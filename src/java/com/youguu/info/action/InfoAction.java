package com.youguu.info.action;

import com.youguu.core.util.PageHolder;
import com.youguu.core.util.ParamUtil;
import com.youguu.util.LigerUiToGrid;
import com.youguu.util.ResponseUtil;
import com.yyt.print.info.pojo.InfoContent;
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

/**
 * Created by leo on 2017/3/3.
 */
@Controller("/manager/info")
public class InfoAction extends DispatchAction {

    IInfoRpcService infoRpcService = YytRpcClientFactory.getInfoRpcService();

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
}
