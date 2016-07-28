<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE HTML>
<html>
<head>
    <title>设备管理</title>
    <script type="text/javascript" src="../js/jquery-1.8.2.min.js"></script>
    <link type="text/css" rel="stylesheet" href="../js/zTree/zTreeStyle/zTreeStyle.css">
    <script type="text/javascript" src="../js/zTree/jquery.ztree.core-3.5.js"></script>
    <script type="text/javascript" src="../js/zTree/jquery.ztree.excheck-3.5.js"></script>
    <script type="text/javascript" src="../js/zTree/jquery.ztree.exedit-3.5.js"></script>
    <script type="text/javascript" src="../js/jquery.form.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <link type="text/css" rel="stylesheet" href="../css/style.css"/>
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=5nQx3fgeRC5EXNO59eSvLNl1"></script>
    <script type="text/javascript">
        var nodeId;
        var flag = 0;
        var isPho = true;
        var curDragNodes, autoExpandNode;
        var newCount = 1;
        var tNode;		//选择的节点
        var zTree;		//整棵树
        var isParas = false;
        var helpOut;	//【显示】提示信息
        var mapRegs = new Map();
        var isAdd;
        var nodeState = ${nodeState};	//页面权限【0：浏览；1：管理】
        var mapPainPoints = new Map();  //已绘制的监测点
        var mapPainLines = new Map();   //已绘制的折线
        var mapBaidu;
        var polyline;       //绘制的折线图
        var pLines = [];        //用户绘制的点
        var drawPoint = null;   //实际需要画在地图上的点
        var isPainLine = false; //是否绘制折线
        var mapPoints = new Map();
        var curPointId;     //当前正在绘制的监测点
        var mapPointNames = new Map();  //监测点Id,监测点名称
        var funMapPoint;
        var funAreaPoint;
        var defaultCursor;
        var myValue;
        var icon_default;
        var icon_area;
        var icon_map;
        var mapRegSwitchs = new Map();  //监测点控制信息 → <regId, {[switchId, switchName, switchValue]}>
        $(function () {
            initNode();
            icon_map = new BMap.Icon("../img/icon_map.png", new BMap.Size(22, 25), {
                offset: new BMap.Size(10, 25),
                imageOffset: new BMap.Size(-23, 0 - 1 * 21)
            });
            icon_default = new BMap.Icon("../img/icon_map.png", new BMap.Size(22, 25), {
                offset: new BMap.Size(10, 25),
                imageOffset: new BMap.Size(-46, 0 - 1 * 21)
            });
            icon_area = icon_map;
            iCheckInit();
        });
        function initNode() {		//初始化
            $.ajax({
                type: "post",
                dataType: "json",
                url: "json_regInfos.action?nodeState=${nodeState}",
                success: function callBack(data) {
                    var zNodes = data.map.zNodes;
                    newCount = data.map.count;		//取最后一个，以免add的时候id重复
                    var setting = {
                        view: {
                            addHoverDom: addHoverDom,
                            removeHoverDom: removeHoverDom,
                            selectedMulti: false,
                            fontCss: setFontCss
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
                                title: "regTitle"
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
                    zTree = $.fn.zTree.getZTreeObj("treeDemo");
                    $("#callbackTrigger").bind("change", {}, setTrigger);
                    tNode = zTree.getNodes()[0];		//展开树后默认显示根节点的信息
                    zTree.selectNode(tNode);
                    showRegInfo();
                    $("#treeDetail .vu:lt(2)").find("tr td:even").addClass("cBlue cRight bold");
                    $("#treeDetail .vu:lt(2)").find("tr td:odd").addClass("bb cLeft");
                    var devTypes = data.map.devTypes;		//室外类型
                    var sensorTypes = data.map.sensorTypes;	//传感器类型
                    var charHtml = "";
                    charHtml += "<optgroup label='设备类型：'></optgroup>";
                    for (var i in devTypes) {
                        charHtml += "<option value='0_" + devTypes[i].id + "'>　" + devTypes[i].typeName + "</option>";
                    }
                    charHtml += "<optgroup label='传感器参数：'></optgroup>";
                    for (var i in sensorTypes) {
                        charHtml += "<option value='1_" + sensorTypes[i].id + "' flag='" + sensorTypes[i].enName + "'>　" + sensorTypes[i].typeName + "</option>";
                    }
                    for (var i in zNodes) {
                        mapRegs.put(zNodes[i].id + "", zNodes[i].name);
                    }
                    $("#paraTypeId").html(charHtml);
                    var points = data.map.mapPoints;
                    if (points) {
                        for (var i in points) {
                            mapPainPoints.put(points[i].regId + "", points[i].lng + "_" + points[i].lat);
                        }
                    }
                    var lines = data.map.mapLines;
                    if (lines) {
                        for (var i in lines) {
                            mapPainLines.put(lines[i].regId + "", lines[i].coords);
                        }
                    }
                    var regSwitchs = data.map.regSwitchs;
                    if (regSwitchs) {
                        for (var i in regSwitchs) {
                            mapRegSwitchs.put(i + "", regSwitchs[i]);
                        }
                    }
                    $(".treeBody").height(document.documentElement.clientHeight);
                    res();
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        }
        function refreshTree() {		//刷新整棵树
            initNode();
        }
        function beforeClick(treeId, treeNode, clickFlag) {
            tNode = treeNode;
            if (tNode.nodeType == "regControl")	//设备控制
                showRegControl();
            else
                showRegInfo();
            return (treeNode.click != false);
        }
        function beforeDrag(treeId, treeNode) {
            return false;
        }
        function beforeEditName(treeId, treeNode) {
            tNode = treeNode;
            editRegInfo();
            return false;		//编辑时浮出自定义的窗口，不再调用zTree原本的方法
            zTree.selectNode(treeNode);
            //return confirm("进入节点 -- " + treeNode.name + " 的编辑状态吗？");
        }
        function beforeRemove(treeId, treeNode) {
            tNode = treeNode;
            zTree.selectNode(tNode);	//选中该节点
            removeRegInfo();
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
            if (nodeState == 0)
                return false;
            return typeof(treeNode.isRemove) != "undefined" ? treeNode.isRemove : true;
        }
        function showRenameBtn(treeId, treeNode) {		//编辑，默认true
            //return !treeNode.isLastNode;
            if (nodeState == 0)
                return false;
            return typeof(treeNode.isRename) != "undefined" ? treeNode.isRename : true;
        }

        function addHoverDom(treeId, treeNode) {		//添加，默认true
            if (nodeState == 0)
                return false;
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
                addRegInfo();		//展开添加的弹出窗,确定后插入数据库并在zTree中同步
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
            var regId = treeNode[0].id;		//拖拽节点的id
            var tIndex = zTree.getNodeIndex(treeNode[0]);	//拖拽后的序号
            var pId;				//拖拽后父节点的id
            if (moveType != "inner")
                pId = targetNode.getParentNode().id;
            else
                pId = targetNode.id;
            $.ajax({
                type: "post",
                dataType: "json",
                url: "sortRegInfo.action?regId=" + regId + "&tIndex=" + tIndex + "&pId=" + pId,
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
        function setFontCss(treeId, treeNode) {		//设置节点的字体css
            return {"color": treeNode.color};
        }
        function showRegInfo() {		//在页面右侧显示所选节点的详细信息
            $("#regPic1").attr("src", "../" + tNode.regPic);
            reChange("regPic1", 240, 240);
            var nodeName = tNode.name;
            $("#regName1").html(nodeName);
            if (tNode.getParentNode())
                $("#pName1").html(tNode.getParentNode().name);
            else
                $("#pName1").html("Sensor");
            $("#paraTypeName1").html(tNode.paraTypeName);
            //$("#regUrl1").html(tNode.regUrl);
            $("#regTitle1").html(tNode.regTitle);
            $("#isShow1").html(tNode.isShow1);
            $("#regDesc1").html(tNode.regDesc);
            if (tNode.nodeType == 1) {		//表示参数
                $("#treeDetail tr[trFlag='regBet']").hide();
                $("#treeDetail tr[trFlag='regPara']").show();
                $("#addrOff1").html(tNode.addrOff);
                $("#memoTypeName").html(tNode.memoTypeName);
                $("#devId1").html(tNode.devId);
                $("#unitName").html(tNode.unitTypeName);
                var gaugeRange = "";
                if (isNum(tNode.gaugeMin))
                    gaugeRange += "<span class='bold cBlue'>最小刻度：</span>" + tNode.gaugeMin + "　";
                if (isNum(tNode.gaugeMax))
                    gaugeRange += "<span class='bold cBlue'>最大刻度：</span>" + tNode.gaugeMax;
                $("#gaugeRange").html(gaugeRange);
                $("#excepData1").html(tNode.excepDatas1);
                //$("#paraLimit1").html(tNode.paraLimit1+" - "+tNode.paraLimit2);
                $("#tdPic_show").attr("rowspan", "12");
                $("#treeDetail tr[trFlag1='isCal']").show();
            }
            else {
                $("#treeDetail tr[trFlag='regPara']").hide();
                //$("#treeDetail tr[trFlag='regSignal']").hide();
                //$("#treeDetail tr[trFlag='regNodes']").hide();
                if (tNode.enName == "sensorType") {
                    $("#treeDetail tr[trFlag='regBet']").show();
                    $("#tdPic_show").attr("rowspan", "8");
                    //$("#dtBet1").html(tNode.dtBet);
                    $("#commPortId1").html(tNode.commPortId);
                }
                else {
                    $("#treeDetail tr[trFlag='regBet']").hide();
                    $("#tdPic_show").attr("rowspan", "7");
                }
            }
            //if(tNode.paraTypeName=="监测区域")
            $("#treeDetail .spanMap").show();
            //else
            //    $("#treeDetail .spanMap").hide();
            $("#nodeShow").show();
            $("#nodeEdit, #nodeRegSwitch").hide();
            $("#nodeRegSwitch").hide();
        }
        function addRegInfo() {	//添加节点
            isAdd = true;
            flag = 0;
            zTree.selectNode(tNode);	//选中该节点
            if (typeof(tNode.children) != "undefined")
                $("#regSort").val(tNode.children.length);	//添加时默认拍最后一位
            else
                $("#regSort").val(0);
            $("#detail .tr_paras").hide();
            isParas = false;	//默认为添加设备，隐藏参数相关信息
            clearDetail();
            $("#regId").val("");
            $("#regUrl").val("");
            $("#regPic").html("<img src='../img/imgNull.png' width='140' class='imgDev'>");
            changeParas("0_0");
            $("#div_detail").hide();
            $("#div_save").show();
            $("#pNode").html(tNode.name);
            $("#nodeShow, #nodeRegSwitch").hide();
            $("#nodeEdit").show();
        }
        function editRegInfo() {
            isAdd = false;
            flag = 0;
            zTree.selectNode(tNode);	//选中该节点
            clearDetail();
            $("#regId").val(tNode.id);
            $("#regName").val(tNode.name);
            $("#regUrl").val("");
            if (tNode.getParentNode()) {
                $("#pNode").html(tNode.getParentNode().name);
                $("#pId").val(tNode.getParentNode().id);
            }
            else {	//根节点
                $("#pNode").html("Sensor");
                $("#pId").val(1);
            }
            if (tNode.regPic != null)
                $("#regPic").html("<img src='../" + tNode.regPic + "' id='imgDetail' class='imgDev' alt='" + tNode.name + "'>");
            else
                $("#regPic").html("<img src='../img/imgNull.png' width='140' class='imgDev'>");
            reChange("imgDetail", 140, 140);	//调整图片大小
            $("#paraTypeId").val(tNode.nodeType + "_" + tNode.paraTypeId);
            if (tNode.nodeType == 1) {		//设备参数
                $("#treeDetail tr[trFlag='regBet']").hide();
                $("#treeDetail tr[trFlag='regPara']").show();
                $("#addrOff").val(tNode.addrOff);
                $("#devId_").val(tNode.devId);
                $("#memoTypeId").val(tNode.memoTypeId);
                $("#unitTypeId").val(tNode.unitTypeId);
                $("#gaugeMin").val(tNode.gaugeMin);
                $("#gaugeMax").val(tNode.gaugeMax);
                var excepDatas = tNode.excepDatas;
                transExcepData(excepDatas);
                $("#tdPic_edit").attr("rowspan", "13");
                isParas = true;
                $("#treeDetail tr[trFlag1='isCal']").show();
            }
            else {
                $("#treeDetail tr[trFlag='regPara']").hide();
                if (tNode.enName == "sensorType") {
                    $("#treeDetail tr[trFlag='regBet']").show();
                    $("#tdPic_edit").attr("rowspan", "9");
                    $("#serialId").val(tNode.serialId);
                }
                else {
                    $("#treeDetail tr[trFlag='regBet']").hide();
                    $("#tdPic_edit").attr("rowspan", "8");
                }
                isParas = false;
            }
            $("#regTitle").val(tNode.regTitle);
            $("#regDesc").val(tNode.regDesc);
            $("#isShow").val(tNode.isShow);
            if (nodeState == 0)
                cmsComp();	//特指农业养殖项目的限制权限
            if (tNode.pId == 1 && tNode.id > 1)
                $("#treeDetail .spanMap").show();
            else
                $("#treeDetail .spanMap").hide();
            $("#nodeShow, #nodeRegSwitch").hide();
            $("#nodeEdit").show();
            $("#nodeRegSwitch").hide();
            $("#excepData_0").focus();
        }
        function cmsComp() {
            $("#paraTypeId,#devId_,#memoTypeId,#unitTypeId,#addrOff,#isShow").attr("disabled", "true");
            if (tNode.id == 1)	//根节点：微能物联养殖云平台
                $("#regName").attr("disabled", "true");
            else
                $("#regName").removeAttr("disabled");
        }
        function clearComp() {
            $("#paraTypeId,#devId_,#memoTypeId,#unitTypeId,#addrOff,#isShow,#regName").removeAttr("disabled");
        }
        function removeRegInfo() {
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
                url: "removeRegInfo.action?regId=" + tNode.id,
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
        function save() {		//添加/修改节点
            var regName = $.trim($("#regName").val());
            var paraType = $("#paraTypeId").val().split("_")[0];
            ;
            ;
            ;
            ;
            ;
            ;
            ;
            var devId = $.trim($("#devId_").val());
            var addrOff = $.trim($("#addrOff").val());
            if (regName == "") {
                save_alert(0, "您还未输入节点名", "#regName");
                $("#regName").addClass("inputAlarm");
            }
            else if (paraType == 1 && devId == "") {	//参数，需检查设备Id，偏移地址，警报值
                save_alert(0, "您还未输入设备Id", "#devId_");
                $("#devId_").addClass("inputAlarm");
            }
            else if (paraType == 1 && addrOff == "") {
                save_alert(0, "您还未输入偏移地址", "#addrOff");
                $("#addrOff").addClass("inputAlarm");
            }
            else if (flag == 0) {
                clearComp();
                if ($("#file").val() == "") {	//没有选择照片，则不上传
                    jsons_save(form1);
                }
                else {
                    $("#detail").hide();
                    beCenter("waiting");
                    $("#waitings").html("保存中，请稍候....");
                    $("#waiting").show();
                    var options = {
                        url: "addRegInfo.action",
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
            if (nodeState == 0)
                cmsComp();
            $("#waiting").hide();
            $("#detail").hide();
            $("#detail_bg").hide().css("z-index", "50000");
            var flag = data.flag;
            //var mapNode = data.map;
            if (flag == -1) {
                top.success(1, "操作失败，请重试或联系管理员");
                return false;
            }
            else if (flag == 0) {	//添加节点
                top.success(0, "添加成功");
                map = data.map;
                zTree.addNodes(tNode, map);	//zTree加载新添加的节点
                showRegInfo();		//更新右侧的详细信息
            }
            else if (flag == 1) {	//编辑节点
                top.success(0, "编辑成功");
                map = data.map;
                for (var i in map) {
                    eval("(tNode." + i + " = '" + map[i] + "')");
                }
                zTree.updateNode(tNode);
                showRegInfo();		//更新右侧的详细信息
            }
            $("#detail").hide();
        }
        function showHelp() {		//浮出帮助信息，此处特指【是否显示】相关介绍
            if ($("#divHelp").length > 0)		//如果已存在，则remove
                $("#divHelp").remove();
            var htmlOut = "<div id='divHelp' class='divHelp' onmouseover='helpOut=false' onmouseout='helpOut=true'>" +
                    "<div class='helpConcent'>" +
                    "<p class='pHtml'><span class='bold'>正常显示：</span>正常显示该节点</p>" +
                    "<p class='pHtml'><span class='bold'>隐藏本节点：</span>隐藏本节点，下属节点直接对应父节点</p>" +
                    "<p class='pHtml'><span class='bold'>隐藏所有节点：</span>隐藏包括本节点在内的所有子节点</p>" +
                    "<p class='pBtn'>" +
                    "<input class='btn_11' flag='done' type='button' onclick='closeDiv(\"divHelp\");' value='确定' />　" +
                    "</p>" +
                    "</div>" +
                    "</div>";
            $(document.body).append(htmlOut);
            mouseClickFun('divHelp');
            $("#divHelp").show();
        }
        document.onclick = function () {
            if (helpOut) {
                $("#divHelp").hide();
            }
        };
        function checkPhoto() {
            var value = $("#file").val();
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
        function changeParas(i) {
            //$("#treeDetail tr[trFlag='regNodes']").hide();
            var paraType;
            if (typeof(i) == "undefined")
                paraType = $("#paraTypeId").val();
            else
                paraType = i;
            if (paraType.split("_")[0] == 0) {	//设备
                $("#treeDetail tr[trFlag='regPara']").hide();
                isParas = false;
                if (paraType.split("_")[1] == 198) {
                    $("#treeDetail tr[trFlag='regBet']").show();
                    $("#tdPic_edit").attr("rowspan", "9");
                }
                else {
                    $("#treeDetail tr[trFlag='regBet']").hide();
                    $("#tdPic_edit").attr("rowspan", "8");
                }
            }
            else {	//参数
                $("#treeDetail tr[trFlag='regPara']").show();
                $("#treeDetail tr[trFlag='regBet']").hide();
                $("#tdPic_edit").attr("rowspan", "12");
                isParas = true;
                resetBorder('addrOff');
                checkAddrOff();
                setParaUnit();
                var enName = $("#paraTypeId").find("option:selected").attr("flag");
                $("#treeDetail tr[trFlag1='isCal']").show();
                $("#memoTypeId").val(196);	//holding
            }
        }
        function cancel() {		//取消编辑
            showRegInfo();		//取消编辑，返回浏览页面
        }
        function setParaUnit() {	//根据参数获取对应单位
            /* var paraType = $("#paraTypeId").val();
             if(paraType.split("_")[0]==1){
             $("#unitTypeId").val(mapParaUnits.get(paraType.split("_")[1]+""));//默认选中参数对应的单位
             } */
        }
        function checkAddrOff() {	//检查偏移地址
            var regId = $("#regId").val();
            var addrOff = $("#addrOff").val();
            var devId = $("#devId_").val();
            if (addrOff == "" || devId == "")
                return false;
            $.ajax({
                type: "post",
                dataType: "json",
                url: "checkAddrOff.action?regId=" + regId + "&addrOff=" + addrOff + "&devId=" + devId,
                success: function (data) {
                    flag = data.flag;
                    if (flag == 1) {
                        save_alert(0, "已存在该偏移地址", "#addrOff");
                        $("#addrOff").addClass("inputAlarm");
                    }
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        }
        /*function checkBet(){		//校验数据点数
         var dtBet = $.trim($("#dtBet").val());
         if(dtBet!=""&&!isUNaN(dtBet)){		//采样周期
         save_alert(0,"请输入正整数","#dtBet");
         $("#dtBet").addClass("inputAlarm");
         return false;
         }
         }*/
        function regNode() {	//获取对应采集节点下的参数，供选择（冷热温差/输出功率）
            var tNodes;
            if (isAdd)
                tNodes = tNode.children;
            else
                tNodes = tNode.getParentNode().children;
            if (tNodes.length == 0)
                return false;
            beCenter("divRegNodes");
            $("#detail_bg").show();
            $("#divRegNodes").show(300);
            var bNodes = [];
            var regUrl = $("#regUrl").val();
            $("#unbindNodes").html("");
            $("#bindNodes").html("");
            if (regUrl != "") {
                bNodes = regUrl.split(",");
                ;
                ;
                ;
                ;
                ;
                ;
                ;
                for (var i in bNodes) {
                    $("#unbindNodes").append("<li id='" + bNodes[i] + "-' onclick='unBind(id)' onmouseover='liOver(this)' onmouseout='liOut(this)'>　" + mapRegs.get(bNodes[i] + "") + "</li>");
                }
            }
            for (var i in tNodes) {
                if ($.inArray(tNodes[i].id + "", bNodes) == -1) {
                    $("#bindNodes").append("<li id='" + tNodes[i].id + "-' onclick='Bind(id)' onmouseover='liOver(this)' onmouseout='liOut(this)'>　" + tNodes[i].name + "</li>");
                }
            }
        }
        function Bind(id) {		//绑定人员
            $("#unbindNodes").append("<li id='" + id + "0' onclick='unBind(id)' onmouseover='liOver(this)' onmouseout='liOut(this)'>" + $("#" + id).html() + "</li>");
            $("#" + id).remove();
        }
        function unBind(id) {	//解绑人员
            $("#bindNodes").append("<li id='" + id + "1' onclick='Bind(id)' onmouseover='liOver(this)' onmouseout='liOut(this)'>" + $("#" + id).html() + "</li>");
            $("#" + id).remove();
        }
        function liOver(td) {
            $(td).css({"background-color": "yellow"});
        }
        function liOut(td) {
            $(td).css({"background-color": "#81f4eb"});
        }
        function saveRegNodes() {
            var regIds = "";
            var regNames = "";
            var rId;
            $("#unbindNodes li").each(function () {
                rId = $(this).attr("id").split("-")[0];
                ;
                ;
                ;
                ;
                ;
                ;
                ;
                regIds += rId + ",";
                regNames += mapRegs.get(rId + "") + ",";
            });
            if (regIds.length > 0) {
                regIds = regIds.substring(0, regIds.length - 1);
                ;
                ;
                ;
                ;
                ;
                ;
                ;
                regNames = regNames.substring(0, regNames.length - 1);
                $("#regUrl").val(regIds);
                //$("#assNodes").html(regNames);
            }
            $("#detail_bg").hide();
            $("#divRegNodes").hide();
        }
        $(window).resize(function () {
            res();
        });
        function res() {
            var pHeight = document.documentElement.clientHeight;
            $(".treeBody").height(pHeight - 3);
        }
        function transExcepData(excepDatas) {
            if (excepDatas == "")
                return;
            var logic;
            if (excepDatas.indexOf("|") > -1) {
                logic = "|";
                $("#excepLogic").val(1);
            }
            else {
                logic = "&";
                $("#excepLogic").val(2);
            }
            var excepRule = excepDatas.split(logic);
            var datas;  //rule_data
            for (var i in excepRule) {
                datas = excepRule[i].split("_");
                if (datas[1] != "") {   //警戒值不为空
                    $("#nodeEdit select[name='excepTypes']:eq(" + i + ")").val(datas[0]);
                    $("#nodeEdit input[name='excepDatas']:eq(" + i + ")").val(datas[1]);
                }
            }
        }
        function showRegMap() {  //地图配置
            $("#divRegMap").show();
            // 百度地图API功能
            mapBaidu = new BMap.Map('baiduMap', {enableMapClick: false});    //去除地图本身元素的点击事件
            var mapPoint = mapPainPoints.get(tNode.id + "");
            var poi;
            var mapLng, mapLat;  //地图中心定位的经纬度
            if (mapPoint) {   //已配置监测区域
                mapLng = mapPoint.split("_")[0];
                mapLat = mapPoint.split("_")[1];
            }
            else {           //未配置监测区域,默认定位到微能物联
                mapLng = 121.848534;
                mapLat = 29.933796;
            }
            poi = new BMap.Point(mapLng, mapLat);
            $("#r-result input[flagInput='regAreaLng']").val(mapLng);
            $("#r-result input[flagInput='regAreaLat']").val(mapLat);
            var mapZoom = tNode.addrOff;
            if (mapZoom < 3 || mapZoom > 19)   //放大级别默认3-18
                mapZoom = 18;
            mapBaidu.centerAndZoom(poi, mapZoom);
            var marker = new BMap.Marker(poi, {icon: icon_map});
            mapBaidu.addOverlay(marker);
            var label = new BMap.Label("监测区域", {offset: new BMap.Size(20, -10)});
            marker.setLabel(label);
            curPointId = tNode.id;
            mapPoints.put(curPointId + "", marker);
            //mapBaidu.enableScrollWheelZoom();
            mapBaidu.disableDoubleClickZoom();   //禁止鼠标双击放大Zoom
            mapBaidu.addControl(new BMap.ScaleControl({anchor: BMAP_ANCHOR_TOP_LEFT}));  // 左上角，添加比例尺
            mapBaidu.addControl(new BMap.NavigationControl());   //左上角，添加默认缩放平移控件
            $("#divRegMap .divMapReg ul.ulLines").html("");
            initRegDatas();
            initMapSearch();    //初始化地图搜索
            var areaLines = mapPainLines.get(tNode.id + "");
            if (areaLines)   //存在折线图
                initPainLines(areaLines);
            mapBaidu.addEventListener("tilesloaded",    //加载完地图后初始化监测区域信息
                    function () {
                        $("#regArea").val(tNode.regTitle);
                    });
            initABtn();
        }
        function initPainLines(areaLines) {
            var arrLines = areaLines.split(";");
            pLines = [];
            var linePoint;
            var ulHtml = "";
            var pointLng, pointLat;
            for (var i in arrLines) {
                pointLng = parseFloat(arrLines[i].split("_")[0]);
                pointLat = parseFloat(arrLines[i].split("_")[1]);
                linePoint = new BMap.Point(pointLng, pointLat);
                pLines.push(linePoint);
                ulHtml += "<li><span>" +
                        "<input class='inputText' value='" + pointLng + "'>　" +
                        "<input class='inputText' value='" + pointLat + "'>　" +
                        "<a class='aBtn aOut' href='javascript:' onclick='pointUpdate(this)'>更新</a>　" +
                        "<a class='aBtn aDel' href='javascript:' onclick='pointDelete(this)'>删除</a>" +
                        "</span></li>";
            }
            polyline = new BMap.Polyline(pLines);
            mapBaidu.addOverlay(polyline);
            $("#divRegMap .divMapReg ul.ulLines").html(ulHtml);
        }
        function initRegDatas() {    //初始化该监测区域已有的地图信息
            var childrenNodes = tNode.children; //所有子监测点
            if (childrenNodes) {
                var htmlUl = "";
                var point, marker, label;
                var pointId, pointName;
                var pointCoords, pointLng, pointLat;  //监测点经纬度
                for (var i = 0; i < childrenNodes.length; i++) {
                    pointId = childrenNodes[i].id;
                    pointName = childrenNodes[i].name;
                    pointLng = "", pointLat = "";
                    pointCoords = mapPainPoints.get(pointId + "");
                    if (pointCoords != "") {
                        pointLng = pointCoords.split("_")[0];
                        pointLat = pointCoords.split("_")[1];
                        point = new BMap.Point(pointLng, pointLat);
                        marker = new BMap.Marker(point, {icon: icon_default});
                        mapBaidu.addOverlay(marker);
                        label = new BMap.Label(pointName, {offset: new BMap.Size(20, -10)});
                        marker.setLabel(label);
                        mapPoints.put(pointId + "", marker);
                    }
                    htmlUl += "<li>" +
                            "<input class='inputText' flagInput='lng' flagId='" + pointId + "' value='" + pointLng + "'>　" +
                            "<input class='inputText' flagInput='lat' flagId='" + pointId + "' value='" + pointLat + "'>　" +
                            "<span class='spanPoint'><a class='aBtn aDetail' href='javascript:' onclick='showMapPoint(" + pointId + ")' flagBtn='" + pointId + "'>" + pointName + "</a></span>" +
                            "</li>";
                    mapPointNames.put(pointId + "", pointName);
                }
            }
            $("#divRegMap .divMapReg ul.ulPoints").html(htmlUl);
        }
        function showMapLines() { //绘制折线图
            removeMapLines();   //删除之前绘制的折线图
            initABtn();
            $("#divRegMap a[flagBtn=painLine]").removeClass("aDetail").addClass("aYellow");
            defaultCursor = mapBaidu.getDefaultCursor();
            mapBaidu.setDefaultCursor("crosshair"); //改变鼠标样式:十字形状
            mapBaidu.addEventListener('mousedown', painLine);
        }
        function painLine(e) {
            if (e.button == 1 || e.button == 0)
                return;
            pLines.push(e.point);
            drawPoint = pLines.concat(pLines[pLines.length - 1]);
            if (pLines.length == 1) {
                polyline = new BMap.Polyline(drawPoint);
                mapBaidu.addOverlay(polyline);
            } else
                polyline.setPath(drawPoint);
            if (!isPainLine) {
                isPainLine = true;
                mapBaidu.addEventListener('mousemove', mousemoveAction);
                mapBaidu.addEventListener('dblclick', dblclickAction);
            }
            updateLineInput(e); //同步更新经纬坐标至左侧菜单
        }
        var mousemoveAction = function (e) { //绘制折线时显示的鼠标轨迹
            polyline.setPositionAt(pLines.length, e.point);
        };
        ;
        ;
        ;
        ;
        ;
        ;
        ;
        var dblclickAction = function (e) {   //双击停止绘制折线
            //$("#regArea").append("1_");
            $("#divRegMap .divMapReg ul.ulLines li:last").remove();
            finishLines();
            var arrPoints = polyline.getPath();
            arrPoints.pop();
            arrPoints.pop();
            mapBaidu.removeOverlay(polyline);
            polyline.setPath(arrPoints);
            mapBaidu.addOverlay(polyline);
        };
        ;
        ;
        ;
        ;
        ;
        ;
        ;
        function updateLineInput(e) {
            var liHtml = "<li><span>" +
                    "<input class='inputText' value='" + e.point.lng + "'>　" +
                    "<input class='inputText' value='" + e.point.lat + "'>　" +
                    "<a class='aBtn aOut' href='javascript:' onclick='pointUpdate(this)'>更新</a>　" +
                    "<a class='aBtn aDel' href='javascript:' onclick='pointDelete(this)'>删除</a>" +
                    "</span></li>";
            $("#divRegMap .divMapReg ul.ulLines").append(liHtml);
        }
        function removeMapLines() {  //清空折线图
            $("#divRegMap a[flagBtn=painLine]").removeClass("aYellow aDetail").addClass("aDetail");
            $("#divRegMap .divMapReg ul.ulLines").html("");
            mapBaidu.removeOverlay(polyline);
            pLines = [];
        }
        function finishLines() {     //结束绘制曲线
            isPainLine = false;
            mapBaidu.removeEventListener("mousedown", painLine);
            mapBaidu.removeEventListener('mousemove', mousemoveAction);
            mapBaidu.removeEventListener("dblclick", dblclickAction);
            mapBaidu.setDefaultCursor(defaultCursor); //改变鼠标样式:十字形状
            $("#divRegMap a[flagBtn=painLine]").removeClass("aYellow aDetail").addClass("aDetail");
        }
        function showMapPoint(id) {  //设置监测点的坐标点
            var isPain = $("#divRegMap .spanPoint a[flagBtn=" + id + "]").hasClass("aYellow");    //点击正在绘制的监测点,则取消绘制
            finishLines();
            initABtn();
            $("#divRegMap .spanPoint a[flagBtn=" + id + "]").removeClass("aDetail").addClass("aYellow");
            curPointId = id;
            //mapBaidu.removeEventListener("mousedown", funMapPoint);     //取消点击事件
            if (!isPain) //开始绘制
                mapBaidu.addEventListener("mousedown", funMapPoint);    //添加点击事件
            else        //取消绘制
                $("#divRegMap .spanPoint a[flagBtn=" + id + "]").removeClass("aYellow").addClass("aDetail");
        }
        funMapPoint = function (e) {
            checkPoint();
            var point = new BMap.Point(e.point.lng, e.point.lat);
            var marker = new BMap.Marker(point, {icon: icon_default});
            mapBaidu.addOverlay(marker);
            var label = new BMap.Label(mapPointNames.get(curPointId + ""), {offset: new BMap.Size(20, -10)});
            marker.setLabel(label);
            mapPoints.put(curPointId + "", marker);
            $("#divRegMap input[flagId='" + curPointId + "'][flagInput='lng']").val(e.point.lng);
            $("#divRegMap input[flagId='" + curPointId + "'][flagInput='lat']").val(e.point.lat);
        };
        ;
        ;
        ;
        ;
        ;
        ;
        ;
        function checkPoint() {    //检查是否有重复添加的监测点
            var marker_old = mapPoints.get(curPointId + "");
            if (marker_old) {  //地图上已存在该监测点
                mapBaidu.removeOverlay(marker_old); //删除该监测点之前设置的坐标点
            }
        }
        function initMapSearch() {
            var ac = new BMap.Autocomplete(    //建立一个自动完成的对象
                    {
                        "input": "regArea"
                        , "location": mapBaidu
                    });

            ac.addEventListener("onhighlight", function (e) {  //鼠标放在下拉列表上的事件
                var str = "";
                var _value = e.fromitem.value;
                var value = "";
                if (e.fromitem.index > -1) {
                    value = _value.province + _value.city + _value.district + _value.street + _value.business;
                }
                str = "FromItem<br />index = " + e.fromitem.index + "<br />value = " + value;

                value = "";
                if (e.toitem.index > -1) {
                    _value = e.toitem.value;
                    value = _value.province + _value.city + _value.district + _value.street + _value.business;
                }
                str += "<br />ToItem<br />index = " + e.toitem.index + "<br />value = " + value;
                $("#searchResultPanel").html(str);
                //G("searchResultPanel").innerHTML = str;
            });
            ac.addEventListener("onconfirm", function (e) {    //鼠标点击下拉列表后的事件
                var _value = e.item.value;
                myValue = _value.province + _value.city + _value.district + _value.street + _value.business;
                $("#searchResultPanel").html("onconfirm<br />index = " + e.item.index + "<br />myValue = " + myValue);
                //G("searchResultPanel").innerHTML ="onconfirm<br />index = " + e.item.index + "<br />myValue = " + myValue;
                setPlace();
            });
        }
        function setPlace() {
            //mapBaidu.clearOverlays();    //清除地图上所有覆盖物
            function myFun() {
                var pp = local.getResults().getPoi(0).point;    //获取第一个智能搜索的结果
                //mapBaidu.centerAndZoom(pp, 18);
                var marker = new BMap.Marker(pp, {icon: icon_area});
                mapBaidu.addOverlay(marker);    //添加标注
                var label = new BMap.Label("监测区域", {offset: new BMap.Size(20, -10)});
                marker.setLabel(label);
                $("#r-result input[flagInput='regAreaLng']").val(pp.lng);
                $("#r-result input[flagInput='regAreaLat']").val(pp.lat);
                mapPoints.put(tNode.id + "", marker);
            }

            var local = new BMap.LocalSearch(myValue, { //智能搜索
                onSearchComplete: myFun
            });
            local.search(myValue);
            curPointId = tNode.id;
            checkPoint();
        }
        function pointUpdate(input) {   //更新折线图的点
            var lng = $(input).parent().find("input:eq(0)").val();
            var lat = $(input).parent().find("input:eq(1)").val();
            var arrPoints = polyline.getPath();
            var point_update = new BMap.Point(lng, lat);
            var _index = $(input).parent().parent().prevAll("li").length;
            arrPoints[_index] = point_update;
            mapBaidu.removeOverlay(polyline);
            polyline.setPath(arrPoints);
            mapBaidu.addOverlay(polyline);
            /*更新至map*/
            var point = new BMap.Point(lng, lat);
            var marker = new BMap.Marker(point, {icon: icon_default});
            var label = new BMap.Label(mapPointNames.get(curPointId + ""), {offset: new BMap.Size(20, -10)});
            marker.setLabel(label);
            mapPoints.put(curPointId + "", marker);
            /*更新结束*/
        }
        function pointDelete(input) {   //删除折线图的点
            var arrPoints = polyline.getPath();
            var _index = $(input).parent().parent().prevAll("li").length;
            arrPoints.splice(_index, 1);
            mapBaidu.removeOverlay(polyline);
            polyline.setPath(arrPoints);
            mapBaidu.addOverlay(polyline);
            $(input).parent().parent().remove();
        }
        function saveRegMap() {  //保存地图配置信息
            var regId = tNode.id;
            /*所在区域的信息*/
            var regArea = $("#regArea").val();
            var regAreaLng = $("#r-result input[flagInput='regAreaLng']").val();    //地图经度
            var regAreaLat = $("#r-result input[flagInput='regAreaLat']").val();    //地图纬度
            var regAreaZoom = mapBaidu.getZoom();   //地图的放大级别
            /*折线图坐标*/
            var linePoints = "";
            if (polyline) {
                var arrPoints = polyline.getPath();
                for (var i in arrPoints) {
                    linePoints += arrPoints[i].lng + "_" + arrPoints[i].lat + ";";
                }
                linePoints = linePoints.substring(0, linePoints.length - 1);
            }
            /*监测点坐标*/
            var markerPoints = "";
            $("#divRegMap .divMapReg ul.ulPoints li").each(function () {
                markerPoints += $(this).find("input[flagInput=lng]").val() + "_" + $(this).find("input[flagInput=lat]").val() + ";";
            });
            markerPoints = markerPoints.substring(0, markerPoints.length - 1);
            $("#detail_bg").css("z-index", "50000").show();
            beCenter("waiting");
            $("#waitings").html("保存中，请稍候....");
            $("#waiting").show();
            $.ajax({
                type: "post",
                dataType: "json",
                url: "saveRegMap.action",
                data: {
                    "regId": regId,
                    "regArea": regArea,
                    "regAreaLng": regAreaLng,
                    "regAreaLat": regAreaLat,
                    "regAreaZoom": regAreaZoom,
                    "linePoints": linePoints,
                    "markerPoints": markerPoints
                },
                success: function (data) {
                    var flag = data.flag;
                    if (flag == 1) {
                        top.success(1, "保存失败,请重试或连接管理员");
                    }
                    else {
                        var mapDatas = data.map;
                        tNode.regTitle = mapDatas.regTitle;
                        tNode.addrOff = mapDatas.regAreaZoom;
                        zTree.updateNode(tNode);
                        $("#regTitle1").html(mapDatas.regTitle);
                        $("#regTitle").val(mapDatas.regTitle);
                        mapPainPoints.put(mapDatas.regId + "", mapDatas.regAreaLng + "_" + mapDatas.regAreaLat);
                        mapPainLines.put(mapDatas.regId + "", mapDatas.regCoords);
                        var rows = mapDatas.regPoints;
                        if (rows) {
                            for (var i in rows) {
                                mapPainPoints.put(rows[i].regId + "", rows[i].lng + "_" + rows[i].lat);
                            }
                        }
                        top.success(0, "保存成功,请重试或连接管理员");
                        $("#divRegMap").hide();
                    }
                    $("#detail_bg").hide();
                    $("#waiting").hide();
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        }
        function cancelRegMap() {    //取消保存地图配置信息
            $("#divRegMap").hide();
        }
        function pointRegArea() {    //定位监测区域的中心点
            var isPain = $("#regAreaPoint").hasClass("aYellow");        //点击正在绘制的监测点,则取消绘制
            initABtn();
            curPointId = tNode.id;
            //mapBaidu.removeEventListener("mousedown", funAreaPoint);    //取消点击事件
            if (!isPain) {   //开始绘制
                mapBaidu.addEventListener("mousedown", funAreaPoint);   //添加点击事件
                $("#regAreaPoint").removeClass("aDetail").addClass("aYellow");
            }
        }
        funAreaPoint = function (e) {
            checkPoint();
            var point = new BMap.Point(e.point.lng, e.point.lat);
            var marker = new BMap.Marker(point, {icon: icon_area});
            mapBaidu.addOverlay(marker);
            var label = new BMap.Label("监测区域", {offset: new BMap.Size(20, -10)});
            marker.setLabel(label);
            mapPoints.put(curPointId + "", marker);
            $("#r-result input[flagInput='regAreaLng']").val(e.point.lng);
            $("#r-result input[flagInput='regAreaLat']").val(e.point.lat);
        };
        ;
        ;
        ;
        ;
        ;
        ;
        ;
        function initABtn() {    //初始化所有按钮的状态
            $("#divRegMap a[flagBtn=painLine]").removeClass("aYellow aDetail").addClass("aDetail");
            $("#divRegMap .spanPoint a").removeClass("aYellow aDetail").addClass("aDetail");
            $("#regAreaPoint").removeClass("aYellow aDetail").addClass("aDetail");
            mapBaidu.removeEventListener("mousedown", funMapPoint);     //取消点击事件
            mapBaidu.removeEventListener("mousedown", funAreaPoint);     //取消点击事件
        }
        function showRegControl() {
            $("#nodeShow, #nodeEdit").hide();
            $("#nodeRegSwitch").show();
            $("#nodeRegSwitch tr:gt(0)").remove();
            var htmlSwitch = "";
            var regId = tNode.id.split("_")[0];
            var regSwitchs = mapRegSwitchs.get(regId + "");
            if (regSwitchs) {
                var switchId,
                        switchName,
                        switchOpen;
                for (var i in regSwitchs) {
                    switchId = regSwitchs[i].id;
                    switchName = regSwitchs[i].switchName;
                    switchOpen = regSwitchs[i].switchOpen;
                    htmlSwitch += "<tr flagId='" + switchId + "'>" +
                            "<td><input name='switchName' value='" + switchName + "' class='inputText'></td>" +
                            "<td>" + getICheckRadio(i + "_0", "radio_" + i, "启用", switchOpen == 1 ? true : false, 1) + " " +
                            getICheckRadio(i + "_1", "radio_" + i, "停用", switchOpen == 1 ? false : true, 0) + "</td>" +
                            "<td><a class='aBtn aGreen' href='javascript:' onclick='saveRegSwitch(this)'>保存</a></td>" +
                            "</tr>";
                }
            }
            $("#nodeRegSwitch tr:last-child").after(htmlSwitch);
        }
        function getICheckRadio(id, name, label, isCheck, value) {
            var checked = isCheck ? "checked" : "";
            var htmlRadio = "<span>" +
                    "<div class='iradio_green " + checked + "'>" +
                    "<input type='radio' id='chk_radio_" + id + "' name='" + name + "' flagInput='iCheck' " + checked + " value='" + value + "'>" +
                    "</div>" +
                    "<label for='chk_radio_" + id + "' flagInput='iCheck'>" + label + "</label>" +
                    "</span>";
            return htmlRadio;
        }
        function saveRegSwitch(a) {  //保存所在行的设备控制项
            var _tr = $(a).closest("tr");
            var regId = parseInt(tNode.id.split("_")[0]);
            var switchId = parseInt($(_tr).attr("flagId"));
            var switchName = $(_tr).find("input[name=switchName]").val();
            var switchOpen = parseInt($(_tr).find("input:radio:checked").val());
            $.ajax({
                type: "post",
                dataType: "json",
                url: "addRegSwitch.action",
                data: {
                    "regId": regId,
                    "switchId": switchId,
                    "switchName": switchName,
                    "switchOpen": switchOpen
                },
                success: function (data) {
                    var map = data.map;
                    var regSwitchs = mapRegSwitchs.get(regId + "");
                    var aSwitch = [];
                    aSwitch["id"] = map.id;
                    aSwitch["switchName"] = map.switchName;
                    aSwitch["switchOpen"] = map.switchOpen;
                    var aIndex = $(_tr).prevAll("tr").length - 1;
                    regSwitchs.splice(aIndex, 1, aSwitch);
                    mapRegSwitchs.put(regId + "", regSwitchs);
                }
            });
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
            background-color: white;
        }

        #detail .tr_paras {
            display: none
        }

        #tdDetail {
            padding: 0 20px;
        }

        #tdDetail .liTitle {
            list-style-type: none;
            padding-left: 10px;
            font: bold 20px/22px "\5FAE\8F6F\96C5\9ED1", "\9ED1\4F53";
            color: #369;
            border-left: 5px solid #416c97;
        }

        #tdDetail .liBorder {
            list-style-type: none;
            height: 10px;
            width: 80%;
            border-bottom: 1px solid #97bbcd;
        }

        #tdDetail .liMain {
            margin: 5px 0 0 0;
            line-height: 25px;
            list-style-type: none;
            text-align: left;
            font-size: 20px;
            font-weight: bold;
            color: #217FA7;
        }

        #tdDetail .liMain .liSpan {
            color: black;
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
            border: 1px solid #cbccdo
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

        #treeDetail .spanMap {
            margin-left: 35px;
        }

        #divRegMap {
            z-index: 55555;
            width: 100%;
            height: 100%;
            position: absolute;
            top: 0;
            left: 0;
            background-color: #FFF;
        }

        #divRegMap .divMapReg {
            width: 320px;
            float: left;
            text-align: left;
            height: 100%;
            overflow-y: auto;
        }

        #divRegMap .divMapReg ul {
            list-style: none;
            padding: 10px;
            margin: 0;
        }

        #divRegMap .divMapReg ul li {
            margin-bottom: 10px;
        }

        #divRegMap .divMapReg ul li.liTitle {
            background-color: #BDBCBC;
            padding: 7px 5px;
            border-radius: 5px;
        }

        #divRegMap .divMapReg ul li.liUlCont {
            margin: 0;
        }

        #divRegMap .divMapReg ul li.liMapSave {
            margin-top: 10px;
        }

        #divRegMap .divMapReg ul li.liMapSave a {
            font-size: 16px;
            padding: 10px 12px 8px;
        }

        #divRegMap .divMapReg ul li ul.ulPoints {
            max-height: 320px;
            display: block;
            overflow-y: auto;
            padding: 0;
        }

        #divRegMap .divMapReg ul li ul.ulPoints span.spanPoint {
            width: 105px;
            display: inline-block;
        }

        #divRegMap .divMapReg ul li ul.ulLines {
            padding: 0;
            max-height: 320px;
            display: block;
            overflow-y: auto;
        }

        #divRegMap .divMapReg ul li input.inputText {
            width: 80px;
        }

        #divRegMap .divContent {
            height: 100%;
            overflow: hidden;
            zoom: 1;
            position: relative;
            box-shadow: none;
            border-left: 1px solid #13C3C3;
            border-radius: 0;
        }

        div.tangram-suggestion-main {
            z-index: 55555;
            text-align: left;
        }

        .anchorBL { /*隐藏百度地图左下角的广告*/
            display: none
        }
    </style>
