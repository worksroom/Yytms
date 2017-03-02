package com.youguu.order.action;

import com.alibaba.fastjson.JSONObject;
import com.youguu.core.util.PageHolder;
import com.youguu.core.util.ParamUtil;
import com.youguu.util.LigerUiToGrid;
import com.youguu.util.ResponseUtil;
import com.yyt.print.order.pojo.Orders;
import com.yyt.print.order.query.OrdersQuery;
import com.yyt.print.rpc.client.YytRpcClientFactory;
import com.yyt.print.rpc.client.order.IOrderRPCService;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;
import org.springframework.stereotype.Controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by leo on 2017/3/2.
 */
@Controller("/manager/order")
public class OrderAction extends DispatchAction {
    IOrderRPCService orderRPCService = YytRpcClientFactory.getOrderRPCService();

    /**
     * 查询订单
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     */
    public ActionForward orderList(ActionMapping mapping,
                                       ActionForm form, HttpServletRequest request,
                                       HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int page = ParamUtil.CheckParam(request.getParameter("page"), 1);
        int pagesize = ParamUtil.CheckParam(request.getParameter("pagesize"), 20);

        int buyerUserId = ParamUtil.CheckParam(request.getParameter("buyerUserId"), -1);
        int status = ParamUtil.CheckParam(request.getParameter("status"), -1);
        int shopId = ParamUtil.CheckParam(request.getParameter("shopId"), -1);

        OrdersQuery query = new OrdersQuery();
        query.setPageIndex(page);
        query.setPageSize(pagesize);

        query.setBuyUserId(buyerUserId);
        query.setShopId(shopId);
        query.setStatus(status);

        PageHolder<Orders> pageHolder = orderRPCService.findOrders(query);
        String gridJson = LigerUiToGrid.toGridJSON(pageHolder, new String[]{"id", "buyUserId", "sellUserId", "shopId", "payType", "totalMoney", "productMoney", "status", "fee",
                "addressId", "productDesc", "payTime", "updateTime", "createTime"}, null);

        ResponseUtil.println(response, gridJson);
        return null;
    }

    /**
     * 修改订单支付总金额
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     */
    public ActionForward updateOrderPrice(ActionMapping mapping,
                                     ActionForm form, HttpServletRequest request,
                                     HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String orderId = ParamUtil.CheckParam(request.getParameter("orderId"), "");
        String totalMoney = ParamUtil.CheckParam(request.getParameter("totalMoney"), "");

        int dbFlag = orderRPCService.updateOrderPrice(orderId, Double.parseDouble(totalMoney));
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
}
