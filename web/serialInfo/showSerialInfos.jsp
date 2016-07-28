<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>串口管理</title>
    <script type="text/javascript" src="../js/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <link href="../css/style.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript">
        var serialId;
        var url = "json_serialInfos.action?nodeState=${nodeState}";
        var url1 = url;
        var flag = 0;
        var devc_Page = 1;
        var devc_Size = 50;
        var nodeState = ${nodeState};	//页面权限【0：浏览；1：管理】
        var _active;
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
            if (nodeState == 0 && _active == 1) {
                dataAlarm(0);
                return;
            }
            flag = 0;
            $("#div_detail").hide();
            $("#div_save").show();
            clearDetail();
            //$("#isActive1, #isActive0").attr("readonly", true);
            $.ajax({
                type: "post",
                dataType: "json",
                url: "showDetailSerialInfo.action",
                data: "serialId=" + id,
                success: function callBack(data) {
                    var map = data.map;
                    $("#devId").val(map.devId);
                    $("#serialId").val(map.serialId);
                    $("#commPortId").val(map.commPortId);
                    $("#baudRate").val(map.baudRate);
                    $("#parity").val(map.parity);
                    $("#dataBits").val(map.dataBits);
                    $("#stopBits").val(map.stopBits);
                    document.getElementById("isActive" + map.isActive).checked = true;
                    $("#serialDesc").val(map.serialDesc);
                    if (nodeState == 0)
                        cmsComp();	//特指农业养殖项目的限制权限
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
        function cmsComp() {
            $("#devId,#baudRate,#parity,#dataBits,#stopBits").attr("disabled", "true");
        }
        function clearComp() {
            $("#devId,#baudRate,#parity,#dataBits,#stopBits").removeAttr("disabled");
        }
        function detail(id) {
            $("#div_detail").show();
            $("#div_save").hide();
            $.ajax({
                type: "post",
                dataType: "json",
                url: "showDetailSerialInfo.action",
                data: "serialId=" + id,
                success: function callBack(data) {
                    var map = data.map;
                    $("#serialId").val(map.serialId);
                    $("#devId1").html(map.devId);
                    $("#commPortId1").html(map.commPortId);
                    $("#baudRate1").html(map.baudRate1);
                    $("#parity1").html(map.parity1);
                    $("#dataBits1").html(map.dataBits1);
                    $("#stopBits1").html(map.stopBits1);
                    $("#isActive_").html(map.isActive1);
                    _active = map.isActive;
                    $("#serialDesc1").html(map.serialDesc);
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
            var devId = $.trim($("#devId").val());
            var commPortId = $.trim($("#commPortId").val());
            if (commPortId == "") {
                save_alert(0, "您还没有输入串口号", "#commPortId");
                $("#commPortId").addClass("inputAlarm");
            }
            else if (devId == "") {
                save_alert(0, "您还没有输入设备ID", "#devId");
                $("#devId").addClass("inputAlarm");
            }
            else if (flag == 0) {
                clearComp();
                jsons_save(form1);
            }
        }
        function save_suc(data) {			//添加or修改成功后的返回函数
            if (nodeState == 0)
                cmsComp();
            var flags = data.flag;
            if (flags == 1) {
                //top.success(1,"操作失败，请重试或联系管理员");
                $("#waiting").hide();
                return false;
            }
            var serialInfo = data.map;
            $("#detail").hide();
            if (serialInfo == null) {
                top.success(0, "添加成功");
                var jumpPage = $("#jumpPage").val();
                var pageSize = $("#pageSize").val();
                jsons(jumpPage, pageSize, url);
            }
            else {
                var serialId = serialInfo.serialId;
                top.success(0, "修改成功");
                var tSort = $("#tr_" + serialId + ">td:eq(0)").html();
                var tCount = $("#tr_" + serialId + ">td:eq(4)").html();
                var tHtml = "<td width=5%>" + tSort + "</td>"
                        + "<td width=8%>" + serialInfo.commPortId + "</td>"
                        + "<td width=18%>" + serialInfo.baudRate + "</td>"
                        + "<td width=10%>" + serialInfo.isActive1 + "</td>"
                        + "<td width=10%>" + tCount + "</td>"
                        + "<td width=18%><a class='aBtn aDetail' href='javascript:' onclick='detail(" + serialId + ");'>详细信息</a>　<a class='aBtn aEdit' href='javascript:' onclick='edit(" + serialId + ");'>编辑</a>";
                $("#tr_" + serialId).html(tHtml);
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
            var querySerialName = $.trim($("#querySerialName").val());
            var queryIsActive = $.trim($("#queryIsActive").val());
            var url_query = "query_serialInfos.action?nodeState=${nodeState}&querySerialName=" + encodeURI(encodeURI(querySerialName))
                    + "&queryIsActive=" + queryIsActive;
            json_query(url_query);
        }
        function del(id) {
            serialId = id;
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
                url: "removeSerialInfo?serialId=" + serialId,
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
                        top.success(1, "删除失败，该从机正在使用使用");
                        $("#detail_bg").hide().css("z-index", "50000");
                        $("#waiting").hide();
                    }
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        }
        function checkDevId() {		//设备ID，整数
            var devId = $("#devId").val();
            if (devId != "" && !isInteger(devId)) {
                save_alert(0, "请输入正确的ID(整数)", "#devId");
                $("#devId").addClass("inputAlarm");
                flag = 1;
            }
            else
                flag = 0;
        }
        function checkCommPort() {		//串口号：COM+zzshu
            var commPort = $.trim($("#commPort").val());
            if (commPort != "" && !isInteger(commPort.substr(4))) {
                save_alert(0, "请输入正确的串口号", "#commPort");
                $("#commPort").addClass("inputAlarm");
                flag = 1;
            }
            else
                flag = 0;
        }
        function regInfos(id) {		//浏览从机对应的参数信息
            serialId = id;
            devc_Page = 1;
            devc_Size = 50;
            json_devc(0);
        }
        function json_devc(type) {
            $("#detail_bg").show();
            $("#waitings").html("获取中，请稍候....");
            $("#waiting").show();
            $.ajax({
                type: "post",
                dataType: "json",
                url: "json_serialRegInfos.action",
                data: "jumpPage=" + devc_Page + "&pageSize=" + devc_Size + "&serialId=" + serialId,
                success: function (data) {
                    var achs = data.rows;
                    var pageBean = data.pageBean;
                    var achContent = "";
                    var ach = "";
                    for (var i in achs) {
                        ach = achs[i];
                        achContent += "<tr>"
                                + "<td align='center' style='width:5%;''></td>"
                                + "<td align='center' style='width:25%;'>" + ach[4] + "</td>"
                                + "<td align='center' style='width:15%;'>" + ach[0] + "</td>"
                                + "<td align='center' style='width:15%;'>" + ach[1] + "</td>"
                                + "<td align='center' style='width:15%;'>" + ach[3] + "</td>"
                                + "<td align='center' style='width:25%;'>" + ach[2] + "</td>"
                                + "</tr>";
                    }
                    $("#divRegInfos [name='vd2']").html(achContent);
                    devc_pages("divRegInfos", pageBean, 0);
                    var jump = $("#divRegInfos [name='devc_Page']").val();
                    var size = $("#divRegInfos [name='devc_Size']").val();
                    var i = 0;
                    $("#divRegInfos [name='vd2'] tr").each(function () {
                        $(this).find("td:eq(0)").html((jump - 1) * size + i + 1);  //给每行的第一列重写赋值
                        i++;
                    });
                    $("#divRegInfos").show();
                    $("#waiting").hide();
                    beCenter("divRegInfos");
                    var vWidth = parseFloat($("#divRegInfos [name='vd2']").width()) + parseFloat("2");
                    $("#divRegInfos [name='vd1']").css("width", vWidth);
                    $("#divRegInfos [name='devc_p']").animate({scrollTop: 0}, 200);
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        }
    </script>
</head>
<body>
<div align="left">
    <table id="vv">
        <thead>
        <tr>
            <th width=5%>序号</th>
            <th width=8%>串口号</th>
            <th width=18%>波特率</th>
            <th width=10%>使用状态</th>
            <th width=10%>对应参数</th>
            <th width=18%>更多操作</th>
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
<%--<div id="Page">
    <c:if test="${nodeState==1}">
        <a class='aBtn aEdit' href='javascript:' onclick='add();'>添 加</a>　
    </c:if>
    <a class='aBtn aEdit' href='javascript:' onclick='query();'>查 询</a>　
    <a class='aBtn aEdit' href='javascript:' onclick='allDatas();'>全 部</a>
    <div id="pages"></div>
</div>--%>
<div id="detail" class="div_alt">
    <s:include value="showDetailSerialInfo.jsp"/>
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
                <li class="queryLeft">串口号名：</li>
                <li><input id="queryCommPortId" Style="width:160px" class="inputText"></li>
                <li class="queryLeft">使用状态：</li>
                <li><s:select id="queryIsActive" list="#{-1:'所有状态',0:'未使用',1:'使用中' }" Style="width:160px"
                              theme="simple"/></li>
            </ul>
        </div>
        <div class="queryBtn">
            <input value="确定" class="btn_1" type="button" flag="done" onclick="query_done();"/>
            　　<input value="取消" class="btn_2" type="button" onclick="closeDiv('query');"/>
        </div>
    </div>
</div>
<div id="divRegInfos" class="div_alt" style="display:none;position:absolute;z-index:50003;border:0;">
    <s:include value="regInfos.jsp"/>
</div>
</body>
</html>