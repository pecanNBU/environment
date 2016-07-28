package com.wnwl.CPN2025.service.impl;

import com.sun.jna.NativeLong;
import com.sun.jna.Pointer;
import com.sun.jna.ptr.IntByReference;
import com.sun.jna.ptr.NativeLongByReference;
import com.wnwl.CPN2025.bhh.DType;
import com.wnwl.CPN2025.hdao.CameraCuriseDAO;
import com.wnwl.CPN2025.hdao.CameraInfoDAO;
import com.wnwl.CPN2025.hdao.CameraPosiDAO;
import com.wnwl.CPN2025.hdao.RegInfoDAO;
import com.wnwl.CPN2025.service.MonitorService;
import com.wnwl.CPN2025.util.HCNetSDK;
import com.wnwl.CPN2025.util.PlayCtrl;

import java.util.HashMap;

import static com.wnwl.CPN2025.util.HCNetSDK.PAN_LEFT;
import static org.aspectj.util.LangUtil.sleep;


public class MonitorServiceImpl extends BaseServiceImpl<DType, Integer> implements MonitorService {

    static HCNetSDK hCNetSDK = HCNetSDK.INSTANCE;
    static PlayCtrl playControl = PlayCtrl.INSTANCE;
    HCNetSDK.NET_DVR_DEVICEINFO_V30 m_strDeviceInfo;//设备信息
    HCNetSDK.NET_DVR_IPPARACFG m_strIpparaCfg;      //IP参数
    HCNetSDK.NET_DVR_CLIENTINFO m_strClientInfo;    //用户参数
    boolean bRealPlay;                              //是否在预览,1是，0否.
    String m_sDeviceIP;                             //已登录设备的IP地址
    NativeLong lUserID;                             //用户句柄
    NativeLong lPreviewHandle;                      //预览句柄
    NativeLongByReference m_lPort;                  //回调预览时播放库端口指针
    NativeLong lAlarmHandle;                        //报警布防句柄
    NativeLong lListenHandle;                       //报警监听句柄
    private NativeLong m_lRealHandle;//预览句柄
    private boolean m_bAutoOn;//自动左右云台
    private boolean m_bLightOn;//开启灯光
    private boolean m_bWiperOn;//开启雨刷
    private boolean m_bFanOn;//开启风扇
    private boolean m_bHeaterOn;//开启加热
    private boolean m_bAuxOn1;//开启辅助1
    private boolean m_bAuxOn2;//开启辅助2
    private boolean m_bIsOnCruise;//是否在巡航
    private int m_iBrightness;//亮度
    private int m_iContrast;//对比度
    private int m_iSaturation;//饱和度
    private int m_iHue;//色度
    private int m_iVolume;//音量
    private int iSpeed = 1;//摄像头转动速度，默认为1
    private RegInfoDAO regInfoDAO;              //设备信息
    private CameraInfoDAO cameraInfoDAO;        //摄像头信息
    private CameraCuriseDAO cameraCuriseDAO;    //摄像头巡航路线
    private CameraPosiDAO cameraPosiDAO;        //摄像头预置位

    /**
     * SDK　初始化
     *
     * @return
     */
    public boolean initSDK()        // SDK初始化
    {
        lUserID = new NativeLong(-1);
        lPreviewHandle = new NativeLong(-1);
        lAlarmHandle = new NativeLong(-1);
        lListenHandle = new NativeLong(-1);
        m_lPort = new NativeLongByReference(new NativeLong(-1));
        /*g_lVoiceHandle = new NativeLong(-1);
        fMSFCallBack = null;
        fRealDataCallBack = new FRealDataCallBack();
        m_iTreeNodeNum = 0;*/
        boolean initSuc = hCNetSDK.NET_DVR_Init();
        //设置连接时间与重连时间
        hCNetSDK.NET_DVR_SetConnectTime(2000, 1);
        hCNetSDK.NET_DVR_SetReconnect(10000, true);
        return initSuc;     //成功返回true,失败返回false;
    }

    /**
     * 注册设备
     *
     * @param m_sDeviceIP 设备IP
     * @param iPort       端口号
     * @param username    用户名
     * @param password    密码
     */
    public void LoginActionPerformed(String m_sDeviceIP, int iPort, String username, String password) {
        //注册之前先注销已注册的用户,预览情况下不可注销
        if (bRealPlay || lUserID.longValue() > -1) {
            //先注销
            hCNetSDK.NET_DVR_Logout_V30(lUserID);
            lUserID = new NativeLong(-1);
        }
        //注册
        m_strDeviceInfo = new HCNetSDK.NET_DVR_DEVICEINFO_V30();
        //-1表示失败，其他值表示返回的用户ID值。
        lUserID = hCNetSDK.NET_DVR_Login_V30(m_sDeviceIP,
                (short) iPort, username, password, m_strDeviceInfo);
        long userID = lUserID.longValue();
        if (userID == -1) {
            m_sDeviceIP = "";//登录未成功,IP置为空
        } else {
            CreateDeviceTree();
        }
    }

