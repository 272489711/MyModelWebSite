using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Data;

namespace WebModel
{
    public class MySession
    {
        public static string UserNameSession
        {
            get
            {
                if(HttpContext.Current.Session!=null&&HttpContext.Current.Session[Constants.UserName]!=null)
                {
                    return HttpContext.Current.Session[Constants.UserName] as string;
                }
                else
                {
                    HttpCookie cookie = CookieHelper.GetCookie(Constants.UserInfo);
                    if(cookie!=null)
                    {
                        string username = cookie.Values[Constants.UserName];
                        string pass = cookie.Values[Constants.UserPass];
                        if(!string.IsNullOrEmpty(username)&&!string.IsNullOrEmpty(pass))
                        {
                            DataTable dt = SqlHelper.ExcuteTable(String.Format("select * from Users where UserName = '{0}'", username));
                            if(dt.Rows.Count>0)
                            {
                                string truePass =dt.Rows[0][Constants.UserPass] as string;
                                truePass = Encription.MD5Encrypt(username + truePass);
                                if(pass.Equals( truePass))
                                {
                                    HttpContext.Current.Session[Constants.UserName] = username;
                                    return username;
                                }

                            }
                        }
                    }
                    return null;
                }
            }
            set
            {
                if (HttpContext.Current.Session != null)
                    HttpContext.Current.Session[Constants.UserName] = value;
            }
        }
    }
}