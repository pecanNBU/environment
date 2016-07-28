<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE HTML>
<%@ taglib prefix="s" uri="/struts-tags" %>
<s:actionmessage cssStyle="list-style-type:none;" escape="false"/>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <script type="text/javascript" src="../js/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <title>登录</title>
    <script type="text/javascript">
        window.onload = function () {
            var error = request("error");
            if (1 == error) {
                $('error1').style.display = "block";
                $('error1').innerHTML = "您输入的帐号或密码不正确，请重新输入";
            }
            else if (2 == error)
                alert("权限不足");
        };
        function reloadImg() {
            var i = Math.random();
            document.getElementById("imgCode").src = "imgcode?" + i;
        }
        function checkReg() {
            /* jQuery.post(
             "isalarm",
             function(data_p){
             },
             "json"
             ); */
            return true;
        }
    </script>
    <link href="../org/style.css" rel="stylesheet" type="text/css"/>
    <style type="text/css">
        .s1 {
            color: #ff2121;
            background: url(../img/error.png) no-repeat;
            padding-left: 14px;
        }

        .btn {
            width: 95px;
            height: 28px;
            font-size: 14px;
        }
    </style>
</head>
<body>
<div id="login_bg" class="layout">
    <div class="login_bg1">
        <s:form theme="simple" action="logins">
            <table align="center" width="350px;" height="187">
                <tr height="34">
                    <td></td>
                </tr>
                <tr height="20">
                    <td><span class="s1" id="error1" style="margin-left:50px;display:none"></span></td>
                </tr>
                <tr height="30">
                    <td height="36">
                        <div style="margin-left:160px"><s:textfield name="j_username"
                                                                    cssStyle="width:150px;height:20px;background-color:#E0EEE0 "/></div>
                    </td>
                </tr>
                <tr height="30">
                    <td height="37">
                        <div style="margin-left:160px"><s:password name="j_password"
                                                                   cssStyle="width:150px;height:20px;background-color:#E0EEE0 "/></div>
                    </td>
                </tr>
                <tr>
                    <td height="43">　　　　　<input value="　&nbsp;登录&nbsp;　" type="submit" class="btn"
                                                onclick="return checkReg();"/>　　　<input value="　&nbsp;重置&nbsp;　"
                                                                                        type="reset" class="btn"/></td>
                </tr>
            </table>
        </s:form>
    </div>
</div>
</body>


</html>