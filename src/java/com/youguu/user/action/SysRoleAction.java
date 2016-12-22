package com.youguu.user.action;

import com.alibaba.fastjson.JSONObject;
import com.youguu.core.util.PageHolder;
import com.youguu.core.util.ParamUtil;
import com.youguu.user.pojo.Parameter;
import com.youguu.user.pojo.Role;
import com.youguu.user.service.IAclService;
import com.youguu.user.service.IParameterService;
import com.youguu.user.service.IRoleService;
import com.youguu.user.service.IUserRoleService;
import com.youguu.util.LigerUiToGrid;
import com.youguu.util.ResponseUtil;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;
import org.springframework.stereotype.Controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.ParseException;
import java.util.*;

/**
 * Created by SomeBody on 2016/8/17.
 */
@Controller("/manager/sysRole")
public class SysRoleAction extends DispatchAction {

    @Resource
    private IRoleService roleService;
    @Resource
    private IAclService aclService;
    @Resource
    private IParameterService parameterService;
    @Resource
    private IUserRoleService userRoleService;

    public ActionForward roleList(ActionMapping mapping,
                                  ActionForm form, HttpServletRequest request,
                                  HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        int page = ParamUtil.CheckParam(request.getParameter("page"), 1);
        int pagesize = ParamUtil.CheckParam(request.getParameter("pagesize"), 50);

        String username = ParamUtil.CheckParam(request.getParameter("username"), "");
        Map<String, Object> map = new HashMap<>();
        PageHolder<Role> pageHolder = roleService.queryPageRole(map, page, pagesize);

        String gridJson = LigerUiToGrid.toGridJSON(pageHolder, new String[]{"id","roleName", "type", "createtime"}, null);

        ResponseUtil.println(response, gridJson);
        return null;
    }


    /**
     * 设置角色访问的模块权限
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws ParseException
     */
    public ActionForward setModule(ActionMapping mapping,
                                       ActionForm form, HttpServletRequest request,
                                       HttpServletResponse response) throws ParseException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String ids = ParamUtil.CheckParam(request.getParameter("ids"), "");
        int roleid = ParamUtil.CheckParam(request.getParameter("roleid"), 0);

        JSONObject result = new JSONObject();

        if(ids!=null && !"".equals(ids.trim())){
            List<Parameter> list = new ArrayList<Parameter>();
            String[] idArray = ids.split(",");
            for(String id : idArray){
                Parameter p = parameterService.queryId(id);
                list.add(p);
            }
            aclService.batchInsertRoleAcl(roleid, list, true, new String[] {"99990001", "99990002", "-1" });
            result.put("success", true);
            result.put("message", "设置成功");
        } else {
            result.put("success", false);
            result.put("message", "没有选择功能模块");
        }

        ResponseUtil.println(response, result.toJSONString());
        return null;
    }


    /**
     * 设置角色下有哪些用户
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws ParseException
     */
    public ActionForward setUser(ActionMapping mapping,
                                   ActionForm form, HttpServletRequest request,
                                   HttpServletResponse response) throws ParseException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String ids = ParamUtil.CheckParam(request.getParameter("ids"), "");
        int roleid = ParamUtil.CheckParam(request.getParameter("roleid"), 0);

        JSONObject result = new JSONObject();

        if(ids!=null && !"".equals(ids.trim())){
            String[] idArray = ids.split(",");
            //上次该角色下的用户，重新插入
            userRoleService.deleteUserRolebyRoleId(roleid);
            for(String id : idArray){
                userRoleService.addUserRole(id, roleid);
            }
            result.put("success", true);
            result.put("message", "设置成功");
        } else {
            result.put("success", false);
            result.put("message", "没有选择功能模块");
        }

        ResponseUtil.println(response, result.toJSONString());
        return null;
    }

    public ActionForward addSysRole(ActionMapping mapping,
                                    ActionForm form, HttpServletRequest request,
                                    HttpServletResponse response) throws ParseException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String roleName = ParamUtil.CheckParam(request.getParameter("roleName"), "");
        int type = ParamUtil.CheckParam(request.getParameter("type"), 0);

        JSONObject result = new JSONObject();
        Role role = new Role();
        role.setRoleName(roleName);
        role.setType(type);
        role.setCreatetime(new Date());

        int dbFlag = roleService.addRole(role);
        if(dbFlag>0){
            result.put("success", true);
            result.put("message", "保存成功");
        } else{
            result.put("success", false);
            result.put("message", "保存失败");
        }
        ResponseUtil.println(response, result);
        return null;
    }

    public ActionForward loadSysRole(ActionMapping mapping,
                                     ActionForm form, HttpServletRequest request,
                                     HttpServletResponse response) throws ParseException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int id = ParamUtil.CheckParam(request.getParameter("id"), 0);

        String responseText = null;
        Role role = roleService.getRole(id);
        if(role!=null){
            responseText = JSONObject.toJSONString(role);
        } else {
            JSONObject result = new JSONObject();
            result.put("success", false);
            result.put("message", "角色不存在");
            responseText = result.toJSONString();

        }
        ResponseUtil.println(response, responseText);
        return null;
    }

    public ActionForward updateSysRole(ActionMapping mapping,
                                    ActionForm form, HttpServletRequest request,
                                    HttpServletResponse response) throws ParseException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int id = ParamUtil.CheckParam(request.getParameter("id"), 0);
        String roleName = ParamUtil.CheckParam(request.getParameter("roleName"), "");
        int type = ParamUtil.CheckParam(request.getParameter("type"), 0);

        JSONObject result = new JSONObject();
        Role role = roleService.getRole(id);
        role.setRoleName(roleName);
        role.setType(type);

        boolean dbFlag = roleService.modifyRole(role);
        if(dbFlag){
            result.put("success", true);
            result.put("message", "修改成功");
        } else{
            result.put("success", false);
            result.put("message", "修改失败");
        }
        ResponseUtil.println(response, result);
        return null;
    }

    public ActionForward deleteSysRole(ActionMapping mapping,
                                       ActionForm form, HttpServletRequest request,
                                       HttpServletResponse response) throws ParseException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String ids = ParamUtil.CheckParam(request.getParameter("ids"), "");
        JSONObject result = new JSONObject();

        if(ids!=null && !"".equals(ids.trim())){
            String[] idArray = ids.split(",");
            for(String id : idArray){
                roleService.deleteRole(Integer.parseInt(id));
            }
            result.put("success", true);
            result.put("message", "删除成功");
        } else {
            result.put("success", false);
            result.put("message", "请先选择删除的角色");
        }

        ResponseUtil.println(response, result.toJSONString());
        return null;
    }
}
