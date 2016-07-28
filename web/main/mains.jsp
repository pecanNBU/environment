<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="sx" uri="/struts-dojo-tags" %>
<!DOCTYPE HTML>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <title>CPN2025-电缆沟在线监测系统</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <script type="text/javascript" src="js/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="js/page.js"></script>
    <link rel="stylesheet" href="css/style.css" type="text/css"/>
    <script type="text/javascript">
        var mapOpens = new Map();	//记录实时监测页面通过window.open弹出的窗口，以免重复
        var leftRegId = 0;			//标记left页面的regId，约束拖拽功能
        var isFull = false;			//标记是否全屏
        var switchState = true;		//标记开关量状态
        var shSwitch;				//更新开关量后的interval
        var switchIndex;			//手动获取更新结果的次数
        var runState = false;		//标记是否正在通信
        $(function () {
            $("#iframe1").attr("src", "main/main.jsp");
            initNavClass();
            $.ajax({		//获取系统信息
                type: "post",
                dataType: "json",
                url: "system/json_curSystemAbout.action",
                success: function callBack(data) {
                    var map = data.map;
                    document.title = map.name;
                    $("#systemName").html(map.name);
                    $("#systemAbbr").html(map.abbr);
                    $("#systemVersion").html(map.version);
                    $("#systemUpdateDt").html(map.updateDt);
                    $("#systemVersionDesc").html(map.versionDesc);
                    $("#systemCopyright").html(map.copyright);
                    $("#systemFax").html(map.fax);
                    $("#systemEmail").html(map.email);
                    $("#systemWebsite").html(map.website);
                    $("#systemDutyUser").html(map.dutyUserName);
                    $("#systemTelephone").html(map.telephone);
                    $("#divAbout").find(".showTb tr:even").find("td:even").addClass("detailTh");
                    var regExcep = map.regExcep;
                    var regComm = map.regComm;
                    if (regExcep == 1)	//数据异常
                        $("#alarmd").show();
                    //if(regComm==1)
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        });
        function initNavClass() {
            var flagSrc;
            $("#divFunc li").hover(function () {
                if ($(this).hasClass("liMain")) { //一级节点
                    flagSrc = $(this).find("img").attr("flagSrc");
                    $(this).find("img").attr("src", "./img/icon/" + flagSrc + "_hover.png");
                    if ($(this).children("ul.modern-menu").size() > 0) {
                        $(this).addClass("hover1");
                        $(this).children("ul.modern-menu").show();
                    }
                    else
                        $(this).addClass("hover");
                }
                else {
                    $(this).addClass("hover");
                    $(this).find("ul").addClass("iBlock");
                }
            }, function () {
                if ($(this).hasClass("liMain")) { //一级节点
                    flagSrc = $(this).find("img").attr("flagSrc");
                    $(this).find("img").attr("src", "./img/icon/" + flagSrc + ".png");
                    if ($(this).children("ul.modern-menu").size() > 0) {
                        $(this).removeClass("hover1");
                        $(this).children("ul.modern-menu").hide();
                    }
                    else
                        $(this).removeClass("hover");
                }
                else {
                    $(this).removeClass("hover");
                    $(this).find("ul").removeClass("iBlock");
                }
            });
            $("#divFunc li.liTitle").each(function () {   //判断2级节点是否包含子节点,包含则添加向右指示箭头
                if ($(this).children("ul").size() > 0)
                    $(this).addClass("arraw_right");
            });
        }
        function turn(url) {		//页面跳转
            if (url == "loginOut") {	//注销
                if (!confirm("您确定要注销吗？"))
                    return;
                window.top.location.href = "login/exitLogin.action";
            }
            else if (url == "about") {	//关于CPN2025
                beCenter("divAbout");
                $("#detail_bg").show();
                $("#divAbout").show(300);
            }
            else if (url == "help") {	//使用手册
                help();
                //location.href = "system/download.action";
            }
            else if (url != "") {
                leftRegId = 0;
                if (typeof(iframe1.rights.src) == "undefined")	//Object Window
                    iframe1.rights.location = "<%=basePath%>" + url;
                else										//Object HTMLFrameElement
                    iframe1.rights.contentWindow.location = "<%=basePath%>" + url;
            }
        }
        function help() {	//请求下载使用手册
            $("#detail_bg").css("z-index", "50004").show();
            beCenter("dHelp");
            $("#dHelp").show();
            $("#dHelp_error").empty();
            $("#helpPsd").val("").focus();
        }
        function help_commit() {	//权限确认
            var helpPsd = $("#helpPsd").val().trim();
            if (helpPsd == null || helpPsd == "") {
                $("#dHelp_error").html("请输入密码");
                $("#helpPsd").focus();
            }
            else {
                $.ajax({
                    type: "post",
                    dataType: "json",
                    url: "system/json_helpCommit",
                    data: "helpPsd=" + helpPsd,
                    success: function callBack(data) {
                        var flag = data.flag;
                        if (flag == 1) {
                            $("#dHelp_error").html("请核对密码");
                            $("#helpPsd").val("").focus();
                        }
                        else {
                            location.href = "system/download.action?flag=" + flag;
                            $("#detail_bg").css("z-index", "50000").hide();
                            $("#dHelp").hide();
                        }
                    }
                });
            }
        }
        var randomI = 0;
        function success(type, name) {
            randomI = Math.random();
            if ($("#sucpop").css("display") == "block")
                $("#sucpop").css("display", "none");
            if (type == 0)					//操作成功
                $("#sucCon").html("<img src='img/success.png' border='none' align='absmiddle'><span class='conHtml'>" + name + "</span>");
            else if (type == 1)			//操作失败
                $("#sucCon").html("<img src='img/fail.png' border='none' align='absmiddle'><span class='conHtml'>" + name + "</span>");
            $("#sucpop").slideDown();
            setTimeout("sliDown(" + randomI + ",'sucpop')", 2500);
        }
        function sliDown(i, id) {
            if (id == "winpop" || i == randomI)	//核对sliDown是否对应本次操作，防止短期内多次success()引起紊乱
                $("#" + id).slideUp();
        }
        var devc_Page = 1;
        var devc_Size = 50;
        function json_devc(type) {
            alarmed();
        }
        function alarm() {		//警报推送
            if ($("#alarm").is(':hidden'))	//未浏览警报记录，显示警报图标
                $("#alarmd").show();
            else	//正在浏览警报记录，直接刷新
                devc_SizeGo("alarm");
        }
        function alarmed() {		//查看数据异常
            $("#alarmd").hide();
            $("#detail_bg").css("z-index", "50004").show();
            beCenter("waiting");
            $("#waitings").html("加载中，请稍候....");
            $("#waiting").show();
            $.ajax({
                type: "post",
                dataType: "json",
                url: "alarm/json_excepConditions",
                data: "jumpPage=" + devc_Page + "&pageSize=" + devc_Size,
                success: function callBack(data) {
                    var alarms = data.rows;
                    var pageBean = data.pageBean;
                    var achContent = "";
                    for (var i in alarms) {
                        achContent += "<tr>"
                                + "<td align='center' style='width:5%;'></td>"
                                + "<td align='center' style='width:20%;'>" + alarms[i][1] + "</td>"
                                + "<td align='center' style='width:30%;'>" + alarms[i][2] + "</td>"
                                + "<td align='center' style='width:20%;'>" + alarms[i][3] + "</td>"
                                + "<td align='center' style='width:25%;'>" + alarms[i][4] + "</td>"
                                //+"<td align='center' style='width:15%;'>"+alarms[i][6]+"</td>"
                                + "</tr>";
                    }
                    $("#alarm [name='vd2']").html(achContent);
                    devc_pages("alarm", pageBean, 0);
                    var jump = $("#alarm [name='devc_Page']").val();
                    var size = $("#alarm [name='devc_Size']").val();
                    var i = 0;
                    $("#alarm [name='vd2'] tr").each(function () {
                        $(this).find("td:eq(0)").html((jump - 1) * size + i + 1);  //给每行的第一列重写赋值
                        i++;
                    });
                    $("#waiting").hide();
                    $("#detail_bg").css("z-index", "50000");
                    var vWidth = $(document).width();
                    $("#alarm").width(vWidth * 0.8);
                    $("#alarm [name='devc_p']").animate({scrollTop: 0}, 200);
                    beCenter("alarm");
                    $("#alarm").show();
                    var tWidth = $("#alarm [name='vd2']").width();
                    var cAgent = cUserAgent();
                    if (cAgent == "IE9.0" || cAgent == "IE10.0" || cAgent == "IE11.0") {
                        tWidth = tWidth - parseFloat("1");
                    }
                    else if (cAgent != "IE7.0") {
                        tWidth = tWidth + parseFloat("2");
                    }
                    $("#alarm [name='vd1']").css("width", tWidth);
                }
            });
        }
        function devc_pages(floatDiv, pageBean, type) {			//浮动窗口的分页功能
            var count = pageBean.count;
            var pageCount = pageBean.pageCount;
            var jumpPage = pageBean.page;
            var jumpPage_ = parseInt(jumpPage) - 1;
            var jumpPage__ = parseInt(jumpPage) + 1;
            var pageSize = pageBean.pageSize;
            var pageCountList = pageBean.pageCountList;
            var firstNum = (jumpPage - 1) * pageSize + 1;
            var lastNum = "";
            if (jumpPage == pageCount) {
                lastNum = count;
            } else {
                lastNum = (jumpPage) * pageSize;
            }
            var phtml = "";
            phtml += "<div style='display:inline;float: left;margin-left: 10px;line-height:30px;' id='pageDiv'>";
            phtml += "<SELECT size=1 name='devc_Size' onchange='devc_Go(1,\"" + floatDiv + "\",\"" + type + "\")'>";
            for (var i = 0; i < pageCountList.length; i++) {
                if (pageSize == pageCountList[i])
                    phtml += "<OPTION value=" + pageCountList[i] + " selected>" + pageCountList[i] + "</OPTION>";
                else
                    phtml += "<OPTION value=" + pageCountList[i] + ">" + pageCountList[i] + "</OPTION>";
            }
            phtml += "</SELECT>";
            phtml += "<span> </span>";
            if (parseInt(jumpPage) <= parseInt(1))
                phtml += " <a href='#' style='margin-left:5px;'><img src='img/pagination_first.gif' style='opacity: 0.5;vertical-align: middle;'></a> ";
            else
                phtml += "<a href='javascript:' onclick='devc_Go(1,\"" + floatDiv + "\",\"" + type + "\")' style='margin-left:5px;'><img src='img/pagination_first.gif' style='vertical-align: middle;'></a>";
            if (parseInt(jumpPage) <= parseInt(1))
                phtml += "<a href='#' > <img src='img/pagination_prev.gif' style='opacity: 0.5;vertical-align: middle;'></a> ";
            else
                phtml += " <a href='javascript:' onclick='devc_Go(" + jumpPage_ + ",\"" + floatDiv + "\",\"" + type + "\")'><img src='img/pagination_prev.gif'  style='vertical-align: middle;'></a>";
            phtml += "<span> </span>";
            phtml += " &nbsp;第<SELECT size=1 name='devc_Page' onchange='devc_SizeGo(\"" + floatDiv + "\");'>";
            for (var i = 1; i < pageCount + 1; i++) {
                if (jumpPage == i)
                    phtml += "<OPTION value=" + i + " selected>" + i + "</OPTION>";
                else
                    phtml += "<OPTION value=" + i + ">" + i + "</OPTION>";
            }
            phtml += "</SELECT> 页 ";
            phtml += " 共<b style='color: red'>" + pageCount + "</b>页 ";
            phtml += "<span> </span>";
            if (parseInt(jumpPage) + parseInt(1) > parseInt(pageCount))
                phtml += " <a href='#' style='margin-left:5px;'><img src='img/pagination_next.gif'  style='opacity: 0.5;vertical-align: middle;'></a>";
            else
                phtml += " <a href='javascript:' onclick='devc_Go(" + jumpPage__ + ",\"" + floatDiv + "\",\"" + type + "\")' style='margin-left:5px;'><img src='img/pagination_next.gif'  style='vertical-align: middle;'></a>";
            if (parseInt(jumpPage) + parseInt(1) > parseInt(pageCount))
                phtml += " <a href='#' style='margin-right:5px;'><img src='img/pagination_last.gif'  style='opacity: 0.5;vertical-align: middle;'></a>";
            else
                phtml += " <a href='javascript:'  onclick='devc_Go(" + pageCount + ",\"" + floatDiv + "\",\"" + type + "\")' style='margin-right:5px;'><img src='img/pagination_last.gif'  style='vertical-align: middle;'></a>";
            phtml += "<span> </span>";
            phtml += " <a href='javascript:' onclick='devc_SizeGo(\"" + floatDiv + "\");' style='margin-left:5px;'><img src='img/pagination_load_.png'  style='vertical-align: middle;width:16px;'></a>";
            phtml += "</div><div style='display:inline;float: right;margin-right: 10px;line-height:30px;'>";
            phtml += " 当前显示   <b style='color: red'>" + firstNum + "</b> -  <b style='color: red'>" + lastNum + "</b> 条记录  共 <b style='color: red'>" + count + "</b> 条记录</div> ";
            phtml += "</div>";
            $("#" + floatDiv + " [name='ppages']").html(phtml);
        }
        function imageOver(id) {		//鼠标移过改变按钮的样式
            $("img[name=" + id + "]").attr("src", "img/" + id.split("_")[1] + "_down.png");
        }
        function imageReset(id) {	//鼠标移过改变按钮的样式
            $("img[name=" + id + "]").attr("src", "img/" + id.split("_")[1] + ".png");
        }
        function out() {				//导出本设备的所有异常记录
            location.href = "dev/download_alarms.action";
        }
        function excelOut(url, exts) {				//弹出导出的确认框
            if ($("#divExcelOut").length > 0)		//如果已存在，则remove
                $("#divExcelOut").remove();
            var htmlOut = "<div id='divExcelOut' class='div_alt'>" +
                    "<div class='excelOut'>" +
                    "<p class='pHtml'><img border='0' src='img/excelOut.png'>确认导出吗？</p>" +
                    "<p class='pBtn'>" +
                    "<input class='btn_11' flag='done' type='button' onclick='excelOut_done(\"" + url + "\",\"" + exts + "\");' value='确定' />　" +
                    "<input class='btn_22' flag='done' type='button' onclick='excelOut_cancle();' value='取消' />" +
                    "</p>" +
                    "</div>" +
                    "</div>";
            $(document.body).append(htmlOut);
            $("#divExcelOut").show();
            beCenter("divExcelOut");
        }
        function excelOut_done(url, exts) {
            exts = exts != 0 ? exts : "";
            location.href = "excel/download_" + url + exts;
            excelOut_cancle();
        }
        function excelOut_cancle() {
            $("#divExcelOut").remove();
        }
    </script>
    <style>
        html, body {
            margin: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
        }

        div {
            margin: 0;
        }

        #div1 {
            position: absolute;
            height: 100%;
            width: 100%
        }

        #sucpop {
            margin-top: 60px;
            top: -86px;
            min-width: 240px;
            width: auto;
            height: 80px;
            position: absolute;
            right: 290px;
            background: url(./img/detail_shadow.png) repeat;
            /*padding:1px 6px 6px 6px;*/
            overflow: hidden;
            align: center;
            display: none;
            box-shadow: 0px 3px 26px rgba(0, 0, 0, .9);
            z-index: 50003;
        }

        #sucpop .con {
            width: 100%;
            min-width: 240px;
            height: 80px;
            font: bold 20px \5FAE\8F6F\96C5\9ED1, tahoma;
            line-height: 100px;
            text-align: center;
            background-color: white;
        }

        .conHtml {
            margin-left: 5px;
        }

        #sucCon {
            padding: 0 20px 0 20px;
        }

        .ppa {
            height: 32px;
        }

        #dHelp {
            z-index: 50005;
        }

        #divSceen {
            position: absolute;
            top: 2px;
            right: 4px;
            display: none;
        }

        #divFunc {
            display: inline-block;
            line-height: 31px;
            position: absolute;
            right: 10px;
            top: 6px;
            text-align: left;
        }

        #divFunc ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        #divFunc ul li {
            display: inline-block;
            padding: 0 10px 0 8px;
            font-size: 14px;
            height: 30px;
            color: #69696d;
            cursor: pointer;
        }

        #divFunc ul li img {
            width: 19px;
            float: left;
            margin-top: 6px;
            margin-right: 2px;
        }

        #divFunc ul li.hover {
            color: #44AADD;
        }

        #divFunc ul li.hover1 {
            color: #44AADD;
            background-color: #F3F3F3;
        }

        #divFunc ul.modern-menu {
            list-style: none;
            margin: 0;
            padding: 0;
            width: 110px;
            height: auto;
            font-family: "Arial Narrow", sans-serif;
            font-size: 15px;
            clear: both;
            background-color: #F3F3F3;
            position: absolute;
            display: none;
            margin-top: -1px;
            margin-left: -8px;
        }

        #divFunc ul.modern-menu a {
            color: #69696d;
            text-decoration: none;
        }

        #divFunc ul.modern-menu ul {
            margin-left: 95px;
            margin-top: -33px;
            background-color: #F3F3F3;
        }

        #divFunc ul.modern-menu li {
            position: relative;
            float: none;
            display: block;
            margin-right: 0;
            padding: 2px 15px;
            width: 80px;
        }

        #divFunc ul.modern-menu li.hover {
            background-color: #44AADD;
        }

        #divFunc ul.modern-menu li.hover > a {
            color: #FFF;
        }

        #divFunc ul.modern-menu li ul li {
            width: 120px;
        }

        #divFunc ul.modern-menu li.arraw_right {
            background-image: url("./img/icon/icon_arrow_right.png");
            background-size: 10px;
            background-repeat: no-repeat;
            background-position: 95% 46%;
        }

        #divFunc ul.modern-menu li.arraw_right.hover {
            background-image: url("./img/icon/icon_arrow_right_hover.png");
        }

        .hide {
            display: none;
        }

        .iBlock {
            display: inline-block;
        }
    </style>
