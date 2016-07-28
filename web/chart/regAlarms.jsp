<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="sx" uri="/struts-dojo-tags" %>
<html>
<head>
    <title>单个设备的异常记录</title>
    <link href="../org/style.css" rel="stylesheet" type="text/css"/>
    <style>
        table {
            table-layout: fixed;
        }

        td {
            word-break: break-all;
            word-wrap: break-word;
        }
    </style>
</head>
<body>
<img title="关闭" onclick="closeDiv('alarms')" src="../img/close.png" name="Image_close" onmouseover="imageOver(name);"
     onmouseout="imageReset(name);" border="none" style="cursor:pointer;position:absolute;right:-15px;top:-15px">
<div id="log" style="background-color:#f0fcff;height:500px;overflow:auto">
    <table id='vd1' class='vd' style='font-size:13px;' cellspacing='0' cellpadding='0'>
        <tr>
            <th style='width:5%;' align='center'>序号</th>
            <th style='width:20%;' align='center'>异常日期</th>
            <th style='width:15%;' align='center'>异常设备</th>
            <th style='width:20%;' align='center'>异常参数</th>
            <th style='width:10%;' align='center'>异常值</th>
            <th style='width:10%;' align='center'>正常值</th>
            <th style='width:20%;' align='center'>故障诊断</th>
        </tr>
    </table>
    <div style='text-align:center; margin:0;padding:0px;overflow:auto;height:415px;' id="dvd">
        <table id='vd2' class='vd' style='font-size:12px;width:100%' cellspacing='0' cellpadding='0'>
        </table>
    </div>
    <div class='ppa'>
        <a href="javascript:" onclick="outAlarm();">导出</a>
        <div id='ppages' style='height:25px'></div>
    </div>
    <s:form name="formAlarm">
    </s:form>
</div>
</body>
</html>