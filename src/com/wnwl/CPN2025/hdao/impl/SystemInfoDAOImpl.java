package com.wnwl.CPN2025.hdao.impl;

import com.wnwl.CPN2025.bhh.SystemInfo;
import com.wnwl.CPN2025.hdao.SystemInfoDAO;

public class SystemInfoDAOImpl extends BaseDAOImpl<SystemInfo, Integer> implements SystemInfoDAO {

    public SystemInfoDAOImpl() {
        super(SystemInfo.class);
    }

}
