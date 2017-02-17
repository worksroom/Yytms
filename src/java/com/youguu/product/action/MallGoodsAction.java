package com.youguu.product.action;

import com.alibaba.fastjson.JSONObject;
import com.youguu.core.util.PageHolder;
import com.youguu.core.util.ParamUtil;
import com.youguu.util.LigerUiToGrid;
import com.youguu.util.ResponseUtil;
import com.yyt.print.product.pojo.MallGoods;
import com.yyt.print.product.query.MallGoodsQuery;
import com.yyt.print.rpc.client.YytRpcClientFactory;
import com.yyt.print.rpc.client.product.IProductRpcService;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;
import org.springframework.stereotype.Controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by leo on 2017/2/14.
 */
@Controller("/manager/goods")
public class MallGoodsAction extends DispatchAction {

    IProductRpcService productRpcService = YytRpcClientFactory.getProductRpcService();

    /**
     * 货品列表查询
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     */
    public ActionForward mallGoodsList(ActionMapping mapping,
                                 ActionForm form, HttpServletRequest request,
                                 HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int page = ParamUtil.CheckParam(request.getParameter("page"), 1);
        int pagesize = ParamUtil.CheckParam(request.getParameter("pagesize"), 20);

        int classId = ParamUtil.CheckParam(request.getParameter("classId"), -1);
        String name = ParamUtil.CheckParam(request.getParameter("name"), "");
        int shopId = ParamUtil.CheckParam(request.getParameter("shopId"), -1);
        int status = ParamUtil.CheckParam(request.getParameter("status"), -1);
        String shopName = ParamUtil.CheckParam(request.getParameter("shopName"), "");

        MallGoodsQuery query = new MallGoodsQuery();
        query.setClassId(classId);
        if(name!=null && !"".equals(name)){
            query.setName(name);
        }

        query.setPageIndex(page);
        query.setPageSize(pagesize);
        query.setShopId(shopId);
        if(shopName!=null && !"".equals(shopName)){
            query.setShopName(shopName);
        }

        query.setStatus(status);

        PageHolder<MallGoods> pageHolder = productRpcService.findMallGoods(query);

        String gridJson = LigerUiToGrid.toGridJSON(pageHolder, new String[]{"id", "name", "shopId", "shopName", "des", "classId", "status", "img", "createTime", "updateTime"}, null);

        ResponseUtil.println(response, gridJson);
        return null;
    }


    /**
     * 货品审核
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     */
    public ActionForward review(ActionMapping mapping,
                                         ActionForm form, HttpServletRequest request,
                                         HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int goodsId = ParamUtil.CheckParam(request.getParameter("goodsId"), 0);
        int status = ParamUtil.CheckParam(request.getParameter("status"), 0);

        int dbFlag = productRpcService.reviewMallGoods(goodsId, status==1?true:false);
        JSONObject result = new JSONObject();
        if(dbFlag>0){
            result.put("success", true);
            result.put("message", "审核成功");
        } else{
            result.put("success", false);
            result.put("message", "修改失败");
        }

        ResponseUtil.println(response, result);
        return null;
    }

}
