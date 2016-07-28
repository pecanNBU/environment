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
                                        <td width="80px">系统名称：</td>
                                        <td style="width:120px" id="name"></td>
                                        <td width="80px">版本号：</td>
                                        <td style="width:120px" id="version"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <HR>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>责任人：</td>
                                        <td id="dutyUserName"></td>
                                        <td>系统简称：</td>
                                        <td id="abbr"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <HR>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>版权所有：</td>
                                        <td id="copyright"></td>
                                        <td>电子邮箱：</td>
                                        <td id="email"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <HR>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>联系电话：</td>
                                        <td id="telephone"></td>
                                        <td>公司传真：</td>
                                        <td id="fax"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <HR>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>公司网站：</td>
                                        <td id="website"></td>
                                        <td>更新日期：</td>
                                        <td id="updateDt"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <HR>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>版本说明：</td>
                                        <td colspan="3" id="versionDesc"></td>
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
                            <s:form name="form1" action="addSystemAbout" method="post" theme="simple">
                                <td>
                                    <input name="aboutId" id="aboutId" style="display:none">
                                    <table class="showTb">
                                        <tr>
                                            <td width="80px">系统名称：</td>
                                            <td width="152px"><input name="name" id="name1" onkeydown="resetBorder(id);"
                                                                     style="width:150px" class="inputText"></td>
                                            <td width="80px">版本号：</td>
                                            <td width="152px"><input name="version" id="version1"
                                                                     onkeydown="resetBorder(id);"
                                                                     onblur="checkVersion();" style="width:150px"
                                                                     class="inputText"></td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <HR>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>责任人：</td>
                                            <td><s:select style="width:150px;" name="dutyUserId" id="dutyUserId"
                                                          list="%{userInfos}" listKey="id" listValue="userName"/></td>
                                            <td>系统简称：</td>
                                            <td><input name="abbr" id="abbr1" style="width:150px" class="inputText">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <HR>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>版权所有：</td>
                                            <td><input name="copyright" id="copyright1" style="width:150px"
                                                       class="inputText"></td>
                                            <td>电子邮箱：</td>
                                            <td><input name="email" id="email1" style="width:150px" class="inputText">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <HR>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>联系电话：</td>
                                            <td><input name="telephone" id="telephone1" style="width:150px"
                                                       class="inputText"></td>
                                            <td>公司传真：</td>
                                            <td><input name="fax" id="fax1" style="width:150px" class="inputText"></td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <HR>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>网站：</td>
                                            <td colspan="3"><input name="website" id="website1" style="width:150px"
                                                                   class="inputText"></td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <HR>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="middle">版本说明：</td>
                                            <td colspan="3"><textarea name="versionDesc" id="versionDesc1"
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
            <c:if test="${nodeState==1}">
                <input value="编辑" class="btn_1" id="btnEdit" type="button" onclick="update('aboutId');"/>　　
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