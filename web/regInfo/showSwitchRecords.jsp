<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>设备控制记录</title>
    <script type="text/javascript" src="../js/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../js/My97DatePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <link href="../css/style.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript">
        var url = "json_switchRecords.action";
        var url1 = url;
        var urlCond = 0;	//查询条件，可供导出时使用
        var mapSwitchs = new Map();		//采集节点-设备控制
        $(function () {
            jsons(1, 50, url);	//默认为第一页，每页50条数据
            doback();
        });
        function doback() {	//加载完数据后填充搜索框里的内容
            $.ajax({
                type: "post",
                dataType: "json",
                url: "json_switchRecordQuey",
                success: function callBack(data) {
                    var mapDatas = data.map;
                    if (mapDatas != null) {
                        var dataUsers = mapDatas.dataUsers;
                        $("#queryUserId").html("<option value='0'>请选择操作人</option>");
                        $("#queryUserId").append("<option value='-1' style='color:gray'>*自动控制*</option>");
                        for (var i in dataUsers) {
                            $("#queryUserId").append("<option value='" + dataUsers[i].id + "'>" + dataUsers[i].name + "</option>");
                        }
                        var dataSensors = mapDatas.dataSensors;
                        $("#queryRegId").html("<option value='0'>请选择所在区域</option>");
                        for (var i in dataSensors) {	//添加采集节点信息
                            $("#queryRegId").append("<option value='" + dataSensors[i].id + "'>" + dataSensors[i].name + "</option>");
                        }
                        var dataSwitchs = mapDatas.dataSwitchs;
                        if (dataSwitchs != null) {
                            for (var i in dataSwitchs) {
                                mapSwitchs.put(i, dataSwitchs[i]);
                            }
                        }
                        transSwitchDatas();	//更新设备控制信息
                    }
                }
            });
        }
        function query() {
            $("#save_alert").remove();
            beCenter("query");
            $("#detail_bg").show();
            $("#query").show(300);
        }
        function query_done() {	//提交查询
            var queryRegId = $("#queryRegId").val();
            var querySwitchId = $("#querySwitchId").val();
            var queryUserId = $("#queryUserId").val();
            var queryStDt = $.trim($("#queryStDt").val());
            var queryEndDt = $.trim($("#queryEndDt").val());
            urlCond = "?nodeState=${nodeState}&queryRegId=" + queryRegId
                    + "&querySwitchId=" + querySwitchId + "&queryUserId=" + queryUserId
                    + "&queryStDt=" + queryStDt + "&queryEndDt=" + queryEndDt;
            var url_query = "query_switchRecords.action" + urlCond;
            json_query(url_query);
        }
        function getAllDatas() {
            urlCond = 0;
            allDatas();
        }
        function transSwitchDatas() {
            $("#querySwitchId").html("<option value='0'>请选择设备控制</option>");
            var regId = $('#queryRegId').val();
            if (regId == 0)
                return;
            var switchDatas = mapSwitchs.get(regId + "");
            for (var i in switchDatas) {
                $("#querySwitchId").append("<option value='" + switchDatas[i].id + "'>" + switchDatas[i].name + "</option>");
            }
        }
    </script>
</head>
<body>
<div align="left">
    <table id="vv">
        <thead>
        <tr>
            <th width=5%>序号</th>
            <th width=30%>监测名称</th>
            <th width=20%>控制人</th>
            <th width=25%>控制结果</th>
            <th width=20%>控制时间</th>
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
    <a class='aBtn aOut' href='javascript:' onclick="excelOut('switchRecords', urlCond)">导 出</a>
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
                <li><span class="queryLeft">所在区域：</span><select id="queryRegId" style="width:173px" class="inputText"
                                                                onchange="transSwitchDatas()"></select></li>
                <li><span class="queryLeft">设备控制：</span><select id="querySwitchId" style="width:173px"
                                                                class="inputText"></select></li>
                <li><span class="queryLeft">　操作人：</span><select id="queryUserId" style="width:173px"
                                                                class="inputText"></select></li>
                <li><span class="queryLeft">操作时间：</span><input id="queryStDt" Style="width:76px" onclick="WdatePicker()"
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