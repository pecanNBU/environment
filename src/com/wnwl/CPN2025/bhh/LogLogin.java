package com.wnwl.CPN2025.bhh;

/**
 * LogLogin  @author Jenny
 */

public class LogLogin implements java.io.Serializable {

    // Fields

    private Integer id;
    private UserInfo userInfo;
    private Integer dt;
    private Long ip;
    private String browser;

    // Constructors

    /**
     * default constructor
     */
    public LogLogin() {
    }

    /**
     * full constructor
     */
    public LogLogin(UserInfo userInfo, Integer dt, Long ip, String browser) {
        this.userInfo = userInfo;
        this.dt = dt;
        this.ip = ip;
        this.browser = browser;
    }

    // Property accessors

    public Integer getId() {
        return this.id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public UserInfo getUserInfo() {
        return this.userInfo;
    }

    public void setUserInfo(UserInfo userInfo) {
        this.userInfo = userInfo;
    }

    public Integer getDt() {
        return this.dt;
    }

    public void setDt(Integer dt) {
        this.dt = dt;
    }

    public Long getIp() {
        return this.ip;
    }

    public void setIp(Long ip) {
        this.ip = ip;
    }

    public String getBrowser() {
        return this.browser;
    }

    public void setBrowser(String browser) {
        this.browser = browser;
    }

}