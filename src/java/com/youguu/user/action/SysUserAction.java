package com.youguu.user.action;

import com.alibaba.fastjson.JSONObject;
import com.youguu.core.util.PageHolder;
import com.youguu.core.util.ParamUtil;
import com.youguu.user.pojo.SysUser;
import com.youguu.user.service.IUserRoleService;
import com.youguu.user.service.impl.SysUserService;
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
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by SomeBody on 2016/8/15.
 */
@Controller("/manager/sysUser")
public class SysUserAction extends DispatchAction {

    @Resource
    private SysUserService sysUserService;
    @Resource
    private IUserRoleService userRoleService;

    public ActionForward userList(ActionMapping mapping,
                                    ActionForm form, HttpServletRequest request,
                                    HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        int page = ParamUtil.CheckParam(request.getParameter("page"), 1);
        int pagesize = ParamUtil.CheckParam(request.getParameter("pagesize"), 20);

        String username = ParamUtil.CheckParam(request.getParameter("username"), "");
        Map<String, Object> map = new HashMap<>();
        PageHolder<SysUser> pageHolder = sysUserService.queryPageUserList(map, page, pagesize);

        String gridJson = LigerUiToGrid.toGridJSON(pageHolder, new String[]{"userName", "userLoginName", "userTel", "userQq", "userFreezeFlag"}, null);

        ResponseUtil.println(response, gridJson);
        return null;
    }


    /**
     * 根据角色ID查询用户列表，已在该角色下的用户默认选中
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     */
    public ActionForward userRoleList(ActionMapping mapping,
                                  ActionForm form, HttpServletRequest request,
                                  HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        int posStart = ParamUtil.CheckParam(request.getParameter("posStart"), 0);
        int pageSize = ParamUtil.CheckParam(request.getParameter("pageSize"), 50);

        int roleid = ParamUtil.CheckParam(request.getParameter("roleid"), 0);

        String username = ParamUtil.CheckParam(request.getParameter("username"), "");
        Map<String, Object> map = new HashMap<>();

        PageHolder<SysUser> pageHolder = sysUserService.queryPageUserList(map, (posStart / pageSize) + 1, pageSize);
        List<String> list =  userRoleService.findUserByRoleid(roleid);

        if(pageHolder!=null && pageHolder.size()>0 && list!=null && list.size()>0){
            for(SysUser sysUser : pageHolder){
                if(list.contains(sysUser.getUserLoginName())){
                    sysUser.setChecked(1);
                }
            }
        }


        String gridJson = LigerUiToGrid.toGridJSON(pageHolder, new String[]{"userName", "userLoginName", "userTel", "userQq", "userFreezeFlag", "checked"}, null);

        ResponseUtil.println(response, gridJson);
        return null;
    }

    public ActionForward addSysUser(ActionMapping mapping,
                                    ActionForm form, HttpServletRequest request,
                                    HttpServletResponse response) throws ParseException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String userName = ParamUtil.CheckParam(request.getParameter("userName"), "");
        String userLoginName = ParamUtil.CheckParam(request.getParameter("userLoginName"), "");
        String userPassword = ParamUtil.CheckParam(request.getParameter("userPassword"), "");
        String userTel = ParamUtil.CheckParam(request.getParameter("userTel"), "");
        String userQq = ParamUtil.CheckParam(request.getParameter("userQq"), "");
        String userEmail = ParamUtil.CheckParam(request.getParameter("userEmail"), "");
        String userAddress = ParamUtil.CheckParam(request.getParameter("userAddress"), "");
        String userCurrentAddress = ParamUtil.CheckParam(request.getParameter("userCurrentAddress"), "");
        String userBirthday = ParamUtil.CheckParam(request.getParameter("userBirthday"), "");
        System.out.println(userBirthday);
        SimpleDateFormat sdf = new SimpleDateFormat("EEE MMM dd yyyy HH:mm:ss 'GMT'Z", Locale.US);
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

