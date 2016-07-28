<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="sx" uri="/struts-dojo-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix='fmt' uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>查看个人所在单位信息</title>
    <script type="text/javascript" src="../js/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <link rel="stylesheet" type="text/css" href="../css/button.css"/>
    <script type="text/javascript">
        $(function () {
            $.ajax({
                type: "post",
                dataType: "json",
                url: "json_myUserDep.action",
                success: function callBack(data) {
                    var map = data.map;
                    $("#depName").html(map.depName);
                    $("#depName1").html(map.depName);
                    $("#userName").html(map.leaderUserName);
                    $("#depAddr").html(map.depAddr);
                    $("#depDesc").html(map.depDesc);
                    $("#deps").html(map.deps);
                    $("#depLogo").html("<img src='../" + map.depLogo + "' id='imgEdit'>");
                    reChange("imgEdit", 200, 200);
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        });
        function edit() {
            window.location.href = "editMyDeps";
        }
    </script>
    <style>
        body {
            font: 15px arial, 微软雅黑, 宋体, sans-serif;
        }

        #tb2 .a {
            font-size: 15px;
            text-align: right;
            color: #217FA7;
        }

        #tb2 .b {
            padding-left: 10px;
        }

        #tb0 {
            font: normal bold 30px/50px arial, sans-serif;
        }

        #tb1 {
            font: normal normal 14px/25px arial, sans-serif;
        }

        .url {
            color: gray;
            font-size: 20px;
            position: absolute;
            line-height: 50px;
            margin-left: 20px
        }

        table {
            text-align: left
        }

        .divContent {
            padding: 0;
            margin: 15px 0;
            background: #f0fcff; /* 一些不支持背景渐变的浏览器 */
        }

        #imgEdit {
            box-shadow: 0px 3px 26px rgba(0, 0, 0, .9);
        }
    </style>
</head>
<body class="divContent">
<center>
    <table id="tb0">
        <tr>
            <td style="width:800px" id="depName1"></td>
        </tr>
        <tr style="height:0px;"></tr>
        <tr>
            <td>
                <hr/>
            </td>
        </tr>
    </table>
    <table id="tb1">
        <tr>
            <td style="width:250px;height:220px;padding-top:20px;" valign="top" id="depLogo">
            <td style="width:550px" valign="top" id="depDesc"></td>
        </tr>
    </table>
    <table id="tb2" style="padding-bottom:15px;">
        <tr>
            <td class="a" style="width:120px">单位名称：</td>
            <td class="b" style="width:250px" id="depName"></td>
            <td style="width:30px"></td>
            <td class="a" style="width:120px">单位负责人：</td>
            <td class="b" style="width:250px" id="userName"></td>
        </tr>
        <tr style="height:10px">
            <td colspan="2">
                <hr/>
            </td>
            <td></td>
            <td colspan="2">
                <hr/>
            </td>
        </tr>
        <tr>
            <td class="a">单位地址：</td>
            <td class="b" colspan="4" id="depAddr"></td>
        </tr>
        <tr style="height:10px">
            <td colspan="5">
                <hr/>
            </td>
        </tr>
        <tr>
            <td class="a">拥有部门：</td>
            <td class="b" colspan="4" id="deps"></td>
        </tr>
        <tr style="height:10px">
            <td colspan="5">
                <hr/>
            </td>
        </tr>
    </table>
    <c:if test="${nodeState==1}">
        <input class="btn_1" type="button" onclick="edit();" value="修改">
    </c:if>
</center>
<%-- <div align="center" id="divAcc">
    <table class="vu" border="0" cellspacing="0" cellpadding="0">
      <tr class="vT">
        <td width="20%"></td>
        <td width="80%"></td>
      </tr>
      <tr>
        <td bgcolor="#efefef" colspan="2"><div align="left"><span id="depName1" class="devClass ml20"></span>　<c:if test="${nodeState==1}"><input class="btn_1" type="button" onclick="edit();" value="编辑" /></c:if></div></td>
      </tr>
      <!-- <tr>
        <td id="depLogo" style="text-align:center"></td>
        <td class= "bb" style="padding-left:10px" id="depDesc" colspan="3"></td>
      </tr> -->
      <tr>
        <td class="cBlue cLeft">单位名称：</td>
        <td class= "bb" style="padding-left:10px" id="depName"></td>
      </tr>
      <tr>
        <td class="cBlue cLeft">单位负责人：</td>
        <td class= "bb" style="padding-left:10px" id="userName"></td>
      </tr>
      <tr>
        <td class="cBlue cLeft">单位地址：</td>
        <td class= "bb" style="padding-left:10px" id="depAddr"></td>
      </tr>
      <tr>
        <td class="cBlue cLeft">单位简介：</td>
        <td class= "bb" style="padding-left:10px" id="depDesc"></td>
      </tr>
      <tr>
        <td class="cBlue cLeft">拥有部门：</td>
        <td class= "bb" style="padding-left:10px" id="deps" colspan="3"></td>
      </tr>
    </table>
</div> --%>
</body>
</html>