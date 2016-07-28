package com.wnwl.CPN2025.hdao.impl;

import com.wnwl.CPN2025.bhh.UserDetail;
import com.wnwl.CPN2025.hdao.UserDetailDAO;

public class UserDetailDAOImpl extends BaseDAOImpl<UserDetail, Integer> implements UserDetailDAO {

    public UserDetailDAOImpl() {
        super(UserDetail.class);
    }

}
