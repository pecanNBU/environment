package com.wnwl.CPN2025.action;

import com.wnwl.CPN2025.bhh.RegInfo;
import com.wnwl.CPN2025.service.RTMonitorService;
import com.wnwl.CPN2025.util.PageBean;

import java.text.DecimalFormat;
import java.util.*;

public class ChartAction extends BaseAction {
    private static final long serialVersionUID = 3396125567153866581L;
    private RTMonitorService rtMonitorService;
    private List<RegInfo> regInfos;
    private String hql;
    private String cond;
    private PageBean pageBean;
    private int jumpPage;
    private int pageSize;
    private ArrayList<Object> rows;
    private Map<String, Object> map;
    private LinkedHashMap<String, Object> linkedMap;
    private Integer regId;
    private String regIds;
    private String lastDts;
    private String lastDatas;
    private Integer depId;
    private Integer period;
    private String stDt;
    private String endDt;
    private int dtBet;
    private String sql;
    private int secLast;
    private int secNow;
    private float experVolt;
    private String noteIds;
    private Long lastDt;    //最新时间，用户判断是否为最新数据
    private String stDtContr;  //历史同比-同比开始时间
    private byte hisInter;

    public static void main(String[] args) {
        List<Object> rows = new ArrayList<Object>();
        Map<String, Object> map1 = new HashMap<String, Object>();
        map1.put("addrRegion", "北仑区");
        map1.put("addrStreet", "新碶街道");
        map1.put("consName", "京华名苑");
        map1.put("addrName", "宁波市北仑区新矸镇辽河路北161号");
        map1.put("chargeUserName", "京华");
        map1.put("mobilephone", "13600000000");
        map1.put("builder", "宁波京华房产开发有限公司");
        map1.put("addrLat", "121.865615");
        map1.put("addrLng", "29.918164");
        rows.add(map1);
        map1 = new HashMap<String, Object>();
        map1.put("addrRegion", "江东区");
        map1.put("addrStreet", "福明街道");
        map1.put("consName", "会展中心");
        map1.put("addrName", "宁波市江东区会展路181号");
        map1.put("chargeUserName", "会展");
        map1.put("mobilephone", "13611111111");
        map1.put("builder", "宁波会展房产开发有限公司");
        map1.put("addrLat", "121.622025");
        map1.put("addrLng", "29.877856");
        rows.add(map1);
        map1 = new HashMap<String, Object>();
        map1.put("addrRegion", "北仑区");
        map1.put("addrStreet", "春晓街道");
        map1.put("consName", "宁波春晓");
        map1.put("addrName", "宁波市北仑区春晓工业园洋沙山路78号");
        map1.put("chargeUserName", "春晓");
        map1.put("mobilephone", "13622222222");
        map1.put("builder", "宁波春晓房产开发有限公司");
        map1.put("addrLat", "121.875845");
        map1.put("addrLng", "29.757355");
        rows.add(map1);
        map1 = new HashMap<String, Object>();
        map1.put("addrRegion", "北仑区");
        map1.put("addrStreet", "大碶街道");
        map1.put("consName", "甬江家园");
        map1.put("addrName", "宁波市北仑区甬江南路");
        map1.put("chargeUserName", "甬江");
        map1.put("mobilephone", "13633333333");
        map1.put("builder", "宁波甬江房产开发有限公司");
        map1.put("addrLat", "121.795093");
        map1.put("addrLng", "29.908817");
        rows.add(map1);
        map1 = new HashMap<String, Object>();
        map1.put("addrRegion", "北仑区");
        map1.put("addrStreet", "柴桥街道");
        map1.put("consName", "上龙泉村");
        map1.put("addrName", "宁波市北仑区上龙泉村");
        map1.put("chargeUserName", "龙泉");
        map1.put("mobilephone", "13644444444");
        map1.put("builder", "宁波龙泉房产开发有限公司");
        map1.put("addrLat", "121.929998");
        map1.put("addrLng", "29.83465");
        rows.add(map1);
        map1 = new HashMap<String, Object>();
        map1.put("addrRegion", "鄞州区");
        map1.put("addrStreet", "钟公庙街道");
        map1.put("consName", "天童寺");
        map1.put("addrName", "浙江省宁波市鄞州区天童乡太白山麓");
        map1.put("chargeUserName", "天童");
        map1.put("mobilephone", "13655555555");
        map1.put("builder", "宁波天童房产开发有限公司");
        map1.put("addrLat", "121.780322");
        map1.put("addrLng", "29.793669");
        rows.add(map1);
        map1 = new HashMap<String, Object>();
        map1.put("addrRegion", "北仑区");
        map1.put("addrStreet", "大碶街道");
        map1.put("consName", "黄金海岸");
        map1.put("addrName", "宁波市北仑区宝山路162号");
        map1.put("chargeUserName", "金海");
        map1.put("mobilephone", "13666666666");
        map1.put("builder", "宁波金海房产开发有限公司");
        map1.put("addrLat", "121.842434");
        map1.put("addrLng", "29.89285");
        rows.add(map1);
        int StatCode = 0;
        Long StatBJH = 1210109120160022L;
        String turnName;
        String StatName, ChargeMan, Telephone, Department, Address,
                Country, Street, Square1, ProStartTime, Stage;
        String Longitude, Latitude;
        StringBuilder sbCons = new StringBuilder();
        sbCons.append("insert into cons_info(StatCode, StatBJH, StatName, ChargeMan, Telephone, Longitude, Latitude, " +
                "Department, Address, Country, Street, Square, ProStartTime, Stage) values ");
        StringBuilder sbReg = new StringBuilder();
        sbReg.append("insert into reg_info(StatCode, DevCode, StartTime, PreEndTime, DevStatus) values ");
        DecimalFormat df = new DecimalFormat("#.00");
        DecimalFormat df1 = new DecimalFormat("#.000000");
        Double Square;
        int intSquare;
        for (int i = 0; i < 8; i++) {   //8个行政区
            for (int j = 0; j < 8; j++) {   //每个行政区8个街道
                StatCode++;
                StatBJH++;
                turnName = trtr(i) + trtr(j);
                StatName = "小区" + turnName;
                ChargeMan = "王" + turnName;
                Telephone = "136666666" + i + "" + j;
                Department = "宁波" + turnName + "开发有限公司";
                Country = trtr(i) + "区";
                Street = trtr(j) + "街道";
                Address = "宁波" + Country + Street + i + "路" + j + "号";
                Square = 5000 + 50000 * Math.random();
                Square1 = df.format(Double.parseDouble(Square + ""));
                Stage = "第" + j + "阶段";
                Longitude = df1.format(Double.parseDouble(120.55 + Math.random() * 1.6 + ""));
                Latitude = df1.format(Double.parseDouble(28.51 + Math.random() * 1.8 + ""));
                sbCons.append("(" + StatCode + ", '" + StatBJH + "','" + StatName + "','" + ChargeMan + "','" + Telephone +
                        "','" + Longitude + "','" + Latitude + "','" + Department +
                        "','" + Address + "','" + Country + "','" + Street + "','" + Square1 + "',now(),'" + Stage + "'),");
                intSquare = Integer.parseInt(Square / 10000 + 1 + "");  //10000平方米一个监测点
                for (int k = 0; k < intSquare; k++) {   //初始化监测点信息

                }
            }
        }
        String sCons = sbCons.toString();
        sCons = sCons.substring(0, sCons.length() - 1);
        String sReg = sbReg.toString();
        sReg = sReg.substring(0, sReg.length() - 1);
        System.err.println(sCons);
        System.err.println(sReg);
    }

