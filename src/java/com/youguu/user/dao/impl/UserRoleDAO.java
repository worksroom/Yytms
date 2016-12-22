package com.youguu.user.dao.impl;

import com.youguu.user.dao.IUserRoleDAO;
import com.youguu.user.pojo.UserRole;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;
import java.util.HashMap;

/**
 * Created by SomeBody on 2016/8/26.
 */
@Repository
public class UserRoleDAO extends LakesideDAO<UserRole> implements IUserRoleDAO {
    @Override
    public int addUserRole(String uid, int roleId) {
        UserRole userRole = new UserRole();
        userRole.setUid(uid);
        userRole.setRoleid(roleId);
        return this.insert(userRole);
    }

    @Override
    public boolean deleteUserRole(String uid, int roleId) {
        Map<String, Object> map = new HashMap();
        map.put("uid", uid);
        map.put("roleId", roleId);

        int result = this.deleteBy("", map);
        return result>0?true:false;
    }

    @Override
    public boolean deleteUserRolebyRoleId(int roleId) {
        int result =  this.deleteBy("deleteUserRolebyRoleId", roleId);
        return result>0?true:false;
    }

    @Override
    public boolean deleteUserRolebyUserId(String uid) {
        int result =  this.deleteBy("deleteUserRolebyUserId", uid);
        return result>0?true:false;
    }

    @Override
    public List<String> findUserByRoleid(int roleId) {
        return this.findBy("findUserByRoleid", roleId);
    }
}
