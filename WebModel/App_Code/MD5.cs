using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Security.Cryptography;

namespace WebModel
{
    public class Encription
    {
        public static string MD5Encrypt(string str)
        {
            MD5 md5 = new MD5CryptoServiceProvider();
            byte[] result = md5.ComputeHash(System.Text.Encoding.Default.GetBytes(str));
            return RemoveEscapeSymbol( System.Text.Encoding.Default.GetString(result));
        }
        public static string MD5WEB32(string str)
        {
            return System.Web.Security.FormsAuthentication.HashPasswordForStoringInConfigFile(str, "MD5").ToString();
        }

        private static string RemoveEscapeSymbol(string str)
        {
            return str.Replace("\a", "\\a").Replace("\n", "\\n").Replace("\b", "\\b").Replace("\t", "\\t").Replace("\f", "\\f").Replace("\v", "\\v").Replace("\r","\\r");
        }
    }
}