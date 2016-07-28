<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE HTML>
<%String ref = request.getHeader("REFERER");%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>出错了！！</title>
    <style type="text/css">
        * {
            padding: 0;
            margin: 0;
        }

        .h1 {
            font-size: 18px;
        }
    </style>
</head>
<center><span class="h1">系统出错了！您可以点击查看错误代码或返回上一页</span></center>
<br/> <a href="javascript:" onclick="document.getElementById('show').style.display = 'block'">查看</a> 　　　　
<button onClick="history.go(-2);">&#171;&nbsp;返回</button>
<div id="show" style="display:none">
    <iframe src="parent.location.href"></iframe>
</div>
</body>
</html>