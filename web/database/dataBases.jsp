<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix='fmt' uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>数据库管理</title>
    <script type="text/javascript" src="../js/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <link type="text/css" rel="stylesheet" href="../css/cssTab.css"/>
    <script type="text/javascript">
        var flag = 0;
        $(function () {
            $("#baseContent > div").hide(); // Initially hide all content
            $("#baseTab a").attr("class", "aNormal");
            $("#baseTab li:first a").addClass("aCurrent");
            $("#baseContent > div:first").fadeIn(); // Show first tab content
            $("#baseTab a").bind("click", function (e) {
                e.preventDefault();
                if ($(this).hasClass("aCurrent")) { //detection for current tab

                }
                else {
                    resetTabs();
                    $(this).addClass("aCurrent"); // Activate this
                    $($(this).attr('name')).fadeIn(); // Show content for current tab
                    if ($("#iframeCover").attr("src") == "") {
                        $("#iframeCover").attr("src", "showDataRecovers");
                    }
                }
            });
            $("#baseTab a").hover(function () {
                if ($(this).attr("class") != "aCurrent")
                    $(this).addClass("aHover");
            }, function () {
                if ($(this).attr("class") != "aCurrent")
                    $(this).removeClass("aHover");
            });
        });
        function resetTabs() {
            $("#baseContent > div").hide(); //Hide all content
            $("#baseTab a").attr("class", "aNormal"); //Reset id's
        }
        function setIHeight() {
            var pHeight = document.documentElement.clientHeight;
            $("#iframeBack").height(pHeight - 36);
            $("#iframeCover").height(pHeight - 36);
        }
        $(window).resize(function () {
            setIHeight();
        });
    </script>
    <style>
        body {
            font: 14px arial, 微软雅黑, 宋体, sans-serif;
            margin: 1px;
            text-align: center;
            overflow: hidden;
        }
    </style>
</head>
<body class="divContent">
<ul id="baseTab" class="tabs">
    <li class='liTag'><a href="#" name="#baseTab1">数据备份管理</a></li>
    <li class='liTag'><a href="#" name="#baseTab2">数据还原记录</a></li>
</ul>
<div id="baseContent" class="tabContent">
    <div id="baseTab1">
        <iframe id="iframeBack" name="iframeBack" src="showDatabases" frameborder="0" width="100%" scrolling="no"
                onload="setIHeight()"></iframe>
    </div>
    <div id="baseTab2">
        <iframe id="iframeCover" name="iframeCover" src="" frameborder="0" width="100%" scrolling="no"
                onload="setIHeight()"></iframe>
    </div>
</div>
</body>
</html>