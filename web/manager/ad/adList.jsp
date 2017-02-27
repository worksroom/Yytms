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
    <title>广告管理</title>

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
        var grid;
        $(function () {
            grid = $("#maingrid").ligerGrid({
                checkbox: true,
                columns: [
                    {display: '广告ID', name: 'id', align: 'left', width: 50},
                    {display: '广告类别ID', name: 'adType', align: 'left', width: 100, hide: true},
                    {display: '广告类别', name: 'adCategoryName', align: 'left', width: 100},
                    {display: '图片地址', name: 'img', align: 'left', width: 300},
                    {display: '广告描述', name: 'des', align: 'left', width: 200},
                    {display: '跳转地址', name: 'url', align: 'left', width: 300},
                    {display: '是否可用', name: 'used', align: 'left', width: 50, render: function (item) {
                        var statusTxt = "其他"
                        if(item.used==0){
                            statusTxt = "否"
                        } else if(item.used==1){
                            statusTxt = "是"
                        } else {
                            statusTxt = "其他"
                        }
                        return statusTxt;
                    }},
                    {display: '创建时间', name: 'createTime', minWidth: 140}
                ],
                dataAction: 'server',
                url: 'manager/ad.do?method=adList',
                usePager: false,
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
                url: 'manager/ad/adAdd.jsp', height: 400, width: 600, buttons: [
                    {
                        text: '提交保存', onclick: function (item, dialog) {
                        var formData = dialog.frame.submitform();

                        $.ajax({
                            cache: true,
                            type: "POST",
                            url:"manager/ad.do?method=saveAd",
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
                ], isResize: true
            });
        }

        function updateData(){
            var row = grid.getSelectedRow();
            $.ligerDialog.open({
                url: 'manager/ad/adUpdate.jsp?id='+row.id, height: 400, width: 600, buttons: [
                    {
                        text: '提交保存', onclick: function (item, dialog) {
                        var formData = dialog.frame.submitform();

                        $.ajax({
                            cache: true,
                            type: "POST",
                            url:"manager/ad.do?method=updateAd",
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
                ], isResize: true
            });
        }

        function deleteData(){
            var rows = grid.getSelecteds();

            var selectIds = new Array();
            $(rows).each(function () {
                selectIds.push(this.id);
            });

            $.ligerDialog.confirm('确定要删除吗', function (yes) {
                if(yes==true){
                    $.ajax({
                        cache: true,
                        type: "POST",
                        url:"manager/ad.do?method=deleteAd&ids="+selectIds,
                        async: false,
                        error: function(data) {
                            $.ligerDialog.tip({
                                title: '提示信息',
                                content: data.message
                            });
                        },
                        success: function(data) {
                            grid.reload();
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
<a class="l-button" style="width:120px;float:left; margin-left:10px; display:none;" onclick="deleteRow()">删除选择的行</a>


<div class="l-clear"></div>

<div id="maingrid"></div>

<div style="display:none;">

</div>
</body>
</html>
