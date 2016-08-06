<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserProfile.aspx.cs" Inherits="WebModel.UserProfile" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <!--基础js-->
    <script src="Scripts/jquery.min.js" type="text/javascript"></script>
    <script src="Scripts/jquery.easyui.min.js" type="text/javascript"></script>
    <link rel="stylesheet" href="Content/easyui_theme/default/easyui.css" />
    <link rel="stylesheet" href="Content/easyui_theme/icon.css" />
    
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
     <%--表格显示区--%>
    <table id="tt" title="管理员设置" class="easyui-datagrid" style="width: 1024px; height: 400px;"        
        idfield="itemid" pagination="true" data-options="iconCls:'icon-save',rownumbers:true,url:'SetAdmin.ashx/ProcessRequest',pageSize:5, pageList:[5,10,15,20],method:'get',toolbar:'#tb',striped:true" fitcolumns="true"> <%--striped="true"--%>
        <%-- 表格标题--%>
        <thead>
            <tr>
                <th data-options="field:'AdminID',checkbox:true"></th>
                <th data-options="field:'AdminName',width:100">用户名</th>
                <th data-options="field:'AdminPassword',width:120,align:'right'">密码</th>
                <th data-options="field:'AdminRightName',width:120,align:'right'">权限</th>
                <th data-options="field:'ActiveDate',width:100">时间</th>               
            </tr>
        </thead>
         <%--表格内容--%>
    </table>
    <%--功能区--%>
    <div id="tb" style="padding: 5px; height: auto">
        <%-- 包括添加管理员，修改、删除管理员 --%>
        <div style="margin-bottom: 5px">
            <a href="javascript:void(0)" onclick="newUser()" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true"></a>
            <a href="javascript:void(0)" onclick="editUser() " class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true"></a>
            <a href="javascript:void(0)" onclick="removeUser()" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true"></a>
        </div>
        <%-- 查找管理员信息，根据时间、管理员名 --%>
        <div>
            时间从:
            <input id="StartTime" class ="easyui-datebox" style="width: 100px" />
            到:
            <input id="EndTime" class="easyui-datebox" style="width: 100px" /> 
           管理员名: 
            <input id="AdminName"/> 
            按权限：
              <select id="quanxian" class="easyui-combobox" name="state" datatextfield="AdminRightName" datavaluefield="AdminRightName" style="width: 150px;" panelheight="auto"  runat="server">
              </select>
            <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="reloadgrid()">Search</a>
        </div>
    </div>
    </div>
    </form>
</body>
</html>
