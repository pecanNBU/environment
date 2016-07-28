package com.wnwl.CPN2025.bhh;

/**
 * RecordOffline  @author Jenny
 */

public class RecordOffline implements java.io.Serializable {

    // Fields

    private Integer id;
    private RegInfo regInfo;
    private Integer dtStart;
    private Integer dtEnd;
    private String comment;

    // Constructors

    /**
     * default constructor
     */
    public RecordOffline() {
    }

    /**
     * full constructor
     */
    public RecordOffline(RegInfo regInfo, Integer dtStart, Integer dtEnd,
                         String comment) {
        this.regInfo = regInfo;
        this.dtStart = dtStart;
        this.dtEnd = dtEnd;
        this.comment = comment;
    }

    // Property accessors

    public Integer getId() {
        return this.id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public RegInfo getRegInfo() {
        return this.regInfo;
    }

    public void setRegInfo(RegInfo regInfo) {
        this.regInfo = regInfo;
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

    public String getComment() {
        return this.comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

}