package com.youguu.product.vo;

import java.util.List;

/**
 * Created by leo on 2017/2/21.
 */
public class ProComboBoxVO {

    private int id;
    private String name;
    private int isMultiple;
    private int isNeed;
    private int isSku;

    private List<ProValueVO> list;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getIsMultiple() {
        return isMultiple;
    }

    public void setIsMultiple(int isMultiple) {
        this.isMultiple = isMultiple;
    }

    public int getIsNeed() {
        return isNeed;
    }

    public void setIsNeed(int isNeed) {
        this.isNeed = isNeed;
    }

    public int getIsSku() {
        return isSku;
    }

    public void setIsSku(int isSku) {
        this.isSku = isSku;
    }

    public List<ProValueVO> getList() {
        return list;
    }

    public void setList(List<ProValueVO> list) {
        this.list = list;
    }
}
