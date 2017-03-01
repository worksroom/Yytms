<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <base href="<%=basePath%>">
    <title>支持上传头像Form</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>

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
            var toolbarData = <jsp:include page="../layout/function.jsp" flush="true"/>;

            $("#toolbar").ligerToolBar({
                items: toolbarData.items

            });

            $("#layout1").ligerLayout({
                leftWidth: 200,
                allowLeftResize: false,
                allowLeftCollapse: true,
                space: 2,
                heightDiff: -1
            });




            //创建表单结构
            form = $("#form2").ligerForm({
                inputWidth: 170, labelWidth: 90, space: 10,
                fields: [
                    {display: "类别ID", name: "id", newline: true, type: "hidden"},
                    {display: "类别名称", name: "name", newline: true, type: "text"},
                    {display: "Logo", name: "logo", newline: false, type: "text"},
                    {display: "类别描述", name: "des", newline: true, type: "text"},
                    {display: "排序", name: "rank", newline: false, type: "text"},
                    {display: "父节点", name: "parentId", newline: true, type: "hidden"},
                    {display: "父节点", name: "parentName", newline: true, type: "text"},
                    {display: "isEnd", name: "isEnd", newline: false, type: "text"}
                ],
                buttons: [
                    {text: '保存', width: 60, click: save}
                ]
            });

            tree = $("#treeCategory").ligerTree({
                url: 'manager/productCategory.do?method=loadCategoryTree',
                idFieldName: 'id',
                //parentIDFieldName: 'pid',
                usericon: 'd_icon',
                checkbox: false,
                isExpand: true,
                itemopen: false,
                onSelect: onSelectNode,
                onError: function () {
                },
                onSuccess: treeLoadFinish
            });

            var selectData = [{ id: 1, text: '是' }, { id: 0, text: '否'}];

            grid = $("#maingrid").ligerGrid({
                checkbox: true,
                columns: [
                    {display: '属性ID', name: 'id', align: 'left', width: 60, render: function (item) {
                        var html = "<a href='javascript:void(0)' onclick=addProData(" + item.id + ")>";
                            if (item.id)
                                html += item.id;
                            html += "</a>";
                            return html;
                        }
                    },
                    {display: '属性名称', name: 'name', align: 'left',editor: { type: 'text' }},
                    {display: '类别ID', name: 'classId', minWidth: 60,editor: { type: 'text' }},
                    {display: '类型', name: 'type', minWidth: 60,editor: { type: 'text' }},
                    {
                        display: '必填', name: 'isNeed', minWidth: 100,
                        render: function (item) {
                            if (parseInt(item.isNeed) == 1) return '是';
                            return '否';
                        },
                        editor: {
                            type: 'select',
                            data: selectData
                        }
                    },
                    {
                        display: '多选', name: 'isMultiple', minWidth: 100, render: function (item) {
                            if (parseInt(item.isMultiple) == 1) return '是';
                            return '否';
                        },
                        editor: {
                            type: 'select',
                            data: selectData
                        }
                    },
                    {
                        display: 'SKU', name: 'isSku', minWidth: 100, render: function (item) {
                            if (parseInt(item.isSku) == 1) return '是';
                            return '否';
                        },
                        editor: {
                            type: 'select',
                            data: selectData
                        }
                    },
                    {
                        display: '搜索', name: 'isSearch', minWidth: 100, render: function (item) {
                            if (parseInt(item.isSearch) == 1) return '是';
                            return '否';
                        },
                        editor: {
                            type: 'select',
                            data: selectData
                        }
                    },
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
                url: 'manager/productCategoryPro.do?method=proList',
                pageSize: 20,
                usePager: false,
                rownumbers: true,
                width: '100%',
                height: '100%',
                enabledEdit: true, clickToEdit: false, isScroll: false,
                toolbar: {
                    items: [
                        { text: '新增分类属性', click: addNewRow, icon: 'add' },
                        { text: '保存分类属性', click: saveData, icon: 'add' },
                        { text: '删除分类属性', click: deleteProData, icon: 'delete' }
                    ]
                }

            });

        });


        function treeLoadFinish(){
            tree.expandAll();
            tree.selectNode(1);
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
        function deleteRow(rowid, rowindex) {
            if (confirm('确定删除?')) {
                grid.deleteRow(rowindex);
            }

            $.ligerDialog.confirm('确定要删除吗', function (yes) {
                if(yes==true){
                    $.ajax({
                        cache: true,
                        type: "POST",
                        url:"manager/productCategoryPro.do?method=delPro&ids="+rowid,
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

        /**
         * 添加属性
         */
        function addNewRow(){
            var rowdata = {"classId": form.getData().id};
            grid.addEditRow(rowdata);
        }

        /**
         * 批量修改类别属性
         */
        function saveData(){
            var data = grid.getData();
            var cid = data[0].classId;
            $.ajax({
                cache: true,
                type: "POST",
                url:"manager/productCategoryPro.do?method=saveOrUpdatePro",
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
                    grid._setUrl("manager/productCategoryPro.do?method=proList&classId=" + cid);
                    grid.loadData(true);
                    $.ligerDialog.closeWaitting();
                }
            });
        }

        /**
         * 批量删除类别属性
         */
        function deleteProData(){
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
                        url:"manager/productCategoryPro.do?method=delPro&ids="+returnValue,
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

        /**
         * 类别树节点选中事件
         */
        function onSelectNode(node){
            //加载类别节点信息
            loadData(node.data.id);

            //加载类别的属性Grid
            $.ligerDialog.waitting('数据查询中,请稍候...');
            grid._setUrl("manager/productCategoryPro.do?method=proList&classId=" + node.data.id);
            grid.loadData(true);
            $.ligerDialog.closeWaitting();
        }

        /**
         * 加载类别节点信息
         */
        function loadData(id){
            $.ajax({
                cache: true,
                type: "POST",
                url:"manager/productCategory.do?method=getProductCategory",
                data: {"id": id},
                async: false,
                error: function(data) {
                    $.ligerDialog.tip({
                        title: '提示信息',
                        content: '获取信息失败'
                    });
                },
                success: function(data) {
                    form.setData(data);
                    $("#logo_image")[0].src=data.logo;
                }
            });
        }

        /**
        * 保存商品类别
        */
        function save(){
            var formData = form.getData();
            $.ajax({
                cache: true,
                type: "POST",
                url:"manager/productCategory.do?method=updateProductCategory",
                data: formData,
                async: false,
                error: function(request) {
                },
                success: function(data) {
                    $.ligerDialog.tip({
                        title: '提示信息',
                        content: data.message
                    });

                    var node = tree.getSelected();
                    tree.reload();
//                    tree.expandAll();
//                    tree.selectNode(node.data.id);
                }
            });
        }

        /**
        * 添加商品类别, 初始化Form表单
        */
        function addData(){
            var node = tree.getSelected();
            form.setData({
                id: "",
                name: "",
                des: "",
                rank: "",
                parentId: node.data.id,
                parentName: node.data.text,
                isEnd: "",
                logo: ""
            });
        }

        /**
        * 修改商品类别
        */
        function updateData(){
            alert("updateData");
        }

        /**
        * 删除商品类别
        */
        function deleteData(){
            var node = tree.getSelected();
            $.ajax({
                cache: true,
                type: "POST",
                url:"manager/productCategory.do?method=deleteProductCategory",
                data: {"id": node.data.id},
                async: false,
                error: function(request) {
                },
                success: function(data) {
                    $.ligerDialog.tip({
                        title: '提示信息',
                        content: data.message
                    });
                    tree.reload();
                }
            });
        }


        function submitform() {
            return form.getData();
        }

        function addProData(proId) {
            var node = tree.getSelected();//获取选择的类别节点
            $.ligerDialog.open({
                url: 'manager/product/productCategoryProValueList.jsp?proId='+proId+"&classId="+node.data.id, height: 500, width: 1000,
                buttons: [
                    {
                        text: '取消', onclick: function (item, dialog) {
                            dialog.close();
                        }
                    }
                ], isResize: true
            });
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
                    url: "manager/productCategoryPro.do?method=cutImg", type: "POST",
                    data: formData,
                    success: function (responseText) {
                        if(responseText.success==true){
                            $("#logo_image").attr("src", responseText.url);
                            $("#form2").ligerForm().setData({
                                logo: responseText.url
                            });
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
    <div id="toolbar" class="l-panel-topbar"></div>
    <div id="layout1" style="margin: -1px">
        <div position="left" title="商品类别维护">
            <div id="treediv" style="width: 250px; height: 100%; margin: -1px; float: left; border: 1px solid #ccc; overflow: auto;">
                <ul id="treeCategory"></ul>
            </div>
        </div>
        <div position="center">
            <div>
                <div id="form2" style="float: left;"></div>
                <div class='ibox-content' style="float: left;">
                    <div class='avatar-view' style='width:120px;height:120px;'>
                        <img id='logo_image' onclick='uploadimg()' src='resources/images/picture.jpg' alt='Logo' style='width:80px;height:70px;'>
                    </div>
                </div>
                <div id="maingrid" style="float: left;margin: 5px;" ></div>
            </div>
        </div>
    </div>
</form>

</body>
</html>
