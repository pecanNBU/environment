package com.wnwl.CPN2025.service.impl;

import com.wnwl.CPN2025.bhh.DType;
import com.wnwl.CPN2025.hdao.AlarmPushDAO;
import com.wnwl.CPN2025.hdao.AlarmPushIgnoreDAO;
import com.wnwl.CPN2025.hdao.RecordAlarmDAO;
import com.wnwl.CPN2025.hdao.RecordAlarmPushDAO;
import com.wnwl.CPN2025.service.DataPushService;

public class DataPushServiceImpl extends BaseServiceImpl<DType, Integer> implements DataPushService {
    private RecordAlarmDAO recordAlarmDAO;          //报警记录
    private RecordAlarmPushDAO recordAlarmPushDAO;  //报警记录-推送
    private AlarmPushDAO alarmPushDAO;              //报警推送-触发条件
    private AlarmPushIgnoreDAO alarmPushIgnoreDAO;  //报警推送-忽视参数

    public RecordAlarmDAO getRecordAlarmDAO() {
        return recordAlarmDAO;
    }

    public void setRecordAlarmDAO(RecordAlarmDAO recordAlarmDAO) {
        this.recordAlarmDAO = recordAlarmDAO;
    }

    public RecordAlarmPushDAO getRecordAlarmPushDAO() {
        return recordAlarmPushDAO;
    }

    public void setRecordAlarmPushDAO(RecordAlarmPushDAO recordAlarmPushDAO) {
        this.recordAlarmPushDAO = recordAlarmPushDAO;
    }

    public AlarmPushDAO getAlarmPushDAO() {
        return alarmPushDAO;
    }

    public void setAlarmPushDAO(AlarmPushDAO alarmPushDAO) {
        this.alarmPushDAO = alarmPushDAO;
    }

    public AlarmPushIgnoreDAO getAlarmPushIgnoreDAO() {
        return alarmPushIgnoreDAO;
    }

    public void setAlarmPushIgnoreDAO(AlarmPushIgnoreDAO alarmPushIgnoreDAO) {
        this.alarmPushIgnoreDAO = alarmPushIgnoreDAO;
    }
}
