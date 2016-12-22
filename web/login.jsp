<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <base href="<%=basePath%>">
    <meta http-equiv="Content-Language" content="zh-CN"/>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="renderer" content="webkit">
    <title>系统登录</title>

    <script src="resources/js/config.js" type="text/javascript"></script>
    <script src="resources/jquery/jquery-1.3.2.min.js" type="text/javascript"></script>
    <link href="resources/ligerUI/skins/Aqua/css/ligerui-dialog.css" rel="stylesheet" type="text/css"/>
    <link href="resources/ligerUI/skins/Gray2014/css/dialog.css" rel="stylesheet" type="text/css"/>
    <script src="resources/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="resources/ligerUI/js/plugins/ligerDialog.js" type="text/javascript"></script>
    <script src="resources/js/common.js" type="text/javascript"></script>
    <script src="resources/js/ne.js" type="text/javascript"></script>
    <link href="resources/css/login.css" rel="stylesheet"/>
    <script type="text/javascript">
        $(function () {
            $(".login-text").focus(function () {
                $(this).addClass("login-text-focus");
            }).blur(function () {
                $(this).removeClass("login-text-focus");
            });

            $(document).keydown(function (e) {
                if (e.keyCode == 13) {
                    dologin();
                }
            });

            $("#btnLogin").click(function () {
                dologin();
            });


            function dologin() {
                var username = $("#txtUsername").val();
                var password = $("#txtPassword").val();
                if (username == "") {
                    alert('账号不能为空!');
                    $("#txtUsername").focus();
                    return;
                }
                if (password == "") {
                    alert('密码不能为空!');
                    $("#txtPassword").focus();
                    return;
                }
                $.ajax({
                    type: 'post', cache: false, dataType: 'json',
                    url: 'loginAction.do?method=login',
                    data: [
                        {name: 'username', value: username},
                        {name: 'password', value: password}
                    ],
                    success: function (data) {

                        if(data.success==true) {
                            window.location.href = "manager/layout/layout.jsp";
                        } else {
                            alert('登陆失败,账号或密码有误!');
                            $("#txtUsername").focus();
                            return;
                        }

                    },
                    error: function () {
                        alert('发送系统错误,请与系统管理员联系!');
                    },
                    beforeSend: function () {
                        $.ligerDialog.waitting("正在登陆中,请稍后...");
                        $("#btnLogin").attr("disabled", true);
                    },
                    complete: function () {
                        $.ligerDialog.closeWaitting();
                        $("#btnLogin").attr("disabled", false);
                    }
                });
            }

            $("#txtUsername").focus();
        });
    </script>

</head>
<body>


<div id="login">
    <div id="loginlogo"></div>
    <div id="loginpanel">
        <div class="panel-h"></div>
        <div class="panel-c">
            <div class="panel-c-l">

                <table cellpadding="0" cellspacing="0">
                    <tbody>
                    <tr>
                        <td align="left" colspan="2">
                            <h3>请使用 系统账号登陆</h3>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">账号：</td>
                        <td align="left"><input type="text" name="loginusername" id="txtUsername" value="admin"
                                                class="login-text"/></td>
                    </tr>
                    <tr>
                        <td align="right">密码：</td>
                        <td align="left"><input type="password" name="loginpassword" id="txtPassword" value="admin123"
                                                class="login-text"/></td>
                    </tr>
                    <tr>
                        <td align="center" colspan="2">
                            <input type="submit" id="btnLogin" value="登陆" class="login-btn"/>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div class="panel-c-r">
                <p>如果遇到系统问题，请联系网络管理员。</p>
                <p>联系电话：010-87668988</p>
                <p>西湖工作室</p>
            </div>
        </div>
        <div class="panel-f"></div>
    </div>
    <div id="logincopyright">Copyright © 2012 Nexteasy管理系统</div>

</div>
</body>
</html>
