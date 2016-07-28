package com.wnwl.CPN2025.bhh;

import java.sql.Timestamp;
import java.util.HashSet;
import java.util.Set;

/**
 * DepCons  @author Jenny
 */

public class DepCons implements java.io.Serializable {

    // Fields

    private Integer statCode;
    private String statBjh;
    private String statName;
    private String chargeMan;
    private String telephone;
    private Double longitude;
    private Double latitude;
    private String department;
    private String address;
    private String country;
    private String street;
    private Float square;
    private Timestamp proStartTime;
    private String stage;
    private Set regInfos = new HashSet(0);

    // Constructors

    /**
     * default constructor
     */
    public DepCons() {
    }

    /**
     * minimal constructor
     */
    public DepCons(String statBjh, String statName, String chargeMan,
                   String telephone, Double longitude, Double latitude,
                   String department, String address, String country, String street,
                   Float square, Timestamp proStartTime, String stage) {
        this.statBjh = statBjh;
        this.statName = statName;
        this.chargeMan = chargeMan;
        this.telephone = telephone;
        this.longitude = longitude;
        this.latitude = latitude;
        this.department = department;
        this.address = address;
        this.country = country;
        this.street = street;
        this.square = square;
        this.proStartTime = proStartTime;
        this.stage = stage;
    }

    /**
     * full constructor
     */
    public DepCons(String statBjh, String statName, String chargeMan,
                   String telephone, Double longitude, Double latitude,
                   String department, String address, String country, String street,
                   Float square, Timestamp proStartTime, String stage, Set regInfos) {
        this.statBjh = statBjh;
        this.statName = statName;
        this.chargeMan = chargeMan;
        this.telephone = telephone;
        this.longitude = longitude;
        this.latitude = latitude;
        this.department = department;
        this.address = address;
        this.country = country;
        this.street = street;
        this.square = square;
        this.proStartTime = proStartTime;
        this.stage = stage;
        this.regInfos = regInfos;
    }

    // Property accessors

    public Integer getStatCode() {
        return this.statCode;
    }

    public void setStatCode(Integer statCode) {
        this.statCode = statCode;
    }

    public String getStatBjh() {
        return this.statBjh;
    }

    public void setStatBjh(String statBjh) {
        this.statBjh = statBjh;
    }

    public String getStatName() {
        return this.statName;
    }

    public void setStatName(String statName) {
        this.statName = statName;
    }

    public String getChargeMan() {
        return this.chargeMan;
    }

    public void setChargeMan(String chargeMan) {
        this.chargeMan = chargeMan;
    }

    public String getTelephone() {
        return this.telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public Double getLongitude() {
        return this.longitude;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public Double getLatitude() {
        return this.latitude;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }

    public String getDepartment() {
        return this.department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getAddress() {
        return this.address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getCountry() {
        return this.country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getStreet() {
        return this.street;
    }

    public void setStreet(String street) {
        this.street = street;
    }

    public Float getSquare() {
        return this.square;
    }

    public void setSquare(Float square) {
        this.square = square;
    }

    public Timestamp getProStartTime() {
        return this.proStartTime;
    }

    public void setProStartTime(Timestamp proStartTime) {
        this.proStartTime = proStartTime;
    }

    public String getStage() {
        return this.stage;
    }

    public void setStage(String stage) {
        this.stage = stage;
    }

    public Set getRegInfos() {
        return this.regInfos;
    }

    public void setRegInfos(Set regInfos) {
        this.regInfos = regInfos;
    }

}