<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>地图测试</title>
    <script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <link type="text/css" rel="stylesheet" href="../css/style.css"/>
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=5nQx3fgeRC5EXNO59eSvLNl1"></script>
    <script>
        var mapBaidu;
        var polyline;
        var pLines = [];
        var mapPoints = new Map();
        $(function () {
            showRegMap();
        });
        function showRegMap() {  //地图配置
            $("#divRegMap").show();
            // 百度地图API功能
            mapBaidu = new BMap.Map('baiduMap');
            var poi = new BMap.Point(116.307852, 40.057031);
            mapBaidu.centerAndZoom(poi, 16);
            //mapBaidu.enableScrollWheelZoom();
            mapBaidu.disableDoubleClickZoom();   //禁止鼠标双击放大Zoom
            var overlays = [];
            var overlaycomplete = function (e) {
                overlays.push(e.overlay);
            };
            var styleOptions = {
                strokeColor: "red",    //边线颜色。
                fillColor: "red",      //填充颜色。当参数为空时，圆形将没有填充效果。
                strokeWeight: 3,       //边线的宽度，以像素为单位。
                strokeOpacity: 0.8,	   //边线透明度，取值范围0 - 1。
                fillOpacity: 0.6,      //填充的透明度，取值范围0 - 1。
                strokeStyle: 'solid' //边线的样式，solid或dashed。
            };
            ;
            ;
            ;
            ;
            ;
            ;
            ;
            //实例化鼠标绘制工具
            /*var drawingManager = new BMapLib.DrawingManager(mapBaidu, {
             isOpen: false, //是否开启绘制模式
             enableDrawingTool: true, //是否显示工具栏
             drawingToolOptions: {
             anchor: BMAP_ANCHOR_TOP_RIGHT, //位置
             offset: new BMap.Size(5, 5), //偏离值
             },
             circleOptions: styleOptions, //圆的样式
             polylineOptions: styleOptions, //线的样式
             polygonOptions: styleOptions, //多边形的样式
             rectangleOptions: styleOptions //矩形的样式
             });
             //添加鼠标绘制工具监听事件，用于获取绘制结果
             drawingManager.addEventListener('overlaycomplete', overlaycomplete);
             function clearAll() {
             for(var i = 0; i < overlays.length; i++){
             mapBaidu.removeOverlay(overlays[i]);
             }
             overlays.length = 0
             }*/
            initRegDatas();
            initMapSearch();
        }
        function initRegDatas() {    //初始化该监测区域已有的地图信息
            var htmlUl = "";
            for (var i = 0; i < 10; i++) {
                htmlUl += "<li>" +
                        "<span class='spanPoint'><a class='aBtn aDetail' href='javascript:' onclick='showMapPoint(" + i + ")'>监测点#" + i + "</a></span>" +
                        "<input class='inputText' flagInput='lng'>　" +
                        "<input class='inputText' flagInput='lat'>" +
                        "</li>";
            }
            $("#divRegMap .divMapReg ul.ulPoints").html(htmlUl);
        }
        function showMapLines() { //绘制折线图
            /*var points = [];
             mapBaidu.addEventListener("click", function (e) {
             mapBaidu.clearOverlays();
             points.push(new BMap.Point(e.point.lng, e.point.lat));
             DrawPolyline(points);
             });*/
            pLines = []; //用来存储折线的点
            var doneDraw = 0; //判断是否绘制折线结束
            var defaultCursor = mapBaidu.getDefaultCursor();
            mapBaidu.setDefaultCursor("crosshair"); //改变鼠标样式:十字形状
            mapBaidu.addEventListener("click", function (e) {
                //当鼠标单击时
                if (doneDraw == 0) {
                    //判断是否绘制折线完毕
                    pLines.push(new BMap.Point(e.point.lng, e.point.lat));
                    ;
                    ;
                    ;
                    ;
                    ;
                    ;
                    ; //存储曲线上每个点的经纬度
                    updateLineInput(e.point.lng, e.point.lat);   //同步更新经纬坐标至左侧菜单
                    if (polyline) {
                        polyline.setPath(pLines);
                    }
                    //如果曲线存在，则获取折线上的点
                    else {
                        polyline = new BMap.Polyline(pLines);
                    }
                    //如果折线不存在，就增加此点
                    if (pLines.length < 2) {
                        return;
                    }
                    //当折线上的点只有一个时，不绘制
                    mapBaidu.addOverlay(polyline); //绘制曲线
                }
            });
            mapBaidu.addEventListener("dblclick", function (e) {   //双击结束绘制折线
                doneDraw = 1;
                mapBaidu.setDefaultCursor(defaultCursor); //改变鼠标样式:十字形状
            });
        }
        function DrawPolyline(points) {
            var polyline = new BMap.Polyline(points, {strokeColor: "blue", strokeWeight: 6, strokeOpacity: 0.5});
            mapBaidu.addOverlay(polyline);
        }
        function updateLineInput(lng, lat) {
            var liHtml = "<li><span>" +
                    "<input class='inputText' value='" + lng + "'>　" +
                    "<input class='inputText' value='" + lat + "'>" +
                    "</span></li>";
            $("#divRegMap .divMapReg ul.ulLines").append(liHtml);
        }
        function removeMapLines() {
            $("#divRegMap .divMapReg ul.ulLines").html("");
            mapBaidu.removeOverlay(polyline);
        }
        function showMapPoint(id) {  //设置监测点的坐标点
            mapBaidu.addEventListener("click", function (e) {
                //当鼠标单击时
                checkPoint(id);
                var point = new BMap.Point(e.point.lng, e.point.lat);
                var marker = new BMap.Marker(point);
                mapBaidu.addOverlay(marker);
                mapPoints.put(id + "", marker);
            });
        }
        function checkPoint(id) {    //检查是否有重复添加的监测点
            var marker_old = mapPoints.get(id + "");
            if (marker_old) {  //地图上已存在该监测点
                mapBaidu.removeOverlay(marker_old);
                //marker.dispose();
            }
        }
        function initMapSearch() {
            var ac = new BMap.Autocomplete(    //建立一个自动完成的对象
                    {
                        "input": "suggestId"
                        , "location": mapBaidu
                    });

            ac.addEventListener("onhighlight", function (e) {  //鼠标放在下拉列表上的事件
                var str = "";
                var _value = e.fromitem.value;
                var value = "";
                if (e.fromitem.index > -1) {
                    value = _value.province + _value.city + _value.district + _value.street + _value.business;
                }
                str = "FromItem<br />index = " + e.fromitem.index + "<br />value = " + value;

                value = "";
                if (e.toitem.index > -1) {
                    _value = e.toitem.value;
                    value = _value.province + _value.city + _value.district + _value.street + _value.business;
                }
                str += "<br />ToItem<br />index = " + e.toitem.index + "<br />value = " + value;
                $("#searchResultPanel").html(str);
                //G("searchResultPanel").innerHTML = str;
            });

            var myValue;
            ac.addEventListener("onconfirm", function (e) {    //鼠标点击下拉列表后的事件
                var _value = e.item.value;
                myValue = _value.province + _value.city + _value.district + _value.street + _value.business;
                $("#searchResultPanel").html("onconfirm<br />index = " + e.item.index + "<br />myValue = " + myValue);
                //G("searchResultPanel").innerHTML ="onconfirm<br />index = " + e.item.index + "<br />myValue = " + myValue;

                setPlace();
            });
        }
        function setPlace() {
            //mapBaidu.clearOverlays();    //清除地图上所有覆盖物
            function myFun() {
                var pp = local.getResults().getPoi(0).point;    //获取第一个智能搜索的结果
                mapBaidu.centerAndZoom(pp, 18);
                mapBaidu.addOverlay(new BMap.Marker(pp));    //添加标注
            }

            var local = new BMap.LocalSearch(myValue, { //智能搜索
                onSearchComplete: myFun
            });
            local.search(myValue);
        }
    </script>
    <style>
        #divRegMap {
            z-index: 55555;
            width: 100%;
            height: 100%;
            position: absolute;
            top: 0;
            left: 0;
            background-color: #FFF;
        }

        #divRegMap .divMapReg {
            width: 340px;
            float: left;
            text-align: left;
        }

        #divRegMap .divMapReg ul {
            list-style: none;
            padding: 0 15px;
        }

        #divRegMap .divMapReg ul li {
            margin-bottom: 10px;
        }

        #divRegMap .divMapReg ul li.liTitle {
            background-color: #BDBCBC;
            padding: 7px 5px;
            border-radius: 5px;
        }

        #divRegMap .divMapReg ul li.liMapSave a {
            font-size: 16px;
            padding: 10px 12px 8px;
        }

        #divRegMap .divMapReg ul li ul.ulPoints {
            max-height: 350px;
            display: block;
            overflow-y: auto;
        }

        #divRegMap .divMapReg ul li ul.ulPoints span.spanPoint {
            width: 105px;
            display: inline-block;
        }

        #divRegMap .divMapReg ul li ul.ulLines {
            padding: 0;
        }

        #divRegMap .divMapReg ul li input.inputText {
            width: 80px;
        }

        #divRegMap .divContent {
            height: 100%;
            overflow: hidden;
            zoom: 1;
            position: relative;
            box-shadow: none;
            border-left: 1px solid #13C3C3;
            border-radius: 0;
        }
    </style>
