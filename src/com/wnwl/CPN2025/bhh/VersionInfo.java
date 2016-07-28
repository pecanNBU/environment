package com.wnwl.CPN2025.bhh;

/**
 * VersionInfo  @author Jenny
 */

public class VersionInfo implements java.io.Serializable {

    // Fields

    private Integer id;
    private UserInfo userInfoByApprUserId;
    private UserInfo userInfoByChargeUserId;
    private String version;
    private Integer dt;
    private String comment;

    // Constructors

    /**
     * default constructor
     */
    public VersionInfo() {
    }

    /**
     * full constructor
     */
    public VersionInfo(UserInfo userInfoByApprUserId,
                       UserInfo userInfoByChargeUserId, String version, Integer dt,
                       String comment) {
        this.userInfoByApprUserId = userInfoByApprUserId;
        this.userInfoByChargeUserId = userInfoByChargeUserId;
        this.version = version;
        this.dt = dt;
        this.comment = comment;
    }

    // Property accessors

    public Integer getId() {
        return this.id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public UserInfo getUserInfoByApprUserId() {
        return this.userInfoByApprUserId;
    }

    public void setUserInfoByApprUserId(UserInfo userInfoByApprUserId) {
        this.userInfoByApprUserId = userInfoByApprUserId;
    }

    public UserInfo getUserInfoByChargeUserId() {
        return this.userInfoByChargeUserId;
    }

    public void setUserInfoByChargeUserId(UserInfo userInfoByChargeUserId) {
        this.userInfoByChargeUserId = userInfoByChargeUserId;
    }

    public String getVersion() {
        return this.version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public Integer getDt() {
        return this.dt;
    }

    public void setDt(Integer dt) {
        this.dt = dt;
    }

    public String getComment() {
        return this.comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

}