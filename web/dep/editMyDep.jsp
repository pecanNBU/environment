<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="sx" uri="/struts-dojo-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>编辑个人所在单位信息</title>
    <script type="text/javascript" src="../js/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../js/jquery.form.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <script type="text/javascript" charset="utf-8" src="../js/ueditor/ueditor.all.js"></script>
    <script type="text/javascript" charset="utf-8" src="../js/ueditor/ueditor.config.js"></script>
    <link rel="stylesheet" type="text/css" href="../css/button.css"/>
    <script type="text/javascript">
        var flag = 0;
        $(function () {
            uEditor = new baidu.editor.ui.Editor({
                toolbars: [
                    ['fullscreen', 'source', '|', 'undo', 'redo', '|',
                        'bold', 'italic', 'underline', 'strikethrough', 'superscript', 'subscript', 'removeformat',
                        '|', 'forecolor', 'backcolor', 'insertorderedlist', 'insertunorderedlist', 'selectall', 'cleardoc', '|',
                        'paragraph', 'fontfamily', 'fontsize', '|',
                        'justifyleft', 'justifycenter', 'justifyright', 'justifyjustify', '|',
                        'link', 'unlink', '|',
                        'insertimage', 'insertvideo', 'attachment', 'map', '|',
                        'horizontal', 'print', 'preview', 'help']
                ]
                //更多其他参数，请参考editor_config.js中的配置项
            });
            uEditor.render('depDesc');
            $("#depDesc").width(700).height(150);
            $.ajax({
                type: "post",
                dataType: "json",
                url: "json_myUserDep.action",
                success: function callBack(data) {
                    var map = data.map;
                    $("#depId").val(map.depId);
                    $("#depName").html(map.depName);
                    $("#depName1").html(map.depName);
                    $("#depAddr").val(map.depAddr);
                    $("#leaderUserId").val(map.leaderUserId);
                    //$("#depDesc").val(map.depDesc);
                    uEditor.addListener("ready", function () {
                        uEditor.setContent(map.depDesc, false);
                        var dHeight = document.documentElement.clientHeight;
                        if ($(".divContent").height() < dHeight - 30)
                            $(".divContent").height(dHeight - 30);
                        setTimeout("setBg()", 2000);		//等内容加载完以及uEditor调整完高度
                    });
                    var dHeight = document.documentElement.clientHeight;
                    $("#depContent").height(dHeight - 50);
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        });

        function save() {
            if (flag == 0) {
                $("#detail_bg").show();
                /*beCenter("waiting");
                 $("#waitings").html("保存中，请稍候....");
                 $("#waiting").show();
                 jsons_save(form1);
                 //form1.submit();*/
                if ($("#fileLogo").val() == "") {	//没有选择照片，则不上传
                    jsons_save(form1);
                }
                else {
                    $("#detail").hide();
                    beCenter("waiting");
                    $("#waitings").html("保存中，请稍候....");
                    $("#waiting").show();
                    var options = {
                        url: "updateMyUserDep.action",
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
        function save_suc(data) {			//添加or修改成功后的返回函数
            var flag = data.flag;
            if (flag == 1)	//成功
                parent.location.href = "./showMyDep.action";
            else
                location.reload;
        }
        function beCenter(id) {		//垂直居中
            var height = $("#" + id).height();
            var ch = $(window).height();
            var top = $(document).scrollTop();
            var divTop = top + (parseInt(ch) - parseInt(height)) / 2;			//div外还有10像素的裙边
            $("#" + id).css("top", divTop > 0 ? divTop : 0);
            var width = $("#" + id).width();
            var offsetWidth = $(document).width();
            var divLeft = (parseInt(offsetWidth) - parseInt(width)) / 2;
            $("#" + id).css("left", divLeft);
        }
        function back() {
            parent.location.href = "showMyDep.action";
        }
    </script>
    <style>
        body {
            font: 14px arial, 微软雅黑, 宋体, sans-serif;
            margin: 1px;
            text-align: center;
        }

        #tb1 tr {
            height: 35px
        }

        #tb1 input {
            height: 20px;
        }

        #tb1 select {
            height: 25px;
        }

        #detail_bg {
            position: absolute;
            top: 0px;
            left: 0px;
            width: 100%;
            height: 100%;
            z-index: 50002;
            background-color: #000;
            display: none;
            opacity: 0.3;
            filter: alpha(opacity=30);
        }

        #waiting {
            position: absolute;
            z-index: 50015;
            display: none;
            border: 1px solid #8AE4DD;
            min-width: 200px;
            height: 50px;
            line-height: 50px;
            background-color: #f0fcff;
            border-radius: 4px;
            padding: 0 10px;
            text-align: center;
        }

        #waitings {
            background: url(../img/tree_loading.gif) no-repeat;
            padding-left: 20px;
        }

        .inputAlarm {
            border: 2px solid red
        }

        .alarm {
            display: none;
            color: red;
            line-height: 25px;
            _line-height: 25px;
            padding-left: 6px;
            font-size: 13px
        }

        .divContent {
            padding: 0;
            margin: 0 0 15px 0;
        }

        .mapContent {
            height: 468px;
            background: #f0fcff; /* 一些不支持背景渐变的浏览器 */
            border-bottom-left-radius: 5px;
            border-bottom-right-radius: 5px;
        }

        .div_alt {
            box-shadow: 0px 3px 26px rgba(0, 0, 0, .9);
            background: url(../img/detail_shadow.png) repeat;
            padding: 8px;
            border-radius: 5px;
        }

        .detail_title {
            height: 30px;
            width: 100%;
            border-bottom: 1px solid #8AE4DD;
            cursor: move;
            border-top-left-radius: 5px;
            border-top-right-radius: 5px;
            background-color: #C1E4F0;
            background-image: -moz-linear-gradient(top, #E7F7FA, #C1E4F0); /* Firefox */
            background-image: -webkit-gradient(linear, left top, left bottom, color-stop(0, #E7F7FA), color-stop(1, #C1E4F0)); /* Saf4+, Chrome */
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#E7F7FA', endColorstr='#C1E4F0', GradientType='0'); /* IE*/
            background: linear-gradient(to bottom, #E7F7FA, #C1E4F0);
        }

        .detail_btn {
            margin-bottom: 10px;
        }

        .detail_close {
            float: right;
            margin-right: 14px;
            color: #000;
            cursor: pointer;
            font-size: 16px;
            line-height: 30px
        }

        .detail_header {
            float: left;
            font-size: 14px;
            font-weight: bold;
            color: #333;
            line-height: 30px;
        }

        .tdTr {
            text-align: right;
            color: #217FA7;
            padding-right: 20px;
            font-size: 15px;
        }
    </style>
</head>
<body class="divContent">
<table id="tb2">
    <tr>
        <td style="width:900px;font-size:30px;line-height:60px;" id="depName1"></td>
    </tr>
    <tr>
        <td>
            <hr/>
        </td>
    </tr>
</table>
<s:form id="form1" name="form1" action="updateMyUserDep" method="post" enctype="multipart/form-data" theme="simple">
    <input type="hidden" name="depId" id="depId">
    <table id="tb1" style="text-align:left">
        <tr>
            <td width="120px" class="tdTr">单位名称：</td>
            <td width="550px" id="depName" style="font-size:15px;"></td>
        </tr>
        <tr>
            <td class="tdTr">单位负责人：</td>
            <td><s:select style="width:220px;" name="leaderUserId" id="leaderUserId" list="%{userInfos}" listKey="id"
                          listValue="userName"/></td>
        </tr>
        <tr>
            <td class="tdTr">单位地址：</td>
            <td><input id="depAddr" name="depAddr" style="width:400px;" class="inputText"></td>
        </tr>
        <tr>
            <td class="tdTr" valign="top">单位描述：</td>
            <td>
                <script id="depDesc" name="depDesc" type="text/plain"></script>
            </td>
        </tr>
        <tr>
            <td class="tdTr">单位LOGO：</td>
            <td><input type="file" name="file" id="fileLogo"></td>
        </tr>
    </table>
</s:form>
<input class="btn_1" type="button" onclick="save();" value="保存"/>　　　
<input class="btn_2" type="button" onclick="back();" value="返回"/>
<div id="detail_bg"></div>
<div id="waiting">
    <span id="waitings"></span>
</div>
</body>
</html>