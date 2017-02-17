package com.youguu.demo.action;

import org.apache.struts.action.ActionForm;
import org.apache.struts.upload.FormFile;

/**
 * Created by leo on 2017/2/13.
 */
public class FileUploadForm extends ActionForm {
    private FormFile avatar_file;
    private String avatar_data;

    public FormFile getAvatar_file() {
        return avatar_file;
    }

    public void setAvatar_file(FormFile avatar_file) {
        this.avatar_file = avatar_file;
    }

    public String getAvatar_data() {
        return avatar_data;
    }

    public void setAvatar_data(String avatar_data) {
        this.avatar_data = avatar_data;
    }
}
