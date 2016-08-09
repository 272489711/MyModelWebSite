using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebModel
{
    public class User
    {
        public string UserName { get; set; }
        public string UserPass { set; get; }
        public bool IsLock { set; get; }
        public DateTime CreateTime { get; set; }
    }
}