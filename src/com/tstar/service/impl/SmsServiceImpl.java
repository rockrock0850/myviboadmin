package com.tstar.service.impl;

import java.net.MalformedURLException;
import java.net.URL;

import javax.xml.namespace.QName;
import javax.xml.ws.Service;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.tempuri.get_log_webservice.get_log.GetLogSoap;
import org.tempuri.get_log_webservice.get_log.SendSMS1;

import com.tstar.dao.sms.SmsReqListMapper;
import com.tstar.model.sms.SmsReqList;
import com.tstar.service.SmsService;
import com.tstar.utility.LoggerUtil;

@Controller
//@Transactional("smsTransactionManager")
@Scope("prototype")
public class SmsServiceImpl implements SmsService{
	
	@Autowired(required=false)
	private SmsReqListMapper smsReqListMapper;
	
	private final Logger logger = Logger.getLogger(SmsServiceImpl.class);
	//使用自訂義的logger
	Logger loggerSms = LoggerUtil.getLoggerByName("SmsLog");
	
	public void sendDB(SmsReqList smsReqDao ){
//		logger.info("this is SmsServiceImpl.sendDB function ");
		int result = smsReqListMapper.insert(smsReqDao);
//		logger.info("sms result:" + result);
	};
	
	public void sendWS(SendSMS1 sendSMS1){
//		logger.info("this is SmsServiceImpl.sendWS function ");
		URL url;
		try {
			//csda01d
			url = new URL("http://172.23.1.101/inhouse/webservice/Get_Log_WebService/Get_Log.asmx?wsdl");
			QName qname = new QName("http://tempuri.org/Get_Log_WebService/Get_Log", "Get_Log");
			Service service = Service.create(url, qname);
			GetLogSoap sendSmsResp = service.getPort(GetLogSoap.class);
			String str = sendSmsResp.sendSMS1(sendSMS1.getNMsisdn(), sendSMS1.getNContext(), sendSMS1.getNSourceSystem(), sendSMS1.getNMakeUser());
			loggerSms.info("sendSMS: " + sendSMS1.getNMsisdn() + " sms context: " + sendSMS1.getNContext());
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
