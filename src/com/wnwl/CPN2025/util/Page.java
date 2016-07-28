/**
 * @Title: Page.java
 * @Package: com.tds.util
 * @Description: TODO
 * @author: 198910310@qq.com
 * @date 2011-7-29下午3:44:05
 * @version V1.0
 */
package com.wnwl.CPN2025.util;

import java.util.List;

/**
 * @ClassName: Page
 * @Description: TODO
 * @author: 198910310@qq.com
 * @date 2011-7-29下午3:44:05
 */
public class Page {
    //注意，这里没有final
    private static Page single;

    //只实例化一次
    static {
        single = new Page();
    }

    private List fieldslist; // 分页返回对象列表
    private String pageSize;       //每页显示的条数
    private String jumpPage;        //当前页码
    private String totalNum;       //所有记录数
    private String totallPage;     //总页数
    private String styleClass;     //样式
    private String theme;  //主题
    private String url;  //action路径
    private String urlType; //路径的类型，用于以后路径的重写扩展
    private String pageInfo;  //分页的内容

    private Page() {
    }

    //静态工厂方法
    public synchronized static Page getInstance() {

        return new Page();
    }

    public List getFieldslist() {
        return fieldslist;
    }

    public void setFieldslist(List fieldslist) {
        this.fieldslist = fieldslist;
    }

    public String getPageSize() {
        return pageSize;
    }

    public void setPageSize(String pageSize) {
        this.pageSize = pageSize;
    }

    public String getJumpPage() {
        return jumpPage;
    }

    public void setJumpPage(String jumpPage) {
        this.jumpPage = jumpPage;
    }

    public String getTotalNum() {
        return totalNum;
    }

    public void setTotalNum(String totalNum) {
        this.totalNum = totalNum;
    }

    public String getTotallPage() {
        return totallPage;
    }

    public void setTotallPage(String totallPage) {
        this.totallPage = totallPage;
    }

    public String getStyleClass() {
        return styleClass;
    }

    public void setStyleClass(String styleClass) {
        this.styleClass = styleClass;
    }

    public String getTheme() {
        return theme;
    }

    public void setTheme(String theme) {
        this.theme = theme;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getUrlType() {
        return urlType;
    }

    public void setUrlType(String urlType) {
        this.urlType = urlType;
    }

    public String getPageInfo() {
        return pageInfo;
    }

    public void setPageInfo(String pageInfo) {
        this.pageInfo = pageInfo;
    }
}
