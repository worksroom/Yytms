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
    <title>商城首页碎片管理</title>

    <link href="resources/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css">
    <link href="resources/ligerUI/skins/ligerui-icons.css" rel="stylesheet" type="text/css">
    <link href="resources/css/jquery-ui.min.css" rel="stylesheet" type="text/css">
    <link href="resources/css/ne.css" rel="stylesheet" type="text/css">
    <link href="resources/css/input.css" rel="stylesheet" type="text/css">
    <link href="resources/ligerUI/skins/Gray/css/all.css" rel="stylesheet" type="text/css">
    <script src="resources/jquery/jquery-1.9.0.min.js" type="text/javascript"></script>
    <script src="resources/css/jquery-ui.min.js" type="text/javascript"></script>
    <script src="resources/jquery/jquery.form.js" type="text/javascript"></script>
    <script src="resources/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="resources/ligerUI/js/ligerui.all.js" type="text/javascript"></script>
    <script src="resources/js/json2.js" type="text/javascript"></script>
    <script type="text/javascript">
        var grid;
        $(function () {
            grid = $("#maingrid").ligerGrid({
                checkbox: true,
                columns: [
                    {display: '碎片ID', name: 'id', align: 'left', width: 60},
                    {display: '排序字段', name: 'rank', align: 'left', width: 100, minWidth: 60},
                    {display: '碎片类型', name: 'type', minWidth: 60},
                    {display: '碎片状态', name: 'status', minWidth: 60, render: function (item) {
                        var statusTxt = "其他"
                        if(item.status==99){
                            statusTxt = "无效"
                        } else if(item.status==1){
                            statusTxt = "有效"
                        } else {
                            statusTxt = "其他"
                        }
                        return statusTxt;
                    }},
                    {display: '碎片名称', name: 'name', minWidth: 100},
                    {display: '碎片内容', name: 'content', minWidth: 100},
                    {display: '创建时间', name: 'createTime', minWidth: 140},
                    {display: '修改时间', name: 'updateTime', minWidth: 140}
                ],
                dataAction: 'server',
                url: 'manager/index.do?method=mallIndexList',
                pageSize: 20,
                rownumbers: true,
                width: '100%',
                height: '100%',
                toolbar: <jsp:include page="../layout/function.jsp" flush="true"/>
            });


            $("#pageloading").hide();

        });

        function addData(){
            $.ligerDialog.open({
                url: 'manager/product/mallIndexAdd.jsp', height: 500, width: 900, buttons: [
                    {
                        text: '提交保存', onclick: function (item, dialog) {
                        var formData = dialog.frame.submitform();

                        var gridData = dialog.frame.submitGrid();

                        $.ajax({
                            cache: true,
                            type: "POST",
                            url:"manager/index.do?method=addMallIndex",
                            data: {
                                "formData" : JSON.stringify(formData),
                                "gridData" : JSON.stringify(gridData)
                            },
                            async: false,
                            error: function(data) {
                                $.ligerDialog.tip({
                                    title: '提示信息',
                                    content: data.message
                                });
                            },
                            success: function(data) {
                                dialog.close();
                                grid.reload();
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

        function updateData(){
            var row = grid.getSelectedRow();
            $.ligerDialog.open({
                url: 'manager/product/mallIndexUpdate.jsp?id='+row.id, height: 500, width: 800, buttons: [
                    {
                        text: '确定', onclick: function (item, dialog) {
                        var formData = dialog.frame.submitform();

                        var gridData = dialog.frame.submitGrid();
                        $.ajax({
                            cache: true,
                            type: "POST",
                            url:"manager/index.do?method=updateMallIndex",
                            data: {
                                "formData" : JSON.stringify(formData),
                                "gridData" : JSON.stringify(gridData)
                            },
                            async: false,
                            error: function(data) {
                                $.ligerDialog.tip({
                                    title: '提示信息',
                                    content: data.message
                                });
                            },
                            success: function(data) {
                                dialog.close();
                                grid.reload();
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

        function updateStatusData(){
            var row = grid.getSelectedRow();
            $.ligerDialog.open({
                url: 'manager/product/mallIndexReview.jsp?id='+row.id+'&name='+encodeURI(encodeURI(row.name))+'&status='+row.status,
                height: 190,
                width: 320,
                buttons: [
                    {text: '确定', onclick: function (item, dialog) {
                        var formData = dialog.frame.submitform();
                        $.ajax({
                            cache: true,
                            type: "POST",
                            url:"manager/index.do?method=updateMallIndexStatus",
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
                                grid.reload();
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
                ],
                isResize: true
            });
        }

        function doserch(){
            var serchtxt = $("#serchform :input").fieldSerialize();
            $.ligerDialog.waitting('数据查询中,请稍候...');
            var manager = $("#maingrid").ligerGetGridManager();

            manager._setUrl("manager/index.do?method=mallIndexList&" + serchtxt);
            manager.loadData(true);
            $.ligerDialog.closeWaitting();

        }

        function doclear() {
            $("input:hidden", "#serchform").val("");
            $("input:text", "#serchform").val("");
            $(".l-selected").removeClass("l-selected");
        }


    </script>

</head>
<body style="overflow:hidden">


<div class="l-loading" style="display:block" id="pageloading"></div>
<a class="l-button" style="width:120px;float:left; margin-left:10px; display:none;" onclick="deleteRow()">删除选择的行</a>


<div class="l-clear"></div>

<div class="az">
    <form id='serchform'>
        <table style='width: 350px' class="bodytable1">
            <tr>
                <td>
                    <div style='width: 60px; text-align: right; float: right'>碎片状态：</div>
                </td>
                <td>
                    <input type='text' id='status' name='status' style="width:80px"/>
                </td>
                <td>
                    <input id='Button2' type='button' value='重置' style='width: 80px; height: 24px' onclick="doclear()" />
                    <input id='Button1' type='button' value='搜索' style='width: 80px; height: 24px' onclick="doserch()" />
                </td>

            </tr>
        </table>
    </form>
</div>

<div id="maingrid"></div>

<div style="display:none;"></div>




</body>
</html>
