package com.wnwl.CPN2025.bhh;

import java.sql.Timestamp;
import java.util.HashSet;
import java.util.Set;

/**
 * RegInfo  @author Jenny
 */

public class RegInfo implements java.io.Serializable {

    // Fields

    private Integer id;
    private DepCons depCons;
    private String devCode;
    private Timestamp startTime;
    private Timestamp preEndTime;
    private Timestamp endTime;
    private String devStatus;
    private String videoUrl;
    private String address;
    private Double longitude;
    private Double latitude;
    private Integer period;
    private Set cameraInfos = new HashSet(0);
    private Set recordOfflines = new HashSet(0);
    private Set regParams = new HashSet(0);

    // Constructors

    /**
     * default constructor
     */
    public RegInfo() {
    }

    /**
     * minimal constructor
     */
    public RegInfo(DepCons depCons, String devCode, String devStatus) {
        this.depCons = depCons;
        this.devCode = devCode;
        this.devStatus = devStatus;
    }

    /**
     * full constructor
     */
    public RegInfo(DepCons depCons, String devCode, Timestamp startTime,
                   Timestamp preEndTime, Timestamp endTime, String devStatus,
                   String videoUrl, String address, Double longitude, Double latitude,
                   Integer period, Set cameraInfos, Set recordOfflines, Set regParams) {
        this.depCons = depCons;
        this.devCode = devCode;
        this.startTime = startTime;
        this.preEndTime = preEndTime;
        this.endTime = endTime;
        this.devStatus = devStatus;
        this.videoUrl = videoUrl;
        this.address = address;
        this.longitude = longitude;
        this.latitude = latitude;
        this.period = period;
        this.cameraInfos = cameraInfos;
        this.recordOfflines = recordOfflines;
        this.regParams = regParams;
    }

    // Property accessors

    public Integer getId() {
        return this.id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public DepCons getDepCons() {
        return this.depCons;
    }

    public void setDepCons(DepCons depCons) {
        this.depCons = depCons;
    }

    public String getDevCode() {
        return this.devCode;
    }

    public void setDevCode(String devCode) {
        this.devCode = devCode;
    }

    public Timestamp getStartTime() {
        return this.startTime;
    }

    public void setStartTime(Timestamp startTime) {
        this.startTime = startTime;
    }

    public Timestamp getPreEndTime() {
        return this.preEndTime;
    }

    public void setPreEndTime(Timestamp preEndTime) {
        this.preEndTime = preEndTime;
    }

    public Timestamp getEndTime() {
        return this.endTime;
    }

    public void setEndTime(Timestamp endTime) {
        this.endTime = endTime;
    }

    public String getDevStatus() {
        return this.devStatus;
    }

    public void setDevStatus(String devStatus) {
        this.devStatus = devStatus;
    }

    public String getVideoUrl() {
        return this.videoUrl;
    }

    public void setVideoUrl(String videoUrl) {
        this.videoUrl = videoUrl;
    }

    public String getAddress() {
        return this.address;
    }

    public void setAddress(String address) {
        this.address = address;
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

    public Integer getPeriod() {
        return this.period;
    }

    public void setPeriod(Integer period) {
        this.period = period;
    }

    public Set getCameraInfos() {
        return this.cameraInfos;
    }

    public void setCameraInfos(Set cameraInfos) {
        this.cameraInfos = cameraInfos;
    }

    public Set getRecordOfflines() {
        return this.recordOfflines;
    }

    public void setRecordOfflines(Set recordOfflines) {
        this.recordOfflines = recordOfflines;
    }

    public Set getRegParams() {
        return this.regParams;
    }

    public void setRegParams(Set regParams) {
        this.regParams = regParams;
    }

}