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
    <title>买家管理</title>

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
                            {display: '用户ID', name: 'userId', align: 'left', width: 50, hide: true},
                            {display: '真实姓名', name: 'name', align: 'left', width: 100, minWidth: 60},
                            {display: '身份证号', name: 'cardNumber', minWidth: 150},
                            {
                                display: '审核状态', name: 'status', minWidth: 60, render: function (item) {
                                var statusTxt = "其他"
                                if(item.status==0){
                                    statusTxt = "待审"
                                } else if(item.status==1){
                                    statusTxt = "通过"
                                } else if(item.status==-1){
                                    statusTxt = "打回"
                                } else {
                                    statusTxt = "其他"
                                }
                                return statusTxt;
                            }
                            },
                            {display: '审核信息', name: 'msg', minWidth: 100},
                            {display: '创建时间', name: 'createTime', minWidth: 140},
                            {display: '修改时间', name: 'updateTime', minWidth: 140}
                        ],
                        dataAction: 'server',
                        url: 'manager/buyer.do?method=buyerList',
                        pageSize: 20,
                        rownumbers: true,
                        width: '100%',
                        height: '100%',
                        toolbar: <jsp:include page="../layout/function.jsp" flush="true"/>
                    });


            $("#pageloading").hide();
        });

        function reviewData(id) {
            var row = g.getSelectedRow();
            $.ligerDialog.open({
                url: 'manager/customer/buyerReview.jsp?id='+row.userId, height: 500, width: 700, buttons: [
                    {
                        text: '确定', onclick: function (item, dialog) {
                        var formData = dialog.frame.submitform();
                        $.ajax({
                            cache: true,
                            type: "POST",
                            url:"manager/buyer.do?method=review",
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
