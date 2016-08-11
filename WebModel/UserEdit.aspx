<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserEdit.aspx.cs" Inherits="WebModel.UserEdit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" style="height: 95%">
<head runat="server">
   

    <link rel="stylesheet" type="text/css" href="Content/easyui_theme/default/easyui.css" />
	<link rel="stylesheet" type="text/css" href="Content/easyui_theme/icon.css" />
    <!--基础js-->
	<script src="Scripts/jquery.min.js" type="text/javascript"></script>
	<script type="text/javascript" src="Scripts/jquery.easyui.min.js"></script>
    <script type="text/javascript"  src="Scripts/easyui-lang-zh_CN.js"></script>


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


        $.extend($.fn.validatebox.defaults.rules, {
            confirmPass: {
                validator: function (value, param) {
                    var pass = $(param[0]).passwordbox('getValue');
                    return value == pass;
                },
                message: '两次密码输入不一致！'
            }
        })

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
            //加载部门名称
            loadDepartmentName();

            $('#dlg').dialog('open').dialog('setTitle', '添加用户');
            document.getElementById("OPType").value = "add";
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




        //保存信息
        function saveUser() {

            var firstname = document.getElementById("firstname").value;
            var password = document.getElementById("password").value;
            var workerID = $("#workerName").combobox("getValue");;
            var adminRightID = $("#adminRightName").combobox("getValue");
            var message = document.getElementById("message").value;

            var test = document.getElementById("test").value;

            if (test == "add") {
                $('#fm').form('submit', {
                    url: "SetAdmin.ashx?test=" + test + "&firstname=" + firstname + "&password=" + password + "&workerID=" + workerID + "&adminRightID=" + adminRightID + "&message=" + message,
                    onSubmit: function () {
                        return $(this).form('validate');
                    },
                    success: function (result) {
                        if (result.indexOf("T") == 0) {
                            $('#dlg').dialog('close');
                            $.messager.alert("提示", "恭喜您，信息添加成功", "info");
                            //alert('恭喜您，信息添加成功！')
                            // close the dialog
                            $('#tt').datagrid('reload');
                            //$('#fm').form('submit');

                        }
                        else {
                            $.messager.alert("提示", "添加失败，请重新操作！", "info");
                            return;
                            //alert('添加失败，请重新操作！')
                        }

                        //var result = eval('(' + result + ')');

                        //if (result.success) {
                        //    $('#dlg').dialog('close');		// close the dialog
                        //    $('#tt').datagrid('reload');	// reload the user data
                        //} else {
                        //    $.messager.show({
                        //        title: 'Error',
                        //        msg: result.msg
                        //    });
                        //}
                    }
                });

            } else {
                var row = $('#tt').datagrid('getSelected');
                if (row) {
                    //获取要修改的字段
                    var adminID = row.AdminID;
                }
                $('#fm').form('submit', {
                    url: "SetAdmin.ashx?test=" + test + "&adminID=" + adminID + "&firstname=" + firstname + "&password=" + password + "&workerID=" + workerID + "&adminRightID=" + adminRightID + "&message=" + message,
                    onSubmit: function () {
                        return $(this).form('validate');
                    },
                    success: function (result) {
                        if (result.indexOf("T") == 0) {
                            $('#dlg').dialog('close');
                            $('#tt').datagrid('clearSelections'); //清空选中的行
                            $.messager.alert("提示", "恭喜您，信息修改成功", "info");
                            //alert('恭喜您，信息添加成功！')
                            // close the dialog
                            $('#tt').datagrid('reload');
                            $('#fm').form('submit');

                        }
                        else {
                            $.messager.alert("提示", "修改失败，请重新操作！", "info");
                            return;
                            //alert('添加失败，请重新操作！')
                        }

                        //var result = eval('(' + result + ')');

                        //if (result.success) {
                        //    $('#dlg').dialog('close');		// close the dialog
                        //    $('#tt').datagrid('reload');	// reload the user data
                        //} else {
                        //    $.messager.show({
                        //        title: 'Error',
                        //        msg: result.msg
                        //    });
                        //}
                    }
                });
            }
        }



        //删除管理员
        function removeUser() {
            var test = document.getElementById("test").value = "delete";
            var row = $('#tt').datagrid('getSelected');
            if (row == null) {
                $.messager.alert("提示", "请选择要删除的行！", "info");
            }
            if (row) {
                $.messager.confirm('提示', '你确定要删除这条信息吗？', function (r) {
                    if (r) {
                        $('#fm').form('submit', {
                            url: 'SetAdmin.ashx/ProcessRequest?AdminID=' + row.AdminID + "&test=" + test,
                            onSubmit: function () {
                                //return $(this).form('validate');
                            },
                            success: function (result) {
                                if (result.indexOf("T") == 0) {
                                    $('#dlg').dialog('close');
                                    $('#tt').datagrid('clearSelections'); //清空选中的行
                                    $.messager.alert("提示", "恭喜您，信息删除成功！", "info");
                                    //alert('恭喜您，信息删除成功！')
                                    // close the dialog
                                    $('#tt').datagrid('reload');
                                    $('#fm').form('submit');

                                }
                                else {
                                    $.messager.alert("提示", "添加失败，请重新操作！", "info");
                                    //alert('添加失败，请重新操作！')
                                    return;
                                    //$('#fm').form('submit');
                                }

                            }

                        });
                    }
                })
            }
        }


        //加载部门名称
        function loadDepartmentName() {
            var queryDepartmentName = "/Handler/UsersHandler.ashx?QueryDepartmentName=true";
            $.getJSON(queryDepartmentName, function (json) {
                $('#departmentName').combobox({
                    data: json.rows,
                    valueField: 'DepartmentID',
                    textField: 'DepartmentName',
                    required: 'false',
                    editable: 'false'
                });
            });


        }


    </script>


    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body style="height: 100%">
    <form id="form1" style="height: 100%" runat ="server">
        <%--表格显示区--%>
        <table id="tt" class="easyui-datagrid" fit="true"
            idfield="itemid" pagination="true" data-options="url:'/Handler/UsersHandler.ashx?Query=true',pageSize:5, pageList:[5,10,15,20],method:'get',toolbar:'#tb',striped:true" >
            <%--striped="true"--%>
            <%-- 表格标题--%>
            <thead>
                <tr>
                    <th data-options="field:'UserID',checkbox:true,resizable:false"></th>
                    <th data-options="field:'UserName',width:120,sortable:true">用户名</th>
                    <th data-options="field:'RealName',width:120,sortable:true">姓名</th>
                    <th data-options="field:'Sex',width:50,sortable:true">性别</th>
                    <th data-options="field:'DepartmentName',width:100,align:'right',sortable:true">所属部门</th>
                    <th data-options="field:'JoinTime',width:150,sortable:true">入职时间</th>
                    <th data-options="field:'Phone',width:120,sortable:true">联系电话</th>
                    <th data-options="field:'CreateDate',width:150,align:'right',sortable:true">创建时间</th>
                    <th data-options="field:'IsLock',width:100,sortable:true" formatter="formatStatus">账号状态</th>
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
    <form id="fm" method="post">
            <input name="OPType" id="OPType" type="hidden" />
            <input name="UserID" id="UserID" type="hidden" />
            <div class="fitem" style="margin-bottom: 10px">
                <label style="width:60px;display:inline-block">用户名：</label>
                <input id="username" name="username" class="easyui-textbox easyui-validatebox" data-options="required:true" style=" height: 30px; padding: 5px;"/>
            </div>
            <div style="margin-bottom: 10px">
                <label style="width:60px;display:inline-block">密码：</label>
                <input id="password" name="password" class="easyui-passwordbox easyui-validatebox" data-options="required:true" style=" height: 30px; padding: 5px;" />

                <input id="key" name="key" onkeydown="if(event.keyCode==13)reloadgrid()" type="hidden" />
            </div>
            <div style="margin-bottom: 10px">
                <label style="width:60px;display:inline-block">确认密码：</label>
                <input id="passwordagain" name="passwordgagain" class="easyui-passwordbox easyui-validatebox" data-options="required:true" style=" height: 30px; padding: 5px;" validType="confirmPass['#password']"/>
            </div>
            <div style="margin-bottom: 10px">
                <label style="width:60px;display:inline-block">姓名:</label>
                <input id="realName" name="realName" class="easyui-textbox easyui-validatebox" style=" height: 30px; padding: 5px;" />
            </div>
        <div style="margin-bottom: 10px">
                <label style="width:60px;display:inline-block">性别:</label>
                <input id="sex" name="sex" class="easyui-textbox easyui-validatebox" style=" height: 30px; padding: 5px;" />
            </div>
            <div style="margin-bottom: 10px">
                <label style="width:60px;display:inline-block">联系电话:</label>
                <input id="phone" name="phone" class="easyui-textbox" style=" height: 30px; padding: 5px;" />
            </div>
            <div style="margin-bottom: 10px">
                <label style="width:60px;display:inline-block">所属部门:</label>
                <input id="departmentName" name="departmentName" class="easyui-combobox" style=" height: 30px; padding: 5px;"/>
            </div>

            <div style="margin-bottom: 10px">
                <label style="width:60px;display:inline-block">入职时间:</label>
                <textarea id="joinTime" name="joinTime" class="easyui-datetimebox" style=" height: 30px; padding: 5px;"></textarea>
            </div>
       
    </form>
</div>
<div id="dlg-buttons">
    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="saveUser()">保存</a>
    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="javascript:$('#dlg').dialog('close')">关闭</a>
</div>
