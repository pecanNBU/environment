package com.wnwl.CPN2025.bhh;

/**
 * FormCaliPm  @author Jenny
 */

public class FormCaliPm implements java.io.Serializable {

    // Fields

    private Integer id;
    private String consName;
    private String devName;
    private String depName;
    private String statBjh;
    private String devNo;
    private Integer dtCali;
    private String checkDep;
    private String checkUser;
    private Integer dtCheck;
    private Float beDataZero;
    private Float beData1;
    private Float beData2;
    private Float beData3;
    private Float beData;
    private Boolean beIsQual;
    private Float afDataSpan;
    private Float afData1;
    private Float afData2;
    private Float afData3;
    private Float afData;
    private Boolean afIsQual;

    // Constructors

    /**
     * default constructor
     */
    public FormCaliPm() {
    }

    /**
     * full constructor
     */
    public FormCaliPm(String consName, String devName, String depName,
                      String statBjh, String devNo, Integer dtCali, String checkDep,
                      String checkUser, Integer dtCheck, Float beDataZero, Float beData1,
                      Float beData2, Float beData3, Float beData, Boolean beIsQual,
                      Float afDataSpan, Float afData1, Float afData2, Float afData3,
                      Float afData, Boolean afIsQual) {
        this.consName = consName;
        this.devName = devName;
        this.depName = depName;
        this.statBjh = statBjh;
        this.devNo = devNo;
        this.dtCali = dtCali;
        this.checkDep = checkDep;
        this.checkUser = checkUser;
        this.dtCheck = dtCheck;
        this.beDataZero = beDataZero;
        this.beData1 = beData1;
        this.beData2 = beData2;
        this.beData3 = beData3;
        this.beData = beData;
        this.beIsQual = beIsQual;
        this.afDataSpan = afDataSpan;
        this.afData1 = afData1;
        this.afData2 = afData2;
        this.afData3 = afData3;
        this.afData = afData;
        this.afIsQual = afIsQual;
    }

    // Property accessors

    public Integer getId() {
        return this.id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getConsName() {
        return this.consName;
    }

    public void setConsName(String consName) {
        this.consName = consName;
    }

    public String getDevName() {
        return this.devName;
    }

    public void setDevName(String devName) {
        this.devName = devName;
    }

    public String getDepName() {
        return this.depName;
    }

    public void setDepName(String depName) {
        this.depName = depName;
    }

    public String getStatBjh() {
        return this.statBjh;
    }

    public void setStatBjh(String statBjh) {
        this.statBjh = statBjh;
    }

    public String getDevNo() {
        return this.devNo;
    }

    public void setDevNo(String devNo) {
        this.devNo = devNo;
    }

    public Integer getDtCali() {
        return this.dtCali;
    }

    public void setDtCali(Integer dtCali) {
        this.dtCali = dtCali;
    }

    public String getCheckDep() {
        return this.checkDep;
    }

    public void setCheckDep(String checkDep) {
        this.checkDep = checkDep;
    }

    public String getCheckUser() {
        return this.checkUser;
    }

    public void setCheckUser(String checkUser) {
        this.checkUser = checkUser;
    }

    public Integer getDtCheck() {
        return this.dtCheck;
    }

    public void setDtCheck(Integer dtCheck) {
        this.dtCheck = dtCheck;
    }

    public Float getBeDataZero() {
        return this.beDataZero;
    }

    public void setBeDataZero(Float beDataZero) {
        this.beDataZero = beDataZero;
    }

    public Float getBeData1() {
        return this.beData1;
    }

    public void setBeData1(Float beData1) {
        this.beData1 = beData1;
    }

    public Float getBeData2() {
        return this.beData2;
    }

    public void setBeData2(Float beData2) {
        this.beData2 = beData2;
    }

    public Float getBeData3() {
        return this.beData3;
    }

    public void setBeData3(Float beData3) {
        this.beData3 = beData3;
    }

    public Float getBeData() {
        return this.beData;
    }

    public void setBeData(Float beData) {
        this.beData = beData;
    }

    public Boolean getBeIsQual() {
        return this.beIsQual;
    }

    public void setBeIsQual(Boolean beIsQual) {
        this.beIsQual = beIsQual;
    }

    public Float getAfDataSpan() {
        return this.afDataSpan;
    }

    public void setAfDataSpan(Float afDataSpan) {
        this.afDataSpan = afDataSpan;
    }

    public Float getAfData1() {
        return this.afData1;
    }

    public void setAfData1(Float afData1) {
        this.afData1 = afData1;
    }

    public Float getAfData2() {
        return this.afData2;
    }

    public void setAfData2(Float afData2) {
        this.afData2 = afData2;
    }

    public Float getAfData3() {
        return this.afData3;
    }

    public void setAfData3(Float afData3) {
        this.afData3 = afData3;
    }

    public Float getAfData() {
        return this.afData;
    }

    public void setAfData(Float afData) {
        this.afData = afData;
    }

    public Boolean getAfIsQual() {
        return this.afIsQual;
    }

    public void setAfIsQual(Boolean afIsQual) {
        this.afIsQual = afIsQual;
    }

}