    /**
     * 注销并退出
     */
    public void ExitActionPerformed() {
        //如果在预览,先停止预览, 释放句柄
        if (lPreviewHandle.longValue() > -1) {
            hCNetSDK.NET_DVR_StopRealPlay(lPreviewHandle);
        }
        //报警撤防
        if (lAlarmHandle.intValue() != -1) {
            hCNetSDK.NET_DVR_CloseAlarmChan_V30(lAlarmHandle);
        }
        //停止监听
        if (lListenHandle.intValue() != -1) {
            hCNetSDK.NET_DVR_StopListen_V30(lListenHandle);
        }
        //如果已经注册,注销
        if (lUserID.longValue() > -1) {
            hCNetSDK.NET_DVR_Logout_V30(lUserID);
        }
        //cleanup SDK
        hCNetSDK.NET_DVR_Cleanup();
    }

    /**
     * 获取通道号,打开播放窗口,开始此通道的预览
     */
    public void RealPlayActionPerformed() {
        if (lUserID.intValue() == -1) {
            System.out.println("请先注册");
            return;
        }
        //如果预览窗口没打开,不预览
        if (bRealPlay == false) {
            //获取窗口句柄
            // W32API.HWND hwnd = new W32API.HWND(Native.getComponentPointer(panelRealplay));
            //获取通道号
            int iChannelNum = getChannelNumber();//通道号
            if (iChannelNum == -1) {
                System.out.println("请选择要预览的通道");
                return;
            }
            m_strClientInfo = new HCNetSDK.NET_DVR_CLIENTINFO();
            m_strClientInfo.lChannel = new NativeLong(iChannelNum);

            long previewSucValue = lPreviewHandle.longValue();
            //预览失败时:
            if (previewSucValue == -1) {
                System.out.println("预览失败");
                return;
            }
            //预览成功的操作
            bRealPlay = true;
        }
        //如果在预览,停止预览,关闭窗口
        else {
            hCNetSDK.NET_DVR_StopRealPlay(lPreviewHandle);
            bRealPlay = false;
            if (m_lPort.getValue().intValue() != -1) {
                playControl.PlayM4_Stop(m_lPort.getValue());
                m_lPort.setValue(new NativeLong(-1));
            }
        }
    }

    /**
     * 从设备树获取通道号
     */
    int getChannelNumber() {
        /*int iChannelNum = -1;
        TreePath tp = jTreeDevice.getSelectionPath();//获取选中节点的路径
        if (tp != null)//判断路径是否有效,即判断是否有通道被选中
        {
            //获取选中的通道名,对通道名进行分析:
            String sChannelName = ((DefaultMutableTreeNode) tp.getLastPathComponent()).toString();
            if (sChannelName.charAt(0) == 'C')//Camara开头表示模拟通道
            {
                //子字符串中获取通道号
                iChannelNum = Integer.parseInt(sChannelName.substring(6));
            } else {
                if (sChannelName.charAt(0) == 'I')//IPCamara开头表示IP通道
                {
                    //子字符创中获取通道号,IP通道号要加32
                    iChannelNum = Integer.parseInt(sChannelName.substring(8)) + 32;
                } else {
                    return -1;
                }
            }
        } else {
            return -1;
        }
        return iChannelNum;*/
        return 0;
    }

    /**
     * 建立设备通道
     */
    public HashMap<Integer, String> CreateDeviceTree() {
        IntByReference ibrBytesReturned = new IntByReference(0);//获取IP接入配置参数
        boolean bRet = false;
        m_strIpparaCfg = new HCNetSDK.NET_DVR_IPPARACFG();
        m_strIpparaCfg.write();
        Pointer lpIpParaConfig = m_strIpparaCfg.getPointer();
        bRet = hCNetSDK.NET_DVR_GetDVRConfig(lUserID, HCNetSDK.NET_DVR_GET_IPPARACFG, new NativeLong(0), lpIpParaConfig, m_strIpparaCfg.size(), ibrBytesReturned);
        m_strIpparaCfg.read();
        HashMap<Integer, String> ChanMap = new HashMap<Integer, String>();
        //DefaultTreeModel TreeModel = ((DefaultTreeModel) jTreeDevice.getModel());//获取树模型
        if (!bRet) {
            //设备不支持,则表示没有IP通道
            for (int iChannum = 0; iChannum < m_strDeviceInfo.byChanNum; iChannum++) {
                ChanMap.put(iChannum, "Camera" + (iChannum + m_strDeviceInfo.byStartChan));

            }
        } else {
            //设备支持IP通道
            for (int iChannum = 0; iChannum < m_strDeviceInfo.byChanNum; iChannum++) {
                if (m_strIpparaCfg.byAnalogChanEnable[iChannum] == 1) {
                    ChanMap.put(iChannum, "Camera" + (iChannum + m_strDeviceInfo.byStartChan));
                }
            }
            for (int iChannum = 0; iChannum < HCNetSDK.MAX_IP_CHANNEL; iChannum++)
                if (m_strIpparaCfg.struIPChanInfo[iChannum].byEnable == 1) {
                    ChanMap.put(iChannum, "IPCamera" + (iChannum + m_strDeviceInfo.byStartChan));
                }
        }
        return ChanMap;
    }

