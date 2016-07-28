<%@ page language="java" contentType="text/html; charset=UTF-8" errorPage="/default_error.jsp" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<html>
<head>
    <script type="text/javascript">
        alert('注销成功，并转入登录页面！');
        window.top.location.href = "<%=basePath%>login/login.jsp";
    </script>
</head>
</html>