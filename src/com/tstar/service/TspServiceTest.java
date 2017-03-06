package com.tstar.service;

import org.apache.log4j.Logger;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath:spring-applicationContext.xml")
public class TspServiceTest {

	private final Logger logger = Logger.getLogger(this.getClass());

	@Autowired
	private TspService tspService;

	
	@Test
	public void remainVal() {
		try {
			String contractId = "0004681574";
			String MSISDN = "0908002701";
			String accountNum = "0004714424";
			String ip = "";

			tspService.remainVal(contractId, MSISDN, accountNum, ip);
		}
		catch (Exception ex) {
			logger.error(ex, ex);
		}
	}
}
