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
    <title>实时监测柱形图</title>
    <script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <script src="../js/highcharts/highcharts.js"></script>
    <script src="../js/highcharts/modules/exporting.js"></script>
    <link href="../css/button1.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript">
        var id = request("id");
        var treeType = request("treeType");
        var period;		//采样周期
        var dtBet = request("dtBet");		//取之前的数据点个数
        var chart;
        var regPName;
        var lastDts = [];
        var chart;
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
                url: "json_nowColumnInit.action",
                data: "regId=" + id,
                success: function callBack(data) {
                    var rows = data.rows;
                    var regNames = [];	//数据名称
                    if (rows == "")
                        return false;
                    var regId;			//参数Id
                    var regName;		//参数名
                    var unitName;       //参数单位
                    var lastDt = "";	//最近时间
                    var regData;		//color;y
                    var yMin = "";		//Y轴最小值
                    var yMax = "";		//Y轴最大值
                    var color = "";		//柱形颜色
                    var rowsSize = rows.length;
                    var regIds = "";
                    var liHtml;
                    var pWidth = _width();
                    var pHeight = _height() - 10;
                    var chartWidth = pWidth / rowsSize - 11;
                    var xAxis;
                    var seriesData;
                    for (var i in rows) { //遍历所有的参数,每个参数放到一张单独的图表中
                        regId = rows[i].regId;
                        regIds += regId + ",";
                        regName = rows[i].regName;
                        unitName = rows[i].unitName;
                        lastDt = rows[i].lastDt;
                        regData = rows[i].regData;
                        regPName = rows[i].regPName;
                        color = rows[i].color;
                        regNames.push(regName);
                        lastDts.push(lastDt);
                        xAxis = [];
                        xAxis.push(regName);
                        seriesData = [{
                            color: rows[i].color,
                            y: rows[i].y
                        }];
                        ;
                        ;
                        ;
                        ;
                        ;
                        ;
                        ;
                        liHtml = "<li id='liChart_" + i + "' class='cLi'><div id='divChart_" + i + "'></div></li>";
                        $("#ulCharts").append(liHtml);
                        $("#divChart_" + i).width(chartWidth).height(pHeight)	//先设置highcharts容器的宽度
                                .highcharts({
                                    chart: {
                                        type: 'column',
                                        borderColor: '#98d7df',
                                        borderWidth: 1,
                                        borderRadius: 5
                                    },
                                    exporting: {
                                        enabled: false
                                    },
                                    credits: {
                                        enabled: false
                                    },
                                    title: {
                                        text: regName,
                                        style: {fontFamily: "微软雅黑"}
                                    },
                                    tooltip: {
                                        animation: false,
                                        useHTML: true,
                                        formatter: function () {    //在此处可以自定义提示信息显示的样式
                                            var tooltop = "<b>" + Highcharts.dateFormat('%Y-%m-%d %H:%M:%S', lastDts[this.point.x]) + "</b><br />";
                                            var value = (this.point.y).toFixed(2);
                                            var regName = this.x;
                                            tooltop += "<li style='color:" + this.point.color + ";padding:0;margin:0;list-style:none'>" + regName + "：<span style='color:black;'>" + value + "</span></li>";
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
                                        categories: xAxis,
                                        labels: {
                                            style: {
                                                fontSize: "15px",
                                            }
                                        }
                                    },
                                    plotOptions: {	//在柱形图上显示数据
                                        column: {
                                            pointPadding: 0.3,
                                            dataLabels: {
                                                enabled: true,
                                                style: {
                                                    fontSize: "14px"
                                                },
                                                formatter: function () {
                                                    var val = this.point.y;
                                                    if (!isInteger(val)) {   //整数则不需要保留2位小数
                                                        return Highcharts.numberFormat(this.point.y, 2);    //保留2位小数
                                                    }
                                                    else
                                                        return this.point.y;
                                                }
                                            },
                                        }
                                    },
                                    yAxis: {
                                        title: {
                                            text: regName + " (" + unitName + ")",
                                            style: {fontFamily: "微软雅黑"}
                                        }/* ,
                                         min: yMin,
                                         max: yMax */
                                    },
                                    series: [{
                                        name: regName,
                                        tooltip: {
                                            valueDecimals: 2
                                        },
                                        data: seriesData
                                    }]
                                });
                    }
                    var nowDt = data.map.nowDt;
                    period = data.map.period;
                    res();
                    regIds = regIds.substring(0, regIds.length - 1);
                    updateDatas(regIds);
                    $("#ulCharts").css({"overflow-y": "auto", "overflow-x": "hidden"});
                    $("#waiting").hide();
                    $("#detail_bg").hide();
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        };

        function updateDatas(regIds) {	//动态添加数据
            var intUrl = "json_nowColumn.action?regIds=" + regIds;
            setInterval(function () {
                $.ajax({
                    type: "post",
                    dataType: "json",
                    url: intUrl,
                    success: function callBack(data) {
                        var listDatas = data.map.listColumns;
                        var series;
                        var regData;
                        for (var i in listDatas) {
                            series = $("#divChart_" + i).highcharts().series[0];
                            regData = [];
                            regData.push(listDatas[i]);
                            series.setData(regData);
                        }
                    }
                });
            }, period);
        }

        function windowTest() {		//将实时图表转移到弹出窗口显示，可同时浏览多个设备（一个窗口对应一个参数）
            var liId;
            var wWidth = $("#ulCharts .cLi:first").width();
            var wHeight = $("#ulCharts .cLi:first").height();
            var openWindow;
            $("#ulCharts .cLi").each(function () {
                liId = $(this).attr("id").split("_")[1];
                openWindow = window.open("nowCharts.jsp?regId=" + liId + "&period=" + period + "&dtBet=" + dtBet,
                        "newwindow_" + liId, "height=" + (parseInt(wHeight) + 15) + ", width=" + (parseInt(wWidth) + 18) + ", top=0,left=0, toolbar=no,menubar=no,scrollbars=no,location=no, status=no,resizable=yes");
                top.mapOpens.put(liId + "", openWindow);
            });
        }
        $(window).resize(function () {
            res();
        });
        function res() {
            var lHeight = _height() - 10;
            var lWidth = _width();
            var chartSize = $("#ulCharts .cLi").length;
            var chartWidth = lWidth / chartSize - 10;
            $("#ulCharts .cLi").each(function (i) {
                $(this).children("div").width(chartWidth).height(lHeight);
                //$(this).css({"left": i * chartWidth});
            });
        }
        function outAll(type) {	//导出即时柱状图-单张图片
            $("#detail_bg").show();
            beCenter("waiting");
            $("#waitings").html("导出中，请稍候....");
            $("#waiting").show();
            var svg = chart.getSVG();
            $.ajax({
                type: 'POST', //post方式异步提交
                async: false, //同步提交
                traditional: true,
                url: "../chart/exportNowColumn", //导出图表的服务页面地址
                dataType: "json",//传递方式为json
                //几个重要的参数 如果这里不传递width的话，需要修改导出服务页面内的Request.Form["width"].ToString() 把这句代码注释掉即可
                data: {"svg": svg, "type": type},
                success: function (msg) {
                    alert("图表导出成功!");
                    location.href = "../chart/downloadColumnWord?type=" + type;
                    $("#waiting").hide();
                    $("#detail_bg").hide();
                },
                error: function (errorMsg) {
                    //alert(errorMsg.responseText);
                    location.href = "../chart/downloadColumnWord?type=" + type;
                    $("#waiting").hide();
                    $("#detail_bg").hide();
                }
            });
        }
    </script>
    <style type="text/css">
        html {
            height: 100%;
        }

        body {
            margin: 0;
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
            overflow-x: auto;
            overflow-y: hidden;
            width: 100%;
            position: relative;
        }
    </style>
</head>
<body>
<button id="openWindow" onclick="windowTest()" class="dNone">测试</button>
<div id="charts">
    <ul id="ulCharts" style="height:100%"></ul>
</div>
<div style="display:none">
    <button id="jpg" onclick="outAll(id)">保存JPG图片</button>
    <button id="png" onclick="outAll(id)">保存PNG图片</button>
    <button id="pdf" onclick="outAll(id)">保存PDF图片</button>
</div>
<div id="detail_bg"></div>
<div id="waiting"><span id="waitings"></span></div>
</body>
</html>