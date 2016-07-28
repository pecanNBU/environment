<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>采样周期管理</title>
    <script type="text/javascript" src="../js/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <link href="../css/style.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript">
        var flag = 0;
        var nodeState = ${nodeState};	//页面权限【0：浏览；1：管理】
        $(function () {
            var url = "json_systemComus?nodeState=${nodeState}";
            jsons_noPage(url);		//默认为第一页，每页50条数据
            $("input[onlyUnInt='true']").onlyUnInt();
        });
        function add() {
            clearDetail();
            beCenter("detail");
            $("#detail_bg").show();
            $("#detail").show(300);
        }
        function edit(id) {
            clearDetail();
            $.ajax({
                type: "post",
                dataType: "json",
                url: "showDetailSystemComu.action",
                data: "comuId=" + id,
                success: function callBack(data) {
                    var map = data.map;
                    $("#comuId").val(map.comuId);
                    $("#comuTypeId").val(map.comuTypeId);
                    $("#acceptMeth").val(map.acceptMeth);
                    var maxPeriod = map.maxPeriod;
                    if (maxPeriod % 3600000 == 0) {		//小时
                        $("#maxPeriod").val(maxPeriod / 3600000);
                        $("#perTypeMax").val(3);
                    }
                    else if (maxPeriod % 60000 == 0) {	//分钟
                        $("#maxPeriod").val(maxPeriod / 60000);
                        $("#perTypeMax").val(2);
                    }
                    else if (maxPeriod % 1000 == 0) {		//秒
                        $("#maxPeriod").val(maxPeriod / 1000);
                        $("#perTypeMax").val(1);
                    }
                    else {
                        $("#maxPeriod").val(maxPeriod);
                        $("#perTypeMax").val(0);
                    }
                    var samplePeriod = map.samplePeriod;
                    if (samplePeriod % 3600000 == 0) {	//小时
                        $("#samplePeriod").val(samplePeriod / 3600000);
                        $("#perTypePeriod").val(3);
                    }
                    else if (samplePeriod % 60000 == 0) {//分钟
                        $("#samplePeriod").val(samplePeriod / 60000);
                        $("#perTypePeriod").val(2);
                    }
                    else if (samplePeriod % 1000 == 0) {						//秒
                        $("#samplePeriod").val(samplePeriod / 1000);
                        $("#perTypePeriod").val(1);
                    }
                    else {
                        $("#samplePeriod").val(samplePeriod);
                        $("#perTypePeriod").val(0);
                    }
                    if (nodeState == 0)
                        cmsComp();	//特指农业养殖项目的限制权限
                    beCenter("detail");
                    $("#detail_bg").show();
                    $("#detail").show(300);
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        }
        function cmsComp() {
            $("#comuTypeId,#acceptMeth,#maxPeriod,#perTypeMax").attr("disabled", "true");
        }
        function clearComp() {
            $("#comuTypeId,#acceptMeth,#maxPeriod,#perTypeMax").removeAttr("disabled");
        }
        function checkPeriod(i) {		//确保采样周期<=最大周期
            if (flag == 2)
                flag = 0;
            var samplePeriod = $.trim($("#samplePeriod").val());
            var perTypePeriod = transPerType($("#perTypePeriod").val());
            var maxPeriod = $.trim($("#maxPeriod").val());
            var perTypeMax = transPerType($("#perTypeMax").val()) * 1000;
            if (i == 0 && samplePeriod != "") {		//采样周期
                if (!isUNaN(samplePeriod)) {
                    save_alert(0, "请输入正整数", "#samplePeriod");
                    $("#samplePeriod").addClass("inputAlarm");
                    return false;
                }
            }
            if (i == 1 && maxPeriod != "") {		//最大周期
                if (!isUNaN(maxPeriod)) {
                    save_alert(0, "请输入正整数", "#maxPeriod");
                    $("#maxPeriod").addClass("inputAlarm");
                    return false;
                }
            }
            //alert(samplePeriod*perTypePeriod+"|"+maxPeriod*perTypeMax);
            if (samplePeriod != "" && maxPeriod != "" && (samplePeriod * perTypePeriod > maxPeriod * perTypeMax)) {
                flag = 2;
                save_alert(0, "采样周期不得大于最大周期", "#samplePeriod");
                $("#samplePeriod").addClass("inputAlarm");
            }
            if (samplePeriod * perTypePeriod < 10000) {
                flag = 2;
                save_alert(0, "采样周期不得小于10秒", "#samplePeriod");
                $("#samplePeriod").addClass("inputAlarm");
            }
        }
        function transPerType(perType) {		//转换采样周期的时间单位
            var pType = 0;
            switch (perType) {
                case "0":
                    pType = perType;
                    break;
                case "1":
                    pType = perType * 1000;
                    break;
                case "2":
                    pType = perType * 60 * 1000;
                    break;
                case "3":
                    pType = perType * 3600 * 1000;
                    break;
            }
            return pType;		//返回秒
        }
        function checkComuType() {		//验证通讯类型，防重复
            if (flag == 1)
                flag = 0;
            var comuTypeId = $("#comuTypeId").val();
            var comuId = $("#comuId").val();
            $.ajax({
                type: "post",
                dataType: "json",
                url: "checkComuType.action?comuId=" + comuId + "&comuTypeId=" + comuTypeId,
                success: function (data) {
                    flag = data.flag;
                    if (flag == 1) {
                        save_alert(1, "已存在该通讯方式，请勿重复添加", "#comuTypeId");
                        $("#comuTypeId").css("margin", "-1px");
                        $("#comuTypeId_d").addClass("select_d");
                    }
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        }
        function save() {
            var samplePeriod = $.trim($("#samplePeriod").val());
            var maxPeriod = $.trim($("#maxPeriod").val());
            var comuTypeId = $("#comuTypeId").val();
            var comuId = $("#comuId").val();
            checkPeriod(0);
            if (maxPeriod == "") {
                save_alert(0, "最大周期(正整数)不得为空", "#maxPeriod");
                $("#maxPeriod").addClass("inputAlarm");
            }
            else if (samplePeriod == "") {
                save_alert(0, "采样周期(正整数)不得为空", "#samplePeriod");
                $("#samplePeriod").addClass("inputAlarm");
            }
            else if (flag == 0) {
                $.ajax({
                    type: "post",
                    dataType: "json",
                    url: "checkComuType.action?comuId=" + comuId + "&comuTypeId=" + comuTypeId,
                    success: function (data) {
                        flag = data.flag;
                        if (flag == 1) {
                            save_alert(1, "已存在该通讯方式，请勿重复添加", "#comuTypeId");
                            $("#comuTypeId").css("margin", "-1px");
                            $("#comuTypeId_d").addClass("select_d");
                        }
                        else {
                            clearComp();
                            jsons_save(form1);
                        }
                    },
                    error: function (data) {
                        ajaxError(data);
                    }
                });
            }
        }
        function save_suc(data) {			//添加or修改成功后的返回函数
            if (nodeState == 0)
                cmsComp();
            var flags = data.flag;
            if (flags == 1) {
                top.success(1, "操作失败，请重试或联系管理员");
                $("#waiting").hide();
                $("#detail_bg").css("z-index", "50000");
                return false;
            }
            var systemComu = data.map;
            $("#detail").hide();
            if (systemComu == null) {
                top.success(0, "添加成功");
                var jumpPage = $("#jumpPage").val();
                var pageSize = $("#pageSize").val();
                jsons(jumpPage, pageSize, url);
            }
            else {
                var comuId = systemComu.comuId;
                top.success(0, "修改成功");
                var tSort = $("#tr_" + comuId + ">td:eq(0)").html();
                var tLast = $("#tr_" + comuId + ">td:last").html();
                var tHtml = "<td width=5%>" + tSort + "</td>"
                        + "<td width=25%>" + systemComu.comuTypeName + "</td>"
                        + "<td width=15%>" + systemComu.acceptMeth + "</td>"
                        + "<td width=10%>" + systemComu.comuState + "</td>"
                        + "<td width=15%>" + systemComu.maxPeriod + "</td>"
                        + "<td width=15%>" + systemComu.samplePeriod + "</td>"
                        + "<td width=15%>" + tLast + "</td>";
                $("#tr_" + comuId).html(tHtml);
                $("#waiting").hide();
                $("#detail_bg").hide().css("z-index", "50000");
            }
        }
        function stopComu(id, enName) {		//表示停用该警报
            comuId = id;
            $("#detail_bg").show();
            beCenter("alert");
            $("#a_title").html("停用确认");
            var titleHtml = "确认停止采样吗？该操作会立即执行。";
            $("#aTitle").html(titleHtml);
            $("#alert").show(300);
            comuState = 0;
        }
        function startComu(id, enName) {		//表示启用该警报
            comuId = id;
            $("#detail_bg").show();
            beCenter("alert");
            $("#a_title").html("启用确认");
            var titleHtml = "";
            if (enName == 'comuType')
                titleHtml = "确认开始采样吗？该操作会立即执行。";
            $("#aTitle").html(titleHtml);
            $("#alert").show(300);
            comuState = 1;
        }
        function comu_done() {		//停用/启用警报
            $("#detail_bg").css("z-index", "50010");
            beCenter("waiting");
            $("#waitings").html("操作中，请稍候....");
            $("#waiting").show();
            $.ajax({
                type: "post",
                dataType: "json",
                url: "changeComuState?comuId=" + comuId + "&comuState=" + comuState,
                success: function (data) {
                    var flags = data.flag;
                    $("#alert").hide(300);
                    $("#detail_bg").hide().css("z-index", "50000");
                    $("#waiting").hide();
                    if (flags == 0) {
                        top.success(0, "操作成功");
                        if (comuState == 0) {
                            $("#tr_" + comuId + " td:eq(3)").html("未用");
                            $("#tr_" + comuId + " td:last").html("<a class='aBtn aEdit' href='javascript:' onclick='edit(" + comuId + ");'>编辑</a>"
                                    + "　<a class='aBtn aGreen' href='javascript:' onclick='startComu(" + comuId + ");'>启用</a>");
                        }
                        else {
                            $("#tr_" + comuId + " td:eq(3)").html("已用");
                            $("#tr_" + comuId + " td:last").html("<a class='aBtn aEdit' href='javascript:' onclick='edit(" + comuId + ");'>编辑</a>"
                                    + "　<a class='aBtn aDel' href='javascript:' onclick='stopComu(" + comuId + ");'>停用</a>");
                        }
                    }
                    else
                        top.success(1, "操作失败，请重试或联系管理员");
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        }
    </script>
    <style>
        body {
        }

        table {
            table-layout: fixed;
        }

        td {
            word-break: break-all;
            word-wrap: break-word;
        }
    </style>
</head>
<body>
<div align="left">
    <table id="vv">
        <thead>
        <tr>
            <th width="5%">序号</th>
            <th width="25%">通讯名称</th>
            <th width="15%">通讯方式</th>
            <th width="10%">通讯状态</th>
            <th width="15%">最大周期</th>
            <th width="15%">设定周期</th>
            <th width="15%">编辑</th>
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
<%--<c:if test="${nodeState==1}">
    <div style="padding-top:15px;">
        <a class='aBtn aEdit' href='javascript:' onclick='add();'>添 加</a>　
    </div>
</c:if>--%>
<div id="detail" class="div_alt">
    <s:include value="showDetailSystemComu.jsp"/>
</div>
<div id="detail_bg"></div>
<div id="waiting"><span id="waitings"></span></div>
<div id="alert" class="div_alt">
    <s:include value="comuAlert.jsp"/>
</div>
</body>
</html>