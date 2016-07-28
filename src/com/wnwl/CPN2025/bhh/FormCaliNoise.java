package com.wnwl.CPN2025.bhh;

/**
 * FormCaliNoise  @author Jenny
 */

public class FormCaliNoise implements java.io.Serializable {

    // Fields

    private Integer id;
    private String consName;
    private String devName;
    private String depName;
    private String statBjh;
    private String devType;
    private String devNo;
    private String caliName;
    private String caliNo;
    private String checkDep;
    private String checkUser;
    private Integer dtCheck;

    // Constructors

    /**
     * default constructor
     */
    public FormCaliNoise() {
    }

    /**
     * full constructor
     */
    public FormCaliNoise(String consName, String devName, String depName,
                         String statBjh, String devType, String devNo, String caliName,
                         String caliNo, String checkDep, String checkUser, Integer dtCheck) {
        this.consName = consName;
        this.devName = devName;
        this.depName = depName;
        this.statBjh = statBjh;
        this.devType = devType;
        this.devNo = devNo;
        this.caliName = caliName;
        this.caliNo = caliNo;
        this.checkDep = checkDep;
        this.checkUser = checkUser;
        this.dtCheck = dtCheck;
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

    public String getDevType() {
        return this.devType;
    }

    public void setDevType(String devType) {
        this.devType = devType;
    }

    public String getDevNo() {
        return this.devNo;
    }

    public void setDevNo(String devNo) {
        this.devNo = devNo;
    }

    public String getCaliName() {
        return this.caliName;
    }

    public void setCaliName(String caliName) {
        this.caliName = caliName;
    }

    public String getCaliNo() {
        return this.caliNo;
    }

    public void setCaliNo(String caliNo) {
        this.caliNo = caliNo;
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

}