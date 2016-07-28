var randomI;
var isInTable = 0;	//表示鼠标是否在v这个表格内
var pageType;
var DataHtml;
var clickCount = 0;	//记录点击同一th的次数
var thLast = 0;		//记录上次点击th的列数
$(document).ready(function () {
    try {
        //backto();		//返回事件
        //只能输入数字
        //$("input[onlyNum='true']").onlyNum();
        //只能输入字母
        //$("input[onlyAlpha='true']").onlyAlpha();
        //只能输入数字和字母
        //$("input[onlyNumAlpha='true']").onlyNumAlpha();
    } catch (e) {
    }
    keyDown();			//回车及esc事件
});
function doback() {		//页面数据加载完后运行的函数，防止页面没定义而造成的错误提示
    //top.document.title = $("#flagTitle",parent.frames["fcTop"].document).html();;
}

function rePage() {
    var cwidth = document.documentElement.clientWidth;
    var mlength = 0;
    var plength = $("#Page").children("a").length;
    for (var i = 0; i < plength; i++) {
        mlength += $("#Page a:eq(" + i + ")").width() + 37;
    }
    var pWidth = mlength + 580;
    var pleft = 0;
    if (plength != 0) {
        pleft = $("#Page a:eq(0)").offset().left;
    }
    if (cwidth <= pWidth || (pleft != 0 && pleft <= 337)) {
        $("#pages").css("display", "block");
        $("#Page").css("height", "64px");
    } else {
        $("#Page").css("height", "26px");
        $("#pages").css("display", "inline");
    }
    $(".h1").height(getHeight());

}
function ready() {		//页面加载完后调整表格样式;
    $("#detail").find(".showTb tr:even").find("td:even").addClass("detailTh");
    $("#detail").find(".showTb1 td:even").addClass("detailTh");
    $("#bbsTab td").not(":last-child").addClass("nlc");		//class:nlc当表格列内容过长时显示...
    tdcolor();			//鼠标移过列改变列颜色
    sort();				//每行第一列显示序号
    $("table#v tr:even").addClass("color1");
    $("table#v tr:odd").addClass("color2");
    $("table#v tr").click(function () {
        selectRow(this);
        turnNlc(this);		//点击取消该行的nlc属性，即显示全部的内容，超出部分不再由...代替
    });
    $("table#v tr").hover(function () {
        $(this).addClass("color3");
    }, function () {
        $(this).removeClass("color3");
    });
    setHeight();		//设置bbsTab层高度
    $("table#v").mouseenter(function () {
        isInTable = 1;
    });
    $("table#v").mouseleave(function () {
        isInTable = 0;
    });
    $(window).unbind("click").click(function () {  	//点击标题或空白部分取消选中行
        if (isInTable == 0) {
            rowscolor();
            $("#bbsTab td").not(":last-child").addClass("nlc");
        }
    });
    //doback();			//页面加载完一切数据后根据情况获取隐藏信息
}
function ready_noPage() {		//页面加载完后调整表格样式，无分页
    $("#detail").find(".showTb tr:even").find("td:even").addClass("detailTh");
    $("#detail").find(".showTb1 td:even").addClass("detailTh");
    $("#bbsTab td").not(":last-child").addClass("nlc");		//class:nlc当表格列内容过长时显示...
    tdcolor();			//鼠标移过列改变列颜色
    sort();				//每行第一列显示序号
    $("table#v tr:even").addClass("color1");
    $("table#v tr:odd").addClass("color2");
    $("table#v tr").click(function () {
        selectRow(this);
        turnNlc(this);		//点击取消该行的nlc属性，即显示全部的内容，超出部分不再由...代替
    });
    $("table#v tr").hover(function () {
        $(this).addClass("color3");
    }, function () {
        $(this).removeClass("color3");
    });
    //setHeight();		//设置bbsTab层高度
    $("table#v").mouseenter(function () {
        isInTable = 1;
    });
    $("table#v").mouseleave(function () {
        isInTable = 0;
    });
    $(window).click(function () {		//点击标题或空白部分取消选中行
        if (isInTable == 0) {
            rowscolor();
            $("#bbsTab td").not(":last-child").addClass("nlc");
        }
    });
    //doback();			//页面加载完一切数据后根据情况获取隐藏信息
}
function backto() {					//返回事件

}
function keyDown() {			//捕捉回车以及esc事件
    $("body").keydown(function (event) {
        if ($("#detail_bg").css("display") != "none") {
            if (event.keyCode == "13") {	//keyCode=13是回车键
                $(".div_alt,.divFloat").each(function () {
                    if ($(this).css("display") != "none") {
                        $(this).focus();		//兼容IE以及火狐浏览器
                        $(this).find("[flag='done']").trigger("click");
                    }
                });
            }
            else if (event.keyCode == "27") {	//keyCode=27是ESC键
                $("#detail_bg").hide().css("z-index", "50000");
                $(".div_alt,.divFloat").hide();
            }
        }
        else {		//兼容IE以及火狐浏览器
            if (event.keyCode == "13" || event.keyCode == "27")
                event.preventDefault();
        }
    });
}
$(window).resize(function () {
    try {
        setHeight();
        if ($("#detail").css("display") != "none") {
            setDetail("detail");
            beCenter("detail");
        }
    } catch (e) {

    }
});
function setHeight() {
    var bHeight = getHeight();
    $(".h1").height(bHeight);
    $("#Page").show();
    pageType = rePage();
    var cAgent = cUserAgent();
    if (cAgent == "firefox" || cAgent == "IE8.0") {
        var vWidth = parseFloat($("#v").width());
        $("#vv").width(vWidth);
    }
    else if (cAgent == "IE9.0" || cAgent == "IE10.0" || cAgent == "IE11.0") {
        var vWidth = parseFloat($("#v").width()) - parseFloat("1");
        $("#vv").width(vWidth);
    }
    else if (cAgent != "IE7.0") {
        var vWidth = parseFloat($("#v").width()) + parseFloat("2");
        $("#vv").width(vWidth);
    }
}
function setDetail(id) {		//页面高度不够时，调整detail_content的高度，及显示overflow
    if ($("#" + id + " .detail_content").height() == 0) {
        setTimeout("setDetail(" + id + ")", 300);
        return false;
    }
    var pHeight = document.documentElement.clientHeight;
    $("#" + id + " .detail_content").height("auto");	//初始化
    if (pHeight < $("#" + id + " .detail_content").height() + 134)
        $("#" + id + " .detail_content").height(pHeight - 134);
}
function clearDetail(formName) {		//初始化detail内的所有提示元素
    if (typeof(formName) == "undefined")
        form1.reset();
    else
        formName.reset();
    $("form .inputHidden").remove();
    $(".save_alert").remove();								//浮出的提示文字
    $("#detail .inputAlarm").removeClass("inputAlarm");		//input
    $("#detail .alarm").hide();								//跟在后面的红字
    $("#detail .select_d").removeClass("select_d");			//select外的div
    $("#detail .detail_alarm").html("");					//弹出窗标题旁的红字
}
function getHeight() {
    var pHeight = _height();//alert(pHeight);
    var bHeight = "";
    var xsnazzy = document.getElementById("xsnazzy");
    if (xsnazzy)			//页面最上方的条件选择框
        bHeight = pHeight - $("#vv").height() - $("#Page").height() - $("#xsnazzy").height() - "16";
    else
        bHeight = pHeight - $("#vv").height() - $("#Page").height() - "14";
    return bHeight;
}
function _height() {	//获取页面高度
    return document.documentElement.clientHeight;
}
function _width() {	//获取页面高度
    return document.documentElement.clientWidth;
}
function selectRow(row) {
    $("table#v tr").removeClass("selected");
    $(row).addClass("selected");
}
function sort() {			//排序
    var jump = $("#jumpPage").val();
    var size = $("#pageSize").val();
    jump = typeof(jump) == "undefined" ? 50 : jump;
    size = typeof(size) == "undefined" ? 0 : size;
    var oTable = document.getElementById("bbsTab");
    for (var i = 0; i < oTable.rows.length; i++) {
        oTable.rows[i].cells[0].innerHTML = ((jump - 1) * size + i + 1);
    }
}
function tdcolor() {			//鼠标移过改变字体颜色
    $("table#v tr").children("td").mouseover(function () {
        $(this).addClass("aa");
    }).mouseout(function () {
        $(this).removeClass("aa");
    });
}
function rowscolor() {		//表格行颜色交替显示,1个TR
    $("table#v tr").removeClass("color1 color2 color3 selected");
    $("table#v tr:odd").addClass("color2");
    $("table#v tr:even").addClass("color1");
    /*var oTable = document.getElementById("bbsTab"); 
     for(var i=0;i<oTable.rows.length;i++){ 
     if(i%2==0)    //偶数行 
     oTable.rows[i].className = "color1"; 
     else
     oTable.rows[i].className = "color2";
     }*/
}
function turnNlc(tr) {
    $("#bbsTab td").not(":last-child").addClass("nlc");		//初始化nlc属性
    $(tr).find("td").removeClass("nlc");
}
function clearTh() {		//初始化th（主要由sort引起的）
    $("#vv th").removeClass("thNlc thSortAsc thSortDesc thNlcPadding");
}
function getFormJson(frm) {		//获取form中的数据，结合ajax
    var o = {};
    var a = $(frm).serializeArray();
    $.each(a, function () {
        if (o[this.name] !== undefined) {
            if (!o[this.name].push) {
                o[this.name] = [o[this.name]];
            }
            o[this.name].push(this.value || '');
        } else {
            o[this.name] = this.value || '';
        }
    });
    return o;
}
function beCenter(id) {		//垂直居中
    var height = $("#" + id).height();
    var ch = $(window).height();
    var top = $(document).scrollTop();
    //var divTop = top + (parseInt(ch)-parseInt(height))/2-8;   //div外还有10像素的裙边
    var divTop = top + (parseInt(ch) - parseInt(height)) / 2;
    $("#" + id).css("top", divTop > 0 ? divTop : 0);
    var width = $("#" + id).width();
    var offsetWidth = $(document).width();
    var divLeft = (parseInt(offsetWidth) - parseInt(width)) / 2;
    $("#" + id).css("left", divLeft);
}

