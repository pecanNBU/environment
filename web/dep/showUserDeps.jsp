<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>单位管理</title>
    <script type="text/javascript" src="../js/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <link href="../css/style.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript">
        var flag = 0;
        var depId;
        var url = "json_userDeps.action?nodeState=${nodeState}";
        var url1 = url;
        var isPublish;
        $(function () {
            jsons(1, 50, url);		//默认为第一页，每页50条数据
        });

        function add() {
            flag = 0;
            $("#div_detail").hide();
            $("#div_save").show();
            clearDetail();
            $("#depId").val("");
            $("#loginName__").css("color", "gray");
            $("#loginName1").removeAttr("readonly");
            $("#tr1").hide();
            $("#tr2").show();
            $("#divss").css("width", "465px");
            $("#Table").css("width", "300px");
            beCenter("detail");
            $("#detail_bg").show();
            $("#detail").show(300);
        }
        function detail(id) {
            flag = 0;
            $("#div_detail").show();
            $("#div_save").hide();
            $.ajax({
                type: "post",
                dataType: "json",
                url: "showDetailUserDep.action",
                data: "depId=" + id,
                success: function callBack(data) {
                    var map = data.map;
                    $("#depId").val(map.id);
                    $("#depName").html(map.depName);
                    $("#pName").html(map.pName);
                    $("#depCode").html(map.depCode);
                    $("#depAddr").html(map.depAddr);
                    $("#loginName").html(map.loginUser);
                    if (map.picUrl != null) {
                        $("#Pic").html("<img src='../" + map.picUrl + "' id='imgDetail' class='imgDev'>");
                    } else {
                        $("#Pic").html("<img src='../img/imgNull.png' height='140' class='imgDev'>");
                    }
                    reChange("imgDetail", 140, 140);		//调整图片大小
                    $("#tr1").show();
                    $("#tr2").hide();
                    $("#divss").css("width", "600px");
                    $("#Table").css("width", "480px");
                    beCenter("detail");
                    $("#detail_bg").show();
                    $("#detail").show(300);
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        }
        function edit(id) {
            $("#div_detail").hide();
            $("#div_save").show();
            clearDetail();
            $.ajax({
                type: "post",
                dataType: "json",
                url: "showDetailUserDep.action",
                data: "depId=" + id,
                success: function callBack(data) {
                    var map = data.map;
                    $("#depId").val(map.id);
                    $("#depName1").val(map.depName);
                    $("#loginName1").val(map.loginName);
                    $('#loginName1').attr("readonly", "readonly");
                    $("#loginName__").css("color", "gray");
                    $("#tr1").hide();
                    $("#tr2").show();
                    $("#divss").css("width", "465px");
                    $("#Table").css("width", "300px");
                    beCenter("detail");
                    $("#detail_bg").show();
                    $("#detail").show(300);
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        }
        function save() {
            var depName = $.trim($("#depName1").val());
            var loginName = $.trim($("#loginName1").val());
            if (depName == "") {
                save_alert(0, "您还没有输入单位名称", "#depName1");
                $("#depName1").addClass("inputAlarm");
            }
            else if (loginName == "") {
                save_alert(0, "您还没有输入登录账户", "#loginName1");
                $("#loginName1").addClass("inputAlarm");
            }
            else if (flag == 0) {
                jsons_save(form1);
            }
        }
        function save_cancle() {		//关闭取消发布单位时弹出的小窗口
            $("#alert").hide();
            $("#detail_bg").css("z-index", "50000");
        }
        function save_done() {
            $("#alert").css("z-index", "50003");
            jsons_save(form1);
        }
        function save_suc(data) {			//添加or修改成功后的返回函数
            var dep = data.map;
            $("#alert").hide();
            $("#detail").hide();
            if (!dep) {
                top.success(0, "添加成功");
                var jumpPage = $("#jumpPage").val();
                var pageSize = $("#pageSize").val();
                jsons(jumpPage, pageSize, url);
            }
            else {
                var depId = dep.depId;
                top.success(0, "修改成功");
                var tSort = $("#tr_" + depId + ">td:eq(0)").html();
                var tHtml = "<td width=5%>" + tSort + "</td>"
                        + "<td width=20%>" + dep.depName + "</td>"
                        + "<td width=10%>" + dep.userName + "</td>"
                        + "<td width=40%>" + dep.depAddr + "</td>"
                        + "<td width=25%><a class='aBtn aEdit' href='javascript:' onclick='detail(" + depId + ");'>详细信息</a>　<a class='aBtn aEdit' href='javascript:' onclick='edit(" + depId + ");'>编辑</a>　<a class='aBtn aDel' href='javascript:' onclick='del(" + depId + ");'>删除</a></td>";
                $("#tr_" + depId).html(tHtml);
                $("#waiting").hide();
                $("#detail_bg").hide().css("z-index", "50000");
            }
        }
        function query() {
            $("#save_alert").remove();
            beCenter("query");
            $("#detail_bg").show();
            $("#query").show(300);
        }
        function query_done() {				//提交查询
            var queryWord = $.trim($("#queryWord").val());
            var url_query = "query_userDeps.action?nodeState=${nodeState}&queryWord=" + encodeURI(encodeURI(queryWord));
            json_query(url_query);
        }
        function del(id) {
            depId = id;
            $("#detail_bg").show();
            $("#aTitle").html("删除后将无法恢复，您确定要删除吗？");
            beCenter("alert");
            $("#alert").show(300);
            $("#alert_update").removeAttr("onclick");
            $("#alert_update").attr("onclick", "del_done()");
            $("#alert_back").removeAttr("onclick");
            $("#alert_back").attr("onclick", "closeDiv('alert')");
        }
        function del_done() {
            $("#detail_bg").css("z-index", "50010");
            beCenter("waiting");
            $("#waitings").html("删除中，请稍候....");
            $("#waiting").show();
            $.ajax({
                type: "post",
                dataType: "json",
                url: "removeUserDep?depId=" + depId,
                success: function (data) {
                    var flags = data.flag;
                    $("#alert").hide(300);
                    if (flags == 0) {
                        top.success(0, "删除成功");
                        var jumpPage = $("#jumpPage").val();
                        var pageSize = $("#pageSize").val();
                        jsons(jumpPage, pageSize, url);
                    }
                    else {
                        top.success(1, "无法删除该单位");
                        $("#detail_bg").hide().css("z-index", "50000");
                        $("#waiting").hide();
                    }
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        }

        function checkDep() {
            var depName = $.trim($("#depName1").val());
            var depId = $.trim($("#depId").val());
            if (depName != "") {
                $.ajax({
                    type: "post",
                    dataType: "json",
                    url: "checkUserDep.action",
                    data: "depName=" + depName + "&depId=" + depId,
                    success: function callBack(data) {
                        flag = data.flag;
                        if (flag == 1) {
                            $("#depName1_").css("display", "inline");
                            $("#depName1").addClass("inputAlarm");
                        }
                        else {
                            $("#depName1_").hide();
                            $("#depName1").removeClass("inputAlarm");
                        }
                    },
                    error: function (data) {
                        ajaxError(data);
                    }
                });
            }
        }
        function checkLogin() {
            var loginName = $.trim($("#loginName1").val());
            if (!isChinese(loginName)) {		//帐号不能包含汉字
                $("#loginName__").css("color", "red");
                flag = 1;
            }
            else {
                var depId = $.trim($("#depId").val());
                if (loginName != "") {
                    $.ajax({
                        type: "post",
                        dataType: "json",
                        url: "checkLogin.action",
                        data: "loginName=" + loginName + "&depId=" + depId,
                        success: function callBack(data) {
                            flag = data.flag;
                            if (flag == 1) {
                                $("#loginName1_").css("display", "inline");
                                $("#loginName1").addClass("inputAlarm");
                            }
                            else {
                                $("#loginName1_").hide();
                                $("#loginName1").removeClass("inputAlarm");
                            }
                        },
                        error: function (data) {
                            ajaxError(data);
                        }
                    });
                }
            }
        }
    </script>
</head>
<body>
<div align="left">
    <table id="vv">
        <thead>
        <tr>
            <th width=5%>序号</th>
            <th width=20%>单位名</th>
            <th width=10%>负责人</th>
            <th width=40%>单位地址</th>
            <th width=25%>编辑</th>
        </tr>
        </thead>
    </table>
</div>
<div class="h1">
    <table id="v">
        <tbody id="bbsTab">
        </tbody>
    </table>
</div>
<div id="Page">
    <c:if test="${nodeState==1}">
        <a class='aBtn aEdit' href='javascript:' onclick='add();'>添加单位</a>　
    </c:if>
    <a class='aBtn aEdit' href='javascript:' onclick='query();'>查询单位</a>　
    <a class='aBtn aEdit' href='javascript:' onclick='allDatas();'>全部单位</a>
    <div id="pages"></div>
</div>
<div id="detail" class="div_alt">
    <s:include value="showDetailUserDep.jsp"/>
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
                <li><span class="queryLeft">　单位名：</span><input id="queryWord" onclick="resetBorder(id);"
                                                               Style="width:160px" class="inputText"></li>
            </ul>
        </div>
        <div class="queryBtn">
            <input value="确定" class="btn_1" type="button" flag="done" onclick="query_done();"/>
            　　<input value="取消" class="btn_2" type="button" onclick="closeDiv('query');"/>
        </div>
    </div>
</div>
</body>
</html>