<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE HTML>
<html>
<head>
    <title>菜单管理</title>
    <script type="text/javascript" src="../js/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../js/zTree/jquery.ztree.core-3.5.js"></script>
    <script type="text/javascript" src="../js/zTree/jquery.ztree.excheck-3.5.js"></script>
    <script type="text/javascript" src="../js/zTree/jquery.ztree.exedit-3.5.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <link type="text/css" rel="stylesheet" href="../js/zTree/zTreeStyle/zTreeStyle.css">
    <link type="text/css" rel="stylesheet" href="../css/style.css"/>
    <script type="text/javascript">
        var nodeId;
        var flag = 0;
        var curDragNodes, autoExpandNode;
        var tNode;		//选择的节点
        var zTree;		//整棵树
        $(function () {
            initNode();
            iCheckInit1();
        });
        function iCheckInit1() {
            var radioId;
            var isCheck;
            var htmlLabel,
                    htmlICheck;
            $("input:radio").each(function () {
                radioId = $(this).attr("id");
                if (radioId.indexOf("iCheck_") > -1) {  //特指iCheck样式
                    htmlLabel = $(this).next("label");
                    $(htmlLabel).attr("flagInput", "iCheck");
                    $(this).attr("flagInput", "iCheck");
                    isCheck = this.checked;
                    htmlICheck = "<span class='spanPara'>" +
                            "<div class='iradio_green " + (isCheck ? "checked" : "") + "'>" +
                            "</div>" +
                            "</span>";
                    $(this).before(htmlICheck);
                    $(this).prev("span").append($(htmlLabel));
                    $(this).prev("span").children("div").append($(this));
                }
            });
            ;
            ;
            ;
            ;
            ;
            ;
            ;
            iCheckInit();
        }
        function initNode() {		//初始化
            $.ajax({
                type: "post", top
                dataType
        :
            "json",
                    url
        :
            "json_nodes.action?nodeState=${nodeState}",
                    success
        :
            function callBack(data) {
                var zNodes = data.rows;
                var setting = {
                    view: {
                        addHoverDom: addHoverDom,
                        removeHoverDom: removeHoverDom,
                        selectedMulti: false
                    },
                    edit: {
                        drag: {
                            autoExpandTrigger: true,
                            prev: dropPrev,
                            inner: dropInner,
                            next: dropNext
                        },
                        enable: true,
                        editNameSelectAll: true,
                        showRemoveBtn: showRemoveBtn,
                        showRenameBtn: showRenameBtn
                    },
                    data: {
                        simpleData: {
                            enable: true
                        },
                        key: {
                            title: "title"
                        }
                    },
                    callback: {
                        beforeEditName: beforeEditName,
                        beforeRemove: beforeRemove,
                        beforeRename: beforeRename,
                        onRemove: onRemove,
                        onRename: onRename,
                        beforeClick: beforeClick,
                        beforeDrag: beforeDrag,
                        beforeDrop: beforeDrop,
                        beforeDragOpen: beforeDragOpen,
                        onDrag: onDrag,
                        onDrop: onDrop,
                        onExpand: onExpand
                    }
                };
                $.fn.zTree.init($("#treeDemo"), setting, zNodes);
                $("#treeDetail .vu").find("tr td:odd").addClass("cBlue cRight bold");
                $("#treeDetail .vu").find("tr td:even").addClass("bb cLeft");
                zTree = $.fn.zTree.getZTreeObj("treeDemo");
                tNode = zTree.getNodes()[0];		//展开树后默认显示根节点的信息
                zTree.selectNode(tNode);
                showDetail();
            }

        ,
            error:function (data) {
                ajaxError(data);
            }
        })
        }
        ;
        ;
        ;
        ;
        ;
        ;
        ;
        ;
        ;
        ;
        ;
        ;
        ;
        ;
        ;
        ;
        ;
        ;
        ;
        ;
        ;
        ;
        ;
        ;
        function refreshTree() {		//刷新整棵树
            initNode();
        }
        function beforeClick(treeId, treeNode, clickFlag) {
            tNode = treeNode;
            showDetail();
            return (treeNode.click != false);
        }
        function beforeEditName(treeId, treeNode) {
            tNode = treeNode;
            edit();
            //editRegInfo();
            return false;		//编辑时在树的右侧直接编辑，不再调用zTree原本的方法
            zTree.selectNode(treeNode);
            //return confirm("进入节点 -- " + treeNode.name + " 的编辑状态吗？");
        }
        function beforeRemove(treeId, treeNode) {
            tNode = treeNode;
            zTree.selectNode(tNode);	//选中该节点
            removeNode();
            return false;		//删除时浮出自定义的窗口，不再调用zTree原本的方法
            zTree.selectNode(treeNode);
            return confirm("确认删除 节点 -- " + treeNode.name + " 吗？");
        }
        function onRemove(e, treeId, treeNode) {
        }
        function beforeRename(treeId, treeNode, newName, isCancel) {
            if (newName.length == 0) {
                alert("节点名称不能为空.");
                setTimeout(function () {
                    zTree.editName(treeNode);
                }, 10);
                return false;
            }
            return true;
        }
        function onRename(e, treeId, treeNode, isCancel) {
        }
        function showRemoveBtn(treeId, treeNode) {		//删除，默认true
            //return !treeNode.isFirstNode;
            return typeof(treeNode.isRemove) != "undefined" ? treeNode.isRemove : true;
        }
        function showRenameBtn(treeId, treeNode) {		//编辑，默认true
            //return !treeNode.isLastNode;
            return typeof(treeNode.isRename) != "undefined" ? treeNode.isRename : true;
        }

        function addHoverDom(treeId, treeNode) {		//添加，默认true
            var isAdd = treeNode.isAdd;
            if (typeof(isAdd) != "undefined" && !isAdd)
                return false;
            var sObj = $("#" + treeNode.tId + "_span");
            if (treeNode.editNameFlag || $("#addBtn_" + treeNode.tId).length > 0) return;
            var addStr = "<span class='button add' id='addBtn_" + treeNode.tId
                    + "' title='add node' onfocus='this.blur();'></span>";
            sObj.after(addStr);
            var btn = $("#addBtn_" + treeNode.tId);
            if (btn) btn.bind("click", function () {
                $("#pId").val(treeNode.id);				//添加的父节点id
                //$("#regLevel").val(treeNode.level+2);	//添加的节点结构级别
                tNode = treeNode;
                addNode();		//展开添加的弹出窗,确定后插入数据库并在zTree中同步
                //var zTree = $.fn.zTree.getZTreeObj("treeDemo");
                //zTree.addNodes(treeNode, {id:(100 + newCount), pId:treeNode.id, name:"new node" + (newCount++)});
                return false;
            });
        }
        function removeHoverDom(treeId, treeNode) {
            $("#addBtn_" + treeNode.tId).unbind().remove();
        }
        function selectAll() {
            zTree.setting.edit.editNameSelectAll = $("#selectAll").attr("checked");
        }
        function dropPrev(treeId, nodes, targetNode) {	//拖拽至节点前面
            var dragLimit = $("#dragLimit").val();
            if (dragLimit == -1)			//禁止拖拽
                return false;
            if (dragLimit == 0)			//无限制
                return true;
            else if (dragLimit == 1) {		//同目录
                if (targetNode.getParentNode().id != nodes[0].getParentNode().id)
                    return false;
            }
            else if (dragLimit == 2) {		//同级别
                var pNode = targetNode.getParentNode();
                if (pNode.level - targetNode.level != "-1" || targetNode.level != nodes[0].level)
                    return false;
            }
            return true;
        }
        function dropInner(treeId, nodes, targetNode) {	//拖拽至节点内部，成为子节点
            var dragLimit = $("#dragLimit").val();
            if (dragLimit == -1)			//禁止拖拽
                return false;
            if (dragLimit == 0)			//无限制
                return true;
            else if (dragLimit == 1) {		//同目录
                if (targetNode.getParentNode().id != nodes[0].getParentNode().id)
                    return false;
            }
            else if (dragLimit == 2) {		//同级别
                //$("#spanTest").html(nodes[0].level+"|"+targetNode.level);
                if (nodes[0].level - targetNode.level != "1")
                    return false;
            }
            return true;
        }
        function dropNext(treeId, nodes, targetNode) {	//拖拽至节点后面
            var dragLimit = $("#dragLimit").val();
            if (dragLimit == -1)			//禁止拖拽
                return false;
            if (dragLimit == 0)			//无限制
                return true;
            else if (dragLimit == 1) {		//同目录
                if (targetNode.getParentNode().id != nodes[0].getParentNode().id)
                    return false;
            }
            else if (dragLimit == 2) {		//同级别
                var pNode = targetNode.getParentNode();
                if (pNode.level - targetNode.level != "-1" || targetNode.level != nodes[0].level)
                    return false;
            }
            return true;
        }
        /****拖拽原则：只能拖拽同级的节点****/
        function beforeDrag(treeId, treeNode) {
            for (var i = 0, l = treeNode.length; i < l; i++) {
                if (treeNode[i].drag === false) {
                    curDragNodes = null;
                    return false;
                } else if (treeNode[i].parentTId && treeNode[i].getParentNode().childDrag === false) {
                    curDragNodes = null;
                    return false;
                }
            }
            curDragNodes = treeNode;
            return true;
        }
        function beforeDragOpen(treeId, treeNode) {
            autoExpandNode = treeNode;
            return true;
        }
        function beforeDrop(treeId, treeNode, targetNode, moveType, isCopy) {
            return true;
        }
        function onDrag(event, treeId, treeNode) {
        }
        function onDrop(event, treeId, treeNode, targetNode, moveType, isCopy) {	//拖拽的最后结果
            if (moveType == null)		//指未拖拽
                return false;
            var nodeId = treeNode[0].id;		//拖拽节点的id
            var tIndex = zTree.getNodeIndex(treeNode[0]);	//拖拽后的序号
            var pId;				//拖拽后父节点的id
            if (moveType != "inner")
                pId = targetNode.getParentNode().id;
            else
                pId = targetNode.id;
            $.ajax({
                type: "post",
                dataType: "json",
                url: "sortNode.action?nodeId=" + nodeId + "&tIndex=" + tIndex + "&pId=" + pId,
                success: function (data) {
                    var flag = data.flag;
                    if (flag == 0) {
                        //top.success(0,"排序成功");
                        //zTree.removeNode(zTree.getSelectedNodes()[0]);
                    }
                    else if (flag == 1) {
                        //top.success(1,"排序失败,请重试或联系管理员！");
                    }
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        }
        function onExpand(event, treeId, treeNode) {
            if (treeNode === autoExpandNode) {
            }
        }
        function setTrigger() {
            zTree.setting.edit.drag.autoExpandTrigger = $("#callbackTrigger").attr("checked");
        }
        function showDetail() {		//在页面右侧显示所选节点的详细信息
            $("#nodeShow").show();
            $("#nodeEdit").hide();
            $("#nodeName2").html(tNode.name);
            $("#pName").html(tNode.pName);
            $("#nodeUrl").html(tNode.url);
            $("#nodeTitle").html(tNode.title);
            $("#nodeDesc").html(tNode.nodeDesc);
            $("#nodeType").html(tNode.nodeType1);
        }
        function addNode() {		//添加节点
            flag = 0;
            zTree.selectNode(tNode);	//选中该节点
            $("#nodeShow").hide();
            $("#nodeEdit").show();
            clearDetail();
            $("#nodeId").val("");
            $("#pId").val(tNode.id);
            if (typeof(tNode.children) != "undefined")
                $("#sort").val(tNode.children.length);	//添加时默认拍最后一位
            else
                $("#sort").val(0);
            $("#pName1").html(tNode.name);
        }
        function edit() {		//编辑
            zTree.selectNode(tNode);
            $("#nodeShow").hide();
            $("#nodeEdit").show();
            $("#nodeId").val(tNode.id);
            $("#pId").val(tNode.pId);
            $("#nodeName1").val(tNode.name);
            $("#pName1").html(tNode.pName);
            $("#sort").val(tNode.sort);
            $("#nodeUrl1").val(tNode.url);
            $("#nodeTitle1").val(tNode.title);
            $("#nodeDesc1").val(tNode.nodeDesc);
            if (tNode.nodeType != null) {
                $("input:radio[name='nodeType']").parent("div").removeClass("checked"); //取消选中所有的radio
                iCheckState($("#iCheck_nodeType" + tNode.nodeType), true);    //选中radio
            }
        }
        function cancel() {		//取消编辑
            showDetail();		//取消编辑，返回浏览页面
        }
        function removeNode() {
            $("#detail_bg").show();
            $("#aTitle").html("本次操作将删除所有子节点，并且无法恢复，您确定要删除吗？");
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
                url: "removeNode.action?nodeId=" + tNode.id,
                success: function (data) {
                    var flag = data.flag;
                    $("#alert").hide(300);
                    $("#detail_bg").hide().css("z-index", "50000");
                    $("#waiting").hide();
                    if (flag == 0) {
                        //top.success(0,"删除成功");
                        zTree.removeNode(zTree.getSelectedNodes()[0]);
                    }
                    else if (flag == 2) {
                        //top.success(1,"删除失败,请重试或联系管理员！");
                    }
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        }
        function save() {	//添加/修改目录、项目、任务
            var nodeName1 = $.trim($("#nodeName1").val());
            if (nodeName1 == "") {
                save_alert(0, "您还没有输入模块名", "#nodeName1");
                $("#nodeName1").addClass("inputAlarm");
            }
            else {
                //jsons_save(form1);
                if ($("#nodeIcon1").val() == "") {	//没有选择照片，则不上传
                    jsons_save(form1);
                }
                else {
                    $("#detail").hide();
                    beCenter("waiting");
                    $("#waitings").html("保存中，请稍候....");
                    $("#waiting").show();
                    var options = {
                        url: "addNode.action",
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
        function save_suc(data) {
            $("#waiting").hide();
            $("#detail").hide();
            $("#detail_bg").hide().css("z-index", "50000");
            var flag = data.flag;
            var mapNode = data.map;
            if (flag == -1) {
                //top.success(1,"操作失败，请重试或联系管理员");
                return false;
            }
            else if (flag == 0) {	//添加节点
                var newNode = zTree.addNodes(tNode, mapNode);	//zTree加载新添加的节点
                //zTree.selectNode(newNode);
                showDetail();
            }
            else {		//编辑节点
                tNode.name = mapNode.name;
                tNode.pId = mapNode.pId;
                tNode.sort = mapNode.sort;
                tNode.title = mapNode.title;
                tNode.url = mapNode.url;
                tNode.nodeDesc = mapNode.nodeDesc;
                zTree.updateNode(tNode);
                showDetail();		//更新右侧的详细信息
            }
        }
    </script>
    <style type="text/css">
        body, html {
            height: 100%;
            margin: 0;
            padding: 0;
        }

        .divMain {
            margin: 0;
            padding: 0;
            height: 100%;
            background: #b4dbf3;
            background-image: -moz-linear-gradient(top, #97DDF3, #FFFFFF);
            background-image: -webkit-gradient(linear, left top, left bottom, color-stop(0, #97DDF3), color-stop(1, #FFFFFF));
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#97DDF3', endColorstr='#FFFFFF', GradientType='0');
            background: linear-gradient(to bottom, #97DDF3, #FFFFFF)
        }

        .treeBody {
            text-align: left;
            overflow: auto;
            width: 250px;
            float: left;
            border-right: 2px solid gray;
            height: 100%;
        }

        .treeDetail {
            text-align: center;
            overflow: auto;
            height: 100%;
            padding: 0;
        }

        .aTree {
            margin: 5px 0 0 5px;
        }

        .vu {
            border: 1px solid #d3d3d3;
            border-collapse: collapse;
            width: 100%;
            background-color: white
        }

        .vu th {
            background-color: #EFEFEF;
            color: #000;
            border: 1px solid #CBCCDD
        }

        .vu tr {
            height: 45px;
            font-size: 15px;
        }

        .vu td {
            border: 1px solid #d3d3d3
        }

        .aa {
            color: #ff2121
        }

        .bb {
            color: #000033
        }

        .s1 {
            color: #ff2121
        }

        .inputText {
        }

        .inputText1 {
            width: 50px;
        }

        .cTitle {
            margin: 10px 0
        }

        .cLeft {
            text-align: left;
            padding: 5px 10px;
        }

        .cRight {
            text-align: right;
            padding-right: 10px;
            background-color: #F7F9FC;
        }
    </style>
</head>
<body>
<div class="divMain">
    <div class="treeBody">　
        <a class='aBtn aGreen aTree' href='javascript:' onclick="refreshTree()">刷新</a>
		<span style="margin-left:10px;">
			拖拽限制：<s:select id="dragLimit" list="#{-1:'禁止',0:'无',1:'同目录',2:'同级别'}" value="-1"/>
		</span>
        <ul id="treeDemo" class="ztree"></ul>
    </div>
    <div class="treeDetail" id="treeDetail">
        <table class="vu" border="0" cellspacing="0" cellpadding="0" id="nodeShow">
            <tr>
                <td bgcolor="#efefef" colspan="2">
                    <div align="left" class="devClass ml20">菜单浏览　<c:if test="${nodeState==1}"><input class="btn_1"
                                                                                                     type="button"
                                                                                                     onclick="edit();"
                                                                                                     value="编辑"/></c:if>
                    </div>
                </td>
            </tr>
            <tr>
                <td width="15%">　模块名：</td>
                <td width="85%" id="nodeName2"></td>
            </tr>
            <tr>
                <td>上级模块：</td>
                <td id="pName"></td>
            </tr>
            <tr>
                <td>模块类型：</td>
                <td id="nodeType"></td>
            </tr>
            <tr>
                <td>模块图标：</td>
                <td id="nodeIcon"></td>
            </tr>
            <tr>
                <td>模块路径：</td>
                <td id="nodeUrl"></td>
            </tr>
            <tr>
                <td>模块Title：</td>
                <td id="nodeTitle"></td>
            </tr>
            <tr>
                <td>模块简介：</td>
                <td id="nodeDesc"></td>
            </tr>
        </table>
        <table class="vu" border="0" cellspacing="0" cellpadding="0" id="nodeEdit" style="display:none">
            <s:form name="form1" id="form1" method="post" action="addNode.action" enctype="multipart/form-data"
                    theme="simple">
                <input type="hidden" id="nodeId" name="nodeId">
                <input type="hidden" id="pId" name="pId">
                <input type="hidden" id="sort" name="sort">
                <tr>
                    <td bgcolor="#efefef" colspan="2">
                        <div align="left" class="devClass ml20">菜单管理　<input class="btn_1" type="button"
                                                                            onclick="save();" value="保存"/>　<input
                                class="btn_2" type="button" onclick="cancel();" value="取消"/></div>
                    </td>
                </tr>
                <tr>
                    <td width="15%">　模块名：</td>
                    <td width="85%"><input id="nodeName1" name="name" onkeydown="resetBorder(id);" style="width:200px"
                                           class="inputText"></td>
                </tr>
                <tr>
                    <td>上级模块：</td>
                    <td id="pName1"></td>
                </tr>
                <tr>
                    <td>模块类型：</td>
                    <td>
                        <s:radio name="nodeType" id="iCheck_nodeType" list="#{1:'top导航',2:'nav导航'}" value="0"/>
                    </td>
                </tr>
                <tr>
                    <td>模块图标：</td>
                    <td><input type="file" name="file" id="nodeIcon1" style="width :140px"/></td>
                </tr>
                <tr>
                    <td>模块路径：</td>
                    <td><input id="nodeUrl1" name="url" style="width:300px" class="inputText"></td>
                </tr>
                <tr>
                    <td>模块Title：</td>
                    <td><input id="nodeTitle1" name="title" style="width:300px" class="inputText"></td>
                </tr>
                <tr>
                    <td>模块简介：</td>
                    <td><textarea id="nodeDesc1" name="nodeDesc" style="width:390px;height:45px"
                                  class="inputText"></textarea></td>
                </tr>
            </s:form>
        </table>
    </div>
</div>
<div id="detail_bg"></div>
<div id="alert" class="div_alt">
    <s:include value="../main/alert.jsp"/>
</div>
</body>
</html>