function fileQueueError(file, errorCode, message) {
    var errorFile = {
        file: file,
        code: errorCode,
        error: ''
    };
    switch (errorCode) {
        case -110:
            errorFile.error = file.name + "(" + formatUnits(file.size) + ")" + ' 文件大小超出限制！';
            break;
        case -100:
            errorFile.error = file.name + ' 文件类型受限！';
            break;
        case -120:
            errorFile.error = '文件为空文件！';
            break;
        default:
            errorFile.error = '加载入队列出错！';
            break;
    }
    alert(errorFile.error);
}
function uploadError(file, errorCode, message) {
    try {

        if (errorCode === SWFUpload.UPLOAD_ERROR.FILE_CANCELLED) {
            // Don't show cancelled error boxes
            return;
        }
        switch (errorCode) {
            case SWFUpload.UPLOAD_ERROR.HTTP_ERROR:
                //progress.setStatus("Upload Error: " + message);
                alert("Upload Error:" + message);
                this.debug("Error Code: HTTP Error, File name: " + file.name + ", Message: " + message);
                break;
            case SWFUpload.QUEUE_ERROR.FILE_EXCEEDS_SIZE_LIMIT:
                alert("文件超出限制大小！");
                this.debug("Error Code: SIZE LIMIT, File name: " + file.name + ", Message: " + message);
                break;
            case SWFUpload.UPLOAD_ERROR.UPLOAD_FAILED:
                //progress.setStatus("Upload Failed.");
                alert("上传失败!");
                this.debug("Error Code: Upload Failed, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
                break;
            case SWFUpload.UPLOAD_ERROR.IO_ERROR:
                //progress.setStatus("Server (IO) Error");
                alert("服务器IO错误!");
                this.debug("Error Code: IO Error, File name: " + file.name + ", Message: " + message);
                break;
            case SWFUpload.UPLOAD_ERROR.SECURITY_ERROR:
                //progress.setStatus("Security Error");
                alert("服务器安装错误!");
                this.debug("Error Code: Security Error, File name: " + file.name + ", Message: " + message);
                break;
            case SWFUpload.UPLOAD_ERROR.UPLOAD_LIMIT_EXCEEDED:
                //progress.setStatus("Upload limit exceeded.");
                alert("上传被限制执行!");
                this.debug("Error Code: Upload Limit Exceeded, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
                break;
            case SWFUpload.UPLOAD_ERROR.FILE_VALIDATION_FAILED:
                //progress.setStatus("Failed Validation.  Upload skipped.");
                alert("文件无效,跳过该文件!");
                this.debug("Error Code: File Validation Failed, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
                break;
            case SWFUpload.UPLOAD_ERROR.FILE_CANCELLED:
                //progress.setStatus("Cancelled");
                alert("上传被终止!");
                //progress.setCancelled();
                break;
            case SWFUpload.UPLOAD_ERROR.UPLOAD_STOPPED:
                //progress.setStatus("Stopped");
                alert("上传被停止!");
                break;
            default:
                //progress.setStatus("Unhandled Error: " + errorCode);
                alert("未知异常,ErrorCode:" + errorCode);
                this.debug("Error Code: " + errorCode + ", File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
                break;
        }
    } catch (ex) {
    }
}


