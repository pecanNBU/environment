package com.wnwl.CPN2025.bhh;

public class SystemInfo {
    private Integer id;
    private UserInfo chargeUser;
    private String name;
    private String abbr;
    private String version;
    private String comment;
    private int dt;
    private String copyright;
    private String telephone;
    private String mobilephone;
    private String fax;
    private String email;
    private String web;

    public SystemInfo() {

    }

    public SystemInfo(Integer id, UserInfo chargeUser, String name, String abbr, String version, String comment, int dt,
                      String copyright, String telephone, String mobilephone, String fax, String email, String web) {
        this.id = id;
        this.chargeUser = chargeUser;
        this.name = name;
        this.abbr = abbr;
        this.version = version;
        this.comment = comment;
        this.dt = dt;
        this.copyright = copyright;
        this.telephone = telephone;
        this.mobilephone = mobilephone;
        this.fax = fax;
        this.email = email;
        this.web = web;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public UserInfo getChargeUser() {
        return chargeUser;
    }

    public void setChargeUser(UserInfo chargeUser) {
        this.chargeUser = chargeUser;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAbbr() {
        return abbr;
    }

    public void setAbbr(String abbr) {
        this.abbr = abbr;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public int getDt() {
        return dt;
    }

    public void setDt(int dt) {
        this.dt = dt;
    }

    public String getCopyright() {
        return copyright;
    }

    public void setCopyright(String copyright) {
        this.copyright = copyright;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public String getMobilephone() {
        return mobilephone;
    }

    public void setMobilephone(String mobilephone) {
        this.mobilephone = mobilephone;
    }

    public String getFax() {
        return fax;
    }

    public void setFax(String fax) {
        this.fax = fax;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getWeb() {
        return web;
    }

    public void setWeb(String web) {
        this.web = web;
    }

}
