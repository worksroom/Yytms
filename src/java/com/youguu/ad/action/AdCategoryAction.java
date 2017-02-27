package com.youguu.ad.action;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.youguu.core.util.PageHolder;
import com.youguu.core.util.ParamUtil;
import com.youguu.util.LigerUiToGrid;
import com.youguu.util.ResponseUtil;
import com.yyt.print.ad.pojo.AdCategory;
import com.yyt.print.rpc.client.YytRpcClientFactory;
import com.yyt.print.rpc.client.ad.IAdRpcService;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;
import org.springframework.stereotype.Controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.ParseException;
import java.util.Date;

/**
 * Created by leo on 2017/2/27.
 */
@Controller("/manager/adCategory")
public class AdCategoryAction extends DispatchAction {
    IAdRpcService adRpcService = YytRpcClientFactory.getAdRpcService();


    public ActionForward adCategoryList(ActionMapping mapping,
                                       ActionForm form, HttpServletRequest request,
                                       HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int page = ParamUtil.CheckParam(request.getParameter("page"), 1);
        int pagesize = ParamUtil.CheckParam(request.getParameter("pagesize"), 20);

        String name = ParamUtil.CheckParam(request.getParameter("name"), "");
        PageHolder<AdCategory> pageHolder = adRpcService.queryAdCategoryByPage(name, page, pagesize);
        String gridJson = LigerUiToGrid.toGridJSON(pageHolder, new String[]{"id", "name", "createTime"}, null);

        ResponseUtil.println(response, gridJson);
        return null;
    }

    public ActionForward saveAdCategory(ActionMapping mapping,
                                       ActionForm form, HttpServletRequest request,
                                       HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String name = ParamUtil.CheckParam(request.getParameter("name"), "");

        AdCategory category = new AdCategory();
        category.setName(name);
        category.setCreateTime(new Date());

        int dbFlag = adRpcService.saveAdCategory(category);
        JSONObject result = new JSONObject();
        if(dbFlag>0){
            result.put("success", true);
            result.put("message", "添加成功");
        } else{
            result.put("success", false);
            result.put("message", "添加失败");
        }
        ResponseUtil.println(response, result);
        return null;
    }

    public ActionForward getAdCategory(ActionMapping mapping,
                                      ActionForm form, HttpServletRequest request,
                                      HttpServletResponse response) throws ParseException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int id = ParamUtil.CheckParam(request.getParameter("id"), 0);

        String responseText = null;
        AdCategory category = adRpcService.getAdCategory(id);
        if(category!=null){
            responseText = JSONObject.toJSONString(category);
        } else {
            JSONObject result = new JSONObject();
            result.put("success", false);
            result.put("message", "未检索到该条数据");
            responseText = result.toJSONString();

        }
        ResponseUtil.println(response, responseText);
        return null;
    }

    public ActionForward updateAdCategory(ActionMapping mapping,
                                         ActionForm form, HttpServletRequest request,
                                         HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int id = ParamUtil.CheckParam(request.getParameter("id"), 0);
        String name = ParamUtil.CheckParam(request.getParameter("name"), "");

        AdCategory category = adRpcService.getAdCategory(id);
        category.setName(name);

        int dbFlag = adRpcService.updateAdCategory(category);

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

    public ActionForward deleteAdCategory(ActionMapping mapping,
                                         ActionForm form, HttpServletRequest request,
                                         HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String ids = ParamUtil.CheckParam(request.getParameter("ids"), "");

        JSONObject result = new JSONObject();
        try{
            String[] idArray=null;
            if(ids!=null && !"".equals(ids.trim())){
                idArray = ids.split(",");
            }
            if(idArray!=null){
                for(String id : idArray){
                    adRpcService.deleteAdCategory(Integer.parseInt(id));
                }
            }
            result.put("success", true);
            result.put("message", "删除成功");
        } catch (Exception e){
            result.put("success", false);
            result.put("message", "删除失败");
        }

        ResponseUtil.println(response, result);
        return null;
    }


    public ActionForward loadComboBox(ActionMapping mapping,
                                        ActionForm form, HttpServletRequest request,
                                        HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        PageHolder<AdCategory> pageHolder = adRpcService.queryAdCategoryByPage("", 1, 1000);

        JSONArray array = new JSONArray();
        if(pageHolder!=null && !pageHolder.isEmpty()){
            for (AdCategory category: pageHolder){
                JSONObject object = new JSONObject();
                object.put("id", category.getId());
                object.put("name", category.getName());
                array.add(object);
            }
        }

        ResponseUtil.println(response, array);
        return null;
    }
}
