package com.youguu.info.action;

import com.alibaba.fastjson.JSONObject;
import com.youguu.core.util.PageHolder;
import com.youguu.core.util.ParamUtil;
import com.youguu.util.LigerUiToGrid;
import com.youguu.util.ResponseUtil;
import com.yyt.print.ad.pojo.Ad;
import com.yyt.print.info.pojo.InfoContent;
import com.yyt.print.info.pojo.InfoVender;
import com.yyt.print.info.query.InfoQuery;
import com.yyt.print.rpc.client.YytRpcClientFactory;
import com.yyt.print.rpc.client.info.IInfoRpcService;
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
 * Created by leo on 2017/3/3.
 */
@Controller("/manager/info")
public class InfoAction extends DispatchAction {

    IInfoRpcService infoRpcService = YytRpcClientFactory.getInfoRpcService();

    /**
     * 厂商供应资讯列表
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     */
    public ActionForward supplyList(ActionMapping mapping,
                                   ActionForm form, HttpServletRequest request,
                                   HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int page = ParamUtil.CheckParam(request.getParameter("page"), 1);
        int pagesize = ParamUtil.CheckParam(request.getParameter("pagesize"), 20);

        int userId = ParamUtil.CheckParam(request.getParameter("userId"), -1);

        InfoQuery query = new InfoQuery();
        query.setPageIndex(page);
        query.setPageSize(pagesize);
        query.setUserId(userId);
        query.setType(2);

        PageHolder<InfoContent> pageHolder = infoRpcService.queryInfoContentByPage(query);
        String gridJson = LigerUiToGrid.toGridJSON(pageHolder, new String[]{"id", "userId", "title", "type", "weight", "des", "photo", "content", "updateTime", "createTime"}, null);

        ResponseUtil.println(response, gridJson);
        return null;
    }


    /**
     * 客户需求资讯列表
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     */
    public ActionForward demandList(ActionMapping mapping,
                                    ActionForm form, HttpServletRequest request,
                                    HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int page = ParamUtil.CheckParam(request.getParameter("page"), 1);
        int pagesize = ParamUtil.CheckParam(request.getParameter("pagesize"), 20);

        int userId = ParamUtil.CheckParam(request.getParameter("userId"), -1);

        InfoQuery query = new InfoQuery();
        query.setPageIndex(page);
        query.setPageSize(pagesize);
        query.setUserId(userId);
        query.setType(1);

        PageHolder<InfoContent> pageHolder = infoRpcService.queryInfoContentByPage(query);
        String gridJson = LigerUiToGrid.toGridJSON(pageHolder, new String[]{"id", "userId", "title", "type", "weight", "des", "photo", "content", "updateTime", "createTime"}, null);

        ResponseUtil.println(response, gridJson);
        return null;
    }


    /**
     * 查询资讯内容
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws ParseException
     */
    public ActionForward getInfo(ActionMapping mapping,
                                 ActionForm form, HttpServletRequest request,
                                 HttpServletResponse response) throws ParseException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int id = ParamUtil.CheckParam(request.getParameter("id"), 0);

