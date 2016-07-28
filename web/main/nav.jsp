<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>导航</title>
    <script type="text/javascript" src="../js/jquery-1.6.min.js"></script>
    <SCRIPT type="text/javascript">
        $(function () {
            initNav();
        });
        function initNav() { //初始化导航信息
            $.ajax({
                type: "post",
                dataType: "json",
                url: "./json_nav.action",
                success: function callBack(data) {
                    var map = data.map;
                    var listNavs = map.listNavs;
                    var liNavName = "";
                    //liNavName += "<li><img src='../img/icon/icon_main.png'><a href='javascript:' onclick='transUrl(\"../main/welcome\")'>主页</a></li>";
                    liNavName += "<li><img src='../img/icon/icon_nowData.png'><a href='javascript:' onclick='transUrl(\"../chart/showNowDatas\")'>实时数据</a></li>";
                    liNavName += "<li><img src='../img/icon/icon_monitor.png'><a href='javascript:' onclick='transUrl(\"../main/welcome\")'>视频监控</a></li>";
                    liNavName += "<li><img src='../img/icon/icon_dataAnalysis.png'><a href='javascript:' onclick='transUrl(\"../main/welcome\")'>统计分析</a></li>";
                    liNavName += "<li><img src='../img/icon/icon_alarm.png'><a href='javascript:' onclick='transUrl(\"../main/welcome\")'>报警管理</a></li>";
                    liNavName += "<li><img src='../img/icon/icon_maintain.png'><a href='javascript:' onclick='transUrl(\"../main/welcome\")'>运行维护</a></li>";
                    /*for(var i in listNodeNames){
                     liNavName += "<li><a>"+listNodeNames[i]+"</a></li>";
                     }*/
                    $("#divNav ul").append(liNavName);
                    initNavClass();
                    $("#divNav ul li:first a").click();
                }
            });
        }
        function initNavClass() {
            $("#divNav ul li:first").addClass("clicked");
            $("#divNav ul li").hover(function () {
                $(this).addClass("hover");
            }, function () {
                $(this).removeClass("hover");
            });
            $("#divNav ul li").click(function () {
                $("#divNav ul li").removeClass("clicked");
                $(this).addClass("clicked");
            });
        }
        function transUrl(url) { //跳转工作区的内容
            if (typeof(parent.content.src) == "undefined")	//Object Window
                parent.content.location = url;
            else										//Object HTMLFrameElement
                parent.content.contentWindow.location = url;
        }
    </script>
    <style type="text/css">
        html, body {
            padding: 0;
            margin: 0;
            font-family: arial, 微软雅黑, 宋体, sans-serif;
        }

        #divMain {
            width: 100%;
            height: 30px;
            display: block;
            font-family: lucida Grande, Verdana;
            background-image: -moz-linear-gradient(top, #01C4D8, #00A9BB); /* Firefox */
            background-image: -webkit-gradient(linear, left top, left bottom, color-stop(0, #01C4D8), color-stop(1, #00A9BB)); /* Saf4+, Chrome */
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#01C4D8', endColorstr='#00A9BB', GradientType='0'); /* IE*/
            background: linear-gradient(to bottom, #01C4D8, #00A9BB);
        }

        #divMain a {
            color: white;
            text-decoration: none;
        }

        div {
            display: inline-block;
        }

        ul, li {
            margin: 0;
            padding: 0;
            list-style: none;
        }

        #divNav ul {
            float: left;
        }

        #divNav ul li {
            display: inline-block;
            font-size: 14px;
            float: left;
            padding: 6px 15px 7px 13px;
            cursor: pointer;
        }

        #divNav ul li img {
            width: 16px;
            float: left;
            margin-right: 4px;
            margin-top: 1px;
        }

        #divNav ul li.hover {
            background-color: #00A6B7;
        }

        #divNav ul li.clicked {
            background-color: #DAA300;
        }
    </style>
</head>
<body>
<div id="divMain">
    <div id="divNav">
        <ul></ul>
    </div>
</div>
</body>
</html>