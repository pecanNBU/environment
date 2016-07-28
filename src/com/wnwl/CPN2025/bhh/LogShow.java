package com.wnwl.CPN2025.bhh;

/**
 * LogShow  @author Jenny
 */

public class LogShow implements java.io.Serializable {

    // Fields

    private Integer id;
    private Integer userId;
    private Integer dt;
    private String url;

    // Constructors

    /**
     * default constructor
     */
    public LogShow() {
    }

    /**
     * full constructor
     */
    public LogShow(Integer userId, Integer dt, String url) {
        this.userId = userId;
        this.dt = dt;
        this.url = url;
    }

    // Property accessors

    public Integer getId() {
        return this.id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getUserId() {
        return this.userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getDt() {
        return this.dt;
    }

    public void setDt(Integer dt) {
        this.dt = dt;
    }

    public String getUrl() {
        return this.url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

}