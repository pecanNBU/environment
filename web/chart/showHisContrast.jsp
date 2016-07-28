<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE HTML>
<html>
<head>
    <title>历史同比图表</title>
    <script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <script type="text/javascript" src="../js/highstock/highstock.js"></script>
    <script type="text/javascript" src="../js/highstock/modules/exporting.js"></script>
    <script type="text/javascript">
        var name;
        var rows;
        var lHeight = _height();
        var lWidth = _width() - 4;
        var regDatas;	//所有参数的历史记录
        var mapRegDatas = new Map();
        var regPName;	//例：开关柜1
        var dataColors = ['#7cb5ec', '#88D688', '#f7a35c', '#8085e9', '#f15c80', '#e4d354', '#8085e8', '#8d4653', '#91e8e1'];
        //颜色 - 原图
        var dataColors_ = ['#729BB3', '#008000', '#B77804', '#4C43E0', '#B96C6C', '#9E9E0C', '#662FAF', '#4A242B', '#6AA5A0'];
        //颜色 - 同比
        //var regNames = new Array();
        var chart;  //图表对象
        var mapParaIndex = new Map();   //参数类型Id → 对应下标
        var mapSeriesNames = new Map(); //图表Index_图像Index → 监测点名+参数名
        var regIds = request("regIds");
        var stDt = request("stDt");		//开始时间
        var endDt = request("endDt");	//结束时间
        var stDtContr = request("stDtContr");   //同比开始时间
        var chartType = request("chartType");   //图表类型 → 1:趋势图   2:柱状图
        var hisInter = request("hisInter");     //时间间隔 → 1:天 2:月 3:年
        var timeBet;    //开始时间与同比时间的时间差
        var breakYear = parseInt(stDt.split("\\-")[0]);
        var breakMonth = parseInt(stDt.split("\\-")[1]);
        var breakDay = parseInt(stDt.split("\\-")[2]);
        var stContr;    //历史同比-开始时间
        var endContr;   //历史同比-结束时间
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
            $("#waitings").html("数据加载中，请稍候....");
            $("#waiting").show();
            $.ajax({
                type: "post",
                dataType: "json",
                url: "json_regIds_contr.action",
                data: "regIds=" + regIds + "&stDt=" + stDt + "&endDt=" + endDt + "&stDtContr=" + stDtContr,
                success: function callBack(data) {
                    rows = data.map.rows;
                    if (rows == null)
                        return false;
                    var paraTypes = data.map.paraTypes;
                    timeBet = data.map.timeBet;
                    var mapParaNames = new Map();
                    for (var i in paraTypes) {
                        mapParaNames.put(i + "", paraTypes[i]);
                    }
                    //var regIds = "";    //Ids
                    var chartDatas;
                    var ulSel;      //参数选择框
                    var colorLen;   //颜色总数
                    var regColor;   //参数颜色
                    var divHeight;  //图表高度
                    var paraTypeId1, paraTypeId2;
                    var yAxis = [];    //Y轴配置
                    var yAxis_;
                    var index = 0;
                    var cType = chartType == 1 ? "spline" : "column";
                    for (var i in rows) {
                        chartDatas = rows[i];
                        paraTypeId1 = "";
                        paraTypeId2 = "";
                        //index = 0;
                        for (var j in chartDatas) {
                            paraTypeId1 = chartDatas[j].paraTypeId;
                            if (paraTypeId1 != paraTypeId2) {
                                yAxis_ = {
                                    labels: {
                                        format: '{value}',
                                        style: {
                                            fontSize: "12px",
                                            color: dataColors[j]
                                        }
                                    },
                                    title: {
                                        text: mapParaNames.get(paraTypeId1 + ""),
                                        style: {
                                            fontSize: "12px",
                                            color: dataColors[j]
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
                                mapParaIndex.put(i + "_" + paraTypeId1, index);
                                index++;
                                paraTypeId2 = paraTypeId1;
                            }
                        }
                        ulSel = "<li><label style='font-size: 15px;color: red;font-weight: bold;'><input type='checkbox' value='0' onclick='selAll(this);'/>全选</label></li>";
                        //显示所有参数，让用户选择是否浏览，默认全部隐藏
                        colorLen = dataColors.length;
                        regColor;
                        for (var j in chartDatas) {
                            //regIds += chartDatas[j].regId + ",";
                            if (colorLen <= parseInt(j)) {
                                regColor = randomColor();
                                dataColors.push(regColor);	//补足初始颜色
                            }
                            else
                                regColor = dataColors[j];
                            regColor = highchartsColor(regColor).get('hex');
                            ulSel += "<li><label style='color:" + regColor + ";font-weight:bold'>" +
                                    "<input type='checkbox' name='selItem' flagId='" + chartDatas[j].paraTypeId + "' value='" + chartDatas[j].regName + "' onclick='changeSeries(this)'/>" + chartDatas[j].regName +
                                    "</label></li>";
                            //regNames.push(chartDatas[j].regName);
                            mapSeriesNames.put(i + "_" + j, chartDatas[j].regName);
                        }
                        liHtml = "<li id='liChart_" + i + "' class='cLi'>" +
                                "<ul id='divSels_" + i + "' class='ulSels'></ul>" +
                                "<div id='divChart_" + i + "' class='divChart'></div>" +
                                "</li>";
                        $("#ulCharts").append(liHtml);
                        $("#divSels_" + i).html(ulSel);
                        divHeight = lHeight - $("#divSels_" + i).height() - 14;
                        $("#divChart_" + i).width(lWidth).height(divHeight);
                        chart = $("#divChart_" + i).highcharts("StockChart", {
                            chart: {
                                borderColor: '#98d7df',
                                borderWidth: 1,
                                borderRadius: 5,
                                type: cType,
                                zoomType: "xy"
                            },
                            rangeSelector: {
                                //enabled : false
                                buttons: [{
                                    type: 'hour',
                                    count: 1,
                                    text: '小时'
                                }, {
                                    type: 'day',
                                    count: 1,
                                    text: '天'
                                }, {
                                    type: 'month',
                                    count: 1,
                                    text: '月'
                                }, {
                                    type: 'all',
                                    count: 1,
                                    text: '全部'
                                }],
                                selected: 2,
                                inputEnabled: false,
                                //inputDateFormat: '%Y-%m-%d'
                            },
                            credits: {
                                enabled: false
                            },
                            title: {
                                text: "历史同比：图表" + (parseInt(i) + 1),
                                style: {fontFamily: "微软雅黑"}
                            },
                            tooltip: {
                                animation: false,
                                useHTML: true,
                                formatter: function () {    //在此处可以自定义提示信息显示的样式
                                    var tooltop = "";
                                    tooltop += "<b style='font-size: 13px;'>" + Highcharts.dateFormat('%Y-%m-%d %H:%M:%S', this.x) + "</b><br />";
                                    var value;
                                    var regName;
                                    var htmlNow = "",   //当前参数
                                            htmlContr = ""; //同比参数
                                    htmlNow += "<b style='font-size: 13px;'>" + Highcharts.dateFormat('%Y-%m-%d %H:%M:%S', this.x) + "</b><br />";
                                    if (timeBet != 0)
                                        htmlContr += "<b style='font-size: 13px;'>" + Highcharts.dateFormat('%Y-%m-%d %H:%M:%S', (this.x - timeBet)) + "</b><br />";
                                    for (var i in this.points) {
                                        value = this.points[i].y;
                                        regName = this.points[i].series.name;
                                        if (regName.indexOf("原图") > -1) {
                                            htmlNow += "<li style='color:" + this.points[i].series.color + ";padding:0;margin:0;list-style:none;font-size: 13px'>" +
                                                    "<span style='font-weight: bold'>" + regName + "：</span>" +
                                                    "<span style='color:black;'>" + value + "</span>" +
                                                    "</li>";
                                        }
                                        else {
                                            htmlContr += "<li style='color:" + this.points[i].series.color + ";padding:0;margin:0;list-style:none;font-size: 13px'>" +
                                                    "<span style='font-weight: bold'>" + regName + "：</span>" +
                                                    "<span style='color:black;'>" + value + "</span>" +
                                                    "</li>";
                                        }
                                    }
                                    tooltop = htmlNow + htmlContr;
                                    return tooltop;
                                }
                            },
                            xAxis: {
                                breaks: [{  //横坐标默认取一个月内的范围
                                    from: Date.UTC(breakYear, breakMonth, breakDay, 0),
                                    to: Date.UTC(breakYear, breakMonth, breakDay, 0)
                                }],
                                type: 'datetime',
                                labels: {
                                    //step: 1,
                                    formatter: function () {
                                        return Highcharts.dateFormat('%m-%d', this.value);
                                    }
                                }
                            },
                            yAxis: yAxis,
                            navigator: {
                                xAxis: {
                                    type: 'datetime',
                                    labels: {
                                        formatter: function () {
                                            return Highcharts.dateFormat('%m-%d', this.value);
                                        }
                                    }
                                },
                            }
                        });
                    }
                    //regIds = regIds.substring(0, regIds.length-1);
                    $("#ulCharts").css({"overflow-y": "auto", "overflow-x": "hidden"});
                    $("#waiting").hide();
                    $("#detail_bg").hide();
                    ggetCharts();
                    res();
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        };

        function ggetCharts() {	//加载完图表框架后获取所有数据，并隐藏
            var stDt_ = stDt + " 00:00:00";
            var endDt_ = endDt + " 23:59:59";
            var stDtContr_ = stDtContr == "" ? "" : stDtContr + " 00:00:00";
            $.ajax({
                type: "post",
                dataType: "json",
                url: "json_hisCharts_contr.action",
                data: "regIds=" + regIds + "&stDt=" + stDt_ + "&endDt=" + endDt_ + "&stDtContr=" + stDtContr_ + "&hisInter=" + hisInter,
                success: function callBack(data) {
                    var datasAll = data.map.allDatas;
                    if (stDtContr != "") {
                        stContr = data.map.stContr;
                        endContr = data.map.endContr;
                    }
                    if (datasAll != null) {
                        var datas;
                        var paraTypeId; //参数类型Id
                        var yAxisIndex; //对应的Y轴
                        var chart;      //图表对象
                        var dataIndex;
                        var seriesName;
                        var seriesColor;
                        for (var i in datasAll) {     //遍历所有的图表
                            datas = datasAll[i];
                            for (var j in datas) {    //遍历单张图表的参数
                                dataIndex = j.split("_")[0];
                                if (dataIndex == 0) {   //每张图表默认显示第一个参数
                                    $("#divSels_" + i).find("input[name = selItem]:checkbox:first").attr("checked", true);
                                    paraTypeId = $("#divSels_" + i).find("input[name = selItem]:checkbox:first").attr("flagId");
                                    yAxisIndex = mapParaIndex.get(i + "_" + paraTypeId);
                                    chart = $("#divChart_" + i).highcharts();
                                    seriesName = mapSeriesNames.get(i + "_" + dataIndex).replace("：", "-");
                                    seriesColor = dataColors[0];
                                    if (stDtContr != "" && j == "0")
                                        seriesName += "<span style='color:red'>(原图)</span>";
                                    if (j != "0") {
                                        seriesName += "<span style='color:red'>(同比)</span>";
                                        seriesColor = dataColors_[0];
                                    }
                                    chart.addSeries({
                                        name: seriesName,
                                        data: datas[j],
                                        color: seriesColor,
                                        yAxis: yAxisIndex
                                    }, true);
                                }
                                mapRegDatas.put(i + "_" + j, datas[j]);
                            }
                        }
                    }
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        }

        function saveChart(type) {
            var pHeight;
            lHeight = 225;
            for (var i = 0; i < rows.length; i++) {
                pHeight = (i % 2 == 0) ? i * lHeight : (i - 1) * lHeight;
                $("#liChart_" + rows[i].regId).css("top", pHeight);
                var regId = rows[i].regId;
                var chart = getChartFromId("ChartId" + regId);   //生成的FusionCharts图表本身的标识
                $("#divFcexp_" + regId).show();
                var name = rows[i].name;
                if (chart.hasRendered()) {
                    chart.exportChart({exportAtClient: '1', exportFormat: type, exportFileName: name});
                } else {
                    alert("图片加载未完成，请稍后再试");
                }
            }
            var liCount = $("#charts .cLi").length;
        }
        $(window).resize(function () {
            res();
        });
        function res() {
            lWidth = document.documentElement.clientWidth;
            lHeight = document.documentElement.clientHeight;
            var heightCli;
            $("#ulCharts li.cLi").each(function (i) {
                $(this).width(lWidth - 4);
                heightCli = $(this).children("ul").height();
                $(this).find(">div").width("").height(lHeight - heightCli - 14);
            });
        }
        function selAll(checkbox) {	//全选/反选所有参数
            var isChecked = checkbox.checked;
            $(checkbox).closest("ul").find("input[name = selItem]:checkbox").each(function () {
                this.checked = isChecked;
                if (isChecked)
                    changeSeries(this);
            });
            if (!isChecked) { //隐藏对应图表中所有的图像
                var chart = $(checkbox).closest("ul").next("div").highcharts();
                var seriesLength = chart.series.length; //整个series的长度
                for (var i = 0; i < seriesLength; i++) {
                    chart.series[0].remove();   //  清空图表
                }
            }
        }
        function changeSeries(input) {	//选中参数后根据选中情况显示对应的图表
            var chart = $(input).closest("ul").next("div").highcharts();
            var chartIndex = $(input).closest("li.cLi").prev("li").length;
            var seriesLength = chart.series.length; //整个series的长度
            for (var i = 0; i < seriesLength; i++) {
                chart.series[0].remove();   //  清空图表
            }
            var regData;
            var paraTypeId; //参数类型Id
            var yAxisIndex; //对应的Y轴
            $(input).closest("ul").find("input:checkbox").each(function (i) {
                if (i == 0)
                    return true;
                if ($(this).is(':checked')) {
                    regData = mapRegDatas.get(chartIndex + "_" + (i - 1));
                    paraTypeId = $(this).attr("flagId");
                    yAxisIndex = mapParaIndex.get(chartIndex + "_" + paraTypeId);
                    var serirsName = $(this).val().replace("：", "-");
                    var seriesColor = dataColors[i - 1];
                    if (stDtContr != "")   //存在同比
                        serirsName += "<span style='color:red'>(原图)</span>";
                    chart.addSeries({name: serirsName, data: regData, color: seriesColor, yAxis: yAxisIndex}, true);
                    regData = mapRegDatas.get(chartIndex + "_" + (i - 1) + "_contr");
                    if (regData != "") {  //存在同比数据
                        seriesColor = dataColors_[i - 1];
                        serirsName = $(this).val().replace("：", "-") + "<span style='color:red'>(同比)</span>";
                        chart.addSeries({name: serirsName, data: regData, color: seriesColor, yAxis: yAxisIndex}, true);
                    }
                }
            });
        }
        function randomColor() {	//生成随机色
            var str = Math.ceil(Math.random() * 16777215).toString(16);
            if (str.length < 6) {
                str = "0" + str;
            }
            return "#" + str;
        }

        var rgbaRegEx = /rgba\(\s*([0-9]{1,3})\s*,\s*([0-9]{1,3})\s*,\s*([0-9]{1,3})\s*,\s*([0-9]?(?:\.[0-9]+)?)\s*\)/,
                hexRegEx = /#([a-fA-F0-9]{2})([a-fA-F0-9]{2})([a-fA-F0-9]{2})/,
                rgbRegEx = /rgb\(\s*([0-9]{1,3})\s*,\s*([0-9]{1,3})\s*,\s*([0-9]{1,3})\s*\)/;

        var highchartsColor = function (input) {
            var rgba = [], result, stops;

            function init(input) {
                // Gradients
                if (input && input.stops) {
                    stops = map(input.stops, function (stop) {
                        return Color(stop[1]);
                    });
                    // Solid colors
                } else {
                    // rgba
                    result = rgbaRegEx.exec(input);
                    if (result) {
                        rgba = [pInt(result[1]), pInt(result[2]), pInt(result[3]), parseFloat(result[4], 10)];
                    } else {
                        // hex
                        result = hexRegEx.exec(input);
                        if (result) {
                            rgba = [pInt(result[1], 16), pInt(result[2], 16), pInt(result[3], 16), 1];
                        } else {
                            // rgb
                            result = rgbRegEx.exec(input);
                            if (result) {
                                rgba = [pInt(result[1]), pInt(result[2]), pInt(result[3]), 1];
                            }
                        }
                    }
                }
            }

            function get(format) {
                var ret;
                if (stops) {
                    ret = merge(input);
                    ret.stops = [].concat(ret.stops);
                    each(stops, function (stop, i) {
                        ret.stops[i] = [ret.stops[i][0], stop.get(format)];
                    });
                } else if (rgba && !isNaN(rgba[0])) {
                    if (format === 'rgb')
                        ret = 'rgb(' + rgba[0] + ',' + rgba[1] + ',' + rgba[2] + ')';
                    else if (format === 'a')
                        ret = rgba[3];
                    else
                        ret = 'rgba(' + rgba.join(',') + ')';
                } else
                    ret = input;
                return ret;
            }

            function brighten(alpha) {
                if (stops) {
                    each(stops, function (stop) {
                        stop.brighten(alpha);
                    });
                } else if (isNumber(alpha) && alpha !== 0) {
                    var i;
                    for (i = 0; i < 3; i++) {
                        rgba[i] += pInt(alpha * 255);
                        if (rgba[i] < 0)
                            rgba[i] = 0;
                        if (rgba[i] > 255)
                            rgba[i] = 255;
                    }
                }
                return this;
            }

            function setOpacity(alpha) {
                rgba[3] = alpha;
                return this;
            }

            init(input);
            return {
                get: get,
                brighten: brighten,
                rgba: rgba,
                setOpacity: setOpacity
            };
        };
        function pInt(s, mag) {
            return parseInt(s, mag || 10);
        }
        function out() {	//导出历史图表-合并至word
            $("#detail_bg").show();
            beCenter("waiting");
            $("#waitings").html("导出中，请稍候....");
            $("#waiting").show();
            var chart_;
            var svgs = [];
            var cType = chartType == 1 ? "spline" : "column";
            var series = [];
            var serie;
            var regData;
            var subTitle = "统计时间：" + stDt + " 至 " + endDt;    //副标题
            if (mapRegDatas.get("0_0_contr") != null) {   //包含历史同比
                subTitle += "同比时间：" + stContr + " 至 " + endContr;
            }
            for (var i = 0; i <= rows.length; i++) {
                series = [];
                regData = mapRegDatas.get("0_" + i);
                serie = {
                    name: mapSeriesNames.get("0_" + i) + "(当前)",
                    tooltip: {
                        valueDecimals: 2
                    },
                    data: regData,
                    color: dataColors[i]
                };
                series.push(serie);
                regData = mapRegDatas.get("0_" + i + "_contr");
                if (regData != null) {
                    serie = {
                        name: mapSeriesNames.get("0_" + i) + "(同比)",
                        tooltip: {
                            valueDecimals: 2
                        },
                        data: regData,
                        color: dataColors_[i + 1]
                    };
                    series.push(serie);
                }
                chart_ = new Highcharts.StockChart({
                    chart: {
                        renderTo: "divOut",
                        width: 1100,
                        height: 900,
                        type: cType,
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
                        text: "历史同比：" + mapSeriesNames.get("0_" + i),
                        style: {fontFamily: "微软雅黑", fontSize: "24px"}
                    },
                    subtitle: {
                        text: subTitle,
                        style: {fontFamily: "微软雅黑", fontSize: "20px"},
                        //x: 200	//向右偏移200像素
                    },
                    legend: {
                        enabled: true
                    },
                    xAxis: {
                        breaks: [{
                            from: Date.UTC(breakYear, breakMonth, breakDay, 0),
                            to: Date.UTC(breakYear, breakMonth, breakDay, 0)
                        }],
                        type: "datetime",
                        labels: {
                            style: {
                                color: "#000000",
                                fontSize: 16 //刻度字体大小
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
                    series: series
                });
                svgs.push(chart_.getSVG());
            }
            $("#divOut").empty();
            $.ajax({
                type: 'POST', //post方式异步提交
                async: false, //同步提交
                traditional: true,
                url: "../chart/exportHisCharts", //导出图表的服务页面地址
                dataType: "json",//传递方式为json
                //几个重要的参数 如果这里不传递width的话，需要修改导出服务页面内的Request.Form["width"].ToString() 把这句代码注释掉即可
                data: {"svgs": svgs},
                success: function (msg) {
                    location.href = "../chart/downloadHisContr?stDt=" + stDt + "&endDt=" + endDt;
                    $("#waiting").hide();
                    $("#detail_bg").hide();
                },
                error: function (errorMsg) {
                    location.href = "../chart/downloadHisContr?stDt=" + stDt + "&endDt=" + endDt;
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
            margin: 2px;
            padding: 0;
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
            overflow-y: hidden;
            overflow-x: hidden;
            width: 100%;
            position: relative;
        }

        .ulSels {
            padding: 5px 10px;
            margin: 0;
            list-style-type: none;
        }

        .ulSels li {
            word-wrap: break-word;
            word-break: normal;
            margin-right: 20px;
            list-style-type: none;
            display: inline-block;
            display: -moz-inline-stack;
            *display: inline;
            zoom: 1;
            vertical-align: top;
        }

        .hide {
            display: none;
        }
    </style>
</head>
<body>
<div id="charts">
    <ul id="ulCharts"></ul>
</div>
<div id="detail_bg"></div>
<div id="waiting"><span id="waitings"></span></div>
<div id="divOut" class="hide"></div>
</body>
</html>