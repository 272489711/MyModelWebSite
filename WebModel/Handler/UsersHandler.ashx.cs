using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;

namespace WebModel.Handler
{
    /// <summary>
    /// UsersHandler 的摘要说明
    /// </summary>
    public class UsersHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            if(context.Request["Query"]!= null)
            {
                Query(context);
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

        public void Query(HttpContext Context)
        {
            Context.Response.ContentType = "text/plain;charset=UTF-8";
            string UserName, StartTime, EndTime, Right;
            UserName = StartTime = EndTime = Right = "";
            //获取查询条件:【用户名,开始时间，结束时间，权限】 
            if (null != Context.Request.QueryString["UserName"])
            {
                UserName = Context.Request.QueryString["UserName"].ToString().Trim();
            }
            if (null != Context.Request.QueryString["StartTime"])
            {
                StartTime = Context.Request.QueryString["StartTime"].ToString().Trim();
            }
            if (null != Context.Request.QueryString["EndTime"])
            {
                EndTime = Context.Request.QueryString["EndTime"].ToString().Trim();
            }
            if (null != Context.Request.QueryString["Right"])
            {
                Right = Context.Request.QueryString["Right"].ToString().Trim();
            }
            /**********获取分页和排序信息：页大小，页码，排序方式，排序字段**************/
            int pageRows, page;
            pageRows = 10;
            page = 1;
            string order, sort;
            order = sort = "";
            if (null != Context.Request.QueryString["rows"])
            {
                pageRows = int.Parse(Context.Request.QueryString["rows"].ToString().Trim());
            }
            if (null != Context.Request.QueryString["page"])
            {
                page = int.Parse(Context.Request.QueryString["page"].ToString().Trim());
            }
            if (null != Context.Request.QueryString["sort"])
            {
                sort = Context.Request.QueryString["sort"].ToString().Trim();
            }
            if (null != Context.Request.QueryString["order"])
            {
                order = Context.Request.QueryString["order"].ToString().Trim();
            }

            //===================================================================
            //组合查询语句：条件+排序
            StringBuilder strWhere = new StringBuilder();
            if (UserName != "")
            {
                strWhere.AppendFormat(" UserName like '%{0}%' and ", UserName);
            }
            if (Right != "")
            {
                strWhere.AppendFormat(" UserRight like '%{0}%' and ", Right);
            }
            if (StartTime != "")
            {
                strWhere.AppendFormat(" CreateDate >= '{0}' and ", StartTime);
            }
            if (EndTime != "")
            {
                strWhere.AppendFormat(" CreateDate <= '{0}' and ", EndTime);
            }

            int startindex = strWhere.ToString().LastIndexOf("and");//获取最后一个and的位置
            if (startindex >= 0)
            {
                strWhere.Remove(startindex, 3);//删除多余的and关键字
            }
            if (sort != "" && order != "")
            {
                order = sort + " " + order;
            }
            //DataSet ds = Bnotice.GetList(strWhere.ToString());  //调用不分页的getlist

            //调用分页的GetList方法
            string strJson = UserBLL.GetJSListByPage(strWhere.ToString(), order, (page - 1) * pageRows + 1, page * pageRows);
            Context.Response.Write(strJson);//返回给前台页面
            Context.Response.End();



        }

    }
}