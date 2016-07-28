<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="sx" uri="/struts-dojo-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>编辑个人所在单位信息</title>
    <script type="text/javascript" src="../js/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <link rel="stylesheet" type="text/css" href="../css/button.css"/>
    <link type="text/css" rel="stylesheet" href="../css/cssTab.css"/>
    <script type="text/javascript">
        var flag = 0;
        $(function () {
            $("#depContent > div").hide(); // Initially hide all content
            $("#depTab a").attr("class", "aNormal");
            $("#depTab li:first a").addClass("aCurrent");
            $("#depContent > div:first").fadeIn(); // Show first tab content
            $("#depTab a").bind("click", function (e) {
                e.preventDefault();
                if ($(this).hasClass("aCurrent")) { //detection for current tab

                }
                else {
                    resetTabs();
                    $(this).addClass("aCurrent"); // Activate this
                    $($(this).attr('name')).fadeIn(); // Show content for current tab
                    if ($("#iframeDeps").attr("src") == "") {
                        $("#iframeDeps").attr("src", "showDeps.action");
                    }
                }
            });

            $("#depTab a").hover(function () {
                if ($(this).attr("class") != "aCurrent")
                    $(this).addClass("aHover");
            }, function () {
                if ($(this).attr("class") != "aCurrent")
                    $(this).removeClass("aHover")
            });
        });
        function resetTabs() {
            $("#depContent > div").hide(); //Hide all content
            $("#depTab a").attr("class", "aNormal"); //Reset id's
        }
        function setIHeight(iframe) {
            var pHeight = document.documentElement.clientHeight;
            $(iframe).height(pHeight - 40);
        }
        function back() {
            location.href = "showMyDep.action";
        }
    </script>
    <style>
        body {
            font: 14px arial, 微软雅黑, 宋体, sans-serif;
            margin: 1px;
            text-align: center;
        }

        #tb1 tr {
            height: 35px
        }

        #tb1 input {
            height: 20px;
        }

        #tb1 select {
            height: 25px;
        }

        #detail_bg {
            position: absolute;
            top: 0px;
            left: 0px;
            width: 100%;
            height: 100%;
            z-index: 50002;
            background-color: #000;
            display: none;
            opacity: 0.3;
            filter: alpha(opacity=30);
        }

        #waiting {
            position: absolute;
            z-index: 50015;
            display: none;
            border: 1px solid #8AE4DD;
            min-width: 200px;
            height: 50px;
            line-height: 50px;
            background-color: #f0fcff;
            border-radius: 4px;
            padding: 0 10px;
            text-align: center;
        }

        #waitings {
            background: url(../img/tree_loading.gif) no-repeat;
            padding-left: 20px;
        }

        .inputAlarm {
            border: 2px solid red
        }

        .alarm {
            display: none;
            color: red;
            line-height: 25px;
            _line-height: 25px;
            padding-left: 6px;
            font-size: 13px
        }

        .divContent {
            padding: 0;
            background: #f0fcff; /* 一些不支持背景渐变的浏览器 */
        }

        .mapContent {
            height: 468px;
            background: #f0fcff; /* 一些不支持背景渐变的浏览器 */
            border-bottom-left-radius: 5px;
            border-bottom-right-radius: 5px;
        }

        .div_alt {
            box-shadow: 0px 3px 26px rgba(0, 0, 0, .9);
            background: url(../img/detail_shadow.png) repeat;
            padding: 8px;
            border-radius: 5px;
        }

        .detail_title {
            height: 30px;
            width: 100%;
            border-bottom: 1px solid #8AE4DD;
            cursor: move;
            border-top-left-radius: 5px;
            border-top-right-radius: 5px;
            background-color: #C1E4F0;
            background-image: -moz-linear-gradient(top, #E7F7FA, #C1E4F0); /* Firefox */
            background-image: -webkit-gradient(linear, left top, left bottom, color-stop(0, #E7F7FA), color-stop(1, #C1E4F0)); /* Saf4+, Chrome */
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#E7F7FA', endColorstr='#C1E4F0', GradientType='0'); /* IE*/
            background: linear-gradient(to bottom, #E7F7FA, #C1E4F0);
        }

        .detail_btn {
            margin-bottom: 10px;
        }

        .detail_close {
            float: right;
            margin-right: 14px;
            color: #000;
            cursor: pointer;
            font-size: 16px;
            line-height: 30px
        }

        .detail_header {
            float: left;
            font-size: 14px;
            font-weight: bold;
            color: #333;
            line-height: 30px;
        }
    </style>
</head>
<body class="divContent">
<ul id="depTab" class="tabs">
    <li class='liTag'><a href="#" name="#depTab1">基本信息</a></li>
    <li class='liTag'><a href="#" name="#depTab2">部门信息</a></li>
</ul>
<div id="depContent" class="tabContent">
    <div id="depTab1">
        <iframe id="iframeDep" name="iframeDep" src="editMyDep.action" frameborder="0" width="100%" height="100%"
                onload="setIHeight(this)"></iframe>
    </div>
    <div id="depTab2">
        <iframe id="iframeDeps" name="iframeDeps" src="" frameborder="0" width="100%" height="100%" scrolling="no"
                onload="setIHeight(this)"></iframe>
    </div>
</div>
<div id="detail_bg"></div>
<div id="waiting">
    <span id="waitings"></span>
</div>
</body>
</html>