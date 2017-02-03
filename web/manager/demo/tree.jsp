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
    <script src="resources/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="resources/ligerUI/js/ligerui.all.js" type="text/javascript"></script>
    <script type="text/javascript">
        var tree = null;
        $(function () {

            $("#tree1").ligerTree({
                data: [
                    {
                        text: '节点1', children: [
                        {text: '节点1.1'},
                        {text: '节点1.2'},
                        {
                            text: '节点1.3', children: [
                            {text: '节点1.3.1'},
                            {text: '节点1.3.2'}
                        ]
                        },
                        {text: '节点1.4'}
                    ]
                    },
                    {text: '节点2'},
                    {text: '节点3'},
                    {text: '节点4'}
                ],
                idFieldName: 'id',
                //parentIDFieldName: 'pid',
                usericon: 'd_icon',
                checkbox: false,
                itemopen: false,
                onError: function () { javascript: location.replace("login.aspx"); }
            });

        });
        function f_selectNode() {
            var parm = function (data) {
                return data.text.indexOf('节点1.3') == 0;
            };

            tree.selectNode(parm);
        }

        function f_cancelSelect() {
            var parm = function (data) {
                return false;
            };

            tree.selectNode(parm);
        }
    </script>

</head>
<body>
<div>
    <a class="l-button" style="width:120px; margin-left:10px; float:left;" onclick="f_selectNode()">选择行</a>
    <a class="l-button" style="width:120px; margin-left:10px;float:left;" onclick="f_cancelSelect()">反选择行</a>
</div>

<div style="width:200px; height:300px; margin:10px; float:left; clear:both; border:1px solid #ccc; overflow:auto;  ">
    <ul id="tree1"></ul>
</div>

<div style="display:none">

</div>
</body>