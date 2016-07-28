<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>服务器备份数据管理</title>
    <script type="text/javascript" src="../js/jquery-1.6.min.js"></script>
    <script type="text/javascript" src="../js/My97DatePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="../js/jquery.form.js"></script>
    <script type="text/javascript" src="../js/page.js"></script>
    <link href="../css/style.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript">
        var dataId;
        var url = "json_datas.action?nodeState=${nodeState}";
        var url1 = url;
        var backupInt;		//用于获取备份状态
        var stateFlag;
        $(function () {
            jsons(1, 50, url);		//默认为第一页，每页50条数据
        });
        function add() {
            $("#dataDesc").val("");
            beCenter("detail");
            $("#detail_bg").show();
            $("#detail").show(300);
        }
        function backup() {
            $("#detail_bg").css("z-index", "50004");
            beCenter("backState");
            $("#stateHtml").html("<span class='loading'>正在初始化，请稍候...</span>");
            $("#backState").show();
            var dataPara = getFormJson(form1);
            $("#stateHtml").html("");
            backupInt = self.setInterval("dataState(0)", 100);	//实时获取备份的进度
            $.ajax({
                url: form1.action,
                type: form1.method,
                data: $.param(dataPara, true),
                success: function (data) {
                    closeBack();
                    var flag = data.flag;
                    $("#detail").hide();
                    if (flag == 0) {
                        top.success(0, "备份成功");
                        var jumpPage = $("#jumpPage").val();
                        var pageSize = $("#pageSize").val();
                        jsons(jumpPage, pageSize, url);
                    }
                    else {
                        top.success(1, "备份失败");
                        $("#detail_bg").hide();
                    }
                },
                error: function (data) {
                    closeBack();
                    ajaxError(data);
                }
            });
        }
        function down(id) {
            $.ajax({
                type: "post",
                dataType: "json",
                url: "checkData.action",
                data: "dataId=" + id,
                success: function callBack(data) {
                    var flag = data.flag;
                    if (flag == 1)
                        top.success(1, "该备份数据库已丢失");
                    else {
                        window.location.href = "download.action?dataId=" + id;
                        top.success(0, "下载成功");
                    }
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        }
        function recover(id) {
            dataId = id;
            form3.reset();
            $("#recData").html($("#tr_" + id + ">td:eq(1)").html());
            beCenter("recover");
            $("#detail_bg").show();
            $("#recover").show(300);
        }
        function recover_done() {
            $("#recover").hide();
            $("#detail_bg").css("z-index", "50004");
            beCenter("backState");
            $("#backState").show();
            $("#stateHtml").html("");
            backupInt = self.setInterval("dataState(1)", 100);	//实时获取还原的进度
            $.ajax({
                type: "post",
                dataType: "json",
                url: "recoverDatas.action?dataId=" + dataId,
                data: $.param(getFormJson(form3), true),
                success: function callBack(data) {
                    closeBack();
                    var flag = data.flag;
                    if (flag == 0) {
                        top.success(0, "还原成功");
                        var jumpPage = $("#jumpPage").val();
                        var pageSize = $("#pageSize").val();
                        jsons(jumpPage, pageSize, url);
                    }
                    else if (flag == 1) {
                        top.success(1, "还原失败，请检查备份数据库");
                        $("#waiting").hide();
                        $("#detail_bg").hide();
                    }
                    else if (flag == 2) {
                        top.success(1, "还原失败，备份的数据库已丢失");
                        $("#waiting").hide();
                        $("#detail_bg").hide();
                    }
                },
                error: function (data) {
                    closeBack();
                    ajaxError(data);
                }
            });
        }
        function del(id) {
            dataId = id;
            $("#detail_bg").show();
            $("#a_title").html("删除确认");
            $("#aTitle").html("删除后将无法恢复，您确定要删除吗？");
            beCenter("alert");
            $("#alert").show(300);
            $("#alert_update").removeAttr("onclick");
            $("#alert_update").attr("onclick", "del_done()");
        }
        function del_done() {
            $("#alert").hide();
            beCenter("waiting");
            $("#waitings").html("删除中，请稍候....");
            $("#waiting").show();
            $.ajax({
                type: "post",
                dataType: "json",
                url: "removeData.action?dataId=" + dataId,
                success: function (data) {
                    var flag = data.flag;
                    $("#alert").hide(300);
                    if (flag == 0) {
                        top.success(0, "删除成功");
                        var jumpPage = $("#jumpPage").val();
                        var pageSize = $("#pageSize").val();
                        jsons(jumpPage, pageSize, url);
                    }
                    else {
                        top.success(1, "删除失败");
                        $("#detail_bg").hide();
                        $("#waiting").hide();
                    }
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        }
        function upload() {
            form2.reset();
            $("#file_").hide();
            beCenter("upload");
            $("#detail_bg").show();
            $("#upload").show(300);
        }
        function upload_done() {
            var value = $("#file").val();
            var fileEx = value.substring(value.lastIndexOf("."));
            if (value == "" || fileEx != ".sql") {
                $("#file_").css("display", "inline");
            }
            else {
                $("#detail_bg").css("z-index", "50004");
                beCenter("waiting");
                $("#waitings").html("上传中，请稍候....");
                $("#waiting").show();
                var options = {
                    url: "uploadDatas.action",
                    type: "POST",
                    dataType: "json",
                    success: function (data) {
                        var flag = data.flag;
                        $("#upload").hide();
                        if (flag == 0) {
                            top.success(0, "上传成功");
                            var jumpPage = $("#jumpPage").val();
                            var pageSize = $("#pageSize").val();
                            jsons(jumpPage, pageSize, url);
                        }
                        else {
                            top.success(1, "上传失败");
                            $("#detail_bg").hide();
                            $("#waiting").hide();
                        }
                    },
                    error: function (data) {
                        ajaxError(data);
                    }
                };
                $("#form2").ajaxSubmit(options);
            }
        }
        function dataState(stateType) {		//实时显示上传、还原等操作的状态
            $.ajax({
                type: "post",
                dataType: "json",
                url: "ggetBaseState.action?stateType=" + stateType,
                success: function (data) {
                    var state = data.flag;
                    if (stateFlag != state)
                        stateFlag = state;
                    else
                        return;
                    $("#stateHtml span").attr("class", "done");
                    beCenter("backState");
                    if (stateType == 0) {
                        switch (state) {
                            case 0:
                                $("#stateHtml").append("<span class='loading'>开始备份数据状态表...</span>");
                                break;
                            case 1:
                                $("#stateHtml").append("<span class='loading'>成功备份数据状态表...</span>");
                                break;
                            case 2:
                                $("#stateHtml").append("<span class='loading'>开始备份基础表...</span>");
                                break;
                            case 3:
                                $("#stateHtml").append("<span class='loading'>成功备份基础表...</span>");
                                break;
                        }
                    }
                    else {
                        switch (state) {
                            case 0:
                                $("#stateHtml").append("<span class='loading'>开始还原前的准备工作...</span>");
                                break;
                            case 1:
                                $("#stateHtml").append("<span class='loading'>开始备份所有数据...</span>");
                                break;
                            case 2:
                                $("#stateHtml").append("<span class='loading'>成功备份所有数据...</span>");
                                break;
                            case 3:
                                $("#stateHtml").append("<span class='loading'>开始删除重复的状态表数据...</span>");
                                break;
                            case 4:
                                $("#stateHtml").append("<span class='loading'>成功删除重复的状态表数据...</span>");
                                break;
                            case 5:
                                $("#stateHtml").append("<span class='loading'>准备工作结束，开始还原数据...</span>");
                                break;
                            case 6:
                                $("#stateHtml").append("<span class='loading'>开始还原基础表...</span>");
                                break;
                            case 7:
                                $("#stateHtml").append("<span class='loading'>成功还原基础表...</span>");
                                break;
                            case 8:
                                $("#stateHtml").append("<span class='loading'>开始还原状态表...</span>");
                                break;
                            case 9:
                                $("#stateHtml").append("<span class='loading'>成功还原状态表...</span>");
                                break;
                            case 10:
                                $("#stateHtml").append("<span class='loading'>还原成功，操作结束...</span>");
                                break;
                        }
                    }
                },
                error: function (data) {
                    ajaxError(data);
                }
            });
        }
        function closeBack() {
            clearInterval(backupInt);
            $("#stateHtml span").attr("class", "done");
            setTimeout("$('#backState').hide()", 300);
        }
    </script>
    <style type="text/css">
        #upload, #recover {
            display: none;
            position: absolute;
            z-index: 50003;
            border: 0;
        }

        #backState {
            z-index: 50020;
        }

        #backState .divContent {
            border: 1px solid #8AE4DD;
            min-width: 200px;
            background-color: #f0fcff;
            text-align: left;
            padding: 20px 40px 20px 0;
        }

        #backState span {
            line-height: 25px;
            display: block;
            padding-left: 50px
        }

        #backState .loading {
            background: url(../img/tree_loading.gif) no-repeat 30px 5px;
            color: red
        }

        #backState .done {
            background: url(../img/state_done.png) no-repeat 30px 5px;
            color: green;
        }
    </style>
