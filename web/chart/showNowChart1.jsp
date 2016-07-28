<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%
    response.setHeader("Pragma ", "No-cache ");
    response.setHeader("Cache-Control ", "no-cache ");
    response.setDateHeader("Expires ", 0);
%>
<!DOCTYPE HTML>
<html>
<head>
    <title>实时监测曲线图</title>
    <script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <script src="../js/highstock/highstock.js"></script>
    <script src="../js/highstock/modules/exporting.js"></script>
    <link href="../css/button1.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript">
        var id = request("id");
        var treeType = request("treeType");
        var period;		//采样周期
        var lWidth = document.documentElement.clientWidth - 20;
        var lHeight = 205;		//lichart的一半高度
        var secLast = request("secLast");	//前秒数
        var secNow = request("secNow");		//现秒数
        var chart;
        var charts = [];
        window.onload = function () {
            Highcharts.setOptions({
                global: {
                    useUTC: false
                },
                lang: {
                    printChart: "打印图表",
                    downloadJPEG: "下载JPEG 图片",
                    downloadPDF: "下载PDF文档",
                    downloadPNG: "下载PNG 图片",
                    downloadSVG: "下载SVG 矢量图",
                    exportButtonTitle: "导出图片"
                }
            });
            $("#detail_bg").show();
            beCenter("waiting");
            $("#waitings").html("加载中，请稍候....");
            $("#waiting").show();
            $.ajax({
                type: "post",
                dataType: "json",
                url: "json_nowChartInit1.action",
                data: "regId=" + id + "&secLast=" + secLast + "&secNow=" + secNow,
                success: function callBack(data) {
                    var rows = data.map.datas;
                    var avgPower = data.map.avgPower;
                    if (rows != "") {
                        var regId;			//参数Id
                        var regIds = "";	//参数Ids
                        var paraEnNames = "";	//参数类别名（标记输出功率以及冷热温差）
                        var regNames = "";
                        var regUrls = "";	//关联参数Id（标记输出功率以及冷热温差的关联参数）
                        var regName;		//参数名
                        var regPName;		//设备名
                        var unitName;		//参数单位
                        var regDatas;		//当前一段数据
                        var lastDts = "";	//最近时间
                        var lastDatas = "";	//最近数据
                        var lastDt = "";	//最近时间
                        var lastData = "";	//最近数据
                        var maxValue1 = "";	//异常下限
                        var maxValue2 = "";	//警报下限
                        var devParas = "";	//设备名【参数名】
                        var liHtml = "";
                        var pWidth, pHeight;
                        var rowsSize = rows.length;
                        for (var i = 0; i < rowsSize; i++) {
                            pWidth = (i % 2 == 0) ? 0 : lWidth / 2;
                            pHeight = (i % 2 == 0) ? i * lHeight : (i - 1) * lHeight;
                            regId = rows[i].regId;
                            regIds += regId + ",";
                            regUrls += rows[i].regUrl + "~!";
                            regName = rows[i].regName;
                            paraEnNames += rows[i].paraEnName + ",";
                            regNames += regName + ",";
                            unitName = rows[i].unitName;
                            regDatas = rows[i].regDatas;
                            period = rows[i].period;
                            lastDt = rows[i].lastDt;
                            lastData = rows[i].lastData;
                            lastDts += rows[i].lastDt + ",";
                            lastDatas += rows[i].lastData + ",";
                            maxValue1 = rows[i].maxValue1;
                            maxValue2 = rows[i].maxValue2;
                            regPName = rows[i].regPName;
                            liHtml = "<li id='liChart_" + regId + "' class='cLi' style='left:" + pWidth + "px;top:" + pHeight + "px'><div id='divChart_" + regId + "'></div></li>";
                            $("#ulCharts").append(liHtml);
                            $("#divChart_" + regId).width(lWidth / 2 - 15);
                            chart = new Highcharts.StockChart({
                                chart: {
                                    renderTo: 'divChart_' + regId,
                                    //type: 'spline',
                                    marginRight: 8,
                                    borderColor: '#98d7df',
                                    borderWidth: 1,
                                    borderRadius: 5
                                },
                                rangeSelector: {
                                    enabled: false
                                },
                                exporting: {
                                    url: "../chart/export", // 配置导出路径
                                    scale: 2
                                },
                                credits: {
                                    enabled: false
                                },
                                title: {
                                    text: "实时数据：" + regName + "(" + unitName + ")",
                                    style: {fontFamily: "微软雅黑"}
                                },
                                /* tooltip : {
                                 style: {fontFamily: "微软雅黑"},
                                 //valueDecimals: 4
                                 formatter:function(){
                                 var s = '<b>'+this.x + '</b>';
                                 $.each(this.points, function () {
                                 s += '<br/>' + this.y;
                                 });
                                 return s;
                                 }
                                 }, */
                                tooltip: {
                                    useHTML: true,
                                    formatter: function () {    //在此处可以自定义提示信息显示的样式
                                        var tooltop = "";
                                        var sec = this.x / 1000;
                                        var secL = sec % 1000;
                                        tooltop += "<b>" + Highcharts.dateFormat('%Y-%m-%d %H:%M:%S', sec) + "." + secL + "</b><br />";
                                        var value;
                                        var regName;
                                        for (var i in this.points) {
                                            value = this.points[i].y;
                                        }
                                        regName = this.points[i].series.name;
                                        tooltop += "<li style='color:" + this.points[i].series.color + ";padding:0;margin:0;list-style:none'>" + regName + "：<span style='color:black;'>" + value + "</span></li>";
                                        ;
                                        ;
                                        ;
                                        ;
                                        ;
                                        ;
                                        ;
                                        return tooltop;
                                    }
                                },
                                legend: {
                                    enabled: false
                                },
                                xAxis: {
                                    labels: {
                                        enabled: false
                                    }
                                },
                                yAxis: {
                                    title: {
                                        text: regName + "(" + unitName + ")",
                                        style: {fontFamily: "微软雅黑"}
                                    }
                                },
                                series: [{
                                    name: regName + "(" + unitName + ")",
                                    tooltip: {
                                        valueDecimals: 4
                                    },
                                    data: regDatas
                                }]
                            });
                            charts.push(chart);
                            //ggetCharts(regId);
                        }
                        //$(".cLi").width(lWidth/2-15);
                        var ulHeight = rowsSize % 2 != 1 ? rowsSize * lHeight : (rowsSize + 1) * lHeight;
                        $("#ulCharts").css({"overflow-y": "auto", "overflow-x": "hidden", "height": ulHeight});
                        $("#waiting").hide();
                        $("#detail_bg").hide();
                        $("#charts").height(document.documentElement.clientHeight);
                        $("#avgPower", window.parent.document).html(" 平均功率：" + avgPower);
                        res();
                        //jScroll();
                    }
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        };

        function windowTest() {		//将实时图表转移到弹出窗口显示，可同时浏览多个设备（一个窗口对应一个参数）
            var liId;
            var wWidth = $("#ulCharts .cLi:first").width();
            var wHeight = $("#ulCharts .cLi:first").height();
            var openWindow;
            $("#ulCharts .cLi").each(function () {
                liId = $(this).attr("id").split("_")[1];
                openWindow = window.open("nowCharts1.jsp?regId=" + liId + "&secLast=" + secLast + "&secNow=" + secNow,
                        "newwindow_" + liId, "height=" + (parseInt(wHeight) + 15) + ", width=" + (parseInt(wWidth) + 18) + ", top=0,left=0, toolbar=no,menubar=no,scrollbars=no,location=no, status=no,resizable=yes");
                //$(this).remove();
                top.mapOpens.put(liId + "", openWindow);
            });
        }
        function liSort(arr) {
            var pWidth, pHeight;
            for (var i in arr) {
                pWidth = (i % 2 == 0) ? 0 : lWidth / 2;
                pHeight = (i % 2 == 0) ? i * lHeight : (i - 1) * lHeight;
                $("#liChart_" + arr[i]).css({"left": pWidth, "top": pHeight});
            }
        }
        $(window).resize(function () {
            res();
        });
        function res() {
            lWidth = document.documentElement.clientWidth - 20;
            $("#ulCharts .cLi").each(function () {
                $(this).width(lWidth / 2 - 15);
                $(this).children("div").css("width", "");
                if ($(this).css("left") != "0px")
                    $(this).css("left", lWidth / 2);
            });
        }
        function outAll() {
            $("#detail_bg").show();
            beCenter("waiting");
            $("#waitings").html("导出中，请稍候....");
            $("#waiting").show();
            var svgs = [];
            for (var i in charts) {
                svgs.push(charts[i].getSVG());
            }
            $.ajax({
                type: 'POST', //post方式异步提交
                async: false, //同步提交
                traditional: true,
                url: "../chart/exports", //导出图表的服务页面地址
                dataType: "json",//传递方式为json
                //几个重要的参数 如果这里不传递width的话，需要修改导出服务页面内的Request.Form["width"].ToString() 把这句代码注释掉即可
                data: {"svgs": svgs},
                success: function (msg) {
                    //alert("图表导出成功!");
                    location.href = "../chart/downloadWord";
                    $("#waiting").hide();
                    $("#detail_bg").hide();
                },
                error: function (errorMsg) {
                    location.href = "../chart/downloadWord";
                    $("#waiting").hide();
                    $("#detail_bg").hide();
                }
            });
        }
        function chartState(state) {	//切换chart的更新/停止状态
            isRun = state;
            if (state == 1) {
                /* for(var i in charts){
                 charts[i].series[0].setData([]);
                 } */
            }
        }
    </script>
    <style type="text/css">
        html {
            height: 100%;
        }

        body {
            margin: 2px;
            padding: 0;
            height: 100%;
            font: 14px arial, 微软雅黑, 宋体, sans-serif;
        }

        #detail_bg {
            position: absolute;
            top: 0px;
            left: 0px;
            width: 100%;
            height: 100%;
            z-index: 50000;
            background-color: #000;
            display: none;
            opacity: 0.3;
            filter: alpha(opacity=30);
        }

        #waiting {
            position: fixed;
            z-index: 50015;
            display: none;
            border: 1px solid #82B324;
            min-width: 200px;
            height: 50px;
            line-height: 50px;
            background-color: #f0fcff;
            border-radius: 4px;
            padding: 0 10px;
            text-align: center;
        }

        #waitings {
            background: url(../img/tree_loading.gif) no-repeat;
            padding-left: 20px;
        }

        .blue {
            color: blue
        }

        .red {
            color: red
        }

        .green {
            color: green
        }

        .dNone {
            display: none
        }

        #ulCharts {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .cLi {
            word-wrap: break-word;
            word-break: normal;
            padding: 5px;
            list-style-type: none;
            display: inline-block;
            display: -moz-inline-stack;
            *display: inline;
            zoom: 1;
            vertical-align: top;
            position: absolute;
        }

        .cLi .divFcexp {
            text-align: center;
            height: 39px;
        }

        @-moz-document url-prefix() {
            .cLi .divFcexp {
                top: 410px
            }
        }

        .cLi img {
            position: absolute;
            left: 5px;
            top: 5px;
        }

        #charts {
            margin: 0;
            padding: 0;
            overflow-y: auto;
            overflow-x: hidden;
            width: 100%;
            position: relative;
        }
    </style>
</head>
<body>
<div id="charts">
    <ul id="ulCharts">
    </ul>
</div>
<div style="display:none">
    <button id="jpg" onclick="saveChart(id)">保存JPG图片</button>
    <button id="png" onclick="saveChart(id)">保存PNG图片</button>
    <button id="pdf" onclick="saveChart(id)">保存PDF图片</button>
</div>
<div id="detail_bg"></div>
<div id="waiting"><span id="waitings"></span></div>
</body>
</html>