    /**
     * 云台控制函数 不需要启动预览画面
     *
     * @param lUserID     用户句柄
     * @param lChannel    通道句柄
     * @param iPTZCommand PTZ控制命令
     * @param iStop       开始或是停止操作
     */
    public void PTZControlAll_other(NativeLong lUserID, NativeLong lChannel, int iPTZCommand, int iStop) {
        if (lUserID.intValue() > -1) {
            hCNetSDK.NET_DVR_PTZControl_Other(lUserID, lChannel, iPTZCommand, iStop);
            return;
        }
    }

    /**
     * 云台控制函数 需要启动预览画面
     *
     * @param lRealHandle 预览句柄
     * @param iPTZCommand PTZ控制命令
     * @param iStop       开始或是停止操作
     */
    public void PTZControlAll(NativeLong lRealHandle, int iPTZCommand, int iStop) {
        boolean ret = false;
        if (lRealHandle.intValue() >= 0) {
            if (iSpeed >= 1)//有速度的ptz
            {
                ret = hCNetSDK.NET_DVR_PTZControlWithSpeed(lRealHandle, iPTZCommand, iStop, iSpeed);
                return;

            } else//速度为默认时
            {
                ret = hCNetSDK.NET_DVR_PTZControl(lRealHandle, iPTZCommand, iStop);
                return;
            }
        }
    }

    /**
     * 左上 按钮的press和release响应函数
     */

    public void LeftUpMousePressed() {
        PTZControlAll_other(lUserID, new NativeLong(1), HCNetSDK.UP_LEFT, 0);
    }

    public void LeftUpMouseReleased() {
        PTZControlAll_other(lUserID, new NativeLong(1), HCNetSDK.UP_LEFT, 1);
    }

    /**
     * 右下 按钮的press和release响应函数
     */
    public void RightDownMousePressed() {
        PTZControlAll(m_lRealHandle, HCNetSDK.DOWN_RIGHT, 0);
    }

    public void RightDownMouseReleased() {
        PTZControlAll(m_lRealHandle, HCNetSDK.DOWN_RIGHT, 1);
    }

    /**
     * 上 按钮的press和release响应函数
     */
    public void UpMousePressed() {
        // PTZControlAll(m_lRealHandle, HCNetSDK.TILT_UP, 0);
        PTZControlAll_other(lUserID, new NativeLong(1), HCNetSDK.UP_LEFT, 0);
    }

    public void UpMouseReleased() {
        PTZControlAll_other(lUserID, new NativeLong(1), HCNetSDK.UP_LEFT, 1);
    }

    public void perform() {
        UpMousePressed();
        sleep(2000);
        UpMouseReleased();
    }

    /**
     * 下 按钮的press和release响应函数
     */
    public void DownMousePressed() {
        PTZControlAll(m_lRealHandle, HCNetSDK.TILT_DOWN, 0);
    }

    public void DownMouseReleased() {
        PTZControlAll(m_lRealHandle, HCNetSDK.TILT_DOWN, 1);
    }

    /**
     * 右上 按钮的press和release响应函数
     */
    public void RightUpMousePressed() {
        PTZControlAll(m_lRealHandle, HCNetSDK.TILT_DOWN, 0);
    }

    public void RightUpMouseReleased() {
        PTZControlAll(m_lRealHandle, HCNetSDK.TILT_DOWN, 1);
    }

    /**
     * 左下 按钮的press和release响应函数
     */
    public void LeftDownMousePressed() {
        PTZControlAll(m_lRealHandle, HCNetSDK.DOWN_LEFT, 0);
    }

    public void LeftDownMouseReleased() {
        PTZControlAll(m_lRealHandle, HCNetSDK.DOWN_LEFT, 1);
    }

    /**
     * 左 按钮的press和release响应函数
     */
    public void LeftMousePressed() {
        PTZControlAll(m_lRealHandle, PAN_LEFT, 0);
    }

    public void LeftMouseReleased() {
        PTZControlAll(m_lRealHandle, PAN_LEFT, 1);
    }

