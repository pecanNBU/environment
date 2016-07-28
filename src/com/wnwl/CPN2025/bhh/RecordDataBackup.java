package com.wnwl.CPN2025.bhh;

/**
 * RecordDataBackup  @author Jenny
 */

public class RecordDataBackup implements java.io.Serializable {

    // Fields

    private Integer id;
    private UserInfo userInfo;
    private Integer dt;
    private String comment;
    private Short dataType;
    private String dataSize;

    // Constructors

    /**
     * default constructor
     */
    public RecordDataBackup() {
    }

    /**
     * minimal constructor
     */
    public RecordDataBackup(UserInfo userInfo) {
        this.userInfo = userInfo;
    }

    /**
     * full constructor
     */
    public RecordDataBackup(UserInfo userInfo, Integer dt, String comment,
                            Short dataType, String dataSize) {
        this.userInfo = userInfo;
        this.dt = dt;
        this.comment = comment;
        this.dataType = dataType;
        this.dataSize = dataSize;
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

    public String getComment() {
        return this.comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Short getDataType() {
        return this.dataType;
    }

    public void setDataType(Short dataType) {
        this.dataType = dataType;
    }

    public String getDataSize() {
        return this.dataSize;
    }

    public void setDataSize(String dataSize) {
        this.dataSize = dataSize;
    }

}