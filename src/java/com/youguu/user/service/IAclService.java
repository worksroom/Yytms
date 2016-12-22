package com.youguu.user.service;

import com.youguu.user.pojo.Parameter;
import com.youguu.user.pojo.RoleAcl;

import java.util.List;

public interface IAclService {
    /**
     * 角色加入权限
     *
     * @param roleid
     * @param aclId
     * @param type
     */
    public int insertRoleAcl(int roleid, String aclId, String type);

    /**
     * 批量加入权限
     *
     * @param roleid
     * @param parameterlist 静态参数列表 需要使用静态参数表的ID和TYPE
     * @param needDelete    是否删除原来的权限 true删除 false 不删除
     */
    public void batchInsertRoleAcl(int roleid, List<Parameter> parameterlist, boolean needDelete, String[] types);

    /**
     * 删除角色单个权限
     *
     * @param roleid
     * @param aclId
     * @return
     */
    public boolean deleteRoleAcl(int roleid, String aclId);

    /**
     * 查询角色的所有权限
     *
     * @param roleid
     * @return
     */
    public List<String> queryRoleAcl(int roleid);

    /**
     * 查询角色某种类型的所有权限
     *
     * @param roleid
     * @param type
     * @return
     */
    public List<RoleAcl> queryRoleAcl(int roleid, String type);

    /**
     * 查询角色某种类型的所有权限
     *
     * @param roleid
     * @param type
     * @return 格式 [aclid1],[aclid2],[aclid3]....
     */
    public String queryRoleAclString(int roleid, String type);

    /**
     * 查询角色某几种类型的所有权限
     *
     * @param roleid
     * @param type
     * @return
     */
    public List<RoleAcl> queryRoleAcl(int roleid, String[] type);

    /**
     * 查询角色某几种类型的所有权限
     *
     * @param roleid
     * @param type
     * @return 格式 [aclid1],[aclid2],[aclid3]....
     */
    public String queryRoleAclString(int roleid, String[] type);


    /**
     * 查询用户的所有权限
     *
     * @param uid
     * @return
     */
    public List<RoleAcl> queryUserAcl(String uid);

    /**
     * 查询用户的所有权限返回字符串
     *
     * @param uid
     * @return 格式 [aclid1],[aclid2],[aclid3]....
     */
    public String queryUserAclString(String uid);

    /**
     * 查询用户某种类型的所有权限
     *
     * @param uid
     * @param type
     * @return
     */
    public List<RoleAcl> queryUserAcl(String uid, String type);

    /**
     * 查询用户某种类型的所有权限
     *
     * @param uid
     * @param type
     * @return 格式 [aclid1],[aclid2],[aclid3]....
     */
    public String queryUserAclString(String uid, String type);

    /**
     * 查询用户多种类型的所有权限
     *
     * @param uid
     * @param type
     * @return
     */
    public List<RoleAcl> queryUserAcl(String uid, String[] type);

    /**
     * 查询用户多种类型的所有权限
     *
     * @param uid
     * @param type
     * @return 格式 [aclid1],[aclid2],[aclid3]....
     */
    public String queryUserAclString(String uid, String[] type);


}
