<%@ page import="com.youguu.core.util.ParamUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    int id = ParamUtil.CheckParam(request.getParameter("id"), 0);
    String name = java.net.URLDecoder.decode(request.getParameter("name"), "UTF-8");
    int status = ParamUtil.CheckParam(request.getParameter("status"), 0);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <base href="<%=basePath%>">
    <title>店铺审核</title>
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
                        display: "碎片ID",
                        name: "id",
                        newline: true,
                        type: "text"
                    },
                    {
                        display: "碎片名称",
                        name: "name",
                        newline: true,
                        type: "text"
                    },
                    {
                        display: "状态 ",
                        name: "status",
                        newline: true,
                        type: "select",
                        comboboxName: "shopCombo",
                        options: {data: [
                            {id: '1', value: '1', text: '有效' },
                            {id: '99', value: '99', text: '无效' }
                        ]}
                    }
                ]
            });

            loadData();
        });

        function loadData(){
            var data = {"id": <%=id %>, "name": "<%=name %>", "status": <%=status %>};
            form.setData(data);
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