    /**
     * 右 按钮的press和release响应函数
     */
    public void RightMousePressed() {
        PTZControlAll(m_lRealHandle, HCNetSDK.PAN_RIGHT, 0);
    }

    public void RightMouseReleased() {
        PTZControlAll(m_lRealHandle, HCNetSDK.PAN_RIGHT, 1);
    }

    /**
     * @param "自动"按钮 双击响应函数
     */
    public void AutoActionPerformed(int ispeed) {
        setISpeed(ispeed);
        int iSpeed = getISpeed();
        m_bAutoOn = false;
        if (!m_bAutoOn) {
            if (iSpeed >= 1) {
                hCNetSDK.NET_DVR_PTZControlWithSpeed(m_lRealHandle, HCNetSDK.PAN_AUTO, 0, iSpeed);
            } else {
                hCNetSDK.NET_DVR_PTZControl(m_lRealHandle, HCNetSDK.PAN_AUTO, 0);
            }
            m_bAutoOn = true;
        } else {
            if (iSpeed >= 1) {
                hCNetSDK.NET_DVR_PTZControlWithSpeed(m_lRealHandle, HCNetSDK.PAN_AUTO, 1, iSpeed);
            } else {
                hCNetSDK.NET_DVR_PTZControl(m_lRealHandle, HCNetSDK.PAN_AUTO, 1);
            }
            m_bAutoOn = false;
        }
    }

    /**
     * 调焦 缩 按钮的press和release响应函数
     */
    public void ZoomInMousePressed() {
        PTZControlAll(m_lRealHandle, HCNetSDK.ZOOM_IN, 0);
    }

    public void ZoomInMouseReleased() {
        PTZControlAll(m_lRealHandle, HCNetSDK.ZOOM_IN, 1);
    }

    /**
     * 调焦 伸 按钮的press和release响应函数
     */
    public void ZoomOutMousePressed() {
        PTZControlAll(m_lRealHandle, HCNetSDK.ZOOM_OUT, 0);
    }

    public void ZoomOutMouseReleased() {
        PTZControlAll(m_lRealHandle, HCNetSDK.ZOOM_OUT, 1);
    }

    /**
     * 聚焦 近 按钮的press和release响应函数
     */
    public void FocusNearMousePressed() {
        PTZControlAll(m_lRealHandle, HCNetSDK.FOCUS_NEAR, 0);
    }

    public void FocusNearMouseReleased() {
        PTZControlAll(m_lRealHandle, HCNetSDK.FOCUS_NEAR, 1);
    }

    /**
     * 聚焦 远 按钮的press和release响应函数
     */
    public void FocusFarMousePressed() {
        PTZControlAll(m_lRealHandle, HCNetSDK.FOCUS_FAR, 0);
    }

    public void FocusFarMouseReleased() {
        PTZControlAll(m_lRealHandle, HCNetSDK.FOCUS_FAR, 1);
    }

    /**
     * 光圈 开 按钮的press和release响应函数
     */
    public void IrisOpenMousePressed() {
        PTZControlAll(m_lRealHandle, HCNetSDK.IRIS_OPEN, 0);
    }

    public void IrisOpenMouseReleased() {
        PTZControlAll(m_lRealHandle, HCNetSDK.IRIS_OPEN, 1);
    }

    /**
     * 光圈 关 按钮的press和release响应函数
     */
    public void IrisCloseMousePressed() {
        PTZControlAll(m_lRealHandle, HCNetSDK.IRIS_CLOSE, 0);
    }

    public void IrisCloseMouseReleased() {
        PTZControlAll(m_lRealHandle, HCNetSDK.IRIS_CLOSE, 1);
    }

    public int getISpeed() {
        return iSpeed;
    }

    public void setISpeed(int ispeed) {
        this.iSpeed = ispeed;
    }

    public RegInfoDAO getRegInfoDAO() {
        return regInfoDAO;
    }

    public void setRegInfoDAO(RegInfoDAO regInfoDAO) {
        this.regInfoDAO = regInfoDAO;
    }

    public CameraInfoDAO getCameraInfoDAO() {
        return cameraInfoDAO;
    }

    public void setCameraInfoDAO(CameraInfoDAO cameraInfoDAO) {
        this.cameraInfoDAO = cameraInfoDAO;
    }

    public CameraCuriseDAO getCameraCuriseDAO() {
        return cameraCuriseDAO;
    }

    public void setCameraCuriseDAO(CameraCuriseDAO cameraCuriseDAO) {
        this.cameraCuriseDAO = cameraCuriseDAO;
    }

    public CameraPosiDAO getCameraPosiDAO() {
        return cameraPosiDAO;
    }

    public void setCameraPosiDAO(CameraPosiDAO cameraPosiDAO) {
        this.cameraPosiDAO = cameraPosiDAO;
    }
}
