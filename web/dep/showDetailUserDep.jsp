<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>编辑单位</title>
</head>
<body>
<div class="divContent" id="divss" style="background-color:#f0fcff;width:650px;border:1px solid #8AE4DD" align="center">
    <div class="detail_title" onmousedown="mouseDownFun('detail')">
        <span class="detail_header">　详细资料</span><span class="detail_close" onclick="closeDiv('detail')"
                                                      title="关闭">X</span>
    </div>
    <div class="detail_content">
        <table border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td align="center">
                    <table border="0" id="Table" cellpadding="0" cellspacing="0" style="text-align:left">
                        <tr id="tr1">
                            <td align="center" style="width:180px">
                                <table border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td id="Pic" align="center"></td>
                                    </tr>
                                </table>
                            </td>
                            <td>
                                <table class="showTb">
                                    <tr>
                                        <td width="100px">单位名：</td>
                                        <td id="depName"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <HR>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>单位负责人：</td>
                                        <td id="loginName" colspan="3"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <HR>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>所在地址：</td>
                                        <td id="depAddr" colspan="3"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <HR>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr id="tr2" style="display:none">
                            <s:form name="form1" action="addUserDep" method="post" enctype="multipart/form-data"
                                    theme="simple">
                                <input type="hidden" name="depId" id="depId">
                                <td>
                                    <table class="showTb1">
                                        <tr>
                                            <td width="100px">单位名称：</td>
                                            <td><input name="depName" id="depName1" onkeydown="resetBorder(id);"
                                                       onblur="checkDep();" style="width:170px" class="inputText">　<span
                                                    class="alarm" id="depName1_">单位名重复</span></td>
                                        </tr>
                                        <tr>
                                            <td>单位负责人：</td>
                                            <td><input name="loginName" id="loginName1" onkeydown="resetBorder(id);"
                                                       onblur="checkLogin();" readonly style="width:170px"
                                                       class="inputText">　<span class="alarm"
                                                                                id="loginName1_">登录名重复</span></td>
                                        </tr>
                                        <tr>
                                            <td></td>
                                            <td><span id="loginName__" style="color:gray;">账户仅支持数字/英文字母/符号</span></td>
                                        </tr>
                                        <tr>
                                            <td>登录密码：</td>
                                            <td><input name="pwd" readonly id="pwd" readonly
                                                       style="width:170px;color:gray" value="密码默认为00000000"
                                                       class="inputText"></td>
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
            <c:if test="${nodeState==1}">
                <input value="编辑" class="btn_1" type="button" onclick="update('depId');"/>　　
            </c:if>
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