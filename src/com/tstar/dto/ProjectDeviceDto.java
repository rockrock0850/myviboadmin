package com.tstar.dto;


public class ProjectDeviceDto {
	private String deviceName;
	private String projectName;
	private String priceTstar;
	private String priceChosen;
	private String deviceModel;
	private String prepaymentAmountTstar;
	private String prepaymentAmountChosen;
	private String singlePhoneTstar;	//台星單手機
	private String singlePhoneChosen;	//競業單手機
	
	public String getPriceChosen() {
		return priceChosen;
	}
	public void setPriceChosen(String priceChosen) {
		this.priceChosen = priceChosen;
	}
	public String getDeviceName() {
		return deviceName;
	}
	public void setDeviceName(String deviceName) {
		this.deviceName = deviceName;
	}
	public String getProjectName() {
		return projectName;
	}
	public void setProjectName(String projectName) {
		this.projectName = projectName;
	}
	public String getPriceTstar() {
		return priceTstar;
	}
	public void setPriceTstar(String priceTstar) {
		this.priceTstar = priceTstar;
	}
	public String getDeviceModel() {
		return deviceModel;
	}
	public void setDeviceModel(String deviceModel) {
		this.deviceModel = deviceModel;
	}
	public String getPrepaymentAmountTstar() {
		return prepaymentAmountTstar;
	}
	public void setPrepaymentAmountTstar(String prepaymentAmountTstar) {
		this.prepaymentAmountTstar = prepaymentAmountTstar;
	}
	public String getPrepaymentAmountChosen() {
		return prepaymentAmountChosen;
	}
	public void setPrepaymentAmountChosen(String prepaymentAmountChosen) {
		this.prepaymentAmountChosen = prepaymentAmountChosen;
	}
	public String getSinglePhoneTstar() {
		return singlePhoneTstar;
	}
	public void setSinglePhoneTstar(String singlePhoneTstar) {
		this.singlePhoneTstar = singlePhoneTstar;
	}
	public String getSinglePhoneChosen() {
		return singlePhoneChosen;
	}
	public void setSinglePhoneChosen(String singlePhoneChosen) {
		this.singlePhoneChosen = singlePhoneChosen;
	}
}