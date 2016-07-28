package com.wnwl.CPN2025.bhh;

/**
 * CameraCurise  @author Jenny
 */

public class CameraCurise implements java.io.Serializable {

    // Fields

    private Integer id;
    private CameraInfo cameraInfo;
    private String no;
    private String name;
    private Short sort;

    // Constructors

    /**
     * default constructor
     */
    public CameraCurise() {
    }

    /**
     * full constructor
     */
    public CameraCurise(CameraInfo cameraInfo, String no, String name,
                        Short sort) {
        this.cameraInfo = cameraInfo;
        this.no = no;
        this.name = name;
        this.sort = sort;

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

    public String getNo() {
        return this.no;
    }

    public void setNo(String no) {
        this.no = no;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Short getSort() {
        return this.sort;
    }

    public void setSort(Short sort) {
        this.sort = sort;
    }

}