package com.tstar.interceptor;


import java.util.ArrayList;
import java.util.List;

import javapns.notification.PushNotificationPayload;

import org.apache.log4j.Logger;

import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.AbstractInterceptor;

public class LogInterceptor extends AbstractInterceptor {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private final Logger logger = Logger.getLogger(LogInterceptor.class);

    @Override
     public String intercept(ActionInvocation ai) throws Exception {
//    	logger.info("LogInterceptor.intercept(): " + ai.getAction().getClass());
    	List<String> a = new ArrayList();
    	return ai.invoke();
    } 
}
