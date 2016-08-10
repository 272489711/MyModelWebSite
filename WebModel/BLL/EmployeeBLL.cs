using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;

namespace WebModel
{

    /// <summary>
    /// 数据访问类:EmployeeBLL
    /// </summary>
    public class EmployeeBLL
    {
        public EmployeeBLL()
        { }
        #region  BasicMethod



        public static DataTable GetDTListByPage(string strWhere, string order, int startIndex, int endIndex)
        {
            StringBuilder sqlStr = new StringBuilder();
            sqlStr.Append("Select EmployeeID,EmployeeName,JoinTime,Employees.DepartmentID,DepartmentName,UserName from Employees left join Departments on Employees.DepartmentID = Departments.DepartmentID left join Users on Users.UserID = Employees.UserID ");
            if (!string.IsNullOrEmpty(strWhere))
            {
                sqlStr.Append("where " + strWhere);
            }
            if (!string.IsNullOrEmpty(order))
            {
                sqlStr.Append("order by " + order);
            }
            else
            {
                sqlStr.Append("order by EmployeeID");
            }
            sqlStr.Append(string.Format(" offset {0} rows fetch next {1} rows only", startIndex - 1, endIndex));
            return SqlHelper.ExcuteTable(sqlStr.ToString());
        }

        public static string GetJSListByPage(string strWhere, string order, int startIndex, int endIndex)
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
                if (dt.Columns.Count > 0)
                {
                    jsonBuilder.Remove(jsonBuilder.Length - 1, 1);
                }
                jsonBuilder.Append("},");
            }
            if (dt.Rows.Count > 0)
            {
                jsonBuilder.Remove(jsonBuilder.Length - 1, 1);
            }
            jsonBuilder.Append("]}");
            return jsonBuilder.ToString();
        }



        /// <summary>
        /// 增加一条数据
        /// </summary>
        public bool Add(Employees model)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("insert into Employees(");
            strSql.Append("EmployeeName,sex,DepartmentID,JoinTime,Phone)");
            strSql.Append(" values (");
            strSql.Append("@EmployeeName,@sex,@DepartmentID,@JoinTime,@Phone)");
            SqlParameter[] parameters = {
					new SqlParameter("@EmployeeName", SqlDbType.VarChar,50),
					new SqlParameter("@sex", SqlDbType.Bit,1),
					new SqlParameter("@DepartmentID", SqlDbType.Int,4),
					new SqlParameter("@JoinTime", SqlDbType.DateTime),
					new SqlParameter("@Phone", SqlDbType.VarChar,20)};
            parameters[0].Value = model.EmployeeName;
            parameters[1].Value = model.sex;
            parameters[2].Value = model.DepartmentID;
            parameters[3].Value = model.JoinTime;
            parameters[4].Value = model.Phone;

            int rows = SqlHelper.ExcuteNoQuery(strSql.ToString(), parameters);
            if (rows > 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }


        /// <summary>
        /// 通过ID删除一条数据
        /// </summary>
        public bool DeleteByID(int EmployeeID)
        {

            StringBuilder strSql = new StringBuilder();
            strSql.Append("delete from Employees ");
            strSql.Append(" where EmployeeID=@EmployeeID");
            SqlParameter[] parameters = {
					new SqlParameter("@EmployeeID", SqlDbType.Int,4)			};
            parameters[0].Value = EmployeeID;

            int rows = SqlHelper.ExcuteNoQuery(strSql.ToString(), parameters);
            if (rows > 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }


        /// <summary>
        /// 得到一个对象实体
        /// </summary>
        public Employees GetModel(int EmployeeID, string EmployeeName, bool sex, int DepartmentID, DateTime JoinTime, string Phone)
        {

            StringBuilder strSql = new StringBuilder();
            strSql.Append("select  top 1 EmployeeName,sex,DepartmentID,JoinTime,Phone from Employees ");
            strSql.Append(" where EmployeeID=@EmployeeID and EmployeeName=@EmployeeName and sex=@sex and DepartmentID=@DepartmentID and JoinTime=@JoinTime and Phone=@Phone ");
            SqlParameter[] parameters = {
					new SqlParameter("@EmployeeID", SqlDbType.Int,4),
					new SqlParameter("@EmployeeName", SqlDbType.VarChar,50),
					new SqlParameter("@sex", SqlDbType.Bit,1),
					new SqlParameter("@DepartmentID", SqlDbType.Int,4),
					new SqlParameter("@JoinTime", SqlDbType.DateTime),
					new SqlParameter("@Phone", SqlDbType.VarChar,20)			};
            parameters[0].Value = EmployeeID;
            parameters[1].Value = EmployeeName;
            parameters[2].Value = sex;
            parameters[3].Value = DepartmentID;
            parameters[4].Value = JoinTime;
            parameters[5].Value = Phone;

            Employees model = new Employees();
            DataTable dt = SqlHelper.ExcuteTable(strSql.ToString(), parameters);
            if (dt.Rows.Count > 0)
            {
                return DataRowToModel(dt.Rows[0]);
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// 通过员工ID得到一个对象实体
        /// </summary>
        public Employees GetModelByID(int EmployeeID)
        {

            StringBuilder strSql = new StringBuilder();
            strSql.Append("select  EmployeeID,EmployeeName,sex,DepartmentID,JoinTime,Phone from Employees ");
            strSql.Append(" where EmployeeID=@EmployeeID");
            SqlParameter[] parameters = {
					new SqlParameter("@EmployeeID", SqlDbType.Int,4)			};
            parameters[0].Value = EmployeeID;

            Employees model = new Employees();
            DataTable dt = SqlHelper.ExcuteTable(strSql.ToString(), parameters);
            if (dt.Rows.Count > 0)
            {
                return DataRowToModel(dt.Rows[0]);
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// 通过姓名得到对象实体(返回的是集合主要是考虑到有同名同姓的情况)
        /// </summary>
        public List<Employees> GetModelByName(string EmployeeName)
        {

            StringBuilder strSql = new StringBuilder();
            strSql.Append("select EmployeeID,EmployeeName,sex,DepartmentID,JoinTime,Phone from Employees ");
            strSql.Append(" where EmployeeName = @EmployeeName");
            SqlParameter[] parameters = {
					new SqlParameter("@EmployeeName", SqlDbType.VarChar,50)};
      
            parameters[1].Value = EmployeeName;
            
            List<Employees> employees = new List<Employees>();
            DataTable dt = SqlHelper.ExcuteTable(strSql.ToString(), parameters);
            for (int i=0;i<dt.Rows.Count;++i)
            {
                employees.Add(DataRowToModel(dt.Rows[i]));
            }
            return employees;
        }


        /// <summary>
        /// 得到一个对象实体
        /// </summary>
        private Employees DataRowToModel(DataRow row)
        {
            Employees model = new Employees();
            if (row != null)
            {
                if (row["EmployeeName"] != null)
                {
                    model.EmployeeName = row["EmployeeName"].ToString();
                }
                if (row["sex"] != null && row["sex"].ToString() != "")
                {
                    if ((row["sex"].ToString() == "1") || (row["sex"].ToString().ToLower() == "true"))
                    {
                        model.sex = true;
                    }
                    else
                    {
                        model.sex = false;
                    }
                }
                if (row["DepartmentID"] != null && row["DepartmentID"].ToString() != "")
                {
                    model.DepartmentID = int.Parse(row["DepartmentID"].ToString());
                }
                if (row["JoinTime"] != null && row["JoinTime"].ToString() != "")
                {
                    model.JoinTime = DateTime.Parse(row["JoinTime"].ToString());
                }
                if (row["Phone"] != null)
                {
                    model.Phone = row["Phone"].ToString();
                }
            }
            return model;
        }

        

        #endregion  BasicMethod
        #region  ExtensionMethod

        #endregion  ExtensionMethod
    }
}
    
