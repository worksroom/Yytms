<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <base href="<%=basePath%>">
    <title>模块维护</title>
    <link href="resources/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css">
    <link href="resources/ligerUI/skins/ligerui-icons.css" rel="stylesheet" type="text/css">
    <link href="resources/css/jquery-ui.min.css" rel="stylesheet" type="text/css">
    <link href="resources/ligerUI/skins/Gray/css/all.css" rel="stylesheet" type="text/css">
    <script src="resources/jquery/jquery-1.9.0.min.js" type="text/javascript"></script>
    <script src="resources/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="resources/ligerUI/js/ligerui.all.js" type="text/javascript"></script>


    <script type="text/javascript">
        function alert(message) {
            $.ligerDialog.alert(message.toString(), '提示信息');
        }
        function tip(message) {
            $.ligerDialog.tip({title: '提示信息', content: message.toString()});
        }
        var manager;
        var form;
        $(function () {
            manager = $("#maingrid").ligerGrid({
                        columns: [
                            {display: '功能名称', name: 'name', width: 200, align: 'left', editor: {type: 'text'}},
                            {display: '功能编码', name: 'id', width: 150, type: 'int', align: 'left'},
                            {display: '描述', name: 'desc', width: 200, align: 'left', editor: {type: 'text'}},
                            {display: '功能链接', name: 'url', width: 250, align: 'left', editor: {type: 'text'}},
                            {display: '上级节点', name: 'pid', width: 150, type: 'int', align: 'left'},
                            {display: '按钮名称', name: 'exp2', width: 100, type: 'int', align: 'left'}
                        ], width: '100%', pageSizeOptions: [5, 10, 15, 20], height: '97%',
                        onSelectRow: function (rowdata, rowindex) {
                            $("#txtrowindex").val(rowindex);
                        },
                        url: "manager/sysMenu.do?method=menuTreeList",
                        alternatingRow: false,
                        tree: {columnName: 'name'},
                        checkbox: false,
                        autoCheckChildren: false,
                        width: '100%',
                        height: '100%',
                        toolbar: <jsp:include page="../layout/function.jsp" flush="true"/>
                    }
            );
        });

        function addData(item) {
            var selectRow = manager.getSelectedRow();
            var parentRow = selectRow;

            if (manager.isLeaf(parentRow)) {
                tip('叶节点不能增加子节点');
                return;
            }

            $.ligerDialog.open({
                url: 'manager/user/moduleAdd.jsp?id='+selectRow.id, height: 450, width: 750, buttons: [{
                    text: '确定', onclick: function (item, dialog) {
                        var formData = dialog.frame.submitform();
                        $.ajax({
                            cache: true,
                            type: "POST",
                            url:"manager/sysMenu.do?method=addSysModule",
                            data: formData,
                            async: false,
                            error: function(request) {
                            },
                            success: function(data) {
                                manager.reload();
                                dialog.close();
                                $.ligerDialog.tip({
                                    title: '提示信息',
                                    content: data.message
                                });
                            }
                        });
                    }, cls: 'l-dialog-btn-highlight'
                },
                    {
                        text: '取消', onclick: function (item, dialog) {
                        dialog.close();
                    }
                    }], isResize: true
            });

        }

        function addBtnData(item) {
            var selectRow = manager.getSelectedRow();
            var parentRow = selectRow;

            if (!manager.isLeaf(parentRow)) {
                tip('只有页面才能添加按钮');
                return;
            }

            $.ligerDialog.open({
                url: 'manager/user/moduleAdd.jsp?id='+selectRow.id, height: 450, width: 750, buttons: [{
                    text: '确定', onclick: function (item, dialog) {
                        var formData = dialog.frame.submitform();
                        $.ajax({
                            cache: true,
                            type: "POST",
                            url:"manager/sysMenu.do?method=addSysModule",
                            data: formData,
                            async: false,
                            error: function(request) {
                            },
                            success: function(data) {
                                manager.reload();
                                dialog.close();
                                $.ligerDialog.tip({
                                    title: '提示信息',
                                    content: data.message
                                });
                            }
                        });
                    }, cls: 'l-dialog-btn-highlight'
                },
                    {
                        text: '取消', onclick: function (item, dialog) {
                        dialog.close();
                    }
                    }], isResize: true
            });

        }


        function appendToCurrentNodeDownData() {
            var selectRow = manager.getSelectedRow();
            if (!selectRow) return;

            $.ligerDialog.open({
                url: 'manager/user/moduleAdd.jsp?id='+selectRow.pid, height: 450, width: 750, buttons: [{
                    text: '确定', onclick: function (item, dialog) {
                        var formData = dialog.frame.submitform();
                        $.ajax({
                            cache: true,
                            type: "POST",
                            url:"manager/sysMenu.do?method=addSysModule",
                            data: formData,
                            async: false,
                            error: function(request) {
                            },
                            success: function(data) {
                                manager.reload();
                                dialog.close();
                                $.ligerDialog.tip({
                                    title: '提示信息',
                                    content: data.message
                                });
                            }
                        });
                    }, cls: 'l-dialog-btn-highlight'
                },
                    {
                        text: '取消', onclick: function (item, dialog) {
                        dialog.close();
                    }
                    }], isResize: true
            });
        }

        function updateData(){
            var selectRow = manager.getSelectedRow();

            $.ligerDialog.open({
                url: 'manager/user/moduleUpdate.jsp?id='+selectRow.id, height: 450, width: 750, buttons: [{
                    text: '确定', onclick: function (item, dialog) {
                        var formData = dialog.frame.submitform();
                        $.ajax({
                            cache: true,
                            type: "POST",
                            url:"manager/sysMenu.do?method=updateSysModule",
                            data: formData,
                            async: false,
                            error: function(request) {
                            },
                            success: function(data) {
                                manager.reload();
                                dialog.close();
                                $.ligerDialog.tip({
                                    title: '提示信息',
                                    content: data.message
                                });
                            }
                        });
                    }, cls: 'l-dialog-btn-highlight'
                },
                    {
                        text: '取消', onclick: function (item, dialog) {
                        dialog.close();
                    }
                    }], isResize: true
            });
        }

        function upgradeData() {
            var selectRow = manager.getSelectedRow();
            manager.upgrade(selectRow);
        }

        function demotionData() {
            var row = manager.getSelected();
            manager.demotion(row);
        }

        function toggleData() {
            var row = manager.getSelected();
            manager.toggle(row);
        }

        function deleteData(){
            var row = manager.getSelectedRow();
            if (!manager.isLeaf(row)) {
                tip('父节点不能删除');
                return;
            }
            $.ajax({
                cache: true,
                type: "POST",
                url:"manager/sysMenu.do?method=delSysModule",
                data: {"id": row.id},
                async: false,
                error: function(request) {
                },
                success: function(data) {
                    manager.reload();
//                    manager.deleteRow(row);
                    $.ligerDialog.tip({
                        title: '提示信息',
                        content: data.message
                    });
                }
            });

        }

    </script>
</head>
<body style="overflow:hidden">
    <div id="maingrid"></div>
</body>
</html>
