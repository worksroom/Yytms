<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.youguu.core.util.ParamUtil" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    int id = ParamUtil.CheckParam(request.getParameter("id"), 0);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <base href="<%=basePath%>">
    <title>货品审核</title>
    <link rel="stylesheet" href="resources/jquery/imgareaselect-default.css" type="text/css">

    <script src="resources/jquery/jquery.min.js" type="text/javascript"></script>
    <script src="resources/jquery/jquery.imgareaselect.pack.js" type="text/javascript"></script>
    <script src="resources/jquery/jquery.form.js" type="text/javascript"></script>

    <script src="resources/swf/swfupload.js" type="text/javascript"></script>
    <script src="resources/swf/handlers_xhd.js" type="text/javascript"></script>

    <script src="resources/js/json2.js" type="text/javascript"></script>
    <script type="text/javascript">
        function preview(img, selection) {
            if (!selection.width || !selection.height)
                return;

            var scaleX = 120 / selection.width;
            var scaleY = 120 / selection.height;

            $('#preview1 img').css({
                width: Math.round(scaleX * $("#photo").width()),
                height: Math.round(scaleY * $("#photo").height()),
                marginLeft: -Math.round(scaleX * selection.x1),
                marginTop: -Math.round(scaleY * selection.y1)
            });

            $('#x1').val(selection.x1);
            $('#y1').val(selection.y1);
            $('#x2').val(selection.x2);
            $('#y2').val(selection.y2);
            $('#w').val(selection.width);
            $('#h').val(selection.height);
        }

        var api;
        $(function () {
            var swfu;
            var settings = {
                post_params: {
                    "ASPSESSID": "fvrwlqafriulrrxawydlzfvv",
                    "AUTHID": "408C18303690A9B1DB7D0854F5CBE6F8F0F28A91369387248FDF42929701997FBCB606D89F59E83F00D102A78CA8DDDF801049FCC68464464CF843FE8B380A84C71E879FE1AB930F0DA92AA8088DAE17E4F4F0C68BD68975CBF1B30BD990819D5FC89E8B4AFBADB6E5511A2B870FC1A6C2E2E82D603295B5010E05664CBC3423FA0310A6D0D1028AC6D65B64C00AECFDE822A0C0A480D674F046D02B02578E16"
                },
                flash_url: "resources/swf/swfupload.swf",
                upload_url: "<%=basePath%>/manager/swfupload.do?method=upload",
                file_size_limit: "10 MB",
                file_types: "*.jpg;*.gif;*.png;*.bmp",
                file_types_description: "图片",
                file_upload_limit: 0,
                file_queue_limit: 1,

                debug: false,

                // Event handler settings
                file_dialog_start_handler: function () {
                },
                file_queued_handler: function (file) {
                    var txtFileName = document.getElementById("txtFileName");
                    txtFileName.value = file.name;
                },
                file_dialog_complete_handler: function () {
                    this.startUpload();
                },
                file_queue_error_handler: fileQueueError,

                //upload_start_handler : uploadStart,	// I could do some client/JavaScript validation here, but I don't need to.
                upload_error_handler: uploadError,
                upload_success_handler: uploadSuccess,

                // Button Settings
                button_image_url: "../Images/fancybox/img/button_green.png",
                button_placeholder_id: "spanButtonPlaceholder",
                button_text: '<span class="theFont">上传头像</span>',
                button_text_style: ".theFont { font-size: 12;font-weight:bold;text-align:center;line-height:25px; }",

                button_width: 70,
                button_height: 25,


                custom_settings: {},

                // Debug settings
                debug: false
            };

            swfu = new SWFUpload(settings);
        });


        function uploadSuccess(file, serverData) {
            $("#photo").attr("src", "<%=basePath%>" + JSON.parse(serverData).message);
            $('#preview1 img').attr("src", "<%=basePath%>" + JSON.parse(serverData).message);

            api = $('#photo').imgAreaSelect({
                instance: true,
                aspectRatio: '1:1',
                handles: true,
                fadeSpeed: 0,
                onSelectChange: preview,
                show: true,
                x1: 50, y1: 50, x2: 170, y2: 170
            });
            preview($("#photo"), {"x1": 50, "y1": 50, "x2": 170, "y2": 170, "width": 120, "height": 120});
        }

        function submitForm() {
            var src = $('#preview1 img').attr("src");
            if (src == '../images/noheadimage.jpg') {
                alert("请先上传图片");
                return;
            }
            else if ($("#x1").val() == "-" || $("#y1").val() == "-" || $("#x2").val() == "-" || $("#y2").val() == "-" || $("#w").val() == "-" || $("#h").val() == "-") {
                alert("请先选择头像");
                return;
            }
            else {
                return $("form :input").fieldSerialize();
            }
        }


    </script>
    <style type="text/css">
        fieldset {
            padding: 8px;
        }

        legend {
            font-size: 12px;
            margin-left: 15px;
        }

        body {
            font-size: 12px;
        }
    </style>

</head>
<body>
<form id="form1">
    <div class="container demo">
        <fieldset>
            <legend>原图</legend>
            <div style="float: left; width: 500px;">


                <div class="frame" style="margin: 0 0.3em; width: 485px; height: 325px; overflow: auto; z-index: 100">
                    <img id="photo" src="../images/noheadimage.jpg" height="300"/>
                </div>


                <div style="line-height: 21px;">
                    <input type="hidden" id="txtFileName" name="txtFileName"/>
                    <span id="spanButtonPlaceholder"></span>
                </div>


            </div>

            <div style="float: left; width: 200px;">

                <div class="frame" style="margin: 0 1em; width: 120px; height: 120px;">
                    <div id="preview1" style="width: 120px; height: 120px; overflow: hidden;">
                        <img src="../images/noheadimage.jpg" style="width: 120px; height: 120px;"/>
                    </div>
                </div>

                <input type="hidden" id="id" name="id" value="<%=id %>"/>
                <input type="hidden" id="x1" name="x1" value="-"/>
                <input type="hidden" id="y1" name="y1" value="-"/>
                <input type="hidden" id="x2" name="x2" value="-"/>
                <input type="hidden" id="y2" name="y2" value="-"/>
                <input type="hidden" id="w" name="w" value="-"/>
                <input type="hidden" id="h" name="h" value="-"/>

                <div style="line-height: 30px;">

                    <br/>
                    操作步骤：<br/>
                    1、点击上传头像按钮。<br/>
                    2、拖动选择框至合适位置，并选择合适大小，右边会有预览。<br/>
                    3、点击保存。

                </div>
            </div>
        </fieldset>
    </div>
</form>

</body>
</html>
