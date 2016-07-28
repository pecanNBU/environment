package com.wnwl.CPN2025.hdao.impl;

import com.wnwl.CPN2025.bhh.VersionInfo;
import com.wnwl.CPN2025.hdao.VersionInfoDAO;

public class VersionInfoDAOImpl extends BaseDAOImpl<VersionInfo, Integer> implements VersionInfoDAO {

    public VersionInfoDAOImpl() {
        super(VersionInfo.class);
    }

}
