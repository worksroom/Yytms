package com.youguu.product.action;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.youguu.core.util.ParamUtil;
import com.youguu.ui.ITree;
import com.youguu.ui.LigerUiToTreeJson;
import com.youguu.ui.LigerUiTree;
import com.youguu.user.pojo.Parameter;
import com.youguu.util.AclCheck;
import com.youguu.util.ParameterUtil;
import com.youguu.util.ResponseUtil;
import com.yyt.print.product.pojo.MallProductCategory;
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
 * Created by leo on 2017/1/2.
 */
@Controller("/manager/productCategory")
public class ProductCategoryAction extends DispatchAction {

    IProductRpcService productRpcService = YytRpcClientFactory.getProductRpcService();

    /**
     * 加载商品类别树
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     */
    public ActionForward loadCategoryTree(ActionMapping mapping,
                                      ActionForm form, HttpServletRequest request,
                                      HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        MallProductCategory category = productRpcService.getMallProductCategory(-1);
        JSONObject jsonObject = makeCategoryTree(category).toTree();
        JSONArray jsonArray = new JSONArray();
        jsonArray.add(jsonObject);

        ResponseUtil.println(response, jsonArray.toJSONString());
        return null;
    }

    /**
     * 生成商品类别树结构
     * @param category
     * @return
     */
    public ITree makeCategoryTree(MallProductCategory category) {
        ITree tree = new LigerUiTree();

        tree.setId(String.valueOf(category.getId()));
        tree.setName(category.getName());
//        tree.setUrl(""+category.getId());
        tree.setPic("http://localhost:8888/lakeside/resources/ligerUI/skins/icons/archives.gif");

        List<MallProductCategory> list = productRpcService.findMallProductCategoryList(category.getId());
        if (list != null && list.size() > 0) {
            for (MallProductCategory p : list) {
                ITree childTree = makeCategoryTree(p);
                tree.addSubTree(childTree);  //组织好数据
            }
        }
        return tree;
    }


    /**
     * 新增商品类别
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     */
    public ActionForward saveProductCategory(ActionMapping mapping,
                                      ActionForm form, HttpServletRequest request,
                                      HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int parentId = ParamUtil.CheckParam(request.getParameter("parentId"), 0);
//        int id = ParamUtil.CheckParam(request.getParameter("id"), 0);
        String name = ParamUtil.CheckParam(request.getParameter("name"), "");
        String des = ParamUtil.CheckParam(request.getParameter("des"), "");
        int rank = ParamUtil.CheckParam(request.getParameter("rank"), 0);
        int isEnd = ParamUtil.CheckParam(request.getParameter("isEnd"), 0);
        String logo = ParamUtil.CheckParam(request.getParameter("logo"), "");

        MallProductCategory p = new MallProductCategory();
//        p.setId(id);
        p.setDes(des);
        p.setCreateTime(new Date());
        p.setIsEnd(isEnd);
        p.setLogo(logo);
        p.setName(name);
        p.setParentId(parentId);
        p.setRank(rank);
        p.setUpdateTime(new Date());

        int dbFlag = productRpcService.saveMallProductCategory(p);
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

    public ActionForward getProductCategory(ActionMapping mapping,
                                       ActionForm form, HttpServletRequest request,
                                       HttpServletResponse response) throws ParseException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int id = ParamUtil.CheckParam(request.getParameter("id"), 0);

        String responseText = null;
        MallProductCategory p = productRpcService.getMallProductCategory(id);
        if(p!=null){
            responseText = JSONObject.toJSONString(p);
        } else {
            JSONObject result = new JSONObject();
            result.put("success", false);
            result.put("message", "未检索到该条数据");
            responseText = result.toJSONString();

        }
        ResponseUtil.println(response, responseText);
        return null;
    }

    public ActionForward updateProductCategory(ActionMapping mapping,
                                         ActionForm form, HttpServletRequest request,
                                         HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int parentId = ParamUtil.CheckParam(request.getParameter("parentId"), 0);
        int id = ParamUtil.CheckParam(request.getParameter("id"), 0);
        String name = ParamUtil.CheckParam(request.getParameter("name"), "");
        String des = ParamUtil.CheckParam(request.getParameter("des"), "");
        int rank = ParamUtil.CheckParam(request.getParameter("rank"), 0);
        int isEnd = ParamUtil.CheckParam(request.getParameter("isEnd"), 0);
        String logo = ParamUtil.CheckParam(request.getParameter("logo"), "");
        String parentName = ParamUtil.CheckParam(request.getParameter("parentName"), "");

        MallProductCategory p = productRpcService.getMallProductCategory(id);

        int dbFlag = 0;

        if(p==null){
            p = new MallProductCategory();
            p.setDes(des);
            p.setIsEnd(isEnd);
            p.setLogo(logo);
            p.setName(name);
            p.setParentId(parentId);
            p.setRank(rank);
            p.setUpdateTime(new Date());
            p.setCreateTime(new Date());
            dbFlag = productRpcService.saveMallProductCategory(p);
        } else {
            p.setDes(des);
            p.setIsEnd(isEnd);
            p.setLogo(logo);
            p.setName(name);
            p.setParentId(parentId);
            p.setRank(rank);
            p.setUpdateTime(new Date());
            dbFlag = productRpcService.updateMallProductCategory(p);
        }


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

    /**
     * 删除商品类别
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     */
    public ActionForward deleteProductCategory(ActionMapping mapping,
                                      ActionForm form, HttpServletRequest request,
                                      HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int id = ParamUtil.CheckParam(request.getParameter("id"), 0);

        int dbFlag = productRpcService.deleteMallProductCategory(id);
        JSONObject result = new JSONObject();
        if(dbFlag>0){
            result.put("success", true);
            result.put("message", "删除成功");
        } else{
            result.put("success", false);
            result.put("message", "删除失败");
        }
        ResponseUtil.println(response, result);
        return null;
    }

}
