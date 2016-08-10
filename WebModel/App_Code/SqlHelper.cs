using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace WebModel
{
    public class SqlHelper
    {
        /// <summary>
        /// 读取配置中默认的连接字符串
        /// </summary>
        static readonly string connStr = ConfigurationManager.ConnectionStrings["Default"].ConnectionString;

        #region 1.0 DataTable ExcuteTable(string sql, params SqlParameter[] pars)
        /// <summary>
        /// 执行查询语句，返回一个表
        /// </summary>
        /// <param name="sql">sql语句</param>
        /// <param name="pars">参数数组</param>
        /// <returns></returns>
        public static DataTable ExcuteTable(string sql, params SqlParameter[] pars)
        {
            SqlDataAdapter da = new SqlDataAdapter(sql, connStr);
            if (pars != null)
                da.SelectCommand.Parameters.AddRange(pars);
            DataSet ds = new DataSet();
            da.Fill(ds);
            return ds.Tables[0];
        } 
        #endregion

        #region 2.0 int ExcuteNoQuery(string sql, params SqlParameter[] pars)
        /// <summary>
        /// 执行增删改的方法，返回记录影响行数
        /// </summary>
        /// <param name="sql">sql语句</param>
        /// <param name="pars">参数数组</param>
        /// <returns></returns>
        public static int ExcuteNoQuery(string sql, params SqlParameter[] pars)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(sql, conn);
                if(pars!=null)
                    cmd.Parameters.AddRange(pars);
                return cmd.ExecuteNonQuery();
            }
        } 
        #endregion

        #region 3.0 int ExcuteProc(string procName, params SqlParameter[] pars)
        /// <summary>
        /// 执行存储过程的方法
        /// </summary>
        /// <param name="procName">存储过程名称</param>
        /// <param name="pars">参数数组</param>
        /// <returns></returns>
        public static int ExcuteProc(string procName, params SqlParameter[] pars)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(procName, conn);
                cmd.CommandType = CommandType.StoredProcedure;
                if(pars!=null)
                cmd.Parameters.AddRange(pars);
                return cmd.ExecuteNonQuery();
            }
        } 
        #endregion

        #region 4.0 object ExcuteScalar(string sql, params SqlParameter[] pars)
        /// <summary>
        /// 查询结果集，返回的是首行首列
        /// </summary>
        /// <param name="sql">sql语句</param>
        /// <param name="pars">参数数组</param>
        /// <returns></returns>
        public static object ExcuteScalar(string sql, params SqlParameter[] pars) //调用的时候才判断是什么类型
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(sql, conn);
                if(pars!=null)
                cmd.Parameters.AddRange(pars);
                return cmd.ExecuteScalar();
            }
        } 
        #endregion

        #region 5.0 bool IsRecordExists(string sql)
        /// <summary>
        /// 查询某条记录是否存在，返回true or false
        /// </summary>
        /// <param name="sql">查询记录的sql语句</param>
        /// <returns></returns>
        public static bool IsRecordExists(string sql)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(sql, conn);
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                        return true;
                    else
                        return false;
                }
            }
        } 
        #endregion

        #region 6.0 void UpdateTable(DataTable dt, string tName)
        /// <summary>
        /// 通过修改dataTable来修改对应数据库表
        /// </summary>
        /// <param name="dt">修改过的DataTable</param>
        /// <param name="tName">对应数据库中的表名</param>
        public static void UpdateTable(DataTable dt, string tName)
        {
            using (SqlDataAdapter apt = new SqlDataAdapter("select * from "+tName,connStr))
            {
                
               // apt.SelectCommand = new SqlCommand("select * from " + tName, conn);
                new SqlCommandBuilder(apt); //能够自动生成更新command?
                apt.Update(dt);
            }
        } 
        #endregion

    }

    
}