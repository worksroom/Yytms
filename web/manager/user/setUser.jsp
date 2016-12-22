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
    <meta http-equiv="Content-Language" content="zh-CN"/>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="renderer" content="webkit">
    <title>用户管理</title>

    <link href="resources/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css">
    <link href="resources/ligerUI/skins/ligerui-icons.css" rel="stylesheet" type="text/css">
    <link href="resources/css/jquery-ui.min.css" rel="stylesheet" type="text/css">
    <link href="resources/css/ne.css" rel="stylesheet" type="text/css">
    <link href="resources/ligerUI/skins/Gray/css/all.css" rel="stylesheet" type="text/css">
    <script src="resources/jquery/jquery-1.9.0.min.js" type="text/javascript"></script>
    <script src="resources/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="resources/ligerUI/js/ligerui.all.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(function () {
            window['g'] =
                    $("#maingrid").ligerGrid({
                        height: '100%',
                        checkbox: true,
                        columns: [
                            {display: '姓名', name: 'userName'},
                            {display: '登录账户', name: 'userLoginName'},
                            {display: '状态', name: 'userDelFlag'},
                            {display: '选中状态', name: 'checked', align: 'left', width: 50, hide: true}
                        ],
                        dataAction: 'server',
                        url: "manager/sysUser.do?method=userRoleList&roleid=<%=roleid%>",
                        pageSize: 20,
                        rownumbers: true,
                        isChecked: f_isChecked,
                        onCheckRow: f_onCheckRow,
                        onCheckAllRow: f_onCheckAllRow
                    });


            $("#pageloading").hide();
        });

        function f_onCheckAllRow(checked) {
            for (var rowid in this.records) {
                if (checked) {
                    addCheckedCustomer(this.records[rowid]['userLoginName']);
                } else {
                    removeCheckedCustomer(this.records[rowid]['userLoginName']);
                }

            }
        }

        var checkedCustomer = [];
        function findCheckedCustomer(userLoginName) {
            for (var i = 0; i < checkedCustomer.length; i++) {
                if (checkedCustomer[i] == userLoginName) return i;
            }
            return -1;
        }

        function addCheckedCustomer(userLoginName) {
            if (findCheckedCustomer(userLoginName) == -1) {
                checkedCustomer.push(userLoginName);
            }

        }

        function removeCheckedCustomer(userLoginName) {
            var i = findCheckedCustomer(userLoginName);
            if (i == -1) {
                return;
            }
            checkedCustomer.splice(i, 1);
        }

        function f_isChecked(rowdata) {
            if (rowdata.checked == 1) {
                addCheckedCustomer(rowdata.userLoginName);
                return true;
            }

            if (findCheckedCustomer(rowdata.userLoginName) == -1) {
                return false;
            }

            return true;
        }

        function f_onCheckRow(checked, data) {
            if (checked) {
                addCheckedCustomer(data.userLoginName);
            } else {
                removeCheckedCustomer(data.userLoginName);
            }
        }

        function f_getChecked() {
            return checkedCustomer.join(',');
        }
    </script>

</head>
<body style="overflow: hidden">
<div class="l-loading" style="display:block" id="pageloading"></div>

<div class="l-clear"></div>

<div id="maingrid"></div>

<div style="display:none;">

</div>
</body>
</html>
