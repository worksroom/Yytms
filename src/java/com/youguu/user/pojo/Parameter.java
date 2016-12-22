package com.youguu.user.pojo;

import java.util.Date;

public class Parameter {
	/**
	 * 静态参数的id
	 * 格式四位一组: 00010002
	 */
	private String id;
	
	/**
	 * 类别
	 * 思位一组 来自本表的ID
	 */
	private String type;
	
	/**
	 * 父id 根节点为-1
	 */
	private String parentId;
	
	/**
	 * 名称
	 */
	private String name;
	
	/**
	 * 值
	 * 不同的类型 有不同的描述
	 */
	private String value;
	
	/**
	 * 创建时间
	 */
	private Date createtime;
	
	/**
	 * 扩展属性1
	 */
	private String exp1;
	
	/**
	 * 扩展属性2
	 */
	private String exp2;

	/**
	 * 图片名称
	 */
	private String icon;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getParentId() {
		return parentId;
	}

	public void setParentId(String parentId) {
		this.parentId = parentId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	public Date getCreatetime() {
		return createtime;
	}

	public void setCreatetime(Date createtime) {
		this.createtime = createtime;
	}

	public String getExp1() {
		return exp1;
	}

	public void setExp1(String exp1) {
		this.exp1 = exp1;
	}

	public String getExp2() {
		return exp2;
	}

	public void setExp2(String exp2) {
		this.exp2 = exp2;
	}

	public String getIcon() {
		return icon;
	}

	public void setIcon(String icon) {
		this.icon = icon;
	}

	@Override
	public String toString() {
		return "Parameter{" +
				"id='" + id + '\'' +
				", type='" + type + '\'' +
				", parentId='" + parentId + '\'' +
				", name='" + name + '\'' +
				", value='" + value + '\'' +
				", createtime=" + createtime +
				", exp1='" + exp1 + '\'' +
				", exp2='" + exp2 + '\'' +
				'}';
	}
}
