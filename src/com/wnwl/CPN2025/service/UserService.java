package com.wnwl.CPN2025.service;

import com.wnwl.CPN2025.bhh.DType;
import com.wnwl.CPN2025.bhh.PrivActor;
import com.wnwl.CPN2025.bhh.UserInfo;
import com.wnwl.CPN2025.hdao.UserInfoDAO;

import java.util.List;

/**
 * Simple to Introduction
 *
 * @ProjectName: 建设工程颗粒物与噪声在线监测系统
 * @Package: com.wnwl.CPN2025.service
 * @ClassName: 用户管理类
 * @Description: 登录账号、建筑单位、上级部门、运营单位、角色权限
 * @Author: Jenny
 * @CreateDate: 2016.7.18
 * @UpdateUser:
 * @UpdateDate:
 * @UpdateRemark:
 * @Version: V1.0
 */
public interface UserService extends BaseService<DType, Integer> {

    UserInfo findUserByLogin(String loginName);

    UserInfo findloginUser();

    UserInfo checkLogin(String loginName, String psws);        //登录验证

    UserInfoDAO getUserInfoDAO();

    List<PrivActor> getPrivActor(Integer userId);

}
