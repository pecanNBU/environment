<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>采样周期详细信息</title>
</head>
<body>
<div class="divContent" id="divss" style="background-color:#f0fcff;border:1px solid #8AE4DD" align="center">
    <div class="detail_title" onmousedown="mouseDownFun('detail')">
        <span class="detail_header">　详细资料</span><span class="detail_close" onclick="closeDiv('detail')"
                                                      title="关闭">X</span>
    </div>
    <div class="detail_content detail_m100">
        <table border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td align="center">
                    <table border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <s:form name="form1" action="addSystemComu.action" method="post" theme="simple">
                                <td>
                                    <input type="hidden" name="comuId" id="comuId">
                                    <table class="showTb">
                                        <tr>
                                            <td width="80px">通讯类型：</td>
                                            <td width="160px">
                                                <div id="comuTypeId_d">
                                                    <s:select name="comuTypeId" id="comuTypeId" listKey="id"
                                                              listValue="typeName" list="%{comuTypes}"
                                                              onchange="checkComuType();resetSD(id);"
                                                              Style="width:150px;"/>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <HR>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>通讯方式：</td>
                                            <td><s:select id="acceptMeth" name="acceptMeth"
                                                          list="#{0:'------', 1:'RS232', 2:'RS485', 3:'TCP/IP', 4:'GPRS'}"
                                                          Style="width:150px"></s:select></td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <HR>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>最大周期：</td>
                                            <td>
                                                <input id="maxPeriod" name="maxPeriod" onkeydown="resetBorder(id);"
                                                       onblur="checkPeriod(1);" onlyUnInt="true" Style="width:93px"
                                                       class="inputText">
                                                <s:select id="perTypeMax" name="perTypeMax"
                                                          list="#{0:'毫秒',1:'秒',2:'分钟',3:'小时'}"
                                                          onchange="resetBorder('samplePeriod');checkPeriod(0);"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <HR>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>采样周期：</td>
                                            <td>
                                                <input id="samplePeriod" name="samplePeriod"
                                                       onkeydown="resetBorder(id);" onblur="checkPeriod(0);"
                                                       onlyUnInt="true" Style="width:93px" class="inputText">
                                                <s:select id="perTypePeriod" name="perTypePeriod"
                                                          list="#{0:'毫秒',1:'秒',2:'分钟',3:'小时'}"
                                                          onchange="resetBorder('samplePeriod');checkPeriod(1);"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
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
        <input value="保存" class="btn_1" type="button" onclick="save();"/>
        　　<input value="取消" class="btn_2" type="button" onclick="closeDiv('detail');"/>
    </div>
</div>
</body>
</html>