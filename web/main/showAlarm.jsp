<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="sx" uri="/struts-dojo-tags" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<html>
<head>
    <title>单个设备的异常记录</title>
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
<img title="关闭" onclick="closeDiv('alarm')" src="<%=basePath%>img/close.png" name="Image_close"
     onmouseover="imageOver(name);" onmouseout="imageReset(name);" border="none"
     style="cursor:pointer;position:absolute;right:-15px;top:-15px;z-index:66666">
<div name="devc_c" style="background-color:#f0fcff;overflow-y:auto;overflow-x:hidden;border-radius:5px;">
    <div align="left">
        <table name='vd1' class='vd' cellspacing='0' cellpadding='0'>
            <tr style='cursor:move;' onmousedown="mouseDownFun('alarm')">
                <th style='width:5%;' align='center'>序号</th>
                <th style='width:20%;' align='center'>监测时间</th>
                <th style='width:30%;' align='center'>监测点</th>
                <th style='width:20%;' align='center'>监测数据(℃)</th>
                <th style='width:25%;' align='center'>警报信息</th>
            </tr>
        </table>
    </div>
    <div name='divCon'
         style='text-align:center; margin:0;padding:0px;overflow:auto;height:415px;background-color: white;'>
        <table name='vd2' class='vd' style='font-size:13px;width:100%' cellspacing='0' cellpadding='0'>
        </table>
    </div>
    <div class='ppa'>
        <a class='aBtn aOut' href='javascript:' onclick="excelOut('regAlarms',0)">导出数据</a>
        <div name='ppages' style='height:25px;display:inline'></div>
    </div>
</div>
</body>
</html>