package com.wnwl.CPN2025.serial;

import net.wimpi.modbus.io.ModbusSerialTransaction;
import net.wimpi.modbus.msg.ReadMultipleRegistersRequest;
import net.wimpi.modbus.msg.ReadMultipleRegistersResponse;
import net.wimpi.modbus.net.SerialConnection;
import net.wimpi.modbus.util.SerialParameters;

public class ModbusTest {

    public static void main(String[] args) {
        try {
            long time1 = System.currentTimeMillis();
            //ReadMultipleRegistersResponse res = null; // the response
            SerialParameters params = new SerialParameters();
            params.setPortName("COM3");
            params.setBaudRate(38400);
            params.setDatabits(8);
            params.setParity("none");
            params.setStopbits(1);
            params.setEncoding("rtu");
            params.setEcho(false);
            params.setReceiveTimeout(25);

            SerialConnection con = new SerialConnection(params);
            con.open();
            ReadMultipleRegistersRequest req = new ReadMultipleRegistersRequest(0, 16);
            req.setUnitID(1);
            req.setHeadless();
            ModbusSerialTransaction trans = new ModbusSerialTransaction(con);
            trans.setRetries(5);
            trans.setRequest(req);
            int k = 0;
            ReadInputs readInputs;
            while (k < 10) {
                readInputs = new ReadInputs(trans, k);
                new Thread(readInputs).start();
                Thread.sleep(50);
                k++;
            }
            // 6. Close the connection
            con.close();
            long time2 = System.currentTimeMillis();
            System.err.println(time2 - time1);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static class ReadInputs implements Runnable {
        private ModbusSerialTransaction trans;
        private int k;
        private ReadMultipleRegistersResponse res;

        public ReadInputs(ModbusSerialTransaction trans, int k) {
            this.trans = trans;
            this.k = k;
        }

        public void run() {
            try {
                trans.execute();
                res = (ReadMultipleRegistersResponse) trans.getResponse();
                System.err.println(k + "|" + res.getRegisterValue(0));
                for (int n = 0; n < res.getWordCount(); n++) {
                    //System.out.println(res.getRegisterValue(n));
                }
            } catch (Exception e) {
                e.getMessage();
            }
        }
    }
}
