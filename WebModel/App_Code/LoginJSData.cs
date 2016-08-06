using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebModel
{
    public enum EnumState{
        登录成功=0,
        验证码错误=1,
        用户不存在=2,
        密码错误=3
    }
    public class LoginJSData
    {
        public EnumState State { get; set; }
        public string Message{get;set;}
    }
}