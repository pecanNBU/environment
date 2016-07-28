package com.wnwl.CPN2025.action;

import com.wnwl.CPN2025.service.MonitorService;

/**
 * Created by peng on 2016/7/19.
 */

public class MonitorAction extends BaseAction {
    private MonitorService monitorService;

    public String showMonitors() {
        monitorService.initSDK();
        monitorService.LoginActionPerformed("192.168.1.170", 8000, "admin", "wnwl1234");
        monitorService.perform();
      /*  monitorService.LeftUpMousePressed();
        try {
            sleep(5000);
        } catch (Exception ex) {
        }
        monitorService.LeftUpMouseReleased();
        monitorService.ExitActionPerformed();*/
        return SUCCESS;
    }

    public MonitorService getMonitorService() {
        return monitorService;
    }

    public void setMonitorService(MonitorService monitorService) {
        this.monitorService = monitorService;
    }

}

