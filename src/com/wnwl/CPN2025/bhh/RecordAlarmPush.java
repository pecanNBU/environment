package com.wnwl.CPN2025.bhh;

/**
 * RecordAlarmPush  @author Jenny
 */

public class RecordAlarmPush implements java.io.Serializable {

    // Fields

    private Integer id;
    private Integer regParamId;
    private Float val;
    private Integer dt;
    private Short pushType;
    private Integer pushData;

    // Constructors

    /**
     * default constructor
     */
    public RecordAlarmPush() {
    }

    /**
     * full constructor
     */
    public RecordAlarmPush(Integer regParamId, Float val, Integer dt,
                           Short pushType, Integer pushData) {
        this.regParamId = regParamId;
        this.val = val;
        this.dt = dt;
        this.pushType = pushType;
        this.pushData = pushData;
    }

    // Property accessors

    public Integer getId() {
        return this.id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getRegParamId() {
        return this.regParamId;
    }

    public void setRegParamId(Integer regParamId) {
        this.regParamId = regParamId;
    }

    public Float getVal() {
        return this.val;
    }

    public void setVal(Float val) {
        this.val = val;
    }

    public Integer getDt() {
        return this.dt;
    }

    public void setDt(Integer dt) {
        this.dt = dt;
    }

    public Short getPushType() {
        return this.pushType;
    }

    public void setPushType(Short pushType) {
        this.pushType = pushType;
    }

    public Integer getPushData() {
        return this.pushData;
    }

    public void setPushData(Integer pushData) {
        this.pushData = pushData;
    }

}