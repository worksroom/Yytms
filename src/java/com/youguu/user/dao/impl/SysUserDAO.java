package com.youguu.user.dao.impl;

import com.youguu.core.util.PageHolder;
import com.youguu.user.dao.ISysUserDAO;
import com.youguu.user.pojo.SysUser;
import org.apache.commons.collections.map.HashedMap;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.Map;

/**
 * Created by SomeBody on 2016/8/14.
 */
@Repository
public class SysUserDAO extends LakesideDAO<SysUser> implements ISysUserDAO {
    @Override
    public SysUser findByUserLoginName(String userLoginName) {
        return this.findUniqueBy("findByUserLoginName", userLoginName);
    }

    @Override
    public PageHolder<SysUser> queryPageUserList(Map<String, Object> hm, int pageIndex, int pageSize) {
        return this.pagedQuery("findPageSysUser", hm, pageIndex, pageSize);
    }

    @Override
    public int saveUser(SysUser user) {
        return this.insert(user);
    }

    @Override
    public int updateUser(SysUser user) {
        return this.update(user);
    }

    @Override
    public int deleteUser(String userLoginName) {
        return this.deleteBy("deleteByLoginName", userLoginName);
    }

    @Override
    public int freezeUser(String userLoginName, int type) {
        Map<String, Object> map = new HashedMap();
        map.put("userLoginName", userLoginName);
        map.put("userFreezeFlag", type);
        return this.updateBy("freezeUser", map);
    }

    @Override
    public int resetPwd(String userLoginName, String pwd) {
        Map<String, Object> map = new HashedMap();
        map.put("userLoginName", userLoginName);
        map.put("userPassword", pwd);
        return this.updateBy("resetPwd", map);
    }

    @Override
    public int updateLoginTime(String userLoginName) {
        Map<String, Object> map = new HashedMap();
        map.put("userLoginName", userLoginName);
        map.put("userLoginTime", new Date());
        return this.updateBy("updateLoginTime", map);
    }
}
