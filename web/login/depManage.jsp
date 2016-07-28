<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix='fmt' uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>单位管理</title>
    <script type="text/javascript" src="../js/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <link href="../org/style.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript">
        /* window.onload=function(){
         var pHeight=parent.document.body.clientHeight*0.8;
         $(".h1").height(pHeight-5+"px");
         }; */
        var lens = ["3%", "3%", "20%", "20%", "8%", "15%", "8%", "8%"];
        var url = "json_depManage.action";
        $(function () {
            jsons(1, 50, url, lens);		//默认为第一页，每页50条数据
        });
        function cancleView(regId) {		//取消监测
            $("#detail_bg").show();
            beCenter("waiting");
            $("#waitings").html("取消中，请稍候....");
            $("#waiting").show();
            $.ajax({
                type: "post",
                dataType: "json",
                url: "cancleView?id=" + regId,
                success: function (data) {
                    var flag = data.flag;
                    if (flag == 0) {
                        $("#" + regId + "_00").html("未监测");
                        $("#" + regId + "_01").html("<a href='javascript:' onclick='view(" + regId + ")'>开始监测</a>");
                    }
                    $("#detail_bg").hide();
                    $("#waiting").hide();
                }
            });
        }
        function view(regId) {			//开始监测
            $("#detail_bg").show();
            beCenter("waiting");
            $("#waitings").html("启动中，请稍候....");
            $("#waiting").show();
            $.ajax({
                type: "post",
                dataType: "json",
                url: "view?id=" + regId,
                success: function (data) {
                    var flag = data.flag;
                    if (flag == 0) {
                        $("#" + regId + "_00").html("正在监测");
                        $("#" + regId + "_01").html("<a href='javascript:' onclick='cancleView(" + regId + ")'>取消监测</a>");
                    }
                    $("#detail_bg").hide();
                    $("#waiting").hide();
                }
            });
        }
        function viewAll() {				//监测全部单位
            $("#detail_bg").show();
            beCenter("waiting");
            $("#waitings").html("启动中，请稍候....");
            $("#waiting").show();
            $.ajax({
                type: "post",
                dataType: "json",
                url: "viewAll",
                success: function (data) {
                    var flag = data.flag;
                    if (flag == 0) {
                        location.reload();
                    }
                }
            });
        }
        function checkAll(checkbox) {
            var checkboxs = document.getElementsByName("regIds");
            for (var i = 0; i < checkboxs.length; i++) {
                checkboxs[i].checked = checkbox.checked;
            }
        }
        function viewDeps() {			//监测勾选的单位
            var regIds = "";
            $("input[name='regIds']:checkbox:checked").each(function () {
                regIds += $(this).val() + ",";
            });
            if ($.trim(regIds) != "") {
                regIds = regIds.substring(0, regIds.length - 1);
                $("#detail_bg").show();
                beCenter("waiting");
                $("#waitings").html("启动中，请稍候....");
                $("#waiting").show();
                $.ajax({
                    type: "post",
                    dataType: "json",
                    url: "viewDeps?regIds=" + regIds,
                    success: function (data) {
                        var flag = data.flag;
                        if (flag == 0) {
                            location.reload();
                        }
                    }
                });
            }
        }
        function cancleViewDeps() {		//取消监测勾选的单位
            var regIds = "";
            $("input[name='regIds']:checkbox:checked").each(function () {
                regIds += $(this).val() + ",";
            });
            if ($.trim(regIds) != "") {
                regIds = regIds.substring(0, regIds.length - 1);
                $("#detail_bg").show();
                beCenter("waiting");
                $("#waitings").html("取消中，请稍候....");
                $("#waiting").show();
                $.ajax({
                    type: "post",
                    dataType: "json",
                    url: "cancleViewDeps?regIds=" + regIds,
                    success: function (data) {
                        var flag = data.flag;
                        if (flag == 0) {
                            location.reload();
                        }
                    }
                });
            }
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

        .style1 {
            font-size: 14px;
            font-weight: bold
        }
    </style>
</head>
<body>
<div align="left">
    <table id="vv">
        <thead>
        <tr>
            <th width=3%>序号</th>
            <th width=3%><input type="checkbox" onclick="check(id,this)" id="regIds" name=""/></th>
            <th width=20%>单位名</th>
            <th width=20%>父单位</th>
            <th width=8%>单位类型</th>
            <th width=15%>单位地址</th>
            <th width=8%>监测状态</th>
            <th width=8%>更多</th>
        </tr>
        </thead>
    </table>
</div>
<div class="h1">
    <s:form name="formD" method="post" theme="simple">
        <table id="v">
            <tbody id="bbsTab">
            </tbody>
        </table>
    </s:form>
</div>
<div id="Page">
    <a href="javascript:" onclick="viewDeps()">监测单位</a>
    　<a href="javascript:" onclick="cancleViewDeps()">取消监测</a>
    <div id="pages"></div>
</div>
<div id="detail_bg"></div>
<div id="alert" class="div_alt">
    <s:include value="../main/alert.jsp"/>
</div>
<div id="waiting">
    <p style="margin-top:15px"><img src="../img/tree_loading.gif" border="none"><span id="waitings"></span></p>
</div>
</html>
