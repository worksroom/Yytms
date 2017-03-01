var expressP, expressC, expressD, areaCont, categoryId;
var arrow = " <font>&gt;</font> ";

/*初始化一级目录*/
function intProvince() {
	areaCont = "";
	$.ajax({
		cache: true,
		type: "POST",
		url:"manager/product.do?method=categoryComboBox",
		async: false,
		error: function(data) {
			$.ligerDialog.tip({
				title: '提示信息',
				content: data.message
			});
		},
		success: function(data) {
			if(data.status=="0000" && data.result.length>0){
				$(data.result).each(function(){
					areaCont += '<li id="'+this.id+'" onClick="selectP(' + this.id + ',\''+this.name+'\');"><a href="javascript:void(0)">' + this.name + '</a></li>';
				});
			}
		}
	});

	$("#sort1").html(areaCont);
}
intProvince();

/*选择一级目录*/
function selectP(id, name) {
	areaCont = "";
	categoryId = id;
	$.ajax({
		cache: true,
		type: "POST",
		url:"manager/product.do?method=categoryComboBox",
		data:{"id": id},
		async: false,
		error: function(data) {
			$.ligerDialog.tip({
				title: '提示信息',
				content: data.message
			});
		},
		success: function(data) {
			if(data.status=="0000" && data.result.length>0){
				$(data.result).each(function(){
					areaCont += '<li id="'+this.id+'" onClick="selectC(' + this.id + ',\''+this.name+'\');"><a href="javascript:void(0)">' + this.name + '</a></li>';
				});
				$("#sort2").html(areaCont).show();
			} else {
				$("#sort2").html(areaCont).hide();
			}
		}
	});

	$("#sort3").hide();
	$("#"+id).addClass("active").siblings("li").removeClass("active");
	expressP = name;
	$("#selectedSort").html(expressP);
	$("#releaseBtn").removeAttr("disabled");
}

/*选择二级目录*/
function selectC(id, name) {
	areaCont = "";
	expressC = "";
	categoryId = id;

	$.ajax({
		cache: true,
		type: "POST",
		url:"manager/product.do?method=categoryComboBox",
		data:{"id": id},
		async: false,
		error: function(data) {
			$.ligerDialog.tip({
				title: '提示信息',
				content: data.message
			});
		},
		success: function(data) {
			if(data.status=="0000" && data.result.length>0){
				$(data.result).each(function(){
					areaCont += '<li id="'+this.id+'" onClick="selectD(' + this.id + ',\''+this.name+'\');"><a href="javascript:void(0)">' + this.name + '</a></li>';
				});
				$("#sort3").html(areaCont).show();
			} else {
				$("#sort3").html(areaCont).hide();
			}

		}
	});

	$("#"+id).addClass("active").siblings("li").removeClass("active");
	expressC = expressP + arrow + name;
	$("#selectedSort").html(expressC);
}

/*选择三级目录*/
function selectD(id, name) {
	categoryId = id;
	$("#"+id).addClass("active").siblings("li").removeClass("active");
	expressD = expressC + arrow + name;
	$("#selectedSort").html(expressD);
}

/*点击下一步*/
$("#releaseBtn").click(function() {
	var releaseS = $(this).prop("disabled");
	if (releaseS == false) {//未被禁用
		window.location.href = "manager/product/addPublishProduct.jsp?categoryId="+categoryId;
	}
});
