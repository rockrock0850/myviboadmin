package com.tstar.dto;

public class CellStrengthResp {
	private int rawId;
	private String netType;
	private String blockLAT;
	private String blockLON;
	private String lat;
	private String lon;
	private String status;
	private String appTime;
	
	
	public String getNetType() {
		return netType;
	}
	public void setNetType(String netType) {
		this.netType = netType;
	}
	public String getBlockLAT() {
		return blockLAT;
	}
	public void setBlockLAT(String blockLAT) {
		this.blockLAT = blockLAT;
	}
	public String getBlockLON() {
		return blockLON;
	}
	public void setBlockLON(String blockLON) {
		this.blockLON = blockLON;
	}
	public String getLat() {
		return lat;
	}
	public void setLat(String lat) {
		this.lat = lat;
	}
	public String getLon() {
		return lon;
	}
	public void setLon(String lon) {
		this.lon = lon;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public int getRawId() {
		return rawId;
	}
	public void setRawId(int rawId) {
		this.rawId = rawId;
	}
	public String getAppTime() {
		return appTime;
	}
	public void setAppTime(String appTime) {
		this.appTime = appTime;
	}
}