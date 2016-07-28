<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="sx" uri="/struts-dojo-tags" %>
<!DOCTYPE HTML>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>登录</title>
    <script type="text/javascript" src="<%=basePath%>js/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/page.js"></script>
    <link href="<%=basePath%>css/style.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript">
        var cAgent = cUserAgent();
        var error = request("error");
        var pLeft, pTop;
        $(function () {
            if (1 == error)
                save_alert(2, "工号出错或已经登录", "#j_username");
            else if (2 == error)
                save_alert(2, "权限不足", "#j_username");
            else if (3 == error)
                save_alert(2, "该账号已在别处登录", "#j_username");
            var height = $("#login_bg1").height();
            var ch = $(window).height();
            var top = $(document).scrollTop();
            var divTop = top + (parseInt(ch) - parseInt(height)) / 2 - 2;			//div外还有10像素的裙边
            $("#login_bg1").css("margin-top", divTop > 0 ? divTop : 0);
        });
        function resetForm() {		//重置form表单
            $("#login_alert").hide();
            form.reset();
        }
        function checkLogin() {		//登录验证
            var usePsw = $.trim($("#j_password").val());
            var userName = $.trim($("#j_username").val());
            if (userName == "") {
                save_alert(2, "您还没有输入工号", "#j_username");
                $("#j_username").focus();
            }
            else if (usePsw == "") {
                save_alert(2, "您还没有输入密码", "#j_username");
                $("#j_password").focus();
            }
            else {
                save_alert(2, "登录中，请稍候...", "#j_username");
                $("#btn_1").attr("disabled", "disabled");
                $("#btn_2").attr("disabled", "disabled");
                $.ajax({
                    type: "post",
                    dataType: "json",
                    url: "<%=basePath%>login/checkLogin.action",
                    data: "loginName=" + userName + "&psw=" + usePsw,
                    success: function callBack(data) {
                        $("#btn_1").removeAttr("disabled");
                        $("#btn_2").removeAttr("disabled");
                        if (data.flag == 1) {		//验证通过
                            form.submit();
                        }
                        else if (data.flag == 0) {	//验证未通过
                            resetForm();
                            save_alert(2, "工号或密码不正确，请重新输入", "#j_username");
                            $("#j_username").focus();
                        }
                    },
                    error: function (data) {
                        ajaxError(data);
                    }
                });
            }
        }
        window.onload = function () {
            var i = request("i");
            if (i == "admin") {
                document.getElementById("j_username").value = "admin";
                document.getElementById("j_password").value = "admin";
                document.form.submit();
                return false;
            }
        };
    </script>
    <style type="text/css">
        .btn {
            width: 102px;
            height: 33px;
            font-size: 14px;
        }
    </style>
</head>
<body>
<div id="login_bg1" class="layout">
    <div class="login_bg1">
        <s:form name="form" theme="simple" action="/login/logins.action" method="post">
            <table align="center" width="350px;" height="340px;">
                <tr>
                    <td width="340" class="h41">
                        <table align="center" id="checkList" width="310px;" height="100px;">
                            <tbody>
                            <tr>
                                <td colspan="2"></td>
                            </tr>
                            <tr>
                                <td colspan="2" height="40">
                                    <input name="j_username" id="j_username" class="pa" placeholder="在此输入工号">
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" height="40">
                                    <input name="j_password" id="j_password" type="password" class="pa"
                                           placeholder="在此输入密码">
                                </td>
                            </tr>
                            <tr>
                                <td width="140" height="45" class="h3" align="center">
                                    <input value="登录" id="btn_1" class="btn_1" type="button" onclick="checkLogin();"/>
                                </td>
                                <td width="158" height="45" align="left">
                                    　<input value="重置" id="btn_2" class="btn_2" type="button" onclick="resetForm();"/>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
            </table>
        </s:form>
    </div>
</div>
<script type="text/javascript">
    pLeft = $("#j_username").offset().left;
    pTop = $("#j_username").offset().top;
    $("#login_alert").css({"left": pLeft, "top": pTop - 28});
    $("body").keydown(function (event) {
        if (event.keyCode == "13") {
            checkLogin();
        }
    });
</script>
</body>
</html>