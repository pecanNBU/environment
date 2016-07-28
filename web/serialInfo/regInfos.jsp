<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="sx" uri="/struts-dojo-tags" %>
<html>
<head>
    <title>浏览从机对应的设备参数信息</title>
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
<img title="关闭" onclick="closeDiv('divRegInfos')" src="../img/close.png" name="Image_close"
     onmouseover="imageOver(name);" onmouseout="imageReset(name);" border="none"
     style="cursor:pointer;position:absolute;right:-15px;top:-15px;z-index:66666">
<div name="devc_c" style="background-color:#f0fcff;width:700px;overflow-y:auto;overflow-x:hidden;border-radius:5px;">
    <div align="left">
        <table name='vd1' class='vd' style='width:683px' cellspacing='0' cellpadding='0'>
            <tr style='cursor:move;' onmousedown="mouseDownFun('divRegInfos')">
                <th style='width:5%;'>序号</th>
                <th style='width:25%;'>对应设备</th>
                <th style='width:15%;'>参数名</th>
                <th style='width:15%;'>参数类型</th>
                <th style='width:15%;'>偏移地址</th>
                <th style='width:25%;'>参数说明</th>
            </tr>
        </table>
    </div>
    <div style='text-align:center; margin:0;padding:0px;overflow:auto;width:700px;height:415px;background-color: white;'>
        <table name='vd2' class='vd' style='font-size:13px;width:100%' cellspacing='0' cellpadding='0'>
        </table>
    </div>
    <div class='ppa'>
        <div name='ppages' style='height:25px'></div>
    </div>
</div>
</body>
</html>