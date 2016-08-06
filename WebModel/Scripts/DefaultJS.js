$(function () {
    $(".top-navibar-menu a").each(function (index, item) {  
        this.text = _menu[index].menuName;
    }); //load the main menuName data from MenuData.js

    //=====================add the main menu click function================
    $(".top-navibar-menu a").click(function () {
        if (this.className.indexOf("active") >= 0)
            return;
        $(".top-navibar-menu a").removeClass("active");
        $(this).addClass("active");
        var index = $(this).attr("ref");
        $(".left-navi").panel({ "title": _menu[index].menuName });
        $(".easyui-layout").layout('expand','west');
        var subMenus = _menu[index].subMenus;
        InitialLeftNavi(subMenus);


    });
    //=====================================================================

    $("a.login").click(function () {
        
        load("加载中。。。");
        RefreshValidateCode();
        setTimeout(disLoad,500);
        setTimeout(function () { $("#windowLogin").window('open'); }, 500);
        $('#verifyImg').click(RefreshValidateCode);
    });
    $("a.resign").click(function () {
        if (!window.confirm("确认登出账户？"))
        {
            return false;
        }
        delCookie("UserInfo");
        $.post("/Handler/Login.ashx", { resign: "out" }, function (obj) { if (obj === "OK") msgShow("系统提醒", "你的账户已安全登出！", "info");});
        $(".unlogin").css('display', '');
        $(".logined").css('display', 'none');
    })

    $(".datetimeDisplay").text(getMyDate());//display the datetime on the website top

    InitialMenuClick();
    
    InitialLoginWindow();

    GetLoginStatus();

});
//get the login status from sever
function GetLoginStatus()
{
    $.post("/Handler/Login.ashx", { status: "get" }, function (obj) {
        if (obj) {
            $(".unlogin").css('display', 'none');
            $(".logined").css('display', '');
            $(".account").children("span").text(obj);
        }
        else
        {
            $(".unlogin").css('display', '');
            $(".logined").css('display', 'none');
        }

    });

}

function RefreshValidateCode() {
    $('#verifyImg').attr("src","/Handler/VerifyCode.ashx?random=" + Math.random());
}

function InitialLeftNavi(obj)
{
    //------------------clear navi--------------------
    if (($('#subMenu').attr("class"))) {
        var pp = $('#subMenu').accordion('panels');

        $.each(pp, function (i, n) {
            if (n) {
                var t = n.panel('options').title;
                $('#subMenu').accordion('remove', t);
            }
        });
        $.each(pp, function (i, n) {              //???????
            if (n) {
                var t = n.panel('options').title;
                $('#subMenu').accordion('remove', t);
            }
        });

        
    }
    
    //---------------------------------------------------


    //--------------------------add navi---------------------
    $.each(obj,function (menuIndex,menu) {
        var menuList = "";
        menuList += '<ul>';
        $.each(menu.items, function (itemIndex, item) {
            menuList += '<li><a rel="' + item.url + '" href="#"><span class="' + item.icon + '"></span><div><span class ="nav">' + item.itemName + '</span></div></li>';
        });
        menuList += '</ul>';
        $("#subMenu").accordion("add", {
            title: menu.subMenuName,
            iconCls: menu.icon,
            content: menuList,
            selected: false
        });
    });
    //------------------------------------------------------


    //-------------------------add navi subMenu click function-------------------
    $("#subMenu ul li").on("click",'a',function () {
        var tabTitle = $(this).find('.nav').text();
        var tabIcon = $(this).find('.nav').prev().attr("class");
        var tabUrl = $(this).attr('rel');
        
        var animateDiv = $(this).children('div');
        $("#subMenu ul li a div").removeClass();
        animateDiv.addClass("animated bounce");
        setTimeout(function () { animateDiv.removeClass(); }, 700);
        AddTab(tabTitle, tabUrl, tabIcon);
    });
    //---------------------------------------------------------
}

function CreateFrame(url) {
    var s = '<iframe scrolling="auto" frameborder="0"  src="' + url + '" style="width:100%;height:100%;"></iframe>';
    return s;
}

