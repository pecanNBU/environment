$(function () {
    $(window).resize(function () {
        $('#dg').datagrid('resize');
    });
    $('#ff').hide();
    $('#dg').datagrid({
        title: '设备-参数关联',
        iconCls: 'icon-ok',
        //width:760,
        //height:450,
        pageList: [5, 10, 15, 20, 50, 100],
        pageSize: 50,
        nowrap: false,
        striped: true,
        collapsible: true,
        url: 'jsons.action',
        loadMsg: '数据装载中......',
        sortName: 'id',
        sortOrder: 'asc',
        remoteSort: false,
        fit: true,
        fitColumns: true,
        frozenColumns: [[
            {field: 'ck', checkbox: true, value: 'id'}
        ]],
        columns: [[
            {
                title: '设备名',
                field: 'devname',
                width: $(this).width() * 0.25,
                rowspan: 2,
                align: 'center',
                sortable: true
            },
            {
                title: '参数名称',
                field: 'nodename',
                width: $(this).width() * 0.25,
                rowspan: 2,
                align: 'center',
                sortable: true
            },
            {
                title: '参数类型',
                field: 'typeName',
                width: $(this).width() * 0.5,
                rowspan: 2,
                align: 'center',
                sortable: true
            }
        ]],
        pagination: true,
        rownumbers: true,
        toolbar: [{
            text: '全部',
            iconCls: 'icon-ok',
            handler: function () {
                $('#dg').datagrid({url: 'jsons.action'});
            }
        }, '-', {
            text: '添加',
            iconCls: 'icon-add',
            handler: function () {
                $('#add').window({
                    modal: true,
                    closed: false
                });
                $('#ff').show();
                $('#ff').form('clear');
                $('#ff').appendTo('#aa');
            }
        }, '-', {
            text: '修改',
            iconCls: 'icon-edit',
            handler: getSelect
        }, '-', {
            text: '删除',
            iconCls: 'icon-remove',
            handler: del
        }, '-', {
            text: '查询节点',
            iconCls: 'icon-search',
            handler: function () {
                $('#query').window({
                    modal: true,
                    closed: false
                });
            }
        }
        ]
    });
    displayMsg();
});
function left() {
    window.parent.left.location.reload();
}
function displayMsg() {
    $('#dg').datagrid('getPager').pagination({displayMsg: '当前显示从{from}到{to}共{total}记录'});
}
function close1() {
    $('#add').window('close');
}
function close2() {
    $('#edit').window('close');
}
function add() {
    $('#ff').form('submit', {
        url: 'addnode.action',
        onSubmit: function () {
            return $('#ff').form('validate');
        },
        success: function () {
            $.messager.alert('add', '添加信息成功!!!', 'info', function () {
                $('#dg').datagrid({
                    url: 'jsons.action',
                    loadMsg: '更新数据中......'
                });
                left();
                displayMsg();
            });
            close1();
        }
    });
}
var id;
function getSelect() {
    var select = $('#dg').datagrid('getSelected');
    if (select) {
        $('#edit').window({
            modal: true,
            closed: false
        });
        $('#ff').show();
        $('#ff').form('load', select);
        $('#ff').appendTo('#ee');
        $('#id').val(select.id);
        id = select.id;
    } else {
        $.messager.alert('warning', '请选择一行数据', 'warning');
    }
}
function edit() {
    $('#ff').form('submit', {
        url: 'updatenode.action?id=' + id,
        onSubmit: function () {
            return $('#ff').form('validate');
        },
        success: function () {
            $('#dg').datagrid('reload'),
                $('#dg').datagrid({
                    url: 'jsons.action',
                    loadMsg: '更新数据......'
                });
            $.messager.alert('edit', '修改信息成功!!!', 'info');
            left();
            close2();
        }
    });
}
function del() {
    var ids = [];
    var selected = $('#dg').datagrid('getSelections');
    if (0 != selected.length) {
        $.messager.confirm('warning', '确认删除么?', function (id) {
            if (id) {
                ids.size = selected.length;
                for (var i = 0; i < selected.length; i++) {
                    ids.push(selected[i].id);
                }
                $.ajax({
                    type: "POST",
                    url: "delnode.action",
                    data: "ids=" + ids,
                    dataType: "xml",
                    success: function callback() {
                        $('#dg').datagrid('reload');
                        left();
                    }
                });
            }
        });
    } else {
        $.messager.alert('warning', '请选择一行数据', 'warning');
    }
}
function querynode() {
    var queryParams = $('#dg').datagrid('options').queryParams;
    queryParams.queryWord = $('#nodename').val();
    if ("" != queryParams.queryWord) {
        $('#dg').datagrid({
            url: 'querynode.action'
        });
        displayMsg();
        $('#query').window('close');
    }
    else {
        return $('#dr').form('validate');
    }
}

