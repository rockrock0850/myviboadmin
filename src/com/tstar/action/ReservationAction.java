package com.tstar.action;

import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import org.apache.log4j.Logger;
import org.apache.struts2.interceptor.ServletRequestAware;
import org.springframework.beans.factory.annotation.Autowired;
import org.tempuri.get_log_webservice.get_log.SendSMS1;

import com.opensymphony.xwork2.Action;
import com.opensymphony.xwork2.ActionContext;
import com.tstar.service.SmsService;
import com.tstar.utility.HttpGet;
import com.tstar.utility.PropertiesUtil;

public class ReservationAction implements Action, ServletRequestAware{
	
	private final Logger logger = Logger.getLogger(ReservationAction.class);
	
	private String result;
	private String verifyCode;
	private String po_name;
	private String po_sex;
	private String po_celpon;
	private String po_landline;
	private String po_eml;
	private String po_storeId;
	private String po_store_sel;
	private String po_address;
	private String showMessage;
	
	@Autowired
	private PropertiesUtil propertiesUtil;
	
	@Autowired
	private SmsService smsService;
	
	public HttpServletRequest request;
	   
	public String execute(){
    	logger.info("ReservationAction.execute()");
    	HttpGet httpGet = new HttpGet();
    	String url = propertiesUtil.getProperty("bscBridgeUrl");
    	
    	if(!url.startsWith("http")){
    		String contextPath = request.getContextPath();
        	String path = request.getRequestURL().toString();
        	path = path.substring(0, path.indexOf(contextPath));
        	url = path + url;
    	}
    	
    	String requestStr = "Function=GetRstDMSStoreAddressId"
    			+ "&ResponseType=json"
				+ "&Request=<FunctionType>001</FunctionType>"
				+ "<SalesClass>001,002</SalesClass>";
    	
    	try{
    		result = httpGet.sendToBSC(url, requestStr);
    	}catch (Exception e){
    		e.printStackTrace();
    		showMessage = "非常抱歉，系統發生異常，請聯絡客服。";
    	}
    	
    	logger.debug("ReservationAction.sendToBSC: " + result);
    	
    	return SUCCESS;
    }
    
