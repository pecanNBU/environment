package com.wnwl.CPN2025.bhh;

/**
 * PrivActor  @author Jenny
 */

public class PrivActor implements java.io.Serializable {

    // Fields

    private Integer id;
    private String actorName;
    private String actorDesc;
    private String name;

    // Constructors

    /**
     * default constructor
     */
    public PrivActor() {
    }

    /**
     * full constructor
     */
    public PrivActor(String actorName, String actorDesc, String name) {
        this.actorName = actorName;
        this.actorDesc = actorDesc;
        this.name = name;
    }

    // Property accessors

    public Integer getId() {
        return this.id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getActorName() {
        return this.actorName;
    }

    public void setActorName(String actorName) {
        this.actorName = actorName;
    }

    public String getActorDesc() {
        return this.actorDesc;
    }

    public void setActorDesc(String actorDesc) {
        this.actorDesc = actorDesc;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

}