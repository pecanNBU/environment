<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<!DOCTYPE HTML>
<html>
<head>
    <title>系统左侧菜单</title>
    <script type="text/javascript" src="<%=basePath%>js/jquery-1.6.min.js"></script>
    <link type="text/css" rel="stylesheet" href="<%=basePath%>js/zTree/zTreeStyle/zTreeStyle.css">
    <script type="text/javascript" src="<%=basePath%>js/zTree/jquery.ztree.core-3.5.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/page.js"></script>
    <link type="text/css" rel="stylesheet" href="<%=basePath%>/css/style.css"/>
    <script type="text/javascript">
        var tNode;		//选择的节点
        var zTree;		//整棵树
        var zNodeSensor;	//传感器节点
        //var zNodeManager;	//传感器综合管理
        var mapSwitchs = new Map();
        var switchState = true;
        var setting;
        $(function () {
            initNode();
        });
        function initNode() {	//初始化
            $.ajax({
                type: "post",
                dataType: "json",
                url: "json_leftTrees.action",
                success: function callBack(data) {
                    zNodeSensor = data.map.sensor;
                    //zNodeManager = data.map.manager;
                    setting = {
                        view: {
                            selectedMulti: false,
                            fontCss: setFontCss,
                            dblClickExpand: false,
                            showIcon: showIconForTree
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
                            beforeClick: beforeClick,
                            onExpand: onExpand
                        }
                    };
                    $.fn.zTree.init($("#treeDemo"), setting, zNodeSensor);
                    zTree = $.fn.zTree.getZTreeObj("treeDemo");
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        }
        function beforeClick(treeId, treeNode, clickFlag) {
            if (treeNode.enName == "sensorType") {	//监测点
                var nodes = zTree.getNodesByParam("pId", treeNode.pId, null);
                for (var i in nodes) {
                    if (nodes[i].id == treeNode.id)
                        zTree.expandNode(nodes[i], true);
                    else
                        zTree.expandNode(nodes[i], false);
                }
                turnUrl(treeNode.urls, treeNode.id);
            }
            else
                return false;
        }
        function onExpand(event, treeId, treeNode) {
            return false;
        }
        function showIconForTree(treeId, treeNode) {	//是否显示图标
            var tEnName = treeNode.enName;
            if (tEnName == "sensorCH4" || tEnName == "sensorCO" || tEnName == "sensorNH3" || tEnName == "sensorH2S" || tEnName == "sensorO2")
                return false;
            return true;
        }
        function setFontCss(treeId, treeNode) {		//设置节点的字体css
            if (treeNode.enName == "sensorType")			//鸡舍
                return {"color": "black", "font-weight": "bold"};
            else if (treeNode.enName == "deviceControl") 	//设备控制
                return {"color": "black", "font-weight": "bold"};
            else
                return {"color": "#545252", "cursor": "default", "text-decoration": "none"};
        }
        function turnUrl(urls, id) {		//跳转rights的页面
            $("#navMenu .liNav", top.document).removeClass("aClick");
            top.leftRegId = id;
            if (typeof(parent.rights.src) == "undefined")	//Object Window
                parent.rights.location = "<%=basePath%>chart/showCharts?regId=" + id;
            else										//Object HTMLFrameElement
                parent.rights.contentWindow.location = "<%=basePath%>chart/showCharts?regId=" + id;
        }
    </script>
    <style>
        html {
            height: 100%
        }

        body {
            margin: 0;
            padding: 0;
            background-color: #DFF0F1;
            background: -moz-radial-gradient(circle, #EFF5F8, #D6F1F4);
            background: -webkit-radial-gradient(circle, #EFF5F8, #D6F1F4);
            background: -webkit-gradient(radial, center center, 150, center center, 700, from(#EFF5F8), to(#D6F1F4));
            height: 100%;
            overflow-y: auto;
            overflow-x: hidden;
        }

        #divMain {
            padding: 0;
            width: 214px;
        }

        .spanTrans {
            background: #bababa;
            width: 8px;
            height: 100%;
            border-right: 1px solid #9d9d9d;
            border-left: 1px solid #a7a7a7;
            cursor: pointer;
            right: 0px;
            float: right;
        }

        .spanTrans .pos-a {
            left: -3px;
            background: no-repeat url(../img/mopIcon15x15.png) -120px -15px;
            top: 45%;
            width: 15px;
            height: 15px;
            position: absolute;
        }
    </style>
</head>
<body>
<div id="divMain" class="treeBody">
    <ul id="treeDemo" class="ztree"></ul>
</div>
</body>
</html>
