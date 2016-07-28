<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>登录日志管理</title>
    <script type="text/javascript" src="../js/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../js/My97DatePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <link href="../css/style.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript">
        var url = "json_logins.action?nodeState=${nodeState}";
        var url1 = url;
        $(function () {
            jsons(1, 50, url);		//默认为第一页，每页50条数据
        });
        function query() {
            beCenter("query");
            $("#detail_bg").show();
            $("#query").show(300);
        }
        function query_done() {				//提交查询
            var queryUserName = $.trim($("#queryUserName").val());
            var queryLoginName = $.trim($("#queryLoginName").val());
            var queryUserTypeId = $("#queryUserTypeId").val();
            var queryStDt = $("#queryStDt").val();
            var queryEndDt = $("#queryEndDt").val();
            var url_query = "query_logins.action?queryUserName=" + encodeURI(encodeURI(queryUserName)) + "&queryLoginName="
                    + encodeURI(encodeURI(queryLoginName)) + "&queryUserTypeId=" + queryUserTypeId
                    + "&queryStDt=" + queryStDt + "&queryEndDt=" + queryEndDt;
            json_query(url_query);
        }
    </script>
</head>
<body>
<div align="left">
    <table id="vv">
        <thead>
        <tr>
            <th width=5%>序号</th>
            <th width=13%>用户名</th>
            <th width=12%>帐号</th>
            <th width=15%>用户类型</th>
            <th width=15%>登录日期</th>
            <th width=15%>登录IP</th>
        </tr>
        </thead>
    </table>
</div>
<div class="h1">
    <table id="v">
        <tbody id="bbsTab">
        </tbody>
    </table>
</div>
<div id="Page">
    <a class='aBtn aEdit' href='javascript:' onclick='query();'>查 询</a>　
    <a class='aBtn aEdit' href='javascript:' onclick='allDatas();'>全 部</a>　
    <div id="pages"></div>
</div>
<div id="detail_bg"></div>
<div id="alert" class="div_alt">
    <s:include value="../main/alert.jsp"/>
</div>
<div id="waiting">
    <span id="waitings"></span>
</div>
<div id="query" class="div_alt">
    <div class="queryBody">
        <div class="detail_title" onmousedown="mouseDownFun('query')"><span class="detail_header">　查询</span><span
                class="detail_close" onclick="closeDiv('query')" title="关闭">X</span></div>
        <div class="queryContent">
            <ul>
                <li><span class="queryLeft">　用户名：</span><input id="queryUserName" Style="width:170px" class="inputText">
                </li>
                <li><span class="queryLeft">登陆账号：</span><input id="queryLoginName" Style="width:170px"
                                                               class="inputText"></li>
                <li><span class="queryLeft">用户类型：</span><s:select id="queryUserTypeId" list="%{rows}" listKey="id"
                                                                  listValue="typeName" headerKey="0"
                                                                  headerValue="所有用户类型" Style="width:170px"
                                                                  theme="simple"/></li>
                <li><span class="queryLeft">登陆日期：</span><input id="queryStDt" Style="width:74px" onclick="WdatePicker()"
                                                               readonly
                                                               onfocus="WdatePicker({minDate:'2013-01-01',maxDate:'#F{$dp.$D(\'queryEndDt\',{d:0});}'})"
                                                               class="inputText">
                    至 <input id="queryEndDt" Style="width:74px" onclick="WdatePicker()" readonly
                             onfocus="WdatePicker({minDate:'#F{$dp.$D(\'queryStDt\',{d:0});}',maxDate:'%y-%M-%d'})"
                             class="inputText">
                </li>
            </ul>
        </div>
        <div class="queryBtn">
            <input value="确定" class="btn_1" type="button" flag="done" onclick="query_done();"/>
            　　<input value="取消" class="btn_2" type="button" onclick="closeDiv('query');"/>
        </div>
    </div>
</div>
</body>
</html>