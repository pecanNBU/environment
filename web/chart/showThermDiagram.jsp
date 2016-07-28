<%--
  Created by IntelliJ IDEA.
  User: Jenny
  Date: 16/5/10
  Time: 14:57
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>热力图-TSP</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no"/>
    <script type="text/javascript" src="../js/jquery-1.8.2.min.js"></script>
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=5nQx3fgeRC5EXNO59eSvLNl1"></script>
    <script type="text/javascript" src="http://api.map.baidu.com/library/Heatmap/2.0/src/Heatmap_min.js"></script>
    <script type="text/javascript">
        var map;
        $(function () {
            var _height = document.documentElement.clientHeight;
            $("#container").height(_height);
            map = new BMap.Map("container", {enableMapClick: false});          // 创建地图实例
            var point = new BMap.Point(121.888261, 29.761984);
            map.centerAndZoom(point, 17);             // 初始化地图，设置中心点坐标和地图级别
            map.enableScrollWheelZoom(); // 允许滚轮缩放
            map.addControl(new BMap.ScaleControl({anchor: BMAP_ANCHOR_TOP_LEFT}));  // 左上角，添加比例尺
            map.addControl(new BMap.NavigationControl());   //左上角，添加默认缩放平移控件
            if (!isSupportCanvas()) {
                alert('热力图目前只支持有canvas支持的浏览器,您所使用的浏览器不能使用热力图功能~')
            }
            addPolugon();
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
            var polygon = new BMap.Polygon([
                new BMap.Point(121.89302, 29.775162),
                new BMap.Point(121.890577, 29.773281),
                new BMap.Point(121.886624, 29.769143),
                new BMap.Point(121.88339, 29.765506),
                new BMap.Point(121.881666, 29.762998),
                new BMap.Point(121.879725, 29.760427),
                new BMap.Point(121.875845, 29.757355),
                new BMap.Point(121.875198, 29.756539),
                new BMap.Point(121.874479, 29.754784),
                new BMap.Point(121.885259, 29.750707),
                new BMap.Point(121.893092, 29.748575),
                new BMap.Point(121.893667, 29.74845),
                new BMap.Point(121.898985, 29.754282),
                new BMap.Point(121.901213, 29.756477),
                new BMap.Point(121.905525, 29.759424),
                new BMap.Point(121.898841, 29.764879),
                new BMap.Point(121.895607, 29.769331),
                new BMap.Point(121.893092, 29.775037)
            ], {strokeColor: "blue", strokeWeight: 2, strokeOpacity: 0.5});  //创建多边形
            map.addOverlay(polygon);           //增加多边形
            var points = [
                {"lng": 121.888261, "lat": 29.761984, "count": 50},
                {"lng": 121.893332, "lat": 29.756532, "count": 51},
                {"lng": 121.889787, "lat": 29.760658, "count": 15},
                {"lng": 121.888455, "lat": 29.760921, "count": 40},
                {"lng": 121.888843, "lat": 29.755516, "count": 100},
                {"lng": 121.89546, "lat": 29.758503, "count": 6},
                {"lng": 121.893289, "lat": 29.759989, "count": 18},
                {"lng": 121.888162, "lat": 29.755051, "count": 80},
                {"lng": 121.892039, "lat": 29.75782, "count": 11},
                {"lng": 121.88387, "lat": 29.757253, "count": 7},
                {"lng": 121.88773, "lat": 29.759426, "count": 42},
                {"lng": 121.891107, "lat": 29.756445, "count": 4},
                {"lng": 121.887521, "lat": 29.757943, "count": 27},
                {"lng": 121.889812, "lat": 29.760836, "count": 23},
                {"lng": 121.890682, "lat": 29.75463, "count": 60},
                {"lng": 121.885424, "lat": 29.764675, "count": 8},
                {"lng": 121.889242, "lat": 29.754509, "count": 15},
                {"lng": 121.892766, "lat": 29.761408, "count": 25},
                {"lng": 121.891674, "lat": 29.764396, "count": 21},
                {"lng": 121.897268, "lat": 29.76267, "count": 1},
                {"lng": 121.887721, "lat": 29.760034, "count": 51},
                {"lng": 121.882456, "lat": 29.76667, "count": 7},
                {"lng": 121.890432, "lat": 29.759114, "count": 11},
                {"lng": 121.895013, "lat": 29.761611, "count": 35},
                {"lng": 121.888733, "lat": 29.761037, "count": 22},
                {"lng": 121.889336, "lat": 29.761134, "count": 4},
                {"lng": 121.883557, "lat": 29.763254, "count": 5},
                {"lng": 121.888367, "lat": 29.76943, "count": 3},
                {"lng": 121.894312, "lat": 29.759621, "count": 100},
                {"lng": 121.893874, "lat": 29.759447, "count": 87},
                {"lng": 121.894225, "lat": 29.763091, "count": 32},
                {"lng": 121.887801, "lat": 29.761854, "count": 44},
                {"lng": 121.887129, "lat": 29.768227, "count": 21},
                {"lng": 121.896426, "lat": 29.762286, "count": 80},
                {"lng": 121.891597, "lat": 29.75948, "count": 32},
                {"lng": 121.893895, "lat": 29.760787, "count": 26},
                {"lng": 121.893563, "lat": 29.761197, "count": 17},
                {"lng": 121.887982, "lat": 29.762547, "count": 17},
                {"lng": 121.896126, "lat": 29.761938, "count": 25},
                {"lng": 121.89326, "lat": 29.755782, "count": 100},
                {"lng": 121.889239, "lat": 29.756759, "count": 39},
                {"lng": 121.887185, "lat": 29.769123, "count": 11},
                {"lng": 121.887237, "lat": 29.767518, "count": 79},
                {"lng": 121.887784, "lat": 29.755754, "count": 47},
                {"lng": 121.890193, "lat": 29.757061, "count": 52},
                {"lng": 121.892735, "lat": 29.755619, "count": 100},
                {"lng": 121.888495, "lat": 29.755958, "count": 46},
                {"lng": 121.886292, "lat": 29.761166, "count": 9},
                {"lng": 121.889916, "lat": 29.764055, "count": 8},
                {"lng": 121.89189, "lat": 29.761308, "count": 11},
                {"lng": 121.883765, "lat": 29.769376, "count": 3},
                {"lng": 121.888232, "lat": 29.760348, "count": 50},
                {"lng": 121.887554, "lat": 29.760511, "count": 15},
                {"lng": 121.888568, "lat": 29.758161, "count": 23},
                {"lng": 121.883461, "lat": 29.766306, "count": 3},
                {"lng": 121.89232, "lat": 29.76161, "count": 13},
                {"lng": 121.8874, "lat": 29.768616, "count": 6},
                {"lng": 121.894679, "lat": 29.755499, "count": 21},
                {"lng": 121.89171, "lat": 29.755738, "count": 29},
                {"lng": 121.887836, "lat": 29.756998, "count": 99},
                {"lng": 121.890755, "lat": 29.768001, "count": 10},
                {"lng": 121.884077, "lat": 29.760655, "count": 14},
                {"lng": 121.896092, "lat": 29.762995, "count": 16},
                {"lng": 121.88535, "lat": 29.761054, "count": 15},
                {"lng": 121.883022, "lat": 29.761895, "count": 13},
                {"lng": 121.885551, "lat": 29.753373, "count": 17},
                {"lng": 121.891191, "lat": 29.766572, "count": 45},
                {"lng": 121.889612, "lat": 29.757119, "count": 9},
                {"lng": 121.888237, "lat": 29.761337, "count": 54},
                {"lng": 121.893776, "lat": 29.761919, "count": 26},
                {"lng": 121.887694, "lat": 29.76536, "count": 17},
                {"lng": 121.885377, "lat": 29.754137, "count": 19},
                {"lng": 121.887434, "lat": 29.754394, "count": 43},
                {"lng": 121.89588, "lat": 29.762622, "count": 27},
                {"lng": 121.888345, "lat": 29.759467, "count": 8},
                {"lng": 121.896883, "lat": 29.757171, "count": 3},
                {"lng": 121.893877, "lat": 29.756659, "count": 34},
                {"lng": 121.885712, "lat": 29.755613, "count": 14},
                {"lng": 121.889869, "lat": 29.761416, "count": 12},
                {"lng": 121.886956, "lat": 29.765377, "count": 11},
                {"lng": 121.89066, "lat": 29.765017, "count": 38},
                {"lng": 121.886244, "lat": 29.760215, "count": 91},
                {"lng": 121.88929, "lat": 29.755908, "count": 54},
                {"lng": 121.892116, "lat": 29.759658, "count": 21},
                {"lng": 121.8883, "lat": 29.765015, "count": 15},
                {"lng": 121.891969, "lat": 29.753527, "count": 3},
                {"lng": 121.892936, "lat": 29.761854, "count": 24},
                {"lng": 121.88905, "lat": 29.769217, "count": 12},
                {"lng": 121.894579, "lat": 29.754987, "count": 57},
                {"lng": 121.89076, "lat": 29.755251, "count": 70},
                {"lng": 121.890867, "lat": 29.758989, "count": 8},
                {"lng": 121.878969, "lat": 29.755527, "count": 100},
                {"lng": 121.879069, "lat": 29.755827, "count": 100},
                {"lng": 121.880936, "lat": 29.753854, "count": 60},
                {"lng": 121.882136, "lat": 29.754054, "count": 85},
                {"lng": 121.882736, "lat": 29.755054, "count": 85},
                {"lng": 121.882736, "lat": 29.758054, "count": 40},
                {"lng": 121.885736, "lat": 29.759054, "count": 40},
                {"lng": 121.89905, "lat": 29.760217, "count": 72},
                {"lng": 121.890579, "lat": 29.754987, "count": 67},
                {"lng": 121.89276, "lat": 29.757251, "count": 78},
                {"lng": 121.89276, "lat": 29.767251, "count": 93},
                {"lng": 121.89276, "lat": 29.751251, "count": 40},
                {"lng": 121.885867, "lat": 29.752989, "count": 15}];
            var array;
            var intVal;
            var pointLng,
                    pointLat;
            for (var i = 0; i < 2500; i++) {
                intVal = Math.floor(Math.random() * 40);
                pointLng = 121.880 + Math.random() * 33 * 0.001;
                pointLat = 29.750 + Math.random() * 16 * 0.001;
                array = {"lng": pointLng, "lat": pointLat, "count": intVal};
                points.push(array);
            }
            for (var i = 0; i < 200; i++) {
                intVal = Math.floor(Math.random() * 30) + 70;
                pointLng = 121.880 + Math.random() * 33 * 0.001;
                pointLat = 29.750 + Math.random() * 16 * 0.001;
                array = {"lng": pointLng, "lat": pointLat, "count": intVal};
                points.push(array);
            }
            heatmapOverlay = new BMapLib.HeatmapOverlay({"radius": 20});
            map.addOverlay(heatmapOverlay);
            heatmapOverlay.setDataSet({data: points, max: 100});
        }
        //是否显示热力图
        function openHeatmap() {
            heatmapOverlay.show();
        }
        function closeHeatmap() {
            heatmapOverlay.hide();
        }
        //closeHeatmap();
        function setGradient() {
            /*格式如下所示:
             {
             0:'rgb(102, 255, 0)',
             .5:'rgb(255, 170, 0)',
             1:'rgb(255, 0, 0)'
             }*/
            var gradient = {};
            var colors = document.querySelectorAll("input[type='color']");
            colors = [].slice.call(colors, 0);
            colors.forEach(function (ele) {
                gradient[ele.getAttribute("data-key")] = ele.value;
            });
            heatmapOverlay.setOptions({"gradient": gradient});
        }
        //判断浏览区是否支持canvas
        function isSupportCanvas() {
            var elem = document.createElement('canvas');
            return !!(elem.getContext && elem.getContext('2d'));
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

        #cpnTest1 {
            position: absolute;
            right: 4px;
            top: 15px;
            width: 246px;
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
<img id='cpnTest' src="../img/cpn_test1.png">
<img id='cpnTest1' src="../img/cpn_test2.png">
</body>
</html>