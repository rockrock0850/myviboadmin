package com.tstar.dto;

public class PushMsgQueryDto {
	private String systemId;
	private String systemKey;
	private String osType;
	private String msisdn;
	private String time;
	private String messageid;
	
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
	public String getOsType() {
		return osType;
	}
	public void setOsType(String osType) {
		this.osType = osType;
	}
	public String getMsisdn() {
		return msisdn;
	}
	public void setMsisdn(String msisdn) {
		this.msisdn = msisdn;
	}
	public String getTime() {
		return time;
	}
	public void setTime(String time) {
		this.time = time;
	}
	public String getMessageid() {
		return messageid;
	}
	public void setMessageid(String messageid) {
		this.messageid = messageid;
	}
}	
