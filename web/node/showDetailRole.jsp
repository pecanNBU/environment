<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="sx" uri="/struts-dojo-tags" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>角色详细资料</title>
</head>
<body>
<div class="divContent" style="background-color:#f0fcff;width:500px;border:1px solid #8AE4DD" align="center">
    <div class="detail_title" onmousedown="mouseDownFun('detail')"><span class="detail_header">　详细资料</span><span
            class="detail_close" onclick="closeDiv('detail')" title="关闭">X</span></div>
    <table border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td style="height:20px"></td>
        </tr>
        <tr>
            <td align="center">
                <table border="0" cellpadding="0" cellspacing="0" style="width:380px">
                    <tr>
                        <s:form name="form1" action="addRole.action" method="post" enctype="multipart/form-data"
                                theme="simple">
                            <td>
                                <table class="showTb1">
                                    <tr>
                                        <td width="80px">　角色名：</td>
                                        <td><input name="actorName" id="actorName" style="width:250px;"
                                                   onblur="checkActor();" onkeydown="resetBorder(id);"
                                                   class="inputText">　<span class="alarm"
                                                                            id="actorName_">角色名重复</span><input
                                                name="actorId" id="actorId" style="display:none"></td>
                                    </tr>
                                    <tr>
                                        <td valign="top">角色描述：</td>
                                        <td><textarea name="actorDesc" id="actorDesc" style="width:250px;height:50px"
                                                      class="inputText"></textarea></td>
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
    <input value="保存" class="btn_1" type="button" flag="done" onclick="save();"/>
    　<input value="取消" class="btn_2" type="button" onclick="closeDiv('detail');"/>
    <br/><br/>
</div>
</body>
</html>