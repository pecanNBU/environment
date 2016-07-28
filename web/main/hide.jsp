<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<% String path = request.getContextPath();
    String basePath = request.getScheme()
            + "://" + request.getServerName()
            + ":" + request.getServerPort() + path + "/"; %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="refresh" content="6600; url=top">
    <!-- 页面每隔110分钟自动刷新，防止session过期 -->
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>hide:专用于dwr推送</title>
    <script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath }/dwr/engine.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath }/dwr/util.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath }/dwr/interface/chatService.js"></script>
    <script>
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
        function nowDay() {
            var dateNow = new Date();
            var yearNow = dateNow.getFullYear();
            var monthNow = dateNow.getMonth();
            var dayNow = dateNow.getDate();
            return yearNow + "-" + monthNow + "-" + dayNow + " ";
        }
        var mapChar = new Map();			//参数Id:设备参数~设备
        var mapUnit = new Map();			//单位Id:参数单位

        function showAlerts(msg) {	//推送-警报信息
            top.alarm();	//促发警报
            //top.document.getElementById("alarmd").style.display="";	//top页面出现警报图标
        }
        function showSwitchs(msg) {	//推送-控制开关量结果
            top.switchMsg(msg);
        }
        function switchSynch() {		//推送-完成初始化开关量
            top.switchSynch();
        }
        function moteData() {	//推送-mote数据
            top.iframe1.rights.frames["iframe1"].ggetDatas();
        }
        function test() {
            parent.rights.document.getElementById("iframe1").contentWindow.document.getElementById("alarmS").innerHTML = "2121";
        }
        window.alert = function () { 		//为了防止DWR弹出alert窗口
            return true;
        };

        function onPageLoad() {
            dwr.engine.setActiveReverseAjax(true); 			//激活反转 重要
            dwr.engine.setNotifyServerOnPageUnload(true);	//页面销毁或刷新时销毁当前ScriptSession
        }
    </script>

</head>
<body onload="onPageLoad();">
</body>
</html>