</head>
<body>
<div>
    <input type="button" id="btn5" value="alarmed" onclick='alarmed()' style="display:none"/>
</div>
<a href="javascript:alarmed()"><img src="./img/alarm.gif" id="alarmd"
                                    style="position:absolute;z-index:999;top:35px;right:200px;width:50px;border:none;display:none;"></a>
<!-- <a href="javascript:max_min(this)" title="全屏显示" class="max_min"></a> -->
<div id="div1">
    <iframe id="iframe1" name="iframe1" frameborder="0" width="100%" height="100%" scrolling="no"></iframe>
</div>
<div id="sucpop">
    <div class="con"><span id="sucCon"></span></div>
</div>
<div id="detail_bg"></div>
<div id="waiting"><span id="waitings"></span></div>
<div id="alarm" class="div_alt" style="display:none;z-index:50003;position:absolute;border:1px solid gray;">
    <s:include value="showAlarm.jsp"/>
</div>
<div id="divFunc">
    <ul>
        <li class="liMain">
            <img src='./img/icon/icon_system.png' flagSrc="icon_system"><a>系统配置</a>
            <ul class="modern-menu">
                <li class="liTitle"><a href="#"><span>系统管理</span></a>
                    <ul class="hide">
                        <li><a href="#"><span>数据词典</span></a></li>
                        <li><a href="#"><span>模块管理</span></a></li>
                        <li><a href="#"><span>角色管理</span></a></li>
                        <li><a href="#"><span>版本信息</span></a></li>
                        <li><a href="#"><span>数据库管理</span></a></li>
                    </ul>
                </li>
                <li class="liTitle"><a href="#"><span>设备管理</span></a>
                    <ul class="hide">
                        <li><a href="#"><span>设备配置</span></a></li>
                        <li><a href="#"><span>采样周期</span></a></li>
                        <li><a href="#"><span>报警配置</span></a></li>
                        <li><a href="#"><span>推送配置</span></a></li>
                    </ul>
                </li>
                <li class="liTitle"><a href="#"><span>监控管理</span></a>
                    <ul class="hide">
                        <li><a href="#"><span>摄像头配置</span></a></li>
                        <li><a href="#"><span>联动配置</span></a></li>
                    </ul>
                </li>
                <li class="liTitle"><a href="#"><span>运维管理</span></a>
                    <ul class="hide">
                        <li><a href="#"><span>颗粒物在线监测仪</span></a></li>
                        <li><a href="#"><span>噪声在线监测仪</span></a></li>
                        <li><a href="#"><span>其它设备</span></a></li>
                        <li><a href="#"><span>系统检修</span></a></li>
                    </ul>
                </li>
                <li class="liTitle"><a href="#"><span>用户管理</span></a>
                    <ul class="hide">
                        <li><a href="#"><span>人员管理</span></a></li>
                        <li><a href="#"><span>单位管理</span></a></li>
                        <li><a href="#"><span>上级部门</span></a></li>
                        <li><a href="#"><span>本单位管理</span></a></li>
                        <li><a href="#"><span>登录日志</span></a></li>
                    </ul>
                </li>
            </ul>
        </li>
        <li class="liMain"><img src='./img/icon/icon_about.png' flagSrc="icon_about"><a>关于</a></li>
        <li class="liMain"><img src='./img/icon/icon_user.png' flagSrc="icon_user"><a>欢迎您：admin</a></li>
        <li class="liMain"><a>注销</a></li>
    </ul>
