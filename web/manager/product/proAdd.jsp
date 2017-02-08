<%@ page import="com.youguu.core.util.ParamUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";

    int proId = ParamUtil.CheckParam(request.getParameter("proId"), 0);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <base href="<%=basePath%>">
    <title>商品类别属性维护页面</title>
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
                    {display: "属性ID", name: "id", newline: true, type: "text"},
                    {display: "属性名称", name: "name", newline: false, type: "text"},
                    {display: "类别ID", name: "classId", newline: true, type: "text"},
                    {
                        display: "类型",
                        name: "type",
                        newline: false,
                        type: "select",
                        comboboxName: "typeCombo",
                        options: {data: [
                            {id: '1', value: '1', text: '颜色' },
                            {id: '2', value: '0', text: '选择' },
                            {id: '3', value: '0', text: '用户输入' }
                        ]}
                    },
                    {
                        display: "是否必须",
                        name: "isNeed",
                        newline: true,
                        type: "select",
                        comboboxName: "needCombo",
                        options: {data: [
                            {id: '1', value: '1', text: '颜色' },
                            {id: '2', value: '0', text: '选择' },
                            {id: '3', value: '0', text: '用户输入' }
                        ]}
                    },
                    {
                        display: "是否搜索",
                        name: "isSearch",
                        newline: false,
                        type: "select",
                        comboboxName: "searchCombo",
                        options: {data: [
                            {id: '1', value: '1', text: '颜色' },
                            {id: '2', value: '0', text: '选择' },
                            {id: '3', value: '0', text: '用户输入' }
                        ]}
                    },
                    {display: "排序", name: "rank", newline: true, type: "text"}
                ]
            });


            $("#maingrid").ligerGrid({
                checkbox: true,
                columns: [
                    {display: '属性值ID', name: 'id', align: 'left', width: 60},
                    {display: '属性值名称', name: 'name', align: 'left', width: 100, minWidth: 60},
                    {display: '属性ID', name: 'classProId', minWidth: 60},
                    {display: '类别ID', name: 'classId', minWidth: 60},
                    {display: '图片地址', name: 'pic', minWidth: 100},
                    {display: '是否启用', name: 'used', minWidth: 100},
                    {display: '排序', name: 'rank', minWidth: 100},
                    {display: '创建时间', name: 'createTime', minWidth: 140},
                    {display: '修改时间', name: 'updateTime', minWidth: 140}
                ],
                dataAction: 'server',
                url: 'manager/productCategoryProValue.do?method=proValueList&proId=<%=proId %>',
                pageSize: 20,
                rownumbers: true,
                width: '100%',
                height: '100%'
            });
        });

        function loadData(id){
            $.ajax({
                cache: true,
                type: "POST",
                url:"manager/productCategory.do?method=getProductCategory",
                data: {"id": id},
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
<div>
    <div id="form2" style="float: left;"></div>
</div>

<div>
    <div id="maingrid"></div>
</div>
</body>
</html>
