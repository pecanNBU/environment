package com.wnwl.CPN2025.hdao.impl;

import com.wnwl.CPN2025.bhh.UserInfo;
import com.wnwl.CPN2025.hdao.UserInfoDAO;
import org.acegisecurity.Authentication;
import org.acegisecurity.context.SecurityContext;
import org.acegisecurity.context.SecurityContextHolder;
import org.acegisecurity.userdetails.UserDetails;

public class UserInfoDAOImpl extends BaseDAOImpl<UserInfo, Integer> implements UserInfoDAO {

    public UserInfoDAOImpl() {
        super(UserInfo.class);
    }

    public UserInfo findloginUser() {
        if ((SecurityContextHolder.getContext() == null)
                || !(SecurityContextHolder.getContext() instanceof SecurityContext)
                || (SecurityContextHolder.getContext()
                .getAuthentication() == null)) {
            return null;

        }
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth.getPrincipal() == null) {
            return null;
        }
        UserInfo user = null;
        UserDetails ud = (UserDetails) auth.getPrincipal();
        String loginName = ud.getUsername();
        if (null != loginName) {
            user = findUserByLogin(loginName.trim());
        }
        return user;
    }

    public UserInfo findUserByLogin(String loginName) {
        String hql = "from UserInfo where loginName ='" + loginName + "'";
        return super.findFirstObject(hql);
    }

    public UserInfo checkLogin(String loginName, String psws) {
        String hql = " from UserInfo where loginName='" + loginName + "' and userPwd='" + psws + "'";
        return super.findFirstObject(hql);
    }

}