</div>
<div id="divAbout" class="div_alt divFloat">
    <div class="divContent" id="divss" style="background-color:#f0fcff;border:1px solid #8AE4DD" align="center">
        <div class="detail_title" onmousedown="mouseDownFun('divAbout')">
            <span class="detail_header">　关于CPN2025</span><span class="detail_close" onclick="closeDiv('divAbout')"
                                                               title="关闭">X</span>
        </div>
        <div class="detail_content detail_m100">
            <table border="0" align="center" cellpadding="0" cellspacing="0">
                <tr id="tr1">
                    <td align="center">
                        <table border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td>
                                    <table class="showTb">
                                        <tr>
                                            <td width="80px">系统名称：</td>
                                            <td style="width:180px" id="systemName"></td>
                                            <td width="80px">版本号：</td>
                                            <td style="width:180px" id="systemVersion"></td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <HR>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>责任人：</td>
                                            <td id="systemDutyUser"></td>
                                            <td>系统简称：</td>
                                            <td id="systemAbbr"></td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <HR>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>版权所有：</td>
                                            <td id="systemCopyright"></td>
                                            <td>电子邮箱：</td>
                                            <td id="systemEmail"></td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <HR>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>联系电话：</td>
                                            <td id="systemTelephone"></td>
                                            <td>公司传真：</td>
                                            <td id="systemFax"></td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <HR>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>公司网站：</td>
                                            <td id="systemWebsite"></td>
                                            <td>更新日期：</td>
                                            <td id="systemUpdateDt"></td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <HR>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>版本说明：</td>
                                            <td colspan="3" id="systemVersionDesc"></td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <HR>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <div class="detail_btn">
            <input value="确定" class="btn_2" type="button" onclick="closeDiv('divAbout');"/>
        </div>
    </div>
</div>
<div id="dHelp" class="div_alt divFloat">
    <div class="divContent" style="background-color:#f0fcff;border:1px solid #8AE4DD" align="center">
        <div class="detail_title" onmousedown="mouseDownFun('dHelp')">
            <span class="detail_header">　权限确认　<span id="dHelp_error" class="red"></span></span><span
                class="detail_close" onclick="closeDiv('dHelp')" title="关闭">X</span>
        </div>
        <div class="detail_content detail_m70">
            <span class="detailTh">密码：</span>
            <input id="helpPsd" class="inputText" type="password" onkeydown="clearHtml('dHelp_error');">
        </div>
        <div class="detail_btn">
            <input value="确定" class="btn_2" type="button" onclick="help_commit();"/>　
            <input value="取消" class="btn_1" type="button" onclick="closeDiv('dHelp');"/>
        </div>
    </div>
</div>
</body>
</html>