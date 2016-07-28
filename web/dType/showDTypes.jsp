<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>数据词典</title>
    <script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <script type="text/javascript" src="../js/jquery.form.js"></script>
    <link href="../css/style.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript">
        var flagTypeName = true;
        var flagEnName = true;
        var isPho = true;
        var userId;
        var url = "";
        var url1 = "";
        $(function () {
            url = "json_dtypes.action?nodeState=${nodeState}&penName=" + $("#penName").val();
            url1 = url;
        });
        function transUrl(jumpPage, pageSize) {
            var jump = typeof(jumpPage) != "undefined" ? $("#jumpPage").val() : "1";
            var page = typeof(pageSize) != "undefined" ? $("#pageSize").val() : "50";
            jsons(jump, page, url);
        }
        function changes() {
            url = "json_dtypes.action?nodeState=${nodeState}&penName=" + $("#penName").val();
            url1 = url;
            var jumpPage = $("#jumpPage").val();
            var pageSize = $("#pageSize").val();
            transUrl(jumpPage, pageSize);
        }
        function image(url, id) {
            $("#showImage").attr("src", "../dtypes/" + url);
            var top = $("#" + id).offset().top;
            var left = $("#" + id).offset().left;
            $("#imageDiv").css("top", top);
            $("#imageDiv").css("left", left - 55);
            $("#imageDiv").show();
        }
        function imageResetDiv() {
            $("#imageDiv").hide();
        }
        function add() {
            clearDetail();
            $("#title").html("&nbsp;&nbsp;添加类型");
            $("#pName").val($('#penName').find("option:selected").text());
            beCenter("detail");
            $("#detail_bg").show();
            $("#detail").show(300);
        }
        function edit(typeId) {
            clearDetail();
            $.ajax({
                type: "post",
                dataType: "json",
                url: "showDetailType.action",
                data: "typeId=" + typeId,
                success: function callBack(data) {
                    var map = data.map;
                    $("#typeId").val(map.typeId);
                    $("#typeName").val(map.typeName);
                    $("#pName").val(map.pName);
                    document.getElementById("isLeaf" + map.isLeaf).checked = true;
                    $("#enName").val(map.enName);
                    $("#title").html("　编辑类型");
                    reChange("imgEdit", 100, 100);		//调整图片大小
                    beCenter("detail");
                    $("#detail_bg").show();
                    $("#detail").show(300);
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        }
        function queryTypes() {
            $("#save_alert").remove();
            beCenter("query");
            //setQueryText();
            $("#detail_bg").show();
            $("#query").show(300);
        }
        function query_done() {
            var queryWord = $("#queryWord").val();
            var queryEnName = $("#queryEnName").val();
            var queryIsLeaf = $("#queryIsLeaf").val();
            var penName = $("#penName").val();
            var url_query = "query_dtypes.action?nodeState=${nodeState}&queryIsLeaf=" + queryIsLeaf + "&queryWord=" + encodeURI(encodeURI(queryWord)) + "&queryEnName=" + queryEnName + "&penName=" + penName;
            json_query(url_query);
        }
        function save() {
            var typeName = $.trim($("#typeName").val());
            var dType = $("#penName").val();
            if (typeName == "") {
                save_alert(0, "您还没有输入类型名", "#typeName");
                $("#typeName").addClass("inputAlarm");
            }
            else if (!flagTypeName) {
                var Name = $("#penName").find("option:selected").text();
                save_alert(0, "\"" + Name + "\"类型已有\"" + typeName + "\"类型名", "#typeName");
                $("#typeName").addClass("inputAlarm");
            }
            else if (!flagEnName) {
                var Name = $("#penName").find("option:selected").text();
                var enName = $.trim($("#enName").val());
                save_alert(0, "\"" + Name + "\"类型已有\"" + enName + "\"英文简写", "#enName");
                $("#enName").addClass("inputAlarm");
            }
            else {
                $("#detail").hide();
                beCenter("waiting");
                $("#waitings").html("保存中，请稍候....");
                $("#waiting").show();
                /*var options = {
                 url : "addDType.action?penName="+$("#penName").val(),
                 type : "POST",
                 dataType : "json",
                 success :function(data){
                 save_suc(data);
                 },
                 error:function(data){
                 ajaxError(data);
                 }
                 };
                 $("#form1").ajaxSubmit(options);*/
                $("#formPenName").val($("#penName").val());
                jsons_save(form1);
            }
        }
        function save_suc(data) {			//添加or修改成功后的返回函数
            var dtype = data.map;
            $("#detail").hide();
            if (!dtype) {
                //top.success(0,"添加成功");
                var jumpPage = $("#jumpPage").val();
                var pageSize = $("#pageSize").val();
                jsons(jumpPage, pageSize, url);
            }
            else {
                var typeId = dtype.typeId;
                //top.success(0,"修改成功");
                var tSort = $("#tr_" + typeId + ">td:eq(0)").html();
                var tHtml = "<td width=3%>" + tSort + "</td>"
                        + "<td width=15%>" + dtype.depName + "</td>"
                        + "<td width=15%>" + dtype.typeName + "</td>"
                        + "<td width=15%>" + dtype.pName + "</td>"
                        + "<td width=5%>" + dtype.isLeaf + "</td>"
                        + "<td width=7%>" + dtype.enName + "</td>";
                tHtml += "<td width=10%><a class='aBtn aEdit' href='javascript:' onclick='edit(" + typeId + ");'>编辑</a>　<a class='aBtn aDel' href='javascript:' onclick='del(" + typeId + ");'>删除</a></td>";
                $("#tr_" + typeId).html(tHtml);
                $("#waiting").hide();
                $("#detail_bg").hide().css("z-index", "50000");
            }
        }
        function del(id) {
            typeId = id;
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
                url: "removeDType.action?typeId=" + typeId,
                success: function (data) {
                    var flag = data.flag;
                    $("#alert").hide(300);
                    if (flag == 0) {
                        top.success(0, "删除成功");
                        var jumpPage = $("#jumpPage").val();
                        var pageSize = $("#pageSize").val();
                        jsons(jumpPage, pageSize, url);
                    }
                    else {
                        top.success(1, "删除失败");
                        $("#detail_bg").hide().css("z-index", "50000");
                        $("#waiting").hide();
                    }
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        }
        function checkTypeName() {			//验证类型名唯一性
            var penName = $("#penName").val();
            var typeName = $.trim($("#typeName").val());
            var typeId = $("#typeId").val();
            if (typeName != "") {
                $.ajax({
                    type: "post",
                    dataType: "json",
                    url: "checkTypeName.action?penName=" + penName + "&typeName=" + typeName + "&typeId=" + typeId,
                    success: function (data) {
                        var flag = data.flag;
                        if (flag != 0) {
                            var Name = $("#penName").find("option:selected").text();
                            flagTypeName = false;
                            save_alert(0, "\"" + Name + "\"类型已有\"" + typeName + "\"类型名", "#typeName");
                            $("#typeName").addClass("inputAlarm");
                        }
                        else
                            flagTypeName = true;
                    },
                    error: function (data) {
                        ajaxError(data);
                    }
                });
            }
        }
        function checkEnName() {
            var penName = $("#penName").val();
            var enName = $.trim($("#enName").val());
            var typeId = $("#typeId").val();
            if (enName != "") {
                $.ajax({
                    type: "post",
                    dataType: "json",
                    url: "checkEnName.action?penName=" + penName + "&enName=" + enName + "&typeId=" + typeId,
                    success: function (data) {
                        var flag = data.flag;
                        if (flag != 0) {
                            var Name = $("#penName").find("option:selected").text();
                            flagEnName = false;
                            save_alert(0, "\"" + Name + "\"类型已有\"" + enName + "\"英文简写", "#enName");
                            $("#enName").addClass("inputAlarm");
                        }
                        else
                            flagEnName = true;
                    },
                    error: function (data) {
                        ajaxError(data);
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

        ul {
            list-style: none;
            margin-left: -35px;
            _margin-left: 5px;
            margin-right: 5px;
            margin-top: 5px;
        }

        #xsnazzy {
            background: transparent;
            margin-bottom: 1px;
            text-align: left;
            padding: 1px;
        }

        .xtop, .xbottom {
            display: block;
            background: transparent;
            font-size: 1px;
        }

        .xb1, .xb2, .xb3, .xb4 {
            display: block;
            overflow: hidden;
        }

        .xb1, .xb2, .xb3 {
            height: 1px;
        }

        .xb2, .xb3, .xb4 {
            background: #FCFCFC;
            border-left: 1px solid gray;
            border-right: 1px solid gray;
        }

        .xb1 {
            margin: 0 5px;
            background: gray;
        }

        .xb2 {
            margin: 0 3px;
            border-width: 0 2px;
        }

        .xb3 {
            margin: 0 2px;
        }

        .xb4 {
            height: 2px;
            margin: 0 1px;
        }

        .xboxcontent {
            display: block;
            background: #FCFCFC;
            border: 0 solid gray;
            border-width: 0 1px;
            padding: 5px 0
        }
    </style>
</head>
<body>
<div id="xsnazzy">
    <b class="xtop"><b class="xb1"></b><b class="xb2"></b><b class="xb3"></b><b class="xb4"></b></b>
    <div class="xboxcontent">
        　　数据类型： <s:select name="penName" id="penName" listKey="enName" listValue="typeName" list="%{dTypes}"
                          Style="min-width:120px;height:25px;border:1px solid #A0522D" align="center"/>
        　<input id="button1" class="btn_1" type="button" onclick="changes();" value="打开"/>
    </div>
    <b class="xbottom"><b class="xb4"></b><b class="xb3"></b><b class="xb2"></b><b class="xb1"></b></b>
</div>
<div align="left">
    <table id="vv">
        <thead>
        <tr>
            <th width=3%>序号</th>
            <th width=15%>所属单位</th>
            <th width=15%>类型名</th>
            <th width=15%>父类名</th>
            <th width=5%>是否叶子</th>
            <th width=7%>英文简写</th>
            <th width=10%>编辑</th>
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
    <a class='aBtn aEdit' href='javascript:' onclick='queryTypes();'>查 询</a>　
    <a class='aBtn aEdit' href='javascript:' onclick='allDatas();'>全 部</a>
    <div id="pages"></div>
</div>
<div id="detail" class="div_alt">
    <s:include value="showDetailType.jsp"/>
</div>
<div id="alert" class="div_alt">
    <s:include value="../main/alert.jsp"/>
</div>
<div id="waiting"><span id="waitings"></span></div>
<div id="detail_bg"></div>
<div style="width:0px;position:absolute;display:none" id="imageDiv">
    <img id="showImage" style="width:150px;" src="">
</div>
<div id="query" class="div_alt">
    <div class="queryBody">
        <div class="detail_title" onmousedown="mouseDownFun('query')"><span class="detail_header">　查询</span><span
                class="detail_close" onclick="closeDiv('query')" title="关闭">X</span></div>
        <div class="queryContent">
            <ul>
                <li><span class="queryLeft">　类型名：</span><input id="queryWord" Style="width:160px" class="inputText">
                </li>
                <li><span class="queryLeft">是否叶子：</span><s:select id="queryIsLeaf" name="queryIsLeaf"
                                                                  list="#{0:'否',1:'是'}" headerKey="-1"
                                                                  headerValue="请选择是否叶子" Style="width:160px"
                                                                  theme="simple"></s:select></li>
                <li><span class="queryLeft">  enName：</span><input id="queryEnName" Style="width:160px"
                                                                   class="inputText"></li>
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