<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE HTML>
<html>
<head>
    <title>实时状态</title>
    <script src="../js/echarts/echarts.js" type="text/javascript"></script>
    <script src="../js/jquery-1.8.2.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <link href="../css/style.css" rel="stylesheet" type="text/css"/>
    <script language="javascript" type="text/javascript">
        var period;		//采样周期
        var mapCharts = new Map();  //所有的echarts对象
        $(function () {
            var regId = request("id");
            $("#detail_bg").show();
            beCenter("waiting");
            $("#waitings").html("加载中，请稍候....");
            $("#waiting").show();
            $.ajax({
                type: "post",
                dataType: "json",
                url: "json_nowStateInit.action",
                data: "regId=" + regId,
                success: function callBack(data) {
                    var rows = data.rows;
                    var nowDt = data.map.nowDt;
                    period = data.map.period;
                    if (rows == "")
                        return false;
                    var regId,      //参数Id
                            regName,    //参数名
                            unitName,   //参数单位
                            nowValue,   //当前状态
                            excepDatas; //异常情况
                    var liHtml;
                    var optionHumi,
                            domMainHumi,
                            myChartHumi;
                    var ranges; //series → min, max, axisLine.lineStyle.color
                    var seriesMin,
                            seriesMax,
                            lineColor,
                            excepVals;
                    var mapRaugeScales = new Map(); //cu
                    var gaugeScales;
                    var regIds = "";
                    for (var i in rows) { //所有参数
                        regId = rows[i].regId;
                        regIds += regId + ",";
                        regName = rows[i].regName;
                        unitName = rows[i].unitName;
                        nowValue = rows[i].nowValue;
                        excepDatas = rows[i].excepDatas;    //警报信息
                        seriesMin = rows[i].gaugeMin;
                        seriesMax = rows[i].gaugeMax;
                        ranges = transGaugeRange(excepDatas, seriesMin, seriesMax);
                        seriesMin = ranges[0][0];
                        seriesMax = ranges[0][1];
                        lineColor = ranges[1];
                        excepVals = ranges[2];
                        gaugeScales = [];
                        mapRaugeScales.put(regId + "", gaugeScales);
                        nowValue = nowValue == null ? 0 : nowValue;
                        liHtml = "<li id='liChart_" + i + "' class='cLi'><div class='divChart' id='divChart_" + i + "'></div></li>";
                        $("#ulCharts").append(liHtml);
                        optionHumi = {
                            tooltip: {
                                show: false
                                //formatter: "{a} <br/>{b}：{c} "+unitName
                            },
                            toolbox: {
                                show: false
                            },
                            series: [{
                                regId: regId,
                                name: nowDt,
                                type: 'gauge',
                                center: ['50%', '80%'],    // 默认全局居中
                                radius: [0, '80%'],
                                startAngle: 180,
                                endAngle: 0,
                                excepVals: excepVals,
                                min: seriesMin,     // 最小值
                                max: seriesMax,     // 最大值
                                precision: 0,       // 小数精度，默认为0，无小数点
                                splitNumber: 25,    // 分割段数，默认为5
                                axisLine: {         // 坐标轴线
                                    show: true,     // 默认显示，属性show控制显示与否
                                    lineStyle: {    // 属性lineStyle控制线条样式
                                        //color: [[0.2, '#F98700'],[0.55, '#49E049'],[1, '#F83636']],
                                        color: lineColor,
                                        width: 20
                                    }
                                },
                                axisTick: {            // 坐标轴小标记
                                    show: true,        // 属性show控制显示与否，默认不显示
                                    splitNumber: 2,    // 每份split细分多少段
                                    length: 6,        // 属性length控制线长
                                    lineStyle: {       // 属性lineStyle控制线条样式
                                        color: '#eee',
                                        width: 1,
                                        type: 'solid'
                                    }
                                },
                                axisLabel: {           // 坐标轴文本标签，详见axis.axisLabel
                                    formatter: function (v) {
                                        var serie = this._chartList[0].series[0];
                                        var rangeMin = serie.min;
                                        var rangeMax = serie.max;
                                        var rangeAll = rangeMax - rangeMin;
                                        var alarmColors = serie.axisLine.lineStyle.color;
                                        var dataBet;
                                        var excepVals = serie.excepVals;
                                        var regId = serie.regId;
                                        var gaugeScales;
                                        for (var i = 0; i < alarmColors.length - 1; i++) {
                                            dataBet = (v - rangeMin) / rangeAll - alarmColors[i][0];
                                            gaugeScales = mapRaugeScales.get(regId + "");
                                            if (gaugeScales == "")
                                                gaugeScales = [];
                                            dataBet = Math.abs(dataBet);
                                            if (dataBet < 0.02 && $.inArray(excepVals[i], gaugeScales) == -1) {
                                                gaugeScales.push(excepVals[i]);
                                                mapRaugeScales.put(regId + "", gaugeScales);
                                                return excepVals[i];
                                            }
                                        }
                                        return "";
                                    },
                                    textStyle: {       // 其余属性默认使用全局文本样式，详见TEXTSTYLE
                                        color: 'gray'
                                    }
                                },
                                splitLine: {        // 分隔线
                                    show: true,     // 默认显示，属性show控制显示与否
                                    length: 12,     // 属性length控制线长
                                    lineStyle: {    // 属性lineStyle（详见lineStyle）控制线条样式
                                        color: '#eee',
                                        width: 2,
                                        type: 'solid'
                                    }
                                },
                                pointer: {
                                    length: '65%',
                                    width: 6,
                                    color: 'auto'
                                },
                                title: {
                                    show: true,
                                    offsetCenter: ['0%', '37%'],       // x, y，单位px
                                    textStyle: {       // 其余属性默认使用全局文本样式，详见TEXTSTYLE
                                        color: '#333',
                                        fontSize: 17
                                    }
                                },
                                detail: {
                                    show: true,
                                    backgroundColor: 'rgba(0,0,0,0)',
                                    borderWidth: 0,
                                    borderColor: '#ccc',
                                    width: 100,
                                    height: 40,
                                    offsetCenter: ['-80%', -135],   // x, y，单位px
                                    formatter: '{value} ' + unitName,
                                    textStyle: {    // 其余属性默认使用全局文本样式，详见TEXTSTYLE
                                        color: 'auto',
                                        fontSize: 16
                                    }
                                },
                                data: [
                                    {value: nowValue, name: regName}
                                ]
                            }]
                        };
                        ;
                        ;
                        ;
                        ;
                        ;
                        ;
                        ;
                        domMainHumi = document.getElementById('divChart_' + i);
                        myChartHumi = echarts.init(domMainHumi);
                        myChartHumi.setOption(optionHumi, true);
                        mapCharts.put(regId + "", myChartHumi);
                    }
                    regIds = regIds.substring(0, regIds.length - 1);
                    //updateDatas(regIds);
                    $("#waiting").hide();
                    $("#detail_bg").hide();
                }
            });
        });
        function updateDatas(regIds) {
            var intUrl = "json_nowState.action?regIds=" + regIds;
            setInterval(function () {
                $.ajax({
                    type: "post",
                    dataType: "json",
                    url: intUrl,
                    success: function callBack(data) {
                        var runState = data.map.runState;
                        /*if(runState==false)	//未采集数据
                         return;*/
                        var rIds = regIds.split(",");
                        var datas = data.map.datas;
                        var series;
                        var shift;
                        var _chart;
                        var _option;
                        for (var i = 0; i < rIds.length; i++) {
                            _chart = mapCharts.get(rIds[i]);
                            _option = _chart.getOption();
                            _option.series[0].data[0].value = datas[i];
                            _chart.setOption(_option, true);
                        }
                    }
                });
            }, period);
        }
        function showDetail(a) {
            $("#divWindow")
                    .css({"top": 23, "left": 550})
                    .slideDown(150, function () {
                        $("#userImg").css("margin-top", $("#divWindow").height() * 0.5);
                    });
        }
        function showSwitch(a) {
            $("#divWindow")
                    .css({"top": 23, "left": 550})
                    .slideDown(150, function () {
                        $("#userImg").css("margin-top", $("#divWindow").height() * 0.5);
                    });
        }
        function transGaugeRange(excepData, seriesMin, seriesMax) {    //根据参数的异常信息,返回图表的警报界限
            var ranges = [];
            var rangeData = [];    //series的min, max
            var excepVals = [];   //所有异常值
            var rangeMin = 0;
            if (isNum(seriesMin))
                rangeMin = seriesMin;
            rangeData.push(seriesMin);      //series.min
            var excepDatas;
            if (excepData.indexOf("|") > -1)
                excepDatas = excepData.split("|");
            else
                excepDatas = excepData.split("&");
            sortArray(excepDatas);
            var logic;  //规则 → 1:＞ 2:≥ 3:＜ 4:≤
            var data;   //值
            var rangeMax = 0;
            if (isNum(seriesMax))    //已设置最大刻度
                rangeMax = seriesMax;
            else {   //未设置最大刻度, 取从最大异常值
                for (var i in excepDatas) {   //获取图表的max值
                    data = parseFloat(excepDatas[i].split("_")[1]);
                    if (rangeMax < data)
                        rangeMax = data;
                }
                rangeMax = rangeMax * 1.5;
            }
            rangeData.push(rangeMax);  //series.max
            ranges.push(rangeData);
            var rangeExcep = [];   //series.axisLine.lineStyle.color
            var excep = [];
            for (var i in excepDatas) {
                logic = parseInt(excepDatas[i].split("_")[0]);
                data = parseFloat(excepDatas[i].split("_")[1]);
                excep = [];
                excep.push((data - rangeMin) / (rangeMax - rangeMin));
                excep.push(transGaugeColor(logic));
                rangeExcep.push(excep);
                excepVals.push(data);
            }
            /*保存表盘的最后一段*/
            logic = logic <= 2 ? 3 : 1;
            excep = [];
            excep.push(1);
            excep.push(transGaugeColor(logic));
            rangeExcep.push(excep);
            ranges.push(rangeExcep);
            ranges.push(excepVals);
            return ranges;
        }
        function transGaugeColor(logic) {
            if (logic <= 2)    //＞,≥ : 返回绿色
                return "#49E049";
            else            //＜,≤ : 返回红色
                return "#F83636";
        }
        function sortArray(excepDatas) { //排序异常判断, 按数字从小到大
            excepDatas = excepDatas.sort(function (a, b) {
                return parseFloat(a.split("_")[1]) - parseFloat(b.split("_")[1]);
            });
            return excepDatas;
        }
    </script>
    <style>
        body {
            overflow-y: auto;
        }

        #divCont {
            text-align: left;
        }

        ul, li {
            padding: 0;
            margin: 0;
            list-style: none;
        }

        #liRegConds ul {

        }

        #liRegConds ul li {
            height: 300px;
            list-style: none;
            display: inline-block;
            margin-top: -95px;
        }

        #liDevConts {
            display: inline-block;
            /*padding-top: 20px;*/
        }

        #liDevConts ul li {
            float: left;
            width: 200px;
            list-style: none;
            display: block;
            padding-top: 10px;
        }

        #liDevConts ul li span.contName {
            width: 60%;
            float: left;
            text-align: right;
            font-size: 17px;
            display: inline-block;
            padding-top: 8px;
        }

        #liDevConts ul li span.contState {
            width: 40%;
            float: left;
            text-align: left;
        }

        #liDevConts ul li span.contState a {
            font-size: 15px;
            padding: 8px 12px 9px;
        }

        #divWindow div.divContent {
            background-color: #FFF;
            padding: 10px 5px;
        }

        #divWindow span.spanTitle {
            display: block;
            text-align: left;
            font-size: 18px;
            padding-bottom: 5px;
            color: #5C5C5C;
        }

        .detailContent {
            max-width: 53%;
            position: absolute;
            top: 100%;
            left: 0;
            z-index: 1020;
            display: none;
            float: left;
            min-width: 160px;
            padding: 10px 8px 0px;
            margin: 9px 0 0;
            text-align: left;
            line-height: 1.6;
            background-color: #fff;
            border: 1px solid #FFF;
            border-radius: 0;
            -webkit-background-clip: padding-box;
            background-clip: padding-box;
            -webkit-animation-duration: .15s;
            animation-duration: .15s;
            box-shadow: 0px 3px 26px rgba(0, 0, 0, .9);
            border-radius: 4px;
        }

        .detailContent .state_1 {
            color: #f58c08;
            font-weight: bold;
        }

        .detailContent .state_2 {
            color: green;
            font-weight: bold;
        }

        .detailContent .state_3 {
            color: red;
            font-weight: bold;
        }

        .divBefore:before {
            -webkit-box-sizing: border-box;
            box-sizing: border-box;
            position: absolute;
            display: block;
            content: "";
            width: 0;
            height: 0;
            border: 8px dashed transparent;
            z-index: 1;
            border-bottom-style: solid;
            border-width: 0 8px 8px;
            border-bottom-color: #FFF;
            bottom: 0;
            left: 10px;
            top: -8px;
            pointer-events: none;
        }

        .divAfter:before {
            -webkit-box-sizing: border-box;
            box-sizing: border-box;
            position: absolute;
            display: block;
            content: "";
            width: 0;
            height: 0;
            border: 8px dashed transparent;
            z-index: 1;
            border-bottom-style: solid;
            border-width: 0 8px 8px;
            left: 115px;
            pointer-events: none;
            border-bottom: none;
            border-top: 8px solid #FFF;
            top: auto;
            bottom: -8px;
        }

        #divWindow .spanDate {
            position: absolute;
            bottom: 8px;
            right: 15px;
            color: white;
        }

        #divWindow div.divCont {
            width: 250px;
            display: inline-block;
            padding: 5px 0 15px 0;
        }

        #divWindow div.divCont a {
            font-size: 16px;
            padding: 8px 12px 7px;
        }

        #ulCharts div.divChart {
            width: 280px;
            height: 300px;
        }
    </style>
