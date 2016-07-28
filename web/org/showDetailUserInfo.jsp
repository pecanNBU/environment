<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>燃气用户详细资料</title>
</head>
<body>
<div class="divContent" style="background-color:#f0fcff;width:850px;border:1px solid #8AE4DD" align="center">
    <div class="detail_title" onmousedown="mouseDownFun('detail')">
        <span class="detail_header">　详细资料</span><span id="pswAlert" class="detail_header" style="color: red">　账号默认初始密码：123456</span><span
            class="detail_close" onclick="closeDiv('detail')" title="关闭">X</span>
    </div>
    <div class="detail_content">
        <table border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td align="center">
                    <table border="0" cellpadding="0" cellspacing="0" style="width:710px">
                        <tr id="tr1">
                            <td align="center" style="width:180px" id="Pic">
                                <img src="../img/imgNull.png" width="140" class="imgDev">
                            </td>
                            <td>
                                <table class="showTb">
                                    <tr>
                                        <td width="80px">姓&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;名：</td>
                                        <td id="userName" style="width:150px"></td>
                                        <td width="80px">帐&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;号：</td>
                                        <td id="loginName" style="width:150px"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <HR>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>用户类型：</td>
                                        <td id="userTypeName"></td>
                                        <td>所在部门：</td>
                                        <td id="deptName"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <HR>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>性&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;别：</td>
                                        <td id="sex"></td>
                                        <td>身份证号：</td>
                                        <td id="idCard"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <HR>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>手&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;机：</td>
                                        <td id="mobilephone"></td>
                                        <td>电&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;话：</td>
                                        <td id="telephone"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <HR>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>邮&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;箱：</td>
                                        <td id="email"></td>
                                        <td>Q&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Q：</td>
                                        <td id="qq"></td>
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
                            <s:form name="form1" id="form1" method="post" action="addUserInfo.action"
                                    enctype="multipart/form-data" theme="simple">
                                <td valign="middle" style="width:180px">
                                    <table border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td align="center"><span id="Pic1"></span>
                                                <br/><br/><input type="file" name="file" id="upload"
                                                                 style="width :140px" onchange="checkPhoto();"/>
                                                <br/><span class="alarm" id="upload_">请上传图片</span></td>
                                        </tr>
                                    </table>
                                </td>
                                <td>
                                    <table class="showTb">
                                        <tr height="28px">
                                            <td width="80px">姓　　名：</td>
                                            <td width="165px"><input name="userName" id="userName1" class="inputText"
                                                                     onkeydown="resetBorder(id);"><input name="userId"
                                                                                                         id="userId"
                                                                                                         style="display:none">
                                            </td>
                                            <td width="80px">帐　　号：</td>
                                            <td width="170px"><input name="loginName" id="loginName1" class="inputText"
                                                                     readonly onblur="checkLogins();"
                                                                     onkeydown="resetBorder(id);">　<span class="alarm"
                                                                                                         id="loginName1_">工号重复</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <HR>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>用户类型：</td>
                                            <td><s:select id="userTypeId" name="userTypeId" list="%{userTypes}"
                                                          listKey="id" listValue="typeName" Style="width:150px"/></td>
                                            <td>所在部门：</td>
                                            <td><s:select id="deptId" name="deptId" list="%{userDeps}" listKey="id"
                                                          listValue="depName" Style="width:150px"/></td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <HR>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>性　　别：</td>
                                            <td><s:radio name="sex" id="sex1" list="#{0:'男',1:'女'}"/></td>
                                            <td>身份证号：</td>
                                            <td><input name="idCard" id="idCard1" class="inputText"
                                                       onkeydown="resetBorder(id);"></td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <HR>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>手　　机：</td>
                                            <td><input name="mobilephone" id="mobilephone1" class="inputText"
                                                       onkeydown="resetBorder(id);"></td>
                                            <td>固定电话：</td>
                                            <td><input name="telephone" id="telephone1" class="inputText"
                                                       onkeydown="resetBorder(id);"></td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <HR>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>电子邮箱：</td>
                                            <td><input name="email" id="email1" class="inputText" onkeyup='getMail(id)'
                                                       onkeydown="resetBorder(id);showList(id)" onblur="hideList();">
                                            </td>
                                            <td>Q　　Q：</td>
                                            <td><input name="qq" id="qq1" class="inputText"
                                                       onkeydown="resetBorder(id);"></td>
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
        <input style="display:none" id="flag">
    </div>
    <div class="detail_btn">
        <div id="div_detail">
            <c:if test="${nodeState==1}">
                <input value="编辑" class="btn_1" type="button" onclick="update('userId');"/>　　
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