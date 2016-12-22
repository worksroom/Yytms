package com.youguu.user.service;

import com.youguu.core.util.PageHolder;
import com.youguu.user.pojo.SysUser;

import java.util.Map;

/**
 * Created by SomeBody on 2016/8/14.
 */
public interface ISysUserService {
    public SysUser findByUserLoginName(String userLoginName);

    public PageHolder<SysUser> queryPageUserList(Map<String, Object> hm,int pageIndex,int pageSize);

    /**
     * 插入新用户
     * @param user
     * @return
     */
    public int saveUser(SysUser user);

    /**
     * 修改新用户，登录账户无法修改
     * @param user
     * @return
     */
    public int updateUser(SysUser user);

    /**
     * 根据登录账户删除用户
     * @param userLoginName 登录账户
     * @return
     */
    public int deleteUser(String userLoginName);

    /**
     * 设置用户状态[1:冻结 0:解冻]
     * @param userLoginName 登录账户
     * @param type 冻结状态
     * @return
     */
    public int freezeUser(String userLoginName, int type);

    /**
     * 重置用户密码，默认密码123456
     * @param userLoginName 登录账户
     * @param pwd 新密码
     * @return
     */
    public int resetPwd(String userLoginName, String pwd);

    /**
     * 修改用户最后登录系统时间
     * @param userLoginName
     * @return
     */
    public int updateLoginTime(String userLoginName);
}
