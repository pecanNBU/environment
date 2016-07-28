package com.wnwl.CPN2025.bhh;

import java.util.HashSet;
import java.util.Set;

/**
 * TreeNode  @author Jenny
 */

public class TreeNode implements java.io.Serializable {

    // Fields

    private Integer id;
    private TreeNode treeNode;
    private String name;
    private Short type;
    private String url;
    private String title;
    private Short sort;
    private String icon;
    private String comment;
    private Set treeNodes = new HashSet(0);
    private Set privActorUsers = new HashSet(0);
    private Set privActorNodeses = new HashSet(0);

    // Constructors

    /**
     * default constructor
     */
    public TreeNode() {
    }

    /**
     * minimal constructor
     */
    public TreeNode(TreeNode treeNode, String name) {
        this.treeNode = treeNode;
        this.name = name;
    }

    /**
     * full constructor
     */
    public TreeNode(TreeNode treeNode, String name, Short type, String url,
                    String title, Short sort, String icon, String comment,
                    Set treeNodes, Set privActorUsers, Set privActorNodeses) {
        this.treeNode = treeNode;
        this.name = name;
        this.type = type;
        this.url = url;
        this.title = title;
        this.sort = sort;
        this.icon = icon;
        this.comment = comment;
        this.treeNodes = treeNodes;
        this.privActorUsers = privActorUsers;
        this.privActorNodeses = privActorNodeses;
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

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Short getType() {
        return this.type;
    }

    public void setType(Short type) {
        this.type = type;
    }

    public String getUrl() {
        return this.url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getTitle() {
        return this.title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Short getSort() {
        return this.sort;
    }

    public void setSort(Short sort) {
        this.sort = sort;
    }

    public String getIcon() {
        return this.icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public String getComment() {
        return this.comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Set getTreeNodes() {
        return this.treeNodes;
    }

    public void setTreeNodes(Set treeNodes) {
        this.treeNodes = treeNodes;
    }

    public Set getPrivActorUsers() {
        return this.privActorUsers;
    }

    public void setPrivActorUsers(Set privActorUsers) {
        this.privActorUsers = privActorUsers;
    }

    public Set getPrivActorNodeses() {
        return this.privActorNodeses;
    }

    public void setPrivActorNodeses(Set privActorNodeses) {
        this.privActorNodeses = privActorNodeses;
    }

}