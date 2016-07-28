<%@ page language="java" pageEncoding="UTF-8" %>
<html>
<head>
    <title>CPN2025-电缆沟在线监测系统</title>
    <script type="text/javascript" src="../js/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=5nQx3fgeRC5EXNO59eSvLNl1"></script>
    <link href="../css/button.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript">
        var period = "${period}";	//采样周期
        var mapBaidu;   //百度地图
        var icon_green, icon_yellow, icon_red;  //图标:正常,通信异常,数据异常
        var mapPointId = new Map();     //点击监测点获取对应ID<lng, regId>
        var mapRegDatas = new Map();    //所有监测点的监测参数<regId, datas>
        var mapRegConds = new Map();    //监测点信息
        $(function () {
            icon_green = new BMap.Icon("../img/icon_map.png", new BMap.Size(21, 24), {
                offset: new BMap.Size(10, 25),
                imageOffset: new BMap.Size(0, 0 - 1 * 21)
            });
            icon_yellow = new BMap.Icon("../img/icon_map.png", new BMap.Size(21, 24), {
                offset: new BMap.Size(10, 25),
                imageOffset: new BMap.Size(-67, 0 - 1 * 21)
            });
            icon_red = new BMap.Icon("../img/icon_map.png", new BMap.Size(21, 24), {
                offset: new BMap.Size(10, 25),
                imageOffset: new BMap.Size(-45, 0 - 1 * 21)
            });
            $.ajax({
                type: "post",
                dataType: "json",
                url: "json_index.action",
                success: function callBack(data) {
                    var map = data.map;
                    var regAreaLng = map.regAreaLng;
                    var regAreaLat = map.regAreaLat;
                    var regAreaZoom = map.regAreaZoom;
                    var regDatas = map.regDatas;
                    var regAreaLines = map.regAreaLines;
                    mapBaidu = new BMap.Map("baiduMap", {enableMapClick: false});
                    var point;  //定位经纬度
                    var marker; //标记点
                    var label;  //附文字
                    if (regAreaLng != "" && regAreaLat != "")
                        point = new BMap.Point(regAreaLng, regAreaLat);
                    else
                        point = new BMap.Point(121.848534, 29.933796);
                    if (regAreaZoom < 3 || regAreaZoom > 19)   //放大级别默认3-18
                        regAreaZoom = 18;
                    mapBaidu.centerAndZoom(point, regAreaZoom);
                    mapBaidu.disableDoubleClickZoom();   //禁止鼠标双击放大Zoom
                    var regState;   //监测点状态[0:正常;1:数据异常;2:通信异常]
                    if (regDatas) {   //监测点
                        for (var i in regDatas) {
                            marker = getMarker(regDatas[i]);
                            mapBaidu.addOverlay(marker);
                            label = new BMap.Label(regDatas[i].regPName, {offset: new BMap.Size(20, -10)});
                            label.setStyle({border: "1px solid gray"});
                            marker.setLabel(label);
                            marker.addEventListener('click', markerClick);  //点击图标显示该监测点的数据
                            mapPointId.put(regDatas[i].lng + "", regDatas[i].id);
                            mapRegDatas.put(regDatas[i].id + "", regDatas[i].datas);
                            mapRegConds.put(regDatas[i].id + "", regDatas[i])
                        }
                    }
                    if (regAreaLines) {   //折线图
                        var pLines = [];
                        var polyline;
                        for (var i in regAreaLines) {     //所有折线图
                            pLines = [];
                            for (var j in regAreaLines[i]) {  //单条折线图
                                point = new BMap.Point(regAreaLines[i][j][0], regAreaLines[i][j][1]);
                                pLines.push(point);
                            }
                            polyline = new BMap.Polyline(pLines);
                            mapBaidu.addOverlay(polyline);
                        }
                    }
                    initAreaDatas(map);
                }
            });
        });
        function getMarker(regData) {
            var point = new BMap.Point(regData.lng, regData.lat);
            var regState = 0;
            if (regData.dataErr == 1)
                regState = 1;
            else if (regData.commErr == 1)
                regState = 2;
            var marker = new BMap.Marker(point, {icon: getIcon(regState)});
            return marker;
        }
        function initAreaDatas(map) {
            var areaName = map.regAreaName; //区域信息
            var recDt = map.regRecDt;       //最近时间
            $("#areaName").html(areaName);
            $("#recDt").html(recDt);
            var regState = "<span class='sDataGood'><img src='../img/icon_good.png'><span class='sCount'>" + map.regDataGood + "</span></span>";
            if (map.regCommErr != 0)
                regState += "<span class='sCommErr'><img src='../img/icon_commErr.png'><span class='sCount'>" + map.regCommErr + "</span></span>";
            if (map.regDataErr != 0)
                regState += "<span class='sDataErr'><img src='../img/icon_dataErr.png'><span class='sCount'>" + map.regDataErr + "</span></span>";
            $("#regCount").html(regState);
        }
        function getIcon(regState) {
            switch (regState) {
                case 0 :
                    return icon_green;
                case 1 :
                    return icon_red;
                case 2 :
                    return icon_yellow;
            }
        }
        function markerClick(e) {
            var regId = mapPointId.get(e.target.point.lng + "");  //点击监测点的Id
            var datas = mapRegDatas.get(regId + "");
            var regData = mapRegConds.get(regId + "");
            var recDt = regData.recDt;
            var regPName = regData.regPName;
            var regLng = regData.lng;
            var regLat = regData.lat;
            var regImg = transRegImg(regData);
            $("#spanRegPName").html(regImg + regPName);
            var ulDatas = "";
            var excepType;  //单个参数的警报情况
            var regColor;
            for (var i in datas) {
                excepType = datas[i].excepType;
                regColor = transSensorStyle(excepType);
                ulDatas += "<li class='liDatas'>" +
                        "<span class='regName'>" + datas[i].regName + "(" + datas[i].unitName + ")：</span>" +
                        "<span class='regValue bold " + regColor + "'>" + datas[i].regValue + "</span>" +
                        "</li>";
            }
            ulDatas += "<li>" +
                    "<span class='cTitle'>实时图表：<span>" +
                    "<span>" +
                    "<a class='aBtn aDetail' href='javascript:' onclick='showNowChart(\"state\", " + regId + ");'>状态图</a>　" +
                    "<a class='aBtn aDetail' href='javascript:' onclick='showNowChart(\"line\", " + regId + ");'>趋势图</a>　" +
                    "<a class='aBtn aDetail' href='javascript:' onclick='showNowChart(\"table\", " + regId + ");'>报表</a>" +
                    "<span>" +
                    "</li>";
            $("#ulConts").html(ulDatas);
        }
        function transSensorStyle(excepType) {
            var style = "green";	//默认正常
            switch (excepType) {
                case 1:
                    style = "red bold";		//数据异常
                    break;
                case 2:
                    style = "yellow bold";	//通信异常
                    break;
            }
            return style;
        }
        function transRegImg(data) {
            var regColor = "<img src='../img/icon_good.png' height='20px'>";
            if (data.dataErr == 1)
                regColor = "<img src='../img/icon_dataErr.png' height='20px'>";
            else if (data.commErr == 1)
                regColor = "<img src='../img/icon_commErr.png' height='20px'>";
            return regColor;
        }
        function transRegState(regState) {
            var state = "<img src='../img/state_green.png' width='20px'>";
            switch (regState) {
                case 1:
                    state = "<img src='../img/state_red.png' width='20px'>";
                    break;
                case 2:
                    state = "<img src='../img/state_yellow.png' width='20px'>";
                    break;
            }
            return state;
        }
        window.onload = function () {
            setTimeout("ajaxValue()", period);
        };
        function ajaxValue() {
            var regIds = "";
            $(".liPara span[flag='chars']").each(function (i) {
                regIds += $(this).attr("id") + ",";
            });
            regIds = regIds.substring(0, regIds.length - 1);
            $.ajax({
                type: "post",
                dataType: "json",
                url: "json_indexPeriod.action",
                data: {regIds: regIds},
                success: function callBack(data) {
                    updateChars(data);		//更新参数值
                }
            });
        }
        function updateChars(data) {
            var regState;
            var regValue;
            var recDt;
            var imgState;
            $(".liPara span[flag='chars']").each(function (i) {
                regState = data.rows[i].regState;
                regValue = data.rows[i].regValue;
                recDt = data.rows[i].recDt;
                if (regValue == null)
                    return true;
                if (regState == 0)
                    $(this).attr("class", "spanRight green").html(regValue);
                else
                    $(this).attr("class", "spanRight " + transSensorStyle(regState) + "").html(regValue);
                $(this).closest("ul").find("li.liDt span").html("监测时间：" + recDt);
            });
            var dataErr;	//数据异常
            var commErr;	//通信异常
            $("ul.ulDev").each(function () {	//遍历所有开关柜，根据内部监测点状态改变自身开关柜状态
                dataErr = $(this).find("span[flag='chars']").hasClass("red");
                commErr = $(this).find("span[flag='chars']").hasClass("yellow");
                if (!dataErr && !commErr)
                    $(this).find("li.liDev").find("span[flag='imgState']").html(transRegState(0));
                else if (dataErr && !commErr)
                    $(this).find("li.liDev").find("img[flag='imgState']").html(transRegState(1));
                else if (!dataErr && commErr)
                    $(this).find("li.liDev").find("img[flag='imgState']").html(transRegState(2));
                else
                    $(this).find("li.liDev").find("img[flag='imgState']").html(transRegState(1) + transRegState(2));
            });
            setTimeout("ajaxValue()", period);
        }
        function rechangeUl() {
            var pHeight = document.body.clientHeight;
            var ulHeightL = 0;
            var ulHeightR = 0;
            $("#tdLeft").find("ul").each(function () {
                ulHeightL += $(this).height();
            });
            $("#tdRight").find("ul").each(function () {
                ulHeightR += $(this).height();
            });
            if (pHeight > ulHeightL && pHeight > ulHeightR)	//两边同时小于页面高度才触发垂直居中
                $("#tdLeft, #tdRight").css("vertical-align", "inherit");
        }
        function showNowChart(chartType, regId) { //浏览监测点的实时图表
            parent.left.mainClick(chartType, regId)
        }
    </script>
    <style>
        body {
            font-family: arial, 微软雅黑, 宋体, sans-serif;
            background-color: #FFFFFF;
            color: #444;
        }

        #divRegMap {
            z-index: 55555;
            width: 100%;
            height: 100%;
            position: absolute;
            top: 0;
            left: 0;
            background-color: #FFF;
        }

        #divInfos {
            width: 320px;
            float: right;
            text-align: left;
            height: 100%;
            overflow-y: auto;
            border-left: 1px solid #B7B5B5;
        }

        #divInfos ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        #divInfos ul li {
            margin-bottom: 10px;
            margin-left: 10px;
            font-size: 14px;
        }

        #divInfos ul li.liTitle {
            background-color: #f5f5f5;
            padding: 10px 7px 9px;
            margin-left: 0;
            font-size: 16px;
            border-top: 1px solid #ddd;
            border-bottom: 1px solid #ddd;
            font-weight: bold;
        }

        #divInfos ul li.liUlCont {
            margin: 0;
        }

        #divInfos ul li.liMapSave {
            margin-top: 10px;
        }

        #divInfos ul li.liMapSave a {
            font-size: 16px;
            padding: 10px 12px 8px;
        }

        #divInfos ul li ul.ulPoints {
            max-height: 320px;
            display: block;
            overflow-y: auto;
            padding: 0;
        }

        #divInfos ul li ul.ulPoints span.spanPoint {
            width: 105px;
            display: inline-block;
        }

        #divInfos ul li ul.ulLines {
            padding: 0;
            max-height: 320px;
            display: block;
            overflow-y: auto;
        }

        #divInfos ul li input.inputText {
            width: 80px;
        }

        #divInfos .cTitle {
            color: #217FA7;
            font-weight: bold;
            font-size: 15px;
        }

        #divInfos span.regTitle {
            color: white;
            padding: 5px 7px;
            border-radius: 3px;
        }

        #ulConts span.regName {
            width: 130px;
            float: left;
            text-align: right
        }

        #ulConts span.regValue {
            text-align: left;
            margin-left: 10px;
        }

        #ulConts li.liDatas {
            border-bottom: 1px dashed gray;
            padding-bottom: 5px;
            margin-right: 10px;
        }

        #ulConts .liDt {
            color: black;
            margin-left: 10px;
            margin-top: 5px;
            background-color: #d6e1ee;
            border-radius: 5px;
            border-bottom: 0;
            padding-bottom: 0;
        }

        #ulConts .liDt span {
            padding: 5px 10px;
            display: inline-block;
        }

        .anchorBL { /*隐藏百度地图左下角的广告*/
            display: none
        }

        #regCount {
            font-size: 16px;
        }

        #regCount span {
            border-radius: 2px;
            margin-right: 7px;
            padding: 2px;
            display: inline-block;
        }

        #regCount span.sCount {
            margin-left: 2px;
        }

        #regCount img {
            height: 20px;
            float: left;
        }

        .red {
            color: #EC442B;
        }

        .green {
            color: #11AB36;
        }

        .yellow {
            color: #EA8010;
        }

        .bold {
            font-weight: bold;
        }

        #spanRegPName {
            display: inline-block;
            line-height: 20px;
            font-weight: normal;
        }

        #spanRegPName img {
            float: left;
            margin-right: 7px;
        }
    </style>
</head>
<body>
<div id="divRegMap">
    <div id="divInfos">
        <ul>
            <li class="liTitle">
                <span>区域信息</span>
            </li>
            <li>
                <span class="cTitle">所在区域：</span>
                <span id="areaName"></span>
            </li>
            <li>
                <span class="cTitle">区域状态：</span>
                <span id="regCount"></span>
            </li>
            <li>
                <span class="cTitle">更新时间：</span>
                <span id="recDt"></span>
            </li>
            <li class="liTitle">
                <span>监测点信息：</span>
                <span id="spanRegPName" class="bold"></span>
            </li>
            <li class="liUlCont">
                <ul id="ulConts" style="padding: 0;"></ul>
            </li>
        </ul>
    </div>
    <div id="divContent">
        <div id="baiduMap"
             style="height:100%;-webkit-transition: all 0.5s ease-in-out;transition: all 0.5s ease-in-out;"></div>
    </div>
</div>
</body>
</html>