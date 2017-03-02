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
    <title>订单查询</title>

    <link href="resources/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css">
    <link href="resources/ligerUI/skins/ligerui-icons.css" rel="stylesheet" type="text/css">
    <link href="resources/css/jquery-ui.min.css" rel="stylesheet" type="text/css">
    <link href="resources/css/ne.css" rel="stylesheet" type="text/css">
    <link href="resources/ligerUI/skins/Gray/css/all.css" rel="stylesheet" type="text/css">
    <script src="resources/jquery/jquery-1.9.0.min.js" type="text/javascript"></script>
    <script src="resources/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="resources/ligerUI/js/ligerui.all.js" type="text/javascript"></script>
    <script src="resources/js/json2.js" type="text/javascript"></script>
    <script type="text/javascript">
        var grid;
        $(function () {
            grid = $("#maingrid").ligerGrid({
                checkbox: true,
                columns: [
                    {display: '订单ID', name: 'id', align: 'left', width: 50},
                    {display: '买家ID', name: 'buyUserId', align: 'left', width: 100, minWidth: 60},
                    {display: '卖家ID', name: 'sellUserId', align: 'left', width: 100, minWidth: 60},
                    {display: '店铺ID', name: 'shopId', align: 'left', width: 100, minWidth: 60},
                    {display: '支付方式', name: 'payType', align: 'left', width: 100, minWidth: 60, render: function (item) {
                        var txt = "未知"
                        if(item.payType==1){
                            txt = "微信"
                        } else if(item.payType==2){
                            txt = "支付宝"
                        } else {
                            txt = "未知"
                        }
                        return txt;
                    }},
                    {display: '总金额', name: 'totalMoney', align: 'left', width: 100, minWidth: 60},
                    {display: '商品金额', name: 'productMoney', align: 'left', width: 100, minWidth: 60},
                    {display: '邮费', name: 'fee', align: 'left', minWidth: 100},
                    {display: '订单状态', name: 'status', minWidth: 60, render: function (item) {
                        var txt = "未知"
                        if(item.status==0){
                            txt = "待支付"
                        } else if(item.status==1){
                            txt = "已支付"
                        } else {
                            txt = "未知"
                        }
                        return txt;
                    }},
                    {display: '收货地址ID', name: 'addressId', minWidth: 100},
                    {display: '商品详情', name: 'productDesc', minWidth: 100},
                    {display: '支付时间', name: 'payTime', minWidth: 100},
                    {display: '修改时间', name: 'updateTime', minWidth: 140},
                    {display: '创建时间', name: 'createTime', minWidth: 140}
                ],
                dataAction: 'server',
                url: 'manager/order.do?method=orderList',
                usePager: true,
                pageSize: 20,
                rownumbers: true,
                width: '100%',
                height: '100%',
                isScroll: false,
                frozen:false,
                detailHeight: 100,
                detail: {onShowDetail: f_showOrder}
            });


            $("#pageloading").hide();
        });

        function f_getOrdersData(row) {
            var data = {Rows: JSON.parse(row.productDesc)};

            return data;
        }

        //显示订单详情Grid
        function f_showOrder(row, detailPanel, callback) {
            var grid = document.createElement('div');
            $(detailPanel).append(grid);
            $(grid).css('margin', 5).ligerGrid({
                columns: [
                    {display: '商品名称', name: 'product_name', width: 120},
                    {display: '商品图片', name: 'product_img', width: 120},
                    {display: '属性值', name: 'product_pro_value', width: 120},
                    {display: '价格', name: 'price', width: 80, type: 'float'},
                    {display: '折扣价', name: 'salePrice', width: 80, type: 'float'},
                    {display: '优惠金额', name: 'fee', width: 80, type: 'float'},
                    {display: '数量', name: 'num', width: 50}
                ],
                width: '90%',
                isScroll: false,
                frozen:false,
                columnWidth: 100,
                detailHeight: 100,
                data: f_getOrdersData(row),
                onAfterShowData: callback,
                usePager: false
            });
        }


        function doserch(){
            var serchtxt = $("#serchform :input").fieldSerialize();
            $.ligerDialog.waitting('数据查询中,请稍候...');
            grid._setUrl("manager/order.do?method=orderList&" + serchtxt);
            grid.loadData(true);
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
        <table style='width: 600px' class="bodytable1">
            <tr>
                <td>
                    <div style='width: 60px; text-align: right; float: right'>买家ID：</div>
                </td>
                <td>
                    <input type='text' id='buyerUserId' name='buyerUserId' style="width:80px"/>
                </td>

                <td>
                    <div style='width: 60px; text-align: right; float: right'>店铺ID：</div>
                </td>
                <td>
                    <input type='text' id='shopId' name='shopId' style="width:80px"/>
                </td>

                <td>
                    <div style='width: 60px; text-align: right; float: right'>订单状态：</div>
                </td>
                <td>
                    <select id="status" name="status" style="width:80px">
                        <option value="0">待支付</option>
                        <option value="1">已支付</option>
                    </select>
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

<div style="display:none;">

</div>
</body>
</html>
