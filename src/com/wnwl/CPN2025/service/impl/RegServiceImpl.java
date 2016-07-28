package com.wnwl.CPN2025.service.impl;

import com.wnwl.CPN2025.bhh.DType;
import com.wnwl.CPN2025.hdao.*;
import com.wnwl.CPN2025.service.RegService;

public class RegServiceImpl extends BaseServiceImpl<DType, Integer> implements RegService {
    private RegInfoDAO regInfoDAO;              //设备基础数据
    private RegParamDAO regParamDAO;            //设备参数数据
    private RegAlarmOverDAO regAlarmOverDAO;    //设备超标报警
    private RegAlarmTrendDAO regAlarmTrendDAO;  //设备趋势报警
    private PmStateDAO pmStateDAO;              //颗粒物指数状态表
    private DataInvalidDAO dataInvalidDAO;      //无效数据规则表

    public RegInfoDAO getRegInfoDAO() {
        return regInfoDAO;
    }

    public void setRegInfoDAO(RegInfoDAO regInfoDAO) {
        this.regInfoDAO = regInfoDAO;
    }

    public RegParamDAO getRegParamDAO() {
        return regParamDAO;
    }

    public void setRegParamDAO(RegParamDAO regParamDAO) {
        this.regParamDAO = regParamDAO;
    }

    public RegAlarmOverDAO getRegAlarmOverDAO() {
        return regAlarmOverDAO;
    }

    public void setRegAlarmOverDAO(RegAlarmOverDAO regAlarmOverDAO) {
        this.regAlarmOverDAO = regAlarmOverDAO;
    }

    public RegAlarmTrendDAO getRegAlarmTrendDAO() {
        return regAlarmTrendDAO;
    }

    public void setRegAlarmTrendDAO(RegAlarmTrendDAO regAlarmTrendDAO) {
        this.regAlarmTrendDAO = regAlarmTrendDAO;
    }

    public PmStateDAO getPmStateDAO() {
        return pmStateDAO;
    }

    public void setPmStateDAO(PmStateDAO pmStateDAO) {
        this.pmStateDAO = pmStateDAO;
    }

    public DataInvalidDAO getDataInvalidDAO() {
        return dataInvalidDAO;
    }

    public void setDataInvalidDAO(DataInvalidDAO dataInvalidDAO) {
        this.dataInvalidDAO = dataInvalidDAO;
    }
}
