<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Insert title here</title>
    <script>
        window.onload = function () {
            var stateComm = "${map.regComm}";
            var projName = "${map.projName}";
            var stateImg;
            /*if(stateComm==0)	//已开启数据通信
             stateImg = "../img/state_green.png";
             else	//未开启
             stateImg = "../img/state_red.png";*/
            var htmlImg = "<a href='javascript:turnSystemState()'><img id='imgState' src='" + stateImg + "' width='16px' border='none' style='vertical-align: sub'></a>";
            document.getElementById("span1").innerHTML = "　" + projName + "　" + htmlImg;
            transState(stateComm);
        };
        ;
        ;
        ;
        ;
        ;
        ;
        ;
        function turnSystemState() {
            top.iframe1.rights.location = "../system/showSystemStates.action";
        }
        function transState(state) {
            //if(state==0){
            top.runState = true;
            document.getElementById("imgState").src = "../img/state_green.png";
            document.getElementById("imgState").title = "数据获取中";
            /*}
             else {
             top.runState = false;
             document.getElementById("imgState").src = "../img/state_red.png";
             document.getElementById("imgState").title="未获取数据";
             }*/
        }
    </script>
    <style type="text/css">
        * {
            padding: 0;
            margin: 0;
        }

        body {
            background-color: #CCCCFF;
            font-family: lucida Grande, Verdana;
            font-size: 13px
        }

        div {
            margin-right: 10px;
            font-size: 13px;
            line-height: 19px;
        }

        a:visited {
            color: #000EEE;
        }

        a {
            color: #000EEE;
        }
    </style>
</head>
<body>
<div>
    <span id="span1" style="float:left">　</span>
    <span style="float:right">　${map.copyright}</span>
</div>
</body>
</html>