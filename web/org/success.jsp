<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE HTML>
<%String ref = request.getHeader("REFERER");%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Insert title here</title>
</head>
<body>
<script type="text/javascript">
    //alert('操作成功');
    window.location = '<%=ref%>';
</script>
</body>
</html>