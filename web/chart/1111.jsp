<html>
<head>
    <title>H5页面</title>
</head>
<body>

<!--<h1 align="center">标题1(APP调用JS，使标题变成红色)</h1>-->
<script src="../js/echarts/echarts1.min.js" type="text/javascript"></script>
<script src="../js/jquery-1.8.2.min.js" type="text/javascript"></script>
<script>
    // JS调用APP(callbackHandler：要两边一致)
    function callNativeApp() {
        try {
            webkit.messageHandlers.callbackHandler.postMessage("I Love you");
        } catch (err) {
            console.log('The native context does not exist yet');
        }
    }

    // APP调用JS
    function redHeader() {
        //$("h1").css("color", "green");
        //document.querySelector('h1').style.color = "red";
    }
    $(function () {
        var option = {
            title: {
                show: false
                //text: '动态数据',
                //subtext: '纯属虚构'
            },
            tooltip: {
                trigger: 'axis',
                textStyle: {
                    fontSize: 30
                }
            },
            legend: {
                data: ['最新成交价', '预购队列'],
                textStyle: {
                    fontSize: 30
                }
            },
            toolbox: {
                show: true,
                feature: {
                    dataView: {readOnly: false},
                    restore: {},
                    saveAsImage: {}
                }
            },
            dataZoom: {
                show: false,
                start: 0,
                end: 100
            },
            xAxis: [
                {
                    type: 'category',
                    boundaryGap: true,
                    data: (function () {
                        var now = new Date();
                        var res = [];
                        var len = 10;
                        while (len--) {
                            res.unshift(now.toLocaleTimeString().replace(/^\D*/, ''));
                            now = new Date(now - 2000);
                        }
                        return res;
                    })(),
                    axisLabel: {
                        textStyle: {
                            fontSize: 16
                        }
                    }
                }
            ],
            yAxis: [
                {
                    type: 'value',
                    scale: true,
                    name: '价格',
                    max: 20,
                    min: 0,
                    boundaryGap: [0.2, 0.2],
                    nameTextStyle: {
                        fontSize: 25
                    },
                    axisLabel: {
                        textStyle: {
                            fontSize: 16
                        }
                    }
                },
                {
                    type: 'value',
                    scale: true,
                    name: '预购量',
                    max: 1200,
                    min: 0,
                    boundaryGap: [0.2, 0.2],
                    nameTextStyle: {
                        fontSize: 25
                    },
                    axisLabel: {
                        textStyle: {
                            fontSize: 16
                        }
                    }
                }
            ],
            series: [
                {
                    name: '预购队列',
                    type: 'line',
                    yAxisIndex: 1,
                    data: (function () {
                        var res = [];
                        var len = 10;
                        while (len--) {
                            res.push(Math.round(Math.random() * 1000));
                        }
                        return res;
                    })(),
                    itemStyle: {
                        normal: {
                            lineStyle: {
                                width: 4
                            }
                        }
                    }
                },
                {
                    name: '最新成交价',
                    type: 'line',
                    data: (function () {
                        var res = [];
                        var len = 0;
                        while (len < 10) {
                            res.push((Math.random() * 10 + 5).toFixed(1) - 0);
                            len++;
                        }
                        return res;
                    })(),
                    itemStyle: {
                        normal: {
                            lineStyle: {
                                width: 4
                            }
                        }
                    }
                }
            ]
        };
        var pWidth = document.documentElement.clientWidth * 0.8;
        var pHeight = document.documentElement.clientHeight * 0.8;
        $("#divChart").width(pWidth).height(pHeight);
        var domMainHumi = document.getElementById('divChart');
        var eCharts = echarts.init(domMainHumi);
        eCharts.setOption(option, true);
    });
</script>
<div id="divChart"></div>

<!--<button style="text-align:center;height:50px;width:200px;font-size:30px;" onclick="callNativeApp()">调用APP</button>-->
</body>
</html>