<%@ page import="com.youguu.core.util.ParamUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    String roleid = ParamUtil.CheckParam(request.getParameter("roleid"), "");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <base href="<%=basePath%>">
    <title>树控件 - 支持拖拽</title>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">

    <script src="resources/jquery/jquery-1.9.0.min.js" type="text/javascript"></script>
    <link href="resources/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css">
    <script src="resources/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="resources/ligerUI/js/ligerui.all.js" type="text/javascript"></script>
    <script src="resources/ligerUI/js/plugins/ligerTree.js" type="text/javascript"></script>
    <script src="resources/js/json2.js" type="text/javascript"></script>
    <script type="text/javascript">
        var manager = null;

        $(function () {
            $("#tree1").ligerTree({
                url: "manager/sysMenu.do?method=makeRoleModuleTree&id=0002&roleid=<%=roleid%>",
                checkbox: true,
                idFieldName: 'id',
                isexpand: false,
                autoCheckboxEven: false,
                slide: false,
                nodeWidth: 120,
                onSelect: function (node) {
//                    alert('onSelect='+node);
                },
                onCheck: function(node){
//                    var pid = node.data.pid;
//                    manager.selectNode(pid);
//
//                    var p1 = manager.getParentTreeItem(node);
//                    alert(p1);
//                    var p2 = manager.getParentTreeItem(p1);
//                    alert(p2);
//                    manager.selectNode(p2);
                    selectParent(node);

                },
                onAfterAppend: function () {manager.expandAll();}
            });


            manager = $("#tree1").ligerGetTreeManager();
//            manager.collapseAll();
        });

        function selectParent(node){
            if(node!=null){
                var p = manager.getParentTreeItem(node);
                if(p!=null){
                    manager.selectNode(p);
                    selectParent(p);
                } else {
                    return ;
                }
            }
            return ;
        }


        function getSelectNodes(){
            var notes = manager.getChecked();
            return notes;
        }

        function getChecked() {
            var notes = manager.getChecked();
            var ctext = [];
            for (var i = 0; i < notes.length; i++) {
                if (notes[i].data.pid == 0) {

                } else {
                    ctext.push(notes[i].data.id);
                }
            }
            return ctext.join(",");
        }

    </script>

</head>
<body style="padding:0px;">
<div style="width:98%; height:500px; border:1px solid #ccc; overflow:auto; clear:both;">
    <ul id="tree1" style="margin-top: 3px;"/>
    <div class="l-tree-loading" style="display: block;"></div>
</div>
</body>
</html>
