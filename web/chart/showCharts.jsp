<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE HTML>
<html>
<head>
    <title>设备数据浏览</title>
    <script type="text/javascript" src="../js/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <script type="text/javascript" src="../js/My97DatePicker/WdatePicker.js"></script>
    <link type="text/css" rel="stylesheet" href="../css/cssTab.css"/>
    <link type="text/css" rel="stylesheet" href="../css/style.css"/>
    <script type="text/javascript">
        var id = request("regId");
        var dtBet = "${map.dtBet}";
        var chartType = request("chartType");
        var regName;
        var tabIndex = -1;	//所在标签	0：实时柱状图	1：实时报表
        var hisIndex = -1;	//所在标签	0：历史图表	1：历史数据
        var curIndex = 0;	//所在标签	0：实时数据	1：历史数据
        var mapRegIds = new Map();      //监测点Id → 参数Id_参数类型Id
        var mapParaTypes = new Map();   //参数类型Id → 参数名
        var mapRegPNames = new Map();   //监测点Id → 监测点名
        var chartIndex;     //对应的图表
        var chartIds = "";  //同比对应的图表
        var regIdss = "";   //同比对应的参数Id
        var chartIds_his = "";  //历史同比对应的图表
        var regIdss_his = "";   //历史同比对应的参数Id
        var mapChartRegIds = new Map(); //图表Id → 参数Ids
        var mapHisDates = new Map();    //历史同比的时间配置
        var mapHisContrs = new Map();   //历史同比的同比配置
        var hisInter;   //历史数据间隔 → 1: 趋势图   2: 柱状图
        var hisContrType;   //历史同比 → 图表类型 → 1:趋势图   2:柱状图
        var hisContrInter;  //历史同比 → 时间配置 → 1:天 2:月 3:年
        $(function () {
            $("#dtBet").val(dtBet);
            $("#chartContent > div").hide();	//Initially hide all content
            $("#chartTab .liTag a").attr("class", "aNormal");
            $("#chartTab li:first a").addClass("aCurrent");
            $("#chartContent > div:first").fadeIn();//Show first tab content
            var _thisCon;
            $("#chartTab .liTag a").bind("click", function (e) {
                e.preventDefault();
                if ($(this).hasClass("aCurrent")) {	//detection for current tab

                }
                else {
                    resetTabs();
                    $(this).addClass("aCurrent"); 	//Activate this
                    _thisCon = $($(this).attr('name'));
                    _thisCon.fadeIn(); 	//Show content for current tab
                    $("#chartTab .liCond").hide();
                    $("#" + $(this).attr('flag')).show();
                    switch (_thisCon.attr("flag")) {
                        case "tabVideo":
                            if (typeof($("#iframe0").attr("src")) == "undefined") {
                                aVideo("init");
                            }
                            curIndex = 0;
                            break;
                        case "tabNow":
                            if (typeof($("#iframe1").attr("src")) == "undefined") {
                                aNow("init");
                            }
                            curIndex = 0;
                            break;
                        case "tabHis":
                            if (typeof($("#iframe2").attr("src")) == "undefined") {
                                $("#stDt").val(getMonthDate(1));
                                $("#endDt").val(getMonthDate());
                                aHis("init");
                            }
                            curIndex = 1;
                            break;
                    }
                }
            });
            $("#chartTab a").hover(function () {
                if ($(this).attr("class") != "aCurrent") {
                    $(this).addClass("aHover");
                }
            }, function () {
                if ($(this).attr("class") != "aCurrent") {
                    $(this).removeClass("aHover")
                }
            });
            if (chartType == "undefined") {  //未指定图表类型
                aNow("init");
            }
            else {
                aNow(chartType);
            }
            keyDown();	//捕捉回车事件-刷新
            initContrast();
            initCheckbox();
            iCheckInit();
        });
        function initContrast() {    //初始化同比的参数及设备信息
            /*var pHeight = _height();
             var pWidth = _width();
             var dWidth = pWidth * 0.8 - 70;
             var dHeight = pHeight * 0.8 - 30;
             $("#divContrast .divCont").css({"max-width": dWidth, "max-height": dHeight});*/
            $.ajax({
                type: "post",
                dataType: "json",
                url: "json_initContrast.action",
                success: function callBack(data) {
                    var regIds = data.map.regIds;       //设备Id → 参数Ids
                    var paraTypes = data.map.paraTypes; //参数类型Id → 参数名
                    var regPNames = data.map.regPNames; //监测点Id → 监测点名
                    var mapRegTypesRegIds = new Map();
                    for (var i in regIds) {
                        mapRegTypesRegIds = new Map();
                        for (var j in regIds[i]) {
                            mapRegTypesRegIds.put(regIds[i][j].split("_")[1], regIds[i][j].split("_")[0]);
                        }
                        mapRegIds.put(i + "", mapRegTypesRegIds);
                    }
                    for (var i in paraTypes) {
                        mapParaTypes.put(i + "", paraTypes[i]);
                    }
                    for (var i in regPNames) {
                        mapRegPNames.put(i + "", regPNames[i]);
                    }
                }
            });
        }
        function initCheckbox() {    //初始化checkbook,radio的样式
            chartIndex = $("input:radio:checked").attr("flagIndex");
            $("input:radio[flagType='chart'][flagInput='iCheck']").live("click", function () {    //图表-对应参数节点
                chartIndex = $(this).attr("flagIndex");
                iCheckState($("input:checkbox[flagInput='iCheck']"), false); //取消选择所有确认框
                var regIds = mapChartRegIds.get(chartIndex + "");
                var input;
                var flagIds;
                var flagId;
                if (regIds != null) {
                    for (var i in regIds) {
                        input = $("span[spanId='" + regIds[i] + "'] input");
                        iCheckState(input, true);
                        flagIds = $(input).attr("flagId").split(" ");
                        for (var j in flagIds) {
                            iCheckIsAll(flagIds[j], true);
                        }
                    }
                }
            });
            var regIds;
            var regId;
            var isCheck;    //是否选中
            var flagTop;    //是否为父类型节点
            var flagIds;    //checkbox节点Ids
            var flagId;     //checkbox节点Id
            $("input:checkbox[flagInput='iCheck']").live("click", function () {
                isCheck = $(this).is(':checked');
                flagTop = $(this).hasAttr("flagTop");
                if (isCheck) {  //选中
                    /*同步显示该图表的状态-已选择参数*/
                    $("input:radio[flagindex='" + chartIndex + "']").parent("div").nextAll("span.spanChartFlag").show();
                    if (flagTop) {   //父类型节点, 同步更新对应子节点
                        var flagIds = $(this).attr("flagId").split(" ");
                        for (var i in flagIds) {
                            flagId = flagIds[i];
                            $("input[flagInput='iCheck']").each(function () { //遍历所有该flagId的点,判断是否已全选/反选
                                if (!$(this).hasAttr("flagTop") && hasVal($(this).attr("flagId"), flagId, " ")) { //同flagId子节点
                                    updateRegIds(this);
                                }
                            });
                        }
                    }
                    else {   //选中监测点参数
                        updateRegIds(this);
                    }
                }
                else {   //反选
                    regIds = mapChartRegIds.get(chartIndex + "");
                    if (regIds == null)
                        return true;
                    if (flagTop) {   //父类型节点, 同步更新对应子节点
                        var flagIds = $(this).attr("flagId").split(" ");
                        for (var i in flagIds) {
                            flagId = flagIds[i];
                            $("input[flagInput='iCheck']").each(function () { //遍历所有该flagId的点,判断是否已全选/反选
                                if (!$(this).hasAttr("flagTop") && hasVal($(this).attr("flagId"), flagId, " ")) { //同flagId子节点
                                    regId = $(this).closest("span").attr("spanId");
                                    regIds.splice($.inArray(regId, regIds), 1);
                                    mapChartRegIds.put(chartIndex + "", regIds);
                                }
                            });
                        }
                    }
                    else {
                        regId = $(this).closest("span").attr("spanId");
                        regIds.splice($.inArray(regId, regIds), 1);
                        mapChartRegIds.put(chartIndex + "", regIds);
                    }
                    /*反选后判断对应图表是否包含已选中的参数*/
                    regIds = mapChartRegIds.get(chartIndex + "");
                    var selInput = regIds.length;
                    if (selInput == 0) //更新该图表的状态-无选中的参数
                        $("input:radio[flagindex='" + chartIndex + "']").parent("div").nextAll("span.spanChartFlag").hide();
                }
            });
        }
        function updateRegIds(input) {
            var regIds = mapChartRegIds.get(chartIndex + "");
            if (regIds == null)
                regIds = [];
            var regId = $(input).closest("span").attr("spanId");
            if (regId != -1 && $.inArray(regId, regIds) == -1)    //非无效元素且该元素未添加
                regIds.push(regId);
            mapChartRegIds.put(chartIndex + "", regIds);
        }
        function setHeight() {
            var pheight = document.documentElement.clientHeight;
            var theight = document.getElementById("chartTab").offsetHeight;
            $("#iframe0,#iframe1,#iframe2").height(pheight - theight - 5);
        }
        function resetTabs() {
            $("#chartContent > div").hide(); //Hide all content
            $("#chartTab .liTag a").attr("class", "aNormal"); //Reset id's
        }
        function getcol(a) {
            var button = document.getElementsByName(a);
            for (var i = 0; i < button.length; i++) {
                if (button[i].style.backgroundColor == "") {
                    return i;
                }
            }
        }
        function aVideo(tag) {		//切换实时状态：折线图/柱状图/表格
            if (tag == "now" || tag == "init") {		//折线
                if (tabIndex != 0)
                    $("#iframe0").attr("src", "../video/showNowVideo.jsp?id=" + id);
                tabIndex = 0;
            }
            else if (tag == "his") {		//折线
                if (tabIndex != 1)
                    $("#iframe0").attr("src", "showNowState.jsp?id=" + id);
                tabIndex = 1;
            }
        }
        function aNow(tag) {		//切换实时状态：折线图/柱状图/表格
            id = 4; //测试用
            if (tag == "therm" || tag == "init") {		//折线
                if (tabIndex != 0)
                    $("#iframe1").attr("src", "showThermDiagram.jsp?id=" + id);
                tabIndex = 0;
            }
            else if (tag == "state") {		//折线
                if (tabIndex != 1)
                    $("#iframe1").attr("src", "showNowState.jsp?id=" + id);
                tabIndex = 1;
            }
            else if (tag == "line") {		//折线
                if (tabIndex != 2)
                    $("#iframe1").attr("src", "showNowLine.jsp?id=" + id + "&i=0" + "&dtBet=" + dtBet);
                tabIndex = 2;
            }
            /*if(tag=="column"){		//柱状图
             if(tabIndex!=2)
             $("#iframe1").attr("src","showNowColumn.jsp?id="+id+"&i=0"+"&dtBet="+dtBet);
             tabIndex = 2;
             }*/
            else if (tag == "table") {	//表格
                if (tabIndex != 3)
                    $("#iframe1").attr("src", "showNowTable.action?id=" + id + "&dtBet=" + dtBet);
                tabIndex = 3;
            }
            else if (tag == "contrast") {  //同比
                //$("#iframe1").attr("src","showNowTable.action?id="+id+"&dtBet="+dtBet);
                aContrast();    //弹出同比配置窗口
                //tabIndex = 3;
            }
            $("#now a:lt(5)").css("background-color", "gray");          //初始化
            $("#now a:eq(" + tabIndex + ")").css("background-color", "");   //显示对应的按钮
            if (typeof(tag) == "undefined") {	//刷新
                var dtBet_ = $("#dtBet").val();
                if (dtBet_ != "" && dtBet_ != dtBet && isUNaN(dtBet_)) {	//更新数据点数
                    $.ajax({
                        type: "post",
                        dataType: "json",
                        url: "synchDtBet?regId=" + id + "&dtBet=" + dtBet_,
                        success: function callBack(data) {
                            dtBet = dtBet_;
                        }
                    });
                }
                if (tabIndex < 3) {	//折线图/柱状图
                    $("#iframe1").attr("src", transNowChart(tabIndex) + "?id=" + id + "&i=0" + "&dtBet=" + dtBet_);
                }
                else if (tabIndex == 3) {  //表格
                    $("#iframe1").attr("src", "showNowTable.action?id=" + id + "&dtBet=" + dtBet_);
                }
                else {   //同比
                    $("#iframe1").attr("src", "showNowContrast.jsp?regIdss=" + regIdss + "&dtBet=" + dtBet_);
                }
            }
        }
        function aHis(tag) {		//切换历史数据：柱状图/表格
            compareDate("stDt", "endDt");
            var stDt = $("#stDt").val();
            var endDt = $("#endDt").val();
            if (tag == "init") {    //默认: 趋势图 → 按日分组
                hisInter = 0;
                saveHisInter();
            }
            else if (tag == "line") {	//趋势图
                /*if(hisIndex!=0)
                 $("#iframe2").attr("src","showHisLine.jsp?id="+id+"&stDt="+stDt+"&endDt="+endDt);
                 hisIndex = 0;*/
                aHisInter();   //弹出数据间隔配置
                hisInter = 0;
            }
            else if (tag == "column") {
                /*if(hisIndex!=1)
                 $("#iframe2").attr("src","showHisColumn.jsp?id="+id+"&stDt="+stDt+"&endDt="+endDt);
                 hisIndex = 1;*/
                aHisInter();   //弹出数据间隔配置
                hisInter = 1;
            }
            else if (tag == "table") {
                /*if(hisIndex!=2)
                 $("#iframe2").attr("src","showHisTable?id="+id+"&stDt="+stDt+"&endDt="+endDt);
                 hisIndex = 2;*/
                aHisInter();   //弹出数据间隔配置
                hisInter = 2;
            }
            else if (tag == "contrast") {  //同比
                aContrast_his();    //弹出同比配置窗口
            }
            else if (typeof(tag) == "undefined") {	//刷新
                if (hisIndex == 0) {	    //趋势图
                    //$("#iframe2").attr("src","showHisLine.jsp?id="+id+"&stDt="+stDt+"&endDt="+endDt);
                    saveHisInter();
                }
                else if (hisIndex == 1) {   //柱状图
                    //$("#iframe2").attr("src","showHisColumn.jsp?id="+id+"&stDt="+stDt+"&endDt="+endDt);
                    saveHisInter();
                }
                else if (hisIndex == 2) {   //报表
                    //$("#iframe2").attr("src","showHisTable?id="+id+"&stDt="+stDt+"&endDt="+endDt);
                    saveHisInter();
                }
                else {   //同比
                    saveContrast_his();
                }
            }
            $("#history a:lt(4)").css("background-color", "gray");          //初始化
            $("#history a:eq(" + hisIndex + ")").css("background-color", "");   //显示对应的按钮
        }
        function outNow() {			//导出当前信息
            iframe1.out();
            //$("#iframe1").contents().find("#outNow").click();
        }
        function outHis() {			//导出历史记录
            iframe2.out();
            //$("#iframe2").contents().find("#outHis").click();
        }
        function windowTest() {		//新建窗口，在窗口中显示实时的图表
            $("#iframe1")[0].contentWindow.windowTest();
        }
        function liSort(arr) {		//改变设备参数的显示顺序
            if ($("#chartTab1").css("display") != "none")
                $("#iframe1")[0].contentWindow.liSort(arr);
            else
                $("#iframe2")[0].contentWindow.liSort(arr);
        }
        function keyDown() {
            $("body").keydown(function (event) {
                if (event.keyCode == "13") {	//keyCode=13是回车键
                    if (curIndex == 0)
                        aNow();
                }
            });
        }
        function transNowChart(index) {
            if (index == 0)    //状态
                return "showNowState.jsp";
            else            //折线图
                return "showNowLine.jsp";
        }
        function aContrast() {   //弹出同比选择窗口
            $("#detail_bg").show();
            $("#divContrast").show();
            var paraHtml = "";
            paraHtml += "<li><span class='spanPoint'></span>";
            var id, value;
            for (var i in mapParaTypes.arr) { //第一行显示监测参数
                id = mapParaTypes.arr[i].key;
                value = mapParaTypes.arr[i].value;
                paraHtml += "<span class='spanParaType' spanId='" + id + "'>" +
                        "<div class='icheckbox_green'>" +
                        "<input type='checkbox' id='chk_para_" + id + "' flagInput='iCheck' flagId='" + id + "' flagTop>" +
                        "</div>" +
                        "<label for='chk_para_" + id + "' flagInput='iCheck'>" + value + "</label>" +
                        "</span>";
            }
            paraHtml += "</li>";
            var regId;  //参数Id
            var colParaTypeId;  //当前列对应的参数类型Id
            for (var i in mapRegPNames.arr) {     //每行第一列显示监测点
                id = mapRegPNames.arr[i].key;   //监测点Id
                value = mapRegPNames.arr[i].value;
                paraHtml += "<li><span class='spanPoint' spanId='" + id + "'>" +
                        "<div class='icheckbox_green'>" +
                        "<input type='checkbox' id='checkbox_point_" + id + "' flagInput='iCheck' flagId='" + id + "' flagTop>" +
                        "</div>" +
                        "<label for='checkbox_point_" + id + "' flagInput='iCheck'>" + value + "</label>" +
                        "</span>";
                var mapRegTypesRegIds = mapRegIds.get(id + "");
                if (mapRegTypesRegIds == null) {   //该监测点没有参数
                    for (var j in mapParaTypes.arr) {
                        paraHtml += "<span class='spanPara' spanId='-1'><div class='icheckbox_green null'></div></span>";
                    }
                }
                else {
                    for (var j in mapParaTypes.arr) {
                        colParaTypeId = mapParaTypes.arr[j].key;    //本列的参数类型Id
                        regId = mapRegTypesRegIds.get(colParaTypeId + "");
                        if (regId == null || regId == "")   //该监测点没有该类参数
                            paraHtml += "<span class='spanPara' spanId='-1'><div class='icheckbox_green null'></div></span>";
                        else {
                            paraHtml += "<span class='spanPara' spanId='" + regId + "'>" +
                                    "<div class='icheckbox_green'>" +
                                    "<input type='checkbox' id='checkbox_" + i + "_" + j + "' flagInput='iCheck' flagId='" + id + " " + colParaTypeId + "'>" +
                                    "</div>" +
                                    "</span>";
                        }
                    }
                }
                paraHtml += "</li>";
            }
            $("#ulParaConts").html(paraHtml);
            /*初始化对应图表*/
            $("#spanChart span.spanPara:gt(0)").remove();
            $("#spanChart span.spanChartFlag").hide();
            $("#spanChart input:radio").attr("checked", true).parent("div").addClass("checked");
            chartIndex = 0;
            $("#contAlarm").empty();
            /*初始化结束*/
            var pHeight = _height();
            var heightCont = pHeight * 0.8 - 30 - 56 - 50; //80%的整体高度-其他内容高度
            $("#ulParaConts").css("max-height", heightCont);
            beCenter("divContrast");
            initContrastData();
        }
        function checkDiv(input) {
            if ($(input).is(':checked'))
                $(input).parent("div").addClass("checked");
            else
                $(input).parent("div").removeClass("checked");
        }
        function addChart(isInit) {    //添加图表
            var flagIndex = $("#spanChart span.spanPara").length;
            var chartId = "radio_chart_" + flagIndex;
            var chartName = "图表" + (parseInt(flagIndex) + 1);
            var htmlChart = "<span class='spanPara'>" +
                    "<div class='iradio_green'>" +
                    "<input type='radio' id='" + chartId + "' name='radio_chart' flagType='chart' flagInput='iCheck' flagIndex='" + flagIndex + "'>" +
                    "</div>" +
                    "<label for='" + chartId + "' flagInput='iCheck'>" + chartName + "</label>" +
                    "<span class='spanChartFlag hide'>●</span>" +
                    "</span>";
            $(htmlChart).insertBefore($("#spanChart span.spanBtn"));
            if (typeof(isInit) == "undefined") //初始化的时候不自动点击
                $("#" + chartId).click(); //添加后默认切换到新的图表
        }
        function saveContrast() {    //保存同比的配置
            /*var isSelChart = mapChartRegIds.arr.length;
             if(isSelChart==0){  //未选中图表
             $("#contAlarm").html("请先选择同比的参数");
             return;
             }*/
            var chartIndex; //图表index
            var regIds;     //图表对应的参数Id
            chartIds = "";
            regIdss = "";
            for (var i in mapChartRegIds.arr) {
                if (mapChartRegIds.arr[i].value == "")
                    continue;
                chartIndex = mapChartRegIds.arr[i].key;
                if (chartIndex.indexOf("_his") > -1)   //历史同比的配置
                    continue;
                regIds = "";
                for (var j in mapChartRegIds.arr[i].value) {
                    regIds += mapChartRegIds.arr[i].value[j] + ",";
                }
                chartIds += chartIndex + ";";
                regIdss += regIds.substring(0, regIds.length - 1) + ";";
            }
            if (chartIds.trim().length == 0) {  //未选中图表
                $("#contAlarm").html("请先选择同比的参数");
                return;
            }
            chartIds = chartIds.substring(0, chartIds.length - 1);
            regIdss = regIdss.substring(0, regIdss.length - 1);
            tabIndex = 4;
            $("#now a:lt(5)").css("background-color", "gray");  //初始化
            $("#now a:eq(4)").css("background-color", "");      //显示对应的按钮
            $("#divContrast, #detail_bg").hide();
            $("#iframe1").attr("src", "showNowContrast.jsp?regIdss=" + regIdss + "&dtBet=" + dtBet);
        }
        function initContrastData() {    //显示已保存的同比配置
            var mapNew = new Map();
            var mapKey;
            for (var i in mapChartRegIds.arr) {   //清空保存的实时同比配置
                mapKey = mapChartRegIds.arr[i].key;
                if (mapKey.indexOf("_his") > -1)
                    mapNew.put(mapKey + "", mapChartRegIds.arr[i].value);
            }
            mapChartRegIds = mapNew;
            if (chartIds == "" || regIdss == "")   //没有已保存的同比配置
                return;
            var regIds = regIdss.split(";");    //所有已选中参数
            var ids;    //单张图表对应的参数
            var span;   //已选中的参数
            var flagId;
            var flagIds = [];
            for (var i in regIds) {    //已配置的参数Id
                if (i > 0)
                    addChart(0); //添加新图表
                $("#spanChart input:radio[flagindex='" + i + "']").parent("div").nextAll("span.spanChartFlag").show();
                ids = regIds[i].split(",");
                mapChartRegIds.put(i + "", ids);
                if (i == 0) {  //默认显示第一个图表的已选中参数
                    for (var j in ids) {
                        span = $("#ulParaConts span.spanPara[spanId='" + ids[j] + "']");
                        $(span).find("div").addClass("checked");
                        $(span).find("input").attr("checked", true).attr("chartIndex", i);
                        $(span).find("label").show();
                        iCheckState($(span).find("input"), true);
                        flagId = $(span).find("input").attr("flagId").split(" ");
                        for (var k in flagId) {   //存储flagId,判断并更新同一flagId的父节点状态
                            if ($.inArray(flagId[k], flagIds) == -1)
                                flagIds.push(flagId[k]);
                        }
                    }
                    for (var id in flagIds) { //遍历所有的flagId类型
                        iCheckIsAll(flagIds[id]);
                    }
                }
            }
        }
        function aContrast_his() {   //弹出同比选择窗口
            $("#detail_bg").show();
            $("#divContrast_his").show();
            var paraHtml = "";
            paraHtml += "<li><span class='spanPoint'></span>";
            var id, value;
            for (var i in mapParaTypes.arr) { //第一行显示监测参数
                id = mapParaTypes.arr[i].key;
                value = mapParaTypes.arr[i].value;
                paraHtml += "<span class='spanParaType' spanId='" + id + "'>" +
                        "<div class='icheckbox_green'>" +
                        "<input type='checkbox' id='chk_para_" + id + "_his' flagInput='iCheck' flagId='" + id + "_his' flagTop>" +
                        "</div>" +
                        "<label for='chk_para_" + id + "_his' flagInput='iCheck'>" + value + "</label>" +
                        "</span>";
            }
            paraHtml += "</li>";
            var regId;  //参数Id
            var colParaTypeId;  //当前列对应的参数类型Id
            for (var i in mapRegPNames.arr) {     //每行第一列显示监测点
                id = mapRegPNames.arr[i].key;   //监测点Id
                value = mapRegPNames.arr[i].value;
                paraHtml += "<li><span class='spanPoint' spanId='" + id + "'>" +
                        "<div class='icheckbox_green'>" +
                        "<input type='checkbox' id='checkbox_point_" + id + "_his' flagInput='iCheck' flagId='" + id + "_his' flagTop>" +
                        "</div>" +
                        "<label for='checkbox_point_" + id + "_his' flagInput='iCheck'>" + value + "</label>" +
                        "</span>";
                var mapRegTypesRegIds = mapRegIds.get(id + "");
                if (mapRegTypesRegIds == null) {   //该监测点没有参数
                    for (var j in mapParaTypes.arr) {
                        paraHtml += "<span class='spanPara' spanId='-1'><div class='icheckbox_green null'></div></span>";
                    }
                }
                else {
                    for (var j in mapParaTypes.arr) {
                        colParaTypeId = mapParaTypes.arr[j].key;    //本列的参数类型Id
                        regId = mapRegTypesRegIds.get(colParaTypeId + "");
                        if (regId == null || regId == "")   //该监测点没有该类参数
                            paraHtml += "<span class='spanPara' spanId='-1'><div class='icheckbox_green null'></div></span>";
                        else {
                            paraHtml += "<span class='spanPara' spanId='" + regId + "'>" +
                                    "<div class='icheckbox_green'>" +
                                    "<input type='checkbox' id='checkbox_" + i + "_" + j + "_his' flagInput='iCheck' flagId='" + id + "_his " + colParaTypeId + "_his'>" +
                                    "</div>" +
                                    "</span>";
                        }
                    }
                }
                paraHtml += "</li>";
            }
            $("#ulParaConts_his").html(paraHtml);
            /*初始化对应图表*/
            /*$("#spanChart_his span.spanPara:gt(0)").remove();
             $("#spanChart_his span.spanChartFlag").hide();
             $("#spanChart_his input:radio").attr("checked", true).parent("div").addClass("checked");*/
            chartIndex = "0_his";
            $("#contAlarm_his").empty();
            /*初始化结束*/
            var pHeight = _height();
            var heightCont = pHeight * 0.8 - 30 - 56 - 113; //80%的整体高度-其他内容高度
            $("#ulParaConts_his").css("max-height", heightCont);
            beCenter("divContrast_his");
            cancelDate_his();   //时间选择-初始化
            cancelContr_his();  //历史同比-初始化
            initContrastData_his(); //还原已保存的配置
        }
        function initContrastData_his() {    //显示已保存的同比配置
            var mapNew = new Map();
            var mapKey;
            for (var i in mapChartRegIds.arr) {   //清空保存的历史同比配置
                mapKey = mapChartRegIds.arr[i].key;
                if (mapKey.indexOf("_his") == -1)
                    mapNew.put(mapKey + "", mapChartRegIds.arr[i].value);
            }
            mapChartRegIds = mapNew;
            if (chartIds_his == "" || regIdss_his == "")   //没有已保存的同比配置
                return;
            var regIds = regIdss_his.split(";");    //所有已选中参数
            var ids;    //单张图表对应的参数
            var span;   //已选中的参数
            var flagId;
            var flagIds = [];
            for (var i in regIds) {    //已配置的参数Id
                /*if(i>0)
                 addChart_his(0); //添加新图表
                 $("#spanChart_his input:radio[flagindex='"+i+"_his']").parent("div").nextAll("span.spanChartFlag").show();*/
                ids = regIds[i].split(",");
                mapChartRegIds.put(i + "_his", ids);
                if (i == 0) {  //默认显示第一个图表的已选中参数
                    for (var j in ids) {
                        span = $("#ulParaConts_his span.spanPara[spanId='" + ids[j] + "']");
                        $(span).find("div").addClass("checked");
                        $(span).find("input").attr("checked", true).attr("chartIndex", i);
                        $(span).find("label").show();
                        iCheckState($(span).find("input"), true);
                        flagId = $(span).find("input").attr("flagId").split(" ");
                        for (var k in flagId) {   //存储flagId,判断并更新同一flagId的父节点状态
                            if ($.inArray(flagId[k], flagIds) == -1)
                                flagIds.push(flagId[k]);
                        }
                    }
                    for (var id in flagIds) { //遍历所有的flagId类型
                        iCheckIsAll(flagIds[id]);
                    }
                }
            }
            var flagDate = mapHisDates.get("flag");
            if (flagDate != null) { //已配置了时间
                iCheckState($("#spanDate_his").find("span.spanPara:eq(" + flagDate + ") input"), true);
                if (flagDate == 3) {    //时间选择-更多
                    addDate_his();
                    $("#stDt_his").val(mapHisDates.get("stDt"));
                    $("#endDt_his").val(mapHisDates.get("endDt"));
                }
            }
            var flagContr = mapHisContrs.get("flag");
            if (flagContr != null) {    //已配置了同比
                iCheckState($("#spanContr_his").find("span.spanPara:eq(" + flagContr + ") input"), true);
                if (flagContr == 3) {    //历史同比-更多
                    addContr_his();
                    $("#stDt_his_contr").val(mapHisContrs.get("stDt"));
                }
            }
        }
        /*function addChart_his(isInit){    //历史同比-添加图表
         var flagIndex = $("#spanChart_his span.spanPara").length;
         var chartId = "radio_chart_"+flagIndex+"_his";
         var chartName = "图表"+(flagIndex+1);
         var htmlChart = "<span class='spanPara'>" +
         "<div class='iradio_green'>"+
         "<input type='radio' id='"+chartId+"' name='radio_chart_his' flagType='chart' flagInput='iCheck' flagIndex='"+flagIndex+"_his'>"+
         "</div>"+
         "<label for='"+chartId+"' flagInput='iCheck'>"+chartName+"</label>" +
         "<span class='spanChartFlag hide'>●</span>"+
         "</span>";
         $(htmlChart).insertBefore($("#spanChart_his span.spanBtn"));
         if(typeof(isInit)=="undefined") //初始化的时候不自动点击
         $("#"+chartId).click(); //添加后默认切换到新的图表
         }*/
        function saveContrast_his() {    //保存同比的配置
            var chartIndex; //图表index
            var regIds;     //图表对应的参数Id
            chartIds_his = "";
            regIdss_his = "";
            for (var i in mapChartRegIds.arr) {
                if (mapChartRegIds.arr[i].value == "")
                    continue;
                chartIndex = mapChartRegIds.arr[i].key;
                if (chartIndex.indexOf("_his") == -1)   //实时同比的配置
                    continue;
                regIds = "";
                for (var j in mapChartRegIds.arr[i].value) {
                    regIds += mapChartRegIds.arr[i].value[j] + ",";
                }
                chartIndex = chartIndex.split("_")[0];  //0_his → 0
                chartIds_his += chartIndex + ";";
                regIdss_his += regIds.substring(0, regIds.length - 1) + ";";
            }
            if (chartIds_his.trim().length == 0) {  //未选中图表
                $("#contAlarm_his").html("请先选择同比的参数");
                return;
            }
            chartIds_his = chartIds_his.substring(0, chartIds_his.length - 1);
            regIdss_his = regIdss_his.substring(0, regIdss_his.length - 1);
            hisIndex = 3;
            $("#history a:lt(3)").css("background-color", "gray");  //初始化
            $("#history a:eq(3)").css("background-color", "");      //显示对应的按钮
            $("#divContrast_his, #detail_bg").hide();
            mapHisDates = new Map();
            mapHisContrs = new Map();
            var stDt, endDt;    //历史同比的开始时间,结束时间
            var isDateMore = $("#radio_date_more").is(":checked");   //是否额外选择时间
            if (isDateMore) { //已选择具体的时间
                stDt = $("#stDt_his").val();
                endDt = $("#endDt_his").val();
                mapHisDates.put("flag", 3);
            }
            else {
                var radio_date = $("#spanDate_his input:radio[name='radio_date']:checked").val();
                var radioDates = getRadioDate(parseInt(radio_date));
                stDt = radioDates[0];
                endDt = radioDates[1];
                mapHisDates.put("flag", parseInt(radio_date));
            }
            mapHisDates.put("stDt", stDt);
            mapHisDates.put("endDt", endDt);
            var isContrCancel = $("#radio_contr_0_his").is(":checked"); //是否选择同比
            var isContrMore = $("#radio_contr_more").is(":checked"); //是否额外选择同比
            var stDt_contr = ""; //历史同比-历史同比时间选择
            if (isContrMore) {
                stDt_contr = $("#stDt_his_contr").val();
                mapHisContrs.put("flag", 3);
                mapHisContrs.put("stDt", stDt_contr);
            }
            else if (!isContrCancel) {
                var radio_date = $("#spanContr_his input:radio[name='radio_contr']:checked").val();
                stDt_contr = getRadioContr(stDt, parseInt(radio_date));
                mapHisContrs.put("flag", parseInt(radio_date));
                mapHisContrs.put("stDt", stDt_contr);
            }
            else
                mapHisContrs.put("flag", 0);
            hisContrType = $("#ulContrast_his input[name='radio_type_his']:checked").val();     //图表类型
            hisContrInter = $("#ulContrast_his input[name='radio_inter_his']:checked").val();   //时间间隔
            $("#iframe2").attr("src", "showHisContrast.jsp?regIds=" + regIdss_his + "&stDt=" + stDt + "&endDt=" + endDt + "&stDtContr="
                    + stDt_contr + "&chartType=" + hisContrType + "&hisInter=" + hisContrInter);
            $("#stDt").val(stDt);
            $("#endDt").val(endDt);
        }
        function addDate_his() { //历史同比-时间选择-更多
            $("#spanDate_his").find("span.spanPara:lt(3)").hide();
            $("#spanDate_his").find("span.spanPara:eq(3)").show();
            $("#spanDate_his").find("a[flagBtn='aCancel']").show();
            $("#stDt_his").val(getMonthDate(1));    //默认一个月
            $("#endDt_his").val(getMonthDate());
        }
        function cancelDate_his() {  //历史同比-时间选择-取消
            $("#spanDate_his").find("span.spanPara:lt(3)").show();
            iCheckState($("#spanDate_his").find("span.spanPara:eq(2) input"), false);
            $("#spanDate_his").find("span.spanPara:eq(3)").hide();
            $("#spanDate_his").find("a[flagBtn='aCancel']").hide();
        }
        function addContr_his() {
            $("#spanContr_his").find("span.spanPara:lt(4)").hide();
            $("#spanContr_his").find("span.spanPara:eq(4)").show();
            $("#spanContr_his").find("a[flagBtn='aCancel']").show();
        }
        function cancelContr_his() {
            $("#spanContr_his").find("span.spanPara:lt(4)").show();
            iCheckState($("#spanContr_his").find("span.spanPara:eq(3) input"), false);
            $("#spanContr_his").find("span.spanPara:eq(4)").hide();
            $("#spanContr_his").find("a[flagBtn='aCancel']").hide();
        }
        function getRadioDate(radioDate) {   //返回历史同比-时间选择的具体时间
            var radioDates = [];
            var stDt;
            var endDt = getNowDate();
            switch (radioDate) {
                case 0:     //30天内
                    stDt = getNowDate(30);
                    break;
                case 1:     //7天内
                    stDt = getNowDate(7);
                    break;
                case 2:     //今日
                    stDt = getNowDate(0);
                    break;
            }
            radioDates.push(stDt);
            radioDates.push(endDt);
            return radioDates;
        }
        function getRadioContr(stDt, radioContr) { //返回历史同比-同比开始时间
            var stDt;
            switch (radioContr) {
                case 1:     //去年同时期
                    stDt = getBeforeDate(stDt, 1, 1);
                    break;
                case 2:     //上月份
                    stDt = getBeforeDate(stDt, 2, 1);
                    break;
            }
            return stDt;
        }
        function aHisInter() {  //历史柱状图配置
            $("#detail_bg").show();
            $("#divHisColumn").show();
            beCenter("divHisColumn");
        }
        function saveHisInter() {
            var stDt = $("#stDt").val();
            var endDt = $("#endDt").val();
            var columnState = $("#divHisColumn").find("input:checked").val();
            $("#history a:lt(4)").css("background-color", "gray");  //初始化
            switch (hisInter) {
                case 0:
                    $("#iframe2").attr("src", "showHisLine.jsp?id=" + id + "&stDt=" + stDt + "&endDt=" + endDt + "&hisInter=" + columnState);
                    hisIndex = 0;
                    $("#history a:eq(0)").css("background-color", "");      //显示对应的按钮
                    break;
                case 1:
                    $("#iframe2").attr("src", "showHisColumn.jsp?id=" + id + "&stDt=" + stDt + "&endDt=" + endDt + "&hisInter=" + columnState);
                    hisIndex = 1;
                    $("#history a:eq(1)").css("background-color", "");      //显示对应的按钮
                    break;
                case 2:
                    $("#iframe2").attr("src", "showHisTable?id=" + id + "&stDt=" + stDt + "&endDt=" + endDt + "&hisInter=" + columnState);
                    hisIndex = 2;
                    $("#history a:eq(2)").css("background-color", "");      //显示对应的按钮
                    break;
            }
            $("#detail_bg").hide();
            $("#divHisColumn").hide();
        }
    </script>
    <style>
        html {
            height: 100%;
        }

        body {
            font-size: 14px;
            height: 100%;
            margin: 0;
        }

        table {
            table-layout: fixed;
        }

        td {
            word-break: break-all;
            word-wrap: break-word;
        }

        button {
            height: 22px;
            line-height: 0;
            padding: 0;
            margin: 0;
            width: 50px
        }

        .aBtn {
            margin-left: 5px;
            padding: 4px 8px
        }

        .aFirst {
            margin-left: 7px;
        }

        .classContrast {
            position: absolute;
            display: none;
            z-index: 50005;
            border: 0;
            padding: 1px;
            border-radius: 5px;
            background: white;
            text-align: left;
            color: #333;
        }

        .classContrast .divTitle {
            min-height: 16.43px;
            padding: 15px;
            border-bottom: 1px solid #e5e5e5;
        }

        .classContrast .divTitle h4.modal-title {
            margin: 0;
            line-height: 1.42857143;
            font-size: 18px;
            display: inline-block;
        }

        .classContrast .divTitle h4.modal-alarm {
            color: red;
            margin-left: 20px;
            font-size: 17px;
        }

        .classContrast .divTitle button.btnClose {
            -webkit-appearance: none;
            padding: 0;
            cursor: pointer;
            background: 0 0;
            border: 0;
            float: right;
            font-size: 21px;
            font-weight: 700;
            line-height: 1;
            color: #000;
            text-shadow: 0 1px 0 #fff;
            filter: alpha(opacity=20);
            opacity: .2;
            width: auto;
            height: auto;
        }

        .classContrast .divTitle button.btnClose:hover {
            filter: alpha(opacity=40);
            opacity: .4;
        }

        .classContrast .divCont {
            margin: 15px 35px;
            overflow: auto;
        }

        .classContrast ul, .classContrast li {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .classContrast li.liTag, .classContrast li.liChartType, .classContrast li.liCont {
            margin-bottom: 10px;
        }

        .classContrast li.liBtn {
            text-align: center;
            margin: 3px 0;
        }

        .classContrast a {
            font-size: 15px;
            padding: 7px 12px 8px;
        }

        .classContrast a.aDefault {
            font-size: 14px;
            padding: 4px 8px;
        }

        .classContrast li.liTag span.spanTitle {
            line-height: 35px;
        }

        .classContrast span.spanTitle {
            line-height: 24px;
            font-size: 16px;
            float: left;
            font-weight: bold;
            color: #217FA7;
        }

        .ulParaConts {
            display: inline-block;
            overflow-y: auto;
        }

        .ulParaConts li {
            margin-bottom: 7px;
        }

        .ulParaConts span.spanPoint {
            width: 100px;
            display: inline-block;
            margin-right: 10px;
        }

        .ulContrast span.spanPara, .ulContrast span.spanParaType {
            width: 95px;
            display: inline-block;
            text-align: left;
        }

        .ulParaConts span.spanPoint span, .ulParaConts span.spanPara span {
            vertical-align: super;
            margin-left: 3px;
        }

        .ulContrast li.liBtn a {
            font-size: 16px;
            padding: 8px 15px;
        }

        .ulContrast span.spanPoint label, .ulContrast span.spanPara label, .ulContrast span.spanParaType label {
            cursor: pointer;
            margin-left: 3px;
        }

        .ulContrast span.spanPara label.labelFlag {
            font-size: 17px;
            display: none;
            color: orange;
            margin-left: 10px;
        }

        .spanChart span.spanPara {
            width: auto;
            margin-right: 20px;
        }

        .spanChart span.spanPara span.spanChartFlag {
            vertical-align: inherit;
            font-size: 17px;
            color: mediumpurple;
        }

        .ulContrast span.spanHide {
            display: none;
        }

        .aHide {
            display: none;
        }

        ul.ulParaConts {
            padding-right: 15px;
            white-space: nowrap;
        }
    </style>
</head>
<body>
<ul id="chartTab" class="tabs">
    <li class='liTag'><a href="#" name="#chartTab0" flag="video">视频监控</a></li>
    <li id="videoNow" class="liCond">
        <a class="aBtn aRed aFirst" href="javascript:" onclick="aVideo('now');">实时记录</a>
        <a class="aBtn aRed aGray" href="javascript:" onclick="aVideo('his');">历史记录</a>
    </li>
    <li class='liTag' style="margin-left:8px;"><a href="#" name="#chartTab1" flag="now">实时数据</a></li>
    <li id="now" class="liCond hide">
        <a class="aBtn aRed aFirst" href="javascript:" onclick="aNow('therm');">热力图</a>
        <a class="aBtn aRed" href="javascript:" onclick="aNow('state');">状态图</a>
        <a class="aBtn aRed" href="javascript:" onclick="aNow('line');">趋势图</a>
        <!--<a class="aBtn aRed" href="javascript:" onclick="aNow('column');">柱形图</a>-->
        <a class="aBtn aRed" href="javascript:" onclick="aNow('table');">报 表</a>
        <a class="aBtn aRed" href="javascript:" onclick="aNow('contrast');">同 比</a>
        数据点数：<input id="dtBet" class="inputText" Style="width:50px;height:18px;" value="100">
        <a class="aBtn aDetail" href="javascript:" onclick="aNow();">刷 新</a>
        <a class="aBtn aOut" href="javascript:" onclick="outNow();">导 出</a>
    </li>
    <li class='liTag' style="margin-left:8px;"><a href="#" name="#chartTab2" flag="history">历史数据</a></li>
    <li id="history" class="liCond hide">
        开始：<input id="stDt" name="stDt" class="Wdate" style="width:90px;" onclick="WdatePicker()" readonly
                  onfocus="WdatePicker({minDate:'2015-01-01',maxDate:'#F{$dp.$D(\'endDt\',{d:0});}'})">
        结束：<input id="endDt" name="endDt" class="Wdate" style="width:90px;" onclick="WdatePicker()" readonly
                  onfocus="WdatePicker({minDate:'#F{$dp.$D(\'stDt\',{d:0});}',maxDate:'%y-%M-#{%d+1}'})">
        <a class="aBtn aRed" href="javascript:" onclick="aHis('line');">趋势图</a>
        <a class="aBtn aRed" href="javascript:" onclick="aHis('column');">柱状图</a>
        <a class="aBtn aRed" href="javascript:" onclick="aHis('table');">报 表</a>
        <a class="aBtn aRed" href="javascript:" onclick="aHis('contrast');">同 比</a>
        <a class="aBtn aDetail" href="javascript:" onclick="aHis();">刷 新</a>
        <a id="aOut2" class="aBtn aOut" href="javascript:" onclick="outHis();">导 出</a>
    </li>
</ul>
<div id="chartContent" class="tabContent">
    <div id="chartTab0" flag="tabVideo">
        <iframe id="iframe0" name="iframe0" frameborder="0" onload="setHeight()" scrolling="auto" width="100%"></iframe>
    </div>
    <div id="chartTab1" flag="tabNow">
        <iframe id="iframe1" name="iframe1" frameborder="0" onload="setHeight()" scrolling="auto" width="100%"></iframe>
    </div>
    <div id="chartTab2" flag="tabHis">
        <iframe id="iframe2" name="iframe2" frameborder="0" onload="setHeight()" width="100%"></iframe>
    </div>
</div>
<div id="detail_bg"></div>
<!-- 实时同比 -->
<div id="divContrast" class="divFloat div_alt classContrast">
    <div class="divTitle">
        <button class="btnClose" onclick="closeDiv('divContrast')"><span>×</span></button>
        <h4 class="modal-title">实时同比配置</h4><h4 id="contAlarm" class="modal-title modal-alarm"></h4>
    </div>
    <div class="divCont">
        <ul id="ulContrast" class="ulContrast">
            <li class="liChartType">
                <span class="spanTitle">
                    <span>对应图表：</span>
                </span>
                <span class="spanCont spanChart" id="spanChart">
                    <span class="spanPara">
                        <div class="iradio_green checked">
                            <input type="radio" id="radio_chart_0" flagType="chart" name="radio_chart"
                                   flagInput='iCheck' flagIndex="0" checked>
                        </div>
                        <label for="radio_chart_0" flagInput='iCheck'>图表1</label>
                        <span class="spanChartFlag hide">●</span>
                    </span>
                    <span class="spanBtn">
                        <a class="aBtn aDetail aDefault" href="javascript:" onclick="addChart();">添 加</a>　
                    </span>
                </span>
            </li>
            <li class="liCont">
                <span class="spanTitle">
                    <span>参数筛选：</span>
                </span>
                <span class="spanCont">
                    <ul id="ulParaConts" class="ulParaConts">
                    </ul>
                </span>
            </li>
            <li class="liBtn">
                <a class='aBtn aOut' href='javascript:' onclick="saveContrast()">确 定</a>　　　
                <a class='aBtn aGray' href='javascript:' onclick="closeDiv('divContrast')">取 消</a>
            </li>
        </ul>
    </div>
</div>
<!-- 历史同比 -->
<div id="divContrast_his" class="divFloat div_alt classContrast">
    <div class="divTitle">
        <button class="btnClose" onclick="closeDiv('divContrast_his')"><span>×</span></button>
        <h4 class="modal-title">历史同比配置</h4><h4 id="contAlarm_his" class="modal-title modal-alarm"></h4>
    </div>
    <div class="divCont">
        <ul id="ulContrast_his" class="ulContrast">
            <!--<li class="liChartType">
                <span class="spanTitle">
                    <span>对应图表：</span>
                </span>
                <span class="spanCont spanChart" id="spanChart_his">
                    <span class="spanPara">
                        <div class="iradio_green checked">
                            <input type="radio" id="radio_chart_0_his" flagType="chart" name="radio_chart_his" flagInput='iCheck' flagIndex="0_his" checked>
                        </div>
                        <label for="radio_chart_0_his" flagInput='iCheck'>图表1</label>
                        <span class="spanChartFlag hide">●</span>
                    </span>
                    <span class="spanBtn">
                        <a class="aBtn aDetail aDefault" href="javascript:" onclick="addChart_his();">添 加</a>　
                    </span>
                </span>
            </li>-->
            <li class="liChartType">
                <span class="spanTitle">
                    <span>图表配置：</span>
                </span>
                <span class="spanCont spanChart">
                    <span class="spanPara">
                        <div class="iradio_green checked">
                            <input type="radio" id="radio_type_0_his" flagType="chart" name="radio_type_his"
                                   flagInput='iCheck' value="1" checked>
                        </div>
                        <label for="radio_type_0_his" flagInput='iCheck'>趋势图</label>
                    </span>
                    <span class="spanPara">
                        <div class="iradio_green">
                            <input type="radio" id="radio_type_1_his" flagType="chart" name="radio_type_his"
                                   flagInput='iCheck' value="2">
                        </div>
                        <label for="radio_type_1_his" flagInput='iCheck'>柱状图</label>
                    </span>
                </span>
            </li>
            <li class="liChartType">
                <span class="spanTitle">
                    <span>时间间隔：</span>
                </span>
                <span class="spanCont spanChart">
                    <span class="spanPara">
                        <div class="iradio_green checked">
                            <input type="radio" id="radio_inter_0_his" flagType="chart" name="radio_inter_his"
                                   flagInput='iCheck' value="1" checked>
                        </div>
                        <label for="radio_inter_0_his" flagInput='iCheck'>天</label>
                    </span>
                    <span class="spanPara">
                        <div class="iradio_green">
                            <input type="radio" id="radio_inter_1_his" flagType="chart" name="radio_inter_his"
                                   flagInput='iCheck' value="2">
                        </div>
                        <label for="radio_inter_1_his" flagInput='iCheck'>月</label>
                    </span>
                    <span class="spanPara">
                        <div class="iradio_green">
                            <input type="radio" id="radio_inter_2_his" flagType="chart" name="radio_inter_his"
                                   flagInput='iCheck' value="3">
                        </div>
                        <label for="radio_inter_2_his" flagInput='iCheck'>年</label>
                    </span>
                </span>
            </li>
            <li class="liChartType">
                <span class="spanTitle">
                    <span>时间选择：</span>
                </span>
                <span class="spanCont spanChart" id="spanDate_his">
                    <span class="spanPara">
                        <div class="iradio_green checked">
                            <input type="radio" id="radio_date_0_his" name="radio_date" value="0" flagInput='iCheck'
                                   checked>
                        </div>
                        <label for="radio_date_0_his" flagInput='iCheck'>近30天</label>
                    </span>
                    <span class="spanPara">
                        <div class="iradio_green">
                            <input type="radio" id="radio_date_1_his" name="radio_date" value="1" flagInput='iCheck'>
                        </div>
                        <label for="radio_date_1_his" flagInput='iCheck'>近7天</label>
                    </span>
                    <!--<span class="spanPara">
                        <div class="iradio_green">
                            <input type="radio" id="radio_date_2_his" name="radio_date" value="2" flagInput='iCheck'>
                        </div>
                        <label for="radio_date_2_his" flagInput='iCheck'>本日</label>
                    </span>-->
                    <span class="spanPara">
                        <div class="iradio_green">
                            <input type="radio" id="radio_date_more" name="radio_date_more" flagInput='iCheck'
                                   onclick="addDate_his();">
                        </div>
                        <label for="radio_date_more" flagInput='iCheck'>更多</label>
                    </span>
                    <span class="spanPara spanHide" flagSpan="his_date">
                        开始时间：<input id="stDt_his" name="stDt" class="Wdate" style="width:90px;" onclick="WdatePicker()"
                                    readonly
                                    onfocus="WdatePicker({minDate:'2015-01-01',maxDate:'#F{$dp.$D(\'endDt_his\',{d:0});}'})">　
		                结束时间：<input id="endDt_his" name="endDt" class="Wdate" style="width:90px;"
                                    onclick="WdatePicker()"
                                    readonly
                                    onfocus="WdatePicker({minDate:'#F{$dp.$D(\'stDt_his\',{d:0});}',maxDate:'%y-%M-#{%d+1}'})">
                    </span>
                    <span class="spanBtn">
                        <a class="aBtn aGray aDefault aHide" flagBtn='aCancel' href="javascript:"
                           onclick="cancelDate_his();">返 回</a>
                    </span>
                </span>
            </li>
            <li class="liChartType">
                <span class="spanTitle">
                    <span>历史同比：</span>
                </span>
                <span class="spanCont spanChart" id="spanContr_his">
                    <span class="spanPara">
                        <div class="iradio_green checked">
                            <input type="radio" id="radio_contr_0_his" name="radio_contr" value="0" flagInput='iCheck'
                                   checked>
                        </div>
                        <label for="radio_contr_0_his" flagInput='iCheck'>无</label>
                    </span>
                    <span class="spanPara">
                        <div class="iradio_green">
                            <input type="radio" id="radio_contr_1_his" name="radio_contr" value="1" flagInput='iCheck'>
                        </div>
                        <label for="radio_contr_1_his" flagInput='iCheck'>去年同时期</label>
                    </span>
                    <span class="spanPara">
                        <div class="iradio_green">
                            <input type="radio" id="radio_contr_2_his" name="radio_contr" value="2" flagInput='iCheck'>
                        </div>
                        <label for="radio_contr_2_his" flagInput='iCheck'>上月份</label>
                    </span>
                    <span class="spanPara">
                        <div class="iradio_green">
                            <input type="radio" id="radio_contr_more" name="radio_contr_more" flagInput='iCheck'
                                   onclick="addContr_his();">
                        </div>
                        <label for="radio_contr_more" flagInput='iCheck'>更多</label>
                    </span>
                    <span class="spanPara spanHide">
                        开始时间：<input id="stDt_his_contr" name="stDt" class="Wdate" style="width:90px;"
                                    onclick="WdatePicker()" readonly>
                    </span>
                    <span class="spanBtn">
                        <a class="aBtn aGray aDefault aHide" flagBtn='aCancel' flagBtn='aCancel' href="javascript:"
                           onclick="cancelContr_his();">返 回</a>
                    </span>
                </span>
            </li>
            <li class="liCont">
                <span class="spanTitle">
                    <span>参数筛选：</span>
                </span>
                <span class="spanCont">
                    <ul id="ulParaConts_his" class="ulParaConts">
                    </ul>
                </span>
            </li>
            <li class="liBtn">
                <a class='aBtn aOut' href='javascript:' onclick="saveContrast_his()">确 定</a>　　　
                <a class='aBtn aGray' href='javascript:' onclick="closeDiv('divContrast_his')">取 消</a>
            </li>
        </ul>
    </div>
</div>
<div id="divHisColumn" class="divFloat div_alt classContrast">
    <div class="divTitle">
        <button class="btnClose" onclick="closeDiv('divHisColumn')"><span>×</span></button>
        <h4 class="modal-title">间隔配置</h4>
    </div>
    <div class="divCont">
        <ul class="ulContrast">
            <li class="liChartType">
                <span class="spanTitle">
                    <span>时间间隔：</span>
                </span>
                <span class="spanCont spanChart">
                    <span class="spanPara">
                        <div class="iradio_green checked">
                            <input type="radio" id="radio_column_1" flagType="chart" name="radio_column_his" value="1"
                                   flagInput='iCheck' checked>
                        </div>
                        <label for="radio_column_1" flagInput='iCheck'>天</label>
                    </span>
                    <span class="spanPara">
                        <div class="iradio_green">
                            <input type="radio" id="radio_column_2" flagType="chart" name="radio_column_his" value="2"
                                   flagInput='iCheck'>
                        </div>
                        <label for="radio_column_2" flagInput='iCheck'>月</label>
                    </span>
                    <span class="spanPara">
                        <div class="iradio_green">
                            <input type="radio" id="radio_column_3" flagType="chart" name="radio_column_his" value="3"
                                   flagInput='iCheck'>
                        </div>
                        <label for="radio_column_3" flagInput='iCheck'>年</label>
                    </span>
                </span>
            </li>
            <li class="liBtn" style="margin:20px 0 5px 0">
                <a class='aBtn aOut' href='javascript:' onclick="saveHisInter()">确 定</a>　　　
                <a class='aBtn aGray' href='javascript:' onclick="closeDiv('divHisColumn')">取 消</a>
            </li>
        </ul>
    </div>
</div>
</body>
</html>