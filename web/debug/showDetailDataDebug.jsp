<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="sx" uri="/struts-dojo-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>系统信息详情</title>
</head>
<body>
<div class="divContent" id="divss" style="background-color:#f0fcff;border:1px solid #8AE4DD" align="center">
    <div class="detail_title" onmousedown="mouseDownFun('detail')">
        <span class="detail_header">　详细资料</span><span class="detail_close" onclick="closeDiv('detail')"
                                                      title="关闭">X</span>
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
                                        <td width="80px">开始时间：</td>
                                        <td width="320px" id="stDt"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <HR>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>结束时间：</td>
                                        <td id="endDt" colspan="3"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <HR>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>调试人：</td>
                                        <td id="userName" colspan="3"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <HR>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>调试原因：</td>
                                        <td colspan="3" id="debugNote"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <HR>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>调试结果：</td>
                                        <td colspan="3" id="debugResult"></td>
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
                            <s:form name="form1" action="addDataDebug" method="post" theme="simple">
                                <td>
                                    <input name="debugId" id="debugId" style="display:none">
                                    <table class="showTb">
                                        <tr>
                                            <td width="80px" valign="middle">调试原因：</td>
                                            <td width="320px" colspan="3"><textarea name="debugNote" id="debugNote1"
                                                                                    style="width:300px;height:45px"
                                                                                    class="inputText"></textarea></td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <HR>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="middle">调试结果：</td>
                                            <td colspan="3"><textarea name="debugResult" id="debugResult1"
                                                                      style="width:300px;height:45px"
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