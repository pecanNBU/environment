package com.wnwl.CPN2025.bhh;

/**
 * UserDetail  @author Jenny
 */

public class UserDetail implements java.io.Serializable {

    // Fields

    private Integer id;
    private String mobilephone;
    private String telephone;
    private String email;
    private String qq;
    private String picHead;
    private Short sex;
    private String idCard;
    private String address;

    // Constructors

    /**
     * default constructor
     */
    public UserDetail() {
    }

    /**
     * full constructor
     */
    public UserDetail(String mobilephone, String telephone, String email,
                      String qq, String picHead, Short sex, String idCard, String address) {
        this.mobilephone = mobilephone;
        this.telephone = telephone;
        this.email = email;
        this.qq = qq;
        this.picHead = picHead;
        this.sex = sex;
        this.idCard = idCard;
        this.address = address;
    }

    // Property accessors

    public Integer getId() {
        return this.id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getMobilephone() {
        return this.mobilephone;
    }

    public void setMobilephone(String mobilephone) {
        this.mobilephone = mobilephone;
    }

    public String getTelephone() {
        return this.telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public String getEmail() {
        return this.email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getQq() {
        return this.qq;
    }

    public void setQq(String qq) {
        this.qq = qq;
    }

    public String getPicHead() {
        return this.picHead;
    }

    public void setPicHead(String picHead) {
        this.picHead = picHead;
    }

    public Short getSex() {
        return this.sex;
    }

    public void setSex(Short sex) {
        this.sex = sex;
    }

    public String getIdCard() {
        return this.idCard;
    }

    public void setIdCard(String idCard) {
        this.idCard = idCard;
    }

    public String getAddress() {
        return this.address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

}