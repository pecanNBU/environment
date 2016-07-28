<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>各种弹出提示窗</title>
    <style type="text/css">
        #aTitle {
            font-size: 14px;
            text-align: left;
            line-height: 2.3;
            margin: 0 30px;
        }

        #alert {
            display: none;
            position: absolute;
            z-index: 50008;
            border: 0;
            background: url(../img/detail_shadow.png) repeat;
            padding: 1px;
            border-radius: 5px;
        }

        .alerts {
            display: none;
            position: absolute;
            z-index: 50003;
            border: 0;
            background: url(../img/detail_shadow.png) repeat;
            padding: 1px;
        }

        .alert_title {
            width: 410px;
            _width: 410px;
            height: 30px;
            border-bottom: 1px solid #ccc;
            cursor: move;
            background-color: #eaeaea;
            padding: 5px 15px;
            border-top-left-radius: 5px;
            border-top-right-radius: 5px;
        }

        .alert_close {
            cursor: pointer;
            background: url(../img/mail1637cd.png) no-repeat -18px -240px;
            width: 18px;
            height: 18px;
            position: absolute;
            border-radius: 2px;
            right: 16px;
            top: 12px
        }

        .alert_close:hover {
            background-position: -54px -240px
        }

        .alert_header {
            float: left;
            font-size: 12px;
            font-weight: bold;
            color: #333;
            line-height: 30px;
        }

        .alert_content {
            padding: 28px 20px 32px 20px;
            width: 400px;
        }

        .alert_operate {
            padding: 5px 12px;
            border-top: 1px solid #ccc;
            line-height: 25px;
            text-align: right;
            background-color: #eaeaea;
            border-bottom-left-radius: 5px;
            border-bottom-right-radius: 5px;
        }

        .dialog_icon {
            width: 32px;
            height: 32px;
            background: url(../img/prompt104472.png) no-repeat -96px 0;
            float: left;
            margin-left: 30px;
            margin-right: 20px;
        }

        .btn_11, .btn_22, .btn_33 {
            width: 70px;
            height: 25px;
            margin-left: 5px;
            padding: 6px 8px;
            cursor: pointer;
            display: inline-block;
            text-align: right;
            *text-align: center;
            line-height: 1;
            *padding: 4px 10px;
            letter-spacing: 9px;
            font-family: Tahoma, Arial/ 9 !important;
            overflow: visible;
            color: #333;
            border: solid 1px #999;
            border-radius: 5px;
            background: #DDD;
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#FFFFFF',
            endColorstr='#DDDDDD');
            background: linear-gradient(top, #FFF, #DDD);
            background: -moz-linear-gradient(top, #FFF, #DDD);
            background: -webkit-gradient(linear, 0% 0%, 0% 100%, from(#FFF),
            to(#DDD));
            text-shadow: 0px 1px 1px rgba(255, 255, 255, 1);
            box-shadow: 0 1px 0 rgba(255, 255, 255, .7), 0 -1px 0 rgba(0, 0, 0, .09);
            -moz-transition: -moz-box-shadow linear .2s;
            -webkit-transition: -webkit-box-shadow linear .2s;
            transition: box-shadow linear .2s;
        }

        .btn_33::-moz-focus-inner, .btn_11::-moz-focus-inner, .btn_22::-moz-focus-inner {
            border: 0;
            padding: 0;
            margin: 0;
        }

        .btn_33:focus, .btn_11:focus, .btn_22:focus {
            outline: none 0;
            border-color: #426DC9;
            box-shadow: 0 0 8px rgba(66, 109, 201, .9);
        }

        .btn_33:hover, .btn_11:hover, .btn_22:hover {
            color: #000;
            border-color: #666;
        }

        .btn_33:active, .btn_11:active, .btn_22:active {
            border-color: #666;
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#DDDDDD',
            endColorstr='#FFFFFF');
            background: linear-gradient(top, #DDD, #FFF);
            background: -moz-linear-gradient(top, #DDD, #FFF);
            background: -webkit-gradient(linear, 0% 0%, 0% 100%, from(#DDD),
            to(#FFF));
            box-shadow: inset 0 1px 5px rgba(66, 109, 201, .9), inset 0 1px 1em rgba(0, 0, 0, .3);
        }

        .btn_33, .btn_11 {
            color: #FFF;
            border: solid 1px #1c6a9e;
            background: #2288cc;
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#33bbee',
            endColorstr='#2288cc');
            background: linear-gradient(top, #33bbee, #2288cc);
            background: -moz-linear-gradient(top, #33bbee, #2288cc);
            background: -webkit-gradient(linear, 0% 0%, 0% 100%, from(#33bbee),
            to(#2288cc));
            text-shadow: -1px -1px 1px #1c6a9e;
        }

        .btn_33:hover, .btn_11:hover {
            color: #FFF;
            border-color: #0F3A56;
        }

        .btn_33:active, .btn_11:active {
            border-color: #1c6a9e;
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#33bbee',
            endColorstr='#2288cc');
            background: linear-gradient(top, #33bbee, #2288cc);
            background: -moz-linear-gradient(top, #33bbee, #2288cc);
            background: -webkit-gradient(linear, 0% 0%, 0% 100%, from(#33bbee),
            to(#2288cc));
        }
    </style>
</head>
<body>
<div id="alertJsp"
     style="background-color:#f0fcff;min-width:440px;_width:440px;border:1px solid #ccc;border-radius:5px;"
     align="center">
    <div class="alert_title" onmousedown="mouseDownFun('alert')"><span class="alert_header"
                                                                       id="a_title">删除确认</span><span id="a_close"
                                                                                                     class="alert_close"
                                                                                                     onclick="closeDiv('alert')"
                                                                                                     title="关闭"></span>
    </div>
    <div class="alert_content">
        <span class="dialog_icon" id="dialog_icon"></span>
        <div id="aTitle">删除后将无法恢复，您确定要删除吗？</div>
    </div>
    <div class="alert_operate">
        　<input id="alert_update" class="btn_22" flag="done" type="button" onclick="del_done();" value="确定"/>
        　<input id="alert_back" class="btn_11" type="button" onclick="closeDiv('alert')" value="取消"/>
    </div>
</div>
</body>
</html>