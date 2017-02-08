package com.youguu.product.action;

import com.alibaba.fastjson.JSONObject;
import com.youguu.core.util.PageHolder;
import com.youguu.core.util.ParamUtil;
import com.youguu.util.LigerUiToGrid;
import com.youguu.util.ResponseUtil;
import com.yyt.print.product.pojo.MallProductCategoryPro;
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
import java.util.List;

/**
 * Created by leo on 2017/2/8.
 */
@Controller("/manager/productCategoryPro")
public class ProductCategoryProAction extends DispatchAction {

    IProductRpcService productRpcService = YytRpcClientFactory.getProductRpcService();

    /**
     * 根据商品类别查询属性列表
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     */
    public ActionForward proList(ActionMapping mapping,
                                   ActionForm form, HttpServletRequest request,
                                   HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int classId = ParamUtil.CheckParam(request.getParameter("classId"), 0);

        List<MallProductCategoryPro> list = productRpcService.findProByClassId(classId);
        PageHolder<MallProductCategoryPro> pageHolder = new PageHolder<>();
        if(list!=null && !list.isEmpty()){
            for(MallProductCategoryPro pro : list){
                pageHolder.add(pro);
            }
        }

        String gridJson = LigerUiToGrid.toGridJSON(pageHolder, new String[]{"id","name", "classId", "type", "isNeed", "isSearch", "rank", "createTime", "updateTime"}, null);

        ResponseUtil.println(response, gridJson);
        return null;
    }

}
