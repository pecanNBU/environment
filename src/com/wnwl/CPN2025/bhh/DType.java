package com.wnwl.CPN2025.bhh;

import java.util.HashSet;
import java.util.Set;

/**
 * DType  @author Jenny
 */

public class DType implements java.io.Serializable {

    // Fields

    private Integer id;
    private DType DType;
    private String typeName;
    private Short isLeaf;
    private String enName;
    private Set regParamsForParaTypeId = new HashSet(0);
    private Set DTypes = new HashSet(0);
    private Set regParamsForUnitTypeId = new HashSet(0);

    // Constructors

    /**
     * default constructor
     */
    public DType() {
    }

    /**
     * minimal constructor
     */
    public DType(DType DType, String typeName) {
        this.DType = DType;
        this.typeName = typeName;
    }

    /**
     * full constructor
     */
    public DType(DType DType, String typeName, Short isLeaf, String enName,
                 Set regParamsForParaTypeId, Set DTypes, Set regParamsForUnitTypeId) {
        this.DType = DType;
        this.typeName = typeName;
        this.isLeaf = isLeaf;
        this.enName = enName;
        this.regParamsForParaTypeId = regParamsForParaTypeId;
        this.DTypes = DTypes;
        this.regParamsForUnitTypeId = regParamsForUnitTypeId;
    }

    // Property accessors

    public Integer getId() {
        return this.id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public DType getDType() {
        return this.DType;
    }

    public void setDType(DType DType) {
        this.DType = DType;
    }

    public String getTypeName() {
        return this.typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public Short getIsLeaf() {
        return this.isLeaf;
    }

    public void setIsLeaf(Short isLeaf) {
        this.isLeaf = isLeaf;
    }

    public String getEnName() {
        return this.enName;
    }

    public void setEnName(String enName) {
        this.enName = enName;
    }

    public Set getRegParamsForParaTypeId() {
        return this.regParamsForParaTypeId;
    }

    public void setRegParamsForParaTypeId(Set regParamsForParaTypeId) {
        this.regParamsForParaTypeId = regParamsForParaTypeId;
    }

    public Set getDTypes() {
        return this.DTypes;
    }

    public void setDTypes(Set DTypes) {
        this.DTypes = DTypes;
    }

    public Set getRegParamsForUnitTypeId() {
        return this.regParamsForUnitTypeId;
    }

    public void setRegParamsForUnitTypeId(Set regParamsForUnitTypeId) {
        this.regParamsForUnitTypeId = regParamsForUnitTypeId;
    }

}