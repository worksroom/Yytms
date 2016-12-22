package com.youguu.user.service.impl;

import com.youguu.core.logging.Log;
import com.youguu.core.logging.LogFactory;
import com.youguu.user.dao.impl.RoleAclDAO;
import com.youguu.user.pojo.Parameter;
import com.youguu.user.pojo.RoleAcl;
import com.youguu.user.service.IAclService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;

@Service("aclService")
public class AclService implements IAclService {

    /**
     * 获取log4j 输出类
     */
    private static Log logger = LogFactory.getLog("");

    /**
     * 角色权限操作
     */
    @Resource
    private RoleAclDAO roleAclDAO;

    /**
     * 角色加入权限
     *
     * @param roleid
     * @param aclId
     * @param type
     */
    @Override
    public int insertRoleAcl(int roleid, String aclId, String type) {
        return roleAclDAO.saveRoleAcl(roleid, aclId, type);
    }

    /**
     * 批量加入权限
     *
     * @param roleid
     * @param parameterlist 静态参数列表 需要使用静态参数表的ID和TYPE
     * @param needDelete    是否删除原来的权限 true删除 false 不删除
     */
    @Override
    public void batchInsertRoleAcl(int roleid, List<Parameter> parameterlist, boolean needDelete, String[] types) {
        logger.debug("batchInsertRoleAcl start..");
        if (parameterlist != null) {
            /*******1.是否需要删除原有角色的权限************/
            if (needDelete) {
                HashMap<String, Object> hm = new HashMap<>();
                hm.put("roleid", roleid);

                StringBuffer sb = new StringBuffer("");
                if (types != null) {
                    for (int i = 0; i < types.length; i++) {
                        sb.append("'" + types[i] + "'");
                        if (i != types.length - 1) {
                            sb.append(",");
                        }
                    }
                    hm.put("type", sb.toString());
                }


                roleAclDAO.deleteByRole(hm);
            }
            /******2.添加权限******************/
            for (Parameter p : parameterlist) {
                roleAclDAO.saveRoleAcl(roleid, p.getId(), p.getType());
            }
        }
        logger.debug("batchInsertRoleAcl end..");
    }

    /**
     * 删除角色单个权限
     *
     * @param roleid
     * @param aclId
     * @return
     */
    @Override
    public boolean deleteRoleAcl(int roleid, String aclId) {
        logger.debug("deleteRoleAcl start..");

        boolean result = false;
        int count = roleAclDAO.deleteRoleAcl(roleid, aclId);
        if (count > 0) {
            result = true;
        }

        logger.debug("deleteRoleAcl end..");

        return result;
    }

    /**
     * 查询角色的所有权限
     *
     * @param roleid
     * @return
     */
    @Override
    public List<String> queryRoleAcl(int roleid) {
        return roleAclDAO.queryRoleAcl(roleid);

    }

    /**
     * 查询角色某种类型的所有权限
     *
     * @param roleid
     * @param type
     * @return
     */
    @Override
    public List<RoleAcl> queryRoleAcl(int roleid, String type) {
        List<RoleAcl> list = roleAclDAO.queryRoleAcl(roleid, type);
        return list;
    }


    /**
     * 查询角色某种类型的所有权限
     *
     * @param roleid
     * @param type
     * @return 格式 [aclid1],[aclid2],[aclid3]....
     */
    @Override
    public String queryRoleAclString(int roleid, String type) {
        StringBuffer result = new StringBuffer("");
        RoleAcl ra_param = new RoleAcl();
        ra_param.setRoleId(roleid);
        ra_param.setType(type);

        List<RoleAcl> list = roleAclDAO.queryRoleAcl(roleid, type);

        if (list != null && list.size() > 0) {
            for (int i = 0; i < list.size(); i++) {
                RoleAcl ra = list.get(i);
                result.append("[").append(ra.getAclId()).append("]");
                if (i != list.size() - 1) {
                    result.append(",");
                }
            }
        }

        return result.toString();
    }

