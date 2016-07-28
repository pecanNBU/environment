package com.wnwl.CPN2025.bhh;

/**
 * RegAlarmTrend  @author Jenny
 */

public class RegAlarmTrend implements java.io.Serializable {

    // Fields

    private Integer id;
    private RegParam regParam;

    // Constructors

    /**
     * default constructor
     */
    public RegAlarmTrend() {
    }

    /**
     * full constructor
     */
    public RegAlarmTrend(RegParam regParam) {
        this.regParam = regParam;
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

}