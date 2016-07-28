package com.wnwl.CPN2025.serial;

import javax.comm.*;
import java.io.IOException;
import java.io.InputStream;
import java.util.Enumeration;
import java.util.TooManyListenersException;

/**
 * Class declaration
 *
 * @author
 * @version 1.8, 08/03/00
 */
public class SimpleRead implements Runnable, SerialPortEventListener {
    static CommPortIdentifier portId;
    static Enumeration portList;
    InputStream inputStream;
    SerialPort serialPort;
    Thread readThread;

    /**
     * Constructor declaration
     *
     * @see
     */
    public SimpleRead() {
        try {
            serialPort = (SerialPort) portId.open("SimpleReadApp", 2000);
        } catch (PortInUseException e) {
        }

        try {
            inputStream = serialPort.getInputStream();
        } catch (IOException e) {
        }

        try {
            serialPort.addEventListener(this);
        } catch (TooManyListenersException e) {
        }

        serialPort.notifyOnDataAvailable(true);

        try {
            serialPort.setSerialPortParams(9600, SerialPort.DATABITS_8,
                    SerialPort.STOPBITS_1,
                    SerialPort.PARITY_NONE);
        } catch (UnsupportedCommOperationException e) {
        }

        readThread = new Thread(this);

        readThread.start();
    }

    /**
     * Method declaration
     *
     * @param args
     * @see
     */
    public static void main(String[] args) {
        boolean portFound = false;
        String defaultPort = "COM3";

        if (args.length > 0) {
            defaultPort = args[0];
        }

        portList = CommPortIdentifier.getPortIdentifiers();

        while (portList.hasMoreElements()) {
            portId = (CommPortIdentifier) portList.nextElement();
            if (portId.getPortType() == CommPortIdentifier.PORT_SERIAL) {
                if (portId.getName().equals(defaultPort)) {
                    System.out.println("Found port: " + defaultPort);
                    portFound = true;
                    SimpleRead reader = new SimpleRead();
                }
            }
        }
        if (!portFound) {
            System.out.println("port " + defaultPort + " not found.");
        }

    }

    /**
     * Method declaration
     *
     * @see
     */
    public void run() {
        try {
            Thread.sleep(20000);
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
        switch (event.getEventType()) {

            case SerialPortEvent.BI:

            case SerialPortEvent.OE:

            case SerialPortEvent.FE:

            case SerialPortEvent.PE:

            case SerialPortEvent.CD:

            case SerialPortEvent.CTS:

            case SerialPortEvent.DSR:

            case SerialPortEvent.RI:

            case SerialPortEvent.OUTPUT_BUFFER_EMPTY:
                break;

            case SerialPortEvent.DATA_AVAILABLE:
                byte[] readBuffer = new byte[20];

                try {
                    while (inputStream.available() > 0) {
                        int numBytes = inputStream.read(readBuffer);
                    }

                    System.out.print(new String(readBuffer));
                } catch (IOException e) {
                }

                break;
        }
    }

}




