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
    <link href="../css/style.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript">
        var regId = request("id");
        var stDt = request("stDt");
        var endDt = request("endDt");
        var hisInter = request("hisInter");   //时间间隔-天,月,年
        var jumpPage = 1;	//页数
        var pageSize = 50;	//条数
        var url = "json_hisTable.action?regId=" + regId + "&stDt=" + stDt + "&endDt=" + endDt + "&hisInter=" + hisInter;
        $(function () {
            jsons_tableInit();
            //$("#outHis").attr("onclick","excelOut('hisTables','?regId="+regId+"&stDt="+stDt+"&endDt="+endDt+"')");
        });
        function out() {
            excelOut("hisTables", "?regId=" + regId + "&stDt=" + stDt + "&endDt=" + endDt + "&hisInter=" + hisInter);
        }
        function jsons_tableInit() {	//初始化
            $.ajax({
                type: "post",
                dataType: "json",
                url: "json_hisTableInit.action",
                data: "regId=" + regId,
                success: function callBack(data) {
                    var trThs = data.map.trThs;
                    var thHtml = "";
                    thHtml += "<th width=5%>序号</th><th width=15%>记录时间</th>";
                    for (var i in trThs) {
                        thHtml += "<th>" + trThs[i] + "</th>";
                    }
                    $("#trTh").html(thHtml);
                    jsons(jumpPage, pageSize, url);	//初始化结束，获取数据
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        }
        function jsons(jumpPage, pageSize, url) {
            jumpPage = jumpPage != null ? jumpPage : "1";
            $("#detail_bg").show().css("z-index", "50000");
            beCenter("waiting");
            $("#waitings").html("加载中，请稍候....");
            $("#waiting").show();
            $.ajax({
                type: "post",
                dataType: "json",
                url: url,
                data: "jumpPage=" + jumpPage + "&pageSize=" + pageSize,
                success: function callBack(data) {
                    var map = data.map;
                    var flagNull = map.flagNull;
                    if (flagNull == 0) {		//表示没有历史数据
                        $("#bbsTab").html("");		//清空
                        var nullHtml = "<div id='nullHtml'>所选时间无历史数据</div>";
                        $(".h1").append(nullHtml);
                        $("#nullHtml").css("line-height", getHeight() - "5" + "px");
                        $("#waiting").hide();
                        $("#detail_bg").hide();
                        return;
                    }
                    var trDatas = map.trDatas;			//tr内容
                    json_datas(trDatas);
                    var pageBean = map.pageBean;
                    json_pages(pageBean);
                    ready();
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
    </script>
    <style>
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

        .hide {
            display: none
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
<div id="Page">
    <div id="pages"></div>
</div>
<a class='hide' id="outHis" href='javascript:'>导出数据</a>
<div id="detail_bg"></div>
<div id="waiting"><span id="waitings"></span></div>
</body>
</html>