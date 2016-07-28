package com.wnwl.CPN2025.hdao.impl;

import com.wnwl.CPN2025.bhh.TreeNode;
import com.wnwl.CPN2025.hdao.TreeNodeDAO;

public class TreeNodeDAOImpl extends BaseDAOImpl<TreeNode, Integer> implements TreeNodeDAO {

    public TreeNodeDAOImpl() {
        super(TreeNode.class);
    }

}
