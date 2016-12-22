package com.youguu.user.dao;

import com.youguu.core.util.PageHolder;
import com.youguu.user.pojo.Parameter;

import java.util.List;
import java.util.Map;

/**
 * Created by SomeBody on 2016/8/15.
 */
public interface IParameterDAO {
    /**
     * 查询所有的参数
     * @return
     */
    public List<Parameter> queryAll();

    /**
     * @Title: queryAll
     * @Description: 查询全部 分页
     * @param pageIndex
     * @param pageSize
     * @return
     * PageHolder<Parameter>    返回类型
     */
    public PageHolder<Parameter> queryAll(int pageIndex, int pageSize);

    /**
     * 查询某一类型所有的参数
     * @param type 类型
     * @param orderBy 排序条件  默认按照时间倒叙
     * @return
     */
    public List<Parameter> queryType(String type,String orderBy);
    /**
     * 根据查询参数
     * @param id
     * @return
     */
    public Parameter queryId(String id);
    /**
     * 按照参数查询
     * hm
     * key:
     * id:id
     * parentid:父节点
     * name : 名称查询（模糊查询）
     * type:类型
     * @return
     */
    public List<Parameter> query(Map<String,Object> hm);

    /**
     * 按照参数查询 分页
     * hm
     * key:
     * id:id
     * parentid:父节点
     * name : 名称查询（模糊查询）
     * type:类型
     * @param pageSize
     * @return
     */
    public PageHolder<Parameter> query(Map<String,Object> hm,int pageIndex, int pageSize);

    /**
     * @Title: delete
     * @Description: 通过ID删除
     * @param id
     * @return
     * int    返回类型
     */
    public int delete(String id);

    /**
     * @Title: insert
     * @Description: 插入
     * @param param
     * @return
     * int    返回类型
     */
    public int insert(Parameter param);

    /**
     * @Title: update
     * @Description: 更新
     * @param param
     * @return
     * int    返回类型
     */
    public int update(Parameter param);

    /**
     * 递归查询id下所有子节点
     * @param id
     * @return
     */
    public List<Parameter> queryTreeParameter(String id);

    public List<Parameter> findParameterByPid(String pid);
}