function mouseDownFun(id) {		//移动div
    var oDiv = document.getElementById(id);
    var dargX = 0;
    var dargY = 0;
    oDiv.onmousedown = function (ev) {
        var oEvent = ev || event;
        dargX = oEvent.clientX - oDiv.offsetLeft;//获取鼠标与div左边的距离
        dargY = oEvent.clientY - oDiv.offsetTop;//获取鼠标与div头部的距离
        document.onmousemove = function (ev) {
            var oEvent = ev || event;
            var Left = oEvent.clientX - dargX;
            var Top = oEvent.clientY - dargY;
            if (Left < 0)
                Left = 0;
            if (Left > document.body.clientWidth - oDiv.offsetWidth)
                Left = document.body.clientWidth - oDiv.offsetWidth;
            if (Top < 0)
                Top = 0;
            if (Top > $(document).height() - oDiv.offsetHeight)
                Top = $(document).height() - oDiv.offsetHeight;
            oDiv.style.left = Left + "px";
            oDiv.style.top = Top + "px";
        };
        document.onmouseup = function () {
            document.onmousemove = null;
            document.onmouseup = null;
            oDiv.onmousedown = null;
        };
        return false;
    };
}
function mouseClickFun(id) {
    var oDiv = document.getElementById(id);
    var x, y, Left, Top;
    x = event.clientX + document.body.scrollLeft + document.documentElement.scrollLeft;
    y = event.clientY + document.body.scrollTop + document.documentElement.scrollTop;
    Left = x - $("#" + id).width() > 0 ? x - $("#" + id).width() - "20" : 0;
    if (document.body.clientHeight > y + $("#" + id).height() + 10) {
        Top = y + 10;
    }
    else {
        Top = document.body.clientHeight - $("#" + id).height() - 10;
        Top = Top > 0 ? Top : 0;
    }
    oDiv.style.top = Top + "px";
    oDiv.style.left = Left + "px";

}
function imageOver(id) {		//鼠标移过改变按钮的样式
    $("img[name=" + id + "]").attr("src", "../img/" + id.split("_")[1] + "_down.png");
}
function imageReset(id) {	//鼠标移过改变按钮的样式
    $("img[name=" + id + "]").attr("src", "../img/" + id.split("_")[1] + ".png");
}
function closeDetail() {	//关闭弹出的detail窗口
    $("#detail_bg").hide();
    $("#detail").hide(300);
    $(".save_alert").remove();
}
function update(id) {		//在detail窗口转到edit窗口	
    edit($("#" + id).val());
}
function closeDiv(id) {		//关闭查询窗口
    $("#detail_bg").hide().css("z-index", "50000");
    $("#" + id).hide(300);
    $(".save_alert").remove();
}
function closeHDiv(id) {		//关闭浮在浮出窗口之上的div
    $("#" + id).hide(300);
    $("#detail_bg").css("z-index", "50000");
}
function showChildAddr(typeId, stepId) {			//联动，根据楼层显示相关的位置
    if ($("#" + typeId).val() != 0) {
        $.post(
            "../main/ggetdeptStep.action?addrTypeId=" + $("#" + typeId).val() + "&depId=" + request("depId"),
            function (data_c) {
                $("#" + stepId).html("");
                for (var j = 0; j < data_c.rows.length; j++) {
                    $("#" + stepId).append('<option value=' + data_c.rows[j].id + '>' + data_c.rows[j].addrName + '</option>');
                }
            },
            "json"
        ).error(function (data) {
            ajaxError(data);
        });
    }
    else
        $("#" + stepId).html("");
}
function ggetUrl() {				//根据选择的设备类型改变左侧的示意图
    if ($("#typeId").val() != 0) {
        $.post(
            "../main/ggetUrl.action?typeId=" + $("#typeId").val(),
            function (data_c) {
                if (data_c.picUrl != null)
                    $("#Pic1").html("<img src='../" + data_c.picUrl + "' id='imgUrl' class='imgDev'>");
                else
                    $("#Pic1").html("<img src='../img/imgNull.png' width='140' class='imgDev'>");
                reChange("imgUrl", 140, 140);		//调整图片大小
            },
            "json"
        ).error(function (data) {
            ajaxError(data);
        });
    }
}
function resetBorder(id) {
    $("#" + id).removeClass("inputAlarm");
    $("#" + id + "_").hide();
    $("#save_alert_" + id).remove();
}
function resetSD(id) {
    $("#" + id + "_d").removeClass("select_d");
    $("#" + id).css("margin", "0px");
    $("#save_alert_" + id).remove();
}
function clearHtml(id) {	//清空id所在标签的内容
    $("#" + id).empty();
}
function save_alert(inputType, html, beforeId) {		//保存or查询时提示必填数据
    //标签类型,显示内容,所要insertBefore的Id
    var sId = "save_alert_" + beforeId.substring(1);
    if ($("#" + sId).length > 0)		//如果已存在，则remove
        $("#" + sId).remove();
    var alertHtml = "";
    var cAgent = cUserAgent();
    var alertStyle = "";
    switch (inputType) {
        case 0:			//input标签
            if (cAgent == "chrome") {	//谷歌浏览器
                alertStyle = "margin-top:-28px";
            }
            else {
                alertStyle = "margin-top:-28px";
            }
            break;
        case 1:			//select标签
            alertStyle = "margin-top:-29px;margin-left:-1px";
            break;
        case 2:			//login页面
            if (cAgent != "IE7.0")
                alertStyle = "margin-top:-28px;margin-left:37px";
            else
                alertStyle = "margin-top:-28px;margin-left:10px";
            break;
        case 3:			//checkbox选择框
            alertStyle = "margin-top:-28px";
            break;
        case 4:			//mail页面内的depMail
            alertStyle = "margin-top:-28px;margin-left:10px";
            break;
        case 5:			//mail页面内的userMail
            alertStyle = "margin-top:-28px;margin-left:26px";
            break;
        case 6:			//personal页面的密码管理
            alertStyle = "margin-top:-28px;margin-left:18px";
            break;
        case 7:			//题型管理页面的管理功能对应的随机题数
            alertStyle = "margin-top:-52px;margin-left:128px";
            break;
        case 8:			//用户开户申请页面的具体位置
            alertStyle = "margin-top:-52px;margin-left:140px";
            break;
        case 9:			//燃气催缴规则表-欠费金额
            alertStyle = "margin-top:-52px;margin-left:70px";
            break;
        case 10:		//燃气催缴规则表-拖欠日期
            alertStyle = "margin-top:-52px;margin-left:249px";
            break;
        case 100:		//测试
            var mLeft = $(beforeId).offset().left - $(beforeId).closest('.div_alt').offset().left;
            var pHeight = $(beforeId).offset().top - $(beforeId).closest('.div_alt').offset().top - $(beforeId).innerHeight();
            alertStyle = "top:" + pHeight + "px;left:" + mLeft + "px";
            break;
    }
    alertHtml = "<div id='" + sId + "' class='save_alert' style='" + alertStyle + "'>"
        + "<span class='save_icon'></span>"
        + "<div class='save_con' style='padding-left:20px;line-height:16px;'>" + html + "</div>"
        + "</div>";
    $(alertHtml).insertBefore(beforeId);
}
function error_alert(errorHtml, time) {		//弹出异常信息，time毫秒后消失
    randomI = Math.random();
    if ($("#divError").length > 0)		//如果已存在，则remove
        $("#divError").remove();
    var eHtml = "<div id='divError' ondblclick='errorHide()' onmouseover='lightDiv(id)' onmouseout='recDiv(id)'>" +
        "<p class='pError'>" +
        "<span class='spanError'>" +
        "<img src='../img/alarm.png' border='none' align='absmiddle' style='height:25px;margin-right:5px;float:left'>" + errorHtml +
        "</span>" +
        "</p>" +
        "</div>";
    $(document.body).append(eHtml);
    $("#divError").show();
    beCenter("divError");
    setTimeout("errorHide(" + randomI + ")", time);		//time毫秒后关闭错误提示窗
}
function lightDiv(id) {
    $("#" + id).css("border", "1px solid #666666");
}
function recDiv(id) {
    $("#" + id).css("border", "1px solid #82B324");
}
function errorHide(i) {
    if (!i || i == randomI)			//防止time毫秒内多次error_alert()引发紊乱
        $("#divError").remove();
}
function dataAlarm(type) {		//页面禁止点击的删除/发布等按钮对应的提示信息
    switch (type) {
        case 0:
            error_alert("无法编辑使用中的串口数据", 2500);
            break;
        case 1:
            error_alert("该从机暂无对应的参数", 2500);
            break;
        case 2:
            error_alert("禁止删除自动备份的数据", 2500);
            break;
        case 3:
            error_alert("请勿重复调试", 2500);
            break;
        case 4:
            error_alert("请先结束调试", 2500);
            break;
    }
}
Date.prototype.pattern = function (fmt) {
    var o = {
        "M+": this.getMonth() + 1, //月份     
        "d+": this.getDate(), //日     
        "h+": this.getHours() % 12 == 0 ? 12 : this.getHours() % 12, //小时     
        "H+": this.getHours(), //小时     
        "m+": this.getMinutes(), //分     
        "s+": this.getSeconds(), //秒     
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度     
        "S": this.getMilliseconds() //毫秒     
    };
    var week = {
        "0": "\u65e5",
        "1": "\u4e00",
        "2": "\u4e8c",
        "3": "\u4e09",
        "4": "\u56db",
        "5": "\u4e94",
        "6": "\u516d"
    };
    if (/(y+)/.test(fmt)) {
        fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    }
    if (/(E+)/.test(fmt)) {
        fmt = fmt.replace(RegExp.$1, ((RegExp.$1.length > 1) ? (RegExp.$1.length > 2 ? "\u661f\u671f" : "\u5468") : "") + week[this.getDay() + ""]);
    }
    for (var k in o) {
        if (new RegExp("(" + k + ")").test(fmt)) {
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
        }
    }
    return fmt;
};

