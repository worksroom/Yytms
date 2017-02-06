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
    <title>卖家审核</title>
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
                        display: "用户ID",
                        name: "userId",
                        newline: true,
                        type: "text"
                    },
                    {
                        display: "用户姓名",
                        name: "name",
                        newline: false,
                        type: "text"
                    },
                    {
                        display: "身份证号",
                        name: "cardNumber",
                        newline: true,
                        type: "text"
                    },
                    {
                        display: "审核状态 ",
                        name: "status",
                        newline: false,
                        type: "select",
                        comboboxName: "roleCombo",
                        options: {data: [
                            {id: '1', value: '1', text: '通过' },
                            {id: '0', value: '0', text: '待审' },
                            {id: '-1', value: '-1', text: '打回' }
                        ]}
                    },
                    {
                        display: "审核信息",
                        name: "msg",
                        newline: true,
                        type: "textarea",
                        width: 300,
                        height: 60
                    }
                ],
                tab:
                {
                    items : [
                        {
                            title: '身份证正面', fields: [
                                {display: "正面", width: 500, hideLabel: true, name: "cardFPhoto", newline: false, type: "text", afterContent: "<div><img style='width: 410px;height: 260px;' id='cardFPhoto_img'></img></div>"}
                            ]
                        },
                        {
                            title: '身份证反面', fields: [
                                {display: "正面", width: 500, hideLabel: true, name: "cardBPhoto", newline: false, type: "text", afterContent: "<div><img style='width: 410px;height: 260px;' id='cardBPhoto_img'></img></div>"}
                            ]
                        },
                        {
                            title: '本人照片', fields: [
                                {display: "本人照", width: 500, hideLabel: true, name: "userCardPhoto", newline: false, type: "text", afterContent: "<div><img style='width: 260px;height: 410px;' id='userCardPhoto_img'></img></div>"}
                            ]
                        },
                        {
                            title: '营业执照', fields: [
                                {display: "营业执照", width: 500, hideLabel: true, name: "licencePhone", newline: false, type: "text", afterContent: "<div><img style='width: 410px;height: 260px;' id='licencePhone_img'></img></div>"}
                            ]
                        }
                    ]
                }
            });

            loadData();
        });

        function loadData(){
            $.ajax({
                cache: true,
                type: "POST",
                url:"manager/seller.do?method=loadUserSeller",
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
                    $("#cardFPhoto_img")[0].src=data.cardFPhoto;
                    $("#cardBPhoto_img")[0].src=data.cardBPhoto;
                    $("#userCardPhoto_img")[0].src=data.userCardPhoto;
                    $("#licencePhone_img")[0].src=data.licencePhone;
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
