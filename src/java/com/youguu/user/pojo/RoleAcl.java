package com.youguu.user.pojo;

import java.io.Serializable;
import java.util.Date;

/**
 * 角色权限
 * @author wd
 *
 */
public class RoleAcl implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 5262219399177360062L;

	/**
	 * 角色id
	 */
	private int roleId;
	
	/**
	 * 权限id 对应静态参数表
	 */
	private String aclId;
	
	/**
	 * 权限类型 对应静态参数表的type
	 */
	private String type;
	
	/**
	 * 创建时间
	 */
	private Date createtime;

	public int getRoleId() {
		return roleId;
	}

	public void setRoleId(int roleId) {
		this.roleId = roleId;
	}

	public String getAclId() {
		return aclId;
	}

	public void setAclId(String aclId) {
		this.aclId = aclId;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public Date getCreatetime() {
		return createtime;
	}

	public void setCreatetime(Date createtime) {
		this.createtime = createtime;
	}
	
}
