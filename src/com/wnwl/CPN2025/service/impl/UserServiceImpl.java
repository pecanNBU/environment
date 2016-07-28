package com.wnwl.CPN2025.service.impl;

import com.wnwl.CPN2025.bhh.DType;
import com.wnwl.CPN2025.bhh.PrivActor;
import com.wnwl.CPN2025.bhh.UserInfo;
import com.wnwl.CPN2025.hdao.*;
import com.wnwl.CPN2025.service.UserService;

import java.util.List;

public class UserServiceImpl extends BaseServiceImpl<DType, Integer> implements UserService {
    private DepConsDAO depConsDAO;              //建筑工地
    private DepSupeDAO depSupeDAO;              //上级单位、环保部门
    private DepOperDAO depOperDAO;              //运维部门
    private UserInfoDAO userInfoDAO;            //用户基本信息
    private UserDetailDAO userDetailDAO;        //用户扩展信息
    private PrivActorDAO privActorDAO;          //角色基本
    private PrivActorNodeDAO privActorNodeDAO;  //角色-节点
    private PrivActorUserDAO privActorUserDAO;  //角色-用户

    public UserInfo findloginUser() {
        return userInfoDAO.findloginUser();
    }

    public UserInfo findUserByLogin(String loginName) {
        return userInfoDAO.findUserByLogin(loginName);
    }

    public UserInfo checkLogin(String loginName, String psws) {
        return userInfoDAO.checkLogin(loginName, psws);
    }

    public List<PrivActor> getPrivActor(Integer userId) {
        return privActorDAO.getPrivActor(userId);
    }

    public DepConsDAO getDepConsDAO() {
        return depConsDAO;
    }

    public void setDepConsDAO(DepConsDAO depConsDAO) {
        this.depConsDAO = depConsDAO;
    }

    public DepSupeDAO getDepSupeDAO() {
        return depSupeDAO;
    }

    public void setDepSupeDAO(DepSupeDAO depSupeDAO) {
        this.depSupeDAO = depSupeDAO;
    }

    public DepOperDAO getDepOperDAO() {
        return depOperDAO;
    }

    public void setDepOperDAO(DepOperDAO depOperDAO) {
        this.depOperDAO = depOperDAO;
    }

    public UserInfoDAO getUserInfoDAO() {
        return userInfoDAO;
    }

    public void setUserInfoDAO(UserInfoDAO userInfoDAO) {
        this.userInfoDAO = userInfoDAO;
    }

    public UserDetailDAO getUserDetailDAO() {
        return userDetailDAO;
    }

    public void setUserDetailDAO(UserDetailDAO userDetailDAO) {
        this.userDetailDAO = userDetailDAO;
    }

    public PrivActorDAO getPrivActorDAO() {
        return privActorDAO;
    }

    public void setPrivActorDAO(PrivActorDAO privActorDAO) {
        this.privActorDAO = privActorDAO;
    }

    public PrivActorNodeDAO getPrivActorNodeDAO() {
        return privActorNodeDAO;
    }

    public void setPrivActorNodeDAO(PrivActorNodeDAO privActorNodeDAO) {
        this.privActorNodeDAO = privActorNodeDAO;
    }

    public PrivActorUserDAO getPrivActorUserDAO() {
        return privActorUserDAO;
    }

    public void setPrivActorUserDAO(PrivActorUserDAO privActorUserDAO) {
        this.privActorUserDAO = privActorUserDAO;
    }
}
