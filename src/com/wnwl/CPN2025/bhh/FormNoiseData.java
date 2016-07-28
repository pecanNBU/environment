package com.wnwl.CPN2025.bhh;

/**
 * FormNoiseData  @author Jenny
 */

public class FormNoiseData implements java.io.Serializable {

    // Fields

    private Integer id;
    private Integer formNoiseId;
    private Integer dt;
    private Float data1;
    private Float data2;
    private Float dataMis;

    // Constructors

    /**
     * default constructor
     */
    public FormNoiseData() {
    }

    /**
     * full constructor
     */
    public FormNoiseData(Integer formNoiseId, Integer dt, Float data1,
                         Float data2, Float dataMis) {
        this.formNoiseId = formNoiseId;
        this.dt = dt;
        this.data1 = data1;
        this.data2 = data2;
        this.dataMis = dataMis;
    }

    // Property accessors

    public Integer getId() {
        return this.id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getFormNoiseId() {
        return this.formNoiseId;
    }

    public void setFormNoiseId(Integer formNoiseId) {
        this.formNoiseId = formNoiseId;
    }

    public Integer getDt() {
        return this.dt;
    }

    public void setDt(Integer dt) {
        this.dt = dt;
    }

    public Float getData1() {
        return this.data1;
    }

    public void setData1(Float data1) {
        this.data1 = data1;
    }

    public Float getData2() {
        return this.data2;
    }

    public void setData2(Float data2) {
        this.data2 = data2;
    }

    public Float getDataMis() {
        return this.dataMis;
    }

    public void setDataMis(Float dataMis) {
        this.dataMis = dataMis;
    }

}