    public static String trtr(int i) {
        switch (i) {
            case 0:
                return "A";
            case 1:
                return "B";
            case 2:
                return "C";
            case 3:
                return "D";
            case 4:
                return "E";
            case 5:
                return "F";
            case 6:
                return "G";
            case 7:
                return "H";
            case 8:
                return "I";
            case 9:
                return "K";
            case 10:
                return "L";
        }
        return "";
    }

    public String showNowDatas() {   //实时数据

        return SUCCESS;
    }

    public String json_mapDatas() {  //获取系统内所有的建筑工地,包含该工地对应的市,行政区,街道信息,按照扬尘指数倒序返回
        rows = new ArrayList<Object>();
        map = new HashMap<String, Object>();
        LinkedHashMap<String, List<String>> mapStreets = new LinkedHashMap<String, List<String>>(); //<街道 - 行政区>
        HashMap<String, Object> map1 = new HashMap<String, Object>();
        map1.put("addrRegion", "北仑区");
        map1.put("addrStreet", "新碶街道");
        map1.put("consName", "京华名苑");
        map1.put("addrName", "宁波市北仑区新矸镇辽河路北161号");
        map1.put("chargeUserName", "京华");
        map1.put("mobilephone", "13600000000");
        map1.put("builder", "宁波京华房产开发有限公司");
        map1.put("addrLat", "121.865615");
        map1.put("addrLng", "29.918164");
        map1.put("isConst", "施工中");
        map1.put("dataDust", "145.5");
        map1.put("dataNoise", "52.3");
        map1.put("consState", "3");
        map1.put("consState1", transConsState(3));
        rows.add(map1);
        map1 = new HashMap<String, Object>();
        map1.put("addrRegion", "江东区");
        map1.put("addrStreet", "福明街道");
        map1.put("consName", "会展中心");
        map1.put("addrName", "宁波市江东区会展路181号");
        map1.put("chargeUserName", "会展");
        map1.put("mobilephone", "13611111111");
        map1.put("builder", "宁波会展房产开发有限公司");
        map1.put("addrLat", "121.622025");
        map1.put("addrLng", "29.877856");
        map1.put("isConst", "施工中");
        map1.put("dataDust", "127.5");
        map1.put("dataNoise", "51.0");
        map1.put("consState", "2");
        map1.put("consState1", transConsState(2));
        rows.add(map1);
        map1 = new HashMap<String, Object>();
        map1.put("addrRegion", "北仑区");
        map1.put("addrStreet", "春晓街道");
        map1.put("consName", "宁波春晓");
        map1.put("addrName", "宁波市北仑区春晓工业园洋沙山路78号");
        map1.put("chargeUserName", "春晓");
        map1.put("mobilephone", "13622222222");
        map1.put("builder", "宁波春晓房产开发有限公司");
        map1.put("addrLat", "121.875845");
        map1.put("addrLng", "29.757355");
        map1.put("isConst", "施工中");
        map1.put("dataDust", "88.7");
        map1.put("dataNoise", "64.8");
        map1.put("consState", "1");
        map1.put("consState1", transConsState(1));
        rows.add(map1);
        map1 = new HashMap<String, Object>();
        map1.put("addrRegion", "北仑区");
        map1.put("addrStreet", "大碶街道");
        map1.put("consName", "甬江家园");
        map1.put("addrName", "宁波市北仑区甬江南路");
        map1.put("chargeUserName", "甬江");
        map1.put("mobilephone", "13633333333");
        map1.put("builder", "宁波甬江房产开发有限公司");
        map1.put("addrLat", "121.795093");
        map1.put("addrLng", "29.908817");
        map1.put("isConst", "施工中");
        map1.put("dataDust", "65.3");
        map1.put("dataNoise", "53.8");
        map1.put("consState", "1");
        map1.put("consState1", transConsState(1));
        rows.add(map1);
        map1 = new HashMap<String, Object>();
        map1.put("addrRegion", "北仑区");
        map1.put("addrStreet", "柴桥街道");
        map1.put("consName", "上龙泉村");
        map1.put("addrName", "宁波市北仑区上龙泉村");
        map1.put("chargeUserName", "龙泉");
        map1.put("mobilephone", "13644444444");
        map1.put("builder", "宁波龙泉房产开发有限公司");
        map1.put("addrLat", "121.929998");
        map1.put("addrLng", "29.83465");
        map1.put("isConst", "施工中");
        map1.put("dataDust", "53.5");
        map1.put("dataNoise", "47.8");
        map1.put("consState", "1");
        map1.put("consState1", transConsState(1));
        rows.add(map1);
        map1 = new HashMap<String, Object>();
        map1.put("addrRegion", "鄞州区");
        map1.put("addrStreet", "钟公庙街道");
        map1.put("consName", "天童寺");
        map1.put("addrName", "浙江省宁波市鄞州区天童乡太白山麓");
        map1.put("chargeUserName", "天童");
        map1.put("mobilephone", "13655555555");
        map1.put("builder", "宁波天童房产开发有限公司");
        map1.put("addrLat", "121.780322");
        map1.put("addrLng", "29.793669");
        map1.put("isConst", "施工中");
        map1.put("dataDust", "50.5");
        map1.put("dataNoise", "49.1");
        map1.put("consState", "1");
        map1.put("consState1", transConsState(1));
        rows.add(map1);
        map1 = new HashMap<String, Object>();
        map1.put("addrRegion", "北仑区");
        map1.put("addrStreet", "大碶街道");
        map1.put("consName", "黄金海岸");
        map1.put("addrName", "宁波市北仑区宝山路162号");
        map1.put("chargeUserName", "金海");
        map1.put("mobilephone", "13666666666");
        map1.put("builder", "宁波金海房产开发有限公司");
        map1.put("addrLat", "121.842434");
        map1.put("addrLng", "29.89285");
        map1.put("isConst", "施工中");
        map1.put("dataDust", "49.9");
        map1.put("dataNoise", "50.5");
        map1.put("consState", "1");
        map1.put("consState1", transConsState(1));
        rows.add(map1);
        List<String> listStreets = new ArrayList<String>();
        listStreets.add("钟公庙街道");
        mapStreets.put("鄞州区", listStreets);
        listStreets = new ArrayList<String>();
        listStreets.add("福明街道");
        mapStreets.put("江东区", listStreets);
        listStreets = new ArrayList<String>();
        listStreets.add("新碶街道");
        listStreets.add("春晓街道");
        listStreets.add("大碶街道");
        listStreets.add("柴桥街道");
        mapStreets.put("北仑区", listStreets);
        map.put("mapStreets", mapStreets);
        map.put("allDatas", rows);
        return SUCCESS;
    }