</head>
<body>
<div class="divMain">
    <div class="treeBody jScroll">
        <a class='aBtn aGreen aTree' href='javascript:' onclick="refreshTree()">刷新</a>
		<span style="margin-left:10px;">
			拖拽限制：<s:select id="dragLimit" list="#{-1:'禁止',0:'无',1:'同目录',2:'同级别'}" value="-1"/>
		</span>
        <ul id="treeDemo" class="ztree"></ul>
    </div>
    <div class="treeDetail" id="treeDetail">
        <table class="vu" border="0" cellspacing="0" cellpadding="0" id="nodeShow">
            <tr>
                <td bgcolor="#efefef" colspan="5">
                    <div align="left" class="devClass ml20">设备浏览　
                        <input class="btn_1" type="button" onclick="editRegInfo();" value="编辑"/>
                        <span class="spanMap">
                            <a class='aBtn aGreen' href='javascript:' onclick="showRegMap()">地图配置</a>
                        </span>
                    </div>
                </td>
            </tr>
            <tr>
                <td width="30%" id="tdPic_show" rowspan="7" style="text-align:center;"><img id="regPic1" border="0">
                </td>
                <td width="15%">节点名：</td>
                <td width="55%" id="regName1"></td>
            </tr>
            <tr>
                <td>父节点：</td>
                <td id="pName1"></td>
            </tr>
            <tr>
                <td>节点类型：</td>
                <td id="paraTypeName1"></td>
            </tr>
            <tr trFlag="regPara">
                <td>设备Id：</td>
                <td id="devId1"></td>
            </tr>
            <tr trFlag="regBet">
                <td>串口号：</td>
                <td id="commPortId1"></td>
            </tr>
            <tr trFlag="regPara" trFlag1="isCal">
                <td>存储类型：</td>
                <td id="memoTypeName"></td>
            </tr>
            <tr trFlag="regPara" trFlag1="isCal">
                <td>偏移地址：</td>
                <td id="addrOff1"></td>
            </tr>
            <tr trFlag="regPara">
                <td>参数单位：</td>
                <td id="unitName"></td>
            </tr>
            <tr trFlag="regPara">
                <td>警报值：</td>
                <td id="excepData1"></td>
            </tr>
            <tr trFlag="regPara">
                <td>状态图刻度：</td>
                <td id="gaugeRange"></td>
            </tr>
            <tr>
                <td>提示信息：</td>
                <td id="regTitle1"></td>
            </tr>
            <tr>
                <td>是否显示：</td>
                <td id="isShow1"></td>
            </tr>
            <tr>
                <td valign="middle">节点说明：</td>
                <td id="regDesc1"></td>
            </tr>
        </table>
        <table class="vu" border="0" cellspacing="0" cellpadding="0" id="nodeEdit" style="display:none">
            <s:form id="form1" name="form1" action="addRegInfo.action" method="post" enctype="multipart/form-data"
                    theme="simple">
                <input type="hidden" id="regId" name="regId">
                <input type="hidden" id="pId" name="pId">
                <input type="hidden" id="regUrl" name="regUrl">
                <input type="hidden" id="paraLimit" name="icon">
                <tr>
                    <td bgcolor="#efefef" colspan="5">
                        <div align="left" class="devClass ml20">设备管理　
                            <input class="btn_1" type="button" onclick="save();" value="保存"/>　
                            <input class="btn_2" type="button" onclick="showRegInfo();" value="取消"/>
                    <span class="spanMap">
                        <a class='aBtn aGreen' href='javascript:' onclick="showRegMap()">地图配置</a>
                    </span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" id="tdPic_edit" rowspan="7" style="text-align:center;">
                        <img id="" border="0">
                        <span id="regPic"></span>
                        <br/><br/><input type="file" name="file" id="file" style="width :140px"
                                         onchange="checkPhoto();"/>
                        <br/><span class="alarm hide" id="upload_">请上传图片</span>
                    </td>
                    <td width="15%">节点名：</td>
                    <td width="55%"><input name="regName" id="regName" Style="width:300px" onkeydown="resetBorder(id);"
                                           class="inputText"></td>
                </tr>
                <tr>
                    <td>父节点：</td>
                    <td><span id="pNode"></span></td>
                </tr>
                <tr>
                    <td>节点类型：</td>
                    <td><select id="paraTypeId" name="paraTypeId1" Style="width:300px"
                                onchange="changeParas();"></select></td>
                </tr>
                <tr trFlag="regPara">
                    <td>设备Id：</td>
                    <td><input name="devId" id="devId_" onblur="checkAddrOff();" onchange="resetBorder('devId_');"
                               class="inputText" Style="width:300px"></td>
                </tr>
                <tr trFlag="regBet">
                    <td>串口号：</td>
                    <td>
                        <div id="serialId_d">
                            <s:select id="serialId" name="serialId" list="%{serialInfos}" listKey="id"
                                      listValue="commPortId" Style="width:300px"
                                      onchange="resetSD(id);resetBorder('addrOff');checkAddrOff()"/>
                        </div>
                    </td>
                </tr>
                <tr trFlag="regPara" trFlag1="isCal">
                    <td>存储类型：</td>
                    <td><s:select id="memoTypeId" name="memoTypeId" list="%{rows}" listKey="id" listValue="name"
                                  Style="width:300px" onchange="resetBorder('addrOff');checkAddrOff()"/></td>
                </tr>
                <tr trFlag="regPara" trFlag1="isCal">
                    <td>偏移地址：</td>
                    <td><input name="addrOff" id="addrOff" onblur="checkAddrOff();" onkeydown="resetBorder(id);"
                               class="inputText" Style="width:300px"></td>
                </tr>
                <tr trFlag="regPara">
                    <td>参数单位：</td>
                    <td><s:select id="unitTypeId" name="unitTypeId" list="%{unitTypes}" listKey="id"
                                  listValue="typeName" Style="width:300px"/></td>
                </tr>
                <tr trFlag="regPara">
                    <td>警报值：</td>
                    <td>
                        <s:select name="excepTypes" id="excepTypes_0" list="#{1:'＞',2:'≥',3:'＜',4:'≤',5:'='}"/>
                        <input name="excepDatas" id="excepData_0" onkeydown="resetBorder(id);" class="inputText"
                               Style="width:60px">
                        <s:select name="excepLogic" id="excepLogic" list="#{1:'或',2:'与'}" cssStyle="margin: 0 5px;"/>
                        <s:select name="excepTypes" id="excepTypes_1" list="#{1:'＞',2:'≥',3:'＜',4:'≤',5:'='}"
                                  value="3"/>
                        <input name="excepDatas" id="excepData_1" onkeydown="resetBorder(id);" class="inputText"
                               Style="width:60px">
                    </td>
                </tr>
                <tr trFlag="regPara">
                    <td>状态图刻度：</td>
                    <td>
                        <span class='bold cBlue'>最小刻度：</span><input name="gaugeMin" id="gaugeMin" Style="width:80px"
                                                                    class="inputText">
                        <span class='bold cBlue'>最大刻度：</span><input name="gaugeMax" id="gaugeMax" Style="width:80px"
                                                                    class="inputText">
                    </td>
                </tr>
                <tr>
                    <td>提示信息：</td>
                    <td><input name="regTitle" id="regTitle" Style="width:300px" class="inputText"></td>
                </tr>
                <tr>
                    <td>是否显示：</td>
                    <td><s:select name="isShow" id="isShow" list="#{1:'正常显示',2:'隐藏本节点',3:'隐藏所有节点'}" value="1"
                                  Style="width:300px"/>
                        <span class="tdHelp" onclick="showHelp();" onmouseover="helpOut=false"
                              onmouseout="helpOut=true">　</span>
                    </td>
                </tr>
                <tr>
                    <td valign="middle">节点说明：</td>
                    <td>
                        <textarea name="regDesc" id="regDesc" style="width:95%;height:60px"
                                  class="inputText"></textarea>
                    </td>
                </tr>
            </s:form>
        </table>
        <table class="vu" border="0" cellspacing="0" cellpadding="0" id="nodeRegSwitch" style="display:none">
            <tr class="switchTh">
                <td style="width:250px">控制名称</td>
                <td style="width:250px">触发控制</td>
                <td>编辑</td>
            </tr>
        </table>
    </div>
