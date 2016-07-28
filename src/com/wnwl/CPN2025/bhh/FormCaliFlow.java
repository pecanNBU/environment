package com.wnwl.CPN2025.bhh;

/**
 * FormCaliFlow  @author Jenny
 */

public class FormCaliFlow implements java.io.Serializable {

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
    private Float beDataSet;
    private Float beData1;
    private Float beData2;
    private Float beData3;
    private Float beDataMis;
    private Boolean beIsAdjust;
    private Float afDataSet;
    private Float afData1;
    private Float afData2;
    private Float afData3;
    private Float afDataMis;
    private Boolean afIsPass;

    // Constructors

    /**
     * default constructor
     */
    public FormCaliFlow() {
    }

    /**
     * full constructor
     */
    public FormCaliFlow(String consName, String devName, String depName,
                        String statBjh, String devNo, Integer dtCali, String checkDep,
                        String checkUser, Integer dtCheck, Float beDataSet, Float beData1,
                        Float beData2, Float beData3, Float beDataMis, Boolean beIsAdjust,
                        Float afDataSet, Float afData1, Float afData2, Float afData3,
                        Float afDataMis, Boolean afIsPass) {
        this.consName = consName;
        this.devName = devName;
        this.depName = depName;
        this.statBjh = statBjh;
        this.devNo = devNo;
        this.dtCali = dtCali;
        this.checkDep = checkDep;
        this.checkUser = checkUser;
        this.dtCheck = dtCheck;
        this.beDataSet = beDataSet;
        this.beData1 = beData1;
        this.beData2 = beData2;
        this.beData3 = beData3;
        this.beDataMis = beDataMis;
        this.beIsAdjust = beIsAdjust;
        this.afDataSet = afDataSet;
        this.afData1 = afData1;
        this.afData2 = afData2;
        this.afData3 = afData3;
        this.afDataMis = afDataMis;
        this.afIsPass = afIsPass;
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

    public Float getBeDataSet() {
        return this.beDataSet;
    }

    public void setBeDataSet(Float beDataSet) {
        this.beDataSet = beDataSet;
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

    public Float getBeDataMis() {
        return this.beDataMis;
    }

    public void setBeDataMis(Float beDataMis) {
        this.beDataMis = beDataMis;
    }

    public Boolean getBeIsAdjust() {
        return this.beIsAdjust;
    }

    public void setBeIsAdjust(Boolean beIsAdjust) {
        this.beIsAdjust = beIsAdjust;
    }

    public Float getAfDataSet() {
        return this.afDataSet;
    }

    public void setAfDataSet(Float afDataSet) {
        this.afDataSet = afDataSet;
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

    public Float getAfDataMis() {
        return this.afDataMis;
    }

    public void setAfDataMis(Float afDataMis) {
        this.afDataMis = afDataMis;
    }

    public Boolean getAfIsPass() {
        return this.afIsPass;
    }

    public void setAfIsPass(Boolean afIsPass) {
        this.afIsPass = afIsPass;
    }

}