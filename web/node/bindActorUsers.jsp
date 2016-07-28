<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>关联角色-用户</title>
</head>
<body>
<span id="actorId" style="display:none"></span><span id="typeName" style="display:none"></span>
<div class="divContent" style="background-color:#f0fcff;width:600px;height:420px;border:1px solid #8AE4DD">
    <div class="detail_title" onmousedown="mouseDownFun('Users')"><span class="detail_header"><span id="formTypeName"
                                                                                                    style="color:#387e80"></span></span><span
            class="detail_close" onclick="closeDiv('Users');" title="关闭">X</span></div>
    <br/>
    <div id="sUsers">
        <div style="width:550px;height:284px;margin-left:25px">
            <table id="showUsers" align="left">
            </table>
        </div>
        <br/><br/>
        <c:if test="${nodeState==1}">
            <input value="编辑" class="btn_1" type="button" flag="done" onclick="editUsers();"/>　　
        </c:if>
        <input value="返回" class="btn_2" type="button" onclick="closeDiv('Users');"/>
        <br/><br/>
    </div>
    <div id="bUsers" style="display:none">
        <div style="width:150px;margin-left:50px;float:left;" align="left">
            <span style="color:blue;">未绑定用户：</span><span style="color:gray;">(点击绑定)</span>
        </div>
        <div style="width:150px;margin-left:350px;_margin-left:250px;" align="left">
            <span style="color:blue;">已绑定用户：</span><span style="color:gray;">(点击解绑)</span>
        </div>
        <br/>
        <div style="width:200px;height:250px;background-color:#FFF;border:1px solid #8AE4DD;margin-left:50px;float:left;overflow:auto;"
             align="left">
            <ul id="bindUsers" class="ulSelect"></ul>
        </div>
        <div style="width:200px;height:250px;background-color:#FFF;border:1px solid #8AE4DD;margin-left:350px;_margin-left:300px;overflow:auto;"
             align="left">
            <ul id="unbindUsers" class="ulSelect"></ul>
        </div>
        <br/><br/>
        <input value="保存" class="btn_1" type="button" flag="done" onclick="saveUsers();"/>
        　　<input value="取消" class="btn_2" type="button" onclick="backUsers();"/>
        <br/><br/>
    </div>
</div>
</body>
</html>