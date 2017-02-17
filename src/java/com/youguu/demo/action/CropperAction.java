package com.youguu.demo.action;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.youguu.util.ResponseUtil;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;
import org.apache.struts.upload.FormFile;
import org.springframework.stereotype.Controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.InputStream;
import java.util.Date;
import java.util.Random;

/**
 * Created by leo on 2017/2/13.
 */
@Controller("/manager/demo/cropper")
public class CropperAction extends DispatchAction {

    public static final String HTTP_URL = "http://localhost:8888/lakeside/";

    //    MultipartFile avatar_file,
//    String avatar_data
    public ActionForward upload(ActionMapping mapping,
                                ActionForm form,
                                HttpServletRequest request,
                                HttpServletResponse response
    ) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        FileUploadForm fileUploadForm = (FileUploadForm) form;

        FormFile avatar_file = fileUploadForm.getAvatar_file();

        System.out.println(avatar_file.getFileName());
        String avatar_data = request.getParameter("avatar_data");
        System.out.println(avatar_data);

        // 文件保存目录路径
        String path = request.getSession().getServletContext().getRealPath("/") + "images/";

        String name = avatar_file.getFileName();
        //判断文件的MIMEtype
        String type = avatar_file.getContentType();
        if (type == null || !type.toLowerCase().startsWith("image/")) {
            Result result = new Result(false, "不支持的文件类型，仅支持图片！");
            ResponseUtil.println(response, JSON.toJSONString(result));
            return null;
        }

        System.out.println("file type:" + type);
        String fileName = new Date().getTime() + "" + new Random().nextInt(10000) + "_" + name.substring(name.lastIndexOf('.'));
        System.out.println("文件路径：" + path + ":" + fileName);

        JSONObject joData = (JSONObject) JSONObject.parse(avatar_data);
        // 用户经过剪辑后的图片的大小
        float x = joData.getFloatValue("x");
        float y = joData.getFloatValue("y");
        float w = joData.getFloatValue("width");
        float h = joData.getFloatValue("height");

        //开始上传
        File targetFile = new File(path, fileName);
        //保存
        try {
            if (!targetFile.exists()) {
                targetFile.mkdirs();
                InputStream is = avatar_file.getInputStream();
                ImageCut.cut(is, targetFile, (int) x, (int) y, (int) w, (int) h);
                is.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
            Result result = new Result(false, "上传失败，出现异常：" + e.getMessage());
            ResponseUtil.println(response, JSON.toJSONString(result));
            return null;
        }
//        Result result = new Result(true, "上传成功!", request.getSession().getServletContext().getContextPath() + "/images/" + fileName);
        JSONObject object = new JSONObject();
        object.put("state", 200);
        object.put("result", request.getSession().getServletContext().getContextPath() + "/images/" + fileName);
        object.put("message", "上传成功!");

        ResponseUtil.println(response, object);
        return null;
    }


    public ActionForward webuploader(ActionMapping mapping,
                                     ActionForm form,
                                     HttpServletRequest request,
                                     HttpServletResponse response) {
        System.out.println("dddddddddddddddddddd");
        return null;
    }
}
