package com.wnwl.CPN2025.bhh;

/**
 * RegAlarmOver  @author Jenny
 */

public class RegAlarmOver implements java.io.Serializable {

    // Fields

    private Integer id;
    private RegParam regParam;
    private Float excepMin;
    private Float excepMax;
    private Float excepReturn;
    private Integer dtStart;
    private Integer dtEnd;
    private Short dtMonth;

    // Constructors

    /**
     * default constructor
     */
    public RegAlarmOver() {
    }

    /**
     * full constructor
     */
    public RegAlarmOver(RegParam regParam, Float excepMin, Float excepMax,
                        Float excepReturn, Integer dtStart, Integer dtEnd, Short dtMonth) {
        this.regParam = regParam;
        this.excepMin = excepMin;
        this.excepMax = excepMax;
        this.excepReturn = excepReturn;
        this.dtStart = dtStart;
        this.dtEnd = dtEnd;
        this.dtMonth = dtMonth;
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

    public Float getExcepMin() {
        return this.excepMin;
    }

    public void setExcepMin(Float excepMin) {
        this.excepMin = excepMin;
    }

    public Float getExcepMax() {
        return this.excepMax;
    }

    public void setExcepMax(Float excepMax) {
        this.excepMax = excepMax;
    }

    public Float getExcepReturn() {
        return this.excepReturn;
    }

    public void setExcepReturn(Float excepReturn) {
        this.excepReturn = excepReturn;
    }

    public Integer getDtStart() {
        return this.dtStart;
    }

    public void setDtStart(Integer dtStart) {
        this.dtStart = dtStart;
    }

    public Integer getDtEnd() {
        return this.dtEnd;
    }

    public void setDtEnd(Integer dtEnd) {
        this.dtEnd = dtEnd;
    }

    public Short getDtMonth() {
        return this.dtMonth;
    }

    public void setDtMonth(Short dtMonth) {
        this.dtMonth = dtMonth;
    }

}