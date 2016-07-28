<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>部门管理</title>
    <script type="text/javascript" src="../js/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <link href="../css/style.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript">
        var flag = 0;
        var depId;
        var url = "json_deps.action?nodeState=${nodeState}";
        var url1 = url;
        var isPublish;
        $(function () {
            jsons(1, 50, url);		//默认为第一页，每页50条数据
        });

        function add() {
            flag = 0;
            clearDetail();
            $("#depId").val("");
            beCenter("detail");
            $("#detail_bg").show();
            $("#detail").show(300);
        }
        function edit(id) {
            clearDetail();
            $.ajax({
                type: "post",
                dataType: "json",
                url: "showDetailDep.action",
                data: "depId=" + id,
                success: function callBack(data) {
                    var map = data.map;
                    $("#depId").val(map.id);
                    $("#depName").val(map.depName);
                    $("#leaderUserId").val(map.leaderUserId);
                    $("#depDesc").val(map.depDesc);
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
            var depName = $.trim($("#depName").val());
            if (depName == "") {
                save_alert(0, "您还没有输入部门名称", "#depName");
                $("#depName").addClass("inputAlarm");
            }
            else if (flag == 0) {
                jsons_save(form1);
            }
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
                        + "<td width=40%>" + dep.depDesc + "</td>"
                        + "<td width=25%><a class='aBtn aEdit' href='javascript:' onclick='edit(" + depId + ");'>编辑</a>　<a class='aBtn aDel' href='javascript:' onclick='del(" + depId + ");'>删除</a></td>";
                $("#tr_" + depId).html(tHtml);
                $("#waiting").hide();
                $("#detail_bg").hide().css("z-index", "50000");
            }
        }
        function del(id) {
            depId = id;
            $("#detail_bg").show();
            $("#aTitle").html("删除后将无法恢复，您确定要删除吗？");
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
                        top.success(1, "无法删除该部门");
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
            var depName = $.trim($("#depName").val());
            var depId = $.trim($("#depId").val());
            if (depName != "") {
                $.ajax({
                    type: "post",
                    dataType: "json",
                    url: "checkDep.action",
                    data: "depName=" + depName + "&depId=" + depId,
                    success: function callBack(data) {
                        flag = data.flag;
                        if (flag == 1) {
                            $("#depName_").css("display", "inline");
                            $("#depName").addClass("inputAlarm");
                        }
                        else {
                            $("#depName_").hide();
                            $("#depName").removeClass("inputAlarm");
                        }
                    },
                    error: function (data) {
                        ajaxError(data);
                    }
                });
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
            <th width=20%>部门名</th>
            <th width=10%>负责人</th>
            <th width=40%>部门简介</th>
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
        <a class='aBtn aEdit' href='javascript:' onclick='add();'>添加部门</a>　
    </c:if>
    <div id="pages"></div>
</div>
<div id="detail" class="div_alt">
    <s:include value="showDetailDep.jsp"/>
</div>
<div id="detail_bg"></div>
<div id="alert" class="div_alt">
    <s:include value="../main/alert.jsp"/>
</div>
<div id="waiting">
    <span id="waitings"></span>
</div>
</body>
</html>