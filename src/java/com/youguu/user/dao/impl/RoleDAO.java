package com.youguu.user.dao.impl;

import com.youguu.core.util.PageHolder;
import com.youguu.user.dao.IRoleDAO;
import com.youguu.user.pojo.Role;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by SomeBody on 2016/8/17.
 */
@Repository
public class RoleDAO extends LakesideDAO<Role> implements IRoleDAO {
    @Override
    public int addRole(Role role) {
        return this.insert(role);
    }

    @Override
    public boolean modifyRoleName(int id, String roleName) {
        boolean result = false;

        Role role = new Role();
        role.setId(id);
        role.setRoleName(roleName);


        int count = this.updateBy("update_name", role);

        if(count>0){
            result = true;
        }

        return result;
    }

    @Override
    public boolean modifyRole(Role role) {
        boolean result = false;

        int count = this.update(role);

        if(count>0){
            result = true;
        }

        return result;
    }

    @Override
    public boolean deleteRole(int id) {
        int count = this.delete(id);
        //TODO 删除角色用户关联关系，角色模块关联关系
        return false;
    }

    @Override
    public Role getRole(int id) {
        return this.get(id);
    }

    @Override
    public PageHolder<Role> queryPageRole(Map<String, Object> hm, int pageIndex, int pageSize) {
        if(hm == null){
            hm = new HashMap<String, Object>();
        }
        //按照时间倒叙
        hm.put("cols", "createtime desc");

        return this.pagedQuery("findByParams", hm, pageIndex, pageSize);
    }
}