</head>
<body>
<div align="left">
    <table id="vv">
        <thead>
        <tr>
            <th width=5%>序号</th>
            <th width=15%>备份时间</th>
            <th width=10%>备份来源</th>
            <th width=10%>数据容量</th>
            <th width=20%>设备状态时间</th>
            <th width=20%>备份说明</th>
            <c:if test="${nodeState==1}">
                <th width=20%>相关操作</th>
            </c:if>
        </tr>
        </thead>
    </table>
</div>
<div class="h1">
    <table id="v">
        <tbody id="bbsTab">
        </tbody>
    </table>
</div>
<div id="Page">
    <c:if test="${nodeState==1}">
        <a class='aBtn aEdit' href='javascript:' onclick='add();'>备份数据库</a>
        <!-- <a class='aBtn aEdit' href='javascript:' onclick='upload();'>上传数据库</a> -->
    </c:if>
    <div id="pages"></div>
</div>
<div id="alert" class="div_alt">
    <s:include value="../main/alert.jsp"/>
</div>
<div id="waiting">
    <span id="waitings"></span>
</div>
<div id="backState" class="div_alt divFloat">
    <div class="divContent" id="stateHtml">
    </div>
</div>
<div id="detail_bg"></div>
<div id="detail" class="div_alt">
    <div class="divContent" id="divss"
         style="border:1px solid #8AE4DD;width:500px;height:320px;background-color:#f0fcff;">
        <div class="detail_title" onmousedown="mouseDownFun('detail')"><span class="detail_header">　备份数据库</span><span
                class="detail_close" onclick="closeDiv('detail')" title="关闭">X</span></div>
        <br/>
        <div align="center">
            <s:form name="form1" id="form1" method="post" action="backupDatas.action" theme="simple">
                <table class="pswTable">
                    <tr>
                        <td class="cBlue">　用户名：</td>
                        <td><input id="dbRoot" name="dbRoot" value="root" class="inputText"></td>
                    </tr>
                    <tr>
                        <td class="cBlue">　　密码：</td>
                        <td><input name="dbPsw" id="dbPsw" type="password" value="bhit414" class="inputText"></td>
                    </tr>
                    <tr>
                        <td class="cBlue">时间间隔：</td>
                        <td>
                            <input id="stDt" name="stDt" Style="width:120px;margin-left:2px;" onclick="WdatePicker()"
                                   readonly class="Wdate inputText"
                                   onfocus="WdatePicker({minDate:'2013-01-01',maxDate:'#F{$dp.$D(\'endDt\',{d:0});}'})">
                            至 <input id="endDt" name="endDt" Style="width:120px" onclick="WdatePicker()" readonly
                                     class="Wdate inputText"
                                     onfocus="WdatePicker({minDate:'#F{$dp.$D(\'stDt\',{d:0});}',maxDate:'%y-%M-%d'})">
                        </td>
                    </tr>
                    <tr>
                        <td class="cBlue">备份说明：</td>
                        <td><textarea name="dataDesc" id="dataDesc" style="width:355px;height:100px;margin-left:2px;"
                                      class="inputText"></textarea></td>
                    </tr>
                </table>
            </s:form>
        </div>
        <div style="padding-top:20px;">
            <input class="btn_1" type="button" onclick="backup();" value="备份"/>
            　　<input class="btn_2" type="button" onclick="closeDiv('detail');" value="取消"/>
        </div>
    </div>
