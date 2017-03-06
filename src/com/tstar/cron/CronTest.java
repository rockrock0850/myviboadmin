package com.tstar.cron;

import java.util.Date;

import org.apache.log4j.Logger;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/*
 * 
 * 
 */
//@Component
public class CronTest{
	
	private final Logger logger = Logger.getLogger(CronTest.class);
	
//	@Scheduled(cron="*/5 * * * * ?")
//	@Scheduled(fixedRate = 5000)
    public void execute(){
		System.out.println("Method executed at every 5 seconds. Current time is :: "+ new Date());
		logger.info("Method executed at every 5 seconds. Current time is :: "+ new Date());
    }

}
