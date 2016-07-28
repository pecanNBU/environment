<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>编辑部门</title>
</head>
<body>
<div class="divContent" id="divss" style="background-color:#f0fcff;width:500px;border:1px solid #8AE4DD" align="center">
    <div class="detail_title" onmousedown="mouseDownFun('detail')">
        <span class="detail_header">　详细资料</span><span class="detail_close" onclick="closeDiv('detail')"
                                                      title="关闭">X</span>
    </div>
    <div class="detail_content">
        <table border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td align="center">
                    <table border="0" id="Table" cellpadding="0" cellspacing="0" style="text-align:left">
                        <tr>
                            <s:form name="form1" action="addDep.action" method="post" enctype="multipart/form-data"
                                    theme="simple">
                                <input type="hidden" name="depId" id="depId">
                                <td>
                                    <table class="showTb1">
                                        <tr>
                                            <td width="100px">部门名称：</td>
                                            <td><input name="depName" id="depName" onkeydown="resetBorder(id);"
                                                       onblur="checkDep();" style="width:170px" class="inputText">　<span
                                                    class="alarm" id="depName_">部门名重复</span></td>
                                        </tr>
                                        <tr>
                                            <td>部门负责人：</td>
                                            <td><s:select name="leaderUserId" id="leaderUserId" list="%{userInfos}"
                                                          listKey="id" listValue="userName" style="width:170px;"/></td>
                                        </tr>
                                        <tr>
                                            <td>部门简介：</td>
                                            <td><textarea id="depDesc" name="depDesc" style="width:250px;height:50px"
                                                          class="inputText"></textarea></td>
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