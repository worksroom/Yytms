<%@ page import="com.youguu.core.util.ParamUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";

    String id = ParamUtil.CheckParam(request.getParameter("id"), "");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <base href="<%=basePath%>">
    <title>树控件 - 支持拖拽</title>
    <script src="resources/jquery/jquery-1.9.0.min.js" type="text/javascript"></script>
    <link href="resources/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css">
    <script src="resources/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="resources/ligerUI/js/ligerui.all.js" type="text/javascript"></script>

    <script type="text/javascript">
        var form;
        $(function () {
            //创建表单结构
            form = $("#form2").ligerForm({
                inputWidth: 170, labelWidth: 90, space: 40,
                fields: [
                    {
                        display: "父节点ID",
                        name: "parentId",
                        newline: true,
                        type: "text"
                    },
                    {
                        display: "节点ID",
                        name: "id",
                        newline: false,
                        type: "text"
                    },
                    {
                        display: "节点名称",
                        name: "name",
                        newline: true,
                        type: "text"
                    },
                    {
                        display: "节点类别 ",
                        name: "type",
                        newline: false,
                        type: "select",
                        comboboxName: "CategoryName",
                        options: {data: [
                            { id: '99990001', value: '99990001', text: '菜单' },
                            { id: '99990002', value: '99990002', text: '动作' }
                        ]}
                    },
                    {display: "跳转地址 ", name: "url", newline: true, type: "text", width: 470},
                    {display: "扩展2", name: "exp2", newline: true, type: "text"}
                ]
            });

            form.setEnabled("id", false);
            loadData();
        });

        function loadData(){
            $.ajax({
                cache: true,
                type: "POST",
                url:"manager/sysMenu.do?method=loadSysModule",
                data: {"id": "<%=id %>"},
                async: false,
                error: function(data) {
                    alert(data);
                    $.ligerDialog.tip({
                        title: '提示信息',
                        content: '获取信息失败'
                    });
                },
                success: function(data) {
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
<div id="form2"></div>
</body>
</html>