</head>
<body>
<div id="divRegMap" class="hide">
    <div class="divMapReg">
        <ul>
            <li class="liTitle">
                <span>地址定位</span>
            </li>
            <li>
                <div id="r-result">请输入:<input type="text" id="suggestId" size="20" value="百度" style="width:150px;"/>
                </div>
                <div id="searchResultPanel"
                     style="border:1px solid #C0C0C0;width:150px;height:auto; display:none;"></div>
            </li>
            <li class="liTitle">
                <span>设置电缆沟</span>
            </li>
            <li>
                <ul class="ulLines"></ul>
            </li>
            <li>
                <a class='aBtn aDetail' href='javascript:' onclick="showMapLines()">绘制</a>　　
                <a class='aBtn aRed' href='javascript:' onclick="removeMapLines()">清空</a>
            </li>
            <li class="liTitle">
                <span>设置监测点</span>
            </li>
            <li>
                <ul class="ulPoints"></ul>
            </li>
            <li class="liMapSave">
                <a class='aBtn aOut' href='javascript:' onclick="saveRegMap()">保存配置</a>
            </li>
        </ul>
    </div>
    <div class="divContent" align="center">
        <div id="baiduMap"
             style="height:100%;-webkit-transition: all 0.5s ease-in-out;transition: all 0.5s ease-in-out;"></div>
    </div>
</div>
</body>
</html>
