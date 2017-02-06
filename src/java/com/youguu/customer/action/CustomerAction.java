package com.youguu.customer.action;

import com.youguu.core.util.PageHolder;
import com.youguu.core.util.ParamUtil;
import com.youguu.util.LigerUiToGrid;
import com.youguu.util.ResponseUtil;
import com.yyt.print.rpc.client.YytRpcClientFactory;
import com.yyt.print.rpc.client.user.IUserRpcService;
import com.yyt.print.user.pojo.User;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;
import org.springframework.stereotype.Controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 用户(客户)Action
 */
@Controller("/manager/customer")
public class CustomerAction extends DispatchAction {

    IUserRpcService userRpcService = YytRpcClientFactory.getUserRpcService();

    /**
     * 用户查询
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     */
    public ActionForward customerList(ActionMapping mapping,
                                    ActionForm form, HttpServletRequest request,
                                    HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        int page = ParamUtil.CheckParam(request.getParameter("page"), 1);
        int pagesize = ParamUtil.CheckParam(request.getParameter("pagesize"), 20);

        int userId = ParamUtil.CheckParam(request.getParameter("userId"), 0);
        String name = ParamUtil.CheckParam(request.getParameter("name"), "");
        String nickname = ParamUtil.CheckParam(request.getParameter("nickname"), "");
        String phone = ParamUtil.CheckParam(request.getParameter("phone"), "");
        String email = ParamUtil.CheckParam(request.getParameter("email"), "");


        PageHolder<User> pageHolder = userRpcService.queryUserByPage(userId, name, nickname, phone, page, pagesize);
        String gridJson = LigerUiToGrid.toGridJSON(pageHolder, new String[]{"userId", "userName", "nickName", "phone", "email", "createTime", "updateTime"}, null);

        ResponseUtil.println(response, gridJson);
        return null;
    }

}
