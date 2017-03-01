(function ($) {
    $.fn.SKU = function () {
        $(".div_contentlist label").bind("change", function () {
            step.Create_Table();
        });
    }

    $.fn.InitTableData = function(data){
        step.Update_Table(data);
    }

    var step = {
        //SKU信息组合
        Create_Table: function () {
            step.hebingFunction();
            var SKUObj = $(".Father_Title");
            var arrayTile = new Array();//标题组数
            var arrayInfor = new Array();//盛放每组选中的CheckBox值的对象，数据结构id_value
            var arrayColumn = new Array();//指定列，用来合并哪些列
            var bCheck = true;//是否全选
            var columnIndex = 0;
            $.each(SKUObj, function (i, item){
                arrayColumn.push(columnIndex);
                columnIndex++;
                arrayTile.push(SKUObj.find("li").eq(i).html().replace("：", ""));
                var itemName = "Father_Item" + i;
                //选中的CHeckBox取值
                var order = new Array();
                $("." + itemName + " input[type=checkbox]:checked").each(function (){
                    order.push($(this).attr("id")+"|"+$(this).val());//格式:key_{proId}_{proValueId}|{proValue}
                });
                arrayInfor.push(order);
                if (order.join() == ""){
                    bCheck = false;
                }
                //var skuValue = SKUObj.find("li").eq(index).html();
            });
            //开始创建Table表
            if (bCheck == true) {
                var RowsCount = 0;
                //$("#createTable").html("");

                var table = $("#process");
                if(table.length>0){//如果Table存在，不再创建

                } else{//如果Table不存在，则创建一个Table
                    table = $("<table id=\"process\" border=\"1\" cellpadding=\"1\" cellspacing=\"0\" style=\"width:100%;padding:5px;\"></table>");
                    table.appendTo($("#createTable"));

                    var thead = $("<thead></thead>");
                    thead.appendTo(table);
                    var trHead = $("<tr></tr>");
                    trHead.appendTo(thead);
                    //创建表头
                    $.each(arrayTile, function (index, item) {
                        var td = $("<th>" + item + "</th>");
                        td.appendTo(trHead);
                    });
                    var itemColumHead = $("<th  style=\"width:70px;\">价格</th><th style=\"width:70px;\">折扣价</th><th style=\"width:70px;\">库存</th> ");
                    itemColumHead.appendTo(trHead);

                    var tbody = $("<tbody></tbody>");
                    tbody.appendTo(table);
                }

                var tbody = table.find("tbody");
                //生成组合
                var zuheData = step.doExchange(arrayInfor);
                step.Delete_Row(zuheData);
                if (zuheData.length > 0) {
                    //创建行
                    $.each(zuheData, function (index, item) {
                        var td_array = item.split(",");
                        var tr = $("<tr></tr>");

                        var rowid = "";
                        $.each(td_array, function (i, values) {
                            var td = $("<td>" + values.split("|")[1] + "<input name=\""+values.split("|")[0]+"\" class=\"l-text\" type=\"hidden\" value=\"" + values.split("|")[0] + "\"></td>");
                            td.appendTo(tr);
                            rowid += values.split("|")[0];
                        });
                        var td1 = $("<td ><input disabled=\"disabled\" name=\"sku_price\" class=\"l-text\" type=\"text\" value=\"\"></td>");
                        td1.appendTo(tr);
                        var td2 = $("<td ><input disabled=\"disabled\" name=\"sku_discount_price\" class=\"l-text\" type=\"text\" value=\"\"></td>");
                        td2.appendTo(tr);
                        var td3 = $("<td ><input disabled=\"disabled\" name=\"sku_inventory\" class=\"l-text\" type=\"text\" value=\"\"></td>");
                        td3.appendTo(tr);

                        var isAppend = true;
                        tbody.find("tr").each(function(){
                            if(this.id==rowid){
                                isAppend = false;
                                return false;
                            }
                        });

                        if(isAppend){
                            $(tr).attr("id", rowid);
                            tr.appendTo(tbody);
                        }
                    });
                }
                //结束创建Table表
                arrayColumn.pop();//删除数组中最后一项
                //合并单元格
                $(table).mergeCell({
                    // 目前只有cols这么一个配置项, 用数组表示列的索引,从0开始
                    cols: arrayColumn
                });
            } else{
                //未全选中,清除表格
                document.getElementById('createTable').innerHTML="";
            }
        },//修改
        Update_Table: function (data) {
            step.hebingFunction();
            var SKUObj = $(".Father_Title");
            var arrayTile = new Array();//标题组数
            var arrayInfor = new Array();//盛放每组选中的CheckBox值的对象，数据结构id_value
            var arrayColumn = new Array();//指定列，用来合并哪些列
            var bCheck = true;//是否全选
            var columnIndex = 0;
            $.each(SKUObj, function (i, item){
                arrayColumn.push(columnIndex);
                columnIndex++;
                arrayTile.push(SKUObj.find("li").eq(i).html().replace("：", ""));
                var itemName = "Father_Item" + i;
                //选中的CHeckBox取值
                var order = new Array();
                $("." + itemName + " input[type=checkbox]:checked").each(function (){
                    order.push($(this).attr("id")+"|"+$(this).val());//格式:key_{proId}_{proValueId}|{proValue}
                });
                arrayInfor.push(order);
                if (order.join() == ""){
                    bCheck = false;
                }
                //var skuValue = SKUObj.find("li").eq(index).html();
            });
            //开始创建Table表
            if (bCheck == true) {
                var RowsCount = 0;
                //$("#createTable").html("");

                var table = $("#process");
                if(table.length>0){//如果Table存在，不再创建

                } else{//如果Table不存在，则创建一个Table
                    table = $("<table id=\"process\" border=\"1\" cellpadding=\"1\" cellspacing=\"0\" style=\"width:100%;padding:5px;\"></table>");
                    table.appendTo($("#createTable"));

                    var thead = $("<thead></thead>");
                    thead.appendTo(table);
                    var trHead = $("<tr></tr>");
                    trHead.appendTo(thead);
                    //创建表头
                    $.each(arrayTile, function (index, item) {
                        var td = $("<th>" + item + "</th>");
                        td.appendTo(trHead);
                    });
                    var itemColumHead = $("<th  style=\"width:70px;\">价格</th><th style=\"width:70px;\">折扣价</th><th style=\"width:70px;\">库存</th> ");
                    itemColumHead.appendTo(trHead);

                    var tbody = $("<tbody></tbody>");
                    tbody.appendTo(table);
                }

                var tbody = table.find("tbody");
                //生成组合
                var zuheData = step.doExchange(arrayInfor);
                if (zuheData.length > 0) {
                    //创建行
                    $.each(zuheData, function (index, item) {
                        var td_array = item.split(",");
                        var tr = $("<tr></tr>");

                        var rowid = "";
                        $.each(td_array, function (i, values) {
                            var td = $("<td>" + values.split("|")[1] + "<input name=\""+values.split("|")[0]+"\" class=\"l-text\" type=\"hidden\" value=\"" + values.split("|")[0] + "\"></td>");
                            td.appendTo(tr);
                            rowid += values.split("|")[0];
                        });
                        var td1 = $("<td ><input disabled=\"disabled\" name=\"sku_price\" class=\"l-text\" type=\"text\" value=\""+data.price+"\"></td>");
                        td1.appendTo(tr);
                        var td2 = $("<td ><input disabled=\"disabled\" name=\"sku_discount_price\" class=\"l-text\" type=\"text\" value=\""+data.salePrice+"\"></td>");
                        td2.appendTo(tr);
                        var td3 = $("<td ><input disabled=\"disabled\" name=\"sku_inventory\" class=\"l-text\" type=\"text\" value=\""+data.storeNum+"\"></td>");
                        td3.appendTo(tr);

                        var isAppend = true;
                        tbody.find("tr").each(function(){
                            if(this.id==rowid){
                                isAppend = false;
                                return false;
                            }
                        });

                        if(isAppend){
                            $(tr).attr("id", rowid);
                            tr.appendTo(tbody);
                        }
                    });
                }
                //结束创建Table表
                arrayColumn.pop();//删除数组中最后一项
                //合并单元格
                $(table).mergeCell({
                    // 目前只有cols这么一个配置项, 用数组表示列的索引,从0开始
                    cols: arrayColumn
                });
            } else{
                //未全选中,清除表格
                document.getElementById('createTable').innerHTML="";
            }
        },//合并行
        Delete_Row: function(zuheData){
            var rowIdArray = new Array();
            $.each(zuheData, function (index, item) {
                var td_array = item.split(",");

                var rowid = "";
                $.each(td_array, function (i, values) {
                    rowid += values.split("|")[0];
                });
                rowIdArray.push(rowid);
            });

            $("#process").find("tbody").find("tr").each(function(){
                //alert(this.id+","+$.inArray(this.id, rowIdArray))
                if($.inArray(this.id, rowIdArray)<0){
                    this.remove();
                }
            });


        },
        hebingFunction: function () {
            $.fn.mergeCell = function (options) {
                return this.each(function () {
                    var cols = options.cols;
                    for (var i = cols.length - 1; cols[i] != undefined; i--) {
                        mergeCell($(this), cols[i]);
                    }
                    dispose($(this));
                });
            };
            function mergeCell($table, colIndex) {
                $table.data('col-content', ''); // 存放单元格内容
                $table.data('col-rowspan', 1); // 存放计算的rowspan值 默认为1
                $table.data('col-td', $()); // 存放发现的第一个与前一行比较结果不同td(jQuery封装过的), 默认一个"空"的jquery对象
                $table.data('trNum', $('tbody tr', $table).length); // 要处理表格的总行数, 用于最后一行做特殊处理时进行判断之用
                // 进行"扫面"处理 关键是定位col-td, 和其对应的rowspan
                $('tbody tr', $table).each(function (index) {
                    // td:eq中的colIndex即列索引
                    var $td = $('td:eq(' + colIndex + ')', this);
                    // 取出单元格的当前内容
                    var currentContent = $td.html();
                    // 第一次时走此分支
                    if ($table.data('col-content') == '') {
                        $table.data('col-content', currentContent);
                        $table.data('col-td', $td);
                    } else {
                        // 上一行与当前行内容相同
                        if ($table.data('col-content') == currentContent) {
                            // 上一行与当前行内容相同则col-rowspan累加, 保存新值
                            var rowspan = $table.data('col-rowspan') + 1;
                            $table.data('col-rowspan', rowspan);
                            // 值得注意的是 如果用了$td.remove()就会对其他列的处理造成影响
                            $td.hide();
                            // 最后一行的情况比较特殊一点
                            // 比如最后2行 td中的内容是一样的, 那么到最后一行就应该把此时的col-td里保存的td设置rowspan
                            if (++index == $table.data('trNum'))
                                $table.data('col-td').attr('rowspan', $table.data('col-rowspan'));
                        } else { // 上一行与当前行内容不同
                            // col-rowspan默认为1, 如果统计出的col-rowspan没有变化, 不处理
                            if ($table.data('col-rowspan') != 1) {
                                $table.data('col-td').attr('rowspan', $table.data('col-rowspan'));
                            }
                            // 保存第一次出现不同内容的td, 和其内容, 重置col-rowspan
                            $table.data('col-td', $td);
                            $table.data('col-content', $td.html());
                            $table.data('col-rowspan', 1);
                        }
                    }
                });
            }
            // 同样是个private函数 清理内存之用
            function dispose($table) {
                $table.removeData();
            }
        },
        //组合数组
        doExchange: function (doubleArrays) {
            var len = doubleArrays.length;
            if (len >= 2) {
                var arr1 = doubleArrays[0];
                var arr2 = doubleArrays[1];
                var len1 = doubleArrays[0].length;
                var len2 = doubleArrays[1].length;
                var newlen = len1 * len2;
                var temp = new Array(newlen);
                var index = 0;
                for (var i = 0; i < len1; i++) {
                    for (var j = 0; j < len2; j++) {
                        temp[index] = arr1[i] + "," + arr2[j];
                        index++;
                    }
                }
                var newArray = new Array(len - 1);
                newArray[0] = temp;
                if (len > 2) {
                    var _count = 1;
                    for (var i = 2; i < len; i++) {
                        newArray[_count] = doubleArrays[i];
                        _count++;
                    }
                }
                //console.log(newArray);
                return step.doExchange(newArray);
            }
            else {
                return doubleArrays[0];
            }
        }
    }
    return step;
})(jQuery);