package com.wnwl.CPN2025.serial;

import javax.comm.*;
import java.io.IOException;
import java.io.InputStream;
import java.util.*;

public class SerialReader1 extends Observable implements Runnable, SerialPortEventListener {
    // 端口读入数据事件触发后,等待n毫秒后再读取,以便让数据一次性读完
    public static final String PARAMS_DELAY = "delay read"; // 延时等待端口数据准备的时间
    public static final String PARAMS_TIMEOUT = "timeout"; // 超时时间
    public static final String PARAMS_PORT = "port name"; // 端口名称
    public static final String PARAMS_DATABITS = "data bits"; // 数据位
    public static final String PARAMS_STOPBITS = "stop bits"; // 停止位
    public static final String PARAMS_PARITY = "parity"; // 奇偶校验
    public static final String PARAMS_RATE = "rate"; // 波特率
    static CommPortIdentifier portId;
    @SuppressWarnings("unchecked")
    static Enumeration portList;
    private static byte[] readBuffer = new byte[4096]; // 4k的buffer空间,缓存串口读入的数据
    int delayRead = 200;
    int numBytes; // buffer中的实际数据字节数
    InputStream inputStream;
    SerialPort serialPort;
    @SuppressWarnings("unchecked")
    HashMap serialParams;

    /**
     * 初始化端口操作的参数.
     *
     * @see
     */
    @SuppressWarnings("unchecked")
    public SerialReader1(HashMap params) {
        serialParams = params;
        init();
    }

    /**
     * 显示系统端口清单信息
     */
    @SuppressWarnings("unchecked")
    static void listPorts() {
        Enumeration portEnum = CommPortIdentifier.getPortIdentifiers();
        while (portEnum.hasMoreElements()) {
            CommPortIdentifier portIdentifier = (CommPortIdentifier) portEnum.nextElement();
            System.out.println(portIdentifier.getName() + " - "
                    + getPortTypeName(portIdentifier.getPortType()));
        }
    }

    static String getPortTypeName(int portType) {
        switch (portType) {
            case CommPortIdentifier.PORT_PARALLEL:
                return "Parallel";
            case CommPortIdentifier.PORT_SERIAL:
                return "Serial";
            default:
                return "unknown type(未知端口类型)";
        }
    }

    /**
     * @return A HashSet containing the CommPortIdentifier for all serial ports that are not
     * currently being used.(返回未被使用的端口)
     */
    @SuppressWarnings("unchecked")
    public static HashSet<CommPortIdentifier> getAvailableSerialPorts() {
        HashSet<CommPortIdentifier> h = new HashSet<CommPortIdentifier>();
        Enumeration thePorts = CommPortIdentifier.getPortIdentifiers();
        while (thePorts.hasMoreElements()) {
            CommPortIdentifier com = (CommPortIdentifier) thePorts.nextElement();
            switch (com.getPortType()) {
                case CommPortIdentifier.PORT_SERIAL:
                    try {
                        CommPort thePort = com.open("CommUtil", 50);
                        thePort.close();
                        h.add(com);
                    } catch (PortInUseException e) {
                        System.out.println("Port, " + com.getName() + ", is in use.");
                    } catch (Exception e) {
                        System.out.println("Failed to open port " + com.getName() + e);
                    }
            }
        }
        return h;
    }

    private void init() {
        try {
            // 参数初始化
            int timeout = Integer.parseInt(serialParams.get(PARAMS_TIMEOUT).toString());
            int rate = Integer.parseInt(serialParams.get(PARAMS_RATE).toString());
            int dataBits = Integer.parseInt(serialParams.get(PARAMS_DATABITS).toString());
            int stopBits = Integer.parseInt(serialParams.get(PARAMS_STOPBITS).toString());
            int parity = Integer.parseInt(serialParams.get(PARAMS_PARITY).toString());
            delayRead = Integer.parseInt(serialParams.get(PARAMS_DELAY).toString());
            String port = serialParams.get(PARAMS_PORT).toString();
            // 打开端口
            portId = CommPortIdentifier.getPortIdentifier(port);
            serialPort = (SerialPort) portId.open("SerialReader", timeout);
            inputStream = serialPort.getInputStream();
            serialPort.addEventListener(this);
            serialPort.notifyOnDataAvailable(true);
            serialPort.setSerialPortParams(rate, dataBits, stopBits, parity);
        } catch (PortInUseException e) {
            System.out.println("端口已经被占用!");
            e.printStackTrace();
        } catch (TooManyListenersException e) {
            System.out.println("端口监听者过多!");
            e.printStackTrace();
        } catch (UnsupportedCommOperationException e) {
            System.out.println("端口操作命令不支持!");
            e.printStackTrace();
        } catch (NoSuchPortException e) {
            System.out.println("端口不存在!");
            e.printStackTrace();
        } catch (IOException e) {
            System.out.println("其它异常!");
            e.printStackTrace();
        }
        Thread readThread = new Thread(this);
        readThread.start();
    }

    /**
     * Method declaration
     *
     * @see
     */
    public void run() {
        try {
            Thread.sleep(100);
        } catch (InterruptedException e) {
        }
    }

    /**
     * Method declaration
     *
     * @param event
     * @see
     */
    public void serialEvent(SerialPortEvent event) {
        try {
            // 等待delayRead秒钟让串口把数据全部接收后在处理
            Thread.sleep(delayRead);
            System.out.print("serialEvent[" + event.getEventType() + "] ");
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        switch (event.getEventType()) {
            case SerialPortEvent.BI: // 10
            case SerialPortEvent.OE: // 7
            case SerialPortEvent.FE: // 9
            case SerialPortEvent.PE: // 8
            case SerialPortEvent.CD: // 6
            case SerialPortEvent.CTS: // 3
            case SerialPortEvent.DSR: // 4
            case SerialPortEvent.RI: // 5
            case SerialPortEvent.OUTPUT_BUFFER_EMPTY: // 2
                break;
            case SerialPortEvent.DATA_AVAILABLE: // 1
                try {
                    // 多次读取,将所有数据读入
                    // while (inputStream.available() > 0) {
                    // numBytes = inputStream.read(readBuffer);
                    // }
                    numBytes = inputStream.read(readBuffer);
                    StringBuilder stringBuilder = new StringBuilder("");
                    int v;
                    String hv;
                    for (int i = 0; i < readBuffer.length; i++) {
                        v = readBuffer[i] & 0xFF;
                        hv = Integer.toHexString(v).toUpperCase();
                        if (hv.length() < 2) {
                            stringBuilder.append(0);
                        }
                        stringBuilder.append(hv);
                    }
                    System.out.print("字节输出:" + stringBuilder.toString() + "\n");
                    changeMessage(readBuffer, numBytes);
                } catch (IOException e) {
                    e.printStackTrace();
                }
                break;
        }
    }

    // 通过observer pattern将收到的数据发送给observer
    // 将buffer中的空字节删除后再发送更新消息,通知观察者
    public void changeMessage(byte[] message, int length) {
        setChanged();
        byte[] temp = new byte[length];
        System.arraycopy(message, 0, temp, 0, length);
        StringBuilder stringBuilder = new StringBuilder("");
        int v;
        String hv;
        for (int i = 0; i < temp.length; i++) {
            v = temp[i] & 0xFF;
            hv = Integer.toHexString(v).toUpperCase();
            if (hv.length() < 2) {
                stringBuilder.append(0);
            }
            stringBuilder.append(hv);
        }
        System.out.println("msg[" + numBytes + "]: [" + stringBuilder.toString() + "]");
        notifyObservers(temp);
    }
}
