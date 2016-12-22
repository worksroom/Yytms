package com.youguu.util;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 调用 HttpServletResponse 对象的getWriter().println()输出数据到前台，
 * 并且这里设置编码格式为utf-8格式
 * 这样子可以解决很多response输出数据乱码问题
 */
public class ResponseUtil {

    /**
     * 调用response对象来输出数据，并且设置编码为utf-8
     *
     * @param resp
     * @param message
     */
    public static void println(HttpServletResponse resp, String message){
        try {
            resp.setContentType("text/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().println(message);
            resp.getWriter().flush();
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    /**
     * 调用response对象来输出数据，并且设置编码为utf-8
     *
     * @param resp
     * @param jsonArray
     */
    public static void println(HttpServletResponse resp, JSONArray jsonArray) {
        println(resp, jsonArray.toString());
    }

    /**
     * 调用response对象来输出数据，并且设置编码为utf-8
     *
     * @param resp
     * @param json
     */
    public static void println(HttpServletResponse resp, JSONObject json) {
        println(resp, json.toString());
    }


}
