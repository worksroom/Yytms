package com.youguu.demo.action;

public class Result {
    private boolean success;
    private String info;
    private Object data;//也可用来标识错误代码

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getInfo() {
        return info;
    }

    public void setInfo(String info) {
        this.info = info;
    }

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }

    public Result(boolean success, String info) {
        this.success = success;
        this.info = info;
    }

    public Result(boolean success, String info, Object data) {
        this.success = success;
        this.info = info;
        this.data = data;
    }
}