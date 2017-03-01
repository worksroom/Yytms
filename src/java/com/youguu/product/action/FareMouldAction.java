package com.youguu.product.action;

import com.alibaba.fastjson.JSONObject;
import com.youguu.core.util.ParamUtil;
import com.youguu.util.LigerUiToGrid;
import com.youguu.util.ResponseUtil;
import com.yyt.print.product.pojo.FareMould;
import com.yyt.print.product.pojo.ShopUser;
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
@Controller("/manager/fareMould")
public class FareMouldAction extends DispatchAction {
    IProductRpcService productRpcService = YytRpcClientFactory.getProductRpcService();


    public ActionForward fareMouldList(ActionMapping mapping,
                                           ActionForm form, HttpServletRequest request,
                                           HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int shopId = ParamUtil.CheckParam(request.getParameter("shopId"), 0);
        List<FareMould> list = productRpcService.findFareMoulds(shopId);

        String gridJson = LigerUiToGrid.toGridJSON(list, new String[]{"id", "shopId", "name", "type", "price", "num", "updateTime", "createTime"}, null);

        ResponseUtil.println(response, gridJson);
        return null;
    }

    public ActionForward saveFareMould(ActionMapping mapping,
                                           ActionForm form, HttpServletRequest request,
                                           HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String name = ParamUtil.CheckParam(request.getParameter("name"), "");
        int type = ParamUtil.CheckParam(request.getParameter("type"), 0);
        int num = ParamUtil.CheckParam(request.getParameter("num"), 0);
        String price = ParamUtil.CheckParam(request.getParameter("price"), "");

        FareMould fareMould = new FareMould();
        int shopId = (int)request.getSession().getAttribute("shopId");
        fareMould.setShopId(shopId);
        fareMould.setName(name);
        fareMould.setType(type);
        fareMould.setPrice(Double.parseDouble(price));
        fareMould.setNum(num);
        fareMould.setCreateTime(new Date());
        fareMould.setUpdateTime(new Date());

        int dbFlag = productRpcService.saveFareMould(fareMould);
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

    public ActionForward getFareMould(ActionMapping mapping,
                                          ActionForm form, HttpServletRequest request,
                                          HttpServletResponse response) throws ParseException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int id = ParamUtil.CheckParam(request.getParameter("id"), 0);

        String responseText = null;
        FareMould fareMould = productRpcService.getFareMould(id);
        if(fareMould!=null){
            responseText = JSONObject.toJSONString(fareMould);
        } else {
            JSONObject result = new JSONObject();
            result.put("success", false);
            result.put("message", "未检索到该条数据");
            responseText = result.toJSONString();

        }
        ResponseUtil.println(response, responseText);
        return null;
    }

    public ActionForward updateFareMould(ActionMapping mapping,
                                             ActionForm form, HttpServletRequest request,
                                             HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int id = ParamUtil.CheckParam(request.getParameter("id"), 0);
        int shopId = ParamUtil.CheckParam(request.getParameter("shopId"), 0);
        String name = ParamUtil.CheckParam(request.getParameter("name"), "");
        int type = ParamUtil.CheckParam(request.getParameter("type"), 0);
        int num = ParamUtil.CheckParam(request.getParameter("num"), 0);
        String price = ParamUtil.CheckParam(request.getParameter("price"), "");

        FareMould fareMould = productRpcService.getFareMould(id);
        fareMould.setShopId(shopId);
        fareMould.setName(name);
        fareMould.setType(type);
        fareMould.setPrice(Double.parseDouble(price));
        fareMould.setNum(num);
        fareMould.setUpdateTime(new Date());

        int dbFlag = productRpcService.updateFareMould(fareMould);

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

    public ActionForward deleteFareMould(ActionMapping mapping,
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
                    productRpcService.delFareMould(Integer.parseInt(id));
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
