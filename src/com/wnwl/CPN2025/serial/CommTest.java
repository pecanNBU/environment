package com.wnwl.CPN2025.serial;

import javax.comm.SerialPort;
import java.util.HashMap;

public class CommTest {

    @SuppressWarnings("unchecked")
    public static void main(String[] args) {
        HashMap<String, Comparable> params = new HashMap<String, Comparable>();
        params.put(SerialReader1.PARAMS_PORT, "COM10"); // 端口名称
        params.put(SerialReader1.PARAMS_RATE, 115200); // 波特率
        params.put(SerialReader1.PARAMS_TIMEOUT, 1000); // 设备超时时间 1秒
        params.put(SerialReader1.PARAMS_DELAY, 200); // 端口数据准备时间 1秒
        params.put(SerialReader1.PARAMS_DATABITS, SerialPort.DATABITS_8); // 数据位
        params.put(SerialReader1.PARAMS_STOPBITS, SerialPort.STOPBITS_1); // 停止位
        params.put(SerialReader1.PARAMS_PARITY, SerialPort.PARITY_NONE); // 无奇偶校验
        SerialReader1 sr = new SerialReader1(params);
        CommDataObserver bob = new CommDataObserver("bob");
        //CommDataObserver joe = new CommDataObserver("joe");
        //sr.addObserver(joe);
        sr.addObserver(bob);
        //sr.listPorts();//系统端口清单
        //sr.getAvailableSerialPorts();//系统未使用的端口
    }
}
