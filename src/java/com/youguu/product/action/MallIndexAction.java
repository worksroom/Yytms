package com.youguu.product.action;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.youguu.core.util.PageHolder;
import com.youguu.core.util.ParamUtil;
import com.youguu.util.LigerUiToGrid;
import com.youguu.util.ResponseUtil;
import com.yyt.print.product.pojo.MallIndex;
import com.yyt.print.product.pojo.MallIndexContent;
import com.yyt.print.rpc.client.YytRpcClientFactory;
import com.yyt.print.rpc.client.product.IProductRpcService;
import com.yyt.print.user.pojo.UserBuyer;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;
import org.springframework.stereotype.Controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.ParseException;
import java.util.Date;
import java.util.List;

/**
 * Created by leo on 2017/2/14.
 */
@Controller("/manager/index")
public class MallIndexAction extends DispatchAction {

    IProductRpcService productRpcService = YytRpcClientFactory.getProductRpcService();

    /**
     * 商城首页碎片列表
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     */
    public ActionForward mallIndexList(ActionMapping mapping,
                                  ActionForm form, HttpServletRequest request,
                                  HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int page = ParamUtil.CheckParam(request.getParameter("page"), 1);
        int pagesize = ParamUtil.CheckParam(request.getParameter("pagesize"), 20);

        int status = ParamUtil.CheckParam(request.getParameter("status"), -1);

        PageHolder<MallIndex> pageHolder = productRpcService.queryMallIndex(status, page, pagesize);

        String gridJson = LigerUiToGrid.toGridJSON(pageHolder, new String[]{"id", "rank", "type", "status", "name", "content", "createTime", "updateTime"}, null);

        ResponseUtil.println(response, gridJson);
        return null;
    }


    /**
     * 添加碎片
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws ParseException
     */
    public ActionForward addMallIndex(ActionMapping mapping,
                                    ActionForm form, HttpServletRequest request,
                                    HttpServletResponse response) throws ParseException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        JSONObject result = new JSONObject();

        try{
            String formData = ParamUtil.CheckParam(request.getParameter("formData"), "");
            String gridData = ParamUtil.CheckParam(request.getParameter("gridData"), "");


            MallIndex mallIndex = JSONObject.parseObject(formData, MallIndex.class);
            mallIndex.setCreateTime(new Date());

            List<MallIndexContent> contentList = JSONArray.parseArray(gridData, MallIndexContent.class);

            int dbFlag = productRpcService.addMallIndex(mallIndex, contentList);
            if(dbFlag>0){
                result.put("success", true);
                result.put("message", "保存成功");
            } else{
                result.put("success", false);
                result.put("message", "保存失败");
            }
        } catch (Exception e){
            result.put("success", false);
            result.put("message", "系统异常,请联系管理员");
        }

        ResponseUtil.println(response, result);
        return null;
    }


    /**
     * 修改碎片
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws ParseException
     */
    public ActionForward updateMallIndex(ActionMapping mapping,
                                      ActionForm form, HttpServletRequest request,
                                      HttpServletResponse response) throws ParseException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        JSONObject result = new JSONObject();

        try{
            String formData = ParamUtil.CheckParam(request.getParameter("formData"), "");
            String gridData = ParamUtil.CheckParam(request.getParameter("gridData"), "");


            MallIndex mallIndex = JSONObject.parseObject(formData, MallIndex.class);
            mallIndex.setCreateTime(new Date());

            List<MallIndexContent> contentList = JSONArray.parseArray(gridData, MallIndexContent.class);


            int dbFlag = productRpcService.updateMallIndex(mallIndex, contentList);
            if(dbFlag>0){
                result.put("success", true);
                result.put("message", "修改成功");
            } else{
                result.put("success", false);
                result.put("message", "修改失败");
            }
        } catch (Exception e){
            result.put("success", false);
            result.put("message", "系统异常,请联系管理员");
        }
        ResponseUtil.println(response, result);
        return null;
    }


    /**
     * 修改碎片状态
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws ParseException
     */
    public ActionForward updateMallIndexStatus(ActionMapping mapping,
                                         ActionForm form, HttpServletRequest request,
                                         HttpServletResponse response) throws ParseException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int id = ParamUtil.CheckParam(request.getParameter("id"), 0);
        int status = ParamUtil.CheckParam(request.getParameter("status"), 99);

        JSONObject result = new JSONObject();

        int dbFlag = productRpcService.updateStatus(id, status==1?true:false);
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
     * 加载碎片
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws ParseException
     */
    public ActionForward loadMallIndex(ActionMapping mapping,
                                       ActionForm form, HttpServletRequest request,
                                       HttpServletResponse response) throws ParseException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int id = ParamUtil.CheckParam(request.getParameter("id"), 0);

        String responseText = null;
        MallIndex mallIndex = productRpcService.getMallIndex(id);
        if(mallIndex!=null){
            responseText = JSONObject.toJSONString(mallIndex);
        } else {
            JSONObject result = new JSONObject();
            result.put("success", false);
            result.put("message", "未查询到匹配信息");
            responseText = result.toJSONString();

        }
        ResponseUtil.println(response, responseText);
        return null;
    }
}
