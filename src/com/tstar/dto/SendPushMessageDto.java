package com.tstar.dto;


public class SendPushMessageDto {
	private String serviceId;
	private String systemId;		//發送人帳號(SenderId)
	private String systemKey;
	private String MSISDN;			//門號(MSISDN)
	private String titleBody;		//通知訊息主旨(TitleBody)
	private String messageBody;		//通知訊息內容(MessageBody)
	private String action;			//動作
	private String actionParam;			//動作值
	
	
	public String getSystemId() {
		return systemId;
	}
	public void setSystemId(String systemId) {
		this.systemId = systemId;
	}
	public String getSystemKey() {
		return systemKey;
	}
	public void setSystemKey(String systemKey) {
		this.systemKey = systemKey;
	}
	public String getMSISDN() {
		return MSISDN;
	}
	public void setMSISDN(String mSISDN) {
		MSISDN = mSISDN;
	}
	public String getTitleBody() {
		return titleBody;
	}
	public void setTitleBody(String titleBody) {
		this.titleBody = titleBody;
	}
	public String getMessageBody() {
		return messageBody;
	}
	public void setMessageBody(String messageBody) {
		this.messageBody = messageBody;
	}
	public String getAction() {
		return action;
	}
	public void setAction(String action) {
		this.action = action;
	}
	public String getServiceId() {
		return serviceId;
	}
	public void setServiceId(String serviceId) {
		this.serviceId = serviceId;
	}
	public String getActionParam() {
		return actionParam;
	}
	public void setActionParam(String actionParam) {
		this.actionParam = actionParam;
	}
}