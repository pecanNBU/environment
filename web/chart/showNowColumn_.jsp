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
        var mapDevParas = new Map();
        var period;		//采样周期
        var dtBet = request("dtBet");		//取之前的数据点个数
        var chart;
        var regPName;
        var noteIds;	//图标所有节点Id
        var lastDts = [];
        var chart;
        window.onload = function () {
            res();
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
                    var regDatas = [];	//实时数据
                    var regNames = [];	//数据名称
                    //var colors = new Array();	//数据名称
                    if (rows != "") {
                        var regId;			//参数Id
                        var regUrls = "";	//关联参数Id（标记输出功率以及冷热温差的关联参数）
                        var regName;		//参数名
                        var unitName;		//参数单位
                        var lastDt = "";	//最近时间
                        var regData;		//color;y
                        var maxValue1 = "";	//异常下限
                        var maxValue2 = "";	//警报下限
                        var devParas = "";	//设备名【参数名】
                        var yMin = "";		//Y轴最小值
                        var yMax = "";		//Y轴最大值
                        var color = "";		//柱形颜色
                        var liHtml = "";
                        var pWidth, pHeight;
                        var rowsSize = rows.length;
                        noteIds = "";
                        for (var i = 0; i < rowsSize; i++) {
                            regId = rows[i].regId;
                            noteIds += regId + ",";
                            regName = rows[i].regName;
                            //regNames += regName + ",";
                            period = rows[i].period;
                            lastDt = rows[i].lastDt;
                            regData = rows[i].regData;
                            regPName = rows[i].regPName;
                            color = rows[i].color;
                            devParas = regPName + "【" + regName + "】";
                            mapDevParas.put(regId + "", devParas);
                            regDatas.push(regData);
                            regNames.push(regName);
                            //colors.push(color);
                            lastDts.push(lastDt);
                        }
                        var nowDt = data.map.nowDt;
                        chart = new Highcharts.Chart({
                            chart: {
                                renderTo: 'divColumn',
                                type: 'column',
                                marginRight: 8,
                                borderColor: '#98d7df',
                                borderWidth: 1,
                                borderRadius: 5,
                                zoomType: "xy"
                            },
                            exporting: {
                                //url: "../chart/exportNowColumn", // 配置导出路径
                                //scale: 2
                                enabled: true
                            },
                            credits: {
                                enabled: false
                            },
                            title: {
                                text: "实时柱状图：" + regPName + " 【" + nowDt + "】",
                                style: {fontFamily: "微软雅黑"}
                            },
                            tooltip: {
                                /*style: {fontFamily: "微软雅黑",
                                 fontSize:"13px"}*/
                                animation: false,
                                useHTML: true,
                                formatter: function () {    //在此处可以自定义提示信息显示的样式
                                    var tooltop = "";
                                    tooltop += "<b>" + Highcharts.dateFormat('%Y-%m-%d %H:%M:%S', lastDts[this.point.x]) + "</b><br />";
                                    var value = (this.point.y).toFixed(2);
                                    var regName = this.x;
                                    tooltop += "<li style='color:" + this.point.color + ";padding:0;margin:0;list-style:none'>" + regName + "：<span style='color:black;'>" + value + " ℃</span></li>";
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
                                categories: regNames,
                                labels: {
                                    style: {
                                        fontSize: "13px"
                                    }
                                },
                            },
                            plotOptions: {	//在柱形图上显示数据
                                column: {
                                    dataLabels: {
                                        enabled: true,
                                        style: {
                                            fontSize: "14px"
                                        }
                                    },
                                }
                            },
                            yAxis: {
                                title: {
                                    text: "实时柱状图（℃）",
                                    style: {fontFamily: "微软雅黑"}
                                }/* ,
                                 min: yMin,
                                 max: yMax */
                            },
                            series: [{
                                name: "实时柱状图",
                                //colorByPoint: true,
                                tooltip: {
                                    valueDecimals: 2,
                                    xDateFormat: '%m-%d %H:%M:%S'
                                },
                                data: regDatas
                            }]
                        });
                        //res();
                        noteIds = noteIds.substring(0, noteIds.length - 1);
                        updateDatas(noteIds);
                        $("#ulCharts").css({"overflow-y": "auto", "overflow-x": "hidden"});
                        $("#waiting").hide();
                        $("#detail_bg").hide();
                    }
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        };

        function updateDatas(noteIds) {	//动态添加数据
            var intUrl = "json_nowColumn.action?noteIds=" + noteIds;
            setInterval(function () {
                $.ajax({
                    type: "post",
                    dataType: "json",
                    url: intUrl,
                    success: function callBack(data) {
                        var listDatas = data.map.listColumns;
                        var series = chart.series[0];
                        series.setData(listDatas);
                        lastDts = data.map.listDts;
                        var nowDt = data.map.nowDt;
                        chart.setTitle({text: "实时柱状图：" + regPName + " 【" + nowDt + "】"});	//同步chart的title
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
                //$(this).remove();
                top.mapOpens.put(liId + "", openWindow);
            });
        }
        $(window).resize(function () {
            res();
        });
        function res() {
            var lHeight = document.documentElement.clientHeight - 3;
            var lWidth = document.documentElement.clientWidth - 3;
            $("#divColumn").width(lWidth).height(lHeight);
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
            padding: 1px;
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
    <ul id="ulCharts" style="height:100%">
        <div id="divColumn" style="width:100%;height:100%"></div>
    </ul>
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
