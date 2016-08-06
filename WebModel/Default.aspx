<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultMaster.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WebModel.Default"   %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="Scripts/MenuData.js" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <%-- easyui-layout总布局 --%>
    <div class="easyui-layout" style="overflow-y: hidden;min-height:600px;width:100%;height:100%"  scroll="no">
        <%-- 上方导航栏和logo以及登录状态 --%>
        <div region="north" split ="true"  class="top-navibar">
            <img class =" top-navibar-logo" src="Images/logo.png" alt="logo"/>
            <div class="top-navibar-login">
                <div class ="datetimeDisplay">

                </div>
                <div class="unlogin">
                    <span style="color: wheat;">你好，你还没有</span><a class="login" href="javascript:void(0);"><span>登录</span></a><span style="color: wheat;">！</span>
                    <!--<a class="login" href="javascript:void(0);"><span>登录</span></a>-->

                    <!--<a class="register" href="javascript:void(0);"><span>注册</span></a>-->
                </div>
                <div class="logined" style="display:none;">
                    <a class="account" href="javascript:void(0);"><span></span></a>
                    <a class="resign" href="javascript:void(0);"><span>注销</span></a>
                </div>
            </div>
            <ul class="top-navibar-menu">
                <li class="item">
                    <a  href="javascript:void(0);" ref="0">菜单一</a>
                </li>
                <li class="item">
                    <a  href="javascript:void(0);" ref="1">菜单二</a>
                </li>
                <li class="item">
                    <a  href="javascript:void(0);" ref="2">菜单三</a>
                </li>
                <li class="item">
                    <a href="javascript:void(0);" ref="3">菜单四</a>
                </li>
                <li class="item">
                    <a href="javascript:void(0);" ref="4">菜单五</a>
                </li>
            </ul>
        </div>
        <%-- 左方子导航栏 --%>
        <div region="west" split="true" class="left-navi" collapsed="true"   title="导航栏" style="width:15%;max-width:200px" >
		    <div id="subMenu" class="easyui-accordion" fit="true" border="false" ></div>
	    </div>
        <%-- 中间tabs页面框 --%>
	    <div id="content" region="center" >
            <div id ="contentTabs" class="easyui-tabs" fit="true" border="false" pill="true"></div>
	    </div>

        <%-- 底部脚注 --%>
        <div region="south" split="true"  class="bottom-foot" scroll="no">
            <div class ="footer-bottom"><a href="javasctipt:void(0)">关于</a><a href="javascript:void(0)">联系我们</a><span style="font-family:SansSerif">©</span>2002-2016<a href="javascript:void(0)">LYH</a>保留所有权利<a href="http://www.miitbeian.gov.cn" target="_blank">粤ICP备XXXXXXX号</a></div>
        </div>
    </div>
   


    <%-- 登录窗口 --%>
    <div class="easyui-window" id="windowLogin" title="登录" style="width:300px;height:260px;padding:5px" 
        collapsible="false" minimizable="false" maximizable="false" closable="false" resizable="false"  shadow="true" modal="true" closed="true" >

        <table style="margin: 15px auto; height: 150px">
            <tr>
                <td colspan="2">
                    <div><input id="userName" class="easyui-textbox" iconalign="left" iconcls='icon-man' style="width: 180px; height: 30px" prompt="输入用户名" /></div></td>
            </tr>
            <tr>
                <td colspan="2">
                    <div><input iconcls="icon-lock" type="password" iconalign="left" class="easyui-textbox" prompt="输入用户密码" id="userPass" style="margin: auto; width: 180px; height: 30px" /></div></td>
            </tr>
            <tr>
                <td>
                    <div><input class="easyui-textbox" type="text" id="verifyTxt" prompt="输入验证码" style="width: 80px; height: 30px" /></div></td>
                <td>
                    <img src="#" alt="验证码" id="verifyImg" style="width: 100px;height:30px" /></td>
            </tr>
            <tr>
                <td colspan="2"><label><input id="isRemember" type="checkbox" checked="checked" />自动登录</label></td>
            </tr>
        </table>
			
			
		
        <div style="text-align: center">
            <a id="loginBtn" class="easyui-linkbutton" href="javascript:void(0);" style="width: 100px;">登录</a>
            <a id="cancelBtn" class="easyui-linkbutton" href="javascript:void(0);" style="width: 100px;">取消</a>
        </div>


    </div>


    <%-- tab的右击菜单 --%>
<div id ="mm" class="easyui-menu" style="width:150px">
    <div id ="mm-refresh">刷新</div>
    <div class="menu-sep"></div>
    <div id="mm-close">关闭当前</div>
    <div id ="mm-close-all">全部关闭</div>
    <div class="menu-sep"></div>
    <div id="mm-close-left">关闭左侧页面</div>
    <div id="mm-close-right">关闭右侧页面</div>
    <div id ="mm-close-other">关闭两侧页面</div>
</div>


</asp:Content>

