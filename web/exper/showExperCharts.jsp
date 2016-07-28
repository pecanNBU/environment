<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE HTML>
<html>
<head>
    <title>设备信息浏览</title>
    <script type="text/javascript" src="../js/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <script type="text/javascript" src="../js/My97DatePicker/WdatePicker.js"></script>
    <link type="text/css" rel="stylesheet" href="../css/cssTab.css"/>
    <link type="text/css" rel="stylesheet" href="../css/style.css"/>
    <script>
        var id = request("regId");
        var showExperChart = "showExperChart.jsp";
        var regName;
        $(function () {
            var secLast = $("#secLast").val();
            var secNow = $("#secNow").val();
            $("#dtBet").val(dtBet);
            $("#chartContent > div").hide();	//Initially hide all content
            $("#chartTab .liTag a").attr("class", "aNormal");
            $("#chartTab li:first a").addClass("aCurrent");
            $("#chartContent > div:first").fadeIn();//Show first tab content
            var _thisCon;
            $("#chartTab .liTag a").bind("click", function (e) {
                $("#iframe1").attr("src", showExperChart + "?id=" + id + "&dtBet=" + dtBet);
                aNow("init");
            });
            $("#chartTab a").hover(function () {
                if ($(this).attr("class") != "aCurrent")
                    $(this).addClass("aHover");
            }, function () {
                if ($(this).attr("class") != "aCurrent")
                    $(this).removeClass("aHover")
            });
            aNow("init");
        });
        function setHeight() {
            var pheight = parent.document.getElementById("rights").clientHeight;
            var theight = document.getElementById("chartTab").offsetHeight;
            $("#iframe1").height(pheight - theight - 5);
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
        function createtag(a, b) {
            var select1 = document.getElementById(a);
            for (var i = select1.length - 1; i > -1; i--) {
                select1.remove(i);
            }
            if (b == 1) {
                var varItem1 = new Option('JPG', '1');
                var varItem2 = new Option('PNG', '2');
                var varItem3 = new Option('PDF', '3');
                select1.options.add(varItem1);
                select1.options.add(varItem2);
                select1.options.add(varItem3);
            }
            else {
                var varItem1 = new Option('EXCEL', '4');
                select1.options.add(varItem1);
            }
        }
        function aNow() {		//切换实时状态：柱状图/表格
            var regId = $("#regId").val();
            var stDt = $("#stDt").val();
            var endDt = $("#endDt").val();
            $("#iframe1").attr("src", showExperChart + "?regId=" + regId + "&stDt=" + stDt + "&endDt=" + endDt);
        }
        function windowTest() {		//新建窗口，在窗口中显示实时的图表
            $("#iframe1")[0].contentWindow.windowTest();
        }
    </script>
    <style>
        html {
            height: 100%;
        }

        body {
            font-size: 14px;
            height: 100%;
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
            padding: 4px 8px 5px;
        }

        .aFirst {
            margin-left: 7px;
        }
    </style>
</head>
<body>
<ul id="chartTab" class="tabs">
    <li class='liTag'><a href="#" name="#chartTab1" flag="now">实验数据</a></li>
    <li id="now" class="liCond">
        参数选择：<s:select id="regId" list="#{4:'温度', 5:'湿度',6:'二氧化碳', 7:'氨气'}" theme="simple"></s:select>
        开始时间：<input id="stDt" name="stDt" style="width:130px;" onclick="WdatePicker()" readonly
                    onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})">
        结束时间：<input id="endDt" name="endDt" style="width:130px;" onclick="WdatePicker()" readonly
                    onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})">
        <a class="aBtn aDetail" href="javascript:" onclick="aNow();">刷 新</a>
    </li>
</ul>
<div id="chartContent" class="tabContent">
    <div id="chartTab1" flag="tabNow">
        <iframe id="iframe1" name="iframe1" frameborder="0" onload="setHeight()" scrolling="no" width="100%"></iframe>
    </div>
</div>
<div id="detail_bg"></div>
</body>
</html>