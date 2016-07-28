<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>数据异常记录</title>
    <script type="text/javascript" src="../js/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../js/My97DatePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <link href="../css/style.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript">
        var url = "json_excepConditions.action";
        var url1 = url;
        var urlCond = 0;	//查询条件，可供导出时使用
        $(function () {
            $('#alarmd', top.document).hide();
            jsons(1, 50, url);	//默认为第一页，每页50条数据
        });
        function query() {
            $("#save_alert").remove();
            beCenter("query");
            $("#detail_bg").show();
            $("#query").show(300);
        }
        function query_done() {	//提交查询
            var queryload = $.trim($("#queryload").val());
            var queryDev = $.trim($("#queryDev").val());
            var queryNode = $.trim($("#queryNode").val());
            var queryStDt = $.trim($("#queryStDt").val());
            var queryEndDt = $.trim($("#queryEndDt").val());
            urlCond = "?nodeState=${nodeState}&queryload=" + encodeURI(encodeURI(queryload))
                    + "&queryDev=" + encodeURI(encodeURI(queryDev)) + "&queryNode=" + encodeURI(encodeURI(queryNode))
                    + "&queryStDt=" + queryStDt + "&queryEndDt=" + queryEndDt;
            var url_query = "query_excepConditions.action" + urlCond;
            json_query(url_query);
        }
        function getAllDatas() {
            urlCond = 0;
            allDatas();
        }
    </script>
</head>
<body>
<div align="left">
    <table id="vv">
        <thead>
        <tr>
            <th width=5%>序号</th>
            <th width=20%>监测时间</th>
            <th width=30%>监测点</th>
            <th width=20%>监测数据</th>
            <th width=25%>警报信息</th>
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
    <a class='aBtn aEdit' href='javascript:' onclick='getAllDatas();'>全 部</a>　
    <a class='aBtn aOut' href='javascript:' onclick="excelOut('regAlarms', urlCond)">导 出</a>
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
                <li><span class="queryLeft">监测路线：</span><input id="queryLoad" Style="width:173px" class="inputText">
                </li>
                <li><span class="queryLeft">　开关柜：</span><input id="queryDev" Style="width:173px" class="inputText"></li>
                <li><span class="queryLeft">监测节点：</span><input id="queryNode" Style="width:173px" class="inputText">
                </li>
                <li><span class="queryLeft">监测时间：</span><input id="queryStDt" Style="width:76px" onclick="WdatePicker()"
                                                               readonly
                                                               onfocus="WdatePicker({minDate:'2015-08-01',maxDate:'#F{$dp.$D(\'queryEndDt\',{d:0});}'})"
                                                               class="inputText">
                    至 <input id="queryEndDt" Style="width:76px" onclick="WdatePicker()" readonly
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