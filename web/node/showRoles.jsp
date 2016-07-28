<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE HTML>
<html>
<head>
    <title>角色管理</title>
    <script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
    <link type="text/css" rel="stylesheet" href="../js/zTree/zTreeStyle/zTreeStyle.css">
    <script type="text/javascript" src="../js/zTree/jquery.ztree.core-3.5.js"></script>
    <script type="text/javascript" src="../js/zTree/jquery.ztree.excheck-3.5.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <link href="../css/style.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript">
        var flag = 0;
        var actorId;
        var url = "json_roles.action?nodeState=${nodeState}";
        var url1 = url;
        var nodeIdss;
        var nodeState = 1;
        $(function () {
            jsons(1, 50, url);		//默认为第一页，每页50条数据
        });
        function add() {
            flag = 0;
            clearDetail();
            $("#actorId").val("");
            beCenter("detail");
            $("#detail_bg").show();
            $("#detail").show(300);
        }
        function edit(id) {
            flag = 0;
            clearDetail();
            $.ajax({
                type: "post",
                dataType: "json",
                url: "showDetailRole.action",
                data: "actorId=" + id,
                success: function callBack(data) {
                    var map = data.map;
                    $("#actorId").val(map.id);
                    $("#actorName").val(map.actorName);
                    $("#actorDesc").val(map.actorDesc);
                    $("#actorName_").hide();
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
            var actorName = $.trim($("#actorName").val());
            if (actorName == "") {
                save_alert(0, "您还没有输入角色名", "#actorName");
                $("#actorName").addClass("inputAlarm");
            }
            else if (flag == 0)
                jsons_save(form1);
        }
        function save_suc(data) {
            var actorId = data.actorId;
            var role = data.map;
            $("#detail").hide();
            if (!actorId) {
                top.success(0, "添加成功");
                var jumpPage = $("#jumpPage").val();
                var pageSize = $("#pageSize").val();
                jsons(jumpPage, pageSize, url);
            }
            else {
                top.success(0, "修改成功");
                var tSort = $("#tr_" + actorId + ">td:eq(0)").html();
                var tHtml = "<td width=5%>" + tSort + "</td>"
                        + "<td width=15%>" + role.actorName + "</td>"
                        + "<td width=10%>" + role.actorType + "</td>"
                        + "<td width=40%>" + role.actorDesc + "</td>"
                        + "<td width=30%><a class='aBtn aEdit' href='javascript:' onclick='detailUsers(" + actorId + ",\"" + role.actorName + "\");'>人员浏览</a>"
                        + "　<a class='aBtn aEdit' href='javascript:' onclick='detailNodes(" + actorId + ",\"" + role.actorName + "\");'>角色节点浏览</a>"
                        + "　<a class='aBtn aEdit' href='javascript:' onclick='edit(" + actorId + ");'>编辑</a>"
                        + "　<a class='aBtn aDel' href='javascript:' onclick='del(" + actorId + ");'>删除</a></td>";
                $("#tr_" + actorId).html(tHtml);
                $("#waiting").hide();
                $("#detail_bg").hide().css("z-index", "50000");
            }
        }
        function del(id) {
            actorId = id;
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
                url: "removeRole.action?actorId=" + actorId,
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
        function query() {
            $("#detail").hide();
            $("#Users").hide();
            $("#Nodes").hide();
            beCenter("query");
            $("#detail_bg").show();
            $("#query").show(300);
        }
        function query_done() {
            var queryWord = $.trim($("#queryWord").val());
            var url_query = "query_roles.action?nodeState=${nodeState}&queryWord=" + encodeURI(encodeURI(queryWord));
            json_query(url_query);
        }
        function detailUsers(id, actorName) {
            $("#actorId").val(id);
            $("#typeName").val(actorName);
            $("#query").hide();
            $("#detail").hide();
            $("#Nodes").hide();
            $("#showUsers").html("");
            $.ajax({
                type: "post",
                dataType: "json",
                url: "detailUsers.action",
                data: "actorId=" + id,
                success: function callBack(data) {
                    if (!data.rows) {		//该角色暂未绑定人员
                        $("#showUsers").append("<tr>"
                                + "<td style='line-height:300px' class='devClass'>暂未绑定人员</td>"
                                + "</tr>");
                        $("#showUsers").attr("align", "center");
                        return false;
                    }
                    var rows1, userTypeName, userName;
                    for (var i = 0; i < data.rows.length; i++) {
                        rows1 = data.rows[i];
                        userTypeName = rows1[0].userTypeName;
                        userName = "";
                        for (var j = 0; j < rows1.length; j++) {
                            userName += rows1[j].userName + "，";
                        }
                        userName = userName.substring(0, userName.length - 1);
                        $("#showUsers").append("<tr valign='top'>"
                                + "<td width='100' align='right'><font style='font-weight:bold;color:blue'>" + userTypeName + "：</font></td>"
                                + "<td style='padding-bottom:20px;text-align:left;'>" + userName + "</td>"
                                + "</tr>");
                        $("#showUsers").attr("align", "left");
                    }
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
            $("#formTypeName").html("　角色相关人员-" + actorName);
            $("#sUsers").show();
            $("#bUsers").hide();
            beCenter("Users");
            $("#detail_bg").show();
            $("#Users").show(300);
        }
        function editUsers() {
            $("#bindUsers").html("");
            $("#unbindUsers").html("");
            var id = $("#actorId").val();
            var typeName = $("#typeName").val();
            $.ajax({
                type: "post",
                dataType: "json",
                url: "ggetRoleUsers.action",
                data: "actorId=" + id + "&depId=" + request("depId"),
                success: function callBack(data) {
                    for (var i = 0; i < data.rows.length; i++) {
                        $("#unbindUsers").append("<li id='" + data.rows[i].id + "-' onclick='unBind(id)' onmouseover='liOver(this)' onmouseout='liOut(this)'>　" + data.rows[i].userName + "</li>");
                    }
                    for (var i = 0; i < data.rows1.length; i++) {
                        $("#bindUsers").append("<li id='" + data.rows1[i].id + "-' onclick='Bind(id)' onmouseover='liOver(this)' onmouseout='liOut(this)'>　" + data.rows1[i].userName + "</li>");
                    }
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
            $("#typeId").val(id);
            $("#formTypeName").html("　绑定用户-" + typeName);
            $("#sUsers").hide();
            $("#bUsers").show();
            beCenter("Users");
            $("#detail_bg").show();
            $("#Users").show(300);
        }
        function backUsers() {
            var typeName = $("#typeName").val();
            $("#formTypeName").html("　角色相关人员-" + typeName);
            $("#sUsers").show();
            $("#bUsers").hide();
        }
        function Bind(id) {		//绑定人员
            $("#unbindUsers").append("<li id='" + id + "0' onclick='unBind(id)' onmouseover='liOver(this)' onmouseout='liOut(this)'>" + $("#" + id).html() + "</li>");
            $("#" + id).remove();
        }
        function unBind(id) {	//解绑人员
            $("#bindUsers").append("<li id='" + id + "1' onclick='Bind(id)' onmouseover='liOver(this)' onmouseout='liOut(this)'>" + $("#" + id).html() + "</li>");
            $("#" + id).remove();
        }
        function saveUsers() {
            if ($("#bUsers").css("display") != "none") {
                var userIds = "";
                $("#unbindUsers li").each(function () {
                    userIds += $(this).attr("id").split("-")[0] + ",";
                });
                $("#Users").hide();
                $("#detail_bg").show();
                beCenter("waiting");
                $("#waitings").html("保存中，请稍候....");
                $("#waiting").show();
                $.ajax({
                    url: "bindRoleUsers.action?userIds=" + userIds + "&actorId=" + $("#actorId").val() + "&depId=" + request("depId"),
                    type: "post",
                    success: function (data) {
                        var flag = data.flag;
                        if (flag == 0)
                            top.success(0, "操作成功");
                        else
                            top.success(1, "出现异常");
                        $("#waiting").hide();
                        $("#detail_bg").hide();
                        top.iframeMain.fTop.location.reload();			//刷新顶部的菜单
                    },
                    error: function (data) {
                        ajaxError(data);
                    }
                });
            }
        }
        function detailNodes(id, actorName) {
            $("#detail_bg").show();
            beCenter("waiting");
            $("#waitings").html("获取中，请稍候....");
            $("#waiting").show();
            $("#showNodes").html("<ul id='nodesPriv' style='width:120px;float:left;text-align:right;margin-left:0px;'></ul><ul id='treeDemo' class='ztree' style='float:left'></ul>");
            $("#actorId").val(id);
            $("#actorName").val(actorName);
            $("#formActorName").html("　角色模块维护 - " + actorName);
            $.ajax({
                type: "post",
                dataType: "json",
                url: "detailNodes.action",
                data: "actorId=" + id,
                success: function callBack(data) {
                    var zNodes = data.rows;
                    var setting = {
                        check: {
                            enable: true
                        },
                        data: {
                            simpleData: {
                                enable: true
                            },
                            key: {
                                title: "title"
                            }
                        },
                        view: {
                            showTitle: true,
                            fontCss: setFontCss
                        },
                        callback: {
                            /* onClick: zTreeOnClick, */
                            onCheck: zTreeOnCheck,
                            beforeCollapse: beforeCollapse
                        }
                    };
                    $.fn.zTree.init($("#treeDemo"), setting, zNodes);
                    var prNodes = data.prNodes.split(",");
                    var htmlPriv = "";
                    nodeIdss = "";//alert(prNodes);
                    for (var i in prNodes) {
                        htmlPriv += "<li>"
                                + "<input type='radio' name='Priv" + prNodes[i] + "_0' id='Priv" + prNodes[i] + "_1' value='1' onclick='checkRadio(id)'><label for='Priv" + prNodes[i] + "_1'>管理</label>"
                                + "  <input type='radio' name='Priv" + prNodes[i] + "_0' id='Priv" + prNodes[i] + "_0' value='0' onclick='checkRadio(id)'><label for='Priv" + prNodes[i] + "_0'>浏览</label>"
                                + "</li>";
                        nodeIdss += prNodes[i] + ",";
                    }//alert(htmlPriv);
                    $("#nodesPriv").html(htmlPriv);
                    var rows1 = data.rows1;
                    if (rows1 != null && rows1.length > 0) {
                        for (var i in rows1) {
                            $("#Priv" + rows1[i].nodeId + "_" + rows1[i].nodeState).attr("checked", "checked");
                        }
                    }
                    $("#waiting").hide();
                    $("#Nodes").show();
                    setDetail("Nodes");
                    beCenter("Nodes");
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        }
        function zTreeOnClick(event, treeId, treeNode) {		//点击的回调事件
            var zTree = $.fn.zTree.getZTreeObj("treeDemo");
            zTree.expandNode(treeNode);
        }
        function beforeCollapse(treeId, treeNode) {
            return false;
        }
        function setFontCss(treeId, treeNode) {
            return {"font-weight": treeNode.fontweight, "font-family": "arial,微软雅黑,宋体,sans-serif"};
        }
        function zTreeOnCheck(event, treeId, treeNode) {
            //alert(treeId+":::"+treeNode.id+":::"+event);
            if (!treeNode.children || treeNode.children.length == 0) { //末端节点
                if (treeNode.checked) { //选中末端节点的radio
                    //alert("moduan|"+treeNode.id);
                    if (nodeState != 3)
                        document.getElementById("Priv" + treeNode.id + "_" + nodeState).checked = true;
                    else
                        document.getElementById("Priv" + treeNode.id + "_1").checked = true;
                    nodeState = 3;
                    if (treeNode.getParentNode() && treeNode.getParentNode().checked) { //选中父节点的radio
                        document.getElementById("Priv" + treeNode.getParentNode().id + "_1").checked = true;
                    }
                    if (treeNode.getParentNode().getParentNode() && treeNode.getParentNode().getParentNode().checked) { //选中父节点的radio
                        document.getElementById("Priv" + treeNode.getParentNode().getParentNode().id + "_1").checked = true;
                    }
                } else {
                    $("#showNodes input:radio[name='Priv" + treeNode.id + "_0']").attr("checked", false);
                    if (treeNode.getParentNode() && !treeNode.getParentNode().checked)
                        $("#showNodes input:radio[name='Priv" + treeNode.getParentNode().id + "_0']").attr("checked", false);
                    if (treeNode.getParentNode().getParentNode() && !treeNode.getParentNode().getParentNode().checked)
                        $("#showNodes input:radio[name='Priv" + treeNode.getParentNode().getParentNode().id + "_0']").attr("checked", false);
                }
            } else { //父节点
                //alert("fujiedian|"+treeNode.id);
                var ids = [];
                ids = getChildren(ids, treeNode);
                for (var i in ids) {
                    //alert(i+":"+ids[i]+":"+nodeState);
                    if (treeNode.checked) { //权限子节点的radio
                        if (nodeState != 3)
                            document.getElementById("Priv" + ids[i] + "_" + nodeState).checked = true;
                        else
                            document.getElementById("Priv" + ids[i] + "_1").checked = true;
                    } else
                        $("#showNodes input:radio[name='Priv" + ids[i] + "_0']").attr("checked", false);
                }
                if (!treeNode.checked) {
                    if (treeNode.getParentNode() && !treeNode.getParentNode().checked)
                        $("#showNodes input:radio[name='Priv" + treeNode.getParentNode().id + "_0']")
                                .attr("checked", false);
                } else {
                    if (nodeState != 3)
                        document.getElementById("Priv" + treeNode.id + "_" + nodeState).checked = true;
                    else
                        document.getElementById("Priv" + treeNode.id + "_1").checked = true;
                    nodeState = 3;
                    if (treeNode.getParentNode() && treeNode.getParentNode().checked) { //选中父节点的radio
                        document.getElementById("Priv" + treeNode.getParentNode().id + "_1").checked = true;
                    }
                }
                nodeState = 3;
            }
        }
        function getChildren(ids, treeNode) {			//获取所有的子节点
            ids.push(treeNode.id);
            if (treeNode.isParent) {
                for (var obj in treeNode.children) {
                    getChildren(ids, treeNode.children[obj]);
                }
            }
            return ids;
        }
        function checkRadio(id) {		//检查radio对应的checkbox是否选中，否则取消选中该radio
            var nId = id.split("_")[0].replace("Priv", "");
            var zTree = $.fn.zTree.getZTreeObj("treeDemo");
            var node = zTree.getNodeByParam("id", nId, null);
            if (!node.checked) {
                nodeState = id.split("_")[1];
                zTree.checkNode(node, true, true, true);	//等同于选中该模块
            }
        }
        function saveNodes() {
            var nodeIds = "";
            var zTree = $.fn.zTree.getZTreeObj("treeDemo");
            var checked = zTree.getCheckedNodes(true);	//所有已经选中的对象
            var checkCount = checked.length;
            for (var i = 0; i < checkCount; i++) {
                nodeIds += checked[i].id + ",";			//获取的是值
            }
            var Ids = nodeIdss.split(",");
            var value;
            var nodeStates = "";
            for (var i in Ids) {
                value = $("input:radio[name='Priv" + Ids[i] + "_0']:checked").val();
                if (value)
                    nodeStates += value + ",";
            }
            $("#Nodes").hide();
            $("#detail_bg").show();
            beCenter("waiting");
            $("#waitings").html("保存中，请稍候....");
            $("#waiting").show();
            $.ajax({
                url: "bindRoleNodes.action?nodeIds=" + nodeIds + "&nodeStates=" + nodeStates + "&actorId=" + $("#actorId").val() + "&depId=" + request("depId"),
                type: "post",
                success: function (data) {
                    var flag = data.flag;
                    if (flag == 0)
                        top.success(0, "操作成功");
                    else
                        top.success(1, "出现异常");
                    $("#waiting").hide();
                    $("#detail_bg").hide();
                    top.iframeMain.fTop.location.reload();			//刷新顶部的菜单
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        }
        function checkActor() {
            var actorName = $.trim($("#actorName").val());
            var actorId = $("#actorId").val();
            var depId = request("depId");
            if (actorName != "") {
                $.ajax({
                    type: "post",
                    dataType: "json",
                    url: "checkActor.action",
                    data: "actorId=" + actorId + "&actorName=" + actorName + "&depId=" + depId,
                    success: function (data) {
                        flag = data.flag;
                        if (flag == 1) {
                            $("#actorName_").css("display", "inline");
                            $("#actorName").addClass("inputAlarm");
                        }
                        else {
                            $("#actorName_").hide();
                            $("#actorName").removeClass("inputAlarm");
                        }
                    },
                    error: function (data) {
                        ajaxError(data);
                    }
                });
            }
        }
        function liOver(td) {
            $(td).css({"background-color": "yellow"});
        }
        function liOut(td) {
            $(td).css({"background-color": "#81f4eb"});
        }
        $(window).resize(function () {
            try {
                if ($("#Nodes").css("display") != "none") {
                    setDetail("Nodes");
                    beCenter("Nodes");
                }
            } catch (e) {
            }

        });
    </script>
    <style type="text/css">
        #nodesPriv {
            list-style: none;
            margin-left: -35px;
            _margin-left: 5px;
            *margin-left: 5px;
            margin-right: 5px;
            margin-top: 5px;
            font-size: 12px;
            font-weight: bold
        }

        #nodesPriv li {
            height: 18px;
        }

        .dsds {
            margin-left: 20px;
        }
    </style>
</head>
<body>
<div align="left">
    <table id="vv">
        <thead>
        <tr>
            <th width=10%>序号</th>
            <th width=20%>角色名</th>
            <th width=30%>角色描述</th>
            <th width=40%>操作</th>
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
        <a class='aBtn aEdit' href='javascript:' onclick='add();'>添加</a>　
    </c:if>
    <a class='aBtn aEdit' href='javascript:' onclick='query();'>查询</a>　
    <a class='aBtn aEdit' href='javascript:' onclick='allDatas();'>全部</a>
    <div id="pages"></div>
</div>
<div id="detail" class="div_alt">
    <s:include value="showDetailRole.jsp"/>
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
                <li><span class="queryLeft">　角色名：</span><input id="queryWord" Style="width:160px" class="inputText">
                </li>
            </ul>
        </div>
        <div class="queryBtn">
            <input value="确定" class="btn_1" type="button" flag="done" onclick="query_done();"/>
            　　<input value="取消" class="btn_2" type="button" onclick="closeDiv('query');"/>
        </div>
    </div>
</div>
<div id="Users" class="div_alt">
    <s:include value="bindActorUsers.jsp"/>
</div>
<div id="Nodes" class="div_alt">
    <s:include value="bindActorNodes.jsp"/>
</div>
</body>
</html>