package com.wnwl.CPN2025.bhh;

/**
 * PrivActorUser  @author Jenny
 */

public class PrivActorUser implements java.io.Serializable {

    // Fields

    private Integer id;
    private UserInfo userInfo;
    private PrivActor privActor;

    // Constructors

    /**
     * default constructor
     */
    public PrivActorUser() {
    }

    /**
     * full constructor
     */
    public PrivActorUser(UserInfo userInfo, PrivActor privActor) {
        this.userInfo = userInfo;
        this.privActor = privActor;
    }

    // Property accessors

    public Integer getId() {
        return this.id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public UserInfo getUserInfo() {
        return this.userInfo;
    }

    public void setUserInfo(UserInfo userInfo) {
        this.userInfo = userInfo;
    }

    public PrivActor getPrivActor() {
        return privActor;
    }

    public void setPrivActor(PrivActor privActor) {
        this.privActor = privActor;
    }
}