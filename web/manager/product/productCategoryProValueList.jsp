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
    <title>商品类别属性-值维护页面</title>
    <script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
    <link href="resources/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css">
    <link href="resources/ligerUI/skins/Gray/css/all.css" rel="stylesheet" type="text/css">
    <script src="resources/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="resources/ligerUI/js/ligerui.all.js" type="text/javascript"></script>

    <script type="text/javascript">
        var dialog = frameElement.dialog;
        var grid;
        $(function () {
            grid = $("#maingrid").ligerGrid({
                checkbox: true,
                columns: [
                    {display: '属性值ID', name: 'id', align: 'left', width: 60},
                    {display: '属性值名称', name: 'name', align: 'left', width: 100, minWidth: 60,editor: { type: 'text' }},
                    {display: '属性ID', name: 'classProId', minWidth: 60},
                    {display: '类别ID', name: 'classId', minWidth: 60},
                    {display: '图片地址', name: 'pic', minWidth: 100, render: function (rowdata, rowindex, value){
                        return "<img id='img_"+rowdata.id+"' onclick='uploadimg("+rowdata.id+")' src='"+rowdata.pic+"' alt='Logo' style='width:80px;height:70px;'>";
                    }},
                    {display: '是否启用', name: 'used', minWidth: 100,editor: { type: 'text' }},
                    {display: '排序', name: 'rank', minWidth: 100,editor: { type: 'text' }},
                    {
                        display: '操作', isSort: false, width: 120, render: function (rowdata, rowindex, value){
                            var h = "";
                            if (!rowdata._editing) {
                                h += "<a href='javascript:beginEdit(" + rowindex + ")'>修改</a> ";
                                h += "<a href='javascript:deleteRow(" + rowdata.id + "," + rowindex + ")'>删除</a> ";
                            } else {
                                h += "<a href='javascript:endEdit(" + rowindex + ")'>提交</a> ";
                                h += "<a href='javascript:cancelEdit(" + rowindex + ")'>取消</a> ";
                            }
                            return h;
                        }
                    },
                    {display: '创建时间', name: 'createTime', minWidth: 140},
                    {display: '修改时间', name: 'updateTime', minWidth: 140}
                ],
                dataAction: 'server',
                url: 'manager/productCategoryProValue.do?method=proValueList&proId=<%=proId %>',
                pageSize: 20,
                usePager: false,
                rownumbers: true,
                width: '100%',
                height: '100%',
                rowHeight: 70,
                enabledEdit: true, clickToEdit: false, isScroll: false,
                toolbar: {
                    items: [
                        { text: '新增属性值', click: addNewRow, icon: 'add' },
                        { text: '保存数据', click: saveData, icon: 'save' },
                        { text: '删除数据', click: deleteData, icon: 'delete' }
                    ]
                }
            });

        });


        function beginEdit(rowid) {
            grid.beginEdit(rowid);
        }
        function cancelEdit(rowid) {
            grid.cancelEdit(rowid);
        }
        function endEdit(rowid) {
            grid.endEdit(rowid);
        }

        function deleteRow(rowid, rowindex) {
            if (confirm('确定删除?')) {
                grid.deleteRow(rowindex);
            }

            $.ligerDialog.confirm('确定要删除吗', function (yes) {
                if(yes==true){
                    $.ajax({
                        cache: true,
                        type: "POST",
                        url:"manager/productCategoryProValue.do?method=delProValue&ids="+rowid,
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
        function addNewRow(){
            var rowdata = {classProId: 1, classId: 1};
            grid.addEditRow(rowdata);
        }

        function saveData(){
            var data = grid.getData();
            $.ajax({
                cache: true,
                type: "POST",
                url:"manager/productCategoryProValue.do?method=saveOrUpdateProValue",
                data: "girdJson="+JSON.stringify(data),
                async: false,
                error: function(request) {
                },
                success: function(data) {
                    $.ligerDialog.tip({
                        title: '提示信息',
                        content: data.message
                    });

                    $.ligerDialog.waitting('数据查询中,请稍候...');
                    grid._setUrl("manager/productCategoryProValue.do?method=proValueList&proId=<%=proId %>");
                    grid.loadData(true);
                    $.ligerDialog.closeWaitting();
                }
            });
        }

        function deleteData(){
            var selectIdArr = [];
            var returnValue;
            var rows = grid.getSelecteds();

            var selectIdArr = [];
            if (rows.length == 0) {
                returnValue = "";
            } else {
                for (var rowid in rows) {
                    selectIdArr.push(rows[rowid]["id"]);
                }
                returnValue  = (selectIdArr.join(","));
            }

            $.ligerDialog.confirm('确定要删除吗', function (yes) {
                if(yes==true){
                    $.ajax({
                        cache: true,
                        type: "POST",
                        url:"manager/productCategoryProValue.do?method=delProValue&ids="+returnValue,
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


        function uploadimg(id) {
            top.$.ligerDialog.open({
                zindex: 9004,
                width: 800, height: 500,
                title: '上传头像',
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
//                            $("#pic").attr("value", responseText.url);
                            alert("id="+getUrlVar("id", formData));
                            var row = grid.getRow({"id": getUrlVar("id", formData)});
                            alert("row="+JSON.stringify(row));
//                            var rowdata = {pic: responseText.url};
                            $("#img_"+getUrlVar("id", formData)+"").attr("src", responseText.url);

//                            var rowdata = grid.getRow(getUrlVar("id", formData));


//                            var cellobj = grid.getCellObj(rowdata, 5);
//                            alert(cellobj);
//                            alert($(cellobj).val());
//                            var container = $(cellobj).html("");

//                            rowdata.pic=responseText.url;
//                            alert(JSON.stringify(rowdata));
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
<div>
    <div id="maingrid"></div>
</div>

</body>
</html>
