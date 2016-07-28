package com.wnwl.CPN2025.service.impl;

import com.wnwl.CPN2025.bhh.DType;
import com.wnwl.CPN2025.hdao.RecordDataBackupDAO;
import com.wnwl.CPN2025.hdao.RecordDataDAO;
import com.wnwl.CPN2025.hdao.RecordDataImportDAO;
import com.wnwl.CPN2025.service.DatabaseService;

public class DatabaseServiceImpl extends BaseServiceImpl<DType, Integer> implements DatabaseService {
    private RecordDataDAO recordDataDAO;                //数据记录
    private RecordDataBackupDAO recordDataBackupDAO;    //数据库备份记录
    private RecordDataImportDAO recordDataImportDAO;    //数据库导入记录

    public RecordDataDAO getRecordDataDAO() {
        return recordDataDAO;
    }

    public void setRecordDataDAO(RecordDataDAO recordDataDAO) {
        this.recordDataDAO = recordDataDAO;
    }

    public RecordDataBackupDAO getRecordDataBackupDAO() {
        return recordDataBackupDAO;
    }

    public void setRecordDataBackupDAO(RecordDataBackupDAO recordDataBackupDAO) {
        this.recordDataBackupDAO = recordDataBackupDAO;
    }

    public RecordDataImportDAO getRecordDataImportDAO() {
        return recordDataImportDAO;
    }

    public void setRecordDataImportDAO(RecordDataImportDAO recordDataImportDAO) {
        this.recordDataImportDAO = recordDataImportDAO;
    }
}
