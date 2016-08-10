<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EmployeeEdit.aspx.cs" Inherits="WebModel.EmployeeEdit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" style="height:95%">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>

    <script src="Scripts/jquery.min.js" type="text/javascript"></script>
    <script src="Scripts/jquery.easyui.min.js" type="text/javascript"></script>
    <link rel="stylesheet" href="Content/easyui_theme/default/easyui.css" />
    <link rel="stylesheet" href="Content/easyui_theme/icon.css" />



</head>
<body style="height:100%">
    <form id="form1" style="height:100%">
        <%--表格显示区--%>
        <table id="tt" class="easyui-datagrid" fit="true"
            idfield="itemid" pagination="true" data-options="url:'/Handler/EmployeeHandler.ashx?Query=true',pageSize:5, pageList:[5,10,15,20],method:'get',toolbar:'#tb',striped:true" fitcolumns="true">
            <%--striped="true"--%>
            <%-- 表格标题--%>
            <thead>
                <tr>
                    <th data-options="field:'',checkbox:true,resizable:false"></th>
                    <th data-options="field:'EmployeeID',width:20,sortable:true">员工ID</th>
                    <th data-options="field:'EmployeeName',width:30,align:'right',sortable:true">姓名</th>
                    <th data-options="field:'Sex',width:10,align:'right',sortable:true">性别</th>
                    <th data-options="field:'DepartmentName',width:50,sortable:true">所属部门</th>
                    <th data-options="field:'Phone',width:50,sortable:true">联系电话</th>
                    <th data-options="field:'JoinTime',width:50,sortable:true">入职时间</th>
                </tr>
            </thead>
            <%--表格内容--%>
        </table>


        <%--功能区--%>
        <div id="tb" style="padding: 5px; height: auto">
            <%-- 包括添加员工，修改、删除员工 --%>
            <div style="margin-bottom: 5px">
                <a href="javascript:void(0)" onclick="" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">添加</a>
                <a href="javascript:void(0)" onclick=" " class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">编辑</a>
                <a href="javascript:void(0)" onclick="" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true">删除</a>
            </div>
            <%-- 查找员工信息，根据时间、员工姓名 --%>
            <div>
                入职时间从:
           
                <input id="StartTime" class="easyui-datebox" style="width: 100px" />
                到:

                <input id="EndTime" class="easyui-datebox" style="width: 100px" />
                姓名: 

                <input id="EmployeeName" />
                部门：
           
                <input id="Right" />
                <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="">Search</a>
            </div>
        </div>
    </form>
</body>
</html>
