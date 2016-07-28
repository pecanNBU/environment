<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE HTML>
<html>
<head>
    <title>实时监测曲线图</title>
    <script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <script src="../js/highstock/highstock.js"></script>
    <script src="../js/highstock/modules/exporting.js"></script>
    <script type="text/javascript">
        var name;
        var rows;
        var lHeight;
        var lWidth = document.documentElement.clientWidth - 4;
        var regDatas;	//所有参数的历史记录
        var mapRegDatas = new Map();
        var regPPName;	//例：北仑线
        var regPName;	//例：开关柜1
        var dataColos = ['#434348', '#7cb5ec', '#90ed7d', '#f7a35c', '#8085e9', '#f15c80', '#e4d354', '#8085e8', '#8d4653', '#91e8e1'];
        var regNames = [];
        var stDt = request("stDt");
        ;
        ;
        ;
        ;
        ;
        ;
        ;		//开始时间
        var endDt = request("endDt");	//结束时间
        var breakYear = parseInt(stDt.split("\\-")[0]);
        var breakMonth = parseInt(stDt.split("\\-")[1]);
        var breakDay = parseInt(stDt.split("\\-")[2]);
        window.onload = function () {
            Highcharts.setOptions({
                global: {
                    useUTC: false
                }
            });
            $("#detail_bg").show();
            beCenter("waiting");
            $("#waitings").html("数据加载中，请稍候....");
            $("#waiting").show();
            $.ajax({
                type: "post",
                dataType: "json",
                url: "json_regIds.action",
                data: "regId=" + request("id"),
                success: function callBack(data) {
                    rows = data.map.rows;
                    regPPName = data.map.regPPName;
                    regPName = data.map.regPName;
                    if (rows != null) {
                        var regIds = "";		//Ids
                        var regName;	//参数名
                        var regFlag;	//参数标志（上触头、下触头、电缆、母线）
                        var regDatas;
                        var liHtml = "";
                        var pHeight;
                        var rowsSize = rows.length;
                        var i = 0;
                        var ulSel = "<li><label style='font-size: 15px;color: red;font-weight: bold;'><input type='checkbox' value='0' onclick='selAll(this);'/>全选</label></li>";
                        //显示所有参数，让用户选择是否浏览，默认全部隐藏
                        var colorLen = dataColos.length;
                        var regColor;
                        for (var i in rows) {
                            regIds += rows[i].regId + ",";
                            if (colorLen <= parseInt(i)) {
                                regColor = randomColor();
                                dataColos.push(regColor);	//补足初始颜色
                            }
                            else
                                regColor = dataColos[i];
                            regColor = highchartsColor(regColor).get('hex');
                            ulSel += "<li><label style='color:" + regColor + ";font-weight:bold'>" +
                                    "<input type='checkbox' name='selItem' value='" + rows[i].regName + "' onclick='changeSeries()'/>" + rows[i].regName +
                                    "</label></li>";
                            regNames.push(rows[i].regName);
                        }
                        ulSel += "";
                        $("#ulSels").html(ulSel);
                        lHeight = document.documentElement.clientHeight - $("#ulSels").height() - 10;
                        liHtml = "<li id='liChart' class='cLi' style='top:5px'>" +
                                "<div id='divChart' style='width:" + lWidth + "px;height:" + lHeight + "px'></div>" +
                                "</li>";
                        $("#ulCharts").append(liHtml);
                        $("#divChart").highcharts("StockChart", {
                            chart: {
                                borderColor: '#98d7df',
                                borderWidth: 1,
                                borderRadius: 5,
                                type: "spline",
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
                                //inputEnabled: false,
                                inputDateFormat: '%Y-%m-%d'
                            },
                            credits: {
                                enabled: false
                            },
                            title: {
                                text: "历史数据统计：" + regPName,
                                style: {fontFamily: "微软雅黑"}
                            },
                            tooltip: {
                                animation: false,
                                useHTML: true,
                                formatter: function () {    //在此处可以自定义提示信息显示的样式
                                    var tooltop = "";
                                    tooltop += "<b>" + Highcharts.dateFormat('%Y-%m-%d %H:%M:%S', this.x) + "</b><br />";
                                    var value;
                                    var regName;
                                    for (var i in this.points) {
                                        value = (this.points[i].y).toFixed(2);
                                        regName = this.points[i].series.name;
                                        tooltop += "<li style='color:" + this.points[i].series.color + ";padding:0;margin:0;list-style:none'>" + regName + "：<span style='color:black;'>" + value + "</span></li>"
                                    }
                                    return tooltop;
                                }
                            },
                            xAxis: {
                                breaks: [{
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
                            yAxis: {},
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
                        regIds = regIds.substring(0, regIds.length - 1);
                        ggetCharts(regIds);
                        $("#ulCharts").css({"overflow-y": "auto", "overflow-x": "hidden", "height": lHeight});
                        $("#waiting").hide();
                        $("#detail_bg").hide();
                    }
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        };

        function ggetCharts(regIds) {	//加载完图表框架后获取所有数据，并隐藏
            var stDt_ = stDt + " 00:00:00";
            var endDt_ = endDt + " 23:59:59";
            $.ajax({
                type: "post",
                dataType: "json",
                url: "json_hisCharts.action",
                data: "regIds=" + regIds + "&stDt=" + stDt_ + "&endDt=" + endDt_,
                success: function callBack(data) {
                    var datas = data.linkedMap;
                    if (datas != null) {
                        var index = 1;
                        for (var i in datas) {
                            if (index == 1) {	//默认显示第一个参数
                                $("#ulSels input[name = selItem]:checkbox:first").attr("checked", true);
                                var chart = $("#divChart").highcharts();
                                chart.addSeries({name: i, data: datas[i], color: dataColos[0]}, true);
                            }
                            mapRegDatas.put(index + "", datas[i]);
                            index++;
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
        function liSort(arr) {
            var pHeight;
            for (var i in arr) {
                pHeight = (i % 2 == 0) ? i * lHeight : (i - 1) * lHeight;
                $("#liChart_" + arr[i]).css({"top": pHeight});
            }
        }
        $(window).resize(function () {
            res();
        });
        function res() {
            lHeight = document.documentElement.clientHeight;
            lWidth = document.documentElement.clientWidth - 4;
            var chartHeight = lHeight - 9 - $("#ulSels").height();
            $("#ulCharts").height(chartHeight);
            $("#divChart").width(lWidth).height(chartHeight);
        }
        function selAll(checkbox) {	//全选/反选所有参数
            var isChecked = checkbox.checked;
            $("#ulSels input[name = selItem]:checkbox").each(function () {
                this.checked = isChecked;
            });
            changeSeries();
        }
        function changeSeries() {	//选中参数后根据选中情况显示对应的图表
            var chart = $("#divChart").highcharts();
            var seriesLength = chart.series.length; //整个series的长度
            for (var i = 0; i < seriesLength; i++) {
                chart.series[0].remove();
            }
            //chart.redraw();
            var regData;
            var serColor;	//图表颜色
            $("#ulSels").find("input:checkbox").each(function (i) {
                if (i == 0)
                    return true;
                if ($(this).is(':checked')) {
                    regData = mapRegDatas.get(i + "");
                    chart.addSeries({name: $(this).val(), data: regData, color: dataColos[i - 1]}, true);
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
        function outAll() {	//导出历史图表-合并至word
            $("#detail_bg").show();
            beCenter("waiting");
            $("#waitings").html("导出中，请稍候....");
            $("#waiting").show();
            var chart_;
            var svgs = [];
            for (var i = 1; i <= rows.length; i++) {
                chart_ = new Highcharts.StockChart({
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
                        text: regPName + "-" + regNames[i - 1] + "(℃)",
                        style: {fontFamily: "微软雅黑", fontSize: "24px"}
                    },
                    subtitle: {
                        text: "统计时间：" + stDt + " 至 " + endDt,
                        style: {fontFamily: "微软雅黑", fontSize: "20px"},
                        x: 200	//向右偏移200像素
                    },
                    legend: {
                        enabled: false
                    },
                    xAxis: {
                        breaks: [{
                            from: Date.UTC(breakYear, breakMonth, breakDay, 0),
                            to: Date.UTC(breakYear, breakMonth, breakDay, 0)
                        }],
                        type: "datetime",
                        labels: {
                            /*step: 1,
                             formatter: function () {
                             return Highcharts.dateFormat('%H:%M:%S', this.value);
                             },*/
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
                    series: [{
                        name: regNames[i - 1],
                        tooltip: {
                            valueDecimals: 2
                        },
                        data: mapRegDatas.get(i + ""),
                        color: dataColos[i - 1]
                    }]
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
                    //alert("图表导出成功!");
                    location.href = "../chart/downloadHisWord?regId=" + request("id") + "&stDt=" + stDt + "&endDt=" + endDt;
                    //location.href = "../chart/downloadHisWord";
                    $("#waiting").hide();
                    $("#detail_bg").hide();
                },
                error: function (errorMsg) {
                    //alert(errorMsg.responseText);
                    location.href = "../chart/downloadHisWord?regId=" + request("id") + "&stDt=" + stDt + "&endDt=" + endDt;
                    //location.href = "../chart/downloadHisWord";
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

        #ulSels {
            padding: 5px 10px 0;
            margin: 0;
            list-style-type: none;
        }

        #ulSels li {
            word-wrap: break-word;
            word-break: normal;
            width: 100px;
            height: 25px;
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
    <ul id="ulSels"></ul>
    <ul id="ulCharts"></ul>
</div>
<a id="outHis" href="javascript:" onclick="outAll()" class="hide">导出数据</a>
<div id="detail_bg"></div>
<div id="waiting"><span id="waitings"></span></div>
<div id="divOut" class="hide"></div>
</body>
</html>