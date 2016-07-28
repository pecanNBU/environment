<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
<head>
    <title>系统状态管理</title>
    <script type="text/javascript" src="../js/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <link href="../css/style.css" rel="stylesheet" type="text/css"/>
    <script>
        var scriptType;	//脚本类型【1：重启服务器；2：停止服务器】
        var runState;	//运行状态【1：运行中；0：未运行】
        $(function () {
            //$("div.divMain table.vu:not(:last)").css("margin-bottom", "20px");
            $("table.vu").find("tr:gt(1)").find("td:even").addClass("cBlue cRight bold");
            $("table.vu").find("tr:gt(1)").find("td:odd").addClass("bb cLeft");
            res();
            $.ajax({		//获取系统信息
                type: "post",
                dataType: "json",
                url: "system/json_systemStates.action",
                success: function callBack(data) {
                    var map = data.map;
                    $("#systemDutyUserName").html(map.dutyUserName);
                    $("#systemName").html(map.systemName);
                    $("#systemAbbr").html(map.systemAbbr);
                    $("#systemVersion").html(map.version);
                    $("#systemUpdateDt").html(map.updateDt);
                    $("#systemVersionDesc").html(map.versionDesc);
                    $("#systemCopyright").html(map.copyright);
                    $("#systemFax").html(map.fax);
                    $("#systemTelephone").html(map.telephone);
                    $("#systemEmail").html(map.email);
                    $("#systemWebsite").html(map.website);
                    var regExcep = map.regExcep;
                    $("#regExcep").html(transRegState(regExcep));
                    var regComm = map.regComm;
                    $("#regComm").html(transRegState(regComm));
                    var systemDate = map.systemDate;
                    $("#systemStDt").html(map.systemStDt);
                    $("#systemDate").html(map.systemDate);
                    runState = map.runState;
                    if (runState == 1) {	//正在运行
                        $("#dataRun").attr("class", "aBtn aGreen").html("获取数据中")
                    }
                    else {
                        $("#dataRun").attr("class", "aBtn aRed").html("未获取数据")
                    }
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        });

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

        function restartSystem() {	//重启
            scriptType = 1;
            beCenter("divPath");
            $("#detail_bg").show();
            $("#divPath").show(300);
            $("#scriptPath").val("D:\\WNWL\\CPN2025\\tomcat7\\bin\\restart_.bat");
            ;
            ;
            ;
            ;
            ;
            ;
            ;
            /*$.ajax({
             type: "post",
             dataType: "json",
             url: "system/json_restartSystem.action",
             success:function callBack(data){
             var map = data.map;
             },
             error:function(data){
             ajaxError(data);
             }
             });*/
        }

        function stopSystem() {		//停止运行
            scriptType = 2;
            beCenter("divPath");
            $("#detail_bg").show();
            $("#divPath").show(300);
            $("#scriptPath").val("D:\\WNWL\\CPN2025\\tomcat7\\bin\\shutdown_.bat");
            ;
            ;
            ;
            ;
            ;
            ;
            ;
            /*$.ajax({
             type: "post",
             dataType: "json",
             url: "system/json_stopSystem.action",
             success:function callBack(data){
             var map = data.map;
             },
             error:function(data){
             ajaxError(data);
             }
             });*/
        }
        function scriptDone() {	//输入脚本路径
            $("#detail_bg").css("z-index", "50010");
            beCenter("waiting");
            $("#waitings").html("处理中，请稍候....");
            $("#waiting").show();
            var scriptPath = $("#scriptPath").val();
            $.ajax({
                type: "post",
                dataType: "json",
                url: "json_systemScript?scriptType=" + scriptType + "&scriptPath=" + scriptPath,
                success: function (data) {
                    var flag = data.flag;
                    if (flag == 0) {
                        $("#divPath,#waiting,#detail_bg").hide();
                        if (scriptType == 1)
                            error_alert("正在重启，请在半分钟后重启浏览器并访问服务器", 30000);
                        else {
                            error_alert("已停止服务器", 30000);
                            window.close();	//关闭本页面
                        }
                    }
                    else {
                        error_alert("路径错误，请重试或联系管理员", 2500);
                        $("#strPath").focus();
                        $("#waiting").hide();
                        $("#detail_bg").css("z-index", "50000");
                    }
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        }
        function runData() {
            $("#detail_bg").css("z-index", "50010").show();
            beCenter("waiting");
            $("#waitings").html("处理中，请稍候....");
            $("#waiting").show();
            $.ajax({
                type: "post",
                dataType: "json",
                url: "json_runData?runState=" + runState,
                success: function (data) {
                    var flag = data.flag;
                    if (flag == 0) {		//操作失败
                        top.success(1, "操作失败，请检查配置文件或联系管理员");
                    }
                    else if (flag == 1) {	//已停止
                        top.success(0, "操作成功，已停止获取数据");
                        runState = 0;
                        $("#dataRun").attr("class", "aBtn aRed").html("未获取数据");
                        ;
                        ;
                        ;
                        ;
                        ;
                        ;
                        ;
                        top.iframe1.foot.transState(1);
                    }
                    else if (flag == 2) {	//启动成功
                        top.success(0, "操作成功，已开始获取数据");
                        runState = 1;
                        $("#dataRun").attr("class", "aBtn aGreen").html("获取数据中");
                        top.iframe1.foot.transState(0);
                    }
                    else if (flag == 3) {	//启动失败
                        top.success(1, "操作失败，请检查配置文件或联系管理员");
                        runState = 0;
                        $("#dataRun").attr("class", "aBtn aRed").html("未获取数据")
                    }
                    $("#waiting").hide();
                    $("#detail_bg").hide().css("z-index", "50000");
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        }
        $(window).resize(function () {
            res();
        });
        function res() {
            $("#detail_bg").height(document.body.scrollHeight);
        }
    </script>
    <style>
        body {
            overflow: auto;
        }

        table {
            table-layout: fixed;
        }

        td {
            word-break: break-all;
            word-wrap: break-word;
        }

        .cTitle {
            margin: 10px 0
        }

        .cLeft {
            text-align: left;
            padding: 5px 10px;
        }

        .cRight {
            text-align: right;
            padding-right: 10px;
            background-color: #F7F9FC;
        }

        .trTitle {
            background: #d3d3d3;
            background-image: -moz-linear-gradient(top, #efefef, #d3d3d3);
            background-image: -webkit-gradient(linear, left top, left bottom, color-stop(0, #efefef), color-stop(1, #d3d3d3));
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#efefef', endColorstr='#d3d3d3', GradientType='0');
            background: linear-gradient(to bottom, #efefef, #d3d3d3)
        }

        .vu {
            border: 1px solid #d3d3d3;
            border-collapse: collapse;
            width: 100%;
            background-color: white
        }

        .vu th {
            background-color: #EFEFEF;
            color: #000;
            border: 1px solid #cbccdo
        }

        .vu tr {
            height: 45px;
            font-size: 15px;
        }

        .vu td {
            border: 1px solid #d3d3d3
        }

        #divPath {
            position: fixed;
        }
    </style>
</head>
<body>
<div class="divMain">
    <table class="vu" border="0" cellspacing="0" cellpadding="0" id="systemBase">
        <tr style="height:1px;">
            <td width="15%"></td>
            <td width="35%"></td>
            <td width="15%"></td>
            <td width="35%"></td>
        </tr>
        <tr class="trTitle">
            <td colspan="4">
                <div align="left" class="devClass ml20">基础信息：　</div>
            </td>
        </tr>
        <tr>
            <td>　系统全称：</td>
            <td id="systemName"></td>
            <td>　系统简称：</td>
            <td id="systemAbbr"></td>
        </tr>
        <tr>
            <td>　负责人：</td>
            <td id="systemDutyUserName"></td>
            <td>　版本号：</td>
            <td id="systemVersion"></td>
        </tr>
        <tr>
            <td>版权所有：</td>
            <td id="systemCopyright"></td>
            <td>电子邮箱：</td>
            <td id="systemEmail"></td>
        </tr>
        <tr>
            <td>联系电话：</td>
            <td id="systemTelephone"></td>
            <td>公司传真：</td>
            <td id="systemFax"></td>
        </tr>
        <tr>
            <td>公司网站：</td>
            <td id="systemWebsite"></td>
            <td>更新日期：</td>
            <td id="systemUpdateDt"></td>
        </tr>
        <tr>
            <td>版本说明：</td>
            <td colspan="3" id="systemVersionDesc"></td>
        </tr>
    </table>
    <table class="vu" border="0" cellspacing="0" cellpadding="0" id="systemData">
        <tr style="height:1px;">
            <td width="15%"></td>
            <td width="35%"></td>
            <td width="15%"></td>
            <td width="35%"></td>
        </tr>
        <tr class="trTitle">
            <td colspan="4">
                <div align="left" class="devClass ml20">通信状态：　</div>
            </td>
        </tr>
        <tr>
            <td>　数据状态：</td>
            <td id="regExcep"></td>
            <td>　通信状态：</td>
            <td id="regComm"></td>
        </tr>
    </table>
    <table class="vu" border="0" cellspacing="0" cellpadding="0" id="systemState">
        <tr style="height:1px;">
            <td width="15%"></td>
            <td width="35%"></td>
            <td width="15%"></td>
            <td width="35%"></td>
        </tr>
        <tr class="trTitle">
            <td colspan="4">
                <div align="left" class="devClass ml20">系统状态：　</div>
            </td>
        </tr>
        <tr>
            <td>　系统启动时间：</td>
            <td id="systemStDt"></td>
            <td>　系统已运行时间：</td>
            <td id="systemDate"></td>
        </tr>
        <tr>
            <td>　系统操作：</td>
            <td colspan="3">
                <!-- <a class='aBtn aRed' href='javascript:' onclick='restartSystem();'>重启系统</a>　 -->
                <a class='aBtn aRed' href='javascript:' onclick='stopSystem();'>停止运行</a>　
                <a class='aBtn' id="dataRun" href='javascript:' onclick='runData();'>停止运行</a>
            </td>
        </tr>
    </table>
</div>
<div id="detail" class="div_alt"></div>
<div id="detail_bg"></div>
<div id="waiting"><span id="waitings"></span></div>
<div id="divPath" class="div_alt divFloat">
    <div class="queryBody" style="width: 520px">
        <div class="detail_title" onmousedown="mouseDownFun('divPath')"><span class="detail_header">　脚本信息</span><span
                class="detail_close" onclick="closeDiv('divPath')" title="关闭">X</span></div>
        <div class="queryContent">
            <ul>
                <li class="queryLeft">脚本路径：</li>
                <li><input id="scriptPath" Style="width:280px" class="inputText"></li>
            </ul>
        </div>
        <div class="queryBtn">
            <input value="确定" class="btn_1" type="button" flag="done" onclick="scriptDone();"/>
            　　<input value="取消" class="btn_2" type="button" onclick="closeDiv('divPath');"/>
        </div>
    </div>
</div>
</body>
</html>