<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserEdit.aspx.cs" Inherits="WebModel.UserEdit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" style="height: 95%">
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




        function Search() {
            var params = {};
            params.StartTime = $("#StartTime").datebox("getValue");
            params.EndTime = $("#EndTime").datebox("getValue");
            params.UserName = document.getElementById("UserName").value;
            params.DepartmentName = document.getElementById("DepartmentName").value;
            $("#tt").datagrid("options").queryParams = params;
            $("#tt").datagrid("reload");
        }




        //添加管理员  
        function newUser() {
            //清空内容  
            $('#fm').form('clear');
            //加载工作人员的姓名和权限  

            $('#dlg').dialog('open').dialog('setTitle', '添加用户');
            document.getElementById("test").value = "add";
        }

        //修改管理员  
        function editUser() {

            var row = $('#tt').datagrid('getSelected');

            if (row == null) {
                $.messager.alert("提示", "请选择要修改的行！", "info");
            }

            //加载工作人员的姓名和权限  
            //loadWorkerNameAndRightName()
            if (row) {

                //获取要修改的字段  
                $('#firstname').val(row.AdminName);
                $('#password').val(row.AdminPassword);
                //$('#adminRightName').val(row.AdminRightName);  
                //$('#adminRightName').combobox('setValue', row.AdminRightName);  
                ////$('#workerName').val(row.WorkerRealName);  
                //$('#workerName').combobox('setValue', row.WorkerRealName);  
                $('#message').val(row.AdminState)
                $('#dlg').dialog('open').dialog('setTitle', '修改用户');
                document.getElementById("test").value = "modify";
                $('#fm').form('load', row);

            }
        }

    </script>


    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body style="height: 100%">
    <form id="form1" style="height: 100%">
        <%--表格显示区--%>
        <table id="tt" class="easyui-datagrid" fit="true"
            idfield="itemid" pagination="true" data-options="url:'/Handler/UsersHandler.ashx?Query=true',pageSize:5, pageList:[5,10,15,20],method:'get',toolbar:'#tb',striped:true" fitcolumns="true">
            <%--striped="true"--%>
            <%-- 表格标题--%>
            <thead>
                <tr>
                    <th data-options="field:'UserID',checkbox:true,resizable:false"></th>
                    <th data-options="field:'UserName',width:100,sortable:true">用户名</th>
                    <th data-options="field:'DepartmentName',width:100,align:'right',sortable:true">所属部门</th>
                    <th data-options="field:'CreateDate',width:80,align:'right',sortable:true">创建时间</th>
                    <th data-options="field:'IsLock',width:50,sortable:true" formatter="formatStatus">账号状态</th>
                </tr>
            </thead>
            <%--表格内容--%>
        </table>


        <%--功能区--%>
        <div id="tb" style="padding: 5px; height: auto">
            <%-- 包括添加用户，修改、删除用户 --%>
            <div style="margin-bottom: 5px">
                <a href="javascript:void(0)" onclick="newUser()" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">添加</a>
                <a href="javascript:void(0)" onclick="editUser() " class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">编辑</a>
                <a href="javascript:void(0)" onclick="removeUser()" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true">删除</a>
            </div>
            <%-- 查找用户信息，根据时间、用户名 --%>
            <div>
                创建时间从:
           
                <input id="StartTime" class="easyui-datebox" style="width: 100px" />
                到:
           
                <input id="EndTime" class="easyui-datebox" style="width: 100px" />
                用户名: 
           
                <input id="UserName" />
                部门：
           
                <input id="DepartmentName" />
                <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="Search()">Search</a>
            </div>
        </div>
    </form>

</body>

</html>
<%-- 弹出操作框--%>  
<div id="dlg" class="easyui-dialog" style="width: 400px; height: auto; padding: 10px 20px"
    data-options="closed:true,buttons:'#dlg-buttons'">
    <%--closed="true" buttons="#dlg-buttons"--%>
    <div class="ftitle">账号信息</div>
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
