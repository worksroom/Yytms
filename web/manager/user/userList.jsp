<%@ page import="com.youguu.core.util.ParamUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    String menuId = ParamUtil.CheckParam(request.getParameter("menuId"), "");
    System.out.println("menuId="+menuId);
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
    <title>用户管理</title>

    <link href="resources/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css">
    <link href="resources/ligerUI/skins/Gray/css/all.css" rel="stylesheet" type="text/css">
    <link href="resources/ligerUI/skins/ligerui-icons.css" rel="stylesheet" type="text/css">
    <link href="resources/css/jquery-ui.min.css" rel="stylesheet" type="text/css">
    <link href="resources/css/ne.css" rel="stylesheet" type="text/css">
    <script src="resources/jquery/jquery-1.9.0.min.js" type="text/javascript"></script>
    <script src="resources/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="resources/ligerUI/js/ligerui.all.js" type="text/javascript"></script>
    <script type="text/javascript">

        $(function () {
            window['g'] = $("#maingrid").ligerGrid({
                checkbox: true,
                columns: [
                    {display: '姓名', name: 'userName', align: 'left', width: 120, minWidth: 60},
                    {display: '登录账户', name: 'userLoginName', minWidth: 120},
                    {display: '电话', name: 'userTel', minWidth: 140},
                    {display: 'QQ', name: 'userQq'},
                    {display: '冻结状态', name: 'userFreezeFlag'},
                    {
                        display : '操作',
                        name : 'id',
                        width : 100,
                        align:"center",
                        render:function(obj){
                            var result = "<div class='operating'><a class='ui-icon ui-icon-pencil' title='修改' href='javascript:updateData("+obj.userLoginName+")'></a><a class='ui-icon ui-icon-trash' title='删除' href='javascript:deleteData(\""+obj.userLoginName+"\",2)'></a></div>";
                            return result;
                        }
                    }
                ],
                dataAction: 'server',
                url: 'manager/sysUser.do?method=userList',
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
                url: 'manager/user/userAdd.jsp', height: 450, width: 750, buttons: [{
                    text: '确定', onclick: function (item, dialog) {
                        var formData = dialog.frame.submitform();
                        $.ajax({
                            cache: true,
                            type: "POST",
                            url:"manager/sysUser.do?method=addSysUser",
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
                }], isResize: true
            });
        }

        function updateData(id) {
            var row = g.getSelectedRow();
            $.ligerDialog.open({
                url: 'manager/user/userUpdate.jsp?userLoginName='+row.userLoginName, height: 450, width: 750, buttons: [{
                        text: '确定', onclick: function (item, dialog) {

                        var formData = dialog.frame.submitform();
                        $.ajax({
                            cache: true,
                            type: "POST",
                            url:"manager/sysUser.do?method=updateSysUser",
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
                    },{
                        text: '取消', onclick: function (item, dialog) {
                        dialog.close();
                    }
                    }
                ], isResize: true
            });
        }

        /**
        *
        * @param rowid
        * @param position 1-工具栏点删除；2-行上点删除
         */
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
                        selectIdArr.push(rows[rowid]["userLoginName"]);
                    }
                    returnValue  = (selectIdArr.join(","));
                }
            }

            $.ligerDialog.confirm('确定要删除吗', function (yes) {
                if(yes==true){
                    $.ajax({
                        cache: true,
                        type: "POST",
                        url:"manager/sysUser.do?method=deleteSysUser&ids="+returnValue,
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

        function freezeData(){
            var returnValue = "";
            var rows = g.getSelecteds();

            if(rows.length>0){
                var selectIdArr = [];
                if (rows.length == 0) {
                    returnValue = "";
                } else {
                    for (var rowid in rows) {
                        selectIdArr.push(rows[rowid]["userLoginName"]);
                    }
                    returnValue  = (selectIdArr.join(","));
                }
            }

            $.ajax({
                cache: true,
                type: "POST",
                url:"manager/sysUser.do?method=freezeSysUser&ids="+returnValue,
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

        function unfreezeData(){
            var returnValue = "";
            var rows = g.getSelecteds();

            if(rows.length>0){
                var selectIdArr = [];
                if (rows.length == 0) {
                    returnValue = "";
                } else {
                    for (var rowid in rows) {
                        selectIdArr.push(rows[rowid]["userLoginName"]);
                    }
                    returnValue  = (selectIdArr.join(","));
                }
            }

            $.ajax({
                cache: true,
                type: "POST",
                url:"manager/sysUser.do?method=unfreezeSysUser&ids="+returnValue,
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

        /**
        * 重置密码
        * @param rowid
        * @param position
         */
        function resetData(rowid,position) {
            var returnValue = "";
            var rows = g.getSelecteds();

            if(rows.length>0){
                var selectIdArr = [];
                if (rows.length == 0) {
                    returnValue = "";
                } else {
                    for (var rowid in rows) {
                        selectIdArr.push(rows[rowid]["userLoginName"]);
                    }
                    returnValue  = (selectIdArr.join(","));
                }
            }

            $.ligerDialog.confirm('确定要重置密码吗', function (yes) {
                if(yes==true){
                    $.ajax({
                        cache: true,
                        type: "POST",
                        url:"manager/sysUser.do?method=resetPwd&ids="+returnValue,
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
    </script>

</head>
<body style="overflow:hidden">

<div class="l-loading" style="display:block" id="pageloading"></div>

<div class="l-clear"></div>
<div id="maingrid"></div>

<div style="display:none;">

</div>
</body>
</html>
