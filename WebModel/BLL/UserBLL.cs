using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Data;

namespace WebModel
{
    public class UserBLL
    {
        public static DataTable  GetDTListByPage(string strWhere,string order,int startIndex,int endIndex)
        {
            StringBuilder sqlStr = new StringBuilder();
            sqlStr.Append("Select UserID,UserName,CreateDate,IsLock,LockTime,DepartmentName from Users left join Departments on Users.DepartmentID = Departments.DepartmentID ");
            if(!string.IsNullOrEmpty(strWhere))
            {
                sqlStr.Append("where " + strWhere);
            }
            if(!string.IsNullOrEmpty(order))
            {
                sqlStr.Append("order by " + order);
            }
            else
            {
                sqlStr.Append("order by UserName");
            }
            sqlStr.Append(string.Format(" offset {0} rows fetch next {1} rows only", startIndex-1, endIndex));
             return SqlHelper.ExcuteTable(sqlStr.ToString());
        }

        public static string GetJSListByPage(string strWhere,string order,int startIndex,int endIndex)
        {
            DataTable dt = GetDTListByPage(strWhere, order, startIndex, endIndex);
            int total = dt.Rows.Count;
            StringBuilder jsonBuilder = new StringBuilder();
            jsonBuilder.Append("{\"total\":");
            jsonBuilder.Append(total);
            jsonBuilder.Append(",\"rows\":[");
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                jsonBuilder.Append("{");
                for (int j = 0; j < dt.Columns.Count; j++)
                {
                        jsonBuilder.Append("\"");
                        jsonBuilder.Append(dt.Columns[j].ColumnName);
                        jsonBuilder.Append("\":\"");
                        jsonBuilder.Append(dt.Rows[i][j].ToString());
                        jsonBuilder.Append("\",");
                }
                if(dt.Columns.Count>0)
                {
                    jsonBuilder.Remove(jsonBuilder.Length - 1, 1);
                }
                jsonBuilder.Append("},");
            }
            if(dt.Rows.Count>0)
            {
                jsonBuilder.Remove(jsonBuilder.Length - 1, 1);
            }
            jsonBuilder.Append("]}");
            return jsonBuilder.ToString();
        }
    }
}