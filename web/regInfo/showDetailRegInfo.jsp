<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>设备详细资料</title>
</head>
<body>
<div class="divContent" style="background-color:#f0fcff;width:850px;border:1px solid #8AE4DD" align="center">
    <div class="detail_title" onmousedown="mouseDownFun('detail')"><span class="detail_header"
                                                                         id="detail_header">　详细资料</span><span
            id="detail_alarm" class="detail_alarm"></span><span class="detail_close" onclick="closeDiv('detail')"
                                                                title="关闭">X</span></div>
    <table border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td style="height:20px"></td>
        </tr>
        <tr>
            <td align="center">
                <table border="0" cellpadding="0" cellspacing="0" style="width:700px">
                    <tr id="tr2">
                        <s:form id="form1" name="form1" action="addRegInfo.action" method="post"
                                enctype="multipart/form-data" theme="simple">
                            <input type="hidden" id="regId" name="regId">
                            <input type="hidden" id="pId" name="pId">
                            <td id="picTd" align="center" style="width:150px;">
                                <table border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td align="center">
                                            <div id="pics">
                                                <span id="Pic"></span>
                                                <br/><br/><br/><input type="file" name="file" id="file"
                                                                      style="width :100px"/>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td>
                                <table class="showTb">
                                    <tr>
                                        <td width="85px">节点名：</td>
                                        <td width="150px"><input name="regName" id="regName" Style="width:140px"
                                                                 onkeydown="resetBorder(id);"></td>
                                        <td width="85px">父节点：</td>
                                        <td width="150px"><span id="pNode"></span></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <HR>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>节点类型：</td>
                                        <td><select id="paraTypeId" name="paraTypeId1" Style="width:140px"></select>
                                        </td>
                                        <td>节点链接：</td>
                                        <td><input name="regUrl" id="regUrl" Style="width:140px"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <HR>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>提示信息：</td>
                                        <td><input name="regTitle" id="regTitle" Style="width:140px"></td>
                                        <td>是否显示：</td>
                                        <td><s:select name="isShow" id="isShow" list="#{1:'正常显示',2:'隐藏本节点',3:'隐藏所有节点'}"
                                                      value="1" Style="width:125px"/><span class="tdHelp"
                                                                                           onclick="showHelp();"
                                                                                           onmouseover="helpOut=false"
                                                                                           onmouseout="helpOut=true">　</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <HR>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="top">节点说明：</td>
                                        <td colspan="3"><textarea name="regDesc" id="regDesc"
                                                                  style="width:382px;height:45px"></textarea></td>
                                    </tr>
                                </table>
                            </td>
                        </s:form>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="height:20px"></td>
        </tr>
    </table>
    <div class="detail_btn">
        <div id="div_detail">
            <input value="编辑" class="btn_1" type="button" onclick="update('nodeId');"/>　　
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