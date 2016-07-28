package com.wnwl.CPN2025.bhh;

/**
 * AlarmPushIgnore  @author Jenny
 */

public class AlarmPushIgnore implements java.io.Serializable {

    // Fields

    private Integer id;
    private RegParam regParam;
    private AlarmPush alarmPush;
    private Float val;

    // Constructors

    /**
     * default constructor
     */
    public AlarmPushIgnore() {
    }

    /**
     * full constructor
     */
    public AlarmPushIgnore(RegParam regParam, AlarmPush alarmPush, Float val) {
        this.regParam = regParam;
        this.alarmPush = alarmPush;
        this.val = val;
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

    public AlarmPush getAlarmPush() {
        return this.alarmPush;
    }

    public void setAlarmPush(AlarmPush alarmPush) {
        this.alarmPush = alarmPush;
    }

    public Float getVal() {
        return this.val;
    }

    public void setVal(Float val) {
        this.val = val;
    }

}