        String responseText = null;
        InfoContent info = infoRpcService.getInfoContent(id);
        System.out.println(info.transContent().getAddress());
        if (info != null) {
            responseText = JSONObject.toJSONString(info);
        } else {
            JSONObject result = new JSONObject();
            result.put("success", false);
            result.put("message", "未检索到该条数据");
            responseText = result.toJSONString();

        }
        ResponseUtil.println(response, responseText);
        return null;
    }

    /**
     * 查询资讯内容
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws ParseException
     */
    public ActionForward getSupplyInfo(ActionMapping mapping,
                                 ActionForm form, HttpServletRequest request,
                                 HttpServletResponse response) throws ParseException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int id = ParamUtil.CheckParam(request.getParameter("id"), 0);

        String responseText = null;
        InfoContent info = infoRpcService.getInfoContent(id);
        if (info != null) {
            JSONObject object = new JSONObject();
            object.put("id", info.getId());
            object.put("weight", info.getWeight());
            object.put("userId", info.getUserId());
            object.put("classId", info.getClassId());
            object.put("title", info.getTitle());
            object.put("type", info.getType());
            object.put("des", info.getDes());
            object.put("photo", info.getPhoto());
            object.put("createTime", info.getCreateTime());
            object.put("updateTime", info.getUpdateTime());

            object.put("venderName", info.transContent().getVenderName());
            object.put("mainBusiness", info.transContent().getMainBusiness());
            object.put("superiority", info.transContent().getSuperiority());
            object.put("area", info.transContent().getArea());
            object.put("address", info.transContent().getAddress());

            responseText = object.toJSONString();
        } else {
            JSONObject result = new JSONObject();
            result.put("success", false);
            result.put("message", "未检索到该条数据");
            responseText = result.toJSONString();

        }
        ResponseUtil.println(response, responseText);
        return null;
    }

    public ActionForward updateInfo(ActionMapping mapping,
                                  ActionForm form, HttpServletRequest request,
                                  HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int id = ParamUtil.CheckParam(request.getParameter("id"), 0);
        int weight = ParamUtil.CheckParam(request.getParameter("weight"), 0);
        int class_id = ParamUtil.CheckParam(request.getParameter("class_id"), 0);
        String title = ParamUtil.CheckParam(request.getParameter("title"), "");
        int type = ParamUtil.CheckParam(request.getParameter("type"), 0);
        String des = ParamUtil.CheckParam(request.getParameter("des"), "");
        String photo = ParamUtil.CheckParam(request.getParameter("photo"), "");
        String content = ParamUtil.CheckParam(request.getParameter("content"), "");


        InfoContent info = infoRpcService.getInfoContent(id);
        info.setWeight(weight);
        info.setClassId(class_id);
        info.setTitle(title);
        info.setType(type);
        info.setDes(des);
        info.setPhoto(photo);
        info.setContent(content);

        int dbFlag = infoRpcService.updateInfoContent(info);

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

    public ActionForward updateSupplyInfo(ActionMapping mapping,
                                    ActionForm form, HttpServletRequest request,
                                    HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int id = ParamUtil.CheckParam(request.getParameter("id"), 0);
        int weight = ParamUtil.CheckParam(request.getParameter("weight"), 0);
        int class_id = ParamUtil.CheckParam(request.getParameter("class_id"), 0);
        String title = ParamUtil.CheckParam(request.getParameter("title"), "");
        int type = ParamUtil.CheckParam(request.getParameter("type"), 0);
        String des = ParamUtil.CheckParam(request.getParameter("des"), "");
        String photo = ParamUtil.CheckParam(request.getParameter("photo"), "");

        String venderName = ParamUtil.CheckParam(request.getParameter("venderName"), "");
        String mainBusiness = ParamUtil.CheckParam(request.getParameter("mainBusiness"), "");
        String superiority = ParamUtil.CheckParam(request.getParameter("superiority"), "");
        String area = ParamUtil.CheckParam(request.getParameter("area"), "");
        String address = ParamUtil.CheckParam(request.getParameter("address"), "");

        InfoVender vender = new InfoVender();
        vender.setVenderName(venderName);
        vender.setMainBusiness(mainBusiness);
        vender.setSuperiority(superiority);
        vender.setArea(area);
        vender.setAddress(address);

        InfoContent info = infoRpcService.getInfoContent(id);
        info.setWeight(weight);
        info.setClassId(class_id);
        info.setTitle(title);
        info.setType(type);
        info.setDes(des);
        info.setPhoto(photo);
        info.setContent(JSONObject.toJSONString(vender));

        int dbFlag = infoRpcService.updateInfoContent(info);

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

    public ActionForward deleteInfo(ActionMapping mapping,
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
                    infoRpcService.deleteInfoContent(Integer.parseInt(id));
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
}