    private String transConsState(int consState) {
        switch (consState) {
            case 1:
                return "优秀";
            case 2:
                return "良好";
            case 3:
                return "轻度污染";
            case 4:
                return "中度污染";
            case 5:
                return "重度污染";
        }
        return "";
    }

    public RTMonitorService getRtMonitorService() {
        return rtMonitorService;
    }

    public void setRtMonitorService(RTMonitorService rtMonitorService) {
        this.rtMonitorService = rtMonitorService;
    }

    public ArrayList<Object> getRows() {
        return rows;
    }

    public Map<String, Object> getMap() {
        return map;
    }

    public void setRegId(Integer regId) {
        this.regId = regId;
    }

    public Integer getPeriod() {
        return period;
    }

    public void setPeriod(Integer period) {
        this.period = period;
    }

    public void setRegIds(String regIds) {
        this.regIds = regIds;
    }

    public void setDepId(Integer depId) {
        this.depId = depId;
    }

    public void setStDt(String stDt) {
        this.stDt = stDt;
    }

    public void setEndDt(String endDt) {
        this.endDt = endDt;
    }

    public void setDtBet(int dtBet) {
        this.dtBet = dtBet;
    }

    public void setSecLast(int secLast) {
        this.secLast = secLast;
    }

    public void setSecNow(int secNow) {
        this.secNow = secNow;
    }

    public void setExperVolt(float experVolt) {
        this.experVolt = experVolt;
    }

    public void setNoteIds(String noteIds) {
        this.noteIds = noteIds;
    }

    public LinkedHashMap<String, Object> getLinkedMap() {
        return linkedMap;
    }

    public void setJumpPage(int jumpPage) {
        this.jumpPage = jumpPage;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    public PageBean getPageBean() {
        return pageBean;
    }

    public void setLastDt(Long lastDt) {
        this.lastDt = lastDt;
    }

    public void setLastDts(String lastDts) {
        this.lastDts = lastDts;
    }

    public void setLastDatas(String lastDatas) {
        this.lastDatas = lastDatas;
    }

    public void setStDtContr(String stDtContr) {
        this.stDtContr = stDtContr;
    }

    public void setHisInter(byte hisInter) {
        this.hisInter = hisInter;
    }

}