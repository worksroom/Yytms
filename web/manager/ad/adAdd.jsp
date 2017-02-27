<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <base href="<%=basePath%>">
    <title>添加广告</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>

    <link href="resources/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css">
    <link href="resources/ligerUI/skins/Gray/css/all.css" rel="stylesheet" type="text/css">
    <script src="resources/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="resources/ligerUI/js/ligerui.all.js" type="text/javascript"></script>


    <script type="text/javascript">
        var groupicon = "resources/ligerUI/skins/icons/communication.gif";
        var form;
        var dialog = frameElement.dialog;

        $(function () {
            form = $("#form2").ligerForm({
                inputWidth: 170, labelWidth: 90, space: 10,
                fields: [
                    {
                        display: "广告类型",
                        name: "adType",
                        newline: false,
                        type: "select",
                        comboboxName: "adTypeCombo",
                        options: {
                            textField: "name",
                            valueField: "id",
                            url: "manager/adCategory.do?method=loadComboBox"
                        }
                    },{
                        display: "是否可用 ",
                        name: "used",
                        newline: false,
                        type: "select",
                        comboboxName: "usedName",
                        options: {data: [
                            { id: '1', value: '1', text: '是' },
                            { id: '0', value: '0', text: '否' }
                        ]}
                    },{
                        display: "广告描述",
                        name: "des",
                        newline: true,
                        rows: 3,
                        width: 440,
                        type: "textarea"
                    },{
                        display: "跳转地址",
                        name: "url",
                        width: 440,
                        newline: true,
                        type: "text"
                    },{
                        display: "图片地址",
                        name: "img",
                        newline: true,
                        type: "text",
                        width: 440,
                        afterContent: "<div><img id='logo_image' onclick='uploadimg()' src='resources/images/picture.jpg' alt='Logo' style='width:80px;height:70px;'></div>"
                    }
                ]
            });
        });

        function submitform() {
            return form.getData();
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
                    url: "manager/productCategoryPro.do?method=cutImg", type: "POST",
                    data: formData,
                    success: function (responseText) {
                        if(responseText.success==true){
                            $("#logo_image").attr("src", responseText.url);
                            $("#form2").ligerForm().setData({
                                img: responseText.url
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
    <div id="form2" style="float: left;"></div>
</form>

</body>
</html>
