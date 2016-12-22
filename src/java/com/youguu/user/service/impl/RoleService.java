package com.youguu.user.service.impl;

import com.youguu.core.util.PageHolder;
import com.youguu.user.dao.IRoleAclDAO;
import com.youguu.user.dao.IRoleDAO;
import com.youguu.user.pojo.Role;
import com.youguu.user.service.IRoleService;
import com.youguu.user.service.IUserRoleService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by SomeBody on 2016/8/17.
 */
@Service("roleService")
public class RoleService implements IRoleService {

    @Resource
    private IRoleDAO roleDAO;
    @Resource
    private IUserRoleService userRoleService;
    @Resource
    private IRoleAclDAO roleAclDAO;

    @Override
    public int addRole(Role role) {
        return roleDAO.addRole(role);
    }

    @Override
    public boolean modifyRoleName(int id, String roleName) {
        return roleDAO.modifyRoleName(id, roleName);
    }

    @Override
    public boolean modifyRole(Role role) {
        return roleDAO.modifyRole(role);
    }

    @Override
    public boolean deleteRole(int id) {
        userRoleService.deleteUserRolebyRoleId(id);
        HashMap<String, Object> hm = new HashMap<>();
        hm.put("roleid", id);
        roleAclDAO.deleteByRole(hm);
        return roleDAO.deleteRole(id);
    }

    @Override
    public Role getRole(int id) {
        return roleDAO.getRole(id);
    }

    @Override
    public PageHolder<Role> queryPageRole(Map<String, Object> hm, int pageIndex, int pageSize) {
        return roleDAO.queryPageRole(hm, pageIndex, pageSize);
    }
}
