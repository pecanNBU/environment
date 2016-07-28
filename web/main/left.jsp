<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <title>系统左侧菜单</title>
    <script type="text/javascript" src="../js/jquery-1.8.2.min.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <link type="text/css" rel="stylesheet" href="../css/bootstrap.min.css">
    <link type="text/css" rel="stylesheet" href="../css/bootstrapStyle.css">
    <link type="text/css" rel="stylesheet" href="../css/style.css"/>
    <script type="text/javascript">
        $(function () {
            initNode();
        });
        function initNode() {	//初始化
            $.ajax({
                type: "post",
                dataType: "json",
                url: "json_leftTrees.action",
                success: function callBack(data) {
                    var zNodeSensor = data.map.sensor;
                    $("#ulTree").empty();
                    var liHtml = "";    //该节点本身的html内容
                    var nodeId;
                    var pId;
                    var liOpen; //该节点是否开启
                    var isOpen;
                    var liImg;  //图标
                    var excepType;  //参数的状态
                    var enName; //节点标志
                    for (var i in zNodeSensor) {
                        nodeId = zNodeSensor[i].id;
                        pId = zNodeSensor[i].pId;
                        liOpen = zNodeSensor[i].open;
                        excepType = zNodeSensor[i].excepType;
                        enName = zNodeSensor[i].enName;
                        liImg = transImg(zNodeSensor[i]);
                        if (typeof(excepType) != "undefined")  //表示参数,拥有参数状态
                            liHtml = "<li liId='" + nodeId + "' liOpen='" + liOpen + "' " + excepType + " liEnName='" + enName + "'>";
                        else
                            liHtml = "<li liId='" + nodeId + "' liOpen='" + liOpen + "' liEnName='" + enName + "'>";
                        liHtml += "<span flagSpan='name'>" + liImg + "<font>" + zNodeSensor[i].name + "</font></span></li>";
                        if (nodeId == 1) {  //根节点
                            $("#ulTree").html(liHtml);
                            continue;
                        }
                        if ($("#ulTree li[liId=" + pId + "]").find("ul").length > 0)  //存在本节点的父节点
                            $("#ulTree li[liId=" + pId + "]").find("ul li:last").after(liHtml);
                        else {
                            isOpen = $("#ulTree li[liId=" + pId + "]").attr("liOpen") == "true" ? "" : "hide";
                            $("#ulTree li[liId=" + pId + "]").append("<ul class='" + isOpen + "'>" + liHtml + "</ul>");
                        }
                    }
                    initTreeLi();
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        }
        function initTreeLi() {  //初始化树形结构
            var htmlImgPlus = "<img src='../img/icon_plus.png' flagspan='circle_plus' class='imgCircle'>";
            var htmlImgMinus = "<img src='../img/icon_minus.png' flagspan='circle_minus' class='imgCircle'>";
            var htmlImgGood = "<img src='../img/icon_moni_good.png' class='imgState'>";
            var htmlImgDataErr = "<img src='../img/icon_moni_dataErr.png' class='imgState'>";
            var htmlImgCommErr = "<img src='../img/icon_moni_commErr.png' class='imgState'>";
            var htmlImg;
            var isVisible;
            var enName;
            var liState;    //监测点的状态
            $("#ulTree li").each(function () { //拥有下级节点
                if ($(this).find("ul").length > 0) {   //拥有下级节点
                    $(this).addClass("li_parent");
                    isVisible = $(this).find(" > ul").is(":visible"); //是否已展开子节点
                    if (isVisible)
                        htmlImg = htmlImgMinus;
                    else
                        htmlImg = htmlImgPlus;
                    $(htmlImg).insertBefore($(this).find(">span[flagspan=name]"));
                }
                else {
                    $(this).addClass("li_single").css({"padding-left": "6px"})
                }
                enName = $(this).attr("liEnName");
                if (enName == "conSite") {   //监测点
                    liState = htmlImgGood;
                    $(this).find(" > ul > li").each(function () {
                        if ($(this).hasAttr("dataErr")) {
                            liState = htmlImgDataErr;
                            return false;
                        }
                        else if ($(this).hasAttr("commErr")) {
                            liState = htmlImgCommErr;
                            return false;
                        }
                    });
                    ;
                    ;
                    ;
                    ;
                    ;
                    ;
                    ;
                    $(liState).insertBefore($(this).find(" > span[flagspan=name] > font"));
                    $(this).find(" > span[flagspan=name]").addClass("regNormal").hover(function () {
                        $(this).addClass("regHover");
                    }, function () {
                        $(this).removeClass("regHover");
                    }).bind("click", function () {
                        regClick(this);
                    });
                }
            });
            $('#ulTree li.li_parent > img[flagspan*=circle]').on('click', function (e) {    //点击显示/隐藏下级菜单
                if ($(this).attr("flagspan") == "circle_plus")
                    $(this).attr({"src": "../img/icon_minus.png", "flagspan": "circle_minus"});
                else
                    $(this).attr({"src": "../img/icon_plus.png", "flagspan": "circle_plus"});
                var childUl = $(this).parent('li.li_parent').find(' > ul');
                if (childUl.is(":visible"))
                    childUl.hide('fast');  //隐藏
                else
                    childUl.show('fast');  //显示
                /*var children = $(this).parent('li.li_parent').find(' > ul > li');
                 if (children.is(":visible")) {
                 children.hide('fast');  //隐藏所有下级节点
                 $(this).parent('li.li_parent').find(">span.spanState span").hide();
                 $(this).parent('li.li_parent').find(">img[flagspan*=circle]").attr({"src": "../img/icon_plus.png", "flagspan":"circle_plus"});
                 } else {
                 children.show('fast');  //显示所有下级节点
                 $(this).parent('li.li_parent').find(">span.spanState span").show();
                 $(this).parent('li.li_parent').find(">img[flagspan*=circle]").attr({"src": "../img/icon_minus.png", "flagspan":"circle_minus"});
                 }*/
                e.stopPropagation();
            });
        }
        function transImg(regInfo) {
            var img = "";
            switch (regInfo.enName) {
                case "sensorRoot":  //根节点
                                    //img = "";
                    break;
                case "regArea":     //所在区域
                                    //img = "";
                    break;
                case "conSite":     //建筑工地
                    img = transRegImg(regInfo.excepType);
                    break;
                case "sensorType":  //监测点
                    break;
                default:            //余下-参数
                    break;
            }
            return img;
        }
        function transRegImg(excepType) {
            var regColor = "<img src='../img/icon_good.png' class='png_icon'>";
            if (excepType == "dataErr")
                regColor = "<img src='../img/icon_dataErr.png' class='png_icon'>";
            else if (excepType == "commErr")
                regColor = "<img src='../img/icon_commErr.png' class='png_icon'>";
            return regColor;
        }
        function regClick(span, chartType) {  //点击监测点名,单独展开该监测点,并在右侧展示对应信息
            if (!$(span).hasClass("regClick")) {
                var ulParent = $(span).parent().parent();
                $(ulParent).find(" > li > span[flagspan=name]").removeClass("regClick");
                $(span).addClass("regClick");
                $(ulParent).find("ul").hide("fast");    //隐藏其它已展开的监测点节点
                $(ulParent).find("img.imgCircle").attr({"src": "../img/icon_plus.png", "flagspan": "circle_plus"});    //更新隐藏节点的图标
                if (!$(span).next("ul").is(":visible")) {
                    $(span).next("ul").show("fast");          //展开点击的监测点节点
                    $(span).prev("img.imgCircle").attr({"src": "../img/icon_minus.png", "flagspan": "circle_minus"});
                }
            }
            var regId = $(span).parent().attr("liId");
            turnUrl(regId, chartType);
        }
        function turnUrl(regId, chartType) {		//跳转rights的页面
            $("#navMenu .liNav", top.document).removeClass("aClick");
            top.leftRegId = regId;
            if (typeof(parent.rights.src) == "undefined")	//Object Window
                parent.rights.location = "../chart/showCharts?regId=" + regId + "&chartType=" + chartType;
            else										//Object HTMLFrameElement
                parent.rights.contentWindow.location = "../chart/showCharts?regId=" + regId + "&chartType=" + chartType;
        }
        function mainClick(chartType, regId) {   //接口 → 主页欢迎界面的按钮
            var regSpan = $("#ulTree").find("li[liId='" + regId + "'] > span[flagspan=name]");
            regClick(regSpan, chartType);
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
            width: 100%;
            text-align: left;
        }

        #ulTree {
            margin-left: 2px;
        }

        #ulTree img.imgCircle {
            margin: -2px 2px 0 2px;
            cursor: pointer;
            width: 16px;
        }

        #ulTree img.imgState {
            margin: -2px 2px 0 2px;
            width: 16px;
        }

        #ulTree li {
            padding-top: 3px;
        }

        #ulTree li::after {
            top: 15px;
        }

        #ulTree li span {
            border: none;
            padding: 1px 2px;
        }

        #ulTree li.li_single::after {
            width: 24px;
        }

        #ulTree li:last-child::before {
            height: 15px;
        }

        #ulTree img.png_icon {
            width: 16px;
            float: left;
            margin: 2px 5px 1px 0;
        }

        #ulTree span.regNormal {
            border: 1px solid #999;
            padding: 2px 5px;
            font-weight: bold;
            cursor: pointer;
        }

        #ulTree span.regHover {
            background-color: #FFFCD1;
        }

        #ulTree span.regClick {
            background-color: #FFF57B;
        }

        /*#ulTree li::after{
            width: 10px;
        }*/
        ul {
            margin: 0px 0px 10px 25px;
        }

        #ulTree li.li_single::after {
            width: 19px;
        }

        .tree li::after {
            width: 15px;
        }

        .tree li::before, .tree li::after {
            left: -15px;
        }
    </style>
</head>
<body>
<div id="divMain" class="tree">
    <ul id="ulTree"></ul>
</div>
</body>
</html>
