<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <script type="text/javascript" src="../js/jquery-1.6.min.js"></script>
    <title>点击切换显示/隐藏左侧菜单</title>
    <script language="javascript">
        function isShowleft() {
            if (parent.main.cols == "220,10,*") {
                parent.main.cols = "0,10,*";
                $(".pos-a").css({"background-position": "-135px -15px", "left": "-4px"});
            }
            else {
                parent.main.cols = "220,10,*";
                $(".pos-a").css({"background-position": "-120px -15px", "left": "-3px"});
            }
        }
    </script>
    <style>
        body, html {
            height: 100%;
            margin: 0;
            padding: 0;
        }

        .spanTrans {
            background: #bababa;
            width: 8px;
            height: 100%;
            border-right: 1px solid #9d9d9d;
            border-left: 1px solid #a7a7a7;
            cursor: pointer;
            position: relative;
        }

        .spanTrans .pos-a {
            left: -3px;
            background: no-repeat url(../img/mopIcon15x15.png) -120px -15px;
            top: 45%;
            width: 15px;
            height: 15px;
            position: absolute;
        }
    </style>
</head>
<body>
<div class="spanTrans" onclick="isShowleft()" title="点击切换左侧菜单显示/隐藏">
    <i class="pos-a"></i>
</div>
</body>
</html>