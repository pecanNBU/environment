<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE HTML>
<html>
<head>
    <title>同比-实时曲线图</title>
    <script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <script src="../js/Highcharts/highcharts.js"></script>
    <script src="../js/Highcharts/modules/exporting.js"></script>
    <link href="../css/button1.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript">
        var regIdss = request("regIdss");
        var mapDevParas = new Map();
        var period;		//采样周期
        var lWidth = document.documentElement.clientWidth - 15;
        var lHeight = document.documentElement.clientHeight;
        var dtBet = request("dtBet");
        var chart;
        var charts = [];
        var regPName;
        var rows;
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
                url: "json_nowChartInit_contr.action",
                data: "regIds=" + regIdss + "&dtBet=" + dtBet,
                success: function callBack(data) {
                    rows = data.map.rows;
                    if (rows == "") {   //没返回
                        return false;
                    }
                    period = data.map.period;
                    var series; //数据
                    var yAxis;  //Y轴配置
                    var listYAxis;
                    var yAxis_;
                    var yAxis_index;
                    var rowsSize = rows.length;
                    var mapRegIds = new Map();  //regId → <chartIndex, seriesIndex>
                    var mapRecDatas = new Map();
                    var recDatas;
                    var listRegIds;
                    var indexs = [];   //<chartIndex, seriesIndex>
                    var regId;
                    var liHtml;
                    for (var i = 0; i < rowsSize; i++) {
                        recDatas = rows[i].mapRecDatas;
                        mapRecDatas.put(i + "", recDatas);
                        listRegIds = rows[i].listRegIds;    //当前图表的参数Id
                        for (var index in listRegIds) {
                            regId = listRegIds[index];
                            indexs = mapRegIds.get(regId + "");
                            if (indexs == null)
                                indexs = [];
                            indexs.push(i + "_" + index);
                            mapRegIds.put(regId + "", indexs);
                        }
                        series = rows[i].series;
                        listYAxis = rows[i].yAxis;
                        yAxis = [];
                        for (var j in listYAxis) {
                            yAxis_index = parseInt(listYAxis[j].chartIndex);
                            yAxis_ = {
                                labels: {
                                    format: '{value}',
                                    style: {
                                        fontSize: "12px",
                                        color: Highcharts.getOptions().colors[yAxis_index]
                                    }
                                },
                                title: {
                                    text: listYAxis[j].text,
                                    style: {
                                        fontSize: "12px",
                                        color: Highcharts.getOptions().colors[yAxis_index]
                                    }
                                },
                                showEmpty: false    //隐藏此类参数时同步隐藏Y轴
                            };
                            ;
                            ;
                            ;
                            ;
                            ;
                            ;
                            ;
                            yAxis.push(yAxis_);
                        }
                        liHtml = "<li id='liChart_" + i + "' class='cLi'><div id='divChart_" + i + "'></div></li>";
                        $("#ulCharts").append(liHtml);
                        $("#divChart_" + i).width(lWidth).height(lHeight - 10)	//先设置highcharts容器的宽度
                                .highcharts({
                                    chart: {
                                        type: 'spline',
                                        marginRight: 8,
                                        borderColor: '#98d7df',
                                        borderWidth: 1,
                                        borderRadius: 5,
                                        //zoomType: "xy"
                                    },
                                    credits: {
                                        enabled: false
                                    },
                                    title: {
                                        text: "实时数据：图表" + (i + 1),
                                        style: {fontFamily: "微软雅黑"}
                                    },
                                    tooltip: {
                                        useHTML: true,
                                        formatter: function () {    //在此处可以自定义提示信息显示的样式
                                            var tooltop = "";
                                            tooltop += "<b style='font-size: 13px;'>" + Highcharts.dateFormat('%Y-%m-%d %H:%M:%S', this.x) + "</b><br />";
                                            var value;
                                            var regName;
                                            for (var i in this.points) {
                                                value = this.points[i].y;
                                                regName = this.points[i].series.name;
                                                tooltop += "<li style='color:" + this.points[i].series.color + ";padding:0;margin:0;list-style:none;font-size: 13px'>" +
                                                        "<span style='font-weight: bold'>" + regName + "：</span>" +
                                                        "<span style='color:black;'>" + value + "</span>" +
                                                        "</li>"
                                            }
                                            return tooltop;
                                        },
                                        shared: true
                                    },
                                    legend: {
                                        enabled: true
                                    },
                                    xAxis: {
                                        type: 'datetime',
                                        labels: {
                                            step: 1,
                                            formatter: function () {
                                                return Highcharts.dateFormat('%H:%M:%S', this.value);
                                            }
                                        }
                                    },
                                    yAxis: yAxis,
                                    plotOptions: {
                                        series: {
                                            marker: {
                                                enabled: false  //隐藏图表上的实心点
                                            }
                                        },
                                    },
                                    series: series
                                });
                    }
                    var ulHeight = rowsSize * lHeight;
                    $("#ulCharts").css({"overflow-y": "auto", "overflow-x": "hidden", "height": ulHeight});
                    $("#waiting").hide();
                    $("#detail_bg").hide();
                    res();
                    updateDatas(mapRecDatas, mapRegIds);
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        };

        function updateDatas(mapRecDatas, mapRegIds) {	//动态添加数据
            var regIds = "";
            var lastDts = "";
            var lastDatas = "";
            for (var i in mapRecDatas.arr) {
                for (var j in mapRecDatas.arr[i].value) {
                    regIds += j + ",";
                    lastDts += mapRecDatas.arr[i].value[j][0] + ',';
                    lastDatas += mapRecDatas.arr[i].value[j][1] + ',';
                }
            }
            regIds = regIds.substring(0, regIds.length - 1);
            lastDts = lastDts.substring(0, lastDts.length - 1);
            lastDatas = lastDatas.substring(0, lastDatas.length - 1);
            var intUrl = "json_nowCharts_contr.action?regIds=" + regIds + "&lastDts=" + lastDts + "&lastDatas=" + lastDatas;
            setInterval(function () {
                $.ajax({
                    type: "post",
                    dataType: "json",
                    url: intUrl,
                    success: function callBack(data) {
                        var map = data.map;
                        var runState = map.runState;
                        if (runState == false)   //数据未采集
                            return false;
                        var mapRegDatas = map.mapRegDatas;  //所有参数的最新数据
                        var series;
                        var shift;
                        var recDt;
                        var recVal;
                        var chartIndex;     //所在图表的下标
                        var seriesIndex;    //图表中图形的下标
                        var indexs; //<chartIndex, seriesIndex>
                        for (var i in mapRegDatas) {
                            indexs = mapRegIds.get(i + "");   //该参数对应的所有图表以及图形
                            for (var j in indexs) {
                                chartIndex = indexs[j].split("_")[0];
                                seriesIndex = indexs[j].split("_")[1];
                                series = $("#divChart_" + chartIndex).highcharts().series[seriesIndex];
                                shift = series.data.length >= dtBet;
                                recVal = mapRegDatas[i].split("_")[0];
                                recDt = mapRegDatas[i].split("_")[1];
                                series.addPoint([parseInt(recDt), parseFloat(recVal)], true, shift);
                            }
                        }
                    }
                });
            }, period);
        }

        $(window).resize(function () {
            res();
        });
        function res() {
            lWidth = document.documentElement.clientWidth - 15;
            lHeight = document.documentElement.clientHeight;
            var rowsSize = $("#ulCharts .cLi").size();
            $("#ulCharts").height(rowsSize * lHeight);
            var pHeight;
            $("#ulCharts .cLi").each(function (i) {
                $(this).children("div").width("").height(lHeight - 10);
                //pHeight = i*lHeight;
                //$(this).css({"top": pHeight, "width": lWidth});
            });
        }
        function out() {	//导出即时柱状图-单张图片
            $("#detail_bg").show();
            beCenter("waiting");
            $("#waitings").html("导出中，请稍候....");
            $("#waiting").show();
            var chart_;
            var svgs = [];
            var series,
                    listYAxis,
                    yAxis_,
                    yAxis,
                    yAxis_index;
            for (var i = 0; i < rows.length; i++) {
                series = rows[i].series;
                listYAxis = rows[i].yAxis;
                yAxis = [];
                for (var j in listYAxis) {
                    yAxis_index = parseInt(listYAxis[j].chartIndex);
                    yAxis_ = {
                        labels: {
                            format: '{value}',
                            style: {
                                fontSize: "12px",
                                color: Highcharts.getOptions().colors[yAxis_index]
                            }
                        },
                        title: {
                            text: listYAxis[j].text,
                            style: {
                                fontSize: "12px",
                                color: Highcharts.getOptions().colors[yAxis_index]
                            }
                        },
                        showEmpty: false    //隐藏此类参数时同步隐藏Y轴
                    };
                    ;
                    ;
                    ;
                    ;
                    ;
                    ;
                    ;
                    yAxis.push(yAxis_);
                }
                var regDatas = rows[i].regDatas;
                chart_ = new Highcharts.Chart({
                    chart: {
                        renderTo: "divOut",
                        width: 1100,
                        height: 900,
                        type: 'spline',
                        marginRight: 8,
                        borderColor: '#3465E4',
                        plotBorderColor: '#7E7878',
                        borderWidth: 1,
                        borderRadius: 5,
                    },
                    rangeSelector: {
                        enabled: false
                    },
                    credits: {
                        enabled: false
                    },
                    navigator: {
                        enabled: false
                    },
                    scrollbar: {
                        enabled: false
                    },
                    title: {
                        text: "实时数据：图表" + (i + 1),
                        style: {fontFamily: "微软雅黑", fontSize: "24px"}
                    },
                    legend: {
                        enabled: false
                    },
                    xAxis: {
                        type: 'datetime',
                        labels: {
                            step: 1,
                            formatter: function () {
                                return Highcharts.dateFormat('%H:%M:%S', this.value);
                            }
                        }
                    },
                    yAxis: yAxis,
                    series: series
                });
                svgs.push(chart_.getSVG());
            }
            $("#divOut").empty();
            $.ajax({
                type: 'POST', //post方式异步提交
                async: false, //同步提交
                traditional: true,
                url: "./exportNowChart", //导出图表的服务页面地址
                dataType: "json",//传递方式为json
                //几个重要的参数 如果这里不传递width的话，需要修改导出服务页面内的Request.Form["width"].ToString() 把这句代码注释掉即可
                data: {"svgs": svgs},
                success: function (msg) {
                    alert("图表导出成功!");
                    location.href = "./downloadNowContr";
                    $("#waiting").hide();
                    $("#detail_bg").hide();
                },
                error: function (errorMsg) {
                    location.href = "./downloadNowContr";
                    $("#waiting").hide();
                    $("#detail_bg").hide();
                }
            });
        }
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
    <button id="outNow" onclick="outAll()">导出所有图片</button>
</div>
<div id="detail_bg"></div>
<div id="waiting"><span id="waitings"></span></div>
<div id="divOut" style="display: block"></div>
</body>
</html>
