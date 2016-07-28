<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>点击切换显示/隐藏上下菜单</title>
    <script language="javascript">
        function isShowleft() {
            if (window.parent.mainFrame.rows == "100,30,9,*,20") {
                window.parent.mainFrame.rows = "0,0,9,*,0";
                document.images['imgHidTop'].src = '../img/showtop.gif';
            }
            else {
                window.parent.mainFrame.rows = "100,30,9,*,20";
                document.images['imgHidTop'].src = '../img/hiddetop.gif';
            }
        }
    </script>
    <style>
        html, body {
            margin-left: 0;
        }

        img {
        }
    </style>
</head>
<body>
<div align="center">
    <img id="imgHidTop" src="../img/hiddetop.gif" onclick="isShowleft()"/>
</div>
</body>
</html>