    public String reserve(){
		logger.info("ReservationAction.reserve()");
		ActionContext actionContext = ActionContext.getContext();
	    Map session = actionContext.getSession();
	    String sessionVerifyCode = (String)session.get("validateCode");
	    logger.debug("sessionVerifyCode: " + sessionVerifyCode);
	    logger.debug("verifyCode: " + verifyCode);
		if(sessionVerifyCode != null && verifyCode != null && verifyCode.equalsIgnoreCase(sessionVerifyCode)){
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Calendar cal = Calendar.getInstance();
			
			SimpleDateFormat sdfId = new SimpleDateFormat("yyyyMMddHHmmss");
			Random r = new Random();
			
			HttpGet httpGet = new HttpGet();
	    	String url = propertiesUtil.getProperty("bscBridgeUrl");
	    	
	    	if(!url.startsWith("http")){
	    		String contextPath = request.getContextPath();
	        	String path = request.getRequestURL().toString();
	        	path = path.substring(0, path.indexOf(contextPath));
	        	url = path + url;
	    	}
	    	
	    	String transactionIdPrefix = sdfId.format(cal.getTime());
	    	String transactionIdSuffix = r.nextInt(10) + "";
	    	String transactionId = transactionIdPrefix + "0000" + transactionIdSuffix;
	    	String smsTransactionId = transactionIdPrefix + transactionIdSuffix;
	    	
	    	try{
	    		String requestStr = "Function=DoSend2VSP"
	    			+ "&ResponseType=json"
					+ "&Request=<Source>2</Source>"	//1=官網, 2=APP, 3=電銷
					+ "<Name>" + URLEncoder.encode(po_name, "UTF8") + "</Name>"
					+ "<Gender>" + URLEncoder.encode(po_sex, "UTF8") + "</Gender>"
					+ "<ContactMobile>" + URLEncoder.encode(po_celpon, "UTF-8") + "</ContactMobile>"
					+ "<LineNo>" + (null == po_landline || 0 == po_landline.length() ? "" : URLEncoder.encode(po_landline)) + "</LineNo>"
					+ "<EMail>" + po_eml + "</EMail>"
					+ "<MSISDN></MSISDN>"
					+ "<ReqTime>" + URLEncoder.encode(sdf.format(cal.getTime()), "UTF-8") + "</ReqTime>"
					+ "<StoreId>" + po_storeId + "</StoreId>"
                    + "<CustomerType>1</CustomerType>"	//1=個人用戶, 2=企業用戶
                    + "<TransactionId>" + transactionId + "</TransactionId>"
                    + "<TrxAction>1</TrxAction>"	//1=新增, 2=修改
                    + "<MarketingProgram>6</MarketingProgram>"	//預約活動 = 6
                    + "<ContactAddress>none</ContactAddress>";
	    	
		    	String bscResult = httpGet.sendToBSC(url, requestStr);
		    	logger.info("ReservationAction.reserve() input: " + requestStr);
		    	logger.info("ReservationAction.reserve() output: " + bscResult);
		    	if(bscResult.contains("ResultCode")){
		    		Date date = new Date();
			    	JSONObject json = (JSONObject) JSONSerializer.toJSON( bscResult );
			    	//如果預約成功，發簡訊
			    	if("00000".equals(json.getJSONObject("DoSend2VSPRes").get("ResultCode"))){
			    		/*
			    		 * 不允許DB連線
			    		SmsReqList smsReqList = new SmsReqList();
			    		//SMS ID為15碼
			    		smsReqList.setSiebelId(smsTransactionId);
			    		smsReqList.setMsisdn(po_celpon);
			    		smsReqList.setMsgtext("您的登記編號"+ transactionId +"，服務門市為" + po_store_sel + "，" + po_address + "，快起身到門市申辦吧！");
			    		smsReqList.setApplytime(date);
			    		smsReqList.setAgreetime(date);
			    		smsReqList.setSmstype("TSCAPP");
			    		smsReqList.setSmssource("TSC_APP");
			    		smsReqList.setStatus("O");
			    		smsReqList.setCompanyName("TSC");
			    		if("true".equals(propertiesUtil.getProperty("isSmsEnable"))){
			    			logger.info("ReservationAction.reserve() sms sending: " + ToStringBuilder.reflectionToString(smsReqList));
			    			smsService.send(smsReqList);
			    		};
			    		*/
			    		//改用API發送
			    		SendSMS1 sendSMS1 = new SendSMS1();
			    		sendSMS1.setNMsisdn(po_celpon);
			    		sendSMS1.setNContext("您的登記編號"+ transactionId +"，服務門市為" + po_store_sel + "，" + po_address + "，快起身到門市申辦吧！");
			    		sendSMS1.setNMakeUser("TSC");
			    		sendSMS1.setNSourceSystem("TSC_APP");
			    		
			    		if("true".equals(propertiesUtil.getProperty("isSmsEnable"))){
			    			logger.info("Reservation SMS on:" + smsTransactionId + " Msisdn: " + po_celpon);
			    			smsService.sendWS(sendSMS1);
			    		}else{
			    			logger.info("Reservation SMS off. The SMS was not send.");
			    		};
			    		
			    		result = "00000";
			    	}else{
			    		result = (String)json.getJSONObject("GetDMSStoreAddressIdRes").get("ResultCode");
			    	}
		    	}
	    	}catch (Exception e){
	    		e.printStackTrace();
	    		result = "fail";
	    	}
		}else{
			result = "verify code fail";
		}
		return SUCCESS;
	}

	@Override
	public void setServletRequest(HttpServletRequest request) {
		this.request = request;
	}

	public void setPo_name(String po_name) {
		this.po_name = po_name;
	}

	public void setPo_sex(String po_sex) {
		this.po_sex = po_sex;
	}

	public void setPo_celpon(String po_celpon) {
		this.po_celpon = po_celpon;
	}

	public void setPo_landline(String po_landline) {
		this.po_landline = po_landline;
	}

	public void setPo_eml(String po_eml) {
		this.po_eml = po_eml;
	}

	public void setPo_storeId(String po_storeId) {
		this.po_storeId = po_storeId;
	}

	public void setVerifyCode(String verifyCode) {
		this.verifyCode = verifyCode;
	}

	public String getResult() {
		return result;
	}

	public void setPo_store_sel(String po_store_sel) {
		this.po_store_sel = po_store_sel;
	}

	public void setPo_address(String po_address) {
		this.po_address = po_address;
	}

	public String getShowMessage() {
		return showMessage;
	}

	
}