    /**
     * 查询用户的所有权限
     *
     * @param uid
     * @return
     */
    @Override
    public List<RoleAcl> queryUserAcl(String uid) {
        return roleAclDAO.queryRoleAclByUid(uid);
    }

    /**
     * 查询用户的所有权限返回字符串
     *
     * @param uid
     * @return 格式 [aclid1],[aclid2],[aclid3]....
     */
    @Override
    public String queryUserAclString(String uid) {
        logger.debug("List<RoleAcl> queryUserAcl(String uid) start..");
        StringBuffer result = new StringBuffer("");
        List<RoleAcl> list = this.queryUserAcl(uid);
        if (list != null && list.size() > 0) {
            for (int i = 0; i < list.size(); i++) {
                RoleAcl ra = list.get(i);
                result.append("[").append(ra.getAclId()).append("]");
                if (i != list.size() - 1) {
                    result.append(",");
                }
            }
        }
        logger.debug("List<RoleAcl> queryUserAcl(String uid) end..");
        return result.toString();
    }

    /**
     * 查询用户某种类型的所有权限
     *
     * @param uid
     * @param type
     * @return
     */
    @Override
    public List<RoleAcl> queryUserAcl(String uid, String type) {
        return roleAclDAO.queryRoleAclByUidAndType(uid, type);
    }


    /**
     * 查询用户某种类型的所有权限
     *
     * @param type
     * @return 格式 [aclid1],[aclid2],[aclid3]....
     */
    @Override
    public String queryUserAclString(String uid, String type) {
        logger.debug("String queryUserAcl(String uid, String type) start..");
        StringBuffer result = new StringBuffer("");
        List<RoleAcl> list = queryUserAcl(uid, type);
        if (list != null && list.size() > 0) {
            for (int i = 0; i < list.size(); i++) {
                RoleAcl ra = list.get(i);
                result.append("[").append(ra.getAclId()).append("]");
                if (i != list.size() - 1) {
                    result.append(",");
                }
            }
        }
        logger.debug("String queryUserAcl(String uid, String type) end..");
        return result.toString();
    }

    /**
     * 查询用户多种类型的所有权限
     *
     * @param uid
     * @param type
     * @return
     */
    @Override
    public List<RoleAcl> queryUserAcl(String uid, String[] type) {
        return roleAclDAO.queryRoleAclByUidAndTypes(uid, type);
    }

    /**
     * 查询用户多种类型的所有权限
     *
     * @param uid
     * @param type
     * @return 格式 [aclid1],[aclid2],[aclid3]....
     */
    @Override
    public String queryUserAclString(String uid, String[] type) {
        logger.debug("String queryUserAcl(String uid, String[] type) start..");
        StringBuffer result = new StringBuffer("");
        if (type != null) {

            List<RoleAcl> list = roleAclDAO.queryRoleAclByUidAndTypes(uid, type);
            if (list != null && list.size() > 0) {
                for (int i = 0; i < list.size(); i++) {
                    RoleAcl ra = list.get(i);
                    result.append("[").append(ra.getAclId()).append("]");
                    if (i != list.size() - 1) {
                        result.append(",");
                    }
                }
            }
        }
        logger.debug("String queryUserAcl(String uid, String[] type) end..");
        return result.toString();
    }

    /**
     * 查询角色某几种类型的所有权限
     *
     * @param roleid
     * @param type
     * @return
     */
    @Override
    public List<RoleAcl> queryRoleAcl(int roleid, String[] type) {
        List<RoleAcl> list = roleAclDAO.queryRoleAclByRoleAndTypes(roleid, type);
        return list;
    }

    @Override
    public String queryRoleAclString(int roleid, String[] type) {
        StringBuffer result = new StringBuffer("");
        if (type != null) {
            List<RoleAcl> list = roleAclDAO.queryRoleAclByRoleAndTypes(roleid, type);
            if (list != null && list.size() > 0) {
                for (int i = 0; i < list.size(); i++) {
                    RoleAcl ra = list.get(i);
                    result.append("[").append(ra.getAclId()).append("]");
                    if (i != list.size() - 1) {
                        result.append(",");
                    }
                }
            }
        }
        return result.toString();
    }

}
