<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.youguu.core.util.ParamUtil" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";

    int categoryId = ParamUtil.CheckParam(request.getParameter("categoryId"), 0);
    int goodsId = ParamUtil.CheckParam(request.getParameter("goodsId"), 0);
    int shopId = ParamUtil.CheckParam(request.getParameter("shopId"), 0);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <base href="<%=basePath%>">
    <title>货品审核明细</title>
    <script src="resources/jquery/jquery-1.9.0.min.js" type="text/javascript"></script>
    <link href="resources/css/input.css" rel="stylesheet" type="text/css">

    <script charset="utf-8" src="resources/kindeditor-4.1.7/kindeditor.js"></script>
    <script charset="utf-8" src="resources/kindeditor-4.1.7/lang/zh_CN.js"></script>

    <link href="resources/swf/swfupload-default.css" rel="stylesheet"type="text/css" />
    <script type="text/javascript" src="resources/swf/swfupload.js"></script>
    <script type="text/javascript" src="resources/swf/handlers.js"></script>

    <script src="resources/jquery/jquery.form.js" type="text/javascript"></script>
    <script src="resources/js/json2.js" type="text/javascript"></script>

    <link href="resources/sku/liandong.css" rel="stylesheet"/>
    <script src="resources/sku/sku.js" type="text/javascript"></script>

    <link href="resources/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css">
    <link href="resources/ligerUI/skins/ligerui-icons.css" rel="stylesheet" type="text/css">
    <link href="resources/ligerUI/skins/Gray/css/all.css" rel="stylesheet" type="text/css">
    <script src="resources/ligerUI/js/core/base.js" type="text/javascript"></script>
    <script src="resources/ligerUI/js/ligerui.all.js" type="text/javascript"></script>

    <script type="text/javascript">

        var editor;
        var prodata;
        $(function () {

            //初始化商品属性区域
            initProductPro();

            //初始化商品销售属性区域
            initProductSalePro();

            $().SKU();

            loadStoreLocation();

            loadFareMould();


            loadData();
        });


        /**
         * 初始化商品属性区域
         */
        function initProductPro(){
            prodata = "";
            $.ajax({
                cache: true,
                type: "POST",
                url:"manager/goods.do?method=loadProList",
                data:{"classId": <%=categoryId %>},
                async: false,
                error: function(data) {
                    $.ligerDialog.tip({
                        title: '提示信息',
                        content: data.message
                    });
                },
                success: function(data) {

                    if(data.status=="0000" && data.result.length>0){
                        prodata = data.result;//全局变量赋值

                        var colspan=3;
                        var i = 0;
                        var tr;
                        $(data.result).each(function(){

                            if(this.isSku==1){
                                return true;
                            }

                            if(i%colspan==0){
                                tr = $('<tr></tr>');
                                $("#second").before(tr);
                            }
                            var td_title = $('<td><div style="text-align: right; float: right">'+this.name+'：</div></td>');
                            td_title.appendTo(tr);
                            var td_input = $('<td><input disabled="disabled" id="pro_'+this.id+'" name="pro_'+this.id+'" type="text" ltype="text" ligerui="{width:100}"/></td>');
                            td_input.appendTo(tr);

                            i++;


                        });

                    }
                }
            });
        }

        /**
         * 初始化商品销售属性区域
         */
        function initProductSalePro(){
            var prostr = "";
            var i = 0;
            $(prodata).each(function(){
                //是否是销售属性，非销售属性不处理
                if(this.isSku!=1){
                    return true;
                }

                prostr += '<tr class="div_contentlist">';
                prostr += '<td>';
                prostr += '<ul class="Father_Title"><li>'+this.name+'：</li></ul>';
                prostr += '</td>';
                prostr += '<td colspan="5">';

                prostr += '<ul class="Father_Item'+i+'">';

                var proId = this.id;
                if(this.isMultiple){//多选
                    $(this.list).each(function(){
                        var proValueId = this.id;
                        prostr += '<li class="li_width"><label><input disabled="disabled" id="key_'+proId+'_'+proValueId+'" type="checkbox" class="chcBox_Width" value="'+this.name+'">'+this.name+'<span class="li_empty"> </span></label></li>';
                    });
                }

                prostr += '</ul>';
                prostr += '</td>';
                prostr += '</tr>';
                i++;
            });

            $("#second").after(prostr);
        }

        /**
         * 加载仓库位置
         */
        function loadStoreLocation(){
            $.ajax({
                cache: true,
                type: "POST",
                url:"manager/storeLocation.do?method=storeLocationList",
                data: {"shopId": "<%=shopId %>"},
                async: false,
                error: function(data) {
                    $.ligerDialog.tip({
                        title: '提示信息',
                        content: data.message
                    });
                },
                success: function(data) {
                    $("#address_div").html("");
                    var select = $('<select id="address_id" name="address_id" style="width:300px" disabled="disabled"></select>');
                    select.appendTo($("#address_div"));
                    $(data.Rows).each(function(){
                        var option = $('<option value="'+this.id+'">'+this.fName+','+this.sName+'</option>');
                        option.appendTo(select);
                    });
                }
            });
        }

        /**
         * 加载运费模板
         */
        function loadFareMould(){
            $.ajax({
                cache: true,
                type: "POST",
                url:"manager/fareMould.do?method=fareMouldList",
                data: {"shopId": "<%=shopId %>"},
                async: false,
                error: function(data) {
                    $.ligerDialog.tip({
                        title: '提示信息',
                        content: data.message
                    });
                },
                success: function(data) {
                    $("#fare_div").html("");
                    var select = $('<select id="fare_id" name="fare_id" style="width:300px" disabled="disabled"></select>');
                    select.appendTo($("#fare_div"));
                    $(data.Rows).each(function(){
                        var option = $('<option value="'+this.id+'">'+this.name+'</option>');
                        option.appendTo(select);
                    });
                }
            });
        }

        function loadData(){
            $.ajax({
                cache: true,
                type: "POST",
                url:"manager/goods.do?method=getGoods",
                data: {"goodsId": "<%=goodsId %>"},
                async: false,
                error: function(data) {
                    $.ligerDialog.tip({
                        title: '提示信息',
                        content: '获取信息失败'
                    });
                },
                success: function(data) {

                    var mallGoods = data.mallGoods;
                    var bpro = data.bpro;
                    var plist = data.list;
                    var exts = data.exts;

                    //商品名称
                    $("#product_name").val(mallGoods.name);

                    //审核状态
                    $("#status").val(mallGoods.status);

                    //商品描述
                    KindEditor.ready(function(K) {
                        editor = K.create('#editor_id');
                        editor.html(mallGoods.des);
                        editor.readonly(true);
                    });

                    //货品基本属性区域赋值
                    $(bpro).each(function(){
                        $("#pro_"+this.classProId).val(this.classProValue);
                    });

                    //销售属性设置
                    $(plist).each(function(){
                        var product = this.mallProduct;
                        var saleProList = this.salePro;

                        $(saleProList).each(function(){
                            var classProId = this.classProId;
                            var classProValueId = this.classProValueId;
                            var chx_key = "key_"+classProId+"_"+classProValueId;
                            $("#"+chx_key).attr("checked",true);
                            $("#"+chx_key).attr("disabled",true);
                        });

                        $().InitTableData(product);
                    });

                    //货品图片设置
                    var imgArray = JSON.parse(mallGoods.img);
                    var i=1;
                    $(imgArray).each(function(){
                        $("#img_"+i)[0].src = this;
                        i++;
                    });

                    //仓库地址，运费模板
                    $(exts).each(function(){
                        //库存位置
                        if(this.type==1){
                            $("#address_id").val(this.thridId);
                        }

                        //运费模板
                        if(this.type==2){
                            $("#fare_id").val(this.thridId);
                        }
                    });
                }
            });
        }

        function submitForm(){
            return {
                goodsId: <%=goodsId %>,
                status: $("#status").val()
            }
        }
    </script>
