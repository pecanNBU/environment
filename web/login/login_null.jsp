<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<html>
<head>
    <script type="text/javascript">
        window.top.location.href = "<%=basePath%>login/login.jsp?i=admin";
        //alert(5);
        //alert('未登录或登录已超时，请重新登录！');
        /* $.post(
         "logins.action?j_username='admin'&j_password='admin'"	,
         {"j_username":"admin"}
         ); */
        <%-- if(navigator.userAgent.indexOf("MSIE")>0) 		//IE浏览器
            window.top.location.href="<%=basePath%>login/logins.action?j_username=1111&j_password=1111";
        else if(isFirefox=navigator.userAgent.indexOf("Firefox")>0) 	//火狐浏览器
            window.top.location.href="<%=basePath%>login/logins.action?j_username=11111&j_password=11111";
        else					//其他的，比如谷歌浏览器
            window.top.location.href="<%=basePath%>login/logins.action?j_username=111111&j_password=111111"; --%>
    </script>
</head>
</html>