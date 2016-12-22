package com.youguu.util;


import com.youguu.user.pojo.Parameter;
import com.youguu.user.service.IParameterService;

import javax.servlet.http.HttpServletRequest;
import java.util.*;

/**
 * 静态参数表的type类型
 * 1.初始化静态参数
 * 2.提供外部初始化静态参数的接口
 * 3.提供通过ID查询
 * 4.提供通过类别查询
 * 5.提供通过父ID查询
 *
 * @author wd
 */
public class ParameterUtil {
    /**
     * 栏目节点的类型
     */

    public final static String MENU = "99990001";

    /**
     * 操作类型
     */
    public final static String ACTION = "99990002";

    /**
     * 栏目父节点ID
     */
    public final static String MENU_PARENT = "0002";

    // 评论来源类型
    public final static String INFO_PLLY = "99999010";

    // 文章状态
    public final static String INFO_STATUS = "99999004";

    // 专题类型
    public final static String STOPIC_TYPE = "99999011";

    // 友链类型
    public final static String Links_TYPE = "99999013";

    /**
     * 团队报名成绩查询web接口路径配置
     */
    public final static String WEB_URL_PATH = "properties/webUrlPath.properties";

    /**
     * 查询团队成绩排行
     */
    public final static String TEAM_RANK_URL_PATH = "team_rank_url_path";

    /**
     * 查询团队人员成绩排行
     */
    public final static String PERSON_RANK_URL_PATH = "person_rank_url_path";

    /**
     * 静态参数列表
     */
    private static LinkedHashMap<String, Parameter> paramHm = new LinkedHashMap<String, Parameter>();

    /**
     * 静态类型对应列表
     */
    private static LinkedHashMap<String, List<Parameter>> paramHmList = new LinkedHashMap<String, List<Parameter>>();

    /**
     * 树形结构
     */
    private static LinkedHashMap<String, List<Parameter>> paramTreeHm = new LinkedHashMap<String, List<Parameter>>();

    /**
     * 初始化静态参数表
     */
    public static void InitParameter(HttpServletRequest request) {
        IParameterService parameterService = WebUtils.getBean(request, "parameterService", IParameterService.class);
        InitParameter(parameterService);
    }

    public static void InitParameter(IParameterService parameterService) {
        System.out.println("InitParameter start....");
        HashMap<String, Object> hm = new HashMap<String, Object>();
        hm.put("cols", " id ");

        List<Parameter> list = null;

        try {
            list = parameterService.query(hm);
            if (list != null && list.size() > 0) {
                // 数据清理
                LinkedHashMap<String, Parameter> paramHm_temp = new LinkedHashMap<String, Parameter>();
                LinkedHashMap<String, List<Parameter>> paramHmList_temp = new LinkedHashMap<String, List<Parameter>>();
                LinkedHashMap<String, List<Parameter>> paramTreeHm_temp = new LinkedHashMap<String, List<Parameter>>();
                for (Parameter p : list) {
                    // 1.静态对应关系
                    paramHm_temp.put(p.getId(), p);
                    // 2.类别对应关系
                    if (paramHmList_temp.containsKey(p.getType())) { // 数据已经存在
                        paramHmList_temp.get(p.getType()).add(p);
                    } else {// 建立list
                        List<Parameter> temp = new ArrayList<Parameter>();
                        temp.add(p);
                        paramHmList_temp.put(p.getType(), temp);
                    }
                    // 3.树形结果关系
                    if (paramTreeHm_temp.containsKey(p.getParentId())) {
                        paramTreeHm_temp.get(p.getParentId()).add(p);
                    } else {
                        List<Parameter> temp = new ArrayList<Parameter>();
                        temp.add(p);
                        paramTreeHm_temp.put(p.getParentId(), temp);
                    }
                }
                // 数据重新引用
                paramHm.clear();
                paramHmList.clear();
                paramTreeHm.clear();

                paramHm = paramHm_temp;
                paramHmList = paramHmList_temp;
                paramTreeHm = paramTreeHm_temp;

                paramHm_temp = null;
                paramHmList_temp = null;
                paramTreeHm_temp = null;
                System.out.println("InitParameter end....");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 通过ID获取静态参数
     *
     * @param code
     * @return
     */
    public static Parameter getParameter(String code) {
        Parameter p = paramHm.get(code);
        return p;
    }

    /**
     * 通过类型获取静态参数列表
     *
     * @param type
     * @return
     */
    public static List<Parameter> getParameterTypeList(String type) {
        List<Parameter> list = paramHmList.get(type);
        return list;
    }

    /**
     * 通过类型获取静态参数key-value
     *
     * @param type
     * @return
     */
    public static Map<String, Parameter> getParameterTypeMap(String type) {
        Map<String, Parameter> map = new HashMap<String, Parameter>();
        List<Parameter> list = paramHmList.get(type);
        for (Parameter p : list) {
            map.put(p.getId(), p);
        }
        return map;
    }

    /**
     * 通过父节点获取静态参数列表
     *
     * @param parentId
     * @return
     */
    public static List<Parameter> getParameterParentList(String parentId) {
        List<Parameter> list = paramTreeHm.get(parentId);
        return list;
    }

}