</head>
<body style="height: 100%; overflow-x: hidden; overflow-y: auto;">

<form id="form1" name="form1">

    <input type="hidden" id="goodsId" name="goodsId" value="<%=goodsId%>"/>
    <input type="hidden" id="categoryId" name="categoryId" value="<%=categoryId%>"/>
    <table style="width: 900px; margin: 2px;" class="bodytable1">
        <tr>
            <td colspan="6" class="table_title1">基本信息</td>
        </tr>
        <tr>
            <td>
                <div style="text-align: right; float: right">商品名称：</div>
            </td>
            <td colspan="5">
                <input type="text" id="product_name" name="product_name" disabled="disabled"/>
            </td>
        </tr>
        <tr>
            <td>
                <div style="text-align: right; float: right">商品描述：</div>
            </td>
            <td colspan="5">
                <textarea id="editor_id" name="content" style="width:700px;height:300px;">

                </textarea>
            </td>
        </tr>

        <tr>
            <td class="table_title1" colspan="6">商品基本属性</td>
        </tr>


        <tr id="second">
            <td class="table_title1" colspan="6">销售属性</td>
        </tr>

        <tr>
            <td>
                &nbsp;
            </td>
            <td colspan="5">
                <div class="div_contentlist2">
                    <ul>
                        <li><div id="createTable"></div></li>
                    </ul>
                </div>
            </td>
        </tr>
        <tr>
            <td class="table_title1" colspan="6">商品图片</td>
        </tr>
        <tr>
            <td colspan="6">
                <div id="imgDiv">
                    <img id="img_1" src="resources/images/picture.jpg" alt="Logo" style="width:80px;height:80px;">
                    <img id="img_2" src="resources/images/picture.jpg" alt="Logo" style="width:80px;height:80px;">
                    <img id="img_3" src="resources/images/picture.jpg" alt="Logo" style="width:80px;height:80px;">
                    <img id="img_4" src="resources/images/picture.jpg" alt="Logo" style="width:80px;height:80px;">
                    <img id="img_5" src="resources/images/picture.jpg" alt="Logo" style="width:80px;height:80px;">
                    <img id="img_6" src="resources/images/picture.jpg" alt="Logo" style="width:80px;height:80px;">
                </div>
            </td>
        </tr>
        <tr>
            <td class="table_title1" colspan="6">物流信息</td>
        </tr>
        <tr>
            <td>
                <div style="text-align: right; float: right">发货地：</div>
            </td>
            <td colspan="5">
                <div id="address_div">

                </div>
            </td>
        </tr>
        <tr>
            <td>
                <div style="text-align: right; float: right">运费：</div>
            </td>
            <td colspan="5">
                <div>
                    <div id="fare_div" style="float: left;"></div>
                </div>
            </td>
        </tr>
        <tr style="height: 50px;">
            <td>
                <div style="text-align: right; float: right; font-size: 20px;">审核状态：</div>
            </td>
            <td colspan="5">
                <div style="font-size: 20px;">
                    <select id="status" name="status">
                        <option value="1">通过</option>
                        <option value="99">待审</option>
                    </select>
                </div>
            </td>
        </tr>
    </table>
</form>
</body>
</html>