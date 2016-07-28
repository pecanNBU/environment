package com.wnwl.CPN2025.bhh;

/**
 * LogOper  @author Jenny
 */

public class LogOper implements java.io.Serializable {

    // Fields

    private Integer id;
    private UserInfo userInfo;
    private Integer dt;
    private Short type;
    private Integer tableId;
    private String tableName;
    private String comment;

    // Constructors

    /**
     * default constructor
     */
    public LogOper() {
    }

    /**
     * full constructor
     */
    public LogOper(UserInfo userInfo, Integer dt, Short type, Integer tableId,
                   String tableName, String comment) {
        this.userInfo = userInfo;
        this.dt = dt;
        this.type = type;
        this.tableId = tableId;
        this.tableName = tableName;
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

    public Short getType() {
        return this.type;
    }

    public void setType(Short type) {
        this.type = type;
    }

    public Integer getTableId() {
        return this.tableId;
    }

    public void setTableId(Integer tableId) {
        this.tableId = tableId;
    }

    public String getTableName() {
        return this.tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public String getComment() {
        return this.comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

}