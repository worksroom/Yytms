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
    <title>资讯-厂家供应</title>

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
                    {display: '资讯ID', name: 'id', align: 'left', width: 100},
                    {display: '用户ID', name: 'userId', align: 'left', width: 100},
                    {display: '标题', name: 'title', align: 'left', width: 100, render: function (item) {
                        var html = "<a href='javascript:void(0)' onclick='showDetail(" + item.content +")'>";
                        html += item.title;
                        html += "</a>";
                        return html;
                    }},
                    {display: '类型', name: 'type', align: 'left', width: 100},
                    {display: '权重', name: 'weight', align: 'left', width: 100},
                    {display: '简介', name: 'des', align: 'left', width: 100},
                    {display: '图片', name: 'photo', align: 'left', width: 100},
                    {display: '资讯内容', name: 'content', align: 'left', width: 100},
                    {display: '创建时间', name: 'updateTime', width: 140},
                    {display: '创建时间', name: 'createTime', width: 140}
                ],
                dataAction: 'server',
                url: 'manager/info.do?method=supplyList',
                pageSize: 20,
                rownumbers: true,
                width: '100%',
                height: '100%',
                toolbar: <jsp:include page="../layout/function.jsp" flush="true"/>
            });


            $("#pageloading").hide();
        });

        function showDetail(infoContent){
            $("#venderName").html(infoContent.venderName);
            $("#mainBusiness").html(infoContent.mainBusiness);
            $("#superiority").html(infoContent.superiority);
            $("#area").html(infoContent.area);
            $("#address").html(infoContent.address);

            $.ligerDialog.open({
                title: '资讯内容',
                target: $("#target1")
            });
        }

        function updateData(){
            var row = grid.getSelectedRow();
            $.ligerDialog.open({
                url: 'manager/ad/adCategoryUpdate.jsp?id='+row.id, height: 200, width: 300, buttons: [
                    {
                        text: '提交保存', onclick: function (item, dialog) {
                        var formData = dialog.frame.submitform();

                        $.ajax({
                            cache: true,
                            type: "POST",
                            url:"manager/adCategory.do?method=updateAdCategory",
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
                        url:"manager/adCategory.do?method=deleteAdCategory&ids="+selectIds,
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
<div id="target1" style="width:200px; margin:3px; display:none;">
    <div>
        <table>
            <tr>
                <td>供应商名称:</td>
                <td><span id="venderName"></span></td>
            </tr>
            <tr>
                <td>供应商主营业务:</td>
                <td><span id="mainBusiness"></span></td>
            </tr>
            <tr>
                <td>特殊优势:</td>
                <td><span id="superiority"></span></td>
            </tr>
            <tr>
                <td>供应商区域:</td>
                <td><span id="area"></span></td>
            </tr>
            <tr>
                <td>供应商地址:</td>
                <td><span id="address"></span></td>
            </tr>
        </table>
    </div>
</div>

</body>
</html>