package com.youguu.user.service;

import java.util.List;

/**
 * Created by SomeBody on 2016/8/26.
 */
public interface IUserRoleService {
    public int addUserRole(String uid, int roleId);

    public boolean deleteUserRole(String uid, int roleId);

    public boolean deleteUserRolebyRoleId(int roleId);

    public boolean deleteUserRolebyUserId(String uid);

    public List<String> findUserByRoleid(int roleId);
}
