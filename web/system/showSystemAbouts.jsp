<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>系统信息管理（'关于'页面）</title>
    <script type="text/javascript" src="../js/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <link href="../css/style.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript">
        var aboutId;
        var url = "json_systemAbouts.action?nodeState=${nodeState}";
        var url1 = url;
        var flag = 0;
        $(function () {
            jsons(1, 50, url);		//默认为第一页，每页50条数据
        });
        function add() {
            flag = 0;
            $("#div_detail").hide();
            $("#div_save").show();
            clearDetail();
            $("#tr1").hide();
            $("#tr2").show();
            beCenter("detail");
            $("#detail_bg").show();
            $("#detail").show(300);
        }
        function edit(id) {
            flag = 0;
            $("#div_detail").hide();
            $("#div_save").show();
            clearDetail();
            $.ajax({
                type: "post",
                dataType: "json",
                url: "showDetailSystemAbout.action",
                data: "aboutId=" + id,
                success: function callBack(data) {
                    var map = data.map;
                    $("#aboutId").val(map.aboutId);
                    $("#dutyUserId").val(map.dutyUserId);
                    $("#telephone1").val(map.telephone);
                    $("#name1").val(map.name);
                    $("#abbr1").val(map.abbr);
                    $("#version1").val(map.version);
                    $("#versionDesc1").val(map.versionDesc);
                    $("#copyright1").val(map.copyright);
                    $("#fax1").val(map.fax);
                    $("#email1").val(map.email);
                    $("#website1").val(map.website);
                    $("#tr1").hide();
                    $("#tr2").show();
                    beCenter("detail");
                    $("#detail_bg").show();
                    $("#detail").show(300);
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        }
        function detail(id) {
            $("#div_detail").show();
            $("#div_save").hide();
            $.ajax({
                type: "post",
                dataType: "json",
                url: "showDetailSystemAbout.action",
                data: "aboutId=" + id,
                success: function callBack(data) {
                    var map = data.map;
                    $("#aboutId").val(map.aboutId);
                    $("#dutyUserName").html(map.dutyUserName);
                    $("#telephone").html(map.telephone);
                    $("#name").html(map.name);
                    $("#abbr").html(map.abbr);
                    $("#version").html(map.version);
                    $("#updateDt").html(map.updateDt);
                    $("#versionDesc").html(map.versionDesc);
                    $("#copyright").html(map.copyright);
                    $("#fax").html(map.fax);
                    $("#email").html(map.email);
                    $("#website").html(map.website);
                    $("#tr1").show();
                    $("#tr2").hide();
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
            var name = $.trim($("#name1").val());
            var version = $.trim($("#version1").val());
            if (name == "") {
                save_alert(0, "您还没有输入系统名称", "#name1");
                $("#name1").addClass("inputAlarm");
            }
            else if (version == "") {
                save_alert(0, "您还没有输入版本号", "#version1");
                $("#version1").addClass("inputAlarm");
            }
            else if (flag == 0)
                jsons_save(form1);
        }
        function save_suc(data) {			//添加or修改成功后的返回函数
            var flags = data.flag;
            if (flags == 1) {
                top.success(1, "操作失败，请重试或联系管理员");
                $("#waiting").hide();
                return false;
            }
            var versionInfo = data.map;
            $("#detail").hide();
            if (!versionInfo) {
                top.success(0, "添加成功");
                var jumpPage = $("#jumpPage").val();
                var pageSize = $("#pageSize").val();
                jsons(jumpPage, pageSize, url);
            }
            else {
                var aboutId = versionInfo.aboutId;
                top.success(0, "修改成功");
                var tSort = $("#tr_" + aboutId + ">td:eq(0)").html();
                var tHtml = "<td width=5%>" + tSort + "</td>"
                        + "<td width=10%>" + versionInfo.dutyUserName + "</td>"
                        + "<td width=18%>" + versionInfo.name + "</td>"
                        + "<td width=14%>" + versionInfo.updateDt + "</td>"
                        + "<td width=8%>" + versionInfo.version + "</td>"
                        + "<td width=25%>" + versionInfo.versionDesc + "</td>"
                        + "<td width=20%><a class='aBtn aDetail' href='javascript:' onclick='detail(" + aboutId + ");'>详细信息</a>　<a class='aBtn aEdit' href='javascript:' onclick='edit(" + aboutId + ");'>编辑</a>　<a class='aBtn aDel' href='javascript:' onclick='del(" + aboutId + ");'>删除</a></td>";
                $("#tr_" + aboutId).html(tHtml);
                $("#waiting").hide();
                $("#detail_bg").hide().css("z-index", "50000");
            }
        }
        function query() {
            beCenter("query");
            $("#detail_bg").show();
            $("#query").show(300);
        }
        function query_done() {				//提交查询
            var queryVersion = $.trim($("#queryVersion").val());
            var url_query = "query_systemAbouts.action?nodeState=${nodeState}&queryVersion=" + queryVersion;
            json_query(url_query);
        }
        function del(id) {
            aboutId = id;
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
                url: "removeSystemAbout?aboutId=" + aboutId,
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
                        top.success(1, "删除失败，请重试或联系管理员");
                        $("#detail_bg").hide().css("z-index", "50000");
                        $("#waiting").hide();
                    }
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        }
        function checkVersion() {		//验证版本号
            var aboutId = $("#aboutId").val();
            var name = $.trim($("#name").val());
            if (name != "") {
                $.ajax({
                    type: "post",
                    dataType: "json",
                    url: "checkVersion.action?aboutId=" + aboutId + "&name=" + encodeURI(encodeURI(name)),
                    success: function (data) {
                        flag = data.flag;
                        if (flag != 0) {
                            save_alert(0, "已存在该版本号", "#name1");
                            $("#name1").addClass("inputAlarm");
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
            <th width=10%>责任人</th>
            <th width=18%>系统名称</th>
            <th width=14%>更新日期</th>
            <th width=8%>版本号</th>
            <th width=25%>版本说明</th>
            <th width=20%>更多</th>
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
        <a class='aBtn aEdit' href='javascript:' onclick='add();'>添 加</a>　
    </c:if>
    <a class='aBtn aEdit' href='javascript:' onclick='query();'>查 询</a>　
    <a class='aBtn aEdit' href='javascript:' onclick='allDatas();'>全 部</a>
    <div id="pages"></div>
</div>
<div id="detail" class="div_alt">
    <s:include value="showDetailSystemAbout.jsp"/>
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
                <li class="queryLeft">版本号：</li>
                <li><input id="queryVersion" Style="width:160px" class="inputText"></li>
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