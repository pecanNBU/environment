<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="sx" uri="/struts-dojo-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>从机详细信息</title>
</head>
<body>
<div class="divContent" id="divss" style="background-color:#f0fcff;border:1px solid #8AE4DD" align="center">
    <div class="detail_title" onmousedown="mouseDownFun('detail')" style="text-align: left;">
        <span class="detail_header">　详细资料</span><span
            style="font-size: 15px;font-weight: bold;color: red;line-height: 31px;">　修改串口信息可能造成通信错误，非专业人士请勿操作</span><span
            class="detail_close" onclick="closeDiv('detail')" title="关闭">X</span>
    </div>
    <div class="detail_content detail_m100">
        <table border="0" align="center" cellpadding="0" cellspacing="0">
            <tr id="tr1">
                <td align="center">
                    <table border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td>
                                <table class="showTb">
                                    <tr>
                                        <td width="80px">串口号：</td>
                                        <td style="width:120px" id="commPortId1"></td>
                                        <td width="80px">设备Id：</td>
                                        <td style="width:120px" id="devId1"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <HR>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>波特率：</td>
                                        <td id="baudRate1" style="width:120px"></td>
                                        <td>奇偶校验：</td>
                                        <td id="parity1"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <HR>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>数据位：</td>
                                        <td id="dataBits1"></td>
                                        <td>停止位：</td>
                                        <td id="stopBits1"></td>
                                    <tr>
                                        <td colspan="4">
                                            <HR>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>是否启用：</td>
                                        <td colspan="3" id="isActive_"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <HR>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="middle">串口说明：</td>
                                        <td colspan="3" id="serialDesc1"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <HR>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr id="tr2" style="display:none">
                <td align="center">
                    <table border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <s:form name="form1" action="addSerialInfo" method="post" theme="simple">
                                <td>
                                    <input name="serialId" id="serialId" style="display:none">
                                    <table class="showTb">
                                        <tr>
                                            <td width="80px">串口号：</td>
                                            <td width="152px"><input name="commPortId" id="commPortId"
                                                                     onkeydown="resetBorder(id);"
                                                                     onblur="checkCommPort();" style="width:150px"
                                                                     class="inputText"></td>
                                            <td width="80px">设备Id：</td>
                                            <td width="152px"><input name="devId" id="devId"
                                                                     onkeydown="resetBorder(id);" onblur="checkDevId();"
                                                                     style="width:150px" class="inputText"></td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <HR>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>波特率：</td>
                                            <td><s:select id="baudRate" name="baudRate"
                                                          list="#{1:'110',2:'300',3:'600',4:'1200',5:'2400',6:'4800',7:'9600',8:'14400',9:'19600',10:'38400',11:'56000',12:'57600',13:'115200',14:'128000',15:'256000'}"
                                                          value="7" Style="width:150px"/></td>
                                            <td>奇偶校验：</td>
                                            <td><s:select id="parity" name="parity"
                                                          list="#{0:'无校验',1:'奇校验',2:'偶校验',3:'1校验',4:'0校验'}" value="0"
                                                          Style="width:150px"/></td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <HR>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>数据位：</td>
                                            <td><s:select id="dataBits" name="dataBits"
                                                          list="#{4:'4位',5:'5位',6:'6位',7:'7位',8:'8位'}" value="8"
                                                          Style="width:150px"/></td>
                                            <td>停止位：</td>
                                            <td><s:select id="stopBits" name="stopBits" list="#{1:'1位',2:'2位'}"
                                                          value="1" Style="width:150px"/></td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <HR>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>是否启用：</td>
                                            <td colspan="3"><s:radio name="isActive" id="isActive"
                                                                     list="#{1:'启用',0:'停用'}" value="1"
                                                                     disabled="true"/></td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <HR>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="middle">串口说明：</td>
                                            <td colspan="3"><textarea id="serialDesc" name="serialDesc"
                                                                      style="width:390px;height:45px"
                                                                      class="inputText"></textarea></td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <HR>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </s:form>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </div>
    <div class="detail_btn">
        <div id="div_detail">
            <input value="编辑" class="btn_1" id="btnEdit" type="button" onclick="update('serialId');"/>　　
            <input value="返回" class="btn_2" type="button" onclick="closeDiv('detail');"/>
        </div>
        <div id="div_save" style="display:none">
            <input value="保存" class="btn_1" type="button" onclick="save();"/>
            　　<input value="取消" class="btn_2" type="button" onclick="closeDiv('detail');"/>
        </div>
    </div>
</div>
</body>
</html>