function getNowDate(durDay) {		//取当前日期(durDay天前)
    var today = new Date();
    if (durDay) {
        var agoDay = new Date(Date.parse(new Date().toString()) - 86400000 * (durDay - 1));
        var lastWeek = agoDay.pattern('yyyy-MM-dd');
        return lastWeek;
    }
    else
        return today.pattern('yyyy-MM-dd');
}

function getMonthDate(durMonth) {	//取当前日期(durMonth月前)
    var today = new Date();
    if (durMonth && !isNaN(durMonth))
        today = new Date(today.setMonth(today.getMonth() - durMonth));
    return today.pattern('yyyy-MM-dd');
}

function getCurMonth() {				//取当前年月
    var d = new Date();
    var vYear = d.getFullYear();
    var vMon = d.getMonth() + 1;
    vMon = vMon < 10 ? "0" + vMon : vMon;
    return vYear + "-" + vMon;
}

function getYear(durYear) {			//取年份
    var d = new Date();
    var vYear = d.getFullYear();
    return vYear - durYear;
}

function getCurDate() {				//取当前时间
    var d = new Date();
    var vYear = d.getFullYear();
    var vMon = d.getMonth() + 1;
    var vDay = d.getDate();
    var h = d.getHours();
    var m = d.getMinutes();
    var se = d.getSeconds();
    vMon = vMon < 10 ? "0" + vMon : vMon;
    vDay = vDay < 10 ? "0" + vDay : vDay;
    h = h < 10 ? "0" + h : h;
    m = m < 10 ? "0" + m : m;
    se = se < 10 ? "0" + se : se;
    return vYear + "-" + vMon + "-" + vDay + " " + h + ":" + m + ":" + se;
}

function getCurDate1() {				//取当前时间
    var d = new Date();
    var vYear = d.getFullYear();
    var vMon = d.getMonth() + 1;
    var vDay = d.getDate();
    vMon = vMon < 10 ? "0" + vMon : vMon;
    vDay = vDay < 10 ? "0" + vDay : vDay;
    return vYear + vMon + vDay;
}

/*
 * 根据规则获取开始日期之前的日期
 * stDt     开始时间
 * dateType 时间类型
 * num      数量
 */
function getBeforeDate(stDt, dateType, num) {
    var stDt_ = new Date(Date.parse(stDt.replace(/-/g, "/")));
    var befDate = new Date();
    switch (dateType) {
        case 1:     //年
            befDate = new Date(stDt_.setYear(1900 + stDt_.getYear() - dateType * num));
            break;
        case 2:     //月
            befDate = new Date(stDt_.setMonth(stDt_.getMonth() - (dateType * num - 1)));
            break;
        case 3:     //日
            befDate = new Date(Date.parse(stDt_) - 86400000 * (num - 1));
            break;
    }
    return befDate.pattern('yyyy-MM-dd');
}

function cUserAgent() {			//判断浏览器及版本
    var userAgent = navigator.userAgent,
        rMsie = /(msie\s|trident.*rv:)([\w.]+)/,
        rFirefox = /(firefox)\/([\w.]+)/,
        rOpera = /(opera).+version\/([\w.]+)/,
        rChrome = /(chrome)\/([\w.]+)/,
        rSafari = /version\/([\w.]+).*(safari)/;
    var browser = "";
    var version = "";
    var ua = userAgent.toLowerCase();

    function uaMatch(ua) {
        var match = rMsie.exec(ua);
        if (match != null) {
            return {browser: "IE", version: match[2] || "0"};
            //ie5-7:IE7.0
            //	ie8:IE8.0
            //	ie9:IE9.0
            // ie10:IE10.0
            // ie11:IE11.0
        }
        var match = rFirefox.exec(ua);
        if (match != null) {
            return {browser: match[1] || "", version: match[2] || "0"};
            //firefox
        }
        var match = rOpera.exec(ua);
        if (match != null) {
            return {browser: match[1] || "", version: match[2] || "0"};
            //Opera 20.0为chrome，低版本未测试
        }
        var match = rChrome.exec(ua);
        if (match != null) {
            return {browser: match[1] || "", version: match[2] || "0"};
            //chrome
        }
        var match = rSafari.exec(ua);
        if (match != null) {
            return {browser: match[2] || "", version: match[1] || "0"};
            //safari
        }
        if (match != null) {
            return {browser: "", version: "0"};
        }
    }

    var browserMatch = uaMatch(userAgent.toLowerCase());
    if (browserMatch.browser) {
        browser = browserMatch.browser;
        version = browser == "IE" ? browserMatch.version : "";
    }
    return browser + version;
}

function GetRadioValue(RadioName) {
    var obj = document.getElementsByName(RadioName);
    if (obj != null) {
        for (var i = 0; i < obj.length; i++) {
            if (obj[i].checked) {
                return obj[i].value;
            }
        }
    }
    return null;
}
function DataLength(fData) {               //计算字符串长度，汉字=2,字符/数字=1
    var intLength = 0;
    for (var i = 0; i < fData.length; i++) {
        if ((fData.charCodeAt(i) < 0) || (fData.charCodeAt(i) > 255))
            intLength = intLength + 2;
        else
            intLength = intLength + 1;
    }
    return intLength;
}
function request(paras) {
    var url = location.href;
    var paraString = url.substring(url.indexOf("?") + 1, url.length).split("&");
    var paraObj = {};
    for (var i = 0; j = paraString[i]; i++) {
        paraObj[j.substring(0, j.indexOf("=")).toLowerCase()] = j.substring(j.indexOf("=") + 1, j.length);
    }
    var returnValue = paraObj[paras.toLowerCase()];
    if (typeof(returnValue) == "undefined") {
        return "";
    } else {
        return returnValue;
    }
}

function checkAll(obj) {
    var allCheck = document.getElementsByTagName("input");
    for (var i = 0; i < allCheck.length; i++) {
        if (allCheck[i].type == "checkbox")
            allCheck[i].checked = obj.checked;
    }
}
function closeWindowWLH(id) {
    $("#" + id).css("display", "none");
    $("#" + id).prev().remove();
}

