<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Runtime run = Runtime.getRuntime();
    Process pro = run.exec("d:\\tomcat7\\bin\\restart.bat");
%>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>远程重启服务器</title>
    <script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
    <script type="text/javascript">
        //setTimeout("login()",10000);
        function login() {
            alert(lTime);
            //location.href = "../login/login.jsp";
        }
        var lTime = 15;
        function rTime() {
            if (lTime > 0) {
                lTime = lTime - 1;
                $("#rTime").html(lTime);
                setTimeout("rTime()", 1000);
            }
            else
                login();
        }
        rTime();
    </script>
</head>
<body>
服务器正在重启，将在<span id="rTime">15</span>秒后重启成功并跳转至登录页面
</body>
</html>