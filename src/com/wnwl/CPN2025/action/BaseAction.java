package com.wnwl.CPN2025.action;

import com.opensymphony.xwork2.ActionSupport;
import org.apache.struts2.interceptor.*;
import org.apache.struts2.util.ServletContextAware;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

public class BaseAction extends ActionSupport implements RequestAware, ServletRequestAware,
        SessionAware, ApplicationAware, ServletContextAware, ServletResponseAware {
    private static final long serialVersionUID = 3271591412540669256L;
    /**
     * 本页面主要提供六个主要的接口
     */
    protected Map<String, Object> request;
    protected HttpServletRequest httpRequest;
    protected HttpServletResponse httpResponse;
    protected Map<String, Object> session;
    protected Map<String, Object> application;
    protected ServletContext context;

    public void setServletContext(ServletContext arg0) {
        this.context = arg0;

    }

    public void setApplication(Map<String, Object> arg0) {
        this.application = arg0;

    }

    public void setSession(Map<String, Object> arg0) {
        this.session = arg0;

    }

    public void setServletRequest(HttpServletRequest arg0) {
        this.httpRequest = arg0;

    }

    public void setServletResponse(HttpServletResponse arg0) {
        this.httpResponse = arg0;
    }

    public void setRequest(Map<String, Object> arg0) {
        this.request = arg0;

    }

}