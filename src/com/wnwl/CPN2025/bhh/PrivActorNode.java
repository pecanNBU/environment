package com.wnwl.CPN2025.bhh;

/**
 * PrivActorNode  @author Jenny
 */

public class PrivActorNode implements java.io.Serializable {

    // Fields

    private Integer id;
    private TreeNode treeNode;
    private PrivActor privActor;
    private Short state;

    // Constructors

    /**
     * default constructor
     */
    public PrivActorNode() {
    }

    /**
     * full constructor
     */
    public PrivActorNode(TreeNode treeNode, PrivActor privActor, Short state) {
        this.treeNode = treeNode;
        this.privActor = privActor;
        this.state = state;
    }

    // Property accessors

    public Integer getId() {
        return this.id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public TreeNode getTreeNode() {
        return this.treeNode;
    }

    public void setTreeNode(TreeNode treeNode) {
        this.treeNode = treeNode;
    }

    public PrivActor getPrivActor() {
        return this.privActor;
    }

    public void setPrivActor(PrivActor privActor) {
        this.privActor = privActor;
    }

    public Short getState() {
        return this.state;
    }

    public void setState(Short state) {
        this.state = state;
    }

}