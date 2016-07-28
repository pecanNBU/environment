<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>编辑数据词典</title>
</head>
<body>
<div class="divContent" id="divss" style="background-color:#f0fcff;width:700px;border:1px solid #8AE4DD" align="center">
    <div class="detail_title" onmousedown="mouseDownFun('detail')">
        <span class="detail_header" id="title">　编辑数据词典</span><span class="detail_close" onclick="closeDiv('detail')"
                                                                   title="关闭">X</span>
    </div>
    <div class="detail_content">
        <table border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td align="center">
                    <table border="0" cellpadding="0" cellspacing="0" style="width:600px">
                        <tr>
                            <s:form name="form1" id="form1" action="addDType" method="post"
                                    enctype="multipart/form-data" theme="simple">
                                <input type="hidden" id="formPenName" name="penName">
                                <td id="picTd" align="center" style="width:100px;">
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
                                            <td width="80px">类型名：</td>
                                            <td width="150px"><input id="typeName" name="typeName" Style="width:150px"
                                                                     onkeydown="resetBorder(id);"
                                                                     onblur="checkTypeName()" class="inputText"></td>
                                            <td width="80px">所在公司：</td>
                                            <td width="153px"><font style="color:red">${depName}</font><input
                                                    name="typeId" id="typeId" style="display:none"></td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <HR>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>父类名：</td>
                                            <td><input name="pName" id="pName" readonly style="width:150px"
                                                       class="inputText"></td>
                                            <td>是否叶子：</td>
                                            <td><s:radio name="isLeaf" id="isLeaf" list="#{1:'是',0:'否'}"
                                                         value="1"/></td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <HR>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>　简写：</td>
                                            <td colspan="3"><input id="enName" name="enName" Style="width:150px"
                                                                   onkeydown="resetBorder(id);" onblur="checkEnName()"
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
        <input value="保存" class="btn_1" type="button" flag="done" onclick="save();"/>
        　　　<input value="取消" class="btn_2" type="button" onclick="closeDiv('detail');"/>
    </div>
</div>
</body>
</html>