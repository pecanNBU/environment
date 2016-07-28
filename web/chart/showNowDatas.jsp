<%--
  Created by IntelliJ IDEA.
  User: Jenny
  Date: 16/6/1
  Time: 15:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE HTML>
<html>
<head>
    <title>实时数据 - 热力图,实时图表,实时报表</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no"/>
    <script type="text/javascript" src="../js/jquery-1.8.2.min.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=5nQx3fgeRC5EXNO59eSvLNl1"></script>
    <link rel="stylesheet" type="text/css" href="../css/style.css"/>
    <script type="text/javascript">
        var mapBaidu;
        var mapStreets = new Map(); //<行政区 - 街道>
        var mapConsts = new Map();  //<街道 - <工地信息>>
        var mapPointDatas = new Map();  //<工地名称 - 工地资料>
        $(function () {
            var _height = document.documentElement.clientHeight;
            $("#container").height(_height);
            // 创建地图实例
            // 地图类型:卫星地图
            // 不允许地图点击事件
            mapBaidu = new BMap.Map("container", {mapType: BMAP_NORMAL_MAP, enableMapClick: false});
            var point = new BMap.Point(121.751397, 29.834528);
            mapBaidu.centerAndZoom(point, 12);             // 初始化地图，设置中心点坐标和地图级别
            mapBaidu.enableScrollWheelZoom(); // 允许滚轮缩放
            var top_right_navigation = new BMap.NavigationControl({
                anchor: BMAP_ANCHOR_TOP_RIGHT,
                type: BMAP_NAVIGATION_CONTROL_ZOOM
            }); //右上角，仅包含平移和缩放按钮
            mapBaidu.addControl(top_right_navigation);
            //map.addControl(new BMap.ScaleControl({anchor: BMAP_ANCHOR_TOP_LEFT}));  // 左上角，添加比例尺
            //map.addControl(new BMap.NavigationControl());   //左上角，添加默认缩放平移控件}
            addPolugon();
            //setDate();
        });
        function addPolugon() {  //获取监测点的数据,并在地图上展示
            $.ajax({
                type: "post",
                dataType: "json",
                url: "json_mapDatas.action",
                success: function callBack(data) {
                    var mapAll = data.map;
                    var streets = mapAll.mapStreets;
                    if (streets) {
                        for (var i in streets) {
                            mapStreets.put(i, streets[i]);
                            $("#selRegion").append("<option value='" + i + "'>" + i + "</option>");
                        }
                    }
                    var allDatas = mapAll.allDatas;
                    if (allDatas) {
                        var pointData,
                                pointDatas,
                                addrStreet;
                        for (var i in allDatas) {
                            pointDatas = [];
                            pointData = allDatas[i];
                            addrStreet = pointData.addrStreet;
                            if (mapConsts.get(addrStreet) == null) {
                                pointDatas.push(pointData);
                            }
                            else {
                                pointDatas = mapConsts.get(addrStreet);
                                pointDatas.push(pointData);
                            }
                            mapConsts.put(allDatas[i].addrStreet, pointDatas);
                            mapPointDatas.put(pointData.consName, pointData);
                        }
                    }
                    showPoints();
                }
            });
        }
        function getIcon(regState) { //根据监测点状态,显示不同的标注颜色
            var imgIcon = "";
            switch (regState) {
                case 1 :
                    imgIcon = "icon_point_green.png";
                    break;
                case 2 :
                    imgIcon = "icon_point_yellow.png";
                    break;
                case 3 :
                    imgIcon = "icon_point_orange.png";
                    break;
                case 4 :
                    imgIcon = "icon_point_red.png";
                    break;
                case 5 :
                    imgIcon = "icon_point_purple.png";
                    break;
            }
            var icon = new BMap.Icon("../img/icon/" + imgIcon, new BMap.Size(40, 40), {
                offset: new BMap.Size(0, 0),
                imageOffset: new BMap.Size(0, 0),
                imageSize: new BMap.Size(24, 24)
            });
            return icon;
        }
        function markerClick() { //点击显示该点的信息
            var sContent =
                    "<h4 style='margin:0 0 5px 0;padding:0.2em 0'>天安门</h4>" +
                    "<img style='float:right;margin:4px' id='imgDemo' src='http://app.baidu.com/map/images/tiananmen.jpg' width='139' height='104' title='天安门'/>" +
                    "<p style='margin:0;line-height:1.5;font-size:13px;text-indent:2em'>天安门坐落在中国北京市中心,故宫的南侧,与天安门广场隔长安街相望,是清朝皇城的大门...</p>" +
                    "</div>";
            var infoWindow = new BMap.InfoWindow(sContent);  // 创建信息窗口对象
            this.openInfoWindow(infoWindow);
        }
        function getCurDate() {      //取当前时间
            var d = new Date();
            var vYear = d.getFullYear();
            var vMon = d.getMonth() + 1;
            var vDay = d.getDate();
            var h = d.getHours();
            var m = d.getMinutes();
            var se = d.getSeconds();
            vMon = vMon < 10 ? "0" + vMon : vMon;
            vDay = vDay < 10 ? "0" + vDay : vDay;
            h = h < 10 ? "0" + h : h;
            m = m < 10 ? "0" + m : m;
            se = se < 10 ? "0" + se : se;
            return vYear + "-" + vMon + "-" + vDay + " " + h + ":" + m + ":" + se;
        }
        function selStreets() {  //根据选择的行政区,显示所有街道
            var region = $("#selRegion").val();
            $("#selStreet").html("<option value=0>-------</option>");
            if (region != 0) {
                var listStreest = mapStreets.get(region);
                if (listStreest) {
                    for (var i in listStreest) {
                        $("#selStreet").append("<option>" + listStreest[i] + "</option>");
                    }
                }
            }
        }
        function showPoints() {  //根据所选行政区,街道,显示对应的所有工地
            var region = $("#selRegion").val(); //所限行政区
            var street = $("#selStreet").val(); //所选街道
            var selPoints = [];    //对应标注
            mapBaidu.clearOverlays();  //清空所有标注
            $("#ulPoints li:gt(0)").remove();
            var pointDatas; //工地信息
            if (region == 0) {  //所有行政区
                for (var i in mapConsts.arr) {
                    pointDatas = mapConsts.arr[i].value;
                    for (var j in pointDatas) {
                        addPoint(pointDatas[j]);
                    }
                }
            }
            else if (street == 0) { //所选行政区的所有街道
                $("#selStreet option:gt(0)").each(function () {
                    pointDatas = mapConsts.get($(this).val());
                    for (var i in pointDatas) {
                        addPoint(pointDatas[i]);
                    }
                })
            }
            else {   //所选街道
                pointDatas = mapConsts.get(street);
                for (var i in pointDatas) {
                    addPoint(pointDatas[i]);
                }
            }
            initClass();
        }
        function addPoint(pointData) {   //添加标注,以及列表信息
            /*添加标注*/
            var point = new BMap.Point(pointData.addrLat, pointData.addrLng);
            var markerState = parseInt(pointData.consState);
            var marker = new BMap.Marker(point, {icon: getIcon(markerState)});
            mapBaidu.addOverlay(marker);
            var labelHtml = pointData.consName;
            var label = new BMap.Label(labelHtml, {offset: new BMap.Size(20, -10)});
            label.setStyle({border: "1px solid gray"});
            marker.setLabel(label);
            /*显示所选区域对应的工地列表*/
            var liClass = transClass(parseInt(pointData.consState));
            var htmlLi = "<li>" +
                    "<div class='dText'>" +
                    "<span class='sTitle'>" + labelHtml + "</span>" +
                    "<span>" + pointData.isConst + "</span>" +
                    "<span>" + pointData.addrName + "</span>" +
                    "</div>" +
                    "<div class='dState'>" +
                    "<a class='" + liClass + "' href='javascript:'>" + pointData.dataDust + "</a>" +
                    "</div>" +
                    "</li>";
            $("#ulPoints").append(htmlLi);
        }
        function transClass(consState) {
            switch (consState) {
                case 1 :
                    return "sGood";
                case 2 :
                    return "sWell";
                case 3 :
                    return "sMild";
                case 4 :
                    return "sMod";
                case 5 :
                    return "sSevere";
            }
        }
        function initClass() {   //初始化样式
            $("#ulPoints li:gt(0)").hover(function () {
                $(this).addClass("hover");
            }, function () {
                $(this).removeClass("hover");
            });
            var consName;   //工地名称
            var pointData;  //工地详情
            $("#ulPoints li:gt(0)").click(function () {
                consName = $(this).find("span.sTitle").text();
                pointData = mapPointDatas.get(consName);
                $("#divLabel>ul>li:eq(1)").hide();
                $("#divLabel>ul>li:gt(1)").show();
                $("#divLabel li span[flagName=spanDate]").html(getCurDate());
                var pointClass = transClass(parseInt(pointData.consState));
                $("#divLabel ul li.liName").attr("class", "liName hide " + pointClass);
                for (var i in pointData) {    //显示建筑工地的详情
                    $("#divLabel li span[flagName=" + i + "]").html(pointData[i]);
                }
            });
        }
        function backList() {    //返回工地列表
            $("#divLabel>ul>li:eq(1)").show();
            $("#divLabel>ul>li:gt(1)").hide();
        }
        function searchFilter(input) {   //搜索框
            var searchVal = $(input).val(); //搜索框输入的内容
            var consName, addrRegion, addrStreet, addrName;
            for (var i in mapPointDatas.arr) {    //遍历所有的工地,模糊匹配工地名,详细地址,行政区,所在街道
                consName = mapPointDatas.arr[i].consName;
                //if(vagueVal(consName, searchVal)==true)
            }
        }
    </script>
    <style type="text/css">
        ul, li {
            list-style: none;
            margin: 0;
            padding: 0;
        }

        html {
            height: 100%
        }

        body {
            height: 100%;
            margin: 0px;
            padding: 0px;
            font-family: "微软雅黑";
        }

        #container {
            height: 500px;
            width: 100%;
        }

        .anchorBL { /*隐藏百度地图左下角的广告*/
            display: none
        }

        #divMark {
            background-color: white;
            position: absolute;
            right: 0;
            bottom: 0;
            font-size: 13px;
            line-height: 11px;
            padding: 2px 8px 0;
            border-radius: 3px;
            text-align: left;
            box-shadow: 0px 0px 3px rgba(0, 0, 0, 0.6);
        }

        #divMark li {
            margin: 5px 0;
            line-height: 22px;
        }

        #divMark span {
            /*margin-right: 5px;*/
        }

        #divMark a {
            background: #2daebf url(../img/overlay-button.png) repeat-x 0 0;
            display: inline-block;
            width: 35px;
            height: 20px;
            text-decoration: none;
            border-radius: 3px;
            -moz-box-shadow: 0 1px 3px rgba(0, 0, 0, 0.5);
            -webkit-box-shadow: 0 1px 3px rgba(0, 0, 0, 0.5);
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.5);
            margin-right: 5px;
            cursor: default;
        }

        #divMark a.bGreen {
            background-color: #00B83F;
        }

        #divMark a.bYellow {
            background-color: #FFFD38;
        }

        #divMark a.bOrange {
            background-color: #FDA429;
        }

        #divMark a.bRed {
            background-color: #FC0D1B;
        }

        #divMark a.bPurple {
            background-color: #7F0F7E;
        }

        #cpnTest {
            position: absolute;
            right: 4px;
            top: 50px;
            width: 326px;
        }

        #divLabel {
            background-color: white;
            position: absolute;
            left: 0;
            top: 0;
            font-size: 13px;
            text-align: left;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.6);
            width: 350px;
        }

        #divLabel .fLeft {
            float: left;
        }

        #divLabel .fRight {
            float: right;
        }

        #divLabel ul li {
            padding: 5px;
            border-bottom: 1px solid #DCDBDB;
        }

        #divLabel ul li:last-child {
            border: none;
        }

        #divLabel ul li.liInput {
            padding: 0;
            background-color: #56ABE4;
        }

        #divLabel ul li.liInput img {
            height: 22px;
            float: right;
            padding: 9px 18px;
            cursor: pointer;
        }

        #divLabel ul li.liInput input {
            width: 280px;
            border-radius: 0;
            height: 35px;
            border: none;
        }

        #divLabel ul li.liBack {
            padding: 2px 5px;
            line-height: 23px;
        }

        #divLabel ul li.liBack a {
            text-decoration: none;
            color: #56ABE4;
        }

        #divLabel ul li.liBack img {
            height: 22px;
            float: left;
            padding-right: 5px;
        }

        #divLabel ul li.liName {
            background-color: #00B83F;
            color: white;
        }

        #divLabel ul li.sGood {
            background-color: #00B83F;
        }

        #divLabel ul li.sWell {
            background-color: #FFFD38;
            color: gray;
        }

        #divLabel ul li.sMild {
            background-color: #FDA429;
        }

        #divLabel ul li.sMod {
            background-color: #FC0D1B;
        }

        #divLabel ul li.sSevere {
            background-color: #7F0F7E;
        }

        #divLabel ul li.liName div {
            height: 25px;
            line-height: 25px;
        }

        #divLabel ul li.liState {
            height: 60px;
            border-bottom: 1px solid darkgrey;
        }

        #divLabel ul li.liState div {
            width: 50%;
        }

        #divLabel ul li.liState span {
            display: block;
        }

        #divLabel ul li.liState span.sType {
            margin-bottom: 5px;
            font-size: 15px;
            font-weight: bold;
        }

        #divLabel ul li.liState span.sData {
            margin-left: 36px;
            font-size: 20px;
            margin-bottom: 5px;
        }

        #divLabel ul li.liState span.sUnit {
            margin-left: 75px;
        }

        #divLabel ul li.liText ul {
            margin: 0 10px 10px 10px;
        }

        #divLabel ul li.liText span.sTitle {
            font-size: 15px;
            font-weight: bold;
        }

        #divLabel ul li.liText span.spanTitle {
            width: 70px;
            display: inline-block;
            text-align: right;
        }

        #divLabel ul li.liText span.sBtn {
            float: right;
            height: 33px;
        }

        #divLabel li.liList {

        }

        #divLabel li.liList ul li div.dText {
            width: 80%;
            display: inline-block;
        }

        #divLabel li.liList ul {

        }

        #divLabel li.liList ul li div.dText span {
            display: block;
            margin: 3px 0;
        }

        #divLabel li.liList ul li div.dText span.sTitle {
            font-size: 18px;
            color: #56ABE4;
        }

        #divLabel li.liList ul li div.dState {
            float: right;
            margin-top: 15px;
            display: inline-block;
        }

        #divLabel li.liList ul li div.dState span {
            padding: 8px 8px 7px;
            border-radius: 2px;
        }

        #divLabel ul.ulPoint li {
            border: none;
        }

        #ulPoints li {
            cursor: pointer;
        }

        #ulPoints li.hover {
            background-color: #FFFFE9;
        }

        #ulPoints a {
            background: #2daebf url(../img/overlay-button.png) repeat-x 0 0;
            display: inline-block;
            width: 40px;
            height: 23px;
            text-decoration: none;
            border-radius: 3px;
            -moz-box-shadow: 0 1px 3px rgba(0, 0, 0, 0.5);
            -webkit-box-shadow: 0 1px 3px rgba(0, 0, 0, 0.5);
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.5);
            line-height: 25px;
            text-align: center;
            color: white;
            padding: 1px 4px;
        }

        #ulPoints a.sGood {
            background-color: #00B83F;
        }

        #ulPoints a.sWell {
            background-color: #FFFD38;
            color: gray;
        }

        #ulPoints a.sMild {
            background-color: #FDA429;
            color: green;
        }

        #ulPoints a.sMod {
            background-color: #FC0D1B;
        }

        #ulPoints a.sSevere {
            background-color: #7F0F7E;
        }

        #divLabel li.liSelect select {
            width: 49%;
            height: 28px;
            line-height: 30px;
            _height: 120px;
            background-color: white;
            outline: 0;
            border: 1px solid #ccc;
            overflow-x: hidden;
            overflow-y: auto;
            padding: 3px 6px;
            font-size: 14px;
            line-height: 20px;
            color: #555;
            -webkit-border-radius: 4px;
            -moz-border-radius: 4px;
            border-radius: 4px;
            -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
            -moz-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
            box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
            -webkit-transition: border linear .2s, box-shadow linear .2s;
            -moz-transition: border linear .2s, box-shadow linear .2s;
            -o-transition: border linear .2s, box-shadow linear .2s;
            transition: border linear .2s, box-shadow linear .2s;
            display: inline-block;
        }

        .spanBig {
            font-size: 16px;
        }

        .bold {
            font-weight: bold;
        }
    </style>
