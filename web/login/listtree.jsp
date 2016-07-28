<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="sx" uri="/struts-dojo-tags" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>设备-参数关联</title>
    <style type="text/css">
        <!--
        .STYLE1 {
            font-size: 12px
        }

        -->
    </style>
    <link rel="stylesheet" type="text/css" href="../js/themes/default/easyui.css">
    <link rel="stylesheet" type="text/css" href="../js/themes/icon.css">
    <link rel="stylesheet" type="text/css" href="../js/demo/demo.css">
    <script type="text/javascript" src="../js/jquery-1.6.min.js">
    </script>
    <script type="text/javascript" src="../js/jquery.easyui.min.js">
    </script>
    <link rel="stylesheet" type="text/css" href="../js/demo/demo.css">
    <script type="text/javascript" src="../js/easyDemo.js">
    </script>
    <script type="text/javascript" src="../js/locale/easyui-lang-zh_CN.js">
    </script>
    <script type="text/javascript" src="listtree.js"></script>
</head>
<body style="padding:0;margin:0;height:100%">
<table id="dg" style="padding:0;margin:0;height:100%">
</table>
<div id="dlg" class="easyui-dialog" style="width:770px;height:280px;padding:10px 20px;"
     closed="true" buttons="#dlg-buttons">
    <s:form id="ff" method="post" theme="simple">
        <table width="250" height="80" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="80">
                    <div align="right">参数名称：</div>
                </td>
                <td width="170"><input name="nodename" class="easyui-validatebox" required="true" Style="width:145px">
                </td>
            </tr>
            <tr>
                <td>
                    <div align="right">参数类型：</div>
                </td>
                <td><s:select id="typeId" name="typeId" list="%{treeTypes}" listKey="id" listValue="typeName"
                              Style="width:145px"/></td>
            </tr>
            <tr>
                <td>
                    <div align="right">设备名称：</div>
                </td>
                <td><s:select id="devId" name="devId" list="%{devTypes}" listKey="id" listValue="typeName"
                              Style="width:145px"/></td>
            </tr>
        </table>
    </s:form>
</div>
<div id="add" class="easyui-window" title="添加" style="padding:10px;width:285;height:155;"
     iconCls="icon-add" closed="true" maximizable="false" minimizable="false" collapsible="false">
    <div id="aa">
    </div>
    　　　<a class="easyui-linkbutton" iconCls="icon-ok" href="javascript:void(0)" onclick="add()">添加</a>
    　<a class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="close1()">取消</a>
</div>
<div id="edit" class="easyui-window" title="修改" style="padding:10px;width:285;height:155;"
     iconCls="icon-edit" closed="true" maximizable="false" minimizable="false" collapsible="false">
    <div id="ee">
    </div>
    　　　<a class="easyui-linkbutton" iconCls="icon-ok" href="javascript:void(0)" onclick="edit()">修改</a>
    　<a class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="close2()">取消</a>
</div>
<div id="query" class="easyui-window" title="查询" style="padding:10px;width:330px;height:100;"
     iconCls="icon-search" closed="true" maximizable="false" minimizable="false" collapsible="false">
    <div id="dr">
        <table>
            <tr>
                <td>节点名称：</td>
                <td><input name="id" id="nodename" class="easyui-validatebox" required="true"></td>
                <td><a class="easyui-linkbutton" iconCls="icon-search" href="javascript:void(0);" onclick="querynode()">查询</a>
                </td>
            </tr>
        </table>
    </div>
</div>
</body>
</html>
