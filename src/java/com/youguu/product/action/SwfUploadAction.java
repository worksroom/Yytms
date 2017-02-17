package com.youguu.product.action;

import com.alibaba.fastjson.JSONObject;
import com.youguu.core.util.ParamUtil;
import com.youguu.util.ResponseUtil;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;
import org.springframework.stereotype.Controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Iterator;
import java.util.List;

/**
 * Created by leo on 2017/2/17.
 */
@Controller("/manager/swfupload")
public class SwfUploadAction extends DispatchAction {

    private static final int UPLOAD_SUCCSSS=0;    // "上传文件成功！"
    private static final int UPLOAD_FAILURE=1;    // "上传文件失败！"
    private static final int UPLOAD_TYPE_ERROR=2; // "上传文件类型错误！"
    private static final int UPLOAD_OVERSIZE=3;   // "上传文件过大！"
    private static final int UPLOAD_ZEROSIZE=4;   // "上传文件为空！"
    private static final int UPLOAD_NOTFOUND=5;   // "上传文件路径错误！"

    public ActionForward upload(ActionMapping mapping,
                              ActionForm form, HttpServletRequest request,
                              HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        JSONObject result = new JSONObject();

        String rootPath = ParamUtil.CheckParam(request.getParameter("rootPath"), "");
        String param = ParamUtil.CheckParam(request.getParameter("param"), "");


        if (rootPath == null) {
            rootPath = "";
        }
        rootPath = rootPath.trim();
        if (rootPath.equals("")) {
            rootPath = request.getSession().getServletContext().getRealPath("");
        }

        //上传操作
        FileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);
        upload.setHeaderEncoding("UTF-8");
        try {
            List items = upload.parseRequest(request);
            if (null != items) {
                Iterator itr = items.iterator();
                while (itr.hasNext()) {
                    FileItem item = (FileItem) itr.next();
                    if (item.isFormField()) {
                        continue;
                    } else {
                        //以当前精确到秒的日期为上传的文件的文件名
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddkkmmss");
                        String path = "/images";
                        File savedFile = new File(rootPath + path, item.getName());
                        item.write(savedFile);

                        result.put("status", this.UPLOAD_SUCCSSS );
                        result.put("message", path + "/" + item.getName());
                    }
                }
            }
        } catch (Exception e) {
            result.put("status", this.UPLOAD_FAILURE );
            result.put("message", "上传文件失败");
        }

        ResponseUtil.println(response, result);
        return null;
    }
}
