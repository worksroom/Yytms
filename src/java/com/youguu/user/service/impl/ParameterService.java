package com.youguu.user.service.impl;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.youguu.core.logging.Log;
import com.youguu.core.logging.LogFactory;
import com.youguu.core.util.PageHolder;
import com.youguu.user.dao.impl.ParameterDAO;
import com.youguu.user.pojo.Parameter;
import com.youguu.user.service.IParameterService;
import com.youguu.util.ParameterUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("parameterService")
public class ParameterService implements IParameterService {
    /**
     * 获取log4j 输出类
     */
    private static Log logger = LogFactory.getLog("");
    /**
     * 静态参数处理类
     */
    @Resource
    private ParameterDAO parameterDAO;

    /**
     * 按照参数查询
     * hm
     * key:
     * id:id
     * parentid:父节点
     * type:类型
     *
     * @return
     */
    @Override
    public List<Parameter> query(Map<String, Object> hm) {
        logger.debug("query start....");
        if (hm != null && !hm.containsKey("cols")) {
            hm.put("cols", " createtime desc ");
        }
        return parameterDAO.findBy("findByParams", hm);
    }

    /**
     * 查询所有的参数
     *
     * @return
     */
    @Override
    public List<Parameter> queryAll() {
        logger.debug("queryAll start....");
        List<Parameter> result = new ArrayList<>();
        result = parameterDAO.findBy("findByParams", null);
        logger.debug("queryAll end....");
        return result;
    }

    /**
     * 根据查询参数
     *
     * @param id
     * @return
     */
    @Override
    public Parameter queryId(String id) {
        logger.debug("queryId start....");
        Parameter result = null;
        HashMap<String, Object> hm = new HashMap<String, Object>();
        hm.put("id", id);
        result = parameterDAO.findUniqueBy("findByParams", hm);
        logger.debug("queryId end....");
        return result;
    }

    /**
     * 查询某一类型所有的参数
     *
     * @param type    类型
     * @param orderBy 排序条件  默认按照时间倒叙
     * @return
     */
    @Override
    public List<Parameter> queryType(String type, String orderBy) {
        logger.debug("queryType start....");
        List<Parameter> result = new ArrayList<>();
        if (orderBy == null || "".equals(orderBy)) {
            orderBy = " createtime desc ";
        }
        HashMap<String, Object> hm = new HashMap<String, Object>();
        hm.put("type", type);
        hm.put("cols", orderBy);
        result = parameterDAO.findBy("findByParams", hm);

        logger.debug("queryType end....");
        return result;
    }

    @Override
    public int delete(String id) {

        return parameterDAO.delete(id);
    }

    @Override
    public int insert(Parameter param) {
        logger.debug("insert start....");
        int result = parameterDAO.insert(param);
        logger.debug("insert end....");
        return result;
    }

    @Override
    public int update(Parameter param) {
        logger.debug("update start....");
        int result = parameterDAO.update(param);
        logger.debug("update end....");
        return result;
    }

    @Override
    public PageHolder<Parameter> queryAll(int pageIndex, int pageSize) {
        logger.debug("queryAll start....");
        PageHolder<Parameter> result = new PageHolder<Parameter>();
        result = parameterDAO.pagedQuery("findByParams", null, pageIndex, pageSize);
        logger.debug("queryAll end....");
        return result;
    }

    @Override
    public PageHolder<Parameter> query(Map<String, Object> hm, int pageIndex,
                                       int pageSize) {
        logger.debug("query start....");
        if (hm != null && !hm.containsKey("cols")) {
            hm.put("cols", " createtime desc ");
        }
        return parameterDAO.pagedQuery("findByParams", hm, pageIndex, pageSize);
    }


    @Override
    public String queryTreeParameter(String id) {
        List<Parameter> menuList = parameterDAO.queryTreeParameter(id);
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

    @Override
    public List<Parameter> findParameterByPid(String pid) {
        return parameterDAO.findParameterByPid(pid);
    }

    public static JSONObject menuToGrid(Parameter parameter){
        JSONObject json = new JSONObject();

        json.put("id", parameter.getId());
        json.put("name", parameter.getName());
        json.put("desc", parameter.getValue());
        json.put("url", parameter.getValue());
        json.put("pid", parameter.getParentId());
        json.put("exp2", parameter.getExp2());

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
