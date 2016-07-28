<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE HTML>
<html>
<head>
    <title>实时状态</title>
    <script src="../js/echarts/echarts.min.js" type="text/javascript"></script>
    <script src="../js/jquery-1.8.2.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <link href="../css/style.css" rel="stylesheet" type="text/css"/>
    <script language="javascript" type="text/javascript">
        var period;     //采样周期
        var eCharts;    //eCharts对象
        var vIndex = -1;//所有刻度的序号
        var rowsSize;   //参数总数
        var regId = request("id");
        $(function () {
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
                    var rows = data.map.rows;
                    var nowDt = data.map.nowDt;
                    period = data.map.period;
                    if (rows == "")
                        return false;
                    var regId,      //参数Id
                            regName,    //参数名
                            unitName,   //参数单位
                            nowValue,   //当前状态
                            excepDatas; //异常情况
                    var optionHumi;
                    var ranges; //series → min, max, axisLine.lineStyle.color
                    var seriesMin,
                            seriesMax,
                            lineColor;
                    var regIds = "";
                    var optionSeriess = [];
                    var series;
                    rowsSize = rows.length;
                    var seriesHeight = 140 * (parseInt(rowsSize / 4) + 1 + (rowsSize % 4 == 0 ? 0 : 1));
                    ;
                    ;
                    ;
                    ;
                    ;
                    ;
                    ;
                    var pHeight = _height();
                    var pWidth = _width();    //页面宽度
                    $("#divChart").width(pWidth).height(seriesHeight);
                    var roundXs = ["15%", "39%", "62%", "85%"];  //圆心坐标 - X轴
                    var roundX, roundY;
                    var splitNumber = 10;   //刻度总数
                    var radius = pWidth / 8 - 30;    //圆半径
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
                        nowValue = nowValue == null ? 0 : nowValue;
                        roundX = roundXs[i % 4];
                        roundY = transRoundY(parseInt(i), rowsSize);
                        series = {
                            name: nowDt,
                            type: 'gauge',
                            center: [roundX, roundY],    // 默认全局居中
                            radius: radius,
                            startAngle: 180,
                            endAngle: 0,
                            min: seriesMin,     // 最小值
                            max: seriesMax,     // 最大值
                            precision: 0,       // 小数精度，默认为0，无小数点
                            splitNumber: splitNumber,    // 分割段数，默认为5
                            axisLine: {         // 坐标轴线
                                show: true,     // 默认显示，属性show控制显示与否
                                lineStyle: {    // 属性lineStyle控制线条样式
                                    //color: [[0.2, '#F98700'],[0.55, '#49E049'],[1, '#F83636']],
                                    color: lineColor,
                                    width: 15
                                }
                            },
                            axisTick: {            // 坐标轴小标记
                                show: true,        // 属性show控制显示与否，默认不显示
                                splitNumber: 5,    // 每份split细分多少段
                                length: 8,        // 属性length控制线长
                                lineStyle: {       // 属性lineStyle控制线条样式
                                    color: '#eee',
                                    width: 1,
                                    type: 'solid'
                                }
                            },
                            axisLabel: {           // 坐标轴文本标签，详见axis.axisLabel
                                formatter: function (v) {
                                    vIndex++;
                                    if ((vIndex % 11) % 2 == 0)    //间隔2个刻度显示
                                        return v + "";
                                    else
                                        return "";
                                },
                                textStyle: {       // 其余属性默认使用全局文本样式，详见TEXTSTYLE
                                    color: 'gray'
                                }
                            },
                            splitLine: {        // 分隔线
                                show: true,     // 默认显示，属性show控制显示与否
                                length: 20,     // 属性length控制线长
                                lineStyle: {    // 属性lineStyle（详见lineStyle）控制线条样式
                                    color: '#eee',
                                    width: 2,
                                    type: 'solid'
                                }
                            },
                            pointer: {
                                length: '70%',
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
                                offsetCenter: ['-80%', -120],   // x, y，单位px
                                formatter: '{value} ' + unitName,
                                textStyle: {    // 其余属性默认使用全局文本样式，详见TEXTSTYLE
                                    color: 'auto',
                                    fontSize: 16
                                }
                            },
                            data: [
                                {value: nowValue, name: regName}
                            ]
                        };
                        ;
                        ;
                        ;
                        ;
                        ;
                        ;
                        ;
                        optionSeriess.push(series);
                    }
                    optionHumi = {
                        tooltip: {
                            formatter: "{a} <br/>{b} : {c}%"
                        },
                        toolbox: {
                            show: false
                        },
                        series: optionSeriess
                    };
                    ;
                    ;
                    ;
                    ;
                    ;
                    ;
                    ;
                    var domMainHumi = document.getElementById('divChart');
                    eCharts = echarts.init(domMainHumi);
                    eCharts.setOption(optionHumi, true);
                    regIds = regIds.substring(0, regIds.length - 1);
                    //updateDatas(regIds);
                    var regSwitchs = data.map.regSwitchs;    //设备控制信息
                    if (regSwitchs) {
                        var htmlConts = "<ul>";
                        var switchId,
                                switchName,
                                switchValue;
                        var switchStates;   //开关量状态 → [按钮颜色, 按钮文字]
                        for (var i in regSwitchs) {
                            switchId = regSwitchs[i].switchId;
                            switchName = regSwitchs[i].switchName;
                            switchValue = regSwitchs[i].switchValue;
                            switchStates = transSwitchState(switchValue);
                            htmlConts += "<li>" +
                                    "<span class='contName'>" + switchName + "：</span>" +
                                    "<span class='contState'>" +
                                    "<a class='aBtn " + switchStates[0] + "' href='javascript:' " +
                                    "onclick='regSwitch(" + switchId + ",\"" + switchName + "\"," + switchValue + ", this)' " +
                                    "value='" + switchValue + "'>" + switchStates[1] + "</a>" +
                                    "</span>" +
                                    "</li>";
                        }
                        htmlConts += "<ul>";
                        $("#liDevConts").html(htmlConts);
                    }
                    //res();
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
                        vIndex = -1;
                        var rIds = regIds.split(",");
                        var datas = data.map.datas;
                        var nowDt = data.map.nowDt;
                        var _chart = eCharts;
                        var _option = _chart.getOption();
                        for (var i = 0; i < rIds.length; i++) {
                            _option.series[i].data[0].value = parseFloat(datas[i]);
                            _option.series[i].name = nowDt;
                            _chart.setOption(_option, true);
                        }
                    }
                });
            }, period);
        }
        $(window).resize(function () {
            res();
        });
        function res() {
            if (typeof(eCharts) == "undefined")
                return;
            var seriesHeight = 140 * (parseInt(rowsSize / 4) + 1 + (rowsSize % 4 == 0 ? 0 : 1));
            ;
            ;
            ;
            ;
            ;
            ;
            ;
            var pWidth = _width();    //页面宽度
            $("#divChart").width(pWidth).height(seriesHeight);
            var radius = pWidth / 8 - 30;    //圆半径
            var _option = eCharts.getOption();
            for (var i = 0; i < rowsSize; i++) {
                _option.series[i].radius = radius;  //同步更新圆半径
            }
            eCharts.setOption(_option, true);
            eCharts.resize();

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
            if (rangeMax == 540)   //特指风速,此时仅作测试
                rangeMax = 360;
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
            }
            /*保存表盘的最后一段*/
            logic = logic <= 2 ? 3 : 1;
            excep = [];
            excep.push(1);
            excep.push(transGaugeColor(logic));
            rangeExcep.push(excep);
            ranges.push(rangeExcep);
            return ranges;
        }
        function transGaugeColor(logic) {
            /*if(logic<=2)    //＞,≥ : 返回绿色
             return "#49E049";
             else            //＜,≤ : 返回红色
             return "#F83636";*/
            if (logic <= 2)    //＞,≥ : 返回绿色
                return "#91C7AE";
            else            //＜,≤ : 返回红色
                return "#C23531";
        }
        function sortArray(excepDatas) { //排序异常判断, 按数字从小到大
            excepDatas = excepDatas.sort(function (a, b) {
                return parseFloat(a.split("_")[1]) - parseFloat(b.split("_")[1]);
            });
            return excepDatas;
        }
        function transRoundY(i, len) {
            var base = 1 / parseInt(len / 4 + 1);    //基数
            var roundY = parseInt(i / 4) * base + 0.7 * base;
            return roundY * 100 + "%";
        }
        function out() {
            var imgUrl = eCharts.getDataURL("png"); //默认png图片
            $.ajax({
                type: 'POST', //post方式异步提交
                async: false, //同步提交
                traditional: true,
                url: "../chart/exportNowState", //导出图表的服务页面地址
                dataType: "json",//传递方式为json
                //几个重要的参数 如果这里不传递width的话，需要修改导出服务页面内的Request.Form["width"].ToString() 把这句代码注释掉即可
                data: {"imgUrl": imgUrl},
                success: function (msg) {
                    alert("图表导出成功!");
                    location.href = "../chart/downloadNowState?regId=" + regId;
                    $("#waiting").hide();
                    $("#detail_bg").hide();
                },
                error: function (errorMsg) {
                    //alert(errorMsg.responseText);
                    location.href = "../chart/downloadNowState?regId=" + regId;
                    $("#waiting").hide();
                    $("#detail_bg").hide();
                }
            });
        }
        function transSwitchState(switchValue) { //设备控制的状态
            var states = [];
            var inputClass, //按钮颜色
                    inputText;  //按钮文字
            switch (switchValue) {
                case 0: //未使用
                    inputClass = "aBtn aGreen";
                    inputText = "正常";
                    break;
                case 1: //运行中
                    inputClass = "aBtn aDetail";
                    inputText = "运行中";
                    break;
            }
            states.push(inputClass);
            states.push(inputText);
            return states;
        }
        function regSwitch(switchId, switchName, switchValue, btn) { //切换设备控制状态
            var _thisHeight = $("#divWindow").height();
            switch (switchValue) {    //当前状态
                case 0:     //当前未运行
                    $("#divWindow div.divCont").find("a:eq(0)").removeClass("aDetail, aGray").addClass("aDetail");
                    $("#divWindow div.divCont").find("a:eq(1)").removeClass("aRed, aGray").addClass("aGray");
                    break;
                case 1:     //当前运行中
                    $("#divWindow div.divCont").find("a:eq(0)").removeClass("aDetail, aGray").addClass("aGray");
                    $("#divWindow div.divCont").find("a:eq(1)").removeClass("aRed, aGray").addClass("aRed");
                    break;
            }
            $("#divWindow")
                    .hide()
                    .css({"top": $(btn).offset().top - _thisHeight - 30, "left": $(btn).offset().left - 82})
                    .removeClass("divBefore divAfter")
                    .addClass("divAfter")
                    .slideDown(150);
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
            margin-top: -90px;
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
            left: 100px;
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
            text-align: center;
            width: 200px;
            display: inline-block;
            padding: 5px 0 15px 0;
        }

        #divWindow div.divCont a {
            font-size: 16px;
            padding: 8px 12px 7px;
        }
    </style>
</head>
<body>
<div id="divCont">
    <ul>
        <li id="liRegConds">
            <div id="divChart"></div>
        </li>
        <li id="liDevConts"></li>
    </ul>
</div>
<div id="divWindow" class="detailContent divAfter">
    <img title="关闭" onclick="closeDiv('divWindow')" src="../img/close.png" name="Image_close"
         onmouseover="imageOver(name);"
         onmouseout="imageReset(name);" border="none"
         style="cursor:pointer;position:absolute;right:-15px;top:-15px;z-index:66666">
    <div class="divCont">
        <span>
            <a class='aBtn aDetail' href='javascript:'>运行</a>　　
            <a class='aBtn aGray' href='javascript:'>停止</a>
        </span>
    </div>
</div>
<div id="detail_bg"></div>
<div id="waiting"><span id="waitings"></span></div>
</body>
</html>