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
        var groupicon = "resources/ligerUI/skins/icons/communication.gif";
        var form;
        var dialog = frameElement.dialog;

        $(function () {
            //创建表单结构
            form = $("#form2").ligerForm({
                inputWidth: 170, labelWidth: 90, space: 10,
                fields: [
                    {
                        display: "用户姓名",
                        name: "userName",
                        newline: true,
                        type: "text"
                    },
                    {
                        display: "所属角色", name: "roleId", textField: "roleName",
                        newline: false, type: "combobox",
                        editor: {
                            selectBoxWidth: 400,
                            selectBoxHeight: 200,
                            textField: 'roleName',
                            valeuField: 'id',
                            grid: {
                                columns: [
                                    {display: '角色名称', name: 'roleName', align: 'left', width: 100, minWidth: 60},
                                    {display: '角色状态', name: 'type', minWidth: 120},
                                    {display: '创建时间', name: 'createtime', minWidth: 140}
                                ],
                                url: 'manager/sysRole.do?method=roleList',
                                isScroll: false, sortName: 'id',
                                width: 480
                            }
                        }
                    },
                    {display: "登录账户", name: "userLoginName",newline: true,type: "text"},
                    {display: "登录密码", name: "userPassword", newline: false, type: "text"},
                    {display: "联系电话", name: "userTel",newline: true,type: "text"},
                    {display: "QQ", name: "userQq", newline: false, type: "text"},
                    {display: "电子邮箱 ", name: "userEmail", newline: true, type: "text"},
                    {display: "出生日期", name: "userBirthday", newline: false, type: "date",format:"MM/dd/yyyy"},
                    {display: "现住址", name: "userCurrentAddress", newline: true, type: "text", width: 440},
                    {display: "户籍地址", name: "userAddress", newline: true, type: "text", width: 440}
                ]
            });
        });


        function submitform() {
            return form.getData();
        }

    </script>

</head>
<body style="padding:0px;height: 90%">
<div>
    <div id="form2" style="float: left;"></div>
    <div id="head" style="float: left;margin: 5px;">
        <img id="userheadimg" src="http://img.sj33.cn/uploads/allimg/201003/20100303234701377.jpg" onerror="noheadimg()"
             style="border-radius: 4px; box-shadow: 1px 1px 3px #111; width: 120px; height: 120px; margin-left: 5px; background: #d2d2f2; border: 3px solid #fff; behavior: url(../css/pie.htc);"/>
    </div>
</div>
</body>
</html>
