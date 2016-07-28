<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="sx" uri="/struts-dojo-tags" %>
<!DOCTYPE HTML>
<html>
<head>
    <title>实时监测列表</title>
    <script type="text/javascript" src="../js/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <link rel="stylesheet" type="text/css" href="../css/style.css"/>
    <script type="text/javascript">
        var regId = request("id");
        var regIds;		//自动刷新时传到后台
        var depId;		//自动刷新时传到后台
        var inter;		//结束Interval的标记
        var period = parseInt("${period}");	//表示刷新间隔
        var dtBet = request("dtBet");		//取之前的数据点个数
        var interType = 0;
        var trDatas;	//页面展示的内容
        var lastDt;		//最新数据刷新时间
        $(function () {
            jsons_table();
            inter = setInterval("getTable()", period);
            if (cUserAgent() == "chrome") {		//谷歌浏览器未知bug
                clearInterval(inter);
                inter = setInterval("getTable()", period);
            }
        });
        function out() {
            excelOut("nowTables", "?regId=" + regId + "&dtBet=" + dtBet);
        }
        function getTable() {	//刷新数据：获取最新数据，加载到表格第一行，删除最后一行
            $.ajax({
                type: "post",
                dataType: "json",
                url: "json_nowTable.action?noteIds=" + regIds + "&lastDt=" + lastDt,
                success: function callBack(data) {
                    var isNew = data.map.isNew;
                    if (!isNew)	//没有最新数据
                        return false;
                    var listDatas = data.map.listTables;
                    var lastDt = data.map.lastDt;
                    //alert(listDatas+"|"+lastDt);
                    var tdHtml = "<tr>";
                    tdHtml += "<td width=5%>1</td><td width=15%>" + lastDt + "</td>";
                    var listData;
                    for (var i = 0; i < listDatas.length; i++) {
                        listData = listDatas[i];
                        tdHtml += "<td style='" + listData[1] + "'>" + listData[0] + "</td>";
                    }
                    tdHtml += "</tr>";
                    $("#bbsTab tr:first").before(tdHtml);
                    if ($("#bbsTab tr").length >= dtBet)
                        $("#bbsTab tr:last-child").remove();
                    $("#bbsTab tr").attr("class", "");	//清空class
                    ready();
                }
            });
        }
        function jsons_table() {
            $("#detail_bg").show().css("z-index", "50000");
            beCenter("waiting");
            $("#waitings").html("加载中，请稍候....");
            $("#waiting").show();
            $.ajax({
                type: "post",
                dataType: "json",
                url: "json_nowTables.action?regId=" + regId + "&dtBet=" + dtBet,
                success: function callBack(data) {
                    var map = data.map;
                    regIds = map.regIds;
                    depId = map.depId;
                    lastDt = map.lastDt;
                    var trThs = map.trThs;			//th标题
                    trDatas = map.trDatas;			//tr内容
                    var thHtml = "";
                    thHtml += "<th width=5%>序号</th><th width=15%>记录时间</th>";
                    for (var i in trThs) {
                        thHtml += "<th>" + trThs[i] + "</th>";
                    }
                    $("#trTh").html(thHtml);
                    json_datas(trDatas);
                    ready();
                    res();
                    var colorExceps = map.colorExceps;	//异常数据，待页面数据填充完后改变颜色
                    var tbody = $("#bbsTab");
                    var trIndex, tdIndex, color;
                    if (colorExceps != null && colorExceps.length > 0) {
                        var colorExcep;
                        for (var i = 0; i < colorExceps.length; i++) {
                            colorExcep = colorExceps[i];
                            trIndex = parseInt(colorExcep.split("_")[0]);
                            tdIndex = parseInt(colorExcep.split("_")[1]) + 2;
                            color = colorExcep.split("_")[2];
                            $(tbody).find("tr:eq(" + trIndex + ") > td:eq(" + tdIndex + ")").css({
                                "color": "#" + color,
                                "font-weight": "bold"
                            });
                        }
                    }
                    $("#waiting").hide();
                    $("#detail_bg").hide();
                }
            });
        }
        $(window).resize(function () {
            res();
        });
        function res() {
            var hHeight = $(".h1").height();
            $(".h1").height(hHeight + 10);
        }
    </script>
    <style>
        html, body {
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
        }

        * {
            overflow: auto;
        }

        table {
            table-layout: fixed;
        }

        td {
            word-break: break-all;
            word-wrap: break-word;
        }
    </style>
</head>
<body>
<div align="left">
    <table id="vv">
        <thead>
        <tr id="trTh">
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
<!-- <div id="Page">
	<a class='aBtn aOut' id="excel" href='javascript:' style="display:none;">导出数据</a>　
	<a class='aBtn aDetail' id='aInter' href='javascript:' onclick="stopInter(id, interType)">停止刷新</a>
</div> -->
<div id="detail_bg"></div>
<div id="waiting"><span id="waitings"></span></div>
</body>
</html>