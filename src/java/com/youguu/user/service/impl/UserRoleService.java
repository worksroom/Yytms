package com.youguu.user.service.impl;

import com.youguu.user.dao.IUserRoleDAO;
import com.youguu.user.pojo.UserRole;
import com.youguu.user.service.IUserRoleService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by SomeBody on 2016/8/26.
 */
@Service("userRoleService")
public class UserRoleService implements IUserRoleService {
    @Resource
    private IUserRoleDAO userRoleDAO;

    @Override
    public int addUserRole(String uid, int roleId) {
        return userRoleDAO.addUserRole(uid, roleId);
    }

    @Override
    public boolean deleteUserRole(String uid, int roleId) {
        return userRoleDAO.deleteUserRole(uid, roleId);
    }

    @Override
    public boolean deleteUserRolebyRoleId(int roleId) {
        return userRoleDAO.deleteUserRolebyRoleId(roleId);
    }

    @Override
    public boolean deleteUserRolebyUserId(String uid) {
        return userRoleDAO.deleteUserRolebyUserId(uid);
    }

    @Override
    public List<String> findUserByRoleid(int roleId) {
        return userRoleDAO.findUserByRoleid(roleId);
    }
}
