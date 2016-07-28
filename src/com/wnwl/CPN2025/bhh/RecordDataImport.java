package com.wnwl.CPN2025.bhh;

/**
 * RecordDataImport  @author Jenny
 */

public class RecordDataImport implements java.io.Serializable {

    // Fields

    private Integer id;
    private UserInfo userInfo;
    private Integer dt;
    private Integer dtLast;
    private Integer fileType;
    private Short state;
    private String comment;

    // Constructors

    /**
     * default constructor
     */
    public RecordDataImport() {
    }

    /**
     * full constructor
     */
    public RecordDataImport(UserInfo userInfo, Integer dt, Integer dtLast,
                            Integer fileType, Short state, String comment) {
        this.userInfo = userInfo;
        this.dt = dt;
        this.dtLast = dtLast;
        this.fileType = fileType;
        this.state = state;
        this.comment = comment;
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

    public Integer getDtLast() {
        return this.dtLast;
    }

    public void setDtLast(Integer dtLast) {
        this.dtLast = dtLast;
    }

    public Integer getFileType() {
        return this.fileType;
    }

    public void setFileType(Integer fileType) {
        this.fileType = fileType;
    }

    public Short getState() {
        return this.state;
    }

    public void setState(Short state) {
        this.state = state;
    }

    public String getComment() {
        return this.comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

}