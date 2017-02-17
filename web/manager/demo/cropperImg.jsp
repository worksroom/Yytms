<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <base href="<%=basePath%>">
    <title>支持上传头像Form</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <link rel="stylesheet" href="resources/cropper/cropper.min.css" type="text/css">
    <link rel="stylesheet" href="resources/cropper/main.css" type="text/css"/>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" type="text/css">

</head>
<body>

<div class="container" id="crop-avatar">

    <!-- Current avatar -->
    <div class="avatar-view" title="Change the avatar">
        <input name="logo", id="logo", type="text"/>
        <img src="resources/images/picture.jpg" alt="Avatar">
    </div>
    <!-- Cropping modal -->
    <div class="modal fade" id="avatar-modal" aria-hidden="true" aria-labelledby="avatar-modal-label" role="dialog"
         tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <form class="avatar-form" action="manager/demo/cropper.do?method=upload" enctype="multipart/form-data" method="post">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title" id="avatar-modal-label">Change Avatar</h4>
                    </div>
                    <div class="modal-body">
                        <div class="avatar-body">

                            <!-- Upload image and data -->
                            <div class="avatar-upload">
                                <input type="hidden" class="avatar-src" name="avatar_src">
                                <input type="hidden" class="avatar-data" name="avatar_data">
                                <label for="avatarInput">Local upload</label>
                                <input type="file" class="avatar-input" id="avatarInput" name="avatar_file">
                            </div>

                            <!-- Crop and preview -->
                            <div class="row">
                                <div class="col-md-9">
                                    <div class="avatar-wrapper"></div>
                                </div>
                                <div class="col-md-3">
                                    <div class="avatar-preview preview-lg"></div>
                                    <div class="avatar-preview preview-md"></div>
                                    <div class="avatar-preview preview-sm"></div>
                                </div>
                            </div>

                            <div class="row avatar-btns">
                                <div class="col-md-9">
                                    <div class="btn-group">
                                        <button type="button" class="btn btn-primary" data-method="rotate"
                                                data-option="-90" title="Rotate -90 degrees">Rotate Left
                                        </button>
                                        <button type="button" class="btn btn-primary" data-method="rotate"
                                                data-option="-15">-15deg
                                        </button>
                                        <button type="button" class="btn btn-primary" data-method="rotate"
                                                data-option="-30">-30deg
                                        </button>
                                        <button type="button" class="btn btn-primary" data-method="rotate"
                                                data-option="-45">-45deg
                                        </button>
                                    </div>
                                    <div class="btn-group">
                                        <button type="button" class="btn btn-primary" data-method="rotate"
                                                data-option="90" title="Rotate 90 degrees">Rotate Right
                                        </button>
                                        <button type="button" class="btn btn-primary" data-method="rotate"
                                                data-option="15">15deg
                                        </button>
                                        <button type="button" class="btn btn-primary" data-method="rotate"
                                                data-option="30">30deg
                                        </button>
                                        <button type="button" class="btn btn-primary" data-method="rotate"
                                                data-option="45">45deg
                                        </button>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <button type="submit" class="btn btn-primary btn-block avatar-save">Done</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                      <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <!-- /.modal -->

    <!-- Loading state -->
    <div class="loading" aria-label="Loading" role="img" tabindex="-1"></div>
</div>

<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script type="text/javascript" src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script type="text/javascript" src="resources/cropper/cropper.min.js"></script>
<script type="text/javascript" src="resources/cropper/main.js"></script>
</body>
</html>
