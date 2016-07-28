package com.wnwl.CPN2025.bhh;

/**
 * LogOperCont  @author Jenny
 */

public class LogOperCont implements java.io.Serializable {

    // Fields

    private Integer id;
    private LogOper logOper;
    private String tbKey;
    private String tbValue;
    private String tbValueCur;

    // Constructors

    /**
     * default constructor
     */
    public LogOperCont() {
    }

    /**
     * full constructor
     */
    public LogOperCont(Integer id, LogOper logOper, String tbKey, String tbValue, String tbValueCur) {
        this.id = id;
        this.logOper = logOper;
        this.tbKey = tbKey;
        this.tbValue = tbValue;
        this.tbValueCur = tbValueCur;
    }

    // Property accessors

    public Integer getId() {
        return this.id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public LogOper getLogOper() {
        return logOper;
    }

    public void setLogOper(LogOper logOper) {
        this.logOper = logOper;
    }

    public String getTbKey() {
        return this.tbKey;
    }

    public void setTbKey(String tbKey) {
        this.tbKey = tbKey;
    }

    public String getTbValue() {
        return this.tbValue;
    }

    public void setTbValue(String tbValue) {
        this.tbValue = tbValue;
    }

    public String getTbValueCur() {
        return this.tbValueCur;
    }

    public void setTbValueCur(String tbValueCur) {
        this.tbValueCur = tbValueCur;
    }

}