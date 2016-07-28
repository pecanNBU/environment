<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>设备调试</title>
    <script type="text/javascript" src="../js/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../js/My97DatePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <link href="../css/style.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript">
        var debugId;
        var url = "json_devDebugs.action?nodeState=${nodeState}";
        var url1 = url;
        $(function () {
            jsons(1, 50, url);		//默认为第一页，每页50条数据
            var devDebug = ${devDebug};
            if (devDebug == true) //正在调试，禁止添加调试
                $("#startDebug").removeClass("aRed").addClass("aGray").attr("onclick", "dataAlarm(3)");
        });
        function add() {
            $("#div_detail").hide();
            $("#div_save").show();
            clearDetail();
            $("#tr1").hide();
            $("#tr2").show();
            beCenter("detail");
            $("#detail_bg").show();
            $("#detail").show(300);
        }
        function edit(id) {  //结束调试
            $("#div_detail").hide();
            $("#div_save").show();
            clearDetail();
            $.ajax({
                type: "post",
                dataType: "json",
                url: "showDetailDevDebug.action",
                data: "debugId=" + id,
                success: function callBack(data) {
                    var map = data.map;
                    $("#debugId").val(map.debugId);
                    $("#debugNote1").val(map.debugNote);
                    $("#debugResult1").val(map.debugResult);
                    $("#tr1").hide();
                    $("#tr2").show();
                    beCenter("detail");
                    $("#detail_bg").show();
                    $("#detail").show(300);
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        }
        function detail(id) {
            $("#div_detail").show();
            $("#div_save").hide();
            $.ajax({
                type: "post",
                dataType: "json",
                url: "showDetailDevDebug.action",
                data: "debugId=" + id,
                success: function callBack(data) {
                    var map = data.map;
                    $("#debugId").val(map.debugId);
                    $("#stDt").html(map.stDt);
                    $("#endDt").html(map.endDt);
                    $("#userName").html(map.userName);
                    $("#debugNote").html(map.debugNote);
                    $("#debugResult").html(map.debugResult);
                    $("#tr1").show();
                    $("#tr2").hide();
                    beCenter("detail");
                    $("#detail_bg").show();
                    $("#detail").show(300);
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        }
        function save() {
            jsons_save(form1);
        }
        function save_suc(data) {			//添加or修改成功后的返回函数
            var flags = data.flag;
            $("#detail").hide();
            if (flags == 1) {
                top.success(1, "操作失败，请重试或联系管理员");
                $("#waiting").hide();
                return false;
            }
            else if (flags == 2) {
                top.success(0, "添加成功");
                $("#startDebug").removeClass("aRed").addClass("aGray").attr("onclick", "dataAlarm(3)");
                var jumpPage = $("#jumpPage").val();
                var pageSize = $("#pageSize").val();
                jsons(jumpPage, pageSize, url);
            }
            else {
                $("#startDebug").removeClass("aGray").addClass("aRed").attr("onclick", "add()");
                var devDebug = data.map;
                var debugId = devDebug.debugId;
                top.success(0, "修改成功");
                var tSort = $("#tr_" + debugId + ">td:eq(0)").html();
                var tHtml = "<td width=5%>" + tSort + "</td>"
                        + "<td width=14%>" + devDebug.stDt + "</td>"
                        + "<td width=14%>" + devDebug.endDt + "</td>"
                        + "<td width=6%>" + devDebug.userName + "</td>"
                        + "<td width=19%>" + devDebug.debugNote + "</td>"
                        + "<td width=19%>" + devDebug.debugResult + "</td>"
                        + "<td width=23%><a class='aBtn aDetail' href='javascript:' onclick='detail(" + debugId + ");'>详细信息</a>　<a class='aBtn aDel' href='javascript:' onclick='del(" + debugId + ");'>删除</a></td>";
                $("#tr_" + debugId).html(tHtml);
                $("#waiting").hide();
                $("#detail_bg").hide().css("z-index", "50000");
            }
        }
        function query() {
            beCenter("query");
            $("#detail_bg").show();
            $("#query").show(300);
        }
        function query_done() {				//提交查询
            var queryVersion = $.trim($("#queryVersion").val());
            var url_query = "query_devDebugs.action?nodeState=${nodeState}&queryVersion=" + queryVersion;
            json_query(url_query);
        }
        function del(id) {
            debugId = id;
            $("#detail_bg").show();
            beCenter("alert");
            $("#alert").show(300);
        }
        function del_done() {
            $("#detail_bg").css("z-index", "50010");
            beCenter("waiting");
            $("#waitings").html("删除中，请稍候....");
            $("#waiting").show();
            $.ajax({
                type: "post",
                dataType: "json",
                url: "removeDevDebug?debugId=" + debugId,
                success: function (data) {
                    var flags = data.flag;
                    $("#alert").hide(300);
                    if (flags == 0) {
                        top.success(0, "删除成功");
                        var jumpPage = $("#jumpPage").val();
                        var pageSize = $("#pageSize").val();
                        jsons(jumpPage, pageSize, url);
                    }
                    else {
                        top.success(1, "删除失败，请重试或联系管理员");
                        $("#detail_bg").hide().css("z-index", "50000");
                        $("#waiting").hide();
                    }
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        }
    </script>
</head>
<body>
<div align="left">
    <table id="vv">
        <thead>
        <tr>
            <th width=5%>序号</th>
            <th width=14%>调试时间</th>
            <th width=14%>结束时间</th>
            <th width=6%>调试人</th>
            <th width=19%>调试原因</th>
            <th width=19%>调试结果</th>
            <th width=23%>更多</th>
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
    <c:if test="${nodeState==1}">
        <a class='aBtn aRed' id="startDebug" href='javascript:' onclick='add();'>开始调试</a>　
    </c:if>
    <a class='aBtn aEdit' href='javascript:' onclick='query();'>查询调试</a>　
    <a class='aBtn aEdit' href='javascript:' onclick='allDatas();'>全部调试</a>
    <div id="pages"></div>
</div>
<div id="detail" class="div_alt">
    <s:include value="showDetailDevDebug.jsp"/>
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
                <li class="queryLeft">版本号：</li>
                <li><input id="queryVersion" Style="width:160px" class="inputText"></li>
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