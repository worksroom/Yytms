package com.youguu.user.dao.impl;

import com.youguu.core.dao.SqlDAO;
import org.apache.ibatis.session.SqlSessionFactory;

import javax.annotation.Resource;

/**
 * Created by SomeBody on 2016/8/14.
 */
public class LakesideDAO<T> extends SqlDAO<T> {
    public LakesideDAO() {
        super();
        setUseSimpleName(true);
    }

    @Resource(name = "lakesideSessionFactory")
    @Override
    public void setSqlSessionFactory(SqlSessionFactory sqlSessionFactory) {
        super.setSqlSessionFactory(sqlSessionFactory);
    }
}
