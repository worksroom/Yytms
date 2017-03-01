package com.youguu.product.action;

import com.alibaba.fastjson.JSONObject;
import com.youguu.core.util.ParamUtil;
import com.youguu.util.LigerUiToGrid;
import com.youguu.util.ResponseUtil;
import com.yyt.print.product.pojo.ShopUser;
import com.yyt.print.product.pojo.StoreLocation;
import com.yyt.print.rpc.client.YytRpcClientFactory;
import com.yyt.print.rpc.client.product.IProductRpcService;
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
 * Created by leo on 2017/2/23.
 */
@Controller("/manager/storeLocation")
public class StoreLocationAction extends DispatchAction {

    IProductRpcService productRpcService = YytRpcClientFactory.getProductRpcService();


    public ActionForward storeLocationList(ActionMapping mapping,
                                           ActionForm form, HttpServletRequest request,
                                           HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        int shopId = ParamUtil.CheckParam(request.getParameter("shopId"), 0);
        List<StoreLocation> list = productRpcService.findStoreLocations(shopId);

        String gridJson = LigerUiToGrid.toGridJSON(list, new String[]{"id", "shopId", "fCode", "fName", "sCode", "sName", "createTime", "updateTime"}, null);

        ResponseUtil.println(response, gridJson);
        return null;
    }

    public ActionForward saveStoreLocation(ActionMapping mapping,
                                             ActionForm form, HttpServletRequest request,
                                             HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");


        int fCode = ParamUtil.CheckParam(request.getParameter("fCode"), 0);
        String fName = ParamUtil.CheckParam(request.getParameter("fName"), "");
        int sCode = ParamUtil.CheckParam(request.getParameter("sCode"), 0);
        String sName = ParamUtil.CheckParam(request.getParameter("sName"), "");

        StoreLocation location = new StoreLocation();
        int shopId = (int)request.getSession().getAttribute("shopId");
        location.setShopId(shopId);
        location.setFCode(fCode);
        location.setFName(fName);
        location.setSCode(sCode);
        location.setSName(sName);
        location.setCreateTime(new Date());
        location.setUpdateTime(new Date());

        int dbFlag = productRpcService.saveStoreLocation(location);
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

    public ActionForward getStoreLocation(ActionMapping mapping,
                                            ActionForm form, HttpServletRequest request,
                                            HttpServletResponse response) throws ParseException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int id = ParamUtil.CheckParam(request.getParameter("id"), 0);

        String responseText = null;
        StoreLocation location = productRpcService.getStoreLocation(id);
        if(location!=null){
            responseText = JSONObject.toJSONString(location);
        } else {
            JSONObject result = new JSONObject();
            result.put("success", false);
            result.put("message", "未检索到该条数据");
            responseText = result.toJSONString();

        }
        ResponseUtil.println(response, responseText);
        return null;
    }

    public ActionForward updateStoreLocation(ActionMapping mapping,
                                               ActionForm form, HttpServletRequest request,
                                               HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int id = ParamUtil.CheckParam(request.getParameter("id"), 0);
        int shopId = ParamUtil.CheckParam(request.getParameter("shopId"), 0);
        int fCode = ParamUtil.CheckParam(request.getParameter("fCode"), 0);
        String fName = ParamUtil.CheckParam(request.getParameter("fName"), "");
        int sCode = ParamUtil.CheckParam(request.getParameter("sCode"), 0);
        String sName = ParamUtil.CheckParam(request.getParameter("sName"), "");

        StoreLocation location = productRpcService.getStoreLocation(id);
        location.setShopId(shopId);
        location.setFCode(fCode);
        location.setFName(fName);
        location.setSCode(sCode);
        location.setSName(sName);
        location.setUpdateTime(new Date());

        int dbFlag = productRpcService.updateStoreLocation(location);

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

    public ActionForward deleteStoreLocation(ActionMapping mapping,
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
                    productRpcService.delStoreLocation(Integer.parseInt(id));
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
