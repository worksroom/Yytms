package com.youguu.ui;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.youguu.user.pojo.Parameter;

import javax.servlet.http.HttpServletRequest;
import java.util.List;


public class LigerUiToTreeJson implements IToTreeJson {

    private static final LigerUiToTreeJson instance = new LigerUiToTreeJson();

    private LigerUiToTreeJson() {
    }

    public static LigerUiToTreeJson getInstance() {
        return instance;
    }

    public String privilegeTreeJson(Parameter parameter, HttpServletRequest request) {
        JSONArray jsonArray = new JSONArray();

        if(parameter==null){
            return new JSONObject().toJSONString();
        }
        jsonArray.add(LigerUiToTree.getInstance().privilegeTree(parameter, request).toTree());
        return jsonArray.toString();
    }

    @Override
    public String commonTreeJson(Parameter parameter, HttpServletRequest request) {
        JSONArray jsonArray = new JSONArray();

        if(parameter==null){
            return new JSONObject().toJSONString();
        }
        jsonArray.add(LigerUiToTree.getInstance().commonTree(parameter, request).toTree());
        return jsonArray.toString();
    }

    @Override
    public String roleTreeJson(Parameter parameter, List<String> mList, HttpServletRequest request) {
        JSONArray jsonArray = new JSONArray();

        if(parameter==null){
            return new JSONObject().toJSONString();
        }
        jsonArray.add(LigerUiToTree.getInstance().roleTree(parameter, mList, request).toTree());
        return jsonArray.toString();
    }

}
