package com.youguu.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * 用户权限判断
 *
 * @author jhss
 */
public class AclCheck {
    /**
     * 判断用户是否有此栏目的权限
     *
     * @param request
     * @param aclCode
     * @return
     */
    public static boolean checkMenuAcl(HttpServletRequest request,
                                       String aclCode) {
        boolean hasRight = false;
        HttpSession session = request.getSession();
        String uid = (String) session.getAttribute("uid");

        if ("sysadmin".equals(uid)) {
            return true;
        }

        String acl = (String) session.getAttribute("aclMenu");
        if (acl.indexOf("[" + aclCode + "]") != -1) {
            hasRight = true;
        }
        return hasRight;
    }

    /**
     * 判断用户是否有此功能的操作权限
     *
     * @param request
     * @param aclCode
     * @return
     */
    public static boolean checkFunAcl(HttpServletRequest request, String aclCode) {
        boolean hasRight = false;
        HttpSession session = request.getSession();
        String uid = (String) session.getAttribute("uid");

        if ("sysadmin".equals(uid)) {
            return true;
        }
        String acl = (String) session.getAttribute("aclFun");
        if (acl.indexOf("[" + aclCode + "]") != -1) {
            hasRight = true;
        }
        return hasRight;
    }

}
