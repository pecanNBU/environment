<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
<head>
    <title>公司用户管理本人信息</title>
    <script type="text/javascript" src="../js/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <link href="../css/style.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript">
        var flag = 0;
        var pswFlag = 0;
        var isOut = true;
        var mailList = ['@qq.com', '@163.com', '@sina.com', '@sohu.com', '@gmail.com', '@126.com', '@hotmail.com'];
        $(function () {
            $(".vT").height("1px");
            $("#detail_bg").height($(document).height()).show();
            beCenter("waiting");
            $("#waitings").html("加载中，请稍候....");
            $("#waiting").show();
            $.ajax({
                type: "post",
                dataType: "json",
                url: "json_userInfo",
                success: function callBack(data) {
                    var map = data.map;
                    $("#userName").html(map.userName);
                    $("#loginName").html(map.loginName);
                    $("#idCard").html(map.idCard);
                    $("#sex").html(map.sex);
                    $("#mobilephone").html(map.mobilephone);
                    $("#telephone").html(map.telephone);
                    $("#email").html(map.email);
                    $("#qq").html(map.qq);
                    $("#deptName").html(map.deptName);
                    $("#userTypeName").html(map.userTypeName);
                    $("#deptName1").html(map.deptName);
                    $("#userTypeName1").html(map.userTypeName);
                    $("#waiting").hide();
                    $("#detail_bg").hide();
                },
                error: function (data) {
                    ajaxError(data);
                    $("#waiting").hide();
                    $("#detail_bg").hide();
                    error_alert("加载出错，请重试或联系管理员", 1500);
                }
            });
        });
        function psw() {			//修改密码
            clearDetail(pswEd);
            $(".inputAlarm").removeClass("inputAlarm");
            beCenter("psw");
            $("#detail_bg").show();
            $("#psw").show(300);
        }
        function psw_done() {
            var pswOld = $.trim($("#pswOld").val());
            var pswNew = $.trim($("#pswNew").val());
            var pswNew1 = $.trim($("#pswNew1").val());
            if (pswOld == "") {
                save_alert(4, "您还没有输入原始密码", "#pswOld");
                $("#pswOld").focus();
            }
            else if (pswNew == "") {
                save_alert(4, "您还没有新密码", "#pswOld");
                $("#pswNew").focus();
            }
            else if (pswNew1 == "") {
                save_alert(4, "您还没有密码确认", "#pswOld");
                $("#pswNew1").focus();
            }
            else if (pswNew != pswNew1) {
                save_alert(4, "确认密码与新密码不同，请重新输入", "#pswOld");
                $("#pswNew").val("").focus();
                $("#pswNew1").val("");
            }
            else if (pswFlag == 0) {
                $("#detail_bg").css("z-index", "50004");
                beCenter("waiting");
                $("#waitings").html("保存中，请稍候....");
                $("#waiting").show();
                $.ajax({
                    url: "../org/pswEdit.action?pswOld=" + pswNew,
                    type: "post",
                    success: function (data) {
                        var flag = data.flag;
                        if (flag == 0) {
                            error_alert("修改成功，跳转至登录界面", 1500);
                            window.top.location.href = "../login/exitLogin.action";
                        }
                        else {
                            top.success(1, "数据出错，请重试或联系管理员");
                            $("#detail_bg").hide().css("z-index", "50000");
                            $("#waiting").hide();
                            $("#gasDis").hide();
                        }
                    },
                    error: function (data) {
                        ajaxError(data);
                        $("#.div_alt").hide();
                        $("#waiting").hide();
                        $("#detail_bg").hide().css("z-index", "50000");
                        error_alert("数据出错，请重试或联系管理员", 1500);
                    }
                });
            }
        }
        function checkPsw() {		//验证原始密码
            var pswOld = $.trim($("#pswOld").val());
            if (pswOld != "") {
                $.post(
                        "../org/checkPswOld.action?pswOld=" + pswOld,
                        function (data) {
                            $("#save_alert_pswOld").remove();
                            pswFlag = data.flag;
                            if (pswFlag == 1) {
                                save_alert(4, "原始密码错误，请重新输入", "#pswOld");
                                $("#pswOld").val("").focus();
                            }
                        },
                        "json"
                ).error(function (data) {
                    ajaxError(data);
                });
            }
        }
        function editUserDetail() {		//编辑用户基本信息
            clearDetail(formUserDetail);
            $(".inputAlarm").removeClass("inputAlarm");
            $(".vu_alarm").html("");
            $("#userDetailShow").hide();
            $("#userDetailEdit").show();
            $("#userNameEdit").val($("#userName").html());
            $("#loginNameEdit").html($("#loginName").html());
            if ($("#sex").html() == "男")
                document.getElementById("sexEdit0").checked = true;
            else
                document.getElementById("sexEdit1").checked = true;
            $("#idCardEdit").val($("#idCard").html());
            $("#mobilephoneEdit").val($("#mobilephone").html());
            $("#telephoneEdit").val($("#telephone").html());
            $("#emailEdit").val($("#email").html());
            $("#qqEdit").val($("#qq").html());
        }
        function saveUserDetail() {		//保存用户基本信息
            var userName = $.trim($("#userNameEdit").val());
            var email = $.trim($("#emailEdit").val());
            var idCard = $.trim($("#idCardEdit").val());
            var telePhone = $.trim($("#telephoneEdit").val());
            var mobilePhone = $.trim($("#mobilephoneEdit").val());
            var qq = $.trim($("#qqEdit").val());
            if (userName == "") {
                save_alert(0, "您还没有输入用户名", "#userNameEdit");
                $("#userNameEdit").addClass("inputAlarm");
            }
            /*else if(idCard==""){
             save_alert(0,"您还没有输入身份证号码","#idCardEdit");
             $("#idCardEdit").addClass("inputAlarm");
             }*/
            else if (email != "" && !isEmail(email)) {
                save_alert(0, "请输入正确的邮箱帐号", "#emailEdit");
                $("#emailEdit").addClass("inputAlarm");
            }
            /*else if(testIdCardNo(idCard)!="验证通过!"){
             save_alert(0,testIdCardNo(idCard),"#idCardEdit");
             $("#idCardEdit").addClass("inputAlarm");
             }*/
            else if (mobilePhone != "" && isMobil(mobilePhone) != "success") {
                save_alert(0, "请输入正确的手机号", "#mobilephoneEdit");
                $("#mobilephoneEdit").addClass("inputAlarm");
            }
            else if (telePhone != "" && isPhone(telePhone) != "success") {
                save_alert(0, "请输入正确的固定电话", "#telephoneEdit");
                $("#telephoneEdit").addClass("inputAlarm");
            }
            else if (mobilePhone == "" && telePhone == "") {
                $("#vu_alarm").html("请输入手机号或固定电话");
            }
            else if (qq != "" && isQq(qq) != "success") {
                save_alert(0, "请输入正确的QQ号", "#qqEdit");
                $("#qqEdit").addClass("inputAlarm");
            }
            else {
                $("#detail_bg").show();
                beCenter("waiting");
                $("#waitings").html("保存中，请稍候....");
                $("#waiting").show();
                var dataPara = getFormJson(formUserDetail);
                $.ajax({
                    url: formUserDetail.action,
                    type: formUserDetail.method,
                    data: $.param(dataPara, true),
                    success: function (data) {
                        var flag = data.flag;
                        var map = data.map;
                        if (flag == 0) {
                            top.success(0, "修改成功");
                            $("#userName").html(map.userName);
                            $("#idCard").html(map.idCard);
                            $("#sex").html(map.sex);
                            $("#mobilephone").html(map.mobilephone);
                            $("#telephone").html(map.telephone);
                            $("#email").html(map.email);
                            $("#qq").html(map.qq);
                            $("#userDetailEdit").hide();
                            $("#userDetailShow").show();
                        }
                        else {
                            error_alert("数据出错，请重试或联系管理员", 1500);
                        }
                        $("#detail_bg").hide();
                        $("#waiting").hide();
                    },
                    error: function (data) {
                        ajaxError(data);
                        $("#waiting").hide();
                        $("#detail_bg").hide();
                        error_alert("数据出错，请重试或联系管理员", 1500);
                    }
                });
            }
        }
        function cancleUserDetail() {	//取消编辑用户基本信息
            $("#userDetailEdit").hide();
            $("#userDetailShow").show();
        }
        function alearAlarm() {			//清除显示在标题栏的alarm信息
            $(".vu_alarm").html("");
        }
    </script>
    <style type="text/css">
        .cTitle {
            margin: 10px 0
        }

        .cLeft {
            text-align: right;
            padding-right: 10px;
        }

        table {
            table-layout: fixed;
            text-align: left
        }

        td {
            word-break: break-all;
            word-wrap: break-word
        }

        .vu {
            border: 1px solid #d3d3d3;
            border-collapse: collapse;
            width: 100%;
            margin: 20px 0;
            width: 800px
        }

        .vu th {
            background-color: #EFEFEF;
            color: #000;
            border: 1px solid #cbccdo
        }

        .vu tr {
            height: 45px;
            font-size: 15px;
        }

        .vu td {
            border: 1px solid #d3d3d3
        }

        .aa {
            color: #ff2121
        }

        .bb {
            color: #000033
        }

        .s1 {
            color: #ff2121
        }

        .dAlarm {
            font: 15px 微软雅黑;
            color: red;
            margin-left: 20px;
        }

        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
        }

        ul, li, p {
            padding: 0;
            margin: 0;
        }

        li, ul {
            list-style-type: none;
        }

        #formItems li {
            margin: 0 0 5px 0;
            height: 30px;
            line-height: 30px;
            display: inline-block;
            width: 335px;
            float: left
        }

        .s_ul {
            list-style: none;
            margin-left: -35px;
            _margin-left: 5px;
            margin-right: 5px;
            margin-top: 5px;
            text-align: left;
            line-height: 110px;
            *line-height: 55px
        }

        #divAcc {
            padding-bottom: 10px;
        }

        .vu_alarm {
            font-size: 15px;
            font-weight: bold;
            color: red;
            line-height: 31px;
            padding-left: 30px;
        }

        .inputText {
            width: 180px;
        }
    </style>
