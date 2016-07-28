<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<html>
<head>
    <title>欢迎界面</title>
    <script type="text/javascript" src="../js/jquery-1.6.min.js"></script>
    <script type="text/javascript">
        period = '${periodId}';		//采样周期
        window.onload = function () {
            setTimeout("ajaxValue()", period * 1000);
        };
        function ajaxValue() {
            var ids = "";
            $(".chars").each(function (i) {
                ids += $(this).attr("id") + ",";
            });
            $.post(
                    "ajaxValue",
                    {ids: ids.substring(0, ids.length - 1)},
                    function (data) {
                        updateChars(data);		//更新参数值
                    },
                    "json"
            );
        }
        function updateChars(data) {
            $(".chars").each(function (i) {
                $(this).html("<font size=2 color=" + data.rows[i].State + ">" + data.rows[i].Value + "</font>");
            });
            setTimeout("ajaxValue()", period * 1000);
        }
    </script>
    <style>
        body {
            font-family: lucida Grande, Verdana;
            border: 1px #27408B solid;
            background-color: #CCFFFF;
        }

        .span {
            position: relative;
            left: 230px;
            top: 150px;
            color: blue;
            font: bold 22px/26px "\5FAE\8F6F\96C5\9ED1", "\9ED1\4F53";
        }

        .top {
            /* color:blue; */
            font-size: 14px;
        }

        .td {
            width: 764px;
            height: 455px;
            background: url(../img/welcome2.jpg) no-repeat;
        }
    </style>
</head>
<body>
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
            <div align="left">
                <table width="100%">
                    <s:iterator value="rows">
                        <tr>
                            <td align="right"><span class="top"><strong><s:property value="charName"/></strong></span>
                            </td>
                            <td></td>
                        </tr>
                        <s:iterator value="rows1">
                            <tr>
                                <td width="130px" align="right"><font size=2><s:property value="charName1"/>:</font>
                                </td>
                                <td align="left">
                                    <div class="chars" id="<s:property value="charId"/>"><font size=2
                                                                                               color="<s:property value="charstate"/>"><s:property
                                            value="charValue1"/></font></div>
                                </td>
                            </tr>
                        </s:iterator>
                        <tr>
                            <td height="15px"></td>
                        </tr>
                    </s:iterator>
                </table>
                <br/>
            </div>
        </td>
        <td width="764px">
            <div align="center">
                <table>
                    <tr>
                        <td class="td"><span class="span">无线传感器测试软件</span>
                            <br/><span></span>
                        </td>
                    </tr>
                </table>
            </div>
        </td>
        <td>
            <div align="left">
                <table width="100%" align="left">
                    <s:iterator value="rows2">
                        <tr>
                            <td align="right"><span class="top"><strong><s:property value="charName"/></strong></span>
                            </td>
                            <td></td>
                        </tr>
                        <s:iterator value="rows1">
                            <tr>
                                <td width="130px" align="right"><font size=2><s:property value="charName1"/>:</font>
                                </td>
                                <td align="left">
                                    <div class="chars" id="<s:property value="charId"/>"><font size=2
                                                                                               color="<s:property value="charstate"/>"><s:property
                                            value="charValue1"/></font></div>
                                </td>
                            </tr>
                        </s:iterator>
                        <tr>
                            <td height="15px"></td>
                        </tr>
                    </s:iterator>
                </table>
            </div>
        </td>
    </tr>
</table>
</body>
</html>