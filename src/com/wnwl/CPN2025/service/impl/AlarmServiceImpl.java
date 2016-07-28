package com.wnwl.CPN2025.service.impl;

import com.wnwl.CPN2025.bhh.DType;
import com.wnwl.CPN2025.hdao.*;
import com.wnwl.CPN2025.service.AlarmService;

public class AlarmServiceImpl extends BaseServiceImpl<DType, Integer> implements AlarmService {
    private RecordAlarmDAO recordAlarmDAO;          //报警记录
    private RecordAlarmPushDAO recordAlarmPushDAO;  //报警记录-推送判定
    private RecordNoiseDAO recordNoiseDAO;          //报警-噪声录音记录
    private RecordPhotoDAO recordPhotoDAO;          //报警-图片抓拍记录
    private RecordOfflineDAO recordOfflineDAO;      //报警-离线记录

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

    public RecordNoiseDAO getRecordNoiseDAO() {
        return recordNoiseDAO;
    }

    public void setRecordNoiseDAO(RecordNoiseDAO recordNoiseDAO) {
        this.recordNoiseDAO = recordNoiseDAO;
    }

    public RecordPhotoDAO getRecordPhotoDAO() {
        return recordPhotoDAO;
    }

    public void setRecordPhotoDAO(RecordPhotoDAO recordPhotoDAO) {
        this.recordPhotoDAO = recordPhotoDAO;
    }

    public RecordOfflineDAO getRecordOfflineDAO() {
        return recordOfflineDAO;
    }

    public void setRecordOfflineDAO(RecordOfflineDAO recordOfflineDAO) {
        this.recordOfflineDAO = recordOfflineDAO;
    }
}
