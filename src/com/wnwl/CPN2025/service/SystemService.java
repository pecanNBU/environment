package com.wnwl.CPN2025.service;

import com.wnwl.CPN2025.bhh.DType;
import com.wnwl.CPN2025.hdao.SystemInfoDAO;
import com.wnwl.CPN2025.hdao.TreeNodeDAO;

/**
 * Simple to Introduction
 *
 * @ProjectName: 建设工程颗粒物与噪声在线监测系统
 * @Package: com.wnwl.CPN2025.service
 * @ClassName: 系统管理类
 * @Description: 数据词典、模块管理、版本信息
 * @Author: Jenny
 * @CreateDate: 2016.7.18
 * @UpdateUser:
 * @UpdateDate:
 * @UpdateRemark:
 * @Version: V1.0
 */
public interface SystemService extends BaseService<DType, Integer> {

    TreeNodeDAO getTreeNodeDAO();

    SystemInfoDAO getSystemInfoDAO();

}
