package com.youguu.ad.action;

import com.alibaba.fastjson.JSONObject;
import com.youguu.core.util.PageHolder;
import com.youguu.core.util.ParamUtil;
import com.youguu.util.LigerUiToGrid;
import com.youguu.util.ResponseUtil;
import com.yyt.print.ad.pojo.Ad;
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
@Controller("/manager/ad")
public class AdAction extends DispatchAction {

    IAdRpcService adRpcService = YytRpcClientFactory.getAdRpcService();

    public ActionForward adList(ActionMapping mapping,
                                        ActionForm form, HttpServletRequest request,
                                        HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int page = ParamUtil.CheckParam(request.getParameter("page"), 1);
        int pagesize = ParamUtil.CheckParam(request.getParameter("pagesize"), 20);

        int ad_type = ParamUtil.CheckParam(request.getParameter("ad_type"), 0);
        int used = ParamUtil.CheckParam(request.getParameter("used"), 0);

        PageHolder<Ad> pageHolder = adRpcService.queryAdByPage(ad_type, used, page, pagesize);
        if (pageHolder != null && !pageHolder.isEmpty()) {
            for (Ad ad : pageHolder) {
                AdCategory adCategory = adRpcService.getAdCategory(ad.getAdType());
                if (adCategory != null) {
                    ad.setAdCategoryName(adCategory.getName());
                }
            }
        }
        String gridJson = LigerUiToGrid.toGridJSON(pageHolder, new String[]{"id", "adType", "adCategoryName", "img", "des", "url", "used", "createTime"}, null);

        ResponseUtil.println(response, gridJson);
        return null;
    }

    public ActionForward saveAd(ActionMapping mapping,
                                        ActionForm form, HttpServletRequest request,
                                        HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        int adType = ParamUtil.CheckParam(request.getParameter("adType"), 0);
        int used = ParamUtil.CheckParam(request.getParameter("used"), 0);
        String img = ParamUtil.CheckParam(request.getParameter("img"), "");
        String des = ParamUtil.CheckParam(request.getParameter("des"), "");
        String url = ParamUtil.CheckParam(request.getParameter("url"), "");

        Ad ad = new Ad();
        ad.setAdType(adType);
        ad.setImg(img);
        ad.setDes(des);
        ad.setUrl(url);
        ad.setUsed(used);
        ad.setCreateTime(new Date());

        int dbFlag = adRpcService.saveAd(ad);
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

    public ActionForward getAd(ActionMapping mapping,
                                       ActionForm form, HttpServletRequest request,
                                       HttpServletResponse response) throws ParseException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int id = ParamUtil.CheckParam(request.getParameter("id"), 0);

        String responseText = null;
        Ad ad = adRpcService.getAd(id);
        if(ad!=null){
            responseText = JSONObject.toJSONString(ad);
        } else {
            JSONObject result = new JSONObject();
            result.put("success", false);
            result.put("message", "未检索到该条数据");
            responseText = result.toJSONString();

        }
        ResponseUtil.println(response, responseText);
        return null;
    }

    public ActionForward updateAd(ActionMapping mapping,
                                          ActionForm form, HttpServletRequest request,
                                          HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int id = ParamUtil.CheckParam(request.getParameter("id"), 0);
        int adType = ParamUtil.CheckParam(request.getParameter("adType"), 0);
        int used = ParamUtil.CheckParam(request.getParameter("used"), 0);
        String img = ParamUtil.CheckParam(request.getParameter("img"), "");
        String des = ParamUtil.CheckParam(request.getParameter("des"), "");
        String url = ParamUtil.CheckParam(request.getParameter("url"), "");

        Ad ad = adRpcService.getAd(id);
        ad.setAdType(adType);
        ad.setImg(img);
        ad.setDes(des);
        ad.setUrl(url);
        ad.setUsed(used);
        ad.setCreateTime(new Date());

        int dbFlag = adRpcService.updateAd(ad);

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

    public ActionForward deleteAd(ActionMapping mapping,
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
                    adRpcService.deleteAd(Integer.parseInt(id));
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
