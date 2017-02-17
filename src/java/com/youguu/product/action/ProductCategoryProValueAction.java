package com.youguu.product.action;

import com.alibaba.fastjson.JSONObject;
import com.youguu.core.util.PageHolder;
import com.youguu.core.util.ParamUtil;
import com.youguu.demo.action.ImageCut;
import com.youguu.util.LigerUiToGrid;
import com.youguu.util.ResponseUtil;
import com.yyt.print.product.pojo.MallProductCategoryPro;
import com.yyt.print.product.pojo.MallProductCategoryProValue;
import com.yyt.print.rpc.client.YytRpcClientFactory;
import com.yyt.print.rpc.client.product.IProductRpcService;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;
import org.springframework.stereotype.Controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Random;

/**
 * Created by leo on 2017/2/8.
 */
@Controller("/manager/productCategoryProValue")
public class ProductCategoryProValueAction extends DispatchAction {

    IProductRpcService productRpcService = YytRpcClientFactory.getProductRpcService();

    /**
     * 根据商品类别查询属性值列表
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     */
    public ActionForward proValueList(ActionMapping mapping,
                                 ActionForm form, HttpServletRequest request,
                                 HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int proId = ParamUtil.CheckParam(request.getParameter("proId"), 0);

        List<MallProductCategoryProValue> list = productRpcService.findProValueByProId(proId);
        PageHolder<MallProductCategoryProValue> pageHolder = new PageHolder<>();
        if(list!=null && !list.isEmpty()){
            for(MallProductCategoryProValue pro : list){
                pageHolder.add(pro);
            }
        }

        String gridJson = LigerUiToGrid.toGridJSON(pageHolder, new String[]{"id", "name", "classProId", "classId", "pic", "used", "rank", "createTime", "updateTime"}, null);

        ResponseUtil.println(response, gridJson);
        return null;
    }

    public ActionForward saveOrUpdateProValue(ActionMapping mapping,
                                         ActionForm form, HttpServletRequest request,
                                         HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String girdJson = ParamUtil.CheckParam(request.getParameter("girdJson"), "");

        List<MallProductCategoryProValue> list = JSONObject.parseArray(girdJson, MallProductCategoryProValue.class);

        int dbFlag = 0;
        if(list!=null && !list.isEmpty()){
            for(MallProductCategoryProValue proValue : list){
                if(proValue.getId()>0){
                    //修改
                    dbFlag = productRpcService.modifyProValue(proValue);
                } else {
                    //新增
                    List<MallProductCategoryProValue> addList = new ArrayList<>();
                    addList.add(proValue);
                    dbFlag = productRpcService.addProValue(addList);
                }
            }
        }

        JSONObject result = new JSONObject();
        if(dbFlag>0){
            result.put("success", true);
            result.put("message", "修改成功");
        } else{
            result.put("success", false);
            result.put("message", "修改失败");
        }

        ResponseUtil.println(response, result);
        return null;
    }

    /**
     * 批量删除属性值
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     */
    public ActionForward delProValue(ActionMapping mapping,
                                              ActionForm form, HttpServletRequest request,
                                              HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String ids = ParamUtil.CheckParam(request.getParameter("ids"), "");


        JSONObject result = new JSONObject();

        if(ids!=null && !"".equals(ids.trim())){
            String[] idArray = ids.split(",");
            List<Integer> idList = new ArrayList<>();
            for(String id : idArray){
                idList.add(Integer.parseInt(id));
            }

            productRpcService.delProValues(idList);
            result.put("success", true);
            result.put("message", "删除成功");
        } else {
            result.put("success", false);
            result.put("message", "请先选择删除的记录");
        }

        ResponseUtil.println(response, result.toJSONString());
        return null;
    }


    public ActionForward cutImg(ActionMapping mapping,
                                     ActionForm form, HttpServletRequest request,
                                     HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String fileName = ParamUtil.CheckParam(request.getParameter("txtFileName"), "");
        int x1 = ParamUtil.CheckParam(request.getParameter("x1"), 0);
        int y1 = ParamUtil.CheckParam(request.getParameter("y1"), 0);
        int x2 = ParamUtil.CheckParam(request.getParameter("x2"), 0);
        int y2 = ParamUtil.CheckParam(request.getParameter("y2"), 0);
        int w = ParamUtil.CheckParam(request.getParameter("w"), 0);
        int h = ParamUtil.CheckParam(request.getParameter("h"), 0);

        JSONObject result = new JSONObject();

        try{
            String path = request.getSession().getServletContext().getRealPath("/") + "images/";
            String targetFileName = new Date().getTime() + "" + new Random().nextInt(10000) + "_" + fileName.substring(fileName.lastIndexOf('.'));
            File targetFile = new File(path, targetFileName);

            File file = new File(path+"/"+fileName);
            InputStream is = new FileInputStream(file);
            ImageCut.cut(is, targetFile, x1, y1, w, h);
            is.close();

            result.put("success", true);
            result.put("message", "保存成功");
            result.put("url", "images/"+targetFileName);
        } catch (Exception e){
            result.put("success", false);
            result.put("message", "保存失败");
        }

        ResponseUtil.println(response, result.toJSONString());
        return null;
    }

}