function isChinese(name) {
    var pattern = /[^\x00-\xff]/g;
    if (pattern.test(name)) {
        //包含中文
        return false;
    } else {
        //不包含中文
        return true;
    }
}
function isEmail(name) {					//验证邮箱
    var pattern = /^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/;
    if (pattern.test(name))
        return true;
    else
        return false;
}

function isMobil(mobilePhone) {				//验证手机号
    var reg = /^0{0,1}(13[0-9]|145|147|15[0-3]|15[5-9]|18[0-9])[0-9]{8}$|^$/;
    if (!reg.test(mobilePhone)) {
        return "error";
    } else {
        return "success";
    }
}

function isPhone(telePhone) {				//验证固定电话
    var reg = /^((0\d{2,3})-)?(\d{7,8})(-(\d{3,}))?$/;
    if (!reg.test(telePhone)) {
        return "error";
    } else {
        return "success";
    }
}

function isQq(qq) {						//验证QQ号
    var reg = /^[1-9]\d{4,9}$/;
    if (!reg.test(qq)) {
        return "error";
    } else {
        return "success";
    }
}

function testIdCardNo(idCard) {		//验证身份证
    var Errors = ["验证通过!", "身份证号码位数不对!", "身份证号码出生日期超出范围或含有非法字符!", "身份证号码校验错误!", "身份证地区非法!"];
    var area = {
        11: "北京", 12: "天津", 13: "河北", 14: "山西", 15: "内蒙古", 21: "辽宁", 22: "吉林", 23: "黑龙江",
        31: "上海", 32: "江苏", 33: "浙江", 34: "安徽", 35: "福建", 36: "江西", 37: "山东", 41: "河南", 42: "湖北", 43: "湖南",
        44: "广东", 45: "广西", 46: "海南", 50: "重庆", 51: "四川", 52: "贵州", 53: "云南", 54: "西藏", 61: "陕西", 62: "甘肃",
        63: "青海", 64: "宁夏", 65: "新疆", 71: "台湾", 81: "香港", 82: "澳门", 91: "国外"
    };
    var Y, JYM, S, M;
    var idcard_array = [];
    idcard_array = idCard.split("");
    if (area[parseInt(idCard.substr(0, 2))] == null) return Errors[4];
    switch (idCard.length) {
        case 15:
            if ((parseInt(idCard.substr(6, 2)) + 1900) % 4 == 0 || ((parseInt(idCard.substr(6, 2)) + 1900) % 100 == 0 && (parseInt(idCard.substr(6, 2)) + 1900) % 4 == 0)) {
                ereg = /^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$/; //测试出生日期的合法性 
            }
            else {
                ereg = /^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$/; //测试出生日期的合法性 
            }
            if (ereg.test(idCard))
                return Errors[0];
            else
                return Errors[2];
            break;
        case 18:
            if (parseInt(idCard.substr(6, 4)) % 4 == 0 || (parseInt(idCard.substr(6, 4)) % 100 == 0 && parseInt(idCard.substr(6, 4)) % 4 == 0)) {
                ereg = /^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$/; //闰年出生日期的合法性正则表达式 
            }
            else {
                ereg = /^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$/; //平年出生日期的合法性正则表达式 
            }
            if (ereg.test(idCard)) {
                S = (parseInt(idcard_array[0]) + parseInt(idcard_array[10])) * 7 + (parseInt(idcard_array[1]) +
                    parseInt(idcard_array[11])) * 9 + (parseInt(idcard_array[2]) + parseInt(idcard_array[12])) * 10 +
                    (parseInt(idcard_array[3]) + parseInt(idcard_array[13])) * 5 + (parseInt(idcard_array[4]) +
                    parseInt(idcard_array[14])) * 8 + (parseInt(idcard_array[5]) + parseInt(idcard_array[15])) * 4 +
                    (parseInt(idcard_array[6]) + parseInt(idcard_array[16])) * 2 + parseInt(idcard_array[7]) * 1 +
                    parseInt(idcard_array[8]) * 6 + parseInt(idcard_array[9]) * 3;
                Y = S % 11;
                M = "F";
                JYM = "10X98765432";
                M = JYM.substr(Y, 1);
                if (M == idcard_array[17])
                    return Errors[0];
                else
                    return Errors[3];
            }
            else
                return Errors[2];
            break;
        default:
            return Errors[1];
            break;
    }
}

function ifNaN(id) {			//数字
    return isNaN($("#" + id).val());
}

//检查是否数字
function isNum(a) {
    if ($.trim(a).length == 0) //特指""
        return false;
    var reg = new RegExp("^[0-9]*$");
    return reg.test(a);
}

function isInteger(a) {		//整数
    var reg = /^-?\d+$/;
    return reg.test(a);
}

function isUNaN(name) {		//正整数
    var pattern = /^[0-9]*[1-9][0-9]*$/;
    if (pattern.test(name))
        return true;
    else
        return false;
}

function isIp(name) {		//IP地址
    var pattern = /^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$/;
    return pattern.test(name);
}

function allDatas() {							//所有数据
    var pageSize = $("#pageSize").val();
    url = url1;
    jsons(1, pageSize, url);
}

function jsons(jumpPage, pageSize, url) {		//获取页面内容以及展开,含分页
    jumpPage = jumpPage != null ? jumpPage : "1";
    $("#detail_bg").show().css("z-index", "50000");
    beCenter("waiting");
    $("#waitings").html("加载中，请稍候....");
    $("#waiting").show();
    $.ajax({
        type: "post",
        dataType: "json",
        url: url,
        data: "jumpPage=" + jumpPage + "&pageSize=" + pageSize,
        success: function callBack(data) {
            json_datas(data.rows);
            json_pages(data.pageBean);
            ready();
            $("#waiting").hide();
            $("#detail_bg").hide();
        },
        error: function (data) {
            ajaxError(data);
            $("#waiting").hide();
            $("#detail_bg").hide();
            error_alert("加载出错，请重试或联系管理员", 1500);
        }
    });
}

function jsons_noPage(url) {		//获取页面内容以及展开,无分页
    $("#detail_bg").show().css("z-index", "50000");
    beCenter("waiting");
    $("#waitings").html("加载中，请稍候....");
    $("#waiting").show();
    $.ajax({
        type: "post",
        dataType: "json",
        url: url,
        success: function callBack(data) {
            json_datas_noPage(data.rows);
            ready_noPage();
            $("#waiting").hide();
            $("#detail_bg").hide();
        },
        error: function (data) {
            ajaxError(data);
            $("#waiting").hide();
            $("#detail_bg").hide();
            error_alert("加载出错，请重试或联系管理员", 1500);
        }
    });
}

function jsons_save(name) {				//添加or修改数据
    $("#detail_bg").css("z-index", "50004");
    beCenter("waiting");
    $("#waitings").html("保存中，请稍候....");
    $("#waiting").show();
    var dataPara = getFormJson(name);
    /*var testURl = name.action;
     for(var i in dataPara){
     testURl += "&"+i+"="+dataPara[i];
     }
     window.location.href=testURl;*/
    $.ajax({
        url: name.action,
        type: name.method,
        data: $.param(dataPara, true),
        success: function (data) {
            save_suc(data);
        },
        error: function (data) {
            ajaxError(data);
            $(".div_alt").hide();
            $("#waiting").hide();
            $("#detail_bg").hide();
            error_alert("数据出错，请重试或联系管理员", 1500);
        }
    });
}

