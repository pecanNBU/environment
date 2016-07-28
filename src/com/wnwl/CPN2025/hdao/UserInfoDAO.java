package com.wnwl.CPN2025.hdao;

import com.wnwl.CPN2025.bhh.UserInfo;

public interface UserInfoDAO extends BaseDAO<UserInfo, Integer> {

    UserInfo findloginUser();

    UserInfo findUserByLogin(String loginName);

    UserInfo checkLogin(String loginName, String psws);

}