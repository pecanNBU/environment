package com.wnwl.CPN2025.bhh;

import java.util.HashSet;
import java.util.Set;

/**
 * CameraInfo  @author Jenny
 */

public class CameraInfo implements java.io.Serializable {

    // Fields
    private Integer id;
    private RegInfo regInfo;
    private String no;
    private String model;
    private String brand;
    private Integer dt;
    private Integer dtExpir;
    private String m_sDeviceIP;
    private int iPort;
    private String userName;
    private String password;
    private Set cameraPosis = new HashSet(0);
    private Set recordPhotos = new HashSet(0);
    private Set recordNoises = new HashSet(0);
    private Set cameraCurises = new HashSet(0);

    // Constructors

    /**
     * default constructor
     */
    public CameraInfo() {
    }

    /**
     * full constructor
     */
    public CameraInfo(RegInfo regInfo, String no, String model, String brand,
                      Integer dt, Integer dtExpir, String m_sDeviceIP, int iPort, String userName, String password, Set cameraPosis, Set recordPhotos,
                      Set recordNoises, Set cameraCurises) {
        this.regInfo = regInfo;
        this.no = no;
        this.model = model;
        this.brand = brand;
        this.dt = dt;
        this.dtExpir = dtExpir;
        this.cameraPosis = cameraPosis;
        this.recordPhotos = recordPhotos;
        this.recordNoises = recordNoises;
        this.cameraCurises = cameraCurises;
        this.m_sDeviceIP = m_sDeviceIP;
        this.iPort = iPort;
        this.userName = userName;
        this.password = password;
    }

    public CameraInfo(String m_sDeviceIP, int iPort, String userName, String password) {
        this.m_sDeviceIP = m_sDeviceIP;
        this.iPort = iPort;
        this.userName = userName;
        this.password = password;
    }

    // Property accessors

    public Integer getId() {
        return this.id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public RegInfo getRegInfo() {
        return this.regInfo;
    }

    public void setRegInfo(RegInfo regInfo) {
        this.regInfo = regInfo;
    }

    public String getNo() {
        return this.no;
    }

    public void setNo(String no) {
        this.no = no;
    }

    public String getModel() {
        return this.model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public String getBrand() {
        return this.brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public Integer getDt() {
        return this.dt;
    }

    public void setDt(Integer dt) {
        this.dt = dt;
    }

    public Integer getDtExpir() {
        return this.dtExpir;
    }

    public void setDtExpir(Integer dtExpir) {
        this.dtExpir = dtExpir;
    }

    public Set getCameraPosis() {
        return this.cameraPosis;
    }

    public void setCameraPosis(Set cameraPosis) {
        this.cameraPosis = cameraPosis;
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

    public Set getCameraCurises() {
        return this.cameraCurises;
    }

    public void setCameraCurises(Set cameraCurises) {
        this.cameraCurises = cameraCurises;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getM_sDeviceIP() {
        return m_sDeviceIP;
    }

    public void setM_sDeviceIP(String m_sDeviceIP) {
        this.m_sDeviceIP = m_sDeviceIP;
    }

    public int getiPort() {
        return iPort;
    }

    public void setiPort(int iPort) {
        this.iPort = iPort;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }
}