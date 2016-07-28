package com.wnwl.CPN2025.yz;

import org.acegisecurity.AccessDeniedException;
import org.acegisecurity.ConfigAttributeDefinition;
import org.acegisecurity.intercept.web.FilterInvocation;
import org.acegisecurity.intercept.web.FilterInvocationDefinitionSource;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.util.AntPathMatcher;
import org.springframework.util.PathMatcher;

import javax.servlet.http.HttpServletRequest;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

/**
 * FilterInvocationDefinitionSource实现类
 *
 * @author sunjie
 * @since 2009-6-9
 */
public class UrlFilterInvocationDefinitionSource implements FilterInvocationDefinitionSource {

    protected static final Log logger = LogFactory.getLog(UrlFilterInvocationDefinitionSource.class);

    private UrlSecuredUrlDefinition urlInvocationDefinition;

    private PathMatcher pathMatcher = new AntPathMatcher();

    @SuppressWarnings("unchecked")
    public ConfigAttributeDefinition getAttributes(Object object) throws IllegalArgumentException {
        if ((object == null) || !this.supports(object.getClass())) {
            throw new IllegalArgumentException("抱歉，目标对象不是FilterInvocation类型");
        }
        // TODO 抽取出待请求的URL
        String url = ((FilterInvocation) object).getRequestUrl();
        HttpServletRequest req = ((FilterInvocation) object).getHttpRequest();
        String reqType = req.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equalsIgnoreCase(reqType) && null != reqType) {        //特指ajax请求
            return null;
        }
        if (url.indexOf("/login/login") >= 0 || url.indexOf("/img/") >= 0 || url.indexOf("/css/") >= 0
                || url.indexOf("/main/") >= 0 || url.indexOf("/login/exitlogin") >= 0 || url.indexOf("/js/") >= 0
                || url.indexOf("/files/") >= 0 || url.indexOf("/login/checkLogin") >= 0 || url.indexOf("/index.action") >= 0
                || url.indexOf("/msg/new_message.action") >= 0 || url.indexOf("/main.jsp") >= 0) {
            // 放过登录
            return null;
        }
        // TODO 获取所有UrlEntryHolder列表(url与角色集合对应列表)，如果没有，则返回null。
        List<UrlEntryHolder> urlEHs = getEntryHolderList();
        if (urlEHs == null || urlEHs.size() == 0) {
            return null;
        }
        // TODO 去掉待请求url参数信息，数据库中的url信息不带有参数
        int firstQuestionMarkIndex = url.indexOf("?");
        if (firstQuestionMarkIndex != -1) {
            url = url.substring(0, firstQuestionMarkIndex);
        }
        /*int firstQuestionMarkIndex2 = url.indexOf(".");
        if (firstQuestionMarkIndex2 != -1) {
			url = url.substring(0, firstQuestionMarkIndex2);
		}*/
        Iterator<UrlEntryHolder> iter = urlEHs.iterator();
        // TODO 循环判断用户是否有权限访问当前url,
        // 有则返回ConfigAttributeDefinition(角色集合)
        UrlEntryHolder entryHolder;
        String url1;
        boolean matched = false;
        //System.err.println(url);
        while (iter.hasNext()) {
            entryHolder = iter.next();
            // TODO 判断当前访问的url是否符合entryHolder.getUrl()模式,
            // 即判断用户是否有权限访问当前url，如url="/secure/index.jsp",
            // entryHolder.getUrl()="/secure/**", 则有权限访问
            url1 = entryHolder.getUrl();
            /*int firstQuestionMarkIndex3 = url1.indexOf(".");
            if (firstQuestionMarkIndex3 != -1) {
				url1 = url1.substring(0, firstQuestionMarkIndex3);
			}*/
            //url1 = url1.substring(0,2).equals("..")?url1.substring(2, url1.length()):url1;
            matched = pathMatcher.match(url1, url);
            /*if (logger.isDebugEnabled()) {
                logger.debug("匹配到如下URL： '" + url + "；模式为 " + entryHolder.getUrl() + "；是否被匹配：" + matched);
				System.out.println("匹配到如下URL： '" + url + "；模式为 " + entryHolder.getUrl() + "；是否被匹配：" + matched);
			}*/
            // TODO 如果在用户所有被授权的URL中能找到匹配的,
            // 则返回该ConfigAttributeDefinition(角色集合)
            if (matched) {
                return entryHolder.getCad();
            }
        }
        if (!matched)            //当未通过权限验证时抛出AccessDeniedException异常
            throw new AccessDeniedException("权限不足!");
        return null;

    }

    @SuppressWarnings("unchecked")
    public Iterator getConfigAttributeDefinitions() {
        Set set = new HashSet();
        Iterator iter = this.getEntryHolderList().iterator();
        while (iter.hasNext()) {
            UrlEntryHolder entryHolder = (UrlEntryHolder) iter.next();
            set.add(entryHolder.getCad());
        }
        return set.iterator();
    }

    public boolean supports(Class clazz) {
        return FilterInvocation.class.isAssignableFrom(clazz);
    }

    public List<UrlEntryHolder> getEntryHolderList() {
        // urlInvocationDefinition = new UrlSecuredUrlDefinition();
        return urlInvocationDefinition.getAllUrlEntryHolder();
    }

    public UrlSecuredUrlDefinition getUrlInvocationDefinition() {
        return urlInvocationDefinition;
    }

    public void setUrlInvocationDefinition(UrlSecuredUrlDefinition urlInvocationDefinition) {
        this.urlInvocationDefinition = urlInvocationDefinition;
    }

}
