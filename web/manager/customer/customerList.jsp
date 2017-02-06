<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
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
    <title>用户查询</title>

    <link href="resources/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css">
    <link href="resources/ligerUI/skins/ligerui-icons.css" rel="stylesheet" type="text/css">
    <link href="resources/css/jquery-ui.min.css" rel="stylesheet" type="text/css">
    <link href="resources/css/ne.css" rel="stylesheet" type="text/css">
    <link href="resources/css/input.css" rel="stylesheet" type="text/css">
    <link href="resources/ligerUI/skins/Gray/css/all.css" rel="stylesheet" type="text/css">
    <script src="resources/jquery/jquery-1.9.0.min.js" type="text/javascript"></script>
    <script src="resources/css/jquery-ui.min.js" type="text/javascript"></script>
    <script src="resources/jquery/jquery.form.js" type="text/javascript"></script>
    <script src="resources/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="resources/ligerUI/js/ligerui.all.js" type="text/javascript"></script>
    <script src="resources/js/json2.js" type="text/javascript"></script>
    <script type="text/javascript">

        $(function () {
            window['g'] =
                    $("#maingrid").ligerGrid({
                        checkbox: true,
                        columns: [
                            {display: '用户ID', name: 'userId', align: 'left', width: 60},
                            {display: '用户名', name: 'userName', align: 'left', width: 100, minWidth: 60},
                            {display: '昵称', name: 'nickName', minWidth: 60},
                            {display: '手机号', name: 'phone', minWidth: 60},
                            {display: '邮箱', name: 'email', minWidth: 100},
                            {display: '创建时间', name: 'createTime', minWidth: 140},
                            {display: '修改时间', name: 'updateTime', minWidth: 140}
                        ],
                        dataAction: 'server',
                        url: 'manager/customer.do?method=customerList',
                        pageSize: 20,
                        rownumbers: true,
                        width: '100%',
                        height: '100%',
                        toolbar: <jsp:include page="../layout/function.jsp" flush="true"/>
                    });


            $("#pageloading").hide();

        });

        function doserch(){
            var serchtxt = $("#serchform :input").fieldSerialize();
            $.ligerDialog.waitting('数据查询中,请稍候...');
            var manager = $("#maingrid").ligerGetGridManager();

            manager._setUrl("manager/customer.do?method=customerList&" + serchtxt);
            manager.loadData(true);
            $.ligerDialog.closeWaitting();

        }

        function doclear() {
            $("input:hidden", "#serchform").val("");
            $("input:text", "#serchform").val("");
            $(".l-selected").removeClass("l-selected");
        }


    </script>

</head>
<body style="overflow:hidden">


<div class="l-loading" style="display:block" id="pageloading"></div>
<a class="l-button" style="width:120px;float:left; margin-left:10px; display:none;" onclick="deleteRow()">删除选择的行</a>


<div class="l-clear"></div>

<div class="az">
    <form id='serchform'>
        <table style='width: 1020px' class="bodytable1">
            <tr>
                <td>
                    <div style='width: 60px; text-align: right; float: right'>客户ID：</div>
                </td>
                <td>
                    <input type='text' id='userId' name='userId' style="width:80px"/>
                </td>

                <td>
                    <div style='width: 60px; text-align: right; float: right'>用户名：</div>
                </td>
                <td>
                    <input type='text' id='name' name='name' style="width:80px"/>
                </td>

                <td>
                    <div style='width: 60px; text-align: right; float: right'>昵称：</div>
                </td>
                <td>
                    <input type='text' id='nickname' name='nickname' style="width:80px"/>
                </td>

                <td>
                    <div style='width: 60px; text-align: right; float: right'>手机号：</div>
                </td>
                <td>
                    <input type='text' id='phone' name='phone' style="width:80px"/>
                </td>

                <td>
                    <div style='width: 60px; text-align: right; float: right'>邮箱：</div>
                </td>
                <td>
                    <input type='text' id='email' name='email' style="width:80px"/>
                </td>
                <td>
                    <input id='Button2' type='button' value='重置' style='width: 80px; height: 24px' onclick="doclear()" />
                    <input id='Button1' type='button' value='搜索' style='width: 80px; height: 24px' onclick="doserch()" />
                </td>

            </tr>
        </table>
    </form>
</div>

<div id="maingrid"></div>

<div style="display:none;"></div>




</body>
</html>
