package com.youguu.util;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.youguu.core.util.PageHolder;
import com.youguu.user.pojo.Parameter;

import java.lang.reflect.Method;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

/**
 * Created by SomeBody on 2016/8/15.
 */
public class LigerUiToGrid {


    public static String toGridJSON(PageHolder<?> pageHolder,
                                    String[] cols, String[] replaceCols) {

        JSONObject jsonObject = new JSONObject();
        jsonObject.put("Total", pageHolder.getTotalCount());

        JSONArray dataArray = new JSONArray();

        int i = 0;
        int start = pageHolder.getPageSize() * (pageHolder.getPageIndex() - 1);
        for (Object obj : pageHolder.getList()) {
            i++;

            // 生成Id属性
            String id = getPropertyValue(obj, "id");
            if (id.equals("") || "0".equals(id)) {
                id = Integer.toString(i + start);
            }
            dataArray.add(getPorpertyValues(id, obj, cols, replaceCols));
        }

        jsonObject.put("Rows", dataArray);

        return jsonObject.toJSONString();
    }

    public static String getPropertyValue(Object obj, String property) {
        if (property == null || property.trim().equals(""))
            return "";

        Class<?> clazz = obj.getClass();
        Method m;
        try {
            m = clazz.getMethod("get"
                    + property.substring(0, 1).toUpperCase()
                    + property.substring(1));
            Object v = m.invoke(obj);
            if (v == null)
                return "";

            // 格式化日期
            if (v instanceof Date) {
                return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(v);
            }
            if ((v instanceof Long)
                    && ((property.indexOf("time") >= 0)
                    || property.indexOf("Time") >= 0 || property
                    .indexOf("Date") >= 0)) {
                return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(v);
            }

            // 处理列表
            if (v instanceof List) {
                String s = "";
                for (Object item : (List<?>) v) {
                    if (s.length() > 0) {
                        s += ",";
                    }
                    s += item.toString();
                }
                return s;
            }

            // 处理数组
            if (v instanceof String[]) {
                String s = "";
                for (Object item : (String[]) v) {
                    if (s.length() > 0) {
                        s += ",";
                    }
                    s += item.toString();
                }
                return s;
            }

            // 对摘要做转换
            // if(property.equals("brief") || property.equals("longTitle") ||
            // property.equals("shortTitle")){
            // return "<![CDATA[" + v.toString() + "]]>";
            // }

            return v.toString();
        } catch (Exception e) {
            //			e.printStackTrace();
            return "";
        }
    }

    public static JSONObject getPorpertyValues(String id, Object obj, String[] cols, String[] replaceCols) {
        JSONObject rowObject = new JSONObject();
        rowObject.put("id", id);
        if (cols == null || cols.length == 0)
            return rowObject;

        // 初始化字典字段列表
        List<String> replaceList;
        if (replaceCols != null && replaceCols.length > 0) {
            replaceList = Arrays.asList(replaceCols);
        } else {
            replaceList = new ArrayList<>();
        }

        for (int i = 0; i < cols.length; i++) {
            String value = getPropertyValue(obj, cols[i]);
            // 提取数据字典名称
//            if (replaceList.contains(cols[i]) && !s.equals("")) {
//                Parameter p = ParameterUtil.getParameter(s);
//                if (p != null) {
//                    s = p.getName();
//                }
//            }
            rowObject.put(cols[i], value);
        }
        return rowObject;
    }

    public static String menuListToGrid(List<Parameter> menuList){
        if(menuList == null){

            JSONObject json = new JSONObject();
            json.put("Rows", 0);
            json.put("Total", 0);

            return json.toString();
        }

        JSONObject json = new JSONObject();

        JSONArray children = new JSONArray();

        for(Parameter menu: menuList){
            children.add(menuToGrid(menu));
        }

        json.put("Rows", children);
        return json.toJSONString();
    }

    public static JSONObject menuToGrid(Parameter parameter){
        JSONObject json = new JSONObject();

        json.put("id", parameter.getId());
        json.put("name", parameter.getName());
        json.put("desc", parameter.getValue());
        json.put("url", parameter.getValue());
        json.put("pid", parameter.getParentId());

        JSONArray children = new JSONArray();

        //递归遍历子节点menu
        List<Parameter> list = ParameterUtil.getParameterParentList(parameter.getId());
        if (list!=null && list.size()>0) {
            for (Parameter p : list) {
                children.add(menuToGrid(p));
            }
        }

        //如果有节点或者子资源，那么久加入到children中
        if(children.size() > 0)
            json.put("children", children);

        return json;
    }
}
