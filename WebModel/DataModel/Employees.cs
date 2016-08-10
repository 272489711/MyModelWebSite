using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebModel
{
        /// <summary>
        /// Employees:实体类(属性说明自动提取数据库字段的描述信息)
        /// </summary>
        [Serializable]
        public partial class Employees
        {
            public Employees()
            { }
            #region Model
            private int _employeeid;
            private string _employeename;
            private bool _sex;
            private int? _departmentid;
            private DateTime? _jointime;
            private string _phone;
            /// <summary>
            /// 
            /// </summary>
            public int EmployeeID
            {
                set { _employeeid = value; }
                get { return _employeeid; }
            }
            /// <summary>
            /// 
            /// </summary>
            public string EmployeeName
            {
                set { _employeename = value; }
                get { return _employeename; }
            }
            /// <summary>
            /// 
            /// </summary>
            public bool sex
            {
                set { _sex = value; }
                get { return _sex; }
            }
            /// <summary>
            /// 
            /// </summary>
            public int? DepartmentID
            {
                set { _departmentid = value; }
                get { return _departmentid; }
            }
            /// <summary>
            /// 
            /// </summary>
            public DateTime? JoinTime
            {
                set { _jointime = value; }
                get { return _jointime; }
            }
            /// <summary>
            /// 
            /// </summary>
            public string Phone
            {
                set { _phone = value; }
                get { return _phone; }
            }
            #endregion Model

        }
    }