<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

    <style>
        * {
            overflow: auto;
        }
    </style>
</head>

<frameset rows="41,0,30,*" name="mainFrame" id="mainFrame" frameborder="no" border="0" framespacing="0">
    <frame id="top" name="top" src="top.jsp" framespacing="0" frameborder="0" scrolling="no" noresize="noresize"
           style="border-bottom:none;"/>
    <frame id="hide" name="hide" src="hide" framespacing="0" frameborder="0" scrolling="no" noresize="noresize"/>
    <frame id="nav" name=" nav" src="nav.jsp" framespacing="0" frameborder="0" scrolling="no" noresize="noresize"
           style="border-bottom:none;border-top:none;"/>
    <frame id="content" name="content" src="" framespacing="0" frameborder="0" border="0" marginwidth="0"
           marginheight="0" scrolling="auto" noresize="noresize" style=""/>
</frameset>

<noframes>
    <body>

    <p>此网页使用了框架，但您的浏览器不支持框架。</p>

    </body>
</noframes>

</html>