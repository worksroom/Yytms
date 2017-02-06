<%@ page language="java" pageEncoding="UTF-8" %>
<%@page import="com.youguu.util.ParameterUtil" %>
<%@page import="com.youguu.core.util.ParamUtil" %>
<%@page import="java.util.List" %>
<%@page import="com.youguu.user.pojo.Parameter" %>
<%@page import="com.youguu.util.AclCheck" %>
<%
    String menuId = ParamUtil.CheckParam(request.getParameter("menuId"),"");

    boolean flag = false;

    StringBuffer toolbar = new StringBuffer("");

    if(!"".equals(menuId)){
        List<Parameter> list = ParameterUtil.getParameterParentList(menuId);
        if(list!=null){

            toolbar.append("{");
            toolbar.append("items: [");

            for(int i=0;i<list.size();i++){
                Parameter p = list.get(i);
                String aclCode = p.getId();

                //权限判断
                if(p.getValue().equals("view") || !AclCheck.checkFunAcl(request,aclCode)){
                    continue;
                }

                flag = true;

                if(i==(list.size()-1)){
                    toolbar.append("{text: '" + p.getName() + "', click: " + p.getValue() + "Data, icon: '" + p.getValue() + "'}");
                } else {
                    toolbar.append("{text: '" + p.getName() + "', click: " + p.getValue() + "Data, icon: '" + p.getValue() + "'},");
                    toolbar.append("{line: true},");
                }
            }

            toolbar.append("]");
            toolbar.append("}");


        }
    }

    if(flag){
        out.print(toolbar);
    } else{
        out.print("null");
    }

%>
