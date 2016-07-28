<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="sx" uri="/struts-dojo-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>用户管理</title>
    <script type="text/javascript" src="../js/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../js/jquery.form.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <script type="text/javascript" src="../js/My97DatePicker/WdatePicker.js"></script>
    <link href="../css/style.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript">
        var flag = 0;
        var isOut = true;
        var isPho = true;
        var userId;
        var mailList = ['@qq.com', '@163.com', '@sina.com', '@sohu.com', '@gmail.com', '@126.com', '@hotmail.com'];
        var url = "json_userInfos.action?nodeState=${nodeState}";
        var url1 = url;
        $(function () {
            jsons(1, 50, url);		//默认为第一页，每页50条数据
        });
        function detail(userId) {
            $("#div_detail").show();
            $("#div_save").hide();
            $.ajax({
                type: "post",
                dataType: "json",
                url: "showDetailUserInfo.action",
                data: "userId=" + userId,
                success: function callBack(data) {
                    var map = data.map;
                    $("#userId").val(map.userId);
                    $("#userName").html(map.userName);
                    $("#loginName").html(map.loginName);
                    $("#sex").html(map.sex1);
                    $("#idCard").html(map.idCard);
                    $("#telephone").html(map.telephone);
                    $("#mobilephone").html(map.mobilephone);
                    $("#email").html(map.email);
                    $("#qq").html(map.qq);
                    $("#deptName").html(map.deptName);
                    $("#userTypeName").html(map.userTypeName);
                    if (map.picUrl != null) {
                        $("#Pic").html("<img src='../" + map.picUrl + "' id='imgDetail' class='imgDev'>");
                    } else {
                        $("#Pic").html("<img src='../img/imgNull.png' width='140' class='imgDev'>");
                    }
                    reChange("imgDetail", 140, 140);		//调整图片大小
                    $("#tr1").show();
                    $("#tr2").hide();
                    beCenter("detail");
                    $("#detail_bg").show();
                    $("#detail").show(300);
                    setDetail("detail");
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        }
        function edit(userId) {
            flag = 0;
            $("#div_detail").hide();
            $("#div_save").show();
            clearDetail();			//初始化detail内的所有元素
            $("#pswAlert").hide();
            $.ajax({
                type: "post",
                dataType: "json",
                url: "showDetailUserInfo.action",
                data: "userId=" + userId,
                success: function callBack(data) {
                    var map = data.map;
                    $("#userId").val(map.userId);
                    $("#userName1").val(map.userName);
                    $("#loginName1").val(map.loginName);
                    $("#telephone1").val(map.telephone);
                    $("#mobilephone1").val(map.mobilephone);
                    $("#email1").val(map.email);
                    $("#qq1").val(map.qq);
                    $("#deptId").val(map.deptId);
                    $("#userTypeId").val(map.userTypeId);
                    if (map.sex != null)
                        document.getElementById("sex1" + map.sex).checked = true;
                    $("#idCard1").val(map.idCard);
                    if (map.picUrl != null) {
                        $("#Pic1").html("<img src='../" + map.picUrl + "' id='imgEdit' class='imgDev'>");
                    } else {
                        $("#Pic1").html("<img src='../img/imgNull.png' width='140' class='imgDev'>");
                    }
                    reChange("imgEdit", 140, 140);		//调整图片大小
                    $("#loginName1").attr("readonly", "readonly");
                    $("#achId").html("");
                    var aChs = map.aChs;
                    for (var i in aChs) {
                        $("#achId").append('<option value=' + aChs[i].id + '>' + aChs[i].achName + '</option>');
                    }
                    $("#achId").val(map.achId);
                    $("#areaId").val(map.areaId);
                    $("#tr1").hide();
                    $("#tr2").show();
                    beCenter("detail");
                    $("#detail_bg").show();
                    $("#detail").show(300);
                    setDetail("detail");
                    $("#flag").attr("flag", "1");		//flag=1，标记为修改
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        }
        function add() {
            flag = 0;
            $("#div_detail").hide();
            $("#div_save").show();
            clearDetail();
            $("#userName1");
            $("#loginName1").removeAttr("readonly");
            $("#pswAlert").show();
            //$("#tr2 :radio[name=actorId]")[0].checked=true;		//默认没有角色
            $("#tr1").hide();
            $("#tr2").show();
            beCenter("detail");
            $("#detail_bg").show();
            $("#detail").show(300);
            setDetail("detail");
            $("#flag").attr("flag", "0");		//flag=0，标记为保存
        }
        function save() {
            if ($("#tr2").css("display") != "none") {
                var userName = $.trim($("#userName1").val());
                var loginName = $.trim($("#loginName1").val());
                var email = $.trim($("#email1").val());
                var telePhone = $.trim($("#telephone1").val());
                var mobilePhone = $.trim($("#mobilephone1").val());
                var qq = $.trim($("#qq1").val());
                var idCard = $.trim($("#idCard1").val());
                if (userName == "") {
                    save_alert(0, "您还没有输入用户名", "#userName1");
                    $("#userName1").addClass("inputAlarm");
                }
                else if (loginName == "") {
                    save_alert(0, "您还没有输入工号", "#loginName1");
                    $("#loginName1").addClass("inputAlarm");
                }
                else if (idCard != "" && testIdCardNo(idCard) != "验证通过!") {
                    save_alert(0, testIdCardNo(idCard), "#idCard1");
                    $("#idCard1").addClass("inputAlarm");
                }
                else if (email != "" && !isEmail(email)) {
                    save_alert(0, "请输入正确的邮箱帐号", "#email1");
                    $("#email1").addClass("inputAlarm");
                }
                else if (mobilePhone != "" && isMobil(mobilePhone) != "success") {
                    save_alert(0, "请输入正确的手机号", "#mobilephone1");
                    $("#mobilephone1").addClass("inputAlarm");
                }
                else if (telePhone != "" && isPhone(telePhone) != "success") {
                    save_alert(0, "请输入正确的固定电话", "#telephone1");
                    $("#telephone1").addClass("inputAlarm");
                }
                else if (qq != "" && isQq(qq) != "success") {
                    save_alert(0, "请输入正确的QQ号", "#qq1");
                    $("#qq1").addClass("inputAlarm");
                }
                else if (flag == 0 && isPho) {
                    if ($("#upload").val() == "") {	//没有选择照片，则不上传
                        jsons_save(form1);
                    }
                    else {
                        $("#detail").hide();
                        beCenter("waiting");
                        $("#waitings").html("保存中，请稍候....");
                        $("#waiting").show();
                        var options = {
                            url: "addUserInfo.action",
                            type: "POST",
                            dataType: "json",
                            success: function (data) {
                                save_suc(data);
                            },
                            error: function (data) {
                                ajaxError(data);
                            }
                        };
                        $("#form1").ajaxSubmit(options);
                    }
                }
            }
        }
        function save_suc(data) {			//添加or修改成功后的返回函数
            var user = data.map;
            $("#detail").hide();
            if (!user) {
                top.success(0, "添加成功");
                var jumpPage = $("#jumpPage").val();
                var pageSize = $("#pageSize").val();
                jsons(jumpPage, pageSize, url);
            }
            else {
                var userId = user.userId;
                top.success(0, "修改成功");
                var tSort = $("#tr_" + userId + ">td:eq(0)").html();
                var tHtml = "<td width=4%>" + tSort + "</td>"
                        + "<td width=7%>" + user.userName + "</td>"
                        + "<td width=9%>" + user.loginName + "</td>"
                        + "<td width=9%>" + user.userTypeName + "</td>"
                        + "<td width=5%>" + user.sex + "</td>"
                        + "<td width=9%>" + user.deptName + "</td>"
                        + "<td width=18%><a class='aBtn aEdit' href='javascript:' onclick='detail(" + userId + ");'>详细信息</a>"
                        + "　<a class='aBtn aEdit' href='javascript:' onclick='edit(" + userId + ");'>编辑</a>"
                        + "　<a class='aBtn aDel' href='javascript:' onclick='del(" + userId + ");'>删除</a></td>";
                $("#tr_" + userId).html(tHtml);
                $("#waiting").hide();
                $("#detail_bg").hide().css("z-index", "50000");
            }
        }
        function checkLogins() {
            var userId = $("#userId").val();
            if ($.trim(userId) == "") {
                var loginName = $.trim($("#loginName1").val());
                var depId = request("depId");
                if (!isChinese(loginName)) {
                    flag = 1;
                    $("#loginName1").addClass("inputAlarm");
                    $("#loginName1_").html("工号不能为汉字");
                    $("#loginName1_").css("display", "inline");
                }
                else if (loginName != "") {
                    $.ajax({
                        type: "post",
                        dataType: "json",
                        url: "checkLoginName.action",
                        data: "loginName=" + loginName + "&depId" + depId,
                        success: function callBack(data) {
                            flag = data.flag;
                            if (flag == 1) {
                                $("#loginName1").addClass("inputAlarm");
                                $("#loginName1_").html("工号重复");
                                $("#loginName1_").css("display", "inline");
                            }
                            else {
                                $("#loginName1").removeClass("inputAlarm");
                                $("#loginName1_").hide();
                            }
                        },
                        error: function (data) {
                            ajaxError(data);
                        }
                    });
                }
            }
        }
        function checkPhoto() {
            var value = $("#upload").val();
            var photoEx = value.substring(value.lastIndexOf("."));
            if (photoEx == ".gif" || photoEx == ".jpg" || photoEx == ".jpeg" || photoEx == ".png" || photoEx == ".bmp") {
                $("#upload_").hide();
                isPho = true;
            }
            else {
                $("#upload_").show();
                isPho = false;
            }
        }
        function query() {			//弹出查询窗口
            beCenter("query");
            $("#detail_bg").show();
            $("#query").show(300);
        }
        function query_done() {
            var queryLoginName = $.trim($("#queryLoginName").val());
            var queryUserName = $.trim($("#queryUserName").val());
            var url_query = "query_userInfos.action?nodeState=${nodeState}&queryLoginName=" + queryLoginName
                    + "&queryUserName=" + encodeURI(encodeURI(queryUserName));
            json_query(url_query);
        }
        function del(id) {
            userId = id;
            $("#detail_bg").show();
            beCenter("alert");
            $("#alert").show(300);
        }
        function del_done() {
            $("#detail_bg").css("z-index", "50010");
            beCenter("waiting");
            $("#waitings").html("删除中，请稍候....");
            $("#waiting").show();
            $.ajax({
                type: "post",
                dataType: "json",
                url: "removeUserInfo.action?userId=" + userId,
                success: function (data) {
                    var flag = data.flag;
                    $("#alert").hide(300);
                    $("#detail_bg").css("z-index", "50000");
                    if (flag == 0) {
                        top.success(0, "删除成功");
                        var jumpPage = $("#jumpPage").val();
                        var pageSize = $("#pageSize").val();
                        jsons(jumpPage, pageSize, url);
                    }
                    else {
                        top.success(1, "删除失败");
                        $("#detail_bg").hide();
                        $("#waiting").hide();
                    }
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        }
    </script>
    <style>
        table {
            table-layout: fixed;
        }

        td {
            word-break: break-all;
            word-wrap: break-word;
        }

        .vu {
            border: 1px solid #d3d3d3;
            border-collapse: collapse;
            width: 100%;
            width: 800px;
            text-align: left;
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

        .cLeft {
            text-align: right;
            padding-right: 10px;
        }

        ul, li, p {
            padding: 0;
            margin: 0;
        }

        li, ul {
            list-style-type: none;
        }
    </style>
</head>
<body>
<div align="left">
    <table id="vv">
        <thead>
        <tr>
            <th width=4%>序号</th>
            <th width=7%>姓名</th>
            <th width=9%>工号</th>
            <th width=9%>用户类型</th>
            <th width=5%>性别</th>
            <th width=9%>所在部门</th>
            <th width=18%>操作</th>
        </tr>
        </thead>
    </table>
</div>
<div class="h1">
    <table id="v" id="main_table">
        <tbody id="bbsTab">
        </tbody>
    </table>
</div>
<div id="Page">
    <c:if test="${nodeState==1}">
        <a class='aBtn aEdit' href='javascript:' onclick='add();'>添 加</a>　
    </c:if>
    <a class='aBtn aEdit' href='javascript:' onclick='query();'>查 询</a>　
    <a class='aBtn aEdit' href='javascript:' onclick='allDatas();'>全 部</a>　
    <div id="pages"></div>
</div>
<div id="detail" class="div_alt">
    <s:include value="showDetailUserInfo.jsp"/>
</div>
<div id="detail_bg"></div>
<div id="alert" class="div_alt">
    <s:include value="../main/alert.jsp"/>
</div>
<div id="waiting">
    <span id="waitings"></span>
</div>
<div id="query" class="div_alt">
    <div class="queryBody">
        <div class="detail_title" onmousedown="mouseDownFun('query')"><span class="detail_header">　查询</span><span
                class="detail_close" onclick="closeDiv('query')" title="关闭">X</span></div>
        <div class="queryContent">
            <ul>
                <li><span class="queryLeft">　　姓名：</span><input id="queryUserName" Style="width:160px" class="inputText">
                </li>
                <li><span class="queryLeft">　　工号：</span><input id="queryLoginName" Style="width:160px"
                                                               class="inputText"></li>
            </ul>
        </div>
        <div class="queryBtn">
            <input value="确定" class="btn_1" type="button" flag="done" onclick="query_done();"/>
            　　<input value="取消" class="btn_2" type="button" onclick="closeDiv('query');"/>
        </div>
    </div>
</div>
<ul id="emaillist" class="emaillist" onmouseover="isOut=false" onmouseout="isOut=true"></ul>
</body>
</html>