package com.youguu.user.dao;

import com.youguu.user.pojo.RoleAcl;

import java.util.HashMap;
import java.util.List;

/**
 * Created by SomeBody on 2016/8/15.
 */
public interface IRoleAclDAO {
    public int saveRoleAcl(int roleid, String aclId, String type);

    public  int deleteByRole(HashMap<String, Object> hm);

    public int deleteRoleAcl(int roleid, String aclId);

    public List<String> queryRoleAcl(int roleid);

    public List<RoleAcl> queryRoleAcl(int roleid, String type);

    public List<RoleAcl> queryRoleAclByUid(String uid);

    public List<RoleAcl> queryRoleAclByUidAndType(String uid, String type);

    public List<RoleAcl> queryRoleAclByUidAndTypes(String uid, String[] type);

    public List<RoleAcl> queryRoleAclByRoleAndTypes(int roleid, String[] type);

}
