package com.wnwl.CPN2025.service.impl;

import com.wnwl.CPN2025.bhh.DType;
import com.wnwl.CPN2025.hdao.DTypeDAO;
import com.wnwl.CPN2025.hdao.SystemInfoDAO;
import com.wnwl.CPN2025.hdao.TreeNodeDAO;
import com.wnwl.CPN2025.hdao.VersionInfoDAO;
import com.wnwl.CPN2025.service.SystemService;

public class SystemServiceImpl extends BaseServiceImpl<DType, Integer> implements SystemService {
    private DTypeDAO dTypeDAO;              //数据词典
    private TreeNodeDAO treeNodeDAO;        //模块信息
    private VersionInfoDAO versionInfoDAO;  //版本记录
    private SystemInfoDAO systemInfoDAO;

    public DTypeDAO getdTypeDAO() {
        return dTypeDAO;
    }

    public void setdTypeDAO(DTypeDAO dTypeDAO) {
        this.dTypeDAO = dTypeDAO;
    }

    public TreeNodeDAO getTreeNodeDAO() {
        return treeNodeDAO;
    }

    public void setTreeNodeDAO(TreeNodeDAO treeNodeDAO) {
        this.treeNodeDAO = treeNodeDAO;
    }

    public VersionInfoDAO getVersionInfoDAO() {
        return versionInfoDAO;
    }

    public void setVersionInfoDAO(VersionInfoDAO versionInfoDAO) {
        this.versionInfoDAO = versionInfoDAO;
    }

    public SystemInfoDAO getSystemInfoDAO() {
        return systemInfoDAO;
    }

    public void setSystemInfoDAO(SystemInfoDAO systemInfoDAO) {
        this.systemInfoDAO = systemInfoDAO;
    }
}