</head>
<body>
<div id="container"></div>
<div id="divMark">
    <ul>
        <li><a class="bGreen" href="javascript:">　　</a><span>优秀</span></li>
        <li><a class="bYellow" href="javascript:">　　</a><span>良好</span></li>
        <li><a class="bOrange" href="javascript:">　　</a><span>轻度污染</span></li>
        <li><a class="bRed" href="javascript:">　　</a><span>中度污染</span></li>
        <li><a class="bPurple" href="javascript:">　　</a><span>重度污染</span></li>
    </ul>
</div>
<div id="divLabel">
    <ul>
        <li class="liInput">
            <input class="inputText" onkeyup="searchFilter(this)">
            <img src="../img/welcome_select.png">
        </li>
        <li class="liList">
            <ul id="ulPoints">
                <li class="liSelect">
                    <select id="selRegion" onchange="selStreets();showPoints();">
                        <option value='0'>所有行政区</option>
                    </select>
                    <select id="selStreet" onchange="showPoints();">
                        <option value='0'>-------</option>
                    </select>
                </li>
            </ul>
        </li>
        <li class="liBack hide">
            <a href="javascript:" onclick="backList();">
                <img src="../img/icon/icon_back.png">
                返回上一级
            </a>
        </li>
        <li class="liName hide">
            <div>
                <span class="fLeft spanBig bold" flagName="consName">京华名苑</span>
                <span class="fRight spanBig bold" flagName="isConst">施工中</span>
            </div>
            <div>
                <span class="fLeft" flagName="consState1">警报</span>
                <span class="fRight" flagName="spanDate"></span>
            </div>
        </li>
        <li class="liState hide">
            <div class="fLeft">
                <span class="sType">颗粒物</span>
                <span class="sData" flagName="dataDust">83.5</span>
                <span class="sUnit">μg/m3</span>
            </div>
            <div class="fRight">
                <span class="sType">噪声</span>
                <span class="sData" flagName="dataNoise">53.7</span>
                <span class="sUnit">dB</span>
            </div>
        </li>
        <li class="liText hide">
            <ul class="ulPoint">
                <li>
                    <span class="sTitle">工地信息</span>
                </li>
                <li>
                    <span class="spanTitle">工程名：</span>
                    <span class="spanText" flagName="consName">京华名苑二期</span>
                </li>
                <li>
                    <span class="spanTitle">联系人：</span>
                    <span class="spanText" flagName="chargeUserName">范增</span>
                </li>
                <li>
                    <span class="spanTitle">联系电话：</span>
                    <span class="spanText" flagName="mobilephone">13666666666</span>
                </li>
                <li>
                    <span class="spanTitle">建筑商：</span>
                    <span class="spanText" flagName="builder">宁波京华房产开发有限公司</span>
                </li>
                <li>
                    <span class="spanTitle">地址：</span>
                    <span class="spanText" flagName="addrName">宁波市北仑区新矸镇辽河路北161号</span>
                </li>
                <li>
                    <span class="sBtn"><a class='aBtn aDetail' href='javascript:'>详 情</a></span>
                </li>
            </ul>
        </li>
    </ul>
</div>
<!--<img id='cpnTest' src="../img/cpn_test.png">-->
</body>
</html>