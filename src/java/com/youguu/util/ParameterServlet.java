package com.youguu.util;

import com.youguu.user.service.IParameterService;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * 类描述：系统启动时，将静态参数表数据加载到内存
 */
public class ParameterServlet extends HttpServlet {

    /**
     *
     */
    private static final long serialVersionUID = 1L;

    public ParameterServlet() {
        super();
    }

    @Override
    public void destroy() {
        super.destroy();
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ParameterUtil.InitParameter(request);
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("Init....Ok!");
        out.flush();
        out.close();
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        this.doGet(request, response);
    }

    @Override
    public void init(ServletConfig config) throws ServletException {
        IParameterService parameterService = WebUtils.getBean(config.getServletContext(), "parameterService", IParameterService.class);
        ParameterUtil.InitParameter(parameterService);
    }

}
