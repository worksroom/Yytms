package com.youguu.user.action;

import com.alibaba.fastjson.JSONObject;
import com.youguu.core.logging.Log;
import com.youguu.core.logging.LogFactory;
import com.youguu.core.util.ParamUtil;
import com.youguu.user.pojo.SysUser;
import com.youguu.user.service.IAclService;
import com.youguu.user.service.ISysUserService;
import com.youguu.util.ParameterUtil;
import com.youguu.util.ResponseUtil;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;
import org.springframework.stereotype.Controller;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@Controller("/loginAction")
public class LoginAction extends DispatchAction {

    private static final Log logger = LogFactory.getLog("lakeside");

    @Resource
    private ISysUserService sysUserService;
    @Resource
    private IAclService aclService;

    public ActionForward login(ActionMapping mapping, ActionForm form,
                               HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");

        String username = ParamUtil.CheckParam(request.getParameter("username"), "");
        String password = ParamUtil.CheckParam(request.getParameter("password"), "");

        SysUser sysUser = sysUserService.findByUserLoginName(username);

        JSONObject result = new JSONObject();
        if(sysUser==null){
            result.put("success", false);
            result.put("message", "登录账户不正确");
        }

        if(sysUser.getUserPassword().equals(password)){
            HttpSession session = request.getSession();
            // 用户登录session数据保存
            session.setAttribute("uid", sysUser.getUserLoginName());
            session.setAttribute("uname", sysUser.getUserName());

            /****** 3.查询用户栏目权限 ********************/
            String aclMenu = aclService.queryUserAclString(username, ParameterUtil.MENU);
            /****** 4.查询用户功能权限 ********************/
            String aclFun = aclService.queryUserAclString(username, ParameterUtil.ACTION);

            session.setAttribute("aclMenu", aclMenu);
            session.setAttribute("aclFun", aclFun);

            result.put("success", true);
            result.put("message", "登录成功");

            sysUserService.updateLoginTime(username);
        } else {
            result.put("success", false);
            result.put("message", "登录密码错误");
        }


        ResponseUtil.println(response, result);

        return null;
    }

    public ActionForward logout(ActionMapping mapping, ActionForm form,
                               HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");

        request.getSession().removeAttribute("uid");
        request.getSession().removeAttribute("uname");

        Cookie[] cookies = request.getCookies();
        if (cookies != null && cookies.length > 0) {
            for (Cookie cookie : cookies) {
                // 设置生存期为0
                cookie.setMaxAge(-1);
                cookie.setPath("/");
                // 设回Response中生效
                response.addCookie(cookie);
            }
        }
        request.getRequestDispatcher("/login.jsp").forward(request, response);

        return null;
    }
}
