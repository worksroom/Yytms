package com.youguu.util;

import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

public abstract class WebUtils {
	private final static String attrName="org.springframework.web.struts.ContextLoaderPlugIn.CONTEXT.";
	
	public static <T> T getBean(HttpServletRequest request,String name,Class<T> clazz) {
		return getBean(request.getSession().getServletContext(),name,clazz);
	}
	public static <T> T getBean(ServletContext servletContext,String name,Class<T> clazz) {
		ApplicationContext ctx= WebApplicationContextUtils.getWebApplicationContext(servletContext);
		if(ctx==null) ctx= WebApplicationContextUtils.
				getWebApplicationContext(servletContext, attrName);
		return ctx.getBean(name,clazz);
	}

}
