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
    <title>买家管理</title>

    <link rel="stylesheet" type="text/css" href="resources/webuploader/webuploader.css">
    <script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
    <script type="text/javascript" src="resources/webuploader/webuploader.js"></script>

    <script type="text/javascript">
        $(function () {

            var $list = $('#fileList');
            var ratio = window.devicePixelRatio || 1;
            var thumbnailWidth = 100 * ratio;
            var thumbnailHeight = 100 * ratio;

            // 初始化Web Uploader
            var uploader = WebUploader.create({

                // 选完文件后，是否自动上传。
                auto: true,

                // swf文件路径
                swf: 'resources/webuploader/Uploader.swf',

                // 文件接收服务端。
                server: 'manager/demo/cropper.do?method=webuploader',
                method:"POST",
                formData: { "method": "webuploader"},
                // 选择文件的按钮。可选。
                // 内部根据当前运行是创建，可能是input元素，也可能是flash.
                pick:{
                    id:'#filePicker',
                    multiple: false
                } ,

                // 只允许选择图片文件。
                accept: {
                    title: 'Images',
                    extensions: 'gif,jpg,jpeg,bmp,png',
                    mimeTypes: 'image/*'
                }
            });

            //当某个文件上传到服务端响应后，会派送此事件来询问服务端响应是否有效。
//            uploader.on("uploadAccept",function(object,ret){
//                //服务器响应了
//                var data =JSON.parse(ret._raw);
//                if(data.resultCode != "1" && data.resultCode != "3"){
//                    if(data.resultCode == "9"){
//                        uploader.reset();
//                        alert("error");
//                        return false;
//                    }
//                }else{
//                    uploader.reset();
//                    alert("error");
//                    return false;
//                }
//            });

            // 当有文件添加进来的时候
            uploader.on('fileQueued', function (file) {
                var $li = $(
                                '<div id="' + file.id + '" class="file-item thumbnail">' +
                                '<img>' +
                                '<div class="info">' + file.name + '</div>' +
                                '</div>'
                        ),
                        $img = $li.find('img');


                // $list为容器jQuery实例
                $list.append($li);

                // 创建缩略图
                // 如果为非图片文件，可以不用调用此方法。
                // thumbnailWidth x thumbnailHeight 为 100 x 100
                uploader.makeThumb(file, function (error, src) {
                    if (error) {
                        $img.replaceWith('<span>不能预览</span>');
                        return;
                    }

                    $img.attr('src', src);
                }, thumbnailWidth, thumbnailHeight);
            });

            // 文件上传过程中创建进度条实时显示。
            uploader.on('uploadProgress', function (file, percentage) {
                var $li = $('#' + file.id), $percent = $li.find('.progress span');

                // 避免重复创建
                if (!$percent.length) {
                    $percent = $('<p class="progress"><span></span></p>').appendTo($li).find('span');
                }

                $percent.css('width', percentage * 100 + '%');
            });

            // 文件上传成功，给item添加成功class, 用样式标记上传成功。
            uploader.on('uploadSuccess', function (file) {
                $('#' + file.id).addClass('upload-state-done');
            });

            // 文件上传失败，显示上传出错。
            uploader.on('uploadError', function (file) {
                var $li = $('#' + file.id), $error = $li.find('div.error');

                // 避免重复创建
                if (!$error.length) {
                    $error = $('<div class="error"></div>').appendTo($li);
                }

                $error.text('上传失败');
            });

            // 完成上传完了，成功或者失败，先删除进度条。
            uploader.on('uploadComplete', function (file) {
                $('#' + file.id).find('.progress').remove();
            });
        });

    </script>
</head>
<body>
<div id="uploader-demo">
    <div id="fileList" class="uploader-list"></div>
    <div id="filePicker">选择图片</div>
</div>
</body>
</html>
