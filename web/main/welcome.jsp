<%--
  Created by IntelliJ IDEA.
  User: Jenny
  Date: 16/5/10
  Time: 14:57
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<html>
<head>
    <title>热力图-TSP</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no"/>
    <script type="text/javascript" src="../js/jquery-1.8.2.min.js"></script>
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=5nQx3fgeRC5EXNO59eSvLNl1"></script>
    <link rel="stylesheet" type="text/css" href="../css/style.css"/>
    <script type="text/javascript">
        var map;
        var icon_green = new BMap.Icon("../img/icon_map.png", new BMap.Size(21, 24), {
            offset: new BMap.Size(10, 25),
            imageOffset: new BMap.Size(0, 0 - 1 * 21)
        });
        var icon_yellow = new BMap.Icon("../img/icon_map.png", new BMap.Size(21, 24), {
            offset: new BMap.Size(10, 25),
            imageOffset: new BMap.Size(-67, 0 - 1 * 21)
        });
        var icon_red = new BMap.Icon("../img/icon_map.png", new BMap.Size(21, 24), {
            offset: new BMap.Size(10, 25),
            imageOffset: new BMap.Size(-45, 0 - 1 * 21)
        });
        $(function () {
            var _height = document.documentElement.clientHeight;
            $("#container").height(_height);
            // 创建地图实例
            // 地图类型:卫星地图
            // 不允许地图点击事件
            map = new BMap.Map("container", {mapType: BMAP_SATELLITE_MAP, enableMapClick: false});
            var point = new BMap.Point(121.851397, 29.834528);
            map.centerAndZoom(point, 12);             // 初始化地图，设置中心点坐标和地图级别
            map.enableScrollWheelZoom(); // 允许滚轮缩放
            map.addControl(new BMap.ScaleControl({anchor: BMAP_ANCHOR_TOP_LEFT}));  // 左上角，添加比例尺
            map.addControl(new BMap.NavigationControl());   //左上角，添加默认缩放平移控件}
            addPolugon();
            setDate();
            setSelect();
        });
        //详细的参数,可以查看heatmap.js的文档 https://github.com/pa7/heatmap.js/blob/master/README.md
        //参数说明如下:
        /* visible 热力图是否显示,默认为true
         * opacity 热力的透明度,1-100
         * radius 势力图的每个点的半径大小
         * gradient  {JSON} 热力图的渐变区间 . gradient如下所示
         *	{
         .2:'rgb(0, 255, 255)',
         .5:'rgb(0, 110, 255)',
         .8:'rgb(100, 0, 255)'
         }
         其中 key 表示插值的位置, 0~1.
         value 为颜色值.
         */
        function addPolugon() {
            var points = [
                [121.875845, 29.757355],
                [121.865615, 29.918164],
                [121.795093, 29.908817],
                [121.622025, 29.877856],
                [121.780322, 29.793669],
                [121.929998, 29.83465]
            ];
            var labelNames = ["宁波春晓", "京华名苑", "甬江家园", "会展中心", "天童寺", "上龙泉村"];
            var point,
                    marker,
                    label,
                    labelHtml;
            var markerState;
            for (var i in points) {
                point = new BMap.Point(points[i][0], points[i][1]);
                if (i == 1)
                    markerState = 2;
                else
                    markerState = 0;
                marker = new BMap.Marker(point, {icon: getIcon(markerState)});
                map.addOverlay(marker);
                labelHtml = labelNames[i];
                label = new BMap.Label(labelHtml, {offset: new BMap.Size(20, -10)});
                label.setStyle({border: "1px solid gray"});
                marker.setLabel(label);
                if (i == 1) {
                    marker.addEventListener('click', markerClick);  //点击图标显示该监测点的数据
                }
            }
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
        function markerClick() { //点击显示该点的信息
            var sContent =
                    "<h4 style='margin:0 0 5px 0;padding:0.2em 0'>天安门</h4>" +
                    "<img style='float:right;margin:4px' id='imgDemo' src='http://app.baidu.com/map/images/tiananmen.jpg' width='139' height='104' title='天安门'/>" +
                    "<p style='margin:0;line-height:1.5;font-size:13px;text-indent:2em'>天安门坐落在中国北京市中心,故宫的南侧,与天安门广场隔长安街相望,是清朝皇城的大门...</p>" +
                    "</div>";
            var infoWindow = new BMap.InfoWindow(sContent);  // 创建信息窗口对象
            this.openInfoWindow(infoWindow);
        }
        function setDate() {
            $("#spanDate").html(getCurDate());
        }
        function getCurDate() {				//取当前时间
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
        function setSelect() {
            $("#selCity").html("<option value=0>所有省份</option>");
            $("#selArea").html("<option value=0>所有城市</option>");
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
            left: 0;
            bottom: 0;
            font-size: 13px;
            line-height: 11px;
            padding: 0px 3px;
            text-align: left;
        }

        #divMark ul, #divMark li {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        #divMark span {
            margin-right: 5px;
        }

        #divMark .bGreen {
            display: inline-block;
            width: 35px;
            height: 20px;
            background-color: #00B83F;
        }

        #divMark .bYellow {
            display: inline-block;
            width: 35px;
            height: 20px;
            background-color: yellow;
        }

        #divMark .bOrange {
            display: inline-block;
            width: 35px;
            height: 20px;
            background-color: orange;
        }

        #divMark .bRed {
            display: inline-block;
            width: 35px;
            height: 20px;
            background-color: red;
        }

        #divMark .bPurple {
            display: inline-block;
            width: 35px;
            height: 20px;
            background-color: purple;
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
            right: 0;
            top: 0;
            font-size: 13px;
            text-align: left;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.6);
            width: 300px;
        }

        #divLabel .fLeft {
            float: left;
        }

        #divLabel .fRight {
            float: right;
        }

        #divLabel ul li {
            padding: 8px 0;
            border-bottom: 1px solid darkgray;
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
            margin-top: 6px;
            margin-right: 11px;
        }

        #divLabel ul li.liInput input {
            width: 250px;
            border-radius: 0;
            height: 35px;
            border: none;
        }

        #divLabel ul li.liName {
            background-color: orange;
            color: white;
            padding: 0 10px;;
        }

        #divLabel ul li.liName div {
            height: 25px;
            line-height: 25px;
        }

        #divLabel ul li.liState {
            height: 60px;
            border-bottom: 1px solid darkgrey;
            padding: 5px 10px;
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
            padding: 0;
        }

        #divLabel li.liList ul li div.dText {
            width: 80%;
            display: inline-block;
        }

        #divLabel li.liList ul {
            padding: 0 10px;
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
            margin-top: 20px;
            display: inline-block;
        }

        #divLabel li.liList ul li div.dState span.sAlarm {
            background-color: orange;
            padding: 8px;
            border-radius: 2px;
            color: white;
        }

        #divLabel li.liList ul li div.dState span.sGood {
            background-color: #00B83F;
            padding: 8px;
            border-radius: 2px;
            color: white;
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
        <li style="margin: 5px 0;"><span style="font-size: 18px;font-weight: bold;">图例</span>（μg/m³）</li>
        <li><span class="bGreen"></span>0-35</li>
        <li><span class="bYellow"></span>36-75</li>
        <li><span class="bOrange"></span>76-115</li>
        <li><span class="bRed"></span>116-150</li>
        <li><span class="bPurple"></span>151-250</li>
    </ul>
