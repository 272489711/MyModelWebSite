using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Data;

namespace WebModel.Handler
{
    /// <summary>
    /// AdminHelper_ResetAdmin 的摘要说明
    /// </summary>
    public class AdminHelper_ResetAdmin : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string userName = context.Request[Constants.UserName];
            string userPass = context.Request[Constants.UserPass];
            if(!String.IsNullOrEmpty(userName)&&!String.IsNullOrEmpty(userPass))
            {
                try
                {
                    DataTable dt = SqlHelper.ExcuteTable(String.Format("select * from Users where UserName = '{0}'", userName));
                    if (dt == null)
                    {
                        SqlHelper.ExcuteNoQuery("insert into Users values(@UserName,@UserPass,'','','')", new SqlParameter[] { new SqlParameter("UserName", userName), new SqlParameter("UserPass",Encription.MD5Encrypt( userPass)) });
                    }
                    else
                    {
                        dt.Rows[0].BeginEdit();
                        dt.Rows[0]["UserPass"] = Encription.MD5Encrypt(userPass);
                        dt.Rows[0].EndEdit();
                        SqlHelper.UpdateTable(dt, "Users");
                    }
                }catch(Exception ex)
                {
                    context.Response.Write(ex.ToString());
                    return;
                }
                context.Response.Write(userName + "账户重置成功！");
                return;
            }
            context.Response.Write("重置账户参数不正确！");
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}