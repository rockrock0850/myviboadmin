package com.tstar.action;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.Action;
import com.tstar.utility.PropertiesUtil;

@Component
@Scope("prototype")
public class ServiceStatusAction implements Action{
	
	private final Logger logger = Logger.getLogger(ServiceStatusAction.class);
	
	private String isBillInfo;
	
	@Autowired
	private PropertiesUtil propertiesUtil;
	
	   
	public String execute(){
		isBillInfo = propertiesUtil.getProperty("isBillInfo");
		logger.info("ServiceStatusAction.execute: " + isBillInfo);
		
    	return SUCCESS;
    }
    
	public String getIsBillInfo() {
		return isBillInfo;
	}
}
