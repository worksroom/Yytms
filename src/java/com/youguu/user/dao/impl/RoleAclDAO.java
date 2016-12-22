package com.youguu.user.dao.impl;

import com.youguu.user.dao.IRoleAclDAO;
import com.youguu.user.pojo.RoleAcl;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;

/**
 * Created by SomeBody on 2016/8/15.
 */
@Repository
public class RoleAclDAO extends LakesideDAO<RoleAcl> implements IRoleAclDAO {
    @Override
    public int saveRoleAcl(int roleid, String aclId, String type) {
        RoleAcl ra = new RoleAcl();
        ra.setRoleId(roleid);
        ra.setAclId(aclId);
        ra.setType(type);
        return this.insert(ra);
    }

    @Override
    public int deleteByRole(HashMap<String, Object> hm) {
        return this.deleteBy("deleteByRole", hm);
    }

    @Override
    public int deleteRoleAcl(int roleId, String aclId) {
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("roleId", roleId);
        map.put("aclId", aclId);
        return this.deleteBy("deleteRoleAcl", map);
    }

    @Override
    public List<String> queryRoleAcl(int roleid) {
        return this.findBy("selectByRole", roleid);
    }

    @Override
    public List<RoleAcl> queryRoleAcl(int roleId, String type) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("roleId", roleId);
        map.put("type", type);
        List<RoleAcl> list = this.findBy("selectByRoleType", map);
        return list;
    }

    @Override
    public List<RoleAcl> queryRoleAclByUid(String uid) {
        return this.findBy("queryRoleAclByUid",uid);
    }

    @Override
    public List<RoleAcl> queryRoleAclByUidAndType(String uid, String type) {
        HashMap<String, String> hm = new HashMap<>();
        hm.put("uid", uid);
        hm.put("type", type);
        return this.findBy("selectByUidType", hm);
    }

    @Override
    public List<RoleAcl> queryRoleAclByUidAndTypes(String uid, String[] type) {
        if (type != null) {

            StringBuffer sb = new StringBuffer("");
            for (int i = 0; i < type.length; i++) {
                sb.append("'" + type[i] + "'");
                if (i != type.length - 1) {
                    sb.append(",");
                }
            }
            HashMap<String, String> hm = new HashMap<>();
            hm.put("uid", uid);
            hm.put("type", sb.toString());

            return this.findBy("selectByUidTypes", hm);

        }
        return null;
    }

    @Override
    public List<RoleAcl> queryRoleAclByRoleAndTypes(int roleid, String[] type) {
        if (type != null) {
            StringBuffer sb = new StringBuffer("");
            for (int i = 0; i < type.length; i++) {
                sb.append("'" + type[i] + "'");
                if (i != type.length - 1) {
                    sb.append(",");
                }
            }
            HashMap<String, Object> hm = new HashMap<>();
            hm.put("roleid", roleid);
            hm.put("type", sb.toString());

            return this.findBy("selectByRoleTypes", hm);
        }
        return null;
    }
}