</div>
<div id="divLabel">
    <ul>
        <li class="liInput">
            <input name="regName" class="inputText">
            <img src="../img/welcome_select.png">
        </li>
        <li class="liList hide">
            <ul>
                <li class="liSelect">
                    <select id="selCity"></select>
                    <select id="selArea"></select>
                </li>
                <li>
                    <div class="dText">
                        <span class="sTitle">京华名苑</span>
                        <span>施工中</span>
                        <span>宁波市北仑区新矸镇辽河路北161号</span>
                    </div>
                    <div class="dState">
                        <span class="sAlarm">83.5</span>
                    </div>
                </li>
                <li>
                    <div class="dText">
                        <span class="sTitle">会展中心</span>
                        <span>施工中</span>
                        <span>宁波市江东区会展路181号</span>
                    </div>
                    <div class="dState">
                        <span class="sGood">34.2</span>
                    </div>
                </li>
                <li>
                    <div class="dText">
                        <span class="sTitle">宁波春晓</span>
                        <span>施工中</span>
                        <span>宁波市北仑区春晓工业园洋沙山路78号</span>
                    </div>
                    <div class="dState">
                        <span class="sGood">31.4</span>
                    </div>
                </li>
                <li>
                    <div class="dText">
                        <span class="sTitle">甬江家园</span>
                        <span>施工中</span>
                        <span>宁波市北仑区甬江南路</span>
                    </div>
                    <div class="dState">
                        <span class="sGood">20.4</span>
                    </div>
                </li>
                <li>
                    <div class="dText">
                        <span class="sTitle">上龙泉村</span>
                        <span>施工中</span>
                        <span>宁波市北仑区上龙泉村</span>
                    </div>
                    <div class="dState">
                        <span class="sGood">1.5</span>
                    </div>
                </li>
                <li>
                    <div class="dText">
                        <span class="sTitle">天童寺</span>
                        <span>施工中</span>
                        <span>宁波市北仑区东吴镇天童村</span>
                    </div>
                    <div class="dState">
                        <span class="sGood">1.2</span>
                    </div>
                </li>
            </ul>
        </li>
        <li class="liName">
            <div><span class="fLeft spanBig bold">京华名苑</span><span class="fRight spanBig bold">施工中</span></div>
            <div><span class="fLeft">警报</span><span id="spanDate" class="fRight"></span></div>
        </li>
        <li class="liState">
            <div class="fLeft">
                <span class="sType">颗粒物</span>
                <span class="sData">83.5</span>
                <span class="sUnit">μg/m3</span>
            </div>
            <div class="fRight">
                <span class="sType">噪声</span>
                <span class="sData">53.7</span>
                <span class="sUnit">dB</span>
            </div>
        </li>
        <li class="liText">
            <ul>
                <li>
                    <span class="sTitle">工地信息</span>
                </li>
                <li>
                    <span class="spanTitle">工程名：</span>
                    <span class="spanText">京华名苑二期</span>
                </li>
                <li>
                    <span class="spanTitle">联系人：</span>
                    <span class="spanText">范增</span>
                </li>
                <li>
                    <span class="spanTitle">联系电话：</span>
                    <span class="spanText">13666666666</span>
                </li>
                <li>
                    <span class="spanTitle">建筑商：</span>
                    <span class="spanText">宁波京华房产开发有限公司</span>
                </li>
                <li>
                    <span class="spanTitle">地址：</span>
                    <span class="spanText">宁波市北仑区新矸镇辽河路北161号</span>
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