function json_datas(Data) {		//将ajax获取的数据填充到页面
    DataHtml = Data;
    $("#nullHtml").remove();
    var dhtml = "";
    var datas = "";
    if (Data != null && Data != "") {
        for (var i = 0; i < Data.length; i++) {
            dhtml += "<tr id='tr_" + Data[i][0] + "'>";
            datas = Data[i];
            for (var j = 0; j < datas.length; j++) {
                if (i == 0)		//仅需第一行设置宽度
                    dhtml += "<td width=" + $("#vv th:eq(" + j + ")").attr("width") + ">" + datas[j] + "</td>";
                else
                    dhtml += "<td>" + datas[j] + "</td>";
            }
            dhtml += "</tr>";
        }
        $("#bbsTab").html(dhtml);
        $("#vv th:not(:first):not(:last)").unbind("click").bind('click', function () {		//表格添加点击th重新排序功能
            sortTh(this);
        });
        $("#vv th:first").unbind("click").bind('click', function () {		//点击【序号】列返回原有的顺序
            sortTh(0);
        });
    }
    else {		//结果为空
        $("#bbsTab").html("");		//清空
        var nullHtml = "<div id='nullHtml'>暂无数据</div>";
        $(".h1").append(nullHtml);
        $("#nullHtml").css("line-height", getHeight() - "5" + "px");
        $("#vv th:not(:first):not(:last)").unbind("click");
        $("#vv th:first").unbind("click");
    }
    $(".h1").animate({scrollTop: 0}, 200);		//滚动条到最上方
    clearTh();		//初始化th
}
function json_datas_noPage(Data) {		//将ajax获取的数据填充到页面
    DataHtml = Data;
    $("#nullHtml").remove();
    var dhtml = "";
    var datas = "";
    if (Data != null && Data != "") {
        for (var i = 0; i < Data.length; i++) {
            dhtml += "<tr id='tr_" + Data[i][0] + "'>";
            datas = Data[i];
            for (var j = 0; j < datas.length; j++) {
                if (i == 0)		//仅需第一行设置宽度
                    dhtml += "<td width=" + $("#vv th:eq(" + j + ")").attr("width") + ">" + datas[j] + "</td>";
                else
                    dhtml += "<td>" + datas[j] + "</td>";
            }
            dhtml += "</tr>";
        }
        $("#bbsTab").html(dhtml);
    }
    else {		//结果为空
        $("#bbsTab").html("");		//清空
        var nullHtml = "<div id='nullHtml'>暂无数据</div>";
        $(".h1").append(nullHtml);
        $("#nullHtml").css("line-height", getHeight() - "5" + "px");
        $("#vv th:not(:first):not(:last)").unbind("click");
        $("#vv th:first").unbind("click");
    }
    $(".h1").animate({scrollTop: 0}, 200);		//滚动条到最上方
}
function sortTh(th) {			//点击th重新排序本页内容
    if (th == 0) {
        $("#vv th").removeClass("thNlc thSortAsc thSortDesc thNlcPadding");
        var dhtml = "";
        var datas = "";
        for (var i = 0; i < DataHtml.length; i++) {
            dhtml += "<tr id='tr_" + DataHtml[i][0] + "'>";
            datas = DataHtml[i];
            for (var j = 0; j < datas.length; j++) {
                if (i == 0)
                    dhtml += "<td width=" + $("#vv th:eq(" + j + ")").attr("width") + ">" + datas[j] + "</td>";
                else
                    dhtml += "<td>" + datas[j] + "</td>";
            }
            dhtml += "</tr>";
        }
        $("#bbsTab").html(dhtml);
        sort();				//每行第一列显示序号
        $("table#v tr:even").addClass("color1");
        $("table#v tr:odd").addClass("color2");
        $("table#v tr").click(function () {
            selectRow(this);
            turnNlc(this);		//点击取消该行的nlc属性，即显示全部的内容，超出部分不再由...代替
        });
        $("table#v tr").hover(function () {
            $(this).addClass("color3");
        }, function () {
            $(this).removeClass("color3");
        });
        clickCount = 0;
        return false;
    }
    $("#vv th").removeClass("thNlc thSortAsc thSortDesc thNlcPadding");
    var currentFont = "normal 15px arial,微软雅黑,宋体,sans-serif";
    var thWidth = $(th).width();		//th列的宽度
    var textWidth = GetCurrentStrWidth($(th).text(), currentFont);		//th内文字的宽度
    if (thWidth < textWidth + 10)
        $(th).addClass("thNlcPadding");
    var thIndex = $(th).parents("tr").find("th").index($(th));		//获取点击的列数
    if (thLast != thIndex)
        clickCount = 0;		//点击新列，重置排序
    thLast = thIndex;		//记录上次点击的列数
    $(th).addClass("thNlc");
    mapSort = new Map();	//mapSort内存行号-点击内容
    sorts = [];	//存需要排序的值
    for (var i in DataHtml) {
        mapSort.put(DataHtml[i][thIndex] + i, i);
        sorts[i] = DataHtml[i][thIndex] + i;
    }
    sorts = sorts.sort();
    var dhtml = "";
    var datas;
    if (clickCount % 2 == 0) {		//表示升序
        $(th).addClass("thSortAsc");
        for (var i in sorts) {
            thIndex = mapSort.get(sorts[i]);
            dhtml += "<tr id='tr_" + DataHtml[thIndex][0] + "'>";
            datas = DataHtml[thIndex];
            for (var j = 0; j < datas.length; j++) {
                if (i == 0)
                    dhtml += "<td width=" + $("#vv th:eq(" + j + ")").attr("width") + ">" + datas[j] + "</td>";
                else
                    dhtml += "<td>" + datas[j] + "</td>";
            }
            dhtml += "</tr>";
        }
    }
    else {			//表示降序
        $(th).addClass("thSortDesc");
        for (var i = sorts.length - 1; i >= 0; i--) {
            thIndex = mapSort.get(sorts[i]);
            dhtml += "<tr id='tr_" + DataHtml[thIndex][0] + "'>";
            datas = DataHtml[thIndex];
            for (var j = 0; j < datas.length; j++) {
                if (i == sorts.length - 1)
                    dhtml += "<td width=" + $("#vv th:eq(" + j + ")").attr("width") + ">" + datas[j] + "</td>";
                else
                    dhtml += "<td>" + datas[j] + "</td>";
            }
            dhtml += "</tr>";
        }
    }
    $("#bbsTab").html(dhtml);
    sort();				//每行第一列显示序号
    $("table#v tr:even").addClass("color1");
    $("table#v tr:odd").addClass("color2");
    $("table#v tr").click(function () {
        selectRow(this);
        turnNlc(this);		//点击取消该行的nlc属性，即显示全部的内容，超出部分不再由...代替
    });
    $("table#v tr").hover(function () {
        $(this).addClass("color3");
    }, function () {
        $(this).removeClass("color3");
    });
    clickCount++;
}
function json_query(url_query) {	//查询数据
    url = url_query;
    var pageSize = $("#pageSize").val();
    $("#detail_bg").css("z-index", "50004");
    beCenter("waiting");
    $("#waitings").html("查询中，请稍候....");
    $("#waiting").show();
    $.ajax({
        type: "post",
        dataType: "json",
        url: url_query,
        data: "jumpPage=1&pageSize=" + pageSize,
        success: function callBack(data) {
            //top.success(0,"查询成功");
            json_datas(data.rows);
            json_pages(data.pageBean);
            ready();
            $("#query").hide();
            $("#waiting").hide();
            $("#detail_bg").hide().css("z-index", "50000");
        },
        error: function (data) {
            ajaxError(data);
            $("#query").hide();
            $("#waiting").hide();
            $("#detail_bg").hide().css("z-index", "50000");
            error_alert("加载出错，请重试或联系管理员", 1500);
        }
    });
}

