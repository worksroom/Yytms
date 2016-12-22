package com.youguu.user.dao;


import com.youguu.core.util.PageHolder;
import com.youguu.user.pojo.Role;

import java.util.Map;

/**
 * Created by SomeBody on 2016/8/15.
 */
public interface IRoleDAO {
    /**
     * 添加角色
     *
     * @param role
     * @return
     */
    public int addRole(Role role);

    /**
     * 修改角色名称
     *
     * @param id       角色id
     * @param roleName
     * @return
     */
    public boolean modifyRoleName(int id, String roleName);

    /**
     * 修改角色属性
     *
     * @param role
     * @return
     */
    public boolean modifyRole(Role role);

    /**
     * 删除角色
     *
     * @param id
     * @return
     */
    public boolean deleteRole(int id);

    /**
     * 查询单个角色
     *
     * @param id
     * @return
     */
    public Role getRole(int id);

    /**
     * 查询角色列表
     *
     * @param hm        key:value
     *                  id:角色
     *                  roleName/like_roleName :角色名称/模糊查询
     *                  type:角色状态
     * @param pageIndex 开始页数
     * @param pageSize  每页记录数
     */
    public PageHolder<Role> queryPageRole(Map<String, Object> hm, int pageIndex, int pageSize);
}