function AddTab(title, url, icon)
{
    if (!($("#contentTabs").tabs('exists', title))) {
        $("#contentTabs").tabs('add', {
            title: title,
            content: CreateFrame(url),
            iconCls: icon,
            closable: true
        })
    } else {
        $("#contentTabs").tabs('select', title);

        //更新tab内容
    }
    InitialContexMenu();
}
 

function InitialContexMenu() {
    //双击关闭tab选项卡
    $(".tabs-inner").dblclick(function () {
        var subtitle = $(this).children(".tabs-closable").text();
        $('#contentTabs').tabs('close', subtitle);
        return false;
    });
    //绑定右键弹出菜单
    $(".tabs-inner").bind('contextmenu', function (e) {
        $("#mm").menu('show', {
            left: e.pageX,
            top: e.pageY

        });
        var subtitle = $(this).children(".tabs-closable").text();
        $('#mm').data("currTab", subtitle);
        $('#contentTabs').tabs('select', subtitle);
        return false;
    });


}

function InitialMenuClick() {
    //刷新
    $("#mm-refresh").click(function () {
        var currTab = $("#contentTabs").tabs('getSelected');
        var url = $((currTab).panel('options').content).attr('src');
        $("#contentTabs").tabs('update', {
            tab: currTab,
            options: {
                content: CreateFrame(url)
            }
        });
        return false;
    });
    //关闭当前
    $("#mm-close").click(function () {
        var tabTitle = $("#mm").data("currTab");
        $("#contentTabs").tabs('close', tabTitle);
        return false;
    });
    //全部关闭
    $("#mm-close-all").click(function () {
        $('.tabs-inner span').each(function (i, n) {
            var t = $(n).text();
            $('#contentTabs').tabs('close', t);
        });
        return false;
    });
    //关闭左侧
    $("#mm-close-left").click(function () {
        var prevTabs = $(".tabs-selected").prevAll();
        if (prevTabs.length == 0) {
            alert("到头了，左侧没有页面了！");
            return false;
        }
        prevTabs.each(function (i, n) {
            var t = $('a:eq(0) span', $(n)).text();
            $("#contentTabs").tabs('close', t);
        });
        return false;

    });
    //关闭右侧
    $("#mm-close-right").click(function () {
        var nextTabs = $(".tabs-selected").nextAll();
        if (nextTabs.length == 0) {
            alert("到尾了，右侧没有页面了！");
            return false;
        }
        nextTabs.each(function (i, n) {
            var t = $('a:eq(0) span', $(n)).text();
            $("#contentTabs").tabs('close', t);
        });
        return false;

    });
    //关闭左右侧页面
    $("#mm-close-other").click(function () {
        var nextTabs = $(".tabs-selected").nextAll();
        var prevTabs = $(".tabs-selected").prevAll();
        if ((nextTabs.length == 0) && (prevTabs.length == 0)) {
            alert("两侧已经没有页面了！");
            return false;
        }
        nextTabs.each(function (i, n) {
            var t = $('a:eq(0) span', $(n)).text();
            $("#contentTabs").tabs('close', t);
        });
        prevTabs.each(function (i, n) {
            var t = $('a:eq(0) span', $(n)).text();
            $("#contentTabs").tabs('close', t);
        });
        return false;
    });

}


