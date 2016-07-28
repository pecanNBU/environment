package com.wnwl.CPN2025.bhh;

import java.sql.Timestamp;
import java.util.HashSet;
import java.util.Set;

/**
 * RecordAlarm  @author Jenny
 */

public class RecordAlarm implements java.io.Serializable {

    // Fields

    private Integer id;
    private Integer statCode;
    private Float tp;
    private Float db;
    private Timestamp dataTime;
    private Float windSpeed;
    private Float rain;
    private Float windDirection;
    private Float temperature;
    private Float humidity;
    private Float airPressure;
    private String dataStatus;
    private Short alatmType;
    private Short alarmId;
    private Set recordPhotos = new HashSet(0);
    private Set recordNoises = new HashSet(0);

    // Constructors

    /**
     * default constructor
     */
    public RecordAlarm() {
    }

    /**
     * full constructor
     */
    public RecordAlarm(Integer statCode, Float tp, Float db,
                       Timestamp dataTime, Float windSpeed, Float rain,
                       Float windDirection, Float temperature, Float humidity,
                       Float airPressure, String dataStatus, Short alatmType,
                       Short alarmId, Set recordPhotos, Set recordNoises) {
        this.statCode = statCode;
        this.tp = tp;
        this.db = db;
        this.dataTime = dataTime;
        this.windSpeed = windSpeed;
        this.rain = rain;
        this.windDirection = windDirection;
        this.temperature = temperature;
        this.humidity = humidity;
        this.airPressure = airPressure;
        this.dataStatus = dataStatus;
        this.alatmType = alatmType;
        this.alarmId = alarmId;
        this.recordPhotos = recordPhotos;
        this.recordNoises = recordNoises;
    }

    // Property accessors

    public Integer getId() {
        return this.id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getStatCode() {
        return this.statCode;
    }

    public void setStatCode(Integer statCode) {
        this.statCode = statCode;
    }

    public Float getTp() {
        return this.tp;
    }

    public void setTp(Float tp) {
        this.tp = tp;
    }

    public Float getDb() {
        return this.db;
    }

    public void setDb(Float db) {
        this.db = db;
    }

    public Timestamp getDataTime() {
        return this.dataTime;
    }

    public void setDataTime(Timestamp dataTime) {
        this.dataTime = dataTime;
    }

    public Float getWindSpeed() {
        return this.windSpeed;
    }

    public void setWindSpeed(Float windSpeed) {
        this.windSpeed = windSpeed;
    }

    public Float getRain() {
        return this.rain;
    }

    public void setRain(Float rain) {
        this.rain = rain;
    }

    public Float getWindDirection() {
        return this.windDirection;
    }

    public void setWindDirection(Float windDirection) {
        this.windDirection = windDirection;
    }

    public Float getTemperature() {
        return this.temperature;
    }

    public void setTemperature(Float temperature) {
        this.temperature = temperature;
    }

    public Float getHumidity() {
        return this.humidity;
    }

    public void setHumidity(Float humidity) {
        this.humidity = humidity;
    }

    public Float getAirPressure() {
        return this.airPressure;
    }

    public void setAirPressure(Float airPressure) {
        this.airPressure = airPressure;
    }

    public String getDataStatus() {
        return this.dataStatus;
    }

    public void setDataStatus(String dataStatus) {
        this.dataStatus = dataStatus;
    }

    public Short getAlatmType() {
        return this.alatmType;
    }

    public void setAlatmType(Short alatmType) {
        this.alatmType = alatmType;
    }

    public Short getAlarmId() {
        return this.alarmId;
    }

    public void setAlarmId(Short alarmId) {
        this.alarmId = alarmId;
    }

    public Set getRecordPhotos() {
        return this.recordPhotos;
    }

    public void setRecordPhotos(Set recordPhotos) {
        this.recordPhotos = recordPhotos;
    }

    public Set getRecordNoises() {
        return this.recordNoises;
    }

    public void setRecordNoises(Set recordNoises) {
        this.recordNoises = recordNoises;
    }

}