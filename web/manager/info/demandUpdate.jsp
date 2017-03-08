<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.youguu.core.util.ParamUtil" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    int id = ParamUtil.CheckParam(request.getParameter("id"), 0);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <base href="<%=basePath%>">
    <title>修改用户需求-资讯</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>

    <link href="resources/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css">
    <link href="resources/ligerUI/skins/Gray/css/all.css" rel="stylesheet" type="text/css">
    <script src="resources/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="resources/ligerUI/js/ligerui.all.js" type="text/javascript"></script>


    <script type="text/javascript">
        var groupicon = "resources/ligerUI/skins/icons/communication.gif";
        var form;
        var dialog = frameElement.dialog;

        $(function () {
            form = $("#form2").ligerForm({
                inputWidth: 170, labelWidth: 90, space: 10,
                fields: [
                    {
                        display: "资讯ID",
                        name: "id",
                        newline: false,
                        type: "text"
                    },{
                        display: "权重",
                        name: "weight",
                        newline: false,
                        type: "text"
                    },{
                        display: "类别ID",
                        name: "classId",
                        newline: true,
                        type: "text"
                    },{
                        display: "类型",
                        name: "type",
                        newline: false,
                        type: "text"
                    },{
                        display: "标题",
                        name: "title",
                        newline: true,
                        type: "text",
                        width: 440
                    },{
                        display: "描述",
                        name: "des",
                        newline: true,
                        type: "textarea",
                        width: 440
                    },{
                        display: "内容",
                        name: "content",
                        newline: true,
                        type: "textarea",
                        width: 440
                    }
                ]
            });

            loadData()
        });

        /**
         * 加载Form
         */
        function loadData(){
            $.ajax({
                cache: true,
                type: "POST",
                url:"manager/info.do?method=getInfo",
                data: {"id": <%=id %>},
                async: false,
                error: function(data) {
                    $.ligerDialog.tip({
                        title: '提示信息',
                        content: '获取信息失败'
                    });
                },
                success: function(data) {
                    //设置Form数据
                    form.setData(data);
                }
            });
        }

        function submitform() {
            return form.getData();
        }

    </script>

</head>
<body style="padding:0px;height: 90%">

<form id="form1" onsubmit="return false">
    <div id="form2" style="float: left;"></div>
</form>

</body>
</html>
