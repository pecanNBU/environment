package com.wnwl.CPN2025.service.impl;

import com.wnwl.CPN2025.bhh.DType;
import com.wnwl.CPN2025.hdao.RecordDataDAO;
import com.wnwl.CPN2025.hdao.RecordOfflineDAO;
import com.wnwl.CPN2025.hdao.RegInfoDAO;
import com.wnwl.CPN2025.service.AnalyseService;

public class AnalyseServiceImpl extends BaseServiceImpl<DType, Integer> implements AnalyseService {
    private RecordDataDAO recordDataDAO;        //历史数据
    private RecordOfflineDAO recordOfflineDAO;  //离线记录
    private RegInfoDAO regInfoDAO;              //监测点信息表

    public RecordDataDAO getRecordDataDAO() {
        return recordDataDAO;
    }

    public void setRecordDataDAO(RecordDataDAO recordDataDAO) {
        this.recordDataDAO = recordDataDAO;
    }

    public RecordOfflineDAO getRecordOfflineDAO() {
        return recordOfflineDAO;
    }

    public void setRecordOfflineDAO(RecordOfflineDAO recordOfflineDAO) {
        this.recordOfflineDAO = recordOfflineDAO;
    }

    public RegInfoDAO getRegInfoDAO() {
        return regInfoDAO;
    }

    public void setRegInfoDAO(RegInfoDAO regInfoDAO) {
        this.regInfoDAO = regInfoDAO;
    }
}
