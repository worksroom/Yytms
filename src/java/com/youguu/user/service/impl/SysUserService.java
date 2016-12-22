package com.youguu.user.service.impl;

import com.youguu.core.util.PageHolder;
import com.youguu.user.dao.impl.SysUserDAO;
import com.youguu.user.pojo.SysUser;
import com.youguu.user.service.ISysUserService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Map;

/**
 * Created by SomeBody on 2016/8/14.
 */
@Service("sysUserService")
public class SysUserService implements ISysUserService {

    @Resource
    private SysUserDAO sysUserDAO;

    @Override
    public SysUser findByUserLoginName(String userLoginName) {
        return sysUserDAO.findByUserLoginName(userLoginName);
    }

    @Override
    public PageHolder<SysUser> queryPageUserList(Map<String, Object> hm, int pageIndex, int pageSize) {
        return sysUserDAO.queryPageUserList(hm, pageIndex, pageSize);
    }

    @Override
    public int saveUser(SysUser user) {
        return sysUserDAO.saveUser(user);
    }

    @Override
    public int updateUser(SysUser user) {
        return sysUserDAO.updateUser(user);
    }

    @Override
    public int deleteUser(String userLoginName) {
        return sysUserDAO.deleteUser(userLoginName);
    }

    @Override
    public int freezeUser(String userLoginName, int type) {
        return sysUserDAO.freezeUser(userLoginName, type);
    }

    @Override
    public int resetPwd(String userLoginName, String pwd) {
        return sysUserDAO.resetPwd(userLoginName, pwd);
    }

    @Override
    public int updateLoginTime(String userLoginName) {
        return sysUserDAO.updateLoginTime(userLoginName);
    }
}