</head>
<body>
<div align="center" id="divAcc">
    <table class="vu" border="0" cellspacing="0" cellpadding="0" id="userDetailShow">
        <tr class="vT">
            <td width="15%"></td>
            <td width="35%"></td>
            <td width="15%"></td>
            <td width="35%"></td>
        </tr>
        <tr>
            <td bgcolor="#efefef" colspan="4">
                <div align="left" class="devClass ml20">用户信息　<input class="btn_1" type="button"
                                                                    onclick="editUserDetail();" value="编辑"/></div>
            </td>
        </tr>
        <tr>
            <td class="cBlue cLeft">姓　　名：</td>
            <td class="bb" style="padding-left:10px" id="userName"></td>
            <td class="cBlue cLeft">登录账号：</td>
            <td class="bb" style="padding-left:10px">
                <span id="loginName"></span>
                　<a class='aBtn aOut' href='javascript:' onclick='psw();'>修改密码</a>
            </td>
        </tr>
        <tr>
            <td class="cBlue cLeft">身份证号：</td>
            <td class="bb" style="padding-left:10px" id="idCard"></td>
            <td class="cBlue cLeft">性　　别：</td>
            <td class="bb" style="padding-left:10px" id="sex"></td>
        </tr>
        <tr>
            <td class="cBlue cLeft">手机号码：</td>
            <td class="bb " style="padding-left:10px" id="mobilephone"></td>
            <td class="cBlue cLeft">固定电话：</td>
            <td class="bb " style="padding-left:10px" id="telephone"></td>
        </tr>
        <tr>
            <td class="cBlue cLeft">邮　　箱：</td>
            <td class="bb " style="padding-left:10px" id="email"></td>
            <td class="cBlue cLeft">Q　　Q：</td>
            <td class="bb " style="padding-left:10px" id="qq"></td>
        </tr>
        <tr>
            <td class="cBlue cLeft">所在部门：</td>
            <td class="bb" style="padding-left:10px" id="deptName"></td>
            <td class="cBlue cLeft">用户类型：</td>
            <td class="bb" style="padding-left:10px" id="userTypeName"></td>
        </tr>
    </table>
    <table class="vu" border="0" cellspacing="0" cellpadding="0" id="userDetailEdit" style="display:none">
        <s:form name="formUserDetail" id="formUserDetail" method="post" action="../org/userDetail.action"
                theme="simple">
            <tr class="vT">
                <td width="15%"></td>
                <td width="35%"></td>
                <td width="15%"></td>
                <td width="35%"></td>
            </tr>
            <tr>
                <td bgcolor="#efefef" colspan="4">
                    <div align="left" class="devClass ml20">用户信息　<input class="btn_1" type="button"
                                                                        onclick="saveUserDetail();" value="保存"/>　<input
                            class="btn_2" type="button" onclick="cancleUserDetail();" value="取消"/><span class="vu_alarm"
                                                                                                        id="vu_alarm"></span>
                    </div>
                </td>
            </tr>
            <tr>
                <td class="cBlue cLeft">姓　　名：</td>
                <td class="bb" style="padding-left:10px"><input id="userNameEdit" onkeydown="resetBorder(id);"
                                                                name="userName" class="inputText"></td>
                <td class="cBlue cLeft">登录账号：</td>
                <td class="bb" style="padding-left:10px">
                    <span id="loginNameEdit"></span>
                </td>
            </tr>
            <tr>
                <td class="cBlue cLeft">身份证号：</td>
                <td class="bb" style="padding-left:10px"><input id="idCardEdit" onkeydown="resetBorder(id);"
                                                                name="idCard" class="inputText"></td>
                <td class="cBlue cLeft">性　　别：</td>
                <td class="bb" style="padding-left:10px"><s:radio name="sex" id="sexEdit" list="#{0:'男',1:'女'}"/></td>
            </tr>
            <tr>
                <td class="cBlue cLeft">手机号码：</td>
                <td class="bb " style="padding-left:10px"><input id="mobilephoneEdit" name="mobilephone"
                                                                 onkeydown="resetBorder(id);alearAlarm();"
                                                                 class="inputText"></td>
                <td class="cBlue cLeft">固定电话：</td>
                <td class="bb " style="padding-left:10px"><input id="telephoneEdit" name="telephone"
                                                                 onkeydown="resetBorder(id);alearAlarm();"
                                                                 class="inputText"></td>
            </tr>
            <tr>
                <td class="cBlue cLeft">邮　　箱：</td>
                <td class="bb " style="padding-left:10px"><input id="emailEdit" name="email" class="inputText"
                                                                 onkeyup='getMail(id)'
                                                                 onkeydown="resetBorder(id);showList(id)"
                                                                 onblur="hideList();"></td>
                <td class="cBlue cLeft">Q　　Q：</td>
                <td class="bb " style="padding-left:10px"><input id="qqEdit" name="qq" class="inputText"></td>
            </tr>
            <tr>
                <td class="cBlue cLeft">所在部门：</td>
                <td class="bb" style="padding-left:10px" id="deptName1"></td>
                <td class="cBlue cLeft">用户类型：</td>
                <td class="bb" style="padding-left:10px" id="userTypeName1"></td>
            </tr>
        </s:form>
    </table>
