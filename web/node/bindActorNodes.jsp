<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>关联角色-模块</title>
</head>
<body>
<span id="actorId" style="display:none"></span><span id="actorName" style="display:none"></span>
<div class="divContent" style="background-color:#f0fcff;width:450px;border:1px solid #8AE4DD">
    <div class="detail_title" onmousedown="mouseDownFun('Nodes')"><span class="detail_header"><span id="formActorName"
                                                                                                    style="color:#387e80"></span></span><span
            class="detail_close" onclick="closeDiv('Nodes');" title="关闭">X</span></div>
    <div id="showNodes" class="detail_content" style="text-align:center; margin:5px 0;overflow:auto;height:400px;">
        <ul id="nodesPriv" style="width:120px;float:left;text-align:right;margin-left:0px;"></ul>
        <ul id="treeDemo" class="ztree" style="float:left"></ul>
    </div>
    <div class="detail_btn">
        <c:if test="${nodeState==1}">
            <input value="保存" class="btn_1" type="button" flag="done" onclick="saveNodes();"/>　　　
        </c:if>
        <input value="返回" class="btn_2" type="button" onclick="closeDiv('Nodes');"/>
    </div>
</div>
</body>
</html>