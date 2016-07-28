package com.wnwl.CPN2025.service.impl;

import com.wnwl.CPN2025.bhh.DType;
import com.wnwl.CPN2025.hdao.LogLoginDAO;
import com.wnwl.CPN2025.hdao.LogOperContDAO;
import com.wnwl.CPN2025.hdao.LogOperDAO;
import com.wnwl.CPN2025.hdao.LogShowDAO;
import com.wnwl.CPN2025.service.LogService;

public class LogServiceImpl extends BaseServiceImpl<DType, Integer> implements LogService {
    private LogLoginDAO logLoginDAO;        //日志-登录
    private LogShowDAO logShowDAO;          //日志-浏览
    private LogOperDAO logOperDAO;          //日志-操作基础表
    private LogOperContDAO logOperContDAO;  //日志-操作详情表

    public LogLoginDAO getLogLoginDAO() {
        return logLoginDAO;
    }

    public void setLogLoginDAO(LogLoginDAO logLoginDAO) {
        this.logLoginDAO = logLoginDAO;
    }

    public LogShowDAO getLogShowDAO() {
        return logShowDAO;
    }

    public void setLogShowDAO(LogShowDAO logShowDAO) {
        this.logShowDAO = logShowDAO;
    }

    public LogOperDAO getLogOperDAO() {
        return logOperDAO;
    }

    public void setLogOperDAO(LogOperDAO logOperDAO) {
        this.logOperDAO = logOperDAO;
    }

    public LogOperContDAO getLogOperContDAO() {
        return logOperContDAO;
    }

    public void setLogOperContDAO(LogOperContDAO logOperContDAO) {
        this.logOperContDAO = logOperContDAO;
    }
}
