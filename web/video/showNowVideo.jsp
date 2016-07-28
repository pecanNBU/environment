<%--
  Created by IntelliJ IDEA.
  User: Jenny
  Date: 16/5/11
  Time: 09:52
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE HTML>
<html>
<head>
    <title>视频监控-实时</title>
    <script type="text/javascript" src="../js/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <script type="text/javascript" src="../js/jquery.SuperSlide.2.1.1.js"></script>
    <script>
        window.onload = function () {
            $(".slideTxtBox").slide();
            res();
        };
        $(window).resize(function () {
            res();
        });
        function res() {
            var pWidth = _width();
            var pHeight = _height();
            var imgWidth = pWidth - 250;
            $("#ulVideo img").width(imgWidth / 2 - 5).height(pHeight / 2 - 5);
        }
    </script>
    <style>
        html, body {
            margin: 0;
            padding: 0;
        }

        ul, li {
            margin: 0;
            padding: 0;
            list-style: none;
        }

        #ulVideo {
            float: right;
            display: inline-block;
            position: absolute;
        }

        #ulVideo li {
            padding: 0;
            margin: 0;
            width: 49%;
            border: 1px solid #7B7B7B;
            display: inline-block;
            position: relative;
        }

        /*#ulVideo img{
            width: 100%;
        }*/
        #ulVideo span {
            color: #FFF;
        }

        #ulVideo span.spanTitle {
            position: absolute;
            top: 5px;
            left: 5px;
        }

        #ulVideo span.spanDate {
            position: absolute;
            top: 5px;
            right: 5px;
        }

        #ulVideo span.spanData {
            position: absolute;
            top: 28px;
            left: 5px;
        }

        #ulVideo span.spanData span {
            display: block;
            margin-top: 5px;
        }

        #ulContr {
            width: 250px;
            margin: 3px;
            float: left;
            display: inline-block;
            font-size: 14px;
        }

        #ulContr li.liHolder {
            background-color: #E2E2E2;
        }

        #ulContr li.liHolder span {
            width: 42px;
            height: 33px;
            display: table-cell;
            text-align: center;
            vertical-align: middle;
            background-color: white;
            border: 4px solid #E2E2E2;
            border-radius: 7px;
        }

        #ulContr li.liHolder span.spanBig img {
            width: 18px;
        }

        #ulContr li.liHolder img {
            width: 13px;
        }

        #ulContr li.liSpeed {
            background-color: #CACACA;
            background-image: -moz-linear-gradient(top, #F1F1F1, #CACACA); /* Firefox */
            background-image: -webkit-gradient(linear, left top, left bottom, color-stop(0, #F1F1F1), color-stop(1, #CACACA)); /* Saf4+, Chrome */
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#F1F1F1', endColorstr='#CACACA', GradientType='0'); /* IE*/
            background: linear-gradient(to bottom, #F1F1F1, #CACACA);
        }

        #ulContr li.liSpeed span {
            width: 42px;
            height: 32px;
            display: table-cell;
            text-align: center;
            vertical-align: middle;
        }

        #ulContr li.liSpeed img {
            width: 13px;
        }

        #ulContr li.liFocus {
            background-color: #E2E2E2;
        }

        #ulContr li.liFocus span {
            width: 32px;
            height: 32px;
            display: table-cell;
            text-align: center;
            vertical-align: middle;
            background-color: white;
            border: 4px solid #E2E2E2;
            border-radius: 7px;
        }

        #ulContr li.liFocus span img {
            width: 20px;
        }

        #ulContr li.liFocus span.spanAdjust {
            width: 18px;
        }

        #ulContr li.liFocus span.spanAdjust img {
            width: 15px;
        }

        #ulContr span.spanTitle {
            display: block;
            padding: 7px 5px;
            background-color: #B5B5B5;
            background-image: -moz-linear-gradient(top, #EAE9E9, #B5B5B5); /* Firefox */
            background-image: -webkit-gradient(linear, left top, left bottom, color-stop(0, #EAE9E9), color-stop(1, #B5B5B5)); /* Saf4+, Chrome */
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#EAE9E9', endColorstr='#B5B5B5', GradientType='0'); /* IE*/
            background: linear-gradient(to bottom, #EAE9E9, #B5B5B5);
            border-radius: 3px;
            font-size: 15px;
            font-weight: bold;
        }

        #ulContr ul.ulMonitor {
            padding: 0 5px;
        }

        ul.ulMonitor li:nth-child(even), ul.ulMoni li:nth-child(even), ul.ulCont li.liCont:nth-child(even) {
            background-color: #f6f7fa;
        }

        ul.ulMonitor li:nth-child(odd), ul.ulMoni li:nth-child(odd), ul.ulCont li.liCont:nth-child(odd) {
            background-color: white;
        }

        #ulContr ul.ulMonitor li {
            margin: 5px 0;
            width: 100%;
            display: inline-block;
        }

        #ulContr ul.ulMonitor span.spanLabel {
            line-height: 25px;
            float: left;
            margin-left: 10px;
        }

        #ulContr ul.ulMonitor span.spanPara {
            float: left;
            margin-right: 5px;
        }

        #ulContr ul.ulMonitor img {
            width: 22px;
            float: left;
        }

        #ulContr li.liBtn img {
            width: 18px;
            padding-top: 3px;
            margin-right: 7px;
        }

        #ulContr ul.ulMoni {
            padding: 0 5px;
        }

        #ulContr ul.ulMoni li {
            padding: 5px 0;
        }

        #ulContr ul.ulMonitor img.imgSelected {
            width: 23px;
            margin-left: 10px;
        }

        /* 本例子css */
        .slideTxtBox {
            border: 1px solid #ddd;
            text-align: left;
        }

        .slideTxtBox .hd {
            height: 30px;
            line-height: 30px;
            background: #f4f4f4;
            padding: 0 10px 0 20px;
            border-bottom: 1px solid #ddd;
            position: relative;
        }

        .slideTxtBox .hd ul {
            float: left;
            position: absolute;
            left: -1px;
            top: -1px;
            height: 32px;
        }

        .slideTxtBox .hd ul.ulTitle {
            font-weight: bold
        }

        .slideTxtBox .hd ul li {
            float: left;
            padding: 0 15px;
            cursor: pointer;
        }

        .slideTxtBox .hd ul li.on {
            height: 30px;
            background: #fff;
            border: 1px solid #ddd;
            border-bottom: 2px solid #fff;
        }

        .slideTxtBox .bd ul {
            padding: 0 15px;
            zoom: 1;
        }

        .slideTxtBox .bd li {
            padding: 5px 0;
        }

        .slideTxtBox .bd li .date {
            float: right;
            color: #999;
        }

        /*自定义checkbox,radio的样式-源自Bootstrap*/
        .icheckbox_green, .iradio_green {
            display: inline-block;
            vertical-align: middle;
            margin: 0;
            padding: 0;
            width: 22px;
            height: 22px;
            background: url(../img/green_11.png) no-repeat;
            border: none;
            cursor: pointer;
            top: -1px;
            left: 0;
            line-height: 18px;
            -webkit-background-size: 288px 24px;
            background-size: 288px 24px;
        }

        .iradio_green {
            background-position: -120px 0;
        }

        .icheckbox_green input, .iradio_green input {
            top: -20%;
            left: -20%;
            display: block;
            width: 120%;
            height: 120%;
            margin: 0px;
            padding: 0px;
            border: 0px;
            opacity: 0;
            background: rgb(255, 255, 255);
            box-sizing: border-box;
            line-height: normal;
            vertical-align: baseline;
            cursor: pointer;
        }

        .icheckbox_green.checked {
            background-position: -48px 0;
        }

        .icheckbox_green.hover {
            background-position: -24px 0;
        }

        .iradio_green.checked {
            background-position: -168px 0;
        }

        .iradio_green.hover {
            background-position: -144px 0;
        }

        .icheckbox_green.null {
            background-position: -240px 0;
            cursor: not-allowed;
        }

        /*结束iCheck样式*/
    </style>
