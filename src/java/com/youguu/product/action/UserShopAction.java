package com.youguu.product.action;

import com.alibaba.fastjson.JSONObject;
import com.youguu.core.util.PageHolder;
import com.youguu.core.util.ParamUtil;
import com.youguu.product.vo.UserShopVO;
import com.youguu.util.LigerUiToGrid;
import com.youguu.util.ResponseUtil;
import com.yyt.print.product.pojo.MallGoods;
import com.yyt.print.product.pojo.ShopUser;
import com.yyt.print.product.pojo.UserShop;
import com.yyt.print.product.query.MallGoodsQuery;
import com.yyt.print.product.query.UserShopQuery;
import com.yyt.print.rpc.client.YytRpcClientFactory;
import com.yyt.print.rpc.client.product.IProductRpcService;
import com.yyt.print.rpc.client.user.IUserRpcService;
import com.yyt.print.user.pojo.User;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;
import org.springframework.stereotype.Controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * Created by leo on 2017/2/14.
 */
@Controller("/manager/shop")
public class UserShopAction extends DispatchAction {

    IUserRpcService userRpcService = YytRpcClientFactory.getUserRpcService();
    IProductRpcService productRpcService = YytRpcClientFactory.getProductRpcService();

    /**
     * 店铺列表查询
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     */
    public ActionForward shopList(ActionMapping mapping,
                                 ActionForm form, HttpServletRequest request,
                                 HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int page = ParamUtil.CheckParam(request.getParameter("page"), 1);
        int pagesize = ParamUtil.CheckParam(request.getParameter("pagesize"), 20);

        String name = ParamUtil.CheckParam(request.getParameter("name"), "");
        int status = ParamUtil.CheckParam(request.getParameter("status"), -1);

        UserShopQuery query = new UserShopQuery();
        query.setPageIndex(page);
        query.setPageSize(pagesize);
        if(name!=null && !"".equals(name)){
            query.setName(name);
        }

        query.setStatus(status);

        PageHolder<UserShop> pageHolder = productRpcService.findUserShops(query);

        List<Integer> userIdList = new ArrayList<>();
        if(pageHolder!=null && pageHolder.size()>0){
            for(UserShop userShop : pageHolder){
                userIdList.add(userShop.getSellUserId());
            }
        }

        Map<Integer, User> userMap = userRpcService.getUserMap(userIdList);
        PageHolder<UserShopVO> resultList = new PageHolder<>();
        if(pageHolder!=null && pageHolder.size()>0){
            resultList.setPageIndex(pageHolder.getPageIndex());
            resultList.setPageSize(pageHolder.getPageSize());
            resultList.setTotalCount(pageHolder.getTotalCount());

            for(UserShop userShop : pageHolder){
                UserShopVO vo = new UserShopVO();
                vo.setId(userShop.getId());
                vo.setName(userShop.getName());
                vo.setSellUserId(userShop.getSellUserId());
                vo.setMainProduct(userShop.getMainProduct());
                vo.setStatus(userShop.getStatus());
                vo.setLogo(userShop.getLogo());
                vo.setCreateTime(userShop.getCreateTime());
                vo.setUpdateTime(userShop.getUpdateTime());

                if(userMap!=null && userMap.size()>0){
                    User user = userMap.get(userShop.getSellUserId());
                    vo.setNickName(user.getNickName());
                    vo.setUserName(user.getUserName());
                }

                resultList.add(vo);
            }
        }

        String gridJson = LigerUiToGrid.toGridJSON(resultList, new String[]{"id", "name", "sellUserId", "userName", "mainProduct", "status", "logo", "createTime", "updateTime"}, null);

        ResponseUtil.println(response, gridJson);
        return null;
    }


    /**
     * 店铺审核
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

        int id = ParamUtil.CheckParam(request.getParameter("id"), 0);
        int status = ParamUtil.CheckParam(request.getParameter("status"), 0);

        int dbFlag = productRpcService.reviewUserShop(id, status==1?true:false);

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
