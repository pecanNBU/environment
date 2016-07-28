<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE HTML>
<html>
<head>
    <title>设备数据浏览</title>
    <script type="text/javascript" src="../js/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <script type="text/javascript" src="../js/Highcharts/highcharts.js"></script>
    <link type="text/css" rel="stylesheet" href="../css/cssTab.css"/>
    <link type="text/css" rel="stylesheet" href="../css/style.css"/>
    <script type="text/javascript">
        var id = request("regId");
        var dtBet = "${map.dtBet}";
        var chartType = request("chartType");
        var regName;
        var tabIndex = -1;	//所在标签	0：实时柱状图	1：实时报表
        var hisIndex = -1;	//所在标签	0：历史图表	1：历史数据
        var curIndex = 0;	//所在标签	0：实时数据	1：历史数据
        $(function () {
            $("#dtBet").val(dtBet);
            $("#chartContent > div").hide();	//Initially hide all content
            $("#chartTab .liTag a").attr("class", "aNormal");
            $("#chartTab li:first a").addClass("aCurrent");
            $("#chartContent > div:first").fadeIn();//Show first tab content
            var _thisCon;
            $("#chartTab .liTag a").bind("click", function (e) {
                e.preventDefault();
                if ($(this).hasClass("aCurrent")) {	//detection for current tab

                }
                else {
                    resetTabs();
                    $(this).addClass("aCurrent"); 	//Activate this
                    _thisCon = $($(this).attr('name'));
                    _thisCon.fadeIn(); 	//Show content for current tab
                    $("#chartTab .liCond").hide();
                    $("#" + $(this).attr('flag')).show();
                    switch (_thisCon.attr("flag")) {
                        case "tabVideo":
                            if (typeof($("#iframe0").attr("src")) == "undefined") {
                                aVideo("init");
                            }
                            curIndex = 0;
                            break;
                        case "tabNow":
                            if (typeof($("#iframe1").attr("src")) == "undefined") {
                                aNow("init");
                            }
                            curIndex = 0;
                            break;
                        case "tabHis":
                            if (typeof($("#iframe2").attr("src")) == "undefined") {
                                $("#stDt").val(getMonthDate(1));
                                $("#endDt").val(getMonthDate());
                                aHis("init");
                            }
                            curIndex = 1;
                            break;
                    }
                }
            });
            $("#chartTab a").hover(function () {
                if ($(this).attr("class") != "aCurrent") {
                    $(this).addClass("aHover");
                }
            }, function () {
                if ($(this).attr("class") != "aCurrent") {
                    $(this).removeClass("aHover")
                }
            });
            initChart();
        });
        function initChart() {
            var arrDate = [];
            var arrData1 = [];
            var arrData2 = [];
            for (var i = 0; i < 23; i++) {
                arrDate.push(i + ":00");
                ;
                ;
                ;
                ;
                ;
                ;
                ;
                arrData1.push(Math.floor(Math.random() * 30) + 50);
                arrData2.push(Math.floor(Math.random() * 50) + 10);
            }
            var chart = new Highcharts.Chart({
                chart: {
                    renderTo: 'divChart1',
                    stype: 'spline',
                    marginRight: 8,
                    borderColor: '#98d7df',
                    borderWidth: 1,
                    borderRadius: 5,
                },
                exporting: {
                    url: "../chart/export", // 配置导出路径
                    scale: 2
                },
                credits: {
                    enabled: false
                },
                title: {
                    text: "实时数据：总颗粒物(μg/m³)",
                    style: {fontFamily: "微软雅黑"}
                },
                tooltip: {
                    style: {fontFamily: "微软雅黑"}
                },
                legend: {
                    enabled: false
                },
                xAxis: {
                    categories: arrDate
                },
                yAxis: {
                    title: {
                        enabled: false
                    },
                    min: 20,
                    max: 100
                },
                series: [{
                    name: "总颗粒物(μg/m³)",
                    tooltip: {
                        valueDecimals: 1,
                        xDateFormat: '%Y-%m-%d %H:%M:%S'
                    },
                    data: arrData1
                }]
            });
            chart = new Highcharts.Chart({
                chart: {
                    renderTo: 'divChart2',
                    stype: 'spline',
                    marginRight: 8,
                    borderColor: '#98d7df',
                    borderWidth: 1,
                    borderRadius: 5,
                },
                exporting: {
                    url: "../chart/export", // 配置导出路径
                    scale: 2
                },
                credits: {
                    enabled: false
                },
                title: {
                    text: "实时数据：噪声(dB)",
                    style: {fontFamily: "微软雅黑"}
                },
                tooltip: {
                    style: {fontFamily: "微软雅黑"}
                },
                legend: {
                    enabled: false
                },
                xAxis: {
                    categories: arrDate
                },
                yAxis: {
                    title: {
                        enabled: false
                    },
                    min: 20,
                    max: 100
                },
                series: [{
                    name: "噪声(dB)",
                    tooltip: {
                        valueDecimals: 1,
                        xDateFormat: '%Y-%m-%d %H:%M:%S'
                    },
                    data: arrData2
                }]
            });
        }
    </script>
    <style>
        body {
            font-size: 15px;
            margin: 0;
        }

        ul, li {
            padding: 0;
            margin: 0;
            list-style: none;
        }

        #imgBg {
            position: absolute;
            top: 0;
            left: 0;
            width: 29%;
        }

        #imgHead {
            position: absolute;
            top: 0;
            left: 0;
            width: 29%;
            z-index: 5;
        }

        #main {
            width: 371.19px;
            height: 700px;
            color: white;
            position: absolute;
            z-index: 5;
            margin-top: 15px;
        }

        #divMain {
            padding: 20px;
        }

        #divSel span {
            width: 100px;
            border: 1px solid gray;
            border-radius: 4px;
            margin: 0;
            padding: 0;
            height: 30px;
            line-height: 30px;
            display: inline-block;
        }

        #divSel span.seled {
            background-color: white;
            color: #000;
        }

        #divBottom {
            position: absolute;
            z-index: 5;
            color: gray;
            width: 372.19px;
            background-color: white;
            height: 35px;
            line-height: 35px;
            font-size: 15px;
            left: -1px;
            bottom: 28px;
        }

        #divBottom li {
            width: 19%;
            display: inline-block;
            text-align: center;
        }

        #divChart1 {
            width: 100%;
            height: 230px;
            margin: 15px 0;
        }

        #divChart2 {
            width: 100%;
            height: 230px;
            margin: 15px 0;
        }
    </style>
</head>
<body>
<div id="main">
    <div id="divMain">
        <div id="divSel">
            <span class="seled">24小时</span>
            <span>7天</span>
            <span>30天</span>
        </div>
        <div id="divChart1"></div>
        <div id="divChart2"></div>
    </div>
    <div id="divBottom">
        <ul>
            <li style="    background-color: #6CB5CC;color: white"><span>实时</span></li>
            <li><span>地图</span></li>
            <li><span>监控</span></li>
            <li><span>报表</span></li>
            <li><span>更多</span></li>
        </ul>
    </div>
</div>
<img src="../img/app_top.png" id="imgHead">
<img src="../img/app_bg.jpg" id="imgBg">
</body>
</html>