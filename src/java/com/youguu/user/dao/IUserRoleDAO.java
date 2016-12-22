package com.youguu.user.dao;

import java.util.List;

/**
 * Created by SomeBody on 2016/8/15.
 */
public interface IUserRoleDAO {
    public int addUserRole(String uid, int roleId);

    public boolean deleteUserRole(String uid, int roleId);

    public boolean deleteUserRolebyRoleId(int roleId);

    public boolean deleteUserRolebyUserId(String uid);

    public List<String> findUserByRoleid(int roleId);
}
