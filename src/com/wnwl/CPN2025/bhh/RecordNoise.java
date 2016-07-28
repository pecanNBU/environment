package com.wnwl.CPN2025.bhh;

/**
 * RecordNoise  @author Jenny
 */

public class RecordNoise implements java.io.Serializable {

    // Fields

    private Integer id;
    private CameraInfo cameraInfo;
    private RecordAlarm recordAlarm;
    private Integer dt;
    private String path;
    private Short type;

    // Constructors

    /**
     * default constructor
     */
    public RecordNoise() {
    }

    /**
     * full constructor
     */
    public RecordNoise(CameraInfo cameraInfo, RecordAlarm recordAlarm,
                       Integer dt, String path, Short type) {
        this.cameraInfo = cameraInfo;
        this.recordAlarm = recordAlarm;
        this.dt = dt;
        this.path = path;
        this.type = type;
    }

    // Property accessors

    public Integer getId() {
        return this.id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public CameraInfo getCameraInfo() {
        return this.cameraInfo;
    }

    public void setCameraInfo(CameraInfo cameraInfo) {
        this.cameraInfo = cameraInfo;
    }

    public RecordAlarm getRecordAlarm() {
        return this.recordAlarm;
    }

    public void setRecordAlarm(RecordAlarm recordAlarm) {
        this.recordAlarm = recordAlarm;
    }

    public Integer getDt() {
        return this.dt;
    }

    public void setDt(Integer dt) {
        this.dt = dt;
    }

    public String getPath() {
        return this.path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public Short getType() {
        return this.type;
    }

    public void setType(Short type) {
        this.type = type;
    }

}