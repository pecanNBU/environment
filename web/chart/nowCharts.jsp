<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title></title>
    <script type="text/javascript" src="../js/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <script src="../js/highcharts/highcharts.js"></script>
    <!-- <script src="../js/highcharts/modules/exporting.js"></script> -->
    <script type="text/javascript">
        var period = request("period");
        var isRun = request("isRun");
        var regId = request("regId");
        var dtBet = request("dtBet");
        var dtBet1 = request("dtBet1");
        var lastDt, lastData;
        var isInterval = true;
        $(function () {
            $("#divChart").height($(window).height());
            //var devParas = window.opener.mapDevParas.get(regId+"");
            //this.title="实时监测："+devParas;
            $.ajax({
                type: "post",
                dataType: "json",
                url: "nowChart.action?regId=" + regId + "&period=" + period + "&dtBet=" + dtBet + "&dtBet1=" + dtBet1,
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
                    $("#divChart").highcharts({
                        credits: {
                            enabled: false
                        },
                        title: {
                            text: "实时数据：" + regName + "(" + unitName + ")"/* ,
                             style: {fontFamily: "微软雅黑"} */
                        },
                        tooltip: {
                            //style: {fontFamily: "微软雅黑"}
                        },
                        legend: {
                            enabled: false
                        },
                        xAxis: xLabel,
                        yAxis: {
                            title: {
                                text: regName + "(" + unitName + ")",
                                style: {fontFamily: "微软雅黑"}
                            }
                        },
                        series: [{
                            /* name : regName+"("+unitName+")",
                             tooltip: {
                             valueDecimals: 2
                             }, */
                            data: regDatas
                        }],
                        chart: {
                            /* type: 'spline', */
                            marginRight: 8/* ,
                             zoomType: "xy" */
                        },
                    });
                    if (isInterval)
                        updateData(regId);	//更新数据
                }
            });
            //$("#liChart_"+regId, window.opener.document).remove();
        });
        function updateData(regId) {	//动态添加数据
            var intUrl = "json_nowChart.action?regId=" + regId + "&lastDt=" + lastDt + "&lastData=" + lastData + "&period=" + period;
            var period1 = period < 1000 ? 2000 : period;	//小于1秒按2秒计
            setInterval(function () {
                if (isRun == 1) {
                    $.ajax({
                        type: "post",
                        dataType: "json",
                        url: intUrl,
                        success: function callBack(data) {
                            var lastDts = data.map.lastDts.split(",");
                            var lastDatas = data.map.lastDatas.split(",");
                            lastDt = data.map.lastDt;
                            lastData = data.map.lastData;
                            var series = $("#divChart").highcharts().series[0];
                            var shift;
                            if (period >= 1000) {
                                shift = series.data.length >= dtBet;
                                var dt = parseInt(lastDts + "");
                                var data = parseFloat(lastDatas + "");
                                series.addPoint([dt, data], true, shift);
                            }
                            else {
                                var dts, datas;
                                var dLength;
                                dts = [];
                                dLength = series.data.length;
                                for (var j = 0; j < lastDts.length; j++) {
                                    shift = (dLength + j) >= dtBet;
                                    if (j < lastDts.length - 1)
                                        series.addPoint([parseInt(lastDts[j]), parseFloat(lastDatas[j])], false, shift);
                                    else
                                        series.addPoint([parseInt(lastDts[j]), parseFloat(lastDatas[j])], true, shift);
                                }
                            }
                        }
                    });
                }
            }, period1);
        }
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