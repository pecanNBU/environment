package com.wnwl.CPN2025.serial;

import gnu.io.*;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.*;

public class SerialReader extends Observable implements Runnable, SerialPortEventListener {
    //端口读入数据事件触发后,等待n毫秒后再读取,以便让数据一次性读完
    public static final String PARAMS_DELAY = "delay read"; // 延时等待端口数据准备的时间
    public static final String PARAMS_TIMEOUT = "timeout";    // 超时时间
    public static final String PARAMS_RETRYS = "retrys";    // 重试时间（在超时时间内重试）
    public static final String PARAMS_PORT = "port name"; // 端口名称
    public static final String PARAMS_DATABITS = "data bits"; // 数据位
    public static final String PARAMS_STOPBITS = "stop bits"; // 停止位
    public static final String PARAMS_PARITY = "parity"; // 奇偶校验
    public static final String PARAMS_RATE = "rate"; // 波特率
    static CommPortIdentifier portId;
    static Enumeration portList;
    static SerialPort serialPort;
    private static byte[] readBuffer = new byte[1024]; // 4k的buffer空间,缓存串口读入的数据
    int delayRead = 100;
    int retrys = 100;    //重试时间
    int timeout = 1000;    //超时时间
    byte[] sendDatas;    //发送的内容
    DelayMsg delayMsg;
    int numBytes; // buffer中的实际数据字节数
    InputStream inputStream;
    OutputStream outputStream;
    Map<String, String> serialParams;
    Thread readThread;//本来是static类型的
    //端口是否打开了
    boolean isOpen = false;

    /**
     * 初始化端口操作的参数.
     *
     * @throws
     * @see
     */
    public SerialReader() {
        isOpen = false;
    }

    static void listPorts() {
        Enumeration portEnum = CommPortIdentifier.getPortIdentifiers();
        while (portEnum.hasMoreElements()) {
            CommPortIdentifier portIdentifier = (CommPortIdentifier) portEnum
                    .nextElement();
        }
    }

    static String getPortTypeName(int portType) {
        switch (portType) {
            case CommPortIdentifier.PORT_I2C:
                return "I2C";
            case CommPortIdentifier.PORT_PARALLEL:
                return "Parallel";
            case CommPortIdentifier.PORT_RAW:
                return "Raw";
            case CommPortIdentifier.PORT_RS485:
                return "RS485";
            case CommPortIdentifier.PORT_SERIAL:
                return "Serial";
            default:
                return "unknown type";
        }
    }

    public boolean isOpen() {
        return isOpen;
    }

    public boolean open(Map<String, String> mapSerial) {
        serialParams = mapSerial;
        if (isOpen) {
            close();
        }
        try {
            // 参数初始化
            timeout = Integer.parseInt(serialParams.get(PARAMS_TIMEOUT)
                    .toString());
            retrys = Integer.parseInt(serialParams.get(PARAMS_RETRYS)
                    .toString());
            int rate = Integer.parseInt(serialParams.get(PARAMS_RATE)
                    .toString());
            int dataBits = Integer.parseInt(serialParams.get(PARAMS_DATABITS)
                    .toString());
            int stopBits = Integer.parseInt(serialParams.get(PARAMS_STOPBITS)
                    .toString());
            int parity = Integer.parseInt(serialParams.get(PARAMS_PARITY)
                    .toString());
            delayRead = Integer.parseInt(serialParams.get(PARAMS_DELAY)
                    .toString());
            String port = serialParams.get(PARAMS_PORT).toString();
            // 打开端口
            portId = CommPortIdentifier.getPortIdentifier(port);
            serialPort = (SerialPort) portId.open("SerialReader", timeout);
            inputStream = serialPort.getInputStream();
            serialPort.addEventListener(this);
            serialPort.notifyOnDataAvailable(true);
            serialPort.setSerialPortParams(rate, dataBits, stopBits, parity);
            isOpen = true;
        } catch (PortInUseException e) {
            System.err.println("端口" + serialParams.get(PARAMS_PORT).toString() + "已经被占用");
            return false;
        } catch (TooManyListenersException e) {
            System.err.println("端口" + serialParams.get(PARAMS_PORT).toString() + "监听者过多");
            return false;
        } catch (UnsupportedCommOperationException e) {
            System.err.println("端口操作命令不支持");
            return false;
        } catch (NoSuchPortException e) {
            System.err.println("端口" + serialParams.get(PARAMS_PORT).toString() + "不存在");
            return false;
        } catch (IOException e) {
            System.err.println("打开端口" + serialParams.get(PARAMS_PORT).toString() + "失败");
            return false;
        }
        serialParams.clear();
        Thread readThread = new Thread(this);
        readThread.start();
        return true;
    }

