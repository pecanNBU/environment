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
    <script src="../js/highcharts/highcharts.js"></script>
    <script src="../js/highcharts/modules/exporting.js"></script>
    <link href="../css/button1.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript">
        var regId = request("regId");
        var mapDevParas = new Map();
        var period;		//采样周期
        var lWidth = document.documentElement.clientWidth - 10;
        var lHeight = document.documentElement.clientHeight - 10;
        var stDt = request("stDt");		//取之前的数据点个数
        var endDt = request("endDt");		//取之前的数据点个数
        //var dtBet = 50;
        var chart;
        var charts = [];
        var experVolt = request("experVolt");
        var regPName;
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
                url: "json_experChart.action",
                data: "regId=" + regId + "&stDt=" + stDt + "&endDt=" + endDt,
                success: function callBack(data) {
                    var map = data.map;
                    if (map != "") {
                        var regName = map.regName;
                        var unitName = map.unitName;
                        var regDatas = map.datas;
                        var xLabel = {
                            type: 'datetime',
                            labels: {
                                step: 1,
                                formatter: function () {
                                    return Highcharts.dateFormat('%H:%M:%S', this.value);
                                }
                            }
                        };
                        ;
                        ;
                        ;
                        ;
                        ;
                        ;
                        ;
                        var liHtml = "<li id='liChart_" + regId + "' class='cLi'><div id='divChart_" + regId + "'></div></li>";
                        $("#ulCharts").append(liHtml);
                        $("#divChart_" + regId).width(lWidth).height(lHeight);
                        chart = new Highcharts.Chart({
                            chart: {
                                renderTo: 'divChart_' + regId,
                                stype: 'spline',
                                marginRight: 8,
                                borderColor: '#98d7df',
                                borderWidth: 1,
                                borderRadius: 5,
                                zoomType: "xy"
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
                            tooltip: {
                                style: {fontFamily: "微软雅黑"}
                            },
                            legend: {
                                enabled: false
                            },
                            xAxis: xLabel,
                            yAxis: {
                                title: {
                                    text: regName + "(" + unitName + ")",
                                    style: {fontFamily: "微软雅黑"}
                                }/* ,
                                 min: yMin,
                                 max: yMax */
                            },
                            series: [{
                                name: regName + "(" + unitName + ")",
                                tooltip: {
                                    valueDecimals: 1,
                                    xDateFormat: '%Y-%m-%d %H:%M:%S'
                                },
                                data: regDatas
                            }]
                        });
                        $("#ulCharts").css({"overflow-y": "auto", "overflow-x": "hidden", "height": lHeight});
                        $("#waiting").hide();
                        $("#detail_bg").hide();
                        $("#charts").height(document.documentElement.clientHeight);
                    }
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        };
        function chartState(state) {	//切换chart的更新/停止状态
            if (state == 1) {	//开始实验，清空所有数据
                parent.submit1(0);	//执行父页面的【刷新】按钮
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
<button id="openWindow" onclick="windowTest()" class="dNone">测试</button>
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