</div>
<div id="upload" class="div_alt">
    <div class="divContent" id="divss"
         style="border:1px solid #8AE4DD;width:500px;height:255px;background-color:#f0fcff;">
        <div class="detail_title" onmousedown="mouseDownFun('upload')"><span class="detail_header">　上传数据库</span><span
                class="detail_close" onclick="closeDiv('upload')" title="关闭">X</span></div>
        <br/>
        <div align="center">
            <s:form name="form2" id="form2" method="post" action="uploadDatas.action" enctype="multipart/form-data"
                    theme="simple">
                <table class="pswTable">
                    <tr>
                        <td class="cBlue">　　数据库：</td>
                        <td><input type="file" name="file" id="file" onclick="resetBorder(id);"
                                   style="width:180px"/>　<span class="alarm" id="file_">请上传sql格式的数据库文件</span></td>
                    </tr>
                    <tr>
                        <td class="cBlue">数据库说明：</td>
                        <td><textarea name="dataDesc" id="dataDesc1" style="width:355px;height:100px;margin-left:2px;"
                                      class="inputText"></textarea></td>
                    </tr>
                </table>
            </s:form>
        </div>
        <div style="padding-top:20px;">
            <input class="btn_1" type="button" onclick="upload_done();" value="确认"/>
            　　<input class="btn_2" type="button" onclick="closeDiv('upload');" value="取消"/>
        </div>
    </div>