    public void run() {
        try {
            Thread.sleep(50);
        } catch (InterruptedException e) {
        }
    }

    public void start() {
        try {
            outputStream = serialPort.getOutputStream();
        } catch (IOException e) {
        }
        try {
            readThread = new Thread(this);
            readThread.start();
        } catch (Exception e) {

        }
    }  //start() end

    public void run(byte[] msg) {
        sendDatas = msg;
        sendMsg();
        /*if(delayMsg!=null)
            delayMsg.interrupt();	//先停止上一次线程
    	delayMsg = new DelayMsg();
		new Thread(delayMsg).start();	//超时等待，促发则重发数据*/
    }

    private void sendMsg() {    //发送数据
        try {
            if (sendDatas != null && sendDatas.length > 0) {
                Thread.sleep(4);
                /*serialPort.setRTS(false);
                Thread.sleep(10); */
                outputStream.write(sendDatas);
                /*Thread.sleep(10);
                serialPort.setRTS(true);*/
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void close() {
        //if (isOpen){	//强制关闭串口
        try {
            serialPort.notifyOnDataAvailable(false);
            serialPort.removeEventListener();
            inputStream.close();
            serialPort.close();
            isOpen = false;
        } catch (IOException ex) {
            System.err.println("关闭串口失败");
            //"关闭串口失败";
        }
        //}
    }

    public void serialEvent(SerialPortEvent event) {
        if (delayMsg != null)
            delayMsg.interrupt();    //成功接收到值
        //System.err.println("serialEvent");
        try {
            Thread.sleep(delayRead);
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
                    while (inputStream.available() > 0) {
                        numBytes = inputStream.read(readBuffer);
                    }

                    //打印接收到的字节数据的ASCII码
                    for (int i = 0; i < numBytes; i++) {
                        // System.out.println("msg[" + numBytes + "]: [" +readBuffer[i] + "]:"+(char)readBuffer[i]);
                    }
//                    numBytes = inputStream.read( readBuffer );
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
        //byte[] temp = new byte[length];
        StringBuilder stringBuilder = new StringBuilder();
        int v;
        String hv;
        for (int i = 0; i < length; i++) {
            v = message[i] & 0xFF;
            hv = Integer.toHexString(v).toUpperCase();
            if (hv.length() < 2) {
                stringBuilder.append(0);
            }
            stringBuilder.append(hv);
        }
        //System.out.println("msg[" + numBytes + "]: [" + stringBuilder.toString() + "]");
        //System.arraycopy( message, 0, temp, 0, length );
        notifyObservers(message);
    }
    
    /*public void openSerialPort(String message){
        try {
			open(serialParams);//打开串口
			//LoginFrame cf=new LoginFrame();
			//addObserver(cf);
			//也可以像上面一个通过LoginFrame来绑定串口的通讯输出.
			if(message!=null&&message.length()!=0){
				String str="";
				for(int i=0;i<10;i++){
					str += message;
				}
				start(); 
			    //run(str);  
			 } 
		} catch (Exception e) { 
		}
    }*/

    public HashSet<CommPortIdentifier> getAvailableSerialPorts() {
        HashSet<CommPortIdentifier> h = new HashSet<CommPortIdentifier>();
        Enumeration thePorts = CommPortIdentifier.getPortIdentifiers();
        while (thePorts.hasMoreElements()) {
            CommPortIdentifier com = (CommPortIdentifier) thePorts
                    .nextElement();
            switch (com.getPortType()) {
                case CommPortIdentifier.PORT_SERIAL:
                    try {
                        CommPort thePort = com.open("CommUtil", 50);
                        thePort.close();
                        h.add(com);
                    } catch (PortInUseException e) {
                        System.out.println("Port, " + com.getName()
                                + ", is in use.");
                    } catch (Exception e) {
                        System.out.println("Failed to open port "
                                + com.getName() + e);
                    }
            }
        }
        return h;
    }

    private String Bytes2HexString(byte[] b) {
        String ret = "";
        for (int i = 0; i < b.length; i++) {
            String hex = Integer.toHexString(b[i] & 0xFF);
            if (hex.length() == 1) {
                hex = '0' + hex;
            }
            ret += hex.toUpperCase();
        }
        return ret;
    }

    private String hexString2binaryString(String hexString) {
        if (hexString == null || hexString.length() % 2 != 0)
            return null;
        String bString = "", tmp;
        for (int i = 0; i < hexString.length(); i++) {
            tmp = "0000" + Integer.toBinaryString(Integer.parseInt(hexString.substring(i, i + 1), 16));
            bString += tmp.substring(tmp.length() - 4);
        }
        return bString;
    }

    private String transBaudRate(byte baudRate) {    //数据位
        String sBaudRate = "";
        switch (baudRate) {
            case 1:
                sBaudRate = "110";
                break;
            case 2:
                sBaudRate = "300";
                break;
            case 3:
                sBaudRate = "600";
                break;
            case 4:
                sBaudRate = "1200";
                break;
            case 5:
                sBaudRate = "2400";
                break;
            case 6:
                sBaudRate = "4800";
                break;
            case 7:
                sBaudRate = "9600";
                break;
            case 8:
                sBaudRate = "14400";
                break;
            case 9:
                sBaudRate = "19200";
                break;
            case 10:
                sBaudRate = "38400";
                break;
            case 11:
                sBaudRate = "56000";
                break;
            case 12:
                sBaudRate = "57600";
                break;
            case 13:
                sBaudRate = "115200";
                break;
            case 14:
                sBaudRate = "128000";
                break;
            case 15:
                sBaudRate = "256000";
                break;
        }
        return sBaudRate;
    }

    private class DelayMsg extends Thread implements Runnable {    //通信超时等待
        private boolean isInterrupted = false;

        public DelayMsg() {

        }

        public void interrupt() {    //停止线程
            isInterrupted = true;
            super.interrupt();
        }

        public void run() {
            try {
                Thread.sleep(retrys);
            } catch (Exception e) {
            }
            int retryCount = 0;    //重试次数
            while (!isInterrupted && retrys * retryCount <= timeout) {
                System.err.println("retrys:" + retryCount + "|" + retrys * retryCount);
                sendMsg();
                retryCount++;
                try {
                    Thread.sleep(retrys);
                } catch (Exception e) {
                }
            }
        }

    }
}

//ASCII表
//-------------------------------------------------------------
//                 ASCII Characters                            
//                            
//Dec   Hex       Char    Code   Dec   Hex  Char
//                            
//0     0         NUL            64    40    @
//1     1         SOH            65    41    A
//2     2         STX            66    42    B
//3     3         ETX            67    43    C
//4     4         EOT            68    44    D
//5     5         ENQ            69    45    E
//6     6         ACK            70    46    F
//7     7         BEL            71    47    G
//8     8         BS             72    48    H
//9     9         HT             73    49    I
//10    0A        LF             74    4A    J
//11    0B        VT             75    4B    K
//12    0C        FF             76    4C    L
//13    0D        CR             77    4D    M
//14    0E        SO             78    4E    N
//15    0F        SI             79    4F    O
//16    10        SLE            80    50    P
//17    11        CS1            81    51    Q
//18    12        DC2            82    52    R
//19    13        DC3            83    53    S
//20    14        DC4            84    54    T
//21    15        NAK            85    55    U
//22    16        SYN            86    56    V
//23    17        ETB            87    57    W
//24    18        CAN            88    58    X
//25    19        EM             89    59    Y
//26    1A        SIB            90    5A    Z
//27    1B        ESC            91    5B    [
//                               92    5C     \
//28    1C        FS             93    5D    ]
//29    1D        GS             94    5E    ^
//30    1E        RS             95    5F    _
//31    1F        US             96    60    `
//32    20    (space)            97    61    a
//33    21        !              98    62    b
//34    22        "    
//                               99    63    c
//35    23        #              100    64    d
//36    24        $                    
//37    25        %              101    65    e
//38    26        &              102    66    f
//39    27        '              103    67    g
//40    28        (              104    68    h
//41    29        )              105    69    i
//42    2A        *              106    6A    j
//43    2B        +              107    6B    k
//44    2C        ,              108    6C    l
//45    2D        -              109    6D    m
//46    2E        .              110    6E    n
//47    2F        /              111    6F    o
//48    30        0              112    70    p
//49    31        1              113    72    q
//50    32        2              114    72    r
//51    33        3              115    73    s
//52    34        4              116    74    t
//53    35        5              117    75    u
//54    36        6              118    76    v
//55    37        7              119    77    w
//56    38        8              120    78    x
//57    39        9              121    79    y
//58    3A        :              122    7A    z
//59    3B        ;              123    7B    {
//60    3C        <              124    7C    |
//61    3D        =              125    7D    }
//62    3E        >              126    7E    ~
//63    3F        ?              127    7F    
