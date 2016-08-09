<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserProfile.aspx.cs" Inherits="WebModel.UserProfile" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" style="height:95%">
<head runat="server">
    <!--基础js-->
    <script src="Scripts/jquery.min.js" type="text/javascript"></script>
    <script src="Scripts/jquery.easyui.min.js" type="text/javascript"></script>
    <link rel="stylesheet" href="Content/easyui_theme/default/easyui.css" />
    <link rel="stylesheet" href="Content/easyui_theme/icon.css" />
    
    <script type="text/javascript">
        function formatStatus(val, row) {
            var nowMins = (Date.now()) / 60000;
            if (row.IsLock) {
                var span = nowMins - row.LockTime;
                if (span < 31) {
                    return '<span style="color:red;">已锁定(' + parseInt(31 - span) + '分钟后解锁)</span>'
                }
                else
                    return "正常";
            }
            else
                return "正常";
        }


    

        function Search()
        {
            var params = {};
            params.StartTime = $("#StartTime").datebox("getValue");
            params.EndTime = $("#EndTime").datebox("getValue");
            params.UserName = document.getElementById("UserName").value;
            params.Right = document.getElementById("Right").value;
            $("#tt").datagrid("options").queryParams = params;
            $("#tt").datagrid("reload");
        }

        </script>

    
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body style="height:100%">
    <form id="form1" runat="server" style="height:100%">
     <%--表格显示区--%>
    <table id="tt" class="easyui-datagrid"  fit="true"
        idfield="itemid" pagination="true" data-options="iconCls:'icon-save',rownumbers:true,url:'/Handler/UsersHandler.ashx?Query=true',pageSize:5, pageList:[5,10,15,20],method:'get',toolbar:'#tb',striped:true" fitcolumns="true"> <%--striped="true"--%>
        <%-- 表格标题--%>
        <thead>
            <tr>
                <th data-options="field:'UserID',checkbox:true,resizable:false">ID</th>
                <th data-options="field:'UserName',width:100,sortable:true">用户名</th>
                <th data-options="field:'UserRight',width:120,align:'right',sortable:true">权限</th>
                <th data-options="field:'CreateDate',width:80,sortable:true">创建时间</th>
                <th data-options="field:'IsLock',width:40,align:'right',sortable:true" formatter ="formatStatus">状态</th>      
            </tr>
        </thead>
         <%--表格内容--%>
    </table>
        
   
     <%--功能区--%>
    <div id="tb" style="padding: 5px; height: auto">
        <%-- 包括添加管理员，修改、删除管理员 --%>
        <div style="margin-bottom: 5px">
            <a href="javascript:void(0)" onclick="newUser()" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">添加</a>
            <a href="javascript:void(0)" onclick="editUser() " class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">编辑</a>
            <a href="javascript:void(0)" onclick="removeUser()" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true">删除</a>
        </div>
        <%-- 查找管理员信息，根据时间、管理员名 --%>
        <div>
            时间从:
            <input id="StartTime" class ="easyui-datebox" style="width: 100px" />
            到:
            <input id="EndTime" class="easyui-datebox" style="width: 100px" /> 
           管理员名: 
            <input id="UserName"/> 
            按权限：
            <input id="Right" />
            <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="Search()">Search</a>
        </div>
    </div>
    </form>

</body>
</html>
