package com.tstar.service;

import org.tempuri.get_log_webservice.get_log.SendSMS1;

import com.tstar.model.sms.SmsReqList;


public interface SmsService {
	public void sendDB(SmsReqList smsReqDao);
	
	public void sendWS(SendSMS1 sendSMS1);
}
