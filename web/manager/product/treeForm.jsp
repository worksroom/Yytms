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
    <script src="resources/jquery/jquery-1.9.0.min.js" type="text/javascript"></script>
    <link href="resources/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css">
    <link href="resources/ligerUI/skins/Gray/css/all.css" rel="stylesheet" type="text/css">
    <script src="resources/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="resources/ligerUI/js/ligerui.all.js" type="text/javascript"></script>

    <script type="text/javascript">
        var groupicon = "resources/ligerUI/skins/icons/communication.gif";
        var form;
        var manager;
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
                    {display: "类别描述", name: "des", newline: false, type: "text"},
                    {display: "排序", name: "rank", newline: true, type: "text"},
                    {display: "父节点", name: "parentId", newline: false, type: "hidden"},
                    {display: "父节点", name: "parentName", newline: false, type: "text"},
                    {display: "isEnd", name: "isEnd", newline: true, type: "text"},
                    {display: "Logo", name: "logo", newline: false, type: "text"}
                ],
                buttons: [
                    {text: '保存', width: 60, click: save}
                ]
            });

            $("#treeCategory").ligerTree({
                url: 'manager/productCategory.do?method=loadCategoryTree',
                idFieldName: 'id',
                //parentIDFieldName: 'pid',
                usericon: 'd_icon',
                checkbox: false,
                itemopen: false,
                onError: function () {
                },
                onSelect: onSelectNode
            });
        });

        function onSelectNode(node){
            loadData(node.data.id);
        }

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
                }
            });
        }


        function addData(){
            manager = $("#treeCategory").ligerGetTreeManager();
            var node = manager.getSelected();
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

        function updateData(){
            alert("updateData");
        }

        function deleteData(){
            alert("deleteData");
        }

        function submitform() {
            return form.getData();
        }

        function addProData() {
            $.ligerDialog.open({
                url: 'manager/product/proAdd.jsp', height: 400, width: 600, buttons: [{
                    text: '确定', onclick: function (item, dialog) {
                        var formData = dialog.frame.submitform();
                        alert(JSON2.stringify(formData));
                        $.ajax({
                            cache: true,
                            type: "POST",
                            url: "manager/sysRole.do?method=addSysRole",
                            data: formData,
                            async: false,
                            error: function (data) {
                                $.ligerDialog.tip({
                                    title: '提示信息',
                                    content: data.message
                                });
                            },
                            success: function (data) {
                                dialog.close();
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
                <div id="head" style="float: left;margin: 5px;">
                    <img id="userheadimg" src="http://img.sj33.cn/uploads/allimg/201003/20100303234701377.jpg" onerror="noheadimg()"
                         style="border-radius: 4px; box-shadow: 1px 1px 3px #111; width: 120px; height: 120px; margin-left: 5px; background: #d2d2f2; border: 3px solid #fff; behavior: url(../css/pie.htc);"/>
                </div>
            </div>

        </div>
    </div>


    <!--<a class="l-button" onclick="getChecked()" style="float:left;margin-right:10px;">获取选择(复选框)</a> -->
    <div style="display: none">
        <!--  数据统计代码 -->
    </div>
</form>


</body>
</html>
