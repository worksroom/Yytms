package com.youguu.user.pojo;

import com.alibaba.fastjson.annotation.JSONField;

import java.util.Date;

/**
 * Created by SomeBody on 2016/8/14.
 */
public class SysUser {
    private int id;
    private String userName;
    private String userLoginName;
    private String userPassword;
    private String userTel;
    private String userQq;
    private String userEmail;
    private String userAddress;
    private String userCurrentAddress;
    @JSONField(format = "yyyy-MM-dd")
    private Date userBirthday;
    private String userLoginTime;
    private int userLoginCount;
    private Date userUpdatedTime;
    private String userUpdator;
    private Date userCreatedTime;
    private String userCreator;
    private int userFreezeFlag;
    private int userDelFlag;

    //extend
    private int checked;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserLoginName() {
        return userLoginName;
    }

    public void setUserLoginName(String userLoginName) {
        this.userLoginName = userLoginName;
    }

    public String getUserPassword() {
        return userPassword;
    }

    public void setUserPassword(String userPassword) {
        this.userPassword = userPassword;
    }

    public String getUserTel() {
        return userTel;
    }

    public void setUserTel(String userTel) {
        this.userTel = userTel;
    }

    public String getUserQq() {
        return userQq;
    }

    public void setUserQq(String userQq) {
        this.userQq = userQq;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public String getUserAddress() {
        return userAddress;
    }

    public void setUserAddress(String userAddress) {
        this.userAddress = userAddress;
    }

    public String getUserCurrentAddress() {
        return userCurrentAddress;
    }

    public void setUserCurrentAddress(String userCurrentAddress) {
        this.userCurrentAddress = userCurrentAddress;
    }

    public Date getUserBirthday() {
        return userBirthday;
    }

    public void setUserBirthday(Date userBirthday) {
        this.userBirthday = userBirthday;
    }

    public int getUserLoginCount() {
        return userLoginCount;
    }

    public void setUserLoginCount(int userLoginCount) {
        this.userLoginCount = userLoginCount;
    }

    public Date getUserUpdatedTime() {
        return userUpdatedTime;
    }

    public void setUserUpdatedTime(Date userUpdatedTime) {
        this.userUpdatedTime = userUpdatedTime;
    }

    public String getUserUpdator() {
        return userUpdator;
    }

    public void setUserUpdator(String userUpdator) {
        this.userUpdator = userUpdator;
    }

    public Date getUserCreatedTime() {
        return userCreatedTime;
    }

    public void setUserCreatedTime(Date userCreatedTime) {
        this.userCreatedTime = userCreatedTime;
    }

    public String getUserCreator() {
        return userCreator;
    }

    public void setUserCreator(String userCreator) {
        this.userCreator = userCreator;
    }

    public int getUserDelFlag() {
        return userDelFlag;
    }

    public void setUserDelFlag(int userDelFlag) {
        this.userDelFlag = userDelFlag;
    }

    public int getUserFreezeFlag() {
        return userFreezeFlag;
    }

    public void setUserFreezeFlag(int userFreezeFlag) {
        this.userFreezeFlag = userFreezeFlag;
    }

    public String getUserLoginTime() {
        return userLoginTime;
    }

    public void setUserLoginTime(String userLoginTime) {
        this.userLoginTime = userLoginTime;
    }

    public int getChecked() {
        return checked;
    }

    public void setChecked(int checked) {
        this.checked = checked;
    }

    @Override
    public String toString() {
        return "SysUser{" +
                "id=" + id +
                ", userName='" + userName + '\'' +
                ", userLoginName='" + userLoginName + '\'' +
                ", userPassword='" + userPassword + '\'' +
                ", userTel='" + userTel + '\'' +
                ", userQq='" + userQq + '\'' +
                ", userEmail='" + userEmail + '\'' +
                ", userAddress='" + userAddress + '\'' +
                ", userCurrentAddress='" + userCurrentAddress + '\'' +
                ", userBirthday='" + userBirthday + '\'' +
                ", userLoginCount=" + userLoginCount +
                ", userUpdatedTime='" + userUpdatedTime + '\'' +
                ", userUpdator='" + userUpdator + '\'' +
                ", userCreatedTime='" + userCreatedTime + '\'' +
                ", userCreator='" + userCreator + '\'' +
                ", userDelFlag=" + userDelFlag +
                '}';
    }
}