        JSONObject result = new JSONObject();
        SysUser sysUser = sysUserService.findByUserLoginName(userLoginName);
        if(sysUser!=null){
            result.put("success", false);
            result.put("message", "登录账户已存在");
        } else {
            sysUser = new SysUser();
            sysUser.setUserName(userName);
            sysUser.setUserLoginName(userLoginName);
            sysUser.setUserPassword(userPassword);
            sysUser.setUserTel(userTel);
            sysUser.setUserQq(userQq);
            sysUser.setUserEmail(userEmail);
            sysUser.setUserAddress(userAddress);
            sysUser.setUserCurrentAddress(userCurrentAddress);
            sysUser.setUserBirthday(dateFormat.parse(dateFormat.format(sdf.parse(userBirthday))));
            sysUser.setUserLoginCount(0);
            sysUser.setUserDelFlag(0);
            sysUser.setUserFreezeFlag(0);
            sysUser.setUserCreator(request.getSession().getAttribute("uid").toString());
            sysUser.setUserCreatedTime(new Date());

            int dbFlag = sysUserService.saveUser(sysUser);
            if(dbFlag>0){
                result.put("success", true);
                result.put("message", "保存成功");
            } else{
                result.put("success", false);
                result.put("message", "保存失败");
            }
        }
        ResponseUtil.println(response, result);
        return null;
    }

    public ActionForward updateSysUser(ActionMapping mapping,
                                    ActionForm form, HttpServletRequest request,
                                    HttpServletResponse response) throws ParseException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        JSONObject result = new JSONObject();
        try{
            String userName = ParamUtil.CheckParam(request.getParameter("userName"), "");
            String userLoginName = ParamUtil.CheckParam(request.getParameter("userLoginName"), "");
//            String userPassword = ParamUtil.CheckParam(request.getParameter("userPassword"), "");
            String userTel = ParamUtil.CheckParam(request.getParameter("userTel"), "");
            String userQq = ParamUtil.CheckParam(request.getParameter("userQq"), "");
            String userEmail = ParamUtil.CheckParam(request.getParameter("userEmail"), "");
            String userAddress = ParamUtil.CheckParam(request.getParameter("userAddress"), "");
            String userCurrentAddress = ParamUtil.CheckParam(request.getParameter("userCurrentAddress"), "");
            String userBirthday = ParamUtil.CheckParam(request.getParameter("userBirthday"), "");
            SimpleDateFormat sdf = new SimpleDateFormat("EEE MMM dd yyyy HH:mm:ss 'GMT'Z", Locale.US);
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

            SysUser sysUser = sysUserService.findByUserLoginName(userLoginName);
            if(sysUser==null){
                result.put("success", false);
                result.put("message", "未查询到该用户信息");
            } else {
                sysUser.setUserName(userName);
                sysUser.setUserLoginName(userLoginName);
//                sysUser.setUserPassword(userPassword);
                sysUser.setUserTel(userTel);
                sysUser.setUserQq(userQq);
                sysUser.setUserEmail(userEmail);
                sysUser.setUserAddress(userAddress);
                sysUser.setUserCurrentAddress(userCurrentAddress);
                sysUser.setUserBirthday(dateFormat.parse(dateFormat.format(sdf.parse(userBirthday))));
                sysUser.setUserUpdator(request.getSession().getAttribute("uid").toString());
                sysUser.setUserUpdatedTime(new Date());

                int dbFlag = sysUserService.updateUser(sysUser);
                if(dbFlag>0){
                    result.put("success", true);
                    result.put("message", "修改成功");
                } else{
                    result.put("success", false);
                    result.put("message", "修改失败");
                }
            }

        } catch (Exception e){
            result.put("success", false);
            result.put("message", "系统异常");
        }
        ResponseUtil.println(response, result);
        return null;
    }

    public ActionForward loadSysUser(ActionMapping mapping,
                                    ActionForm form, HttpServletRequest request,
                                    HttpServletResponse response) throws ParseException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String userLoginName = ParamUtil.CheckParam(request.getParameter("userLoginName"), "");

        String responseText = null;
        SysUser sysUser = sysUserService.findByUserLoginName(userLoginName);
        if(sysUser!=null){
            responseText = JSONObject.toJSONString(sysUser);
        } else {
            JSONObject result = new JSONObject();
            result.put("success", false);
            result.put("message", "登录账户已存在");
            responseText = result.toJSONString();

        }
        ResponseUtil.println(response, responseText);
        return null;
    }


    public ActionForward deleteSysUser(ActionMapping mapping,
                                     ActionForm form, HttpServletRequest request,
                                     HttpServletResponse response) throws ParseException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String ids = ParamUtil.CheckParam(request.getParameter("ids"), "");
        JSONObject result = new JSONObject();

        if(ids!=null && !"".equals(ids.trim())){
            String[] idArray = ids.split(",");
            for(String id : idArray){
                sysUserService.deleteUser(id);
            }
            result.put("success", true);
            result.put("message", "删除成功");
        } else {
            result.put("success", false);
            result.put("message", "请先选择删除的用户");
        }

        ResponseUtil.println(response, result.toJSONString());
        return null;
    }

    public ActionForward freezeSysUser(ActionMapping mapping,
                                       ActionForm form, HttpServletRequest request,
                                       HttpServletResponse response) throws ParseException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String ids = ParamUtil.CheckParam(request.getParameter("ids"), "");
        JSONObject result = new JSONObject();

        if(ids!=null && !"".equals(ids.trim())){
            String[] idArray = ids.split(",");
            for(String id : idArray){
                sysUserService.freezeUser(id, 1);
            }
            result.put("success", true);
            result.put("message", "冻结成功");
        } else {
            result.put("success", false);
            result.put("message", "请先选择需要冻结的用户");
        }

        ResponseUtil.println(response, result.toJSONString());
        return null;
    }

    public ActionForward unfreezeSysUser(ActionMapping mapping,
                                       ActionForm form, HttpServletRequest request,
                                       HttpServletResponse response) throws ParseException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String ids = ParamUtil.CheckParam(request.getParameter("ids"), "");
        JSONObject result = new JSONObject();

        if(ids!=null && !"".equals(ids.trim())){
            String[] idArray = ids.split(",");
            for(String id : idArray){
                sysUserService.freezeUser(id, 0);
            }
            result.put("success", true);
            result.put("message", "解冻成功");
        } else {
            result.put("success", false);
            result.put("message", "请先选择需要解冻的用户");
        }

        ResponseUtil.println(response, result.toJSONString());
        return null;
    }

    /**
     * 重置用户密码
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws ParseException
     */
    public ActionForward resetPwd(ActionMapping mapping,
                                         ActionForm form, HttpServletRequest request,
                                         HttpServletResponse response) throws ParseException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String ids = ParamUtil.CheckParam(request.getParameter("ids"), "");
        JSONObject result = new JSONObject();

        if(ids!=null && !"".equals(ids.trim())){
            String[] idArray = ids.split(",");
            for(String id : idArray){
                sysUserService.resetPwd(id, "123456");
            }
            result.put("success", true);
            result.put("message", "重置成功");
        } else {
            result.put("success", false);
            result.put("message", "请先选择需要重置的用户");
        }

        ResponseUtil.println(response, result.toJSONString());
        return null;
    }
}
