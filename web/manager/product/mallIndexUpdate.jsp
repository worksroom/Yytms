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
    <title>添加碎片</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <link rel="stylesheet" href="resources/cropper/cropper.min.css" type="text/css">
    <link rel="stylesheet" href="resources/cropper/main.css" type="text/css"/>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" type="text/css">

    <script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
    <script type="text/javascript" src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="resources/cropper/cropper.min.js"></script>
    <script type="text/javascript" src="resources/cropper/main.js"></script>

    <link href="resources/cropper/sitelogo.css" rel="stylesheet">


    <link href="resources/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css">
    <link href="resources/ligerUI/skins/Gray/css/all.css" rel="stylesheet" type="text/css">
    <script src="resources/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="resources/ligerUI/js/ligerui.all.js" type="text/javascript"></script>


    <script type="text/javascript">
        var groupicon = "resources/ligerUI/skins/icons/communication.gif";
        var form;
        var tree;
        var grid;
        var dialog = frameElement.dialog;

        $(function () {
            //创建表单结构
            form = $("#form2").ligerForm({
                inputWidth: 170, labelWidth: 90, space: 10,
                fields: [
                    {display: "碎片ID", name: "id", newline: true, type: "hidden"},
                    {display: "碎片名称", name: "name", newline: true, type: "text"},
                    {display: "排序", name: "rank", newline: false, type: "text"},
                    {
                        display: "类型",
                        name: "type",
                        newline: true,
                        type: "select",
                        comboboxName: "typeComboBox",
                        options: {data: [
                            {id: '0', value: '0', text: '单图banner' },
                            {id: '1', value: '1', text: '文字'},
                            {id: '2', value: '2', text: '两图区(宣传图)'},
                            {id: '3', value: '3', text: '两图区(优惠价格)'},
                            {id: '4', value: '4', text: '三图区(宣传图)'},
                            {id: '5', value: '5', text: '三图区(商品直达)'}
                        ]}
                    },
                    {
                        display: "碎片状态",
                        name: "status",
                        newline: false,
                        type: "select",
                        comboboxName: "statusComboBox",
                        options: {data: [
                            {id: '99', value: '99', text: '不可用'},
                            {id: '1', value: '1', text: '可用'}
                        ]}
                    }
                ]
            });

            grid = $("#maingrid").ligerGrid({
                checkbox: false,
                columns: [
                    {display: '名称', name: 'name', align: 'left',editor: { type: 'text' }},
                    {display: '图片地址', name: 'img', minWidth: 100, render: function (rowdata, rowindex, value){
                        return "<img id='img_"+rowindex+"' onclick='uploadimg("+rowindex+")' src='"+rowdata.img+"' alt='Logo' style='width:80px;height:70px;'>";
                    }},
                    {display: '跳转链接', name: 'url', minWidth: 60,editor: { type: 'text' }},
                    {display: '原价', name: 'price', minWidth: 100,editor: { type: 'text' }},
                    {display: '折扣价', name: 'salePrice', minWidth: 100,editor: { type: 'text' }},
                    {display: '折扣', name: 'discount', minWidth: 100,editor: { type: 'text' }},
                    {
                        display: '操作', isSort: false, width: 120, render: function (rowdata, rowindex, value){
                            var h = "";
                            if (!rowdata._editing) {
                                h += "<a href='javascript:beginEdit(" + rowindex + ")'>修改</a> ";
                                h += "<a href='javascript:deleteRow(" + rowindex + ")'>删除</a> ";
                            } else {
                                h += "<a href='javascript:endEdit(" + rowindex + ")'>提交</a> ";
                                h += "<a href='javascript:cancelEdit(" + rowindex + ")'>取消</a> ";
                            }
                            return h;
                        }
                    }
                ],
                usePager: false,
                rownumbers: true,
                width: '100%',
                height: '100%',
                rowHeight: 70,
                enabledEdit: true, clickToEdit: false, isScroll: false,
                toolbar: {
                    items: [
                        { text: '增加行', click: addNewRow, icon: 'add' }
                    ]
                }

            });

            loadData()
        });

        /**
         * 加载Form和Grid数据
         */
        function loadData(){
            $.ajax({
                cache: true,
                type: "POST",
                url:"manager/index.do?method=loadMallIndex",
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

                    //设置Grid数据
                    var indexData = {Rows:JSON.parse(data.content)};
                    grid.loadData(indexData);
                }
            });
        }


        /**
         * 编辑属性行
         */
        function beginEdit(rowid) {
            grid.beginEdit(rowid);
        }

        /**
         * 取消编辑属性行
         */
        function cancelEdit(rowid) {
            grid.cancelEdit(rowid);
        }

        /**
         * 提交
         */
        function endEdit(rowid) {
            grid.endEdit(rowid);
        }

        /**
         * 删除属性
         */
        function deleteRow(rowindex) {
            if (confirm('确定删除?')) {
                grid.deleteRow(rowindex);
            }
        }

        /**
         * 添加属性
         */
        function addNewRow(){
            grid.addEditRow();
        }

        function submitform() {
            return form.getData();
        }

        function submitGrid(){
            var data = grid.getData();
            alert(JSON.stringify(data));
            return grid.getData();
        }

        function uploadimg(id) {
            top.$.ligerDialog.open({
                zindex: 9004,
                width: 800, height: 500,
                title: '上传图片',
                url: 'manager/product/uploadImg.jsp?id='+id,
                buttons: [
                    {
                        text: '保存', onclick: function (item, dialog) {
                        saveheadimg(item, dialog);
                    }
                    },
                    {
                        text: '关闭', onclick: function (item, dialog) {
                        dialog.close();
                    }
                    }
                ],
                isResize: true
            });
        }

        function getUrlVar(key, url) {
            var key = key + "=";
            var url = (url ? url.substring(url.indexOf("?"), url.indexOf("#") < 0 ? url.length: url.indexOf("#")) : location.search).substring(1);
            var qa = url.split("&");
            for (var i = 0; i < qa.length; i++) {
                var q = qa[i];
                if (q.indexOf(key) == 0) return q.substring(key.length);
            }
            return "";
        }

        function saveheadimg(item, dialog) {
            var formData = dialog.frame.submitForm();

            if (formData) {
                dialog.close();
                top.$.ligerDialog.waitting('数据保存中,请稍候...');

                $.ajax({
                    url: "manager/productCategoryProValue.do?method=cutImg", type: "POST",
                    data: formData,
                    success: function (responseText) {
                        if(responseText.success==true){
                            $("#img_"+getUrlVar("id", formData)+"").attr("src", responseText.url);
                            grid.updateCell(2, responseText.url, getUrlVar("id", formData));
                        }

                        top.$.ligerDialog.closeWaitting();
                    },
                    error: function () {
                        top.$.ligerDialog.closeWaitting();
                        top.$.ligerDialog.error('操作失败！');
                    }
                });
            }
        }
    </script>

</head>
<body style="padding:0px;height: 90%">

<form id="form1" onsubmit="return false">
    <div id="form2" style="float: left;"></div>
    <div id="maingrid" style="float: left;margin: 5px;" ></div>
</form>

</body>
</html>
