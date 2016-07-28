package com.wnwl.CPN2025.util;

import com.wnwl.CPN2025.service.RegService;
import org.springframework.scheduling.quartz.CronTriggerBean;

import java.io.Serializable;
import java.text.ParseException;

public class InitCronTrigger extends CronTriggerBean implements Serializable {
    private static final long serialVersionUID = -6738493410789036967L;
    private RegService regService;

    /*
    * Spring中的触发器时间配置
    */
    private String croexpress() {
        /*String hql="from SystemComu";
        SystemComu periods = systemComuService.findFirstObject(hql);
		//String croexpress="0/5 0-"+duration.getNowValue()+" 0/"+period.getNowValue()+" * * ?";
		String croexpress="0/"+periods.getSamplePeriod()+" * * * * ?";*/
        String croexpress = "0/10 * * * * ?";
        return croexpress;
    }

    public RegService getRegService() {
        return regService;
    }

    public void setRegService(RegService regService) throws ParseException {
        this.regService = regService;
        String cronException = croexpress();
        setCronExpression(cronException);
    }

}
