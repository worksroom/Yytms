package com.youguu.customer.action;

import com.alibaba.fastjson.JSONObject;
import com.youguu.core.util.PageHolder;
import com.youguu.core.util.ParamUtil;
import com.youguu.user.pojo.SysUser;
import com.youguu.util.LigerUiToGrid;
import com.youguu.util.ResponseUtil;
import com.yyt.print.rpc.client.YytRpcClientFactory;
import com.yyt.print.rpc.client.user.IUserRpcService;
import com.yyt.print.user.pojo.UserBuyer;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;
import org.springframework.stereotype.Controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.ParseException;

/**
 * 买家Action
 */
@Controller("/manager/buyer")
public class BuyerAction extends DispatchAction {

    IUserRpcService userRpcService = YytRpcClientFactory.getUserRpcService();

    /**
     * 买家查询
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     */
    public ActionForward buyerList(ActionMapping mapping,
                                    ActionForm form, HttpServletRequest request,
                                    HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        int page = ParamUtil.CheckParam(request.getParameter("page"), 1);
        int pagesize = ParamUtil.CheckParam(request.getParameter("pagesize"), 20);

        String username = ParamUtil.CheckParam(request.getParameter("username"), "");

        PageHolder<UserBuyer> pageHolder = userRpcService.queryUserBuyerByPage(0, null, null, null, null, null, page, pagesize);
        String gridJson = LigerUiToGrid.toGridJSON(pageHolder, new String[]{"userId", "name", "cardNumber", "status", "msg", "createTime", "updateTime"}, null);

        ResponseUtil.println(response, gridJson);
        return null;
    }

    /**
     * 买家认证审核
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws ParseException
     */
    public ActionForward review(ActionMapping mapping,
                                    ActionForm form, HttpServletRequest request,
                                    HttpServletResponse response) throws ParseException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int userId = ParamUtil.CheckParam(request.getParameter("userId"), 0);
        int status = ParamUtil.CheckParam(request.getParameter("status"), 0);
        String msg = ParamUtil.CheckParam(request.getParameter("msg"), "");

        JSONObject result = new JSONObject();

        UserBuyer buyer = userRpcService.getUserBuyer(userId);
        if(buyer==null){
            result.put("success", false);
            result.put("message", "用户不存在");
        }

        buyer.setStatus(status);
        buyer.setMsg(msg);

        int flag = userRpcService.updateUserBuyer(buyer);
        if(flag>0){
            result.put("success", true);
            result.put("message", "审核成功");
        } else {
            result.put("success", false);
            result.put("message", "审核失败");
        }

        ResponseUtil.println(response, result);
        return null;
    }


    /**
     * 根据客户ID查询客户信息
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws ParseException
     */
    public ActionForward loadUserBuyer(ActionMapping mapping,
                                     ActionForm form, HttpServletRequest request,
                                     HttpServletResponse response) throws ParseException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int userId = ParamUtil.CheckParam(request.getParameter("id"), 0);

        String responseText = null;
        UserBuyer buyer = userRpcService.getUserBuyer(userId);
        if(buyer!=null){
            responseText = JSONObject.toJSONString(buyer);
        } else {
            JSONObject result = new JSONObject();
            result.put("success", false);
            result.put("message", "用户不存在");
            responseText = result.toJSONString();

        }
        ResponseUtil.println(response, responseText);
        return null;
    }
}