</head>
<body>
<ul id="ulContr">
    <li>
        <span class="spanTitle">视图</span>
        <ul class="ulMonitor">
            <li>
                <span class="spanPara">
                    <div class="icheckbox_green">
                        <input type="checkbox" name="radio_contr" value="1" flagInput='iCheck'>
                    </div>
                </span>
                <img src="../img/video/video_monitor.png">
                <span class="spanLabel">1 - 画面</span>
            </li>
            <li>
                <span class="spanPara">
                    <div class="icheckbox_green checked">
                        <input type="checkbox" name="radio_contr" value="1" flagInput='iCheck'>
                    </div>
                </span>
                <img src="../img/video/video_monitor_4.png">
                <span class="spanLabel">4 - 画面</span>
            </li>
            <li>
                <span class="spanPara">
                    <div class="icheckbox_green">
                        <input type="checkbox" name="radio_contr" value="1" flagInput='iCheck'>
                    </div>
                </span>
                <img src="../img/video/video_monitor_9.png">
                <span class="spanLabel">9 - 画面</span>
            </li>
            <li>
                <span class="spanPara">
                    <div class="icheckbox_green">
                        <input type="checkbox" name="radio_contr" value="1" flagInput='iCheck'>
                    </div>
                </span>
                <img src="../img/video/video_monitor_16.png">
                <span class="spanLabel">16 - 画面</span>
            </li>
        </ul>
    </li>
    <li>
        <span class="spanTitle">监控点</span>
        <ul class="ulMoni">
            <li>
                <span class="spanPara">
                    <div class="icheckbox_green checked">
                        <input type="checkbox" name="radio_contr" value="1" flagInput='iCheck'>
                    </div>
                </span>
                <span>1#监控点</span></li>
            <li>
                <span class="spanPara">
                    <div class="icheckbox_green checked">
                        <input type="checkbox" name="radio_contr" value="1" flagInput='iCheck'>
                    </div>
                </span>
                <span>2#监控点</span>
            </li>
            <li>
                <span class="spanPara">
                    <div class="icheckbox_green checked">
                        <input type="checkbox" name="radio_contr" value="1" flagInput='iCheck'>
                    </div>
                </span>
                <span>3#监控点</span>
            </li>
            <li>
                <span class="spanPara">
                    <div class="icheckbox_green checked">
                        <input type="checkbox" name="radio_contr" value="1" flagInput='iCheck'>
                    </div>
                </span>
                <span>4#监控点</span>
            </li>
        </ul>
    </li>
    <li>
        <span class="spanTitle">云台控制</span>
        <ul>
            <li class="liHolder">
                <span><img src="../img/video/video_arrow_leftUp.png"></span>
                <span><img src="../img/video/video_arrow_up.png"></span>
                <span><img src="../img/video/video_arrow_rightUp.png"></span>
                <span><img src="../img/video/video_plus.png"></span>
                <span class="spanBig"><img src="../img/video/video_focus.png"></span>
                <span><img src="../img/video/video_minus.png"></span>
            </li>
            <li class="liHolder">
                <span><img src="../img/video/video_arrow_left.png"></span>
                <span class="spanBig"><img src="../img/video/video_scan.png"></span>
                <span><img src="../img/video/video_arrow_right.png"></span>
                <span><img src="../img/video/video_plus.png"></span>
                <span class="spanBig"><img src="../img/video/video_aperture.png"></span>
                <span><img src="../img/video/video_minus.png"></span>
            </li>
            <li class="liHolder">
                <span><img src="../img/video/video_arrow_leftDown.png"></span>
                <span><img src="../img/video/video_arrow_down.png"></span>
                <span><img src="../img/video/video_arrow_rightDown.png"></span>
                <span><img src="../img/video/video_plus.png"></span>
                <span class="spanBig"><img src="../img/video/video_change.png"></span>
                <span><img src="../img/video/video_minus.png"></span>
            </li>
            <li class="liSpeed">
                <span><img src="../img/video/video_minus.png"></span>
                <span style="width: 166px"><input type="range" name="points" min="1" max="10"/></span>
                <span><img src="../img/video/video_plus.png"></span>
            </li>
            <li class="liFocus">
                <span class="spanAdjust"><img src="../img/video/video_left.png"></span>
                <span><img src="../img/video/video_3DPoint.png"></span>
                <span><img src="../img/video/video_focus1.png"></span>
                <span><img src="../img/video/video_focus2.png"></span>
                <span><img src="../img/video/video_light.png"></span>
                <span><img src="../img/video/video_wiper.png"></span>
                <span class="spanAdjust"><img src="../img/video/video_right.png"></span>
            </li>
            <li>
                <div class="slideTxtBox">
                    <div class="hd">
                        <ul class="ulTitle">
                            <li>预置点</li>
                            <li>轨迹</li>
                            <li>巡航</li>
                        </ul>
                    </div>
                    <div class="bd">
                        <ul class="ulCont">
                            <li class="liBtn">
                                <img src="../img/video/video_start.png">
                                <img src="../img/video/video_edit.png">
                                <img src="../img/video/video_remove.png">
                            </li>
                            <li class="liCont">01　1#预置点</li>
                            <li class="liCont">02　2#预置点</li>
                            <li class="liCont">03　3#预置点</li>
                            <li class="liCont">04　4#预置点</li>
                        </ul>
                        <ul>
                            轨迹
                        </ul>
                        <ul>
                            巡航
                        </ul>
                    </div>
                </div>
            </li>
        </ul>
    </li>
