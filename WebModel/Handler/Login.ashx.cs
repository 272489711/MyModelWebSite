using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Data;
using System.Data.SqlClient;
using System.Text;

namespace WebModel.Handler
{
    /// <summary>
    /// Login 的摘要说明
    /// </summary>
    public class Login : IHttpHandler, System.Web.SessionState.IRequiresSessionState  //要实现session接口
    {
        private int tickToMinSpan = 600000000; //tick的单位是100毫微秒，1秒=1毫微秒*10^9,tick转换为minute的基数；
        public void ProcessRequest(HttpContext context)
        {
            LoginJSData myJson = new LoginJSData();
            JavaScriptSerializer jsSerial = new JavaScriptSerializer();
            string validateCodeInSession = (string)context.Session[Constants.ValidateCode];

            string userName = context.Request.Params["userName"];
            string userPass = context.Request.Params["userPass"];
            string isRemember = context.Request.Params["isRemember"];
            string validateCode = context.Request.Params["verifyTxt"];
            bool isRequestStatus = context.Request.Params["status"] != null ? true : false;
            bool isResign = context.Request.Params["resign"] != null ? true : false;
            string sql="";

            if(isResign)
            {
                if (MySession.UserNameSession != null)
                    MySession.UserNameSession = null;
                if (CookieHelper.GetCookie(Constants.UserInfo) != null)
                    CookieHelper.RemoveCookie(Constants.UserInfo);
                context.Response.Write("OK");
                return;
            }

            if(isRequestStatus)
            {
                if (MySession.UserNameSession == null)
                    context.Response.Write("");
                else
                    context.Response.Write(MySession.UserNameSession);
                return;
            }

            //处理验证码是否已过期
            if(context.Session==null)  
            {
                myJson.State = EnumState.验证码错误;
                myJson.Message = "页面停留过长，验证码已失效！";
                context.Response.Write(jsSerial.Serialize( myJson));
                return;
            }
            //处理验证码是否输入正确
            if (!validateCode.Equals(validateCodeInSession, StringComparison.CurrentCultureIgnoreCase)) 
            {
                myJson.State = EnumState.验证码错误;
                myJson.Message = "验证码错误！";
                context.Response.Write(jsSerial.Serialize( myJson));
                return;
            }
            //检测用户名是否存在或是否处于锁定状态
            sql=String.Format("select * from Users where UserName='{0}'",userName);
            if (!SqlHelper.IsRecordExists(sql))
            {
                myJson.State = EnumState.用户不存在;
                myJson.Message = String.Format("“{0}”用户不存在！", userName);
                context.Response.Write(jsSerial.Serialize(myJson));
                return;
            }
            else
            {
                sql = String.Format("select * from Users where UserName = '{0}'",userName);
                DataTable dt = SqlHelper.ExcuteTable(sql,new SqlParameter("UserName",userName));//
                if ((bool)dt.Rows[0]["IsLock"])
                {
                    if (dt.Rows[0]["LockTime"] != DBNull.Value)
                    {
                        if (DateTime.Now.Ticks / tickToMinSpan - Convert.ToInt32(dt.Rows[0]["LockTime"]) > 30) //tick的单位是100毫微妙
                        {
                            dt.Rows[0].BeginEdit();
                            dt.Rows[0]["IsLock"] = false;
                            dt.Rows[0]["Wrongs"] = 0;
                            dt.Rows[0].EndEdit();
                            SqlHelper.UpdateTable(dt, "Users");
                        }
                        else
                        {
                            myJson.State = EnumState.用户不存在;
                            myJson.Message = String.Format("用户{0}已被锁定30分钟！",userName);
                            context.Response.Write(jsSerial.Serialize(myJson));
                            return;
                        }
                    }
                }
            }


            DataTable dt1;
            sql = String.Format("select * from Users where UserName = '{0}'", userName);
            dt1 = SqlHelper.ExcuteTable(sql,new SqlParameter("UserName",userName));

            sql = String.Format("select * from Users where UserName = '{0}' and UserPass = '{1}'",userName,Encription.MD5Encrypt( userPass));
         
            if (!SqlHelper.IsRecordExists(sql))  //输入账户密码不正确
            {
                int wrongNum = 0;
                wrongNum = dt1.Rows[0]["Wrongs"] == DBNull.Value ? 0 : (int)dt1.Rows[0]["Wrongs"];
                wrongNum++;
                dt1.Rows[0].BeginEdit();
                dt1.Rows[0]["Wrongs"] = wrongNum;
                dt1.Rows[0].EndEdit();
                SqlHelper.UpdateTable(dt1, "Users");

                if (wrongNum >= 5)
                {
                    dt1.Rows[0].BeginEdit();
                    dt1.Rows[0]["IsLock"] = true;
                    dt1.Rows[0]["LockTime"] = DateTime.Now.Ticks / tickToMinSpan;
                    dt1.Rows[0].EndEdit();
                    SqlHelper.UpdateTable(dt1, "Users");
                    myJson.State = EnumState.密码错误;
                    myJson.Message = "密码错误！输入错误已达5次，"+userName+"账户已被锁定！";
                    context.Response.Write(jsSerial.Serialize(myJson));
                    return;
                }
                else
                {

                    myJson.State = EnumState.密码错误;
                    myJson.Message = "密码错误！已累计错误" + wrongNum + "次，输入错误达5次将锁定账户！";
                    context.Response.Write(jsSerial.Serialize(myJson));
                    return;
                }
            }
            else {                           //输入账户密码正确
                dt1.Rows[0].BeginEdit();
                dt1.Rows[0]["Wrongs"] = 0;
                dt1.Rows[0].EndEdit();
                SqlHelper.UpdateTable(dt1, "Users");

                //用cookie记住用户信息
                if(isRemember=="true")
                {
                    if(CookieHelper.GetCookie(Constants.UserInfo)==null)
                    {

                        string pass =  Encription.MD5Encrypt(userName + Encription.MD5Encrypt(userPass));
                        HttpCookie cookie = new HttpCookie(Constants.UserInfo);
                        cookie.Values.Add(Constants.UserName, userName);
                        cookie.Values.Add(Constants.UserPass,pass); //客户端cookie中密码的保密规则：用户名+原密码MD5加密，在对其再一次md5加密
                        cookie.Expires = DateTime.Now.AddMonths(1);
                        CookieHelper.AddCookie(cookie);
                    }
                    else
                    {
                        HttpCookie cookie = CookieHelper.GetCookie(Constants.UserInfo);
                        String pass = Encription.MD5Encrypt(userName + Encription.MD5Encrypt(userPass));
                        if (cookie.Values[Constants.UserName] != userName)
                            CookieHelper.SetCookie(Constants.UserInfo, Constants.UserName, userName, DateTime.Now.AddMonths(1));
                        if (cookie.Values[Constants.UserPass] != pass)
                            CookieHelper.SetCookie(Constants.UserInfo, Constants.UserPass,pass, DateTime.Now.AddMonths(1));
                    }
                }
                else
                {
                    if(CookieHelper.GetCookie(Constants.UserInfo)!=null)
                    {
                        CookieHelper.RemoveCookie(Constants.UserInfo);
                    }
                }

                MySession.UserNameSession = userName;//登录状态记录到session中;
                myJson.State = EnumState.登录成功;
                myJson.Message = userName + "，欢迎您回来！";
                context.Response.Write(jsSerial.Serialize(myJson));
                return;
            }

            

        }

        public bool IsReusable
        {
            get
            {
                return true;
            }
        }
    }
}