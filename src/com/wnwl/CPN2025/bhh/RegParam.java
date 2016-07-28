package com.wnwl.CPN2025.bhh;

import java.util.HashSet;
import java.util.Set;

/**
 * RegParam  @author Jenny
 */

public class RegParam implements java.io.Serializable {

    // Fields

    private Integer id;
    private DType DTypeByUnitTypeId;
    private DType DTypeByParaTypeId;
    private RegInfo regInfo;
    private String paraName;
    private Integer memoType;
    private Short devId;
    private Short offset;
    private Set regAlarmTrends = new HashSet(0);
    private Set dataInvalids = new HashSet(0);
    private Set regAlarmOvers = new HashSet(0);
    private Set alarmPushIgnores = new HashSet(0);
    private Set alarmPushs = new HashSet(0);

    // Constructors

    /**
     * default constructor
     */
    public RegParam() {
    }

    /**
     * full constructor
     */
    public RegParam(DType DTypeByUnitTypeId, DType DTypeByParaTypeId,
                    RegInfo regInfo, String paraName, Integer memoType, Short devId,
                    Short offset, Set regAlarmTrends, Set dataInvalids,
                    Set regAlarmOvers, Set alarmPushIgnores, Set alarmPushs) {
        this.DTypeByUnitTypeId = DTypeByUnitTypeId;
        this.DTypeByParaTypeId = DTypeByParaTypeId;
        this.regInfo = regInfo;
        this.paraName = paraName;
        this.memoType = memoType;
        this.devId = devId;
        this.offset = offset;
        this.regAlarmTrends = regAlarmTrends;
        this.dataInvalids = dataInvalids;
        this.regAlarmOvers = regAlarmOvers;
        this.alarmPushIgnores = alarmPushIgnores;
        this.alarmPushs = alarmPushs;
    }

    // Property accessors

    public Integer getId() {
        return this.id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public DType getDTypeByUnitTypeId() {
        return this.DTypeByUnitTypeId;
    }

    public void setDTypeByUnitTypeId(DType DTypeByUnitTypeId) {
        this.DTypeByUnitTypeId = DTypeByUnitTypeId;
    }

    public DType getDTypeByParaTypeId() {
        return this.DTypeByParaTypeId;
    }

    public void setDTypeByParaTypeId(DType DTypeByParaTypeId) {
        this.DTypeByParaTypeId = DTypeByParaTypeId;
    }

    public RegInfo getRegInfo() {
        return this.regInfo;
    }

    public void setRegInfo(RegInfo regInfo) {
        this.regInfo = regInfo;
    }

    public String getParaName() {
        return this.paraName;
    }

    public void setParaName(String paraName) {
        this.paraName = paraName;
    }

    public Integer getMemoType() {
        return this.memoType;
    }

    public void setMemoType(Integer memoType) {
        this.memoType = memoType;
    }

    public Short getDevId() {
        return this.devId;
    }

    public void setDevId(Short devId) {
        this.devId = devId;
    }

    public Short getOffset() {
        return this.offset;
    }

    public void setOffset(Short offset) {
        this.offset = offset;
    }

    public Set getRegAlarmTrends() {
        return this.regAlarmTrends;
    }

    public void setRegAlarmTrends(Set regAlarmTrends) {
        this.regAlarmTrends = regAlarmTrends;
    }

    public Set getDataInvalids() {
        return this.dataInvalids;
    }

    public void setDataInvalids(Set dataInvalids) {
        this.dataInvalids = dataInvalids;
    }

    public Set getRegAlarmOvers() {
        return this.regAlarmOvers;
    }

    public void setRegAlarmOvers(Set regAlarmOvers) {
        this.regAlarmOvers = regAlarmOvers;
    }

    public Set getAlarmPushIgnores() {
        return this.alarmPushIgnores;
    }

    public void setAlarmPushIgnores(Set alarmPushIgnores) {
        this.alarmPushIgnores = alarmPushIgnores;
    }

    public Set getAlarmPushs() {
        return this.alarmPushs;
    }

    public void setAlarmPushs(Set alarmPushs) {
        this.alarmPushs = alarmPushs;
    }

}