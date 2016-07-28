<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title></title>
    <script type="text/javascript" src="../js/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <script src="../js/highstock/highstock.js"></script>
    <script type="text/javascript">
        var regId = request("regId");
        var secLast = request("secLast");	//前秒数
        var secNow = request("secNow");		//现秒数
        var lastDt, lastData;
        var isInterval = true;
        $(function () {
            $("#divChart").height($(window).height());
            $.ajax({
                type: "post",
                dataType: "json",
                url: "nowChart1.action?regId=" + regId + "&secLast=" + secLast + "&secNow=" + secNow,
                success: function callBack(data) {
                    var map = data.map;
                    var regName = map.regName;
                    var regPName = map.regPName;
                    var unitName = map.unitName;
                    var regDatas = map.regDatas;
                    lastDt = map.lastDt;
                    lastData = map.lastData;
                    var maxValue1 = map.maxValue1;
                    var maxValue2 = map.maxValue2;
                    var xLabel;
                    if (regPName.indexOf("无线模块") > -1) {
                        xLabel = {
                            labels: {
                                enabled: false
                            }
                        };
                        ;
                        ;
                        ;
                        ;
                        ;
                        ;
                        ;
                        isInterval = false;
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
                    chart = new Highcharts.StockChart({
                        chart: {
                            renderTo: 'divChart',
                            type: 'spline',
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
                            data: regDatas,
                            id: 'dataseries'
                        }, {
                            type: 'flags',
                            data: map.flagDatas,
                            onSeries: 'dataseries',
                            shape: 'circlepin',
                            width: 16
                        }]
                    });
                }
            });
        });
        $(window).resize(function () {
            $("#divChart").height($(window).height() - 16);
        });
    </script>
    <style type="text/css">
        html, body {
            height: 100%;
            overflow: hidden
        }
    </style>
</head>
<body>
<div id="divChart"></div>
</body>
</html>