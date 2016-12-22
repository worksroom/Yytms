<%@ page import="com.youguu.core.util.ParamUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    int id = ParamUtil.CheckParam(request.getParameter("id"), 0);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <base href="<%=basePath%>">
    <title>添加角色</title>
    <script src="resources/jquery/jquery-1.9.0.min.js" type="text/javascript"></script>
    <link href="resources/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css">
    <script src="resources/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="resources/ligerUI/js/ligerui.all.js" type="text/javascript"></script>

    <script type="text/javascript">
        var form;
        var dialog = frameElement.dialog;

        $(function () {
            //创建表单结构
            form = $("#form2").ligerForm({
                inputWidth: 170, labelWidth: 90, space: 40,
                fields: [
                    {
                        display: "角色ID",
                        name: "id",
                        newline: true,
                        type: "hidden"
                    },
                    {
                        display: "角色名称",
                        name: "roleName",
                        newline: true,
                        type: "text"
                    },
                    {
                        display: "角色状态 ",
                        name: "type",
                        newline: true,
                        type: "select",
                        comboboxName: "roleCombo",
                        options: {data: [
                            {id: '1', value: '1', text: '正常' },
                            {id: '0', value: '0', text: '冻结' }
                        ]}
                    }
                ]
            });

            loadData();
        });

        function loadData(){
            $.ajax({
                cache: true,
                type: "POST",
                url:"manager/sysRole.do?method=loadSysRole",
                data: {"id": <%=id %>},
                async: false,
                error: function(data) {
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
