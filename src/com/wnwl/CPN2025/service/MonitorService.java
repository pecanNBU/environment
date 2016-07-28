package com.wnwl.CPN2025.service;

import com.sun.jna.NativeLong;
import com.wnwl.CPN2025.bhh.DType;

import java.util.HashMap;

/**
 * Simple to Introduction
 *
 * @ProjectName: 建设工程颗粒物与噪声在线监测系统
 * @Package: com.wnwl.CPN2025.service‘
 * @ClassName: 监控管理类
 * @Description: 摄像头配置、视频联动、噪声联动、视频监控、超标抓拍、超标录音
 * @Author: Jenny
 * @CreateDate: 2016.7.18
 * @UpdateUser:
 * @UpdateDate:
 * @UpdateRemark:
 * @Version: V1.0
 */
public interface MonitorService extends BaseService<DType, Integer> {


    boolean initSDK();//初始化SDK

    void LoginActionPerformed(String m_sDeviceIP, int iPort, String username, String password);//注册并登记设备

    void ExitActionPerformed();//退出

    HashMap<Integer, String> CreateDeviceTree();//构建通道树

    void perform();

    void RealPlayActionPerformed();//预览

    /**
     * 云台控制函数
     *
     * @param lRealHandle 预览句柄
     * @param iPTZCommand PTZ控制命令
     * @param iStop       开始或是停止操作
     */
    void PTZControlAll(NativeLong lRealHandle, int iPTZCommand, int iStop);

    void PTZControlAll_other(NativeLong lUserID, NativeLong lChannel, int iPTZCommand, int iStop);

    /**
     * 左上 按钮的press和release响应函数
     */
    void LeftUpMousePressed();

    void LeftUpMouseReleased();

    /**
     * 右下 按钮的press和release响应函数
     */
    void RightDownMousePressed();

    void RightDownMouseReleased();

    /**
     * * 上 按钮的press和release响应函数
     */
    void UpMousePressed();

    void UpMouseReleased();

    /**
     * 下 按钮的press和release响应函数
     */
    void DownMousePressed();

    void DownMouseReleased();

    /**
     * 右上 按钮的press和release响应函数
     */
    void RightUpMousePressed();

    void RightUpMouseReleased();

    /**
     * 左下 按钮的press和release响应函数
     */
    void LeftDownMousePressed();

    void LeftDownMouseReleased();

    /**
     * 左 按钮的press和release响应函数
     */
    void LeftMousePressed();

    void LeftMouseReleased();

    /**
     * 右 按钮的press和release响应函数
     */
    void RightMousePressed();

    void RightMouseReleased();

    //自动响应函数
    void AutoActionPerformed(int ispeed);

    /**
     * 调焦 缩 按钮的press和release响应函数
     */
    void ZoomInMousePressed();

    void ZoomInMouseReleased();

    /**
     * 调焦 伸 按钮的press和release响应函数
     */
    void ZoomOutMousePressed();

    void ZoomOutMouseReleased();

    /**
     * 聚焦 近 按钮的press和release响应函数
     */
    void FocusNearMousePressed();

    void FocusNearMouseReleased();

    /**
     * 聚焦 远 按钮的press和release响应函数
     */
    void FocusFarMousePressed();

    void FocusFarMouseReleased();

    /**
     * 光圈 开 按钮的press和release响应函数
     */
    void IrisOpenMousePressed();

    void IrisOpenMouseReleased();

    /**
     * 光圈 关 按钮的press和release响应函数
     */
    void IrisCloseMousePressed();

    void IrisCloseMouseReleased();


}
