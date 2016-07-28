package com.wnwl.CPN2025.bhh;

/**
 * UserInfo  @author Jenny
 */

public class UserInfo implements java.io.Serializable {

    // Fields

    private Integer id;
    private UserDetail userDetail;
    private String loginName;
    private String loginPwd;
    private String userName;
    private Short isUse;

    // Constructors

    /**
     * default constructor
     */
    public UserInfo() {
    }

    /**
     * full constructor
     */
    public UserInfo(UserDetail userDetail, String loginName, String loginPwd, String userName, Short isUse) {
        this.userDetail = userDetail;
        this.loginName = loginName;
        this.loginPwd = loginPwd;
        this.userName = userName;
        this.isUse = isUse;
    }

    // Property accessors

    public Integer getId() {
        return this.id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public UserDetail getUserDetail() {
        return userDetail;
    }

    public void setUserDetail(UserDetail userDetail) {
        this.userDetail = userDetail;
    }

    public String getLoginName() {
        return this.loginName;
    }

    public void setLoginName(String loginName) {
        this.loginName = loginName;
    }

    public String getLoginPwd() {
        return this.loginPwd;
    }

    public void setLoginPwd(String loginPwd) {
        this.loginPwd = loginPwd;
    }

    public String getUserName() {
        return this.userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public Short getIsUse() {
        return this.isUse;
    }

    public void setIsUse(Short isUse) {
        this.isUse = isUse;
    }

}