</div>
<div id="detail_bg"></div>
<div id="waiting"><span id="waitings"></span></div>
<div id="alert" class="div_alt">
    <s:include value="../main/alert.jsp"/>
</div>
<div id="divRegMap" class="hide">
    <div class="divMapReg">
        <ul>
            <li class="liTitle">
                <span>地址定位</span>
            </li>
            <li>
                <div id="r-result">
                    <input id="regArea" class="inputText" style="width: 225px;">　
                    <a id="regAreaPoint" class='aBtn aDetail' href='javascript:' onclick="pointRegArea()">定位</a>
                    <input type="hidden" flagInput="regAreaLng" value="所在位置的经度">
                    <input type="hidden" flagInput="regAreaLat" value="所在位置的纬度">
                </div>
                <div id="searchResultPanel"
                     style="border:1px solid #C0C0C0;width:150px;height:auto; display:none;"></div>
            </li>
            <li class="liTitle">
                <span>设置电缆沟</span>
            </li>
            <li class="liUlCont">
                <ul class="ulLines"></ul>
            </li>
            <li>
                <a class='aBtn aDetail' href='javascript:' onclick="showMapLines()" flagBtn="painLine">开始绘制</a>　　
                <a class='aBtn aRed' href='javascript:' onclick="removeMapLines()">清空折线图</a>
            </li>
            <li class="liTitle">
                <span>设置监测点</span>
            </li>
            <li class="liUlCont">
                <ul class="ulPoints"></ul>
            </li>
            <li class="liMapSave">
                <a class='aBtn aOut' href='javascript:' onclick="saveRegMap()">保存配置</a>　　
                <a class='aBtn aDel' href='javascript:' onclick="cancelRegMap()">取消配置</a>
            </li>
        </ul>
    </div>
    <div class="divContent" align="center">
        <div id="baiduMap"
             style="height:100%;-webkit-transition: all 0.5s ease-in-out;transition: all 0.5s ease-in-out;"></div>
    </div>
</div>
</body>
</html>