</ul>
<ul id="ulVideo">
    <li>
        <img src="../img/video_0.jpg">
        <span class="spanTitle">1#监控点</span>
        <span class="spanDate">2016年5月11日 09:55:25</span>
        <span class="spanData">
            <span>噪声值：58.6 db</span>
            <span>TSP：430.5 mg/m³</span>
        </span>
    </li>
    <li>
        <img src="../img/video_1.jpg">
        <span class="spanTitle">2#监控点</span>
        <span class="spanDate">2016年5月11日 09:55:23</span>
        <span class="spanData">
            <span>噪声值：50.8 db</span>
            <span>TSP：410.1 mg/m³</span>
        </span>
    </li>
    <li>
        <img src="../img/video_2.jpg">
        <span class="spanTitle">3#监控点</span>
        <span class="spanDate">2016年5月11日 09:55:28</span>
        <span class="spanData">
            <span>噪声值：57.2 db</span>
            <span>TSP：422.7 mg/m³</span>
        </span>
    </li>
    <li>
        <img src="../img/video_3.jpg">
        <span class="spanTitle">4#监控点</span>
        <span class="spanDate">2016年5月11日 09:55:48</span>
        <span class="spanData">
            <span>噪声值：55.4 db</span>
            <span>TSP：440.2 mg/m³</span>
        </span>
    </li>
</ul>
</body>
</html>
