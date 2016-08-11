<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EmployeeEdit.aspx.cs" Inherits="WebModel.EmployeeEdit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" style="height:95%">
<head runat="server">
    <!--基础js-->
    <script src="Scripts/jquery.min.js" type="text/javascript"></script>
    <script src="Scripts/jquery.easyui.min.js" type="text/javascript"></script>
    <link rel="stylesheet" href="Content/easyui_theme/default/easyui.css" />
    <link rel="stylesheet" href="Content/easyui_theme/icon.css" />

<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body style="height:100%">
    <form id="form1" runat="server" style="height:100%">
     <%--表格显示区--%>
        <table id="tt" class="easyui-datagrid" fit="true"
            idfield="itemid" pagination="true" data-options="url:'/Handler/EmployeeHandler.ashx?Query=true',pageSize:5, pageList:[5,10,15,20],method:'get',toolbar:'#tb',striped:true" fitcolumns="true">
            <%--striped="true"--%>
            <%-- 表格标题--%>
            <thead>
                <tr>
                    <th data-options="field:'EmployeeCheck',checkbox:true,resizable:false"></th>
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
           
                <input id="DepartmentName" />
                <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="">Search</a>
            </div>
        </div>
    </form>
</body>
</html>
<%-- 弹出操作框--%>  
<div id="dlg" class="easyui-dialog" style="width: 400px; height: auto; padding: 10px 20px"
    data-options="closed:true,buttons:'#dlg-buttons'">
    <%--closed="true" buttons="#dlg-buttons"--%>
    <div class="ftitle">信息</div>
    <form id="fm" method="post">
        <div class="fitem">
            <label>用户名：</label>&nbsp;  
             <input id="firstname" name="firstname" class="easyui-validatebox" data-options="required:true" />
        </div>
        <div class="fitem">
            <label>密码：</label>&nbsp;&nbsp;  
             <input id="password" name="password" class="easyui-validatebox" data-options="required:true" />
            <input name="Test" id="test" type="hidden" />
            <input name="AdminID" id="AdminID" type="hidden" />
            <input id="key" name="key" onkeydown="if(event.keyCode==13)reloadgrid()" type="hidden" />
        </div>
        <div class="fitem">
            <label>员工姓名:</label>
            <input id="workerName" name="workerName" class="easyui-combobox" />
        </div>
        <div class="fitem">
            <label>权限:</label>&nbsp;&nbsp;  
             <input id="adminRightName" name="adminRightName" class="easyui-combobox" />
        </div>

        <div class="fitem">
            <label>备注:</label>&nbsp;&nbsp;  
             <textarea id="message" name="message" style="width: 150px;"></textarea>
        </div>
    </form>
</div>
<div id="dlg-buttons">
    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="saveUser()">保存</a>
    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="javascript:$('#dlg').dialog('close')">关闭</a>
</div>