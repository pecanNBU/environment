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
    <script src="../js/Highcharts/highcharts.js"></script>
    <script src="../js/Highcharts/modules/exporting.js"></script>
    <link href="../css/button1.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript">
        var id = request("id");
        var treeType = request("treeType");
        var mapDevParas = new Map();
        var period;		//采样周期
        var lWidth = document.documentElement.clientWidth - 20;
        //var lHeight = 205;		//lichart的一半高度
        var lHeight = document.documentElement.clientHeight / 2;
        var dtBet = request("dtBet");		//取之前的数据点个数
        //var dtBet = 50;
        var chart;
        var charts = [];
        var experVolt = request("experVolt");
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
                url: "json_nowChartInit.action",
                data: "regId=" + id + "&dtBet=" + dtBet,
                success: function callBack(data) {
                    rows = data.rows;
                    if (rows != "") {
                        var regId;			//参数Id
                        var regIds = "";	//参数Ids
                        var paraEnNames = "";	//参数类别名（标记输出功率以及冷热温差）
                        var regNames = "";
                        var regUrls = "";	//关联参数Id（标记输出功率以及冷热温差的关联参数）
                        var regName;		//参数名
                        var unitName;		//参数单位
                        var regDatas;		//当前一段数据
                        var lastDts = "";	//最近时间
                        var lastDatas = "";	//最近数据
                        var lastDt = "";	//最近时间
                        var lastData = "";	//最近数据
                        var maxValue1 = "";	//异常下限
                        var maxValue2 = "";	//警报下限
                        var devParas = "";	//设备名【参数名】
                        var yMin = "";		//Y轴最小值
                        var yMax = "";		//Y轴最大值
                        var liHtml = "";
                        var pWidth, pHeight;
                        var rowsSize = rows.length;
                        var xLabel = true;
                        for (var i = 0; i < rowsSize; i++) {
                            pWidth = (i % 2 == 0) ? 0 : lWidth / 2;
                            //pHeight = (i%2==0)?i*lHeight:(i-1)*lHeight;
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
                            if (regPName.indexOf("无线模块") > -1) {
                                xLabel = {
                                    labels: {
                                        enabled: false
                                    }
                                }
                            }
                            else {
                                xLabel = {
                                    type: 'datetime',
                                    labels: {
                                        step: 1,
                                        formatter: function () {
                                            return Highcharts.dateFormat('%H:%M:%S', this.value);
                                        }
                                    }
                                }
                            }
                            devParas = regPName + "【" + regName + "】";
                            yMin = rows[i].yMin;
                            yMax = rows[i].yMax;
                            mapDevParas.put(regId + "", devParas);
                            liHtml = "<li id='liChart_" + regId + "' class='cLi'><div id='divChart_" + regId + "'></div></li>";
                            $("#ulCharts").append(liHtml);
                            $("#divChart_" + regId).width(lWidth / 2 - 5).height(lHeight - 10);
                            chart = new Highcharts.Chart({
                                chart: {
                                    renderTo: 'divChart_' + regId,
                                    stype: 'spline',
                                    marginRight: 8,
                                    borderColor: '#98d7df',
                                    borderWidth: 1,
                                    borderRadius: 5,
                                    //zoomType: "xy"
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
                                    },
                                    min: yMin,
                                    max: yMax
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
                            charts.push(chart);
                            //ggetCharts(regId);
                        }
                        regIds = regIds.substring(0, regIds.length - 1);
                        lastDts = lastDts.substring(0, lastDts.length - 1);
                        lastDatas = lastDatas.substring(0, lastDatas.length - 1);
                        paraEnNames = paraEnNames.substring(0, paraEnNames.length - 1);
                        regNames = regNames.substring(0, regNames.length - 1);
                        updateDatas(regIds, paraEnNames, regNames, regUrls, lastDts, lastDatas);
                        //$(".cLi").width(lWidth/2-15);
                        var ulHeight = rowsSize % 2 != 1 ? rowsSize * lHeight : (rowsSize + 1) * lHeight;
                        $("#ulCharts").css({"overflow-y": "auto", "overflow-x": "hidden", "height": ulHeight});
                        $("#waiting").hide();
                        $("#detail_bg").hide();
                        //$("#charts").height(document.documentElement.clientHeight+10);
                        res();
                        //jScroll();
                    }
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        };

        function updateDatas(regIds, paraEnNames, regNames, regUrls, lastDts, lastDatas) {	//动态添加数据
            var intUrl = "json_nowCharts.action?noteIds=" + regIds + "&paraEnNames=" + paraEnNames + "&regUrls=" + regUrls + "&lastDts="
                    + lastDts + "&lastDatas=" + lastDatas + "&period=" + period + "&regNames=" + regNames + "&regPName=" + regPName;
            setInterval(function () {
                $.ajax({
                    type: "post",
                    dataType: "json",
                    url: intUrl,
                    success: function callBack(data) {
                        var runState = data.map.runState;
                        if (runState == false)	//未采集数据
                            return;
                        var rIds = regIds.split(",");
                        var lastDts = data.map.lastDts;
                        var lastDatas = data.map.lastDatas;
                        var series;
                        var shift;
                        var _chart;
                        for (var i = 0; i < rIds.length; i++) {
                            _chart = $("#divChart_" + rIds[i]).highcharts();
                            if (_chart.series.length > 0) {
                                series = _chart.series[0];
                                shift = series.data.length >= dtBet;
                            }
                            else
                                shift = false;
                            var dt = lastDts[i];
                            var data = lastDatas[i].y;
                            series.addPoint([dt, data], true, shift);
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
            lHeight = document.documentElement.clientHeight / 2;
            var rowsSize = $("#ulCharts .cLi").size();
            var totalHeight = rowsSize % 2 == 1 ? (rowsSize + 1) * lHeight / 2 : rowsSize * lHeight / 2;
            $("#charts, #ulCharts").height(totalHeight);
            var pHeight;
            $("#ulCharts .cLi").each(function (i) {
                $(this).width(lWidth / 2 - 5);//.height(lHeight*2);
                $(this).find(">div").width("").height(lHeight - 10);
                //if($(this).css("left")!="0px")
                //    $(this).css("left", lWidth/2+2);
                //pHeight = (i%2==0)?i*lHeight/2:(i-1)*lHeight/2;
                //$(this).css("top", pHeight);
            });
        }
        function out() {	//导出即时柱状图-单张图片
            $("#detail_bg").show();
            beCenter("waiting");
            $("#waitings").html("导出中，请稍候....");
            $("#waiting").show();
            var chart_;
            var svgs = [];
            for (var i = 0; i < rows.length; i++) {
                var regName = rows[i].regName;
                var unitName = rows[i].unitName;
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
                        text: "实时数据：" + regName + "(" + unitName + ")",
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
                    yAxis: {
                        labels: {
                            style: {
                                fontFamily: "微软雅黑",
                                color: "#000000",
                                fontSize: 16 //刻度字体大小
                            }
                        },
                        gridLineColor: "#b5b5b5"
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
                    location.href = "./downloadChartWord";
                    $("#waiting").hide();
                    $("#detail_bg").hide();
                },
                error: function (errorMsg) {
                    //alert(errorMsg.responseText);
                    location.href = "./downloadChartWord";
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
<button id="openWindow" onclick="windowTest()" class="dNone">测试</button>
<div id="charts">
    <ul id="ulCharts">
    </ul>
</div>
<div id="detail_bg"></div>
<div id="waiting"><span id="waitings"></span></div>
<div id="divOut" class="hide"></div>
</body>
</html>
