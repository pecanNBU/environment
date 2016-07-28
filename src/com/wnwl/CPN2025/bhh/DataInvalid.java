package com.wnwl.CPN2025.bhh;

/**
 * DataInvalid  @author Jenny
 */

public class DataInvalid implements java.io.Serializable {

    // Fields

    private Integer id;
    private RegParam regParam;
    private Float val;

    // Constructors

    /**
     * default constructor
     */
    public DataInvalid() {
    }

    /**
     * full constructor
     */
    public DataInvalid(RegParam regParam, Float val) {
        this.regParam = regParam;
        this.val = val;
    }

    // Property accessors

    public Integer getId() {
        return this.id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public RegParam getRegParam() {
        return this.regParam;
    }

    public void setRegParam(RegParam regParam) {
        this.regParam = regParam;
    }

    public Float getVal() {
        return this.val;
    }

    public void setVal(Float val) {
        this.val = val;
    }

}