function json_pages(pageBean) {			//将ajax返回的分页信息填充到页面
    var count = pageBean.count;
    var pageCount = pageBean.pageCount;
    var jumpPage = pageBean.page;
    var jumpPage_ = parseInt(jumpPage) - 1;
    var jumpPage__ = parseInt(jumpPage) + 1;
    var pageSize = pageBean.pageSize;
    var pageCountList = pageBean.pageCountList;
    var firstNum = (jumpPage - 1) * pageSize + 1;
    var lastNum = "";
    if (jumpPage == pageCount) {
        lastNum = count;
    } else {
        lastNum = (jumpPage) * pageSize;
    }
    var phtml = "";
    phtml += "<div style='display:inline;float: left;margin-left: 10px;' id='pageDiv'>";
    phtml += " <SELECT size=1 id='pageSize' name='pagesize' onchange='pageGo(1)' style='margin-right:5px;'>";
    for (var i = 0; i < pageCountList.length; i++) {
        if (pageSize == pageCountList[i]) {
            phtml += "<OPTION value=" + pageCountList[i] + " selected>" + pageCountList[i] + "</OPTION>";
            page = pageCountList[i];
        } else {
            phtml += "<OPTION value=" + pageCountList[i] + ">" + pageCountList[i] + "</OPTION>";
        }
    }
    phtml += "</SELECT>";
    phtml += "<span> </span>";
    if (parseInt(jumpPage) <= parseInt(1))
        phtml += " <a href='#' style='margin-left:5px;'><img src='../img/pagination_first.gif' style='opacity: 0.5;vertical-align: middle;'></a> ";
    else
        phtml += "<a href='javascript:' onclick='pageGo(1)' style='margin-left:5px;'><img src='../img/pagination_first.gif' style='vertical-align: middle;'></a>";
    if (parseInt(jumpPage) <= parseInt(1))
        phtml += "<a href='#' > <img src='../img/pagination_prev.gif' style='opacity: 0.5;vertical-align: middle;'></a> ";
    else
        phtml += " <a href='javascript:' onclick='pageGo(" + jumpPage_ + ")'><img src='../img/pagination_prev.gif'  style='vertical-align: middle;'></a>";
    phtml += "<span> </span>";
    phtml += " &nbsp;第 <SELECT size=1 id='jumpPage' name='Pagelist' onchange='pageSizeGo();'>";
    for (var i = 1; i < pageCount + 1; i++) {
        if (jumpPage == i) {
            phtml += "<OPTION value=" + i + " selected>" + i + "</OPTION>";
        } else {
            phtml += "<OPTION value=" + i + ">" + i + "</OPTION>";
        }
    }
    phtml += "</SELECT> 页 ";
    phtml += " 共<b style='color: red'>" + pageCount + "</b>页 ";
    phtml += "<span> </span>";
    if (parseInt(jumpPage) + parseInt(1) > parseInt(pageCount))
        phtml += " <a href='#' style='margin-left:5px;'><img src='../img/pagination_next.gif'  style='opacity: 0.5;vertical-align: middle;'></a>";
    else
        phtml += " <a href='javascript:' onclick='pageGo(" + jumpPage__ + ")' style='margin-left:5px;'><img src='../img/pagination_next.gif'  style='vertical-align: middle;'></a>";
    if (parseInt(jumpPage) + parseInt(1) > parseInt(pageCount))
        phtml += " <a href='#' style='margin-right:5px;'><img src='../img/pagination_last.gif'  style='opacity: 0.5;vertical-align: middle;'></a>";
    else
        phtml += " <a href='javascript:' onclick='pageGo(" + pageCount + ")' style='margin-right:5px;'><img src='../img/pagination_last.gif'  style='vertical-align: middle;'></a>";
    phtml += "<span> </span>";
    phtml += " <a href='javascript:' onclick='pageSizeGo()' style='margin-left:5px;'><img src='../img/pagination_load_.png'  style='vertical-align: middle;width:16px;'></a>";
    phtml += "</div><div style='display:inline;float: right;margin-right: 10px;'>";
    phtml += " 当前显示   <b style='color: red'>" + firstNum + "</b> -  <b style='color: red'>" + lastNum + "</b> 条记录  共 <b style='color: red'>" + count + "</b> 条记录</div> ";
    phtml += "</div>";
    $("#pages").html(phtml);
}

function pageSizeGo() {		//转到第几页
    var jumpPage = $("#jumpPage").val();
    var pageSize = $("#pageSize").val();
    jsons(jumpPage, pageSize, url);
}
function pageGo(jumpPage) {	//页面跳转
    var pageSize = $("#pageSize").val();
    jsons(jumpPage, pageSize, url);
}
function devc_pages(floatDiv, pageBean, type) {			//浮动窗口的分页功能
    var count = pageBean.count;
    var pageCount = pageBean.pageCount;
    var jumpPage = pageBean.page;
    var jumpPage_ = parseInt(jumpPage) - 1;
    var jumpPage__ = parseInt(jumpPage) + 1;
    var pageSize = pageBean.pageSize;
    var pageCountList = pageBean.pageCountList;
    var firstNum = (jumpPage - 1) * pageSize + 1;
    var lastNum = "";
    if (jumpPage == pageCount) {
        lastNum = count;
    } else {
        lastNum = (jumpPage) * pageSize;
    }
    var phtml = "";
    phtml += "<div style='display:inline;float: left;margin-left: 10px;' id='pageDiv'>";
    phtml += "<SELECT size=1 name='devc_Size' onchange='devc_Go(1,\"" + floatDiv + "\",\"" + type + "\")'>";
    for (var i = 0; i < pageCountList.length; i++) {
        if (pageSize == pageCountList[i])
            phtml += "<OPTION value=" + pageCountList[i] + " selected>" + pageCountList[i] + "</OPTION>";
        else
            phtml += "<OPTION value=" + pageCountList[i] + ">" + pageCountList[i] + "</OPTION>";
    }
    phtml += "</SELECT>";
    phtml += "<span> </span>";
    if (parseInt(jumpPage) <= parseInt(1))
        phtml += " <a href='#' style='margin-left:5px;'><img src='../img/pagination_first.gif' style='opacity: 0.5;vertical-align: middle;'></a> ";
    else
        phtml += "<a href='javascript:' onclick='devc_Go(1,\"" + floatDiv + "\",\"" + type + "\")' style='margin-left:5px;'><img src='../img/pagination_first.gif' style='vertical-align: middle;'></a>";
    if (parseInt(jumpPage) <= parseInt(1))
        phtml += "<a href='#' > <img src='../img/pagination_prev.gif' style='opacity: 0.5;vertical-align: middle;'></a> ";
    else
        phtml += " <a href='javascript:' onclick='devc_Go(" + jumpPage_ + ",\"" + floatDiv + "\",\"" + type + "\")'><img src='../img/pagination_prev.gif'  style='vertical-align: middle;'></a>";
    phtml += "<span> </span>";
    phtml += " &nbsp;第<SELECT size=1 name='devc_Page' onchange='devc_SizeGo(\"" + floatDiv + "\");'>";
    for (var i = 1; i < pageCount + 1; i++) {
        if (jumpPage == i)
            phtml += "<OPTION value=" + i + " selected>" + i + "</OPTION>";
        else
            phtml += "<OPTION value=" + i + ">" + i + "</OPTION>";
    }
    phtml += "</SELECT> 页 ";
    phtml += " 共<b style='color: red'>" + pageCount + "</b>页 ";
    phtml += "<span> </span>";
    if (parseInt(jumpPage) + parseInt(1) > parseInt(pageCount))
        phtml += " <a href='#' style='margin-left:5px;'><img src='../img/pagination_next.gif'  style='opacity: 0.5;vertical-align: middle;'></a>";
    else
        phtml += " <a href='javascript:' onclick='devc_Go(" + jumpPage__ + ",\"" + floatDiv + "\",\"" + type + "\")' style='margin-left:5px;'><img src='../img/pagination_next.gif'  style='vertical-align: middle;'></a>";
    if (parseInt(jumpPage) + parseInt(1) > parseInt(pageCount))
        phtml += " <a href='#' style='margin-right:5px;'><img src='../img/pagination_last.gif'  style='opacity: 0.5;vertical-align: middle;'></a>";
    else
        phtml += " <a href='javascript:'  onclick='devc_Go(" + pageCount + ",\"" + floatDiv + "\",\"" + type + "\")' style='margin-right:5px;'><img src='../img/pagination_last.gif'  style='vertical-align: middle;'></a>";
    phtml += "<span> </span>";
    phtml += " <a href='javascript:' onclick='devc_SizeGo(\"" + floatDiv + "\");' style='margin-left:5px;'><img src='../img/pagination_load_.png'  style='vertical-align: middle;width:16px;'></a>";
    phtml += "</div><div style='display:inline;float: right;margin-right: 10px;'>";
    phtml += " 当前显示   <b style='color: red'>" + firstNum + "</b> -  <b style='color: red'>" + lastNum + "</b> 条记录  共 <b style='color: red'>" + count + "</b> 条记录</div> ";
    phtml += "</div>";
    $("#" + floatDiv + " [name='ppages']").html(phtml);
}

function devc_SizeGo(floatDiv, type) {		//转到第几页
    devc_Page = $("#" + floatDiv + " [name='devc_Page']").val();
    devc_Size = $("#" + floatDiv + " [name='devc_Size']").val();
    json_devc(type);
}
function devc_Go(jumpPage, floatDiv, type) {		//页面跳转
    devc_Page = jumpPage;
    devc_Size = $("#" + floatDiv + " [name='devc_Size']").val();
    json_devc(type);
}
function Map() {		//JS实现map
    var struct = function (key, value) {
        this.key = key;
        this.value = value;
    };

    var put = function (key, value) {
        for (var i = 0; i < this.arr.length; i++) {
            if (this.arr[i].key === key) {
                this.arr[i].value = value;
                return;
            }
        }
        this.arr[this.arr.length] = new struct(key, value);
    };

    var get = function (key) {
        for (var i = 0; i < this.arr.length; i++) {
            if (this.arr[i].key === key) {
                return this.arr[i].value;
            }
        }
        return null;
    };

    var remove = function (key) {
        var v;
        for (var i = 0; i < this.arr.length; i++) {
            v = this.arr.pop();
            if (v.key === key) {
                continue;
            }
            this.arr.unshift(v);
        }
    };

    var size = function () {
        return this.arr.length;
    };

    var isEmpty = function () {
        return this.arr.length <= 0;
    };
    this.arr = [];
    this.get = get;
    this.put = put;
    this.remove = remove;
    this.size = size;
    this.isEmpty = isEmpty;
}