function InitialLoginWindow() {
    $("#cancelBtn").click(function() {
        $("#windowLogin").window('close');
    });

    $("#loginBtn").click(function () {
        var username = $("#userName");
        var userpass = $('#userPass');
        var verifytxt = $('#verifyTxt');
        var isremember=document.getElementById("isRemember");
        if (username.val().trim() == '') {
            msgShow('系统提示', '请输入用户名！', 'info');
            $(username).parent('div').addClass("animated shake");
            username.textbox('clear');
            setTimeout(function () { $(username).parent('div').removeClass("animated shake"); }, 800);
            return false;
        }
        if (userpass.val().trim() == '') {
            msgShow('系统提示', '请输入用户密码！', 'info');
            $(userpass).parent('div').addClass("animated shake");
            $(userpass).next().children(".textbox-text").focus();
            userpass.textbox('clear');
            setTimeout(function () { $(userpass).parent('div').removeClass("animated shake"); }, 800);
            return false;
        }
        if (verifytxt.val().trim() == '') {
            msgShow('系统提示', '请输入验证码！', 'info');
            $(verifytxt).parent('div').addClass("animated shake");
            $(verifytxt).textbox('clear');
            setTimeout(function () { $(verifytxt).parent('div').removeClass("animated shake"); }, 800);
            return false;
        }
        load("登录中。。。");
        var timeOut = setTimeout(function ()
        {//超时处理
            disLoad();
            alert("获取信息超时，请检查当前网络状况！");
           
        }, 10000)      //设置10秒超时


        //post请求
        $.post("/Handler/Login.ashx", {
            userName: username.val(),
            userPass: userpass.val(),
            verifyTxt: verifytxt.val(),
            isRemember: isremember.checked==true
        }, function (objstr) {
            disLoad();
            if (timeOut) {
                clearTimeout(timeOut);
                timeOut = null;
            }
            if(typeof objstr =="string")
                var obj = JSON.parse(objstr);
            if (obj.State == 0) {
                msgShow('系统提示', obj.Message, 'info');
                $("#windowLogin").window('close');
                GetLoginStatus();
                //---------------登录成功处理------------------
            }
            else if (obj.State == 1) {
                msgShow('系统提示', obj.Message, 'error');
                $(verifytxt).textbox('clear');
                $(verifytxt).parent('div').addClass("animated shake");
                RefreshValidateCode();
                setTimeout(function () { $(verifytxt).parent('div').removeClass("animated shake"); }, 800);
                return false;
            }
            else if (obj.State == 2) {
                msgShow('系统提示', obj.Message, 'info');
                userpass.textbox('clear');
                verifytxt.textbox('clear');
                $(username).next().children(".textbox-text").focus();
                $(username).parent('div').addClass("animated shake");
                RefreshValidateCode();
                setTimeout(function () { $(username).parent('div').removeClass("animated shake"); }, 800);
                return false;
            }
            else if (obj.State == 3) {
                msgShow('系统提示', obj.Message, 'error');
                verifytxt.textbox('clear');
                userpass.textbox('clear');
                $(userpass).parent('div').addClass("animated shake");
                $(userpass).next().children(".textbox-text").focus();
                RefreshValidateCode();
                setTimeout(function () { $(userpass).parent('div').removeClass("animated shake"); }, 800);
                return false;
            }
            else
            {

                return true;
            }
        });

        //++++++++++++++post end++++++++++++++//

    });
    
}

//弹出加载层
function load(tip) {
    $("<div class=\"datagrid-mask\" ></div>").css({ display: "block", width: "100%", height: $(window).height() }).appendTo("body");
    $("<div class=\"datagrid-mask-msg\" ></div>").html(tip).appendTo("body").css({ display: "block", left: ($(document.body).outerWidth(true) - 190) / 2, top: ($(window).height() - 45) / 2 });
}

//取消加载层  
function disLoad() {
    $(".datagrid-mask").remove();
    $(".datagrid-mask-msg").remove();
}

// 弹出信息窗口 title:标题 msgString:提示信息 msgType:信息类型 [error,info,question,warning]
function msgShow(title, msgString, msgType) {
    //$.messager.alert(title, msgString, msgType);
    $.messager.show({
        title: title,
        msg: msgString,
        timeout: 3800,
        showType: 'show'
    });
}

//delete cookie by cookie name 
function delCookie(name) {
    var exp = new Date();  //当前时间
    exp.setTime(exp.getTime() - 1);
    var cval = getCookie(name);
    if (cval != null) document.cookie = name + "=" + cval + ";expires=" + exp.toGMTString();
}

//get cookie by cookie name
function getCookie(name) {
    var arr, reg = new RegExp("(^| )" + name + "=([^;]*)(;|$)");
    if (arr = document.cookie.match(reg))
        return unescape(arr[2]);
    else
        return null;
}
