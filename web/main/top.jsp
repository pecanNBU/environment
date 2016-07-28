<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>top</title>
    <script type="text/javascript" src="../js/jquery-1.6.min.js"></script>
    <script>
        $(function () {
            $.ajax({		//获取系统信息
                type: "post",
                dataType: "json",
                url: "./json_top.action",
                success: function callBack(data) {
                    var map = data.map;
                    $("#spanProjName").html(map.projName);
                    var listNodeNames = map.listNodeNames;
                    /*var liProjName = "";
                     liProjName += "<li><img src='../img/icon/icon_system.png'><a>系统配置</a></li>";
                     liProjName += "<li><img src='../img/icon/icon_about.png'><a>关于</a></li>";
                     liProjName += "<li><img src='../img/icon/icon_user.png'><a>欢迎您：admin</a></li>";
                     liProjName += "<li><a>注销</a></li>";
                     for(var i in listNodeNames){
                     liProjName += "<li><a>"+listNodeNames[i]+"</a></li>";
                     }
                     $("#divFunc ul").append(liProjName);*/
                    //initNavClass();
                }
            });
        });
        function initNavClass() {
            var flagSrc;
            $("#divFunc li").hover(function () {
                if ($(this).hasClass("liMain")) { //一级节点
                    flagSrc = $(this).find("img").attr("flagSrc");
                    $(this).find("img").attr("src", "../img/icon/" + flagSrc + "_hover.png");
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
                    $(this).find("img").attr("src", "../img/icon/" + flagSrc + ".png");
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
        function exit() {
            if (!confirm("您确定要注销吗？")) {
                return;
            }
            window.top.location.href = "../login/exitLogin.action";
        }
    </script>
    <style type="text/css">
        body {
            font-family: arial, 微软雅黑, 宋体, sans-serif;
            margin: 5px 8px;
        }

        ul, li {
            padding: 0;
            margin: 0;
        }

        div {
            display: inline-block;
            line-height: 31px;
        }

        #divTitle img {
            height: 25px;
            float: left;
            margin-top: 2px;
        }

        #spanProjName {
            height: 30px;
            line-height: 32px;
            font-weight: bold;
            margin-left: 20px;
            color: green;
            font-size: 18px;
        }

        #divFunc {
            float: right;
            margin-right: 10px;
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
            background-image: url("../img/icon/icon_arrow_right.png");
            background-size: 10px;
            background-repeat: no-repeat;
            background-position: 95% 46%;
        }

        #divFunc ul.modern-menu li.arraw_right.hover {
            background-image: url("../img/icon/icon_arrow_right_hover.png");
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
<div id="divTitle">
    <img src="../img/logo_lgom.png">
    <span id="spanProjName"></span>
</div>
<!--<div id="divFunc">
    <ul>
        <li class="liMain">
            <img src='../img/icon/icon_system.png' flagSrc="icon_system"><a>系统配置</a>
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
        <li class="liMain"><img src='../img/icon/icon_about.png' flagSrc="icon_about"><a>关于</a></li>
        <li class="liMain"><img src='../img/icon/icon_user.png' flagSrc="icon_user"><a>欢迎您：admin</a></li>
        <li class="liMain"><a>注销</a></li>
    </ul>
</div>-->
</body>
</html>