function reChange(imgId, width, height) {	//调整图片大小
    var _this = $("#" + imgId);
    _this.error(function () {			//加载失败
        _this.attr("src", "../img/imgNull.png").width("140px");
    }).load(function () {					//加载完成
        if (_this.attr("src") != "../img/imgNull.png") {
            var tWidth = _this.width();
            var tHeight = _this.height();
            if (tWidth * height > tHeight * width)
                _this.width(width);
            else
                _this.height(height);
        }
    });
}

function __firefox() {
    HTMLElement.prototype.__defineGetter__("runtimeStyle", __element_style);
    window.constructor.prototype.__defineGetter__("event", __window_event);
    Event.prototype.__defineGetter__("srcElement", __event_srcElement);
}
function __element_style() {
    return this.style;
}
function __window_event() {
    return __window_event_constructor();
}
function __event_srcElement() {
    return this.target;
}
function __window_event_constructor() {
    if (document.all) {
        return window.event;
    }
    var _caller = __window_event_constructor.caller;
    while (_caller != null) {
        var _argument = _caller.arguments[0];
        if (_argument) {
            var _temp = _argument.constructor;
            if (_temp.toString().indexOf("Event") != -1) {
                return _argument;
            }
        }
        _caller = _caller.caller;
    }
    return null;
}
if (window.addEventListener) {
    try {
        __firefox();
    } catch (e) {
    }
}

function compareDate(stDt, endDt) {	//比较开始时间与结束时间，异常时互换
    var a = $("#" + stDt).val();
    var b = $("#" + endDt).val();
    var arr = a.split("-");
    var starttime = new Date(arr[0], arr[1], arr[2]);
    var starttimes = starttime.getTime();
    var arrs = b.split("-");
    var lktime = new Date(arrs[0], arrs[1], arrs[2]);
    var lktimes = lktime.getTime();
    if (starttimes >= lktimes) {
        $("#" + stDt).val(b);
        $("#" + endDt).val(a);
    }
}

function excelOut(url, exts) {			//弹出导出的确认框
    if ($("#divExcelOut").length > 0)		//如果已存在，则remove
        $("#divExcelOut").remove();
    var htmlOut = "<div id='divExcelOut' class='div_alt'>" +
        "<div class='excelOut'>" +
        "<p class='pHtml'><img border='0' src='../img/excelOut.png'>确认导出吗？</p>" +
        "<p class='pBtn'>" +
        "<input class='btn_11' flag='done' type='button' onclick='excelOut_done(\"" + url + "\",\"" + exts + "\");' value='确定' />　" +
        "<input class='btn_22' flag='done' type='button' onclick='excelOut_cancle();' value='取消' />" +
        "</p>" +
        "</div>" +
        "</div>";
    $(document.body).append(htmlOut);
    $("#detail_bg").show();
    $("#divExcelOut").show();
    beCenter("divExcelOut");
}

function excelOut_done(url, exts) {
    exts = exts != 0 ? exts : "";
    location.href = "../excel/download_" + url + exts;
    excelOut_cancle();
}

function excelOut_cancle() {
    $("#detail_bg").hide();
    $("#divExcelOut").remove();
}

function excelIn(url) {				//弹出导入的确认框
    if ($("#excelIn").length > 0)		//如果已存在，则remove
        $("#excelIn").remove();
    var htmlOut = "<div id='excelIn' class='div_alt divFloat'>"
        + "<div class='queryBody'>"
        + "<form name='formExcelIn' id='formExcelIn' method='post' enctype='multipart/form-data' theme='simple'>"
        + "<div class='detail_title' onmousedown='mouseDownFun(\"excelIn\")'>" +
        "<span class='detail_header'>　导入数据</span>" +
        "<span id='spAlarm' class='detail_alarm'></span><span class='detail_close' onclick='closeDiv(\"excelIn\")' title='关闭'>X</span>" +
        "</div>"
        + "<div class='queryContent'>"
        + "<ul>"
        + "<li><span class='queryLeft'>数据模板：</span><a class='aBtn aOut' href='javascript:' onclick='excelMode(\"" + url + "\")'>点击获取</a></li>"
        + "<li><span class='queryLeft'>上传文件：</span><input type='file' name='excelFile' id='excelFile' style='width:180px'/></li>"
        + "<li><span class='queryLeft'>文件说明：</span>仅支持<span class='red bold'>xls</span>及<span class='red bold'>xlsx</span>格式</li>"
        + "</ul>"
        + "</div>"
        + "<div class='queryBtn'>"
        + "<input value='确定' class='btn_1' type='button' flag='done' onclick='excelIn_done(\"" + url + "\");'/>"
        + "　　<input value='取消' class='btn_2' type='button' onclick='closeDiv(\"excelIn\");'/>"
        + "</div>"
        + "</form>"
        + "</div>"
        + "</div>";
    $(document.body).append(htmlOut);
    $("#detail_bg").show();
    $("#excelIn").show();
    beCenter("excelIn");
}

function excelMode(url) {
    location.href = "../excel/excelMode_" + url + "Mode";
}

function excelIn_done(url) {
    var filepath = $("#excelFile").val();
    if (filepath == "") {
        $("#spAlarm").html("　请先选择导入的文件");
        return false;
    }
    var extStart = filepath.lastIndexOf(".");
    var ext = filepath.substring(extStart, filepath.length).toUpperCase();
    if (ext != ".XLS" && ext != ".XLSX") {
        $("#spAlarm").html("　文件仅限于xls,xlsx格式");
        return false;
    }
    $("#excelIn").hide();
    beCenter("waiting");
    $("#waitings").html("导入中，请稍候....");
    $("#waiting").show();
    var options = {
        url: "../excel/" + url,
        type: "POST",
        dataType: "json",
        success: function (data) {
            $("#waiting").hide();
            var flag = data.flag;
            if (flag == 0)
                error_alert("请先选择导入的文件", 2500);
            else if (flag == -1)
                error_alert("操作出错，请重试或联系管理员", 2500);
            else if (flag == -2) {
                var map = data.map;
                error_alert("导入文件包含" + map.errCount + "条错误信息", 2500);
                location.href = "../excel/download.action?errFileName=" + map.errFileName;
            }
            else {
                top.success(0, "导入成功");
                allDatas();		//刷新页面
            }
            excelIn_cancle();
        },
        error: function (data) {
            ajaxError(data);
            error_alert("操作出错，请重试或联系管理员", 2500);
            $("#waiting").hide();
            excelIn_cancle();
        }
    };
    $("#formExcelIn").ajaxSubmit(options);
}

function excelIn_cancle() {
    $("#detail_bg").hide();
    $("#excelIn").remove();
}

function check(name, obj) {
    var checkboxs = document.getElementsByName(name);
    for (var i = 0; i < checkboxs.length; i++) {
        checkboxs[i].checked = obj.checked;
    }
}
function ccheck(name, obj) {
    if (!obj.checked) {
        document.getElementById(name).checked = false;
    }
}

function unselectAll() {//全选、反选
    $("[name = delid]:checkbox").each(function () {
        $(this).attr("checked", !$(this).attr("checked"));
    });
}