</div>
<div id="recover" class="div_alt">
    <div class="divContent" id="divss"
         style="border:1px solid #8AE4DD;width:500px;height:265px;background-color:#f0fcff;">
        <div class="detail_title" onmousedown="mouseDownFun('recover')"><span class="detail_header">　还原数据库</span><span
                class="detail_close" onclick="closeDiv('recover')" title="关闭">X</span></div>
        <br/>
        <div align="center">
            <s:form name="form3" id="form3" method="post" action="uploadDatas.action" enctype="multipart/form-data"
                    theme="simple">
                <table class="pswTable">
                    <tr>
                        <td class="cBlue">　数据库：</td>
                        <td id="recData"></td>
                    </tr>
                    <tr>
                        <td class="cBlue">还原说明：</td>
                        <td><textarea name="recDesc" id="recDesc" style="width:355px;height:100px;margin-left:2px;"
                                      class="inputText"></textarea></td>
                    </tr>
                    <tr>
                        <td class="cBlue">　　备注：</td>
                        <td style="color:red">还原时系统将自动备份当前数据库</td>
                    </tr>
                </table>
            </s:form>
        </div>
        <div style="padding-top:20px;">
            <input class="btn_1" type="button" onclick="recover_done();" value="确认"/>
            　　<input class="btn_2" type="button" onclick="closeDiv('recover');" value="取消"/>
        </div>
    </div>
</div>
</body>
</html>