</div>
<div id="detail_bg"></div>
<div id="alert" class="div_alt">
    <s:include value="../main/alert.jsp"/>
</div>
<div id="waiting">
    <span id="waitings"></span>
</div>
<div id="psw" class="div_alt divFloat">
    <div class="divContent" style="border:1px solid #8AE4DD;width:500px;background-color:#f0fcff;">
        <div class="detail_title" onmousedown="mouseDownFun('psw')"><span class="detail_header">　修改密码</span><span
                class="detail_close" onclick="closeDiv('psw')" title="关闭">X</span></div>
        <br/>
        <div align="center">
            <s:form name="pswEd" id="pswEd" method="post" action="pswEdit.action" theme="simple">
                <table class="pswTable" style="padding-top:10px;">
                    <tr>
                        <td class="cBlue">原始密码：</td>
                        <td><input id="pswOld" class="pa" type="password" maxlength="16" onblur="checkPsw();"></td>
                    </tr>
                    <tr>
                        <td style="height:5px;"></td>
                    </tr>
                    <tr>
                        <td class="cBlue">　新密码：</td>
                        <td><input id="pswNew" class="pa" type="password" maxlength="16"></td>
                    </tr>
                    <tr>
                        <td style="height:5px;"></td>
                    </tr>
                    <tr>
                        <td class="cBlue">确认密码：</td>
                        <td><input id="pswNew1" class="pa" type="password" maxlength="16"></td>
                    </tr>
                </table>
            </s:form>
        </div>
        <div style="padding:20px 0;">
            <input class="btn_1" type="button" onclick="psw_done();" value="确定"/>
            　　<input class="btn_2" type="button" onclick="closeDiv('psw');" value="取消"/>
        </div>
    </div>
</div>
<ul id="emaillist" class="emaillist" onmouseover="isOut=false" onmouseout="isOut=true"></ul>
</body>
</html>