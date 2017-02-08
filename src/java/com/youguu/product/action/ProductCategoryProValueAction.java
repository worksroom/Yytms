package com.youguu.product.action;

import com.youguu.core.util.PageHolder;
import com.youguu.core.util.ParamUtil;
import com.youguu.util.LigerUiToGrid;
import com.youguu.util.ResponseUtil;
import com.yyt.print.product.pojo.MallProductCategoryPro;
import com.yyt.print.product.pojo.MallProductCategoryProValue;
import com.yyt.print.rpc.client.YytRpcClientFactory;
import com.yyt.print.rpc.client.product.IProductRpcService;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;
import org.springframework.stereotype.Controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * Created by leo on 2017/2/8.
 */
@Controller("/manager/productCategoryProValue")
public class ProductCategoryProValueAction extends DispatchAction {

    IProductRpcService productRpcService = YytRpcClientFactory.getProductRpcService();

    /**
     * 根据商品类别查询属性值列表
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     */
    public ActionForward proValueList(ActionMapping mapping,
                                 ActionForm form, HttpServletRequest request,
                                 HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int proId = ParamUtil.CheckParam(request.getParameter("proId"), 0);

        List<MallProductCategoryProValue> list = productRpcService.findProValueByProId(proId);
        PageHolder<MallProductCategoryProValue> pageHolder = new PageHolder<>();
        if(list!=null && !list.isEmpty()){
            for(MallProductCategoryProValue pro : list){
                pageHolder.add(pro);
            }
        }

        String gridJson = LigerUiToGrid.toGridJSON(pageHolder, new String[]{"id", "name", "classProId", "classId", "pic", "used", "rank", "createTime", "updateTime"}, null);

        ResponseUtil.println(response, gridJson);
        return null;
    }

}
