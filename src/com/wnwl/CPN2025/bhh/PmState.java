package com.wnwl.CPN2025.bhh;

/**
 * PmState  @author Jenny
 */

public class PmState implements java.io.Serializable {

    // Fields

    private Integer id;
    private Short val;
    private String name;
    private Integer color;
    private Float dataStart;
    private Float dataEnd;

    // Constructors

    /**
     * default constructor
     */
    public PmState() {
    }

    /**
     * full constructor
     */
    public PmState(Short val, String name, Integer color, Float dataStart,
                   Float dataEnd) {
        this.val = val;
        this.name = name;
        this.color = color;
        this.dataStart = dataStart;
        this.dataEnd = dataEnd;
    }

    // Property accessors

    public Integer getId() {
        return this.id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Short getVal() {
        return this.val;
    }

    public void setVal(Short val) {
        this.val = val;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getColor() {
        return this.color;
    }

    public void setColor(Integer color) {
        this.color = color;
    }

    public Float getDataStart() {
        return this.dataStart;
    }

    public void setDataStart(Float dataStart) {
        this.dataStart = dataStart;
    }

    public Float getDataEnd() {
        return this.dataEnd;
    }

    public void setDataEnd(Float dataEnd) {
        this.dataEnd = dataEnd;
    }

}