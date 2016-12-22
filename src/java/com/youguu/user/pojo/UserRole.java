package com.youguu.user.pojo;

import java.io.Serializable;
import java.util.Date;

/**
 * Title: 用户角色关系实体类
 * <p>Copyright  ©2011-2012	Jhss Corp</p>
 * @author wd
 */
public class UserRole implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = -4619572293912425114L;

	/**
	 * 用户id
	 */
	private String uid;
	
	/**
	 * 角色id
	 */
	private int roleid;
	/**
	 * 创建时间
	 */
	private Date createtime;
	
	
	public String getUid() {
		return uid;
	}
	public void setUid(String uid) {
		this.uid = uid;
	}
	
	public Date getCreatetime() {
		return createtime;
	}
	public void setCreatetime(Date createtime) {
		this.createtime = createtime;
	}
	public int getRoleid() {
		return roleid;
	}
	public void setRoleid(int roleid) {
		this.roleid = roleid;
	}
	
	
}