function getMail(id) {
    $("#emaillist").css({"top": $("#" + id).offset().top + 22, "left": $("#" + id).offset().left});
    var val = $("#" + id).val();
    if (val == '' || val.indexOf("@") > -1) {
        $("#emaillist").hide();
        return false;
    }
    $('#emaillist').empty();
    for (var i = 0; i < mailList.length; i++) {
        var emailText = $("#" + id).val();
        $('#emaillist').append('<li class=addr>' + emailText + mailList[i] + '</li>');
    }
    $('#emaillist').show();
    $('#emaillist li').click(function () {
        $("#" + id).val($(this).text());
        $('#emaillist').hide();
    });
}
function hideList() {
    if (isOut)
        $('#emaillist').hide();
}
function showList(id) {
    var email = $.trim($("#" + id).val());
    if (email != "") {
        $("#emaillist").css({"top": $("#" + id).offset().top + 22, "left": $("#" + id).offset().left});
        $('#emaillist').show();
    }
}
function ajaxError(data) {
    if (data.getResponseHeader("sessionStatus") == "ajaxSessionTimeOut") {
        top.reLogin(0);		//session过期，重新登录
    }
    else if (data.getResponseHeader("sessionStatus") == "ajaxCurrentError") {
        top.reLogin(1);		//此帐号已在别处登录
    }
    /****隐藏弹出窗口****/
    $("#detail_bg").hide();
    $(".div_alt").hide();
    $(".save_alert").remove();
    /****隐藏弹出窗口****/
}
function setBg() {			//等页面加载完后改变detail_bg的高度，让背景阴影铺满整个屏幕
    var pHeight = $(document).height();
    $("#detail_bg").height(pHeight);
}
function GetCurrentStrWidth(text, font) {		//获取text内容的宽度，font对应text
    var currentObj = $('<span>').hide().appendTo(document.body);
    $(currentObj).html(text).css('font', font);
    var width = currentObj.width();
    currentObj.remove();
    return width;
}
function form_addInput(form, arrays, name) {		//将arrays的数组内容转为input标签后加到form表单内，然后提交至后台
    var inputHtml = "";
    for (var i in arrays) {
        inputHtml += "<input class='inputHidden' type='hidden' name='" + name + "' value='" + arrays[i] + "'>";
    }
    $("#" + form).append(inputHtml);
}
function randomColor() {	//生成随机色
    var str = Math.ceil(Math.random() * 16777215).toString(16);
    if (str.length < 6) {
        str = "0" + str;
    }
    return "#" + str;
}
$.fn.hasAttr = function (name) { //判断该元素是否包含某属性
    return this.attr(name) !== undefined;
};
// ----------------------------------------------------------------------
// <summary>
// 限制只能输入数字
// </summary>
// ----------------------------------------------------------------------
$.fn.onlyNum = function () {
    $(this).keypress(function (event) {
        var _val = $(this).val();
        var eventObj = event || e;
        var keyCode = eventObj.keyCode || eventObj.which;
        if ((keyCode >= 48 && keyCode <= 57) || (_val.indexOf(".") == -1 && keyCode == 46) || (_val == "" && (keyCode == 43 || keyCode == 45)))
        //0到9，允许一个小数点,第一位允许+-符号
            return true;
        else
            return false;
    }).focus(function () {				//禁用输入法
        this.style.imeMode = 'disabled';
    }).bind("paste", function () {		//获取剪切板的内容,有兼容性问题
        var clipboard = window.clipboardData.getData("Text");
        if (!isNaN(clipboard))
            return true;
        else
            return false;
    });
};
// ----------------------------------------------------------------------
// <summary>
// 限制只能输入字母
// </summary>
// ----------------------------------------------------------------------
$.fn.onlyAlpha = function () {
    $(this).keypress(function (event) {
        var eventObj = event || e;
        var keyCode = eventObj.keyCode || eventObj.which;
        if ((keyCode >= 65 && keyCode <= 90) || (keyCode >= 97 && keyCode <= 122))
            return true;
        else
            return false;
    }).focus(function () {
        this.style.imeMode = 'disabled';
    }).bind("paste", function () {
        var clipboard = window.clipboardData.getData("Text");
        if (/^[a-zA-Z]+$/.test(clipboard))
            return true;
        else
            return false;
    });
};
// ----------------------------------------------------------------------
// <summary>
// 限制只能输入数字和字母
// </summary>
// ----------------------------------------------------------------------
$.fn.onlyNumAlpha = function () {
    $(this).keypress(function (event) {
        var eventObj = event || e;
        var keyCode = eventObj.keyCode || eventObj.which;
        if ((keyCode >= 48 && keyCode <= 57) || (keyCode >= 65 && keyCode <= 90) || (keyCode >= 97 && keyCode <= 122))
            return true;
        else
            return false;
    }).focus(function () {
        this.style.imeMode = 'disabled';
    }).bind("paste", function () {
        var clipboard = window.clipboardData.getData("Text");
        if (/^(\d|[a-zA-Z])+$/.test(clipboard))
            return true;
        else
            return false;
    });
};
// ----------------------------------------------------------------------
// <summary>
// 限制只能输入正整数
// </summary>
// ----------------------------------------------------------------------
$.fn.onlyUnInt = function () {
    $(this).keypress(function (event) {
        var eventObj = event || e;
        var keyCode = eventObj.keyCode || eventObj.which;
        if (keyCode >= 48 && keyCode <= 57)
        //0到9
            return true;
        else
            return false;
    }).focus(function () {				//禁用输入法
        this.style.imeMode = 'disabled';
    }).bind("paste", function () {		//获取剪切板的内容,有兼容性问题
        var clipboard = window.clipboardData.getData("Text");
        if (!isUNaN(clipboard))
            return true;
        else
            return false;
    });
};
/*$(function () {
 // 限制使用了onlyNum类样式的控件只能输入数字
 $(".onlyNum").onlyNum();
 //限制使用了onlyAlpha类样式的控件只能输入字母
 $(".onlyAlpha").onlyAlpha();
 // 限制使用了onlyNumAlpha类样式的控件只能输入数字和字母
 $(".onlyNumAlpha").onlyNumAlpha();
 });*/

function iCheckInit() {  //自定义checkbox,radio
    var flagType;
    var radioName;
    var isCheck;
    $("input[flagInput='iCheck']").live("click", function () {    //点击切换checkbox的状态
        $(this).parent("div").removeClass("hover");
        flagType = $(this).attr("type");
        if (flagType == "radio") {      //radio
            radioName = $(this).attr("name");
            $("input:radio[name='" + radioName + "']").parent("div").removeClass("checked");
            $(this).parent("div").addClass("checked");
        }
        else {  //checkbox
            isCheck = $(this).is(':checked');
            iCheckFlag($(this).closest("span"), isCheck);
        }
    });
    $("input[flagInput='iCheck']").live("hover", function (event) {    //鼠标移过事件
        if (event.type == 'mouseover') {
            if (!$(this).parent("div").hasClass("checked"))
                $(this).parent("div").addClass("hover");
        }
        else
            $(this).parent("div").removeClass("hover");
    });
    $("label[flagInput='iCheck']").live("hover", function (event) {    //鼠标移过事件
        if (event.type == 'mouseover') {
            if (!$(this).prev("div").hasClass("checked"))
                $(this).prev("div").addClass("hover");
        }
        else
            $(this).prev("div").removeClass("hover");
    });
}

function iCheckFlag(span, isCheck) {    //更新确认框的状态<所在span, 选中状态>
    if ($(span).find("input").hasAttr("flagId")) {    //拥有对应的父类型
        var flagIds = $(span).find("input").attr("flagId").split(" ");
        var flagTop = $(span).find("input").hasAttr("flagTop"); //标志为父类型
        var flagId;
        for (var i in flagIds) {
            flagId = flagIds[i];
            if (flagTop) {    //父flagId,同步全选/反选所有的子类型
                $("input[flagInput='iCheck']").each(function () {
                    if (hasVal($(this).attr("flagId"), flagId, " ")) {
                        iCheckState(this, isCheck);
                    }
                })
            }
            else {  //子flagId,切换本身的选中状态,并判断所属类型是否已全选/反选,再更新对应父节点的选中状态
                iCheckState(span.find("input"), isCheck);
                //isUnify = true;
                if (isCheck) {   //选中子节点,需判断所有同flagId子节点是否全部选中
                    iCheckIsAll(flagId);
                }
                else {   //反选节点,直接反选对应flagId父节点即可
                    $("input[flagInput='iCheck']").each(function () { //遍历所有该flagId的点,判断是否已全选/反选
                        if ($(this).hasAttr("flagTop") && hasVal($(this).attr("flagId"), flagId, " ")) { //同flagId子节点
                            iCheckState(this, isCheck);
                        }
                    });
                }
            }
        }
    }
}

function iCheckState(input, isCheck) {    //切换选中状态<input, 选中状态>
    var objCheck;
    $(input).each(function () {
        objCheck = $(this)[0];
        if (typeof(objCheck) != "undefined")
            objCheck.checked = isCheck;
    });
    if (isCheck) {    //选中
        $(input).closest("div").addClass("checked");
    }
    else   //反选
        $(input).closest("div").removeClass("checked");
}

function iCheckIsAll(flagId) {   //判断是否已全选所有该flagId的节点
    var isUnify = true;    //所有flagId对应子节点是否统一
    var isUnifyParent;  //flagId对应的父类型节点
    $("input[flagInput='iCheck']").each(function () { //遍历所有该flagId的点,判断是否已全选/反选
        if (hasVal($(this).attr("flagId"), flagId, " ")) { //同flagId子节点
            if ($(this).hasAttr("flagTop")) {    //父类型,仅标志,不做判断是否选中
                isUnifyParent = this;
            }
            else if ($(this)[0].checked != true) {
                isUnify = false;
                return false;
            }
        }
    });
    if (isUnify == true) {    //所有flagId的子节点的状态一致
        iCheckState(isUnifyParent, true);
    }
}

function hasVal(allVal, val, rule) { //判断字符串内是否包含某一值(如"123 12" 是否包含"12")
    if (typeof(allVal) == "undefined")
        return false;
    var vals = allVal.split(rule);
    return $.inArray(val, vals) > -1;
}

function vagueVal(allVal, val) { //模糊匹配,val字符串是否在allVal内
    return allVal.indexOf(val) > -1;
}