</head>
<body>
<div id="divCont">
    <ul>
        <li id="liRegConds">
            <ul id="ulCharts">
            </ul>
        </li>
        <li id="liDevConts">
            <ul>
                <li>
                    <span class="contName">风机：</span>
                    <span class="contState"><a class='aBtn aGreen' href='javascript:'>正常</a></span>
                </li>
                <li>
                    <span class="contName">水泵：</span>
                    <span class="contState"><a class='aBtn aGreen' href='javascript:'>正常</a></span>
                </li>
            </ul>
        </li>
    </ul>
</div>
<div id="divWindow" class="detailContent divAfter">
    <img title="关闭" onclick="closeDiv('divWindow')" src="../img/close.png" name="Image_close"
         onmouseover="imageOver(name);" onmouseout="imageReset(name);" border="none"
         style="cursor:pointer;position:absolute;right:-15px;top:-15px;z-index:66666">
    <div align="center">
        <div>
            <span class="spanTitle" style="float: left">大棚生长监控1</span>
            <span style="float: right;padding-right: 10px;"><img src="../img/setting.png"
                                                                 style="width: 22px;padding-right: 10px;"><span
                    style="float: right">设置</span></span>
        </div>
        <div>
            <span class="spanDate">2016年2月26日 11:09:00</span>
            <img src="" style="width: 450px;border: 1px solid #44CCB9;">
        </div>
        <!--<div>
            <span class="spanTitle" style="float: left">灌溉水泵</span>
            <span style="float: right;padding-right: 10px;"><img src="../img/setting.png" style="width: 22px;padding-right: 10px;"><span style="float: right">设置</span></span>
        </div>
        <div class="divCont">
            <span>
                <a class='aBtn aDetail' href='javascript:'>运行</a>　　　
                <a class='aBtn aGray' href='javascript:'>停止</a>
            </span>
        </div>-->
    </div>
</div>
<div id="detail_bg"></div>
<div id="waiting"><span id="waitings"></span></div>
</body>
</html>