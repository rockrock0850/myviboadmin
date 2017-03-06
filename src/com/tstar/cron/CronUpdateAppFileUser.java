package com.tstar.cron;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.tstar.service.UpdateAppFileUserService;

/*
 * 
 * 
 */
@Component
public class CronUpdateAppFileUser{
	
	private final Logger logger = Logger.getLogger(CronUpdateAppFileUser.class);
	
	@Autowired
	private UpdateAppFileUserService updateAppFileUserService;
	
	@Value(value="${cron.app.user}")
	private String cronString;
	
	/**
	 * cron - 固定的時間或週期，週期式行為同 fixedRate
	 * 固定六個值：秒(0-59) 分(0-59) 時(0-23) 日(1-31) 月(1-12) 週(1,日-7,六)
	 * 日與週互斥，其中之一必須為 ?
	 * 可使用的值有：單一數值（26）、範圍（50-55）、清單（9,10）、不指定（*）與週期（* /3）
	 *
	 * @Scheduled(cron="0 0 6,12,18 * * ?")
	 * @Scheduled(cron="0 * /2 * * * ?")
	 * @Scheduled(fixedDelay = 5000)
	 * 
	 * @throws Exception
	 */
	
//	@Scheduled(cron="${cron.app.user}")
    public void execute(){
		logger.info("Start UpdateAppFileUser cron cronString: " + cronString);
		updateAppFileUserService.updateFile();
    }
}
