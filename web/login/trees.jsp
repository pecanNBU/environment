<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>菜单</title>
    <%
        String path = request.getContextPath();
        String basePath = request.getScheme() + "://"
                + request.getServerName() + ":" + request.getServerPort()
                + path + "/";
    %>
    <base href="<%=basePath%>">
    <script type="text/javascript" src="js/jquery-1.6.min.js"></script>
    <link rel="StyleSheet" href="js/dtree.css" type="text/css"/>
    <script type="text/javascript" src="js/dtree.js"></script>
    <SCRIPT type="text/javascript">
        function show() { 						//在foot左侧显示当前所在的模块
            var id = d.selectedNode;
            var str = "";
            var strshow = "";
            var url = "";
            var href = "";
            for (var i = 0; i < 10000; i++) {
                if (id != 0) {
                    url = d.aNodes[id].url;
                    href = "<%=basePath%>" + d.aNodes[id].url;
                    if (url) {
                        str += "<a target=" + 'rights' + " href='" + href + "'>" + d.aNodes[id].name + "</a>" + ",";
                    }
                    else {
                        str += d.aNodes[id].name + ",";
                    }
                    id = d.aNodes[id].pid;
                }
                else {
                    str1 = str.split(",");
                    for (var j = str1.length - 2; j >= 0; j--) {
                        strshow += str1[j] + " >>　";
                    }
                    strshow = strshow.substring(0, strshow.lastIndexOf(' '));
                    parent.foot.window.document.getElementById("span1").innerHTML = strshow;
                    return false;
                }
            }
        }
        function checkStatus(no, chkBox) {
            checkPar(chkBox);//当子目录选中时,父目录也选中
            var chks = document.getElementsByTagName('input');//得到所有input
            for (var i = 0; i < chks.length; i++) {
                if (chks[i].name.toLowerCase() == 'check') {//得到所名为check的input
                    if (chks[i].className == no) {//ID等于传进父目录ID时
                        chks[i].checked = chkBox.checked;//保持选中状态和父目录一致
                        checkStatus(chks[i].value, chks[i]);//递归保持所有的子目录选中
                    }
                }
            }
        }

        function checkPar(chkBox) {
            if (chkBox.name.toLowerCase() == 'check' && chkBox.checked && chkBox.className != 0) {//判断本单击为选中,并且不是根目录,则选中父目录
                var chkObject = document.getElementById("ch" + chkBox.className);//得到父目录对象
                chkObject.checked = true;
                checkPar(chkObject);
            }
        }
        function chan(id) {
            parent.document.getElementById("rights").contentWindow.document.getElementById("iframe1").contentWindow.changeDiv("chartdiv" + id);
            parent.document.getElementById("rights").contentWindow.document.getElementById("iframe1").contentWindow.changeDiv("fcexpDiv" + id);
        }
    </SCRIPT>
    <style>
        b:visited {
            color: #000eee;
            text-decoration: none;
        }

        html {
            *overflow-y: scroll;
        }

        body {
            background-color: #E7F0FA
        }
    </style>
</head>
<body onclick="show()">
<a href="javascript: d.openAll();"><font size=2>展开</font></a> | <a href="javascript: d.closeAll();"><font
        size=2>关闭</font></a>
<script type="text/javascript">
    <!--
    //var i = "${attr.i}";
    d = new dTree('d');
    d.add(0, -1, '无线传感器测试软件');
    d.add(1, 0, '无线传感器测试软件');
    <s:iterator value="rows">
    d.add(<s:property value="id" />, <s:property value="pid" />, '<s:property value="name" />', '<s:property value="url" />', '<s:property value="title" />', '<s:property value="target" />', '', '', '<s:property value="open" />');
    </s:iterator>
    document.write(d);
    //-->
</script>
</body>
</html>