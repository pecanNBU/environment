package com.wnwl.CPN2025.interceptor;

import org.acegisecurity.Authentication;
import org.acegisecurity.context.SecurityContextHolder;
import org.acegisecurity.userdetails.UserDetails;

import javax.servlet.*;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class OnlineFilter extends HttpServlet implements Filter {
    private static final long serialVersionUID = 8124303505064808057L;

    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/login/login_null.jsp");// 这里设置如果没有登录将要转发到的页面
        HttpServletRequest req = (HttpServletRequest) request;
        String reqType = req.getHeader("X-Requested-With");
        HttpServletResponse res = (HttpServletResponse) response;
        //System.out.println(req.getRequestURI());
        // System.out.println(((HttpServletRequest) request).getRequestURI());
        // 从acegi中取用户信息
        String loginName = null;
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            UserDetails ud = (UserDetails) auth.getPrincipal();
            loginName = ud.getUsername();
        } catch (Exception e) {
            loginName = null;
        }
        if (loginName == null) {
            // 判断如果没有取到用户信息,就跳转到登录页面
            // String url = req.getRequestURI() + "?" + req.getQueryString();
            String url = req.getRequestURI();
            url = url.substring(6, url.length());
            //System.err.println(url);
            if (url.indexOf("login.jsp") >= 0 || url.indexOf("logins") >= 0 || url.indexOf("img/") >= 0
                    || url.indexOf("css/") >= 0 || url.indexOf("main.jsp") >= 0 || url.indexOf("exitLogin") >= 0
                    || url.indexOf("login_null") >= 0 || url.indexOf("js/") >= 0 || url.indexOf("checkLogin") >= 0
                    || (url.indexOf("concurrentError") >= 0 && (!"XMLHttpRequest".equalsIgnoreCase(reqType) || null == reqType))) {
                // 放过登录
                chain.doFilter(request, response);
            } else if ("login/concurrentError.jsp".equalsIgnoreCase(url)) {        //此帐号已在别处登录
                if ("XMLHttpRequest".equalsIgnoreCase(reqType) && null != reqType) {
                    res.setHeader("sessionStatus", "ajaxCurrentError");
                } else {
                    dispatcher.forward(request, response);                //url请求返回dispatcher配置的页面
                    // System.out.println("用户没有登录，不允许操作");
                    res.setHeader("Cache-Control", "no-store");
                    res.setDateHeader("Expires", 0);
                    res.setHeader("Pragma", "no-cache");
                }
            } else {
                //未登录，返回对应数据
                if ("XMLHttpRequest".equalsIgnoreCase(reqType) && null != reqType) {
                    res.setHeader("sessionStatus", "ajaxSessionTimeOut");
                    //getResponseHeader("sessionStatus")=="ajaxSessionTimeOut"
                } else {
                    dispatcher.forward(request, response);                //url请求返回dispatcher配置的页面
                    // System.out.println("用户没有登录，不允许操作");
                    res.setHeader("Cache-Control", "no-store");
                    res.setDateHeader("Expires", 0);
                    res.setHeader("Pragma", "no-cache");
                }
            }
        } else {
            // 已经登录,继续此次请求
            chain.doFilter(request, response);
            // System.out.println("用户已经登录，允许操作");
        }
    }

    public void init(FilterConfig filterConfig) throws ServletException {

    }

}