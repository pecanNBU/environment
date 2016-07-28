<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>模块详细资料</title>
</head>
<body>
<div class="divContent" style="background-color:#f0fcff;width:640px;border:1px solid #8AE4DD" align="center">
    <div class="detail_title" onmousedown="mouseDownFun('detail')"><span class="detail_header">　详细资料</span><span
            id="detail_alarm" class="detail_alarm"></span><span class="detail_close" onclick="closeDiv('detail')"
                                                                title="关闭">X</span></div>
    <table border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td style="height:20px"></td>
        </tr>
        <tr>
            <td align="center">
                <table border="0" cellpadding="0" cellspacing="0" style="width:500px">
                    <tr id="tr1">
                        <td align="center" style="width:180px" id="Pic1" valign="middle"></td>
                        <td>
                            <table class="showTb1">
                                <tr>
                                    <td width="90px">　模块名：</td>
                                    <td width="220px" id="nodeName2"></td>
                                </tr>
                                <tr>
                                    <td>上级模块：</td>
                                    <td id="pName"></td>
                                </tr>
                                <tr>
                                    <td>　　顺序：</td>
                                    <td id="nodeSort1"></td>
                                </tr>
                                <tr>
                                    <td>模块权限：</td>
                                    <td id="nodeActor1"></td>
                                </tr>
                                <tr>
                                    <td valign="top">模块链接：</td>
                                    <td id="nodeUrl1"></td>
                                </tr>
                                <tr>
                                    <td valign="top">模块说明：</td>
                                    <td id="nodeDesc1"></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr id="tr2" style="display:none">
                        <s:form id="form1" name="form1" action="addNode.action" method="post"
                                enctype="multipart/form-data" theme="simple">
                            <td align="center" style="width:180px" id="Pic" valign="middle"></td>
                            <td>
                                <table class="showTb1">
                                    <tr>
                                        <td width="90px">　模块名：</td>
                                        <td width="220px"><input name="nodeName1" id="nodeName1" Style="width:210px"
                                                                 onblur="checkNode();"
                                                                 onkeydown="resetBorder(id);"><input type="hidden"
                                                                                                     name="nodeId"
                                                                                                     id="nodeId"></td>
                                    </tr>
                                    <tr>
                                        <td>上级模块：</td>
                                        <td id="pIdNodeTd"><s:select id="pId" name="pId" list="%{pNodes}" listKey="id"
                                                                     listValue="name" Style="width:210px"
                                                                     onchange="checkNode();resetBorder('nodeName1');resetSort(0);"/></td>
                                    </tr>
                                    <tr>
                                        <td>　　顺序：</td>
                                        <td>
                                                <%-- <s:select id="nodeSort" name="nodeSort" list="#{1:'1',2:'2',3:'3',4:'4',5:'5',6:'6',7:'7',8:'8',9:'9',10:'10',11:'11',12:'12',13:'13',14:'14',15:'15',16:'16',17:'17',18:'18',19:'19',20:'20'}" Style="width:210px"/> --%>
                                            <select id="nodeSort" name="nodeSort" style="width:210px;"
                                                    class='selLimit'></select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>模块权限：</td>
                                        <td><s:select id="nodeActor" name="nodeActor"
                                                      list="#{0:'系统管理员',1:'平台管理员',2:'单位管理员'}" Style="width:210px"
                                                      value="2"/></td>
                                    </tr>
                                    <tr>
                                        <td>模块图标：</td>
                                        <td><input type="file" name="file" id="file" style="width :140px"
                                                   onchange="checkPhoto();"/>
                                            <!-- <input name="nodeTitle" id="nodeTitle" Style="width:210px"> --></td>
                                    </tr>
                                    <tr>
                                        <td valign="top">模块链接：</td>
                                        <td><textarea name="nodeUrl" id="nodeUrl"
                                                      style="width:210px;height:30px"></textarea></td>
                                    </tr>
                                    <tr>
                                        <td valign="top">模块说明：</td>
                                        <td><textarea name="nodeDesc" id="nodeDesc"
                                                      style="width:210px;height:45px"></textarea></td>
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
    <!-- 	<input value="保存" class="btn_1" type="button" flag="done" onclick="save();"/>
        　<input value="取消" class="btn_2" type="button" onclick="closeDiv('detail');"/>
    <br /><br /> -->
    <div class="detail_btn">
        <div id="div_detail">
            <c:if test="${nodeState==1}"><input value="编辑" class="btn_1" type="button"
                                                onclick="update('nodeId');"/>　　</c:if>
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