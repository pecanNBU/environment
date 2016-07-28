package com.wnwl.CPN2025.util;

public class PageBean {
    //注意，这里没有final
    private static PageBean single;

    //只实例化一次
    static {
        single = new PageBean();
    }

    private long count = 0;
    private int pageSize = 10;
    private int pageCount = 0;
    private int page = 1;
    private String url;       //改造新增
    private String condition; //查询条件
    private String orderitem;
    private String uord;
    private int[] pageCountList = new int[]{5, 10, 50, 100, 200};  //控制页面显示数据的条数

    private PageBean() {
    }

    //静态工厂方法
    public synchronized static PageBean getInstance() {
        if (single == null) {
            single = new PageBean();
        }
        return single;
    }

    public long getCount() {
        return count;
    }

    public void setCount(long count) {
        if (pageSize != 0) {
            pageCount = (int) count / pageSize;
            if (count % pageSize != 0) {
                pageCount++;
            }
        }
        this.count = count;
    }

    public int getPage() {
        return page;
    }

    public void setPage(int page) {
        this.page = page;
    }

    public int getPageCount() {
        return pageCount;
    }

    public void setPageCount(int pageCount) {
        this.pageCount = pageCount;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getCondition() {
        return condition;
    }

    public void setCondition(String condition) {
        this.condition = condition;
    }

    public String getOrderitem() {
        if (null == orderitem || "" == orderitem) {
            orderitem = "id";
        }
        return orderitem;
    }

    public void setOrderitem(String orderitem) {
        this.orderitem = orderitem;
    }

    public String getUord() {
        if (null == uord || "" == uord) {
            uord = "asc";
        }
        return uord;
    }

    public void setUord(String uord) {
        this.uord = uord;
    }

    /**
     * @return the pageCountList
     */
    public int[] getPageCountList() {
        return pageCountList;
    }

    /**
     * @param pageCountList the pageCountList to set
     */
    public void setPageCountList(int[] pageCountList) {
        this.pageCountList = pageCountList;
    }

    public void setPageBean(long count, int page, int pageSize, String url) {
        this.setPage(page == 0 ? 1 : page);
        this.setPageSize(pageSize == 0 ? 50 : pageSize);
        this.setCount(count);
        this.setUrl(url);
    }
}
