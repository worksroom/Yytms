package com.youguu.ui;

import com.youguu.user.pojo.Parameter;

import javax.servlet.http.HttpServletRequest;
import java.util.List;


public interface IToTreeJson {

	public String privilegeTreeJson(Parameter parameter, HttpServletRequest request);

	public String commonTreeJson(Parameter parameter, HttpServletRequest request);

	public String roleTreeJson(Parameter parameter, List<String> mList, HttpServletRequest request);
}