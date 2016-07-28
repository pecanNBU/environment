package com.wnwl.CPN2025.action;

import com.wnwl.CPN2025.bhh.SystemInfo;
import com.wnwl.CPN2025.bhh.TreeNode;
import com.wnwl.CPN2025.bhh.UserInfo;
import com.wnwl.CPN2025.service.SystemService;
import com.wnwl.CPN2025.service.UserService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Jenny on 16/5/31.
 */
public class MenuAction extends BaseAction {
    private SystemService systemService;
    private UserService userService;
    private UserInfo userInfo;
    private Map<String, Object> map;
    private String hql;
    private String cond;

    public String json_top() {   //top部分
        userInfo = userService.findloginUser();
        map = new HashMap<String, Object>();
        map.put("userName", userInfo.getUserName());
        //map.put("userTypeName", userInfo.getUserType().getTypeName());
        hql = "from SystemInfo order by dt desc";
        SystemInfo systemInfo = systemService.getSystemInfoDAO().findFirstObject(hql);
        if (systemInfo != null) {
            map.put("projName", systemInfo.getName());
        }
        cond = " nodeType = 2"; //特指系统top部分右测的菜单
        List<TreeNode> listTreeNodes = systemService.getTreeNodeDAO().findSelfObjects(cond);
        List<String> listNodeNames = new ArrayList<String>();
        if (listTreeNodes != null && listTreeNodes.size() > 0) {
            for (TreeNode treeNode : listTreeNodes) {
                listNodeNames.add(treeNode.getName());
            }
        }
        map.put("listNodeNames", listNodeNames);
        return SUCCESS;
    }

    public String json_nav() {   //nav - 导航信息(只有一级菜单)
        map = new HashMap<String, Object>();
        cond = " nodeType = 1"; //特指系统nav部分的菜单
        List<TreeNode> listTreeNodes = systemService.getTreeNodeDAO().findSelfObjects(cond);
        List<String> listNodeNames = new ArrayList<String>();
        if (listTreeNodes != null && listTreeNodes.size() > 0) {
            for (TreeNode treeNode : listTreeNodes) {
                listNodeNames.add(treeNode.getName());
            }
        }
        map.put("listNodeNames", listNodeNames);
        return SUCCESS;
    }

    public Map<String, Object> getMap() {
        return map;
    }

    public SystemService getSystemService() {
        return systemService;
    }

    public void setSystemService(SystemService systemService) {
        this.systemService = systemService;
    }

    public UserService getUserService() {
        return userService;
    }

    public void setUserService(UserService userService) {
        this.userService = userService;
    }
}
