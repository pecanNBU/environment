package com.wnwl.CPN2025.util;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServlet;

public class StartListener extends HttpServlet {
    private static final long serialVersionUID = -3588943183888629111L;

    public StartListener() {

    }

    public void init() {        //tomcat启动后自动运行该方法
        try {
            ServletContext sc = getServletContext();
            WebApplicationContext ac = WebApplicationContextUtils.getRequiredWebApplicationContext(sc);
            /*RegConditionService regConditionService = (RegConditionService)ac.getBean("regConditionService");
            System.out.println("-----tomcat start------");
			Date systemStDt = new Date();	//系统开始运行
			regConditionService.setSystemStDt(systemStDt);*/
            //regConditionService.readRegister();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}  