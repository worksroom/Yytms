<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <base href="<%=basePath%>">
    <meta http-equiv="Content-Language" content="zh-CN"/>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="renderer" content="webkit">
    <title>角色管理</title>

    <link href="resources/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css">
    <link href="resources/ligerUI/skins/ligerui-icons.css" rel="stylesheet" type="text/css">
    <link href="resources/css/jquery-ui.min.css" rel="stylesheet" type="text/css">
    <link href="resources/css/ne.css" rel="stylesheet" type="text/css">
    <link href="resources/ligerUI/skins/Gray/css/all.css" rel="stylesheet" type="text/css">
    <script src="resources/jquery/jquery-1.9.0.min.js" type="text/javascript"></script>
    <script src="resources/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="resources/ligerUI/js/ligerui.all.js" type="text/javascript"></script>
    <script src="resources/js/json2.js" type="text/javascript"></script>
    <script type="text/javascript">

        $(function () {
            window['g'] =
                    $("#maingrid").ligerGrid({
                        checkbox: true,
                        columns: [
                            {display: '角色ID', name: 'id', align: 'left', width: 50, hide: true},
                            {display: '角色名称', name: 'roleName', align: 'left', width: 100, minWidth: 60},
                            {display: '角色状态', name: 'type', minWidth: 120},
                            {display: '创建时间', name: 'createtime', minWidth: 140},
                            {
                                display : '操作',
                                name : 'operation',
                                width : 100,
                                align:"center",
                                render:function(obj){
                                    var result = "<div class='operating'><a class='ui-icon ui-icon-pencil' title='修改' href='javascript:updateData("+obj.id+")'></a><a class='ui-icon ui-icon-trash' title='删除' href='javascript:deleteData(\""+obj.id+"\",2)'></a></div>";
                                    return result;
                                }
                            }
                        ],
                        dataAction: 'server',
                        url: 'manager/sysRole.do?method=roleList',
                        pageSize: 20,
                        rownumbers: true,
                        width: '100%',
                        height: '100%',
                        toolbar: <jsp:include page="../layout/function.jsp" flush="true"/>
                    });


            $("#pageloading").hide();
        });

        function addData(item) {
            $.ligerDialog.open({
                url: 'manager/user/roleAdd.jsp', height: 200, width: 300, buttons: [
                    {
                        text: '确定', onclick: function (item, dialog) {
                        var formData = dialog.frame.submitform();
                        alert(JSON2.stringify(formData));
                        $.ajax({
                            cache: true,
                            type: "POST",
                            url:"manager/sysRole.do?method=addSysRole",
                            data: formData,
                            async: false,
                            error: function(data) {
                                $.ligerDialog.tip({
                                    title: '提示信息',
                                    content: data.message
                                });
                            },
                            success: function(data) {
                                dialog.close();
                                g.reload();
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
                    }
                ], isResize: true
            });
        }




        function deleteData(rowid,position) {
            var returnValue = "";
            var rows = g.getSelecteds();

            if(position==2){
                returnValue = rowid;
            } else if(rows.length>0){
                var selectIdArr = [];
                if (rows.length == 0) {
                    returnValue = "";
                } else {
                    for (var rowid in rows) {
                        selectIdArr.push(rows[rowid]["id"]);
                    }
                    returnValue  = (selectIdArr.join(","));
                }
            }

            alert(returnValue);

            $.ligerDialog.confirm('确定要删除吗', function (yes) {
                if(yes==true){
                    $.ajax({
                        cache: true,
                        type: "POST",
                        url:"manager/sysRole.do?method=deleteSysRole&ids="+returnValue,
                        async: false,
                        error: function(data) {
                            $.ligerDialog.tip({
                                title: '提示信息',
                                content: data.message
                            });
                        },
                        success: function(data) {
                            g.reload();
                            $.ligerDialog.tip({
                                title: '提示信息',
                                content: data.message
                            });
                        }
                    });
                }
            });
        }

        function updateData(id) {
            var row = g.getSelectedRow();

            $.ligerDialog.open({
                url: 'manager/user/roleUpdate.jsp?id='+row.id, height: 200, width: 300, buttons: [
                    {
                        text: '确定', onclick: function (item, dialog) {
                        var formData = dialog.frame.submitform();
                        $.ajax({
                            cache: true,
                            type: "POST",
                            url:"manager/sysRole.do?method=updateSysRole",
                            data: formData,
                            async: false,
                            error: function(data) {
                                $.ligerDialog.tip({
                                    title: '提示信息',
                                    content: data.message
                                });
                            },
                            success: function(data) {
                                dialog.close();
                                g.reload();
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
                    }
                ], isResize: true
            });
        }

        function setMenuData(item) {
            var row = g.getSelectedRow();
            if(row==null){
                $.ligerDialog.tip({
                    title: '提示信息',
                    content: "请选择一个角色"
                });
                return;
            }
            var roleid = row.id;


            $.ligerDialog.open({
                url: 'manager/user/setModule.jsp?roleid=' + roleid,
                height: 500,
                width: 300,
                buttons: [{
                    text: '确定', onclick: function (item, dialog) {
                        var ids = dialog.frame.getChecked();
                        var data = {
                            "ids": ids,
                            "roleid": roleid
                        }
                        $.ajax({
                            cache: true,
                            type: "POST",
                            url: "manager/sysRole.do?method=setModule",
                            data: data,
                            async: false,
                            error: function (data) {
                                $.ligerDialog.tip({
                                    title: '提示信息',
                                    content: data.message
                                });
                            },
                            success: function (data) {
                                dialog.close();
//                                g.reload();
                                $.ligerDialog.tip({
                                    title: '提示信息',
                                    content: data.message
                                });
                            }
                        });
                    },
                    cls: 'l-dialog-btn-highlight'
                }, {
                    text: '取消', onclick: function (item, dialog) {
                        dialog.close();
                    }
                }], isResize: true
            });
        }

        function relationUserData(item) {
            var row = g.getSelectedRow();
            if(row==null){
                $.ligerDialog.tip({
                    title: '提示信息',
                    content: "请选择一个角色"
                });
                return;
            }
            var roleid = row.id;

            $.ligerDialog.open({
                url: 'manager/user/setUser.jsp?roleid='+roleid, height: 320, width: 630, buttons: [
                    {
                        text: '确定', onclick: function (item, dialog) {
                        var ids = dialog.frame.f_getChecked();
                        var data = {
                            "ids": ids,
                            "roleid": roleid
                        }
                        $.ajax({
                            cache: true,
                            type: "POST",
                            url:"manager/sysRole.do?method=setUser",
                            data: data,
                            async: false,
                            error: function(data) {
                                $.ligerDialog.tip({
                                    title: '提示信息',
                                    content: data.message
                                });
                            },
                            success: function(data) {
                                dialog.close();
//                                g.reload();
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
                    }
                ], isResize: true
            });
        }

        //剔除用户
        function deleteUserData(funId){

        }

    </script>

</head>
<body style="overflow:hidden">


<div class="l-loading" style="display:block" id="pageloading"></div>
<a class="l-button" style="width:120px;float:left; margin-left:10px; display:none;" onclick="deleteRow()">删除选择的行</a>


<div class="l-clear"></div>

<div id="maingrid"></div>

<div style="display:none;">

</div>
</body>
</html>
