package com.wnwl.CPN2025.bhh;

import java.util.HashSet;
import java.util.Set;

/**
 * AlarmPush  @author Jenny
 */

public class AlarmPush implements java.io.Serializable {

    // Fields

    private Integer id;
    private RegParam regParam;
    private Float val;
    private Integer dtLast;
    private Short pushType;
    private Set alarmPushIgnores = new HashSet(0);

    // Constructors

    /**
     * default constructor
     */
    public AlarmPush() {
    }

    /**
     * full constructor
     */
    public AlarmPush(RegParam regParam, Float val, Integer dtLast,
                     Short pushType, Set alarmPushIgnores) {
        this.regParam = regParam;
        this.val = val;
        this.dtLast = dtLast;
        this.pushType = pushType;
        this.alarmPushIgnores = alarmPushIgnores;
    }

    // Property accessors

    public Integer getId() {
        return this.id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public RegParam getRegParam() {
        return this.regParam;
    }

    public void setRegParam(RegParam regParam) {
        this.regParam = regParam;
    }

    public Float getVal() {
        return this.val;
    }

    public void setVal(Float val) {
        this.val = val;
    }

    public Integer getDtLast() {
        return this.dtLast;
    }

    public void setDtLast(Integer dtLast) {
        this.dtLast = dtLast;
    }

    public Short getPushType() {
        return this.pushType;
    }

    public void setPushType(Short pushType) {
        this.pushType = pushType;
    }

    public Set getAlarmPushIgnores() {
        return this.alarmPushIgnores;
    }

    public void setAlarmPushIgnores(Set alarmPushIgnores) {
        this.alarmPushIgnores = alarmPushIgnores;
    }

}