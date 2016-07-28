package com.wnwl.CPN2025.service.impl;

import com.wnwl.CPN2025.bhh.DType;
import com.wnwl.CPN2025.hdao.*;
import com.wnwl.CPN2025.service.OperationService;

public class OperationServiceImpl extends BaseServiceImpl<DType, Integer> implements OperationService {
    private FormCaliNoiseDAO formCaliNoiseDAO;  //噪声在线监测仪校准记录-基础表
    private FormNoiseDataDAO formNoiseDataDAO;  //噪声在线检测仪校准记录-数据表
    private FormCaliFlowDAO formCaliFlowDAO;    //流量校准记录表
    private FormCaliPmDAO formCaliPmDAO;        //颗粒物检测仪校准记录表
    private FormCommCheckDAO formCommCheckDAO;  //通信维护记录表
    private FormDataCheckDAO formDataCheckDAO;  //数据核查记录表
    private FormDevChangeDAO formDevChangeDAO;  //设备更换记录表
    private FormDevCleanDAO formDevCleanDAO;    //清洗保养记录表
    private FormDevFaultDAO formDevFaultDAO;    //故障修复记录表
    private FormDevMoveDAO formDevMoveDAO;      //设备移机记录表
    private FormDevRepairDAO formDevRepairDAO;  //检修维修记录表
    private FormFeedbackDAO formFeedbackDAO;    //反馈意见记录表
    private FormPollDayDAO formPollDayDAO;      //巡检记录-日巡检
    private FormPollMonthDAO formPollMonthDAO;  //巡检记录-周汇报
    private FormPollWeekDAO formPollWeekDAO;    //巡检记录-月巡检
    private FormPollYearDAO formPollYearDAO;    //巡检记录-年报表
    private FormQualCheckDAO formQualCheckDAO;  //质量抽检/对比测试记录表
    private FormTraceValDAO formTraceValDAO;    //量值溯源记录表

    public FormCaliNoiseDAO getFormCaliNoiseDAO() {
        return formCaliNoiseDAO;
    }

    public void setFormCaliNoiseDAO(FormCaliNoiseDAO formCaliNoiseDAO) {
        this.formCaliNoiseDAO = formCaliNoiseDAO;
    }

    public FormCaliFlowDAO getFormCaliFlowDAO() {
        return formCaliFlowDAO;
    }

    public void setFormCaliFlowDAO(FormCaliFlowDAO formCaliFlowDAO) {
        this.formCaliFlowDAO = formCaliFlowDAO;
    }

    public FormCaliPmDAO getFormCaliPmDAO() {
        return formCaliPmDAO;
    }

    public void setFormCaliPmDAO(FormCaliPmDAO formCaliPmDAO) {
        this.formCaliPmDAO = formCaliPmDAO;
    }

    public FormCommCheckDAO getFormCommCheckDAO() {
        return formCommCheckDAO;
    }

    public void setFormCommCheckDAO(FormCommCheckDAO formCommCheckDAO) {
        this.formCommCheckDAO = formCommCheckDAO;
    }

    public FormDataCheckDAO getFormDataCheckDAO() {
        return formDataCheckDAO;
    }

    public void setFormDataCheckDAO(FormDataCheckDAO formDataCheckDAO) {
        this.formDataCheckDAO = formDataCheckDAO;
    }

    public FormDevChangeDAO getFormDevChangeDAO() {
        return formDevChangeDAO;
    }

    public void setFormDevChangeDAO(FormDevChangeDAO formDevChangeDAO) {
        this.formDevChangeDAO = formDevChangeDAO;
    }

    public FormDevCleanDAO getFormDevCleanDAO() {
        return formDevCleanDAO;
    }

    public void setFormDevCleanDAO(FormDevCleanDAO formDevCleanDAO) {
        this.formDevCleanDAO = formDevCleanDAO;
    }

    public FormDevFaultDAO getFormDevFaultDAO() {
        return formDevFaultDAO;
    }

    public void setFormDevFaultDAO(FormDevFaultDAO formDevFaultDAO) {
        this.formDevFaultDAO = formDevFaultDAO;
    }

    public FormDevMoveDAO getFormDevMoveDAO() {
        return formDevMoveDAO;
    }

    public void setFormDevMoveDAO(FormDevMoveDAO formDevMoveDAO) {
        this.formDevMoveDAO = formDevMoveDAO;
    }

    public FormDevRepairDAO getFormDevRepairDAO() {
        return formDevRepairDAO;
    }

    public void setFormDevRepairDAO(FormDevRepairDAO formDevRepairDAO) {
        this.formDevRepairDAO = formDevRepairDAO;
    }

    public FormFeedbackDAO getFormFeedbackDAO() {
        return formFeedbackDAO;
    }

    public void setFormFeedbackDAO(FormFeedbackDAO formFeedbackDAO) {
        this.formFeedbackDAO = formFeedbackDAO;
    }

    public FormNoiseDataDAO getFormNoiseDataDAO() {
        return formNoiseDataDAO;
    }

    public void setFormNoiseDataDAO(FormNoiseDataDAO formNoiseDataDAO) {
        this.formNoiseDataDAO = formNoiseDataDAO;
    }

    public FormPollDayDAO getFormPollDayDAO() {
        return formPollDayDAO;
    }

    public void setFormPollDayDAO(FormPollDayDAO formPollDayDAO) {
        this.formPollDayDAO = formPollDayDAO;
    }

    public FormPollMonthDAO getFormPollMonthDAO() {
        return formPollMonthDAO;
    }

    public void setFormPollMonthDAO(FormPollMonthDAO formPollMonthDAO) {
        this.formPollMonthDAO = formPollMonthDAO;
    }

    public FormPollWeekDAO getFormPollWeekDAO() {
        return formPollWeekDAO;
    }

    public void setFormPollWeekDAO(FormPollWeekDAO formPollWeekDAO) {
        this.formPollWeekDAO = formPollWeekDAO;
    }

    public FormPollYearDAO getFormPollYearDAO() {
        return formPollYearDAO;
    }

    public void setFormPollYearDAO(FormPollYearDAO formPollYearDAO) {
        this.formPollYearDAO = formPollYearDAO;
    }

    public FormQualCheckDAO getFormQualCheckDAO() {
        return formQualCheckDAO;
    }

    public void setFormQualCheckDAO(FormQualCheckDAO formQualCheckDAO) {
        this.formQualCheckDAO = formQualCheckDAO;
    }

    public FormTraceValDAO getFormTraceValDAO() {
        return formTraceValDAO;
    }

    public void setFormTraceValDAO(FormTraceValDAO formTraceValDAO) {
        this.formTraceValDAO = formTraceValDAO;
    }
}
