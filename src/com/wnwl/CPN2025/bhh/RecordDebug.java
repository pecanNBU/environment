package com.wnwl.CPN2025.bhh;

import java.sql.Timestamp;

/**
 * RecordDebug  @author Jenny
 */

public class RecordDebug implements java.io.Serializable {

    // Fields

    private Integer id;
    private Integer userId;
    private Timestamp dtStart;
    private Timestamp dtEnd;
    private String debugNote;
    private String debugResult;
    private Short debugType;

    // Constructors

    /**
     * default constructor
     */
    public RecordDebug() {
    }

    /**
     * full constructor
     */
    public RecordDebug(Integer userId, Timestamp dtStart, Timestamp dtEnd,
                       String debugNote, String debugResult, Short debugType) {
        this.userId = userId;
        this.dtStart = dtStart;
        this.dtEnd = dtEnd;
        this.debugNote = debugNote;
        this.debugResult = debugResult;
        this.debugType = debugType;
    }

    // Property accessors

    public Integer getId() {
        return this.id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getUserId() {
        return this.userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Timestamp getDtStart() {
        return this.dtStart;
    }

    public void setDtStart(Timestamp dtStart) {
        this.dtStart = dtStart;
    }

    public Timestamp getDtEnd() {
        return this.dtEnd;
    }

    public void setDtEnd(Timestamp dtEnd) {
        this.dtEnd = dtEnd;
    }

    public String getDebugNote() {
        return this.debugNote;
    }

    public void setDebugNote(String debugNote) {
        this.debugNote = debugNote;
    }

    public String getDebugResult() {
        return this.debugResult;
    }

    public void setDebugResult(String debugResult) {
        this.debugResult = debugResult;
    }

    public Short getDebugType() {
        return this.debugType;
    }

    public void setDebugType(Short debugType) {
        this.debugType = debugType;
    }

}