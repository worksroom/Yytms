package com.youguu.user.dao.impl;

import com.youguu.core.util.PageHolder;
import com.youguu.user.dao.IParameterDAO;
import com.youguu.user.pojo.Parameter;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by SomeBody on 2016/8/15.
 */
@Repository
public class ParameterDAO extends LakesideDAO<Parameter> implements IParameterDAO {
    @Override
    public List<Parameter> queryAll() {
        return this.findBy("findByParams", null);
    }

    @Override
    public PageHolder<Parameter> queryAll(int pageIndex, int pageSize) {
        return this.pagedQuery("findByParams", null, pageIndex, pageSize);
    }

    @Override
    public List<Parameter> queryType(String type, String orderBy) {
        if (orderBy == null || "".equals(orderBy)) {
            orderBy = " createtime desc ";
        }
        HashMap<String, Object> hm = new HashMap<String, Object>();
        hm.put("type", type);
        hm.put("cols", orderBy);
        return this.findBy("findByParams", hm);
    }

    @Override
    public Parameter queryId(String id) {
        HashMap<String, Object> hm = new HashMap<String, Object>();
        hm.put("id", id);
        return this.findUniqueBy("findByParams", hm);
    }

    @Override
    public List<Parameter> query(Map<String, Object> hm) {
        if (hm != null && !hm.containsKey("cols")) {
            hm.put("cols", " createtime desc ");
        }
        return this.findBy("findByParams", hm);
    }

    @Override
    public PageHolder<Parameter> query(Map<String, Object> hm, int pageIndex, int pageSize) {
        if (hm != null && !hm.containsKey("cols")) {
            hm.put("cols", " createtime desc ");
        }
        return this.pagedQuery("findByParams", hm, pageIndex, pageSize);
    }

    @Override
    public int delete(String id) {
        return this.deleteBy("deleteById", id);
    }

    @Override
    public List<Parameter> queryTreeParameter(String id) {
        List<Parameter> sublist = findParameterByPid(id);
        return sublist;
    }

    /**
     * @param id
     * @return List<Parameter>    返回类型
     * @Title: getParamById
     * @Description: 查询这个id下的子节点和自身
     */
    @Override
    public List<Parameter> findParameterByPid(String id) {
        return this.findBy("findByIdOrParentid", id);
    }

}
