<%--
  Created by IntelliJ IDEA.
  User: Jenny
  Date: 16/5/27
  Time: 09:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>APP首页</title>
    <style>
        body {
            width: 420px;
            margin: 20px;
            font-size: 17px;
            font-family: 微软雅黑;
        }

        ul, li {
            padding: 0;
            margin: 0;
            list-style: none;
        }

        .spanBig {
            font-size: 24px;
        }

        .bold {
        }

        .fLeft {
            float: left;
        }

        .fRight {
            float: right;
        }

        #main {
            color: white;
            position: absolute;
            z-index: 5;
            margin-top: 20px;
        }

        #main div {
            margin: 20px 0;
        }

        #divHeader {
            border-bottom: 1px solid gray;
            height: 40px;
            line-height: 40px;
        }

        #divState li {
            margin: 10px 0;
            font-size: 15px;
        }

        #divParam {
            margin: 30px 0;
            font-size: 14px;
        }

        #divParam div {
            display: inline-block;
            width: 160px;
            text-align: center;
        }

        #divParam .sData {
            display: block;
            font-size: 70px;
            margin-bottom: 10px;
        }

        #divParam .sData1 {
            display: block;
            font-size: 50px;
            margin-bottom: 10px;
        }

        #divMore .sTitle {
            display: inline-block;
            width: 120px;
        }

        #divMore .sPeriod {

        }

        #divMore .sData {
            float: right;
        }

        #divMore .sUnit {
            font-size: 12px;
        }

        #divMore li {
            margin: 25px 0;
        }

        #imgBg {
            position: absolute;
            top: 0;
            left: 0;
            width: 29%;
        }

        #imgHead {
            position: absolute;
            top: 0;
            left: 0;
            width: 29%;
            z-index: 5;
        }

        #divBottom {
            position: absolute;
            z-index: 5;
            color: gray;
            width: 371.19px;
            background-color: white;
            height: 35px;
            line-height: 35px;
            font-size: 15px;
            left: 0;
            bottom: 42px;
        }

        #divBottom li {
            width: 19%;
            display: inline-block;
            text-align: center;
        }
    </style>
</head>
<body>
<div id="main">
    <div id="divHeader" style="margin-top: 0">
        <span class="fLeft spanBig bold">春晓工业园</span>
        <img src="../img/app_set.png" style="width: 24px;float: right;margin-top: 10px">
    </div>
    <div id="divState">
        <ul>
            <li><span class="sTitle">工地状态：</span><span class="sData">施工中</span></li>
            <li><span class="sTitle">环境质量：</span><span class="sData">正常</span></li>
            <li><span class="sTitle">监测时间：</span><span class="sData">2016-05-27 13:08:34</span></li>
        </ul>
    </div>
    <div id="divParam">
        <div>
            <span class="sData">62.6</span>
            <span class="sType">总颗粒物浓度</span><span class="sUnit">（μg/m3）</span>
        </div>
        <div>
            <span class="sData1">53.7</span>
            <span class="sType">噪声</span><span class="sUnit">（dB）</span>
        </div>
    </div>
    <div id="divMore">
        <ul>
            <li>
                <span class="sTitle">温度<span class="sUnit">（℃）</span></span>
                <span class="sPeriod">/小时</span>
                <span class="sData">22.1</span>
            </li>
            <li>
                <span class="sTitle">湿度<span class="sUnit">（%）</span></span>
                <span class="sPeriod">/小时</span>
                <span class="sData">96.2</span>
            </li>
            <li>
                <span class="sTitle">风速<span class="sUnit">（m/s）</span></span>
                <span class="sPeriod">/小时</span>
                <span class="sData">1.6</span>
            </li>
            <li>
                <span class="sTitle">风向</span>
                <span class="sPeriod">/小时</span>
                <span class="sData">偏北</span>
            </li>
            <li>
                <span class="sTitle">气压<span class="sUnit">（hPa）</span></span>
                <span class="sPeriod">/小时</span>
                <span class="sData">1007</span>
            </li>
            <li>
                <span class="sTitle">雨量<span class="sUnit">（mm）</span></span>
                <span class="sPeriod">/小时</span>
                <span class="sData">0</span>
            </li>
        </ul>
    </div>
</div>
<div id="divBottom">
    <ul>
        <li style="background-color: #6CB5CC;color: white"><span>实时</span></li>
        <li><span>地图</span></li>
        <li><span>监控</span></li>
        <li><span>报表</span></li>
        <li><span>更多</span></li>
    </ul>
</div>
<img src="../img/app_top.png" id="imgHead">
<img src="../img/app_bg.jpg" id="imgBg">
</body>
</html>
