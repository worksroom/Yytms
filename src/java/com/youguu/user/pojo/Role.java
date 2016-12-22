package com.youguu.user.pojo;

import java.util.Date;

/**
 * Title: 角色实体类
 * <p>Copyright  ©2011-2012	Jhss Corp</p>
 *
 * @author wd
 */
public class Role {
    /**
     * 角色id
     */
    private int id;
    /**
     * 角色名称
     */
    private String roleName;
    /**
     * 用户状态 0正常 1冻结
     */
    private int type;

    /**
     * 创建时间
     */
    private Date createtime;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public Date getCreatetime() {
        return createtime;
    }

    public void setCreatetime(Date createtime) {
        this.createtime = createtime;
    }
}
