package com.tstar.service.impl;

import java.lang.reflect.Method;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.builder.ReflectionToStringBuilder;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.tempuri.BILSoapProxy;
import org.tempuri.CRMSoapProxy;
import org.tempuri.WebServiceCoverageSoapProxy;
import org.tempuri.WsBankInfo;
import org.tempuri.WsCallType;
import org.tempuri.WsParam;
import org.tempuri.WsRepliesDetail;
import org.tempuri.WsResponse;
import org.tempuri.WsServiceLocation;
import org.tempuri.WsTicket;
import org.tempuri.WsZip;
import org.tempuri.XWSSoapProxy;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ser.DefaultSerializerProvider;
import com.tstar.dto.TspDto;
import com.tstar.service.PushMessageUserService;
import com.tstar.service.TspService;
import com.tstar.utility.NullSerializer;
import com.tstar.utility.PropertiesUtil;
import com.tstar.utility.Utils;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service
public class TspServiceImpl implements TspService{
	private final Logger logger = Logger.getLogger(TspServiceImpl.class);
	
	private static JSONObject zipCodeRecord = new JSONObject();//	Api: zipCode
	private static JSONObject retailRecord = new JSONObject();// Api: retail
	private static JSONObject cwsOptionsRecord = new JSONObject();// Api: cwsOptions
	
	@Autowired
	PushMessageUserService pushMessageUserService;
	
	@Autowired
	PropertiesUtil propertiesUtil;

	@Autowired
	ApplicationContext context;
	
	@Override
	public JSONObject simLostServiceApply(TspDto tspDto){
		JSONObject jsonRtn = new JSONObject();
		try{
			Utils utils = new Utils();
			
			XWSSoapProxy service = new XWSSoapProxy(propertiesUtil.getProperty("tsp_wsdl_url"));
			Map<String, String> map = new HashMap<String, String>();
			map.put("req_isdn", tspDto.getMsisdn());
			map.put("billing_account", tspDto.getAccountNum());
			map.put("contract_id", tspDto.getContractId());
			map.put("channel", "APP");
			map.put("conn_ip", tspDto.getConnIp());
			map.put("soid", utils.getUUID(true));
			map.put("soid_seq", "1");
			map.put("service_code", "SIM_LOST");	//TSP設定
			
			WsParam[] param = new WsParam[map.size()];
			int i = 0;
			for(String key : map.keySet()){
				WsParam wsParam = new WsParam();
				wsParam.setKey(key);
				wsParam.setValue(map.get(key));
				param[i] = wsParam;
				i++;
			}
			
			String logString = "";
			for(WsParam wsParam: param){
				logString += "{" + wsParam.getKey() + " : " + wsParam.getValue() + "}, ";
			}
			logger.info(logString);
			
			WsResponse str = service.sim_lost_service_apply(param);
			logger.info(str.getStatusCode() + " : " + str.getStatusDesc() + " : "  + str.getResultData());
			jsonRtn.put("statusCode", str.getStatusCode());
			jsonRtn.put("statusDesc", str.getStatusDesc());
			
		}catch(Exception e){
			jsonRtn.put("statusCode", "99999");
			jsonRtn.put("statusDesc", e.getMessage());
			e.printStackTrace();
		}
		
		return jsonRtn;
	}
	
	@Override
	public JSONObject simDisableServiceApply(TspDto tspDto){
		JSONObject jsonRtn = new JSONObject();
		try{
			Utils utils = new Utils();
			
			XWSSoapProxy service = new XWSSoapProxy(propertiesUtil.getProperty("tsp_wsdl_url"));
			Map<String, String> map = new HashMap<String, String>();
			map.put("req_isdn", tspDto.getMsisdn());
			map.put("billing_account", tspDto.getAccountNum());
			map.put("contract_id", tspDto.getContractId());
			map.put("channel", "APP");
			map.put("conn_ip", tspDto.getConnIp());
			map.put("soid", utils.getUUID(true));
			map.put("soid_seq", "1");
			map.put("service_code", "SIM_DISABLE");	//TSP設定
			
			WsParam[] param = new WsParam[map.size()];
			int i = 0;
			for(String key : map.keySet()){
				WsParam wsParam = new WsParam();
				wsParam.setKey(key);
				wsParam.setValue(map.get(key));
				param[i] = wsParam;
				i++;
			}
			
			String logString = "";
			for(WsParam wsParam: param){
				logString += "{" + wsParam.getKey() + " : " + wsParam.getValue() + "}, ";
			}
			logger.info(logString);
			
			//申請停話
			WsResponse str = service.sim_disable_service_apply(param);
			logger.info(str.getStatusCode() + " : " + str.getStatusDesc() + " : "  + str.getResultData());
			jsonRtn.put("statusCode", str.getStatusCode());
			jsonRtn.put("statusDesc", str.getStatusDesc());
			
		}catch(Exception e){
			jsonRtn.put("statusCode", "99999");
			jsonRtn.put("statusDesc", e.getMessage());
			e.printStackTrace();
		}
		
		return jsonRtn;
	}
	
	@Override
	public JSONObject insTroubleTicket(TspDto tspDto){
		JSONObject jsonRtn = new JSONObject();
		try{
			Utils utils = new Utils();
			
			XWSSoapProxy service = new XWSSoapProxy(propertiesUtil.getProperty("tsp_wsdl_url"));
			Map<String, String> map = new HashMap<String, String>();
			map.put("req_isdn", tspDto.getMsisdn());	//電話號碼
			map.put("billing_account", tspDto.getAccountNum());	//帳號
			map.put("contract_id", tspDto.getContractId());	//合約編號
			map.put("channel", "APP");
			map.put("conn_ip", tspDto.getConnIp());
			map.put("soid", utils.getUUID(true));
			map.put("soid_seq", "1");
			map.put("service_code", "SIM_SUPPORT");	//TSP設定
			map.put("city", tspDto.getCity());
			map.put("county", tspDto.getCounty());
			map.put("addr", tspDto.getAddr());
			map.put("zip", tspDto.getZip());
			map.put("sentType", tspDto.getSentType());			
			
			WsParam[] param = new WsParam[map.size()];
			int i = 0;
			for(String key : map.keySet()){
				WsParam wsParam = new WsParam();
				wsParam.setKey(key);
				wsParam.setValue(map.get(key));
				param[i] = wsParam;
				i++;
			}
			
			String logString = "";
			for(WsParam wsParam: param){
				logString += "{" + wsParam.getKey() + " : " + wsParam.getValue() + "}, ";
			}
			logger.info(logString);
			
			//申請停話
			WsResponse str = service.sim_disable_service_apply(param);
			logger.info(str.getStatusCode() + " : " + str.getStatusDesc() + " : "  + str.getResultData());
			jsonRtn.put("statusCode", str.getStatusCode());
			jsonRtn.put("statusDesc", str.getStatusDesc());
			
		}catch(Exception e){
			jsonRtn.put("statusCode", "99999");
			jsonRtn.put("statusDesc", e.getMessage());
			e.printStackTrace();
		}
		
		return jsonRtn;
	}
	
	@Override
	public JSONObject remainVal(String contractId, String MSISDN, String accountNum, String ip){
		JSONObject jsonRtn = new JSONObject();
		try{
    		String wsdlURL = propertiesUtil.getProperty("tsp_CMS_BIL_url"); 
    		logger.info("wsdlURL: " + wsdlURL);
    		BILSoapProxy bilSoapProxy = new BILSoapProxy(wsdlURL);
    		
    		WsResponse wsResponse = new WsResponse();
    		
    		WsParam[] param = new WsParam[5];
    		param[0] = new WsParam("P_subscription", contractId);	//合約編號
    		param[1] = new WsParam("req_isdn", MSISDN);	//門號
    		param[2] = new WsParam("billing_account", accountNum);	//帳單編號
    		param[3] = new WsParam("channel","APP");	//來源系統
    		param[4] = new WsParam("conn_ip",ip);	//來源IP
    		
    		wsResponse = bilSoapProxy.getRemainVal(param);

        	logger.info("WsResponse: " + ReflectionToStringBuilder.toString(wsResponse));
        	if(wsResponse != null){
        		jsonRtn.put("status", wsResponse.getStatusCode());
        		jsonRtn.put("message", wsResponse.getStatusDesc());
        		if(wsResponse.getResultData() != null){
        			jsonRtn.put("remainVal", String.valueOf(new Double(wsResponse.getResultData().toString()).intValue()));
        		}
    		}else{
    			jsonRtn.put("status", "99999");
        		jsonRtn.put("message", "wsResponse null");
    		}
		} catch (Exception e){
			e.printStackTrace();
			jsonRtn.put("status", "99999");
			jsonRtn.put("message", "系統處理錯誤");
//			Log message to db
    		Map<String, Object> memo = new TreeMap<String, Object>();
			memo.put("cause", new Utils().handleExceptionMessage(e));
			memo.put("accountNum", accountNum);
			new Utils().logRecorder("ERROR", contractId, MSISDN, memo);
		}
		logger.info("remainVal return json: " + jsonRtn);
		return jsonRtn;
	}
	
	public JSONObject queryTicket(String contractId, String MSISDN, String accountNum, String ticketid, String year, String month, String ip){
		JSONObject jsonRtn = new JSONObject();
		try{
    		String wsdlURL = propertiesUtil.getProperty("tsp_CMS_CRM_url"); 
    		logger.info("wsdlURL: " + wsdlURL);
    		CRMSoapProxy crmSoapProxy = new CRMSoapProxy(wsdlURL);
    		
    		WsResponse wsResponse = new WsResponse();
    		WsParam[] param = new WsParam[8];
    		param[0] = new WsParam("msisdn", MSISDN);	//門號
    		param[1] = new WsParam("billing_account", accountNum);	//帳單編號
    		param[2] = new WsParam("contract_id", contractId);	//合約編號
    		param[3] = new WsParam("ticketid", ticketid);	//單號
    		param[4] = new WsParam("year", year);	//年
    		param[5] = new WsParam("month", month);	//月
    		param[6] = new WsParam("channel", "APP");	//來源系統
    		param[7] = new WsParam("conn_ip", ip);	//來源IP
    		
    		wsResponse = crmSoapProxy.query_ticket(param);

        	logger.info("WsResponse: " + ReflectionToStringBuilder.toString(wsResponse));
        	if(wsResponse != null){
        		WsTicket[] wsTicketArray = null;
            	
        		JSONArray jsonArray = new JSONArray();
            	if((wsResponse.getResultData() != null && wsResponse.getResultData() instanceof WsTicket[])){
            		wsTicketArray = (WsTicket[]) wsResponse.getResultData();
            		for(WsTicket wsTicket : wsTicketArray){
                		net.sf.json.JSONObject json = net.sf.json.JSONObject.fromObject(wsTicket);
                		JSONObject jsonNet = JSONObject.fromObject(json.toString());
                		jsonArray.add(jsonNet);
                	}
            	}
            	jsonRtn.put("tickets", jsonArray);
        		jsonRtn.put("status", wsResponse.getStatusCode());
        		jsonRtn.put("message", wsResponse.getStatusDesc());
    		}else{
    			jsonRtn.put("status", "99999");
        		jsonRtn.put("message", "wsResponse null");
    		}
		} catch (Exception e){
			e.printStackTrace();
			jsonRtn.put("status", "99999");
			jsonRtn.put("message", "系統處理錯誤");
//			Log message to db
    		Map<String, Object> memo = new TreeMap<String, Object>();
			memo.put("cause", new Utils().handleExceptionMessage(e));
			memo.put("account_num", accountNum);
			memo.put("ticket_id", ticketid);
			memo.put("year", year);
			memo.put("month", month);
			memo.put("ip", ip);
			new Utils().logRecorder("ERROR", contractId, MSISDN, memo);
		}
		logger.info("queryTicket return json: " + jsonRtn);
		return jsonRtn;
	}
	
	public JSONObject contactUsReplyRead(String issueId){
		JSONObject jsonRtn = new JSONObject();
		try{
    		String wsdlURL = propertiesUtil.getProperty("tsp_CMS_EXTEND_url"); 
    		logger.info("wsdlURL: " + wsdlURL);
    		WebServiceCoverageSoapProxy webServiceCoverageSoapProxy = new WebServiceCoverageSoapProxy(wsdlURL);
    		
    		WsResponse wsResponse = new WsResponse();
    		
    		WsParam[] param = new WsParam[1];
    		param[0] = new WsParam("ISSUE_ID", issueId);	//問題單號
    		
    		wsResponse = webServiceCoverageSoapProxy.contactUs_ReplyRead(param);

        	logger.info("WsResponse: " + ReflectionToStringBuilder.toString(wsResponse));
        	if(wsResponse != null){
        		jsonRtn.put("status", wsResponse.getStatusCode());
        		jsonRtn.put("message", wsResponse.getStatusDesc());
    		}else{
    			jsonRtn.put("status", "99999");
        		jsonRtn.put("message", "wsResponse null");
    		}
		} catch (Exception e){
			e.printStackTrace();
			jsonRtn.put("status", "99999");
			jsonRtn.put("message", "系統處理錯誤");
//			Log message to db
    		Map<String, Object> memo = new TreeMap<String, Object>();
			memo.put("cause", new Utils().handleExceptionMessage(e));
			memo.put("issue_id", issueId);
			new Utils().logRecorder("ERROR", "", "", memo);
		}
		logger.info("contactUsReplyRead return json: " + jsonRtn);
		return jsonRtn;
	}
	
	public JSONObject contactUsIssueAddAgain(String issueId, String issueNote){
		JSONObject jsonRtn = new JSONObject();
		try{
    		String wsdlURL = propertiesUtil.getProperty("tsp_CMS_EXTEND_url"); 
    		logger.info("wsdlURL: " + wsdlURL);
    		WebServiceCoverageSoapProxy webServiceCoverageSoapProxy = new WebServiceCoverageSoapProxy(wsdlURL);
    		
    		WsResponse wsResponse = new WsResponse();
    		
    		WsParam[] param = new WsParam[5];
    		param[0] = new WsParam("ISSUE_ID", issueId);	//再發問的問題ID
    		param[1] = new WsParam("ISSUE_NOTE", issueNote);	//再發問的內容
    		
    		wsResponse = webServiceCoverageSoapProxy.contactUsIssueAddAgain(param);
        	logger.info("WsResponse: " + ReflectionToStringBuilder.toString(wsResponse));
        	if(wsResponse != null){
        		jsonRtn.put("status", wsResponse.getStatusCode());
        		jsonRtn.put("message", wsResponse.getStatusDesc());
    		}else{
    			jsonRtn.put("status", "99999");
        		jsonRtn.put("message", "wsResponse null");
    		}
		} catch (Exception e){
			e.printStackTrace();
			jsonRtn.put("status", "99999");
			jsonRtn.put("message", "系統處理錯誤");
//			Log message to db
    		Map<String, Object> memo = new TreeMap<String, Object>();
			memo.put("cause", new Utils().handleExceptionMessage(e));
			memo.put("issue_id", issueId);
			memo.put("issue_note", issueNote);
			new Utils().logRecorder("ERROR", "", "", memo);
		}
		logger.info("contactUsIssueAddAgain return json: " + jsonRtn);
		return jsonRtn;
	}

	@Override
	public JSONObject zipCode(String functionType) {
		JSONObject jsonRtn = new JSONObject();
		try{
    		WsResponse wsResponse = new WsResponse();
    		long liveTime = Long.valueOf(propertiesUtil.getProperty("system_config_tsp_zipcode_fq"));
            if (functionType == null || StringUtils.isBlank(functionType)){
            	wsResponse.setStatusCode("00005");
            	wsResponse.setStatusDesc("傳入之參數有誤");
            }else if("0".equals(functionType)){
            	zipRefreshDetector(liveTime);
            	jsonRtn.put("zipCodes", zipCodeRecord.getString("zipCodes"));
            	wsResponse.setStatusCode(zipCodeRecord.getString("StatusCode"));
            	wsResponse.setStatusDesc(zipCodeRecord.getString("StatusDesc"));
           	 	logger.debug("cache time ranage:" + (Calendar.getInstance().getTimeInMillis() - zipCodeRecord.getLong("callTime")) + "ms");
           	 	logger.debug("status:" + zipCodeRecord.getString("status"));
            }else if ("1".equals(functionType)){// 20120520 取縣市鄉鎮另一方式
            	zipRefreshDetector(liveTime);
           	 	jsonRtn.put("citys", zipCodeRecord.get("citys"));
            	wsResponse.setStatusCode(zipCodeRecord.getString("StatusCode"));
            	wsResponse.setStatusDesc(zipCodeRecord.getString("StatusDesc"));
           	 	logger.debug("cache time ranage:" + (Calendar.getInstance().getTimeInMillis() - zipCodeRecord.getLong("callTime")) + "ms");
           	 	logger.debug("status:" + zipCodeRecord.getString("status"));
            }
            jsonRtn.put("cache_type", zipCodeRecord.getString("status"));
        	jsonRtn.put("status", wsResponse.getStatusCode());
			jsonRtn.put("message", wsResponse.getStatusDesc());
		} catch (Exception e){
			e.printStackTrace();
			jsonRtn.put("status", "99999");
			jsonRtn.put("message", "系統處理錯誤");
//			Log message to db
    		Map<String, Object> memo = new TreeMap<String, Object>();
			memo.put("cause", new Utils().handleExceptionMessage(e));
			memo.put("function_type", functionType);
			new Utils().logRecorder("ERROR", "", "", memo);
		}
		logger.info("zipCode return json: " + jsonRtn);
		return jsonRtn;
	}

	@Override
	public JSONObject retail(String zipCode ,String address) {
		JSONObject jsonRtn = new JSONObject();
		try{
			JSONArray locateJson = retailRecord.optJSONArray("location");
    		if(StringUtils.isNotBlank(zipCode) && StringUtils.isBlank(address)){
    			jsonRtn.put("type", "zipCode");
    			jsonRtn.put("value", getRetailJson(locateJson, "type_zipCode", zipCode));
    		}else if(StringUtils.isBlank(zipCode) && StringUtils.isNotBlank(address)){
    			jsonRtn.put("type", "address");
    			jsonRtn.put("value", getRetailJson(locateJson, "type_address", address));
    		}else if(StringUtils.isNotBlank(zipCode) && StringUtils.isNotBlank(address)){
    			jsonRtn.put("type", "both");
    			jsonRtn.put("value", getRetailJson(locateJson, "type_both", zipCode + "," +address));
    		}else{
    			jsonRtn.put("type", "all");
    			jsonRtn.put("value", getRetailJson(locateJson, "type_all", null));
    		}
			jsonRtn.put("status", retailRecord.opt("StatusCode"));
			jsonRtn.put("message", retailRecord.opt("StatusDesc"));
		} catch (Exception e){
			e.printStackTrace();
			jsonRtn.put("status", "99999");
			jsonRtn.put("message", "系統處理錯誤");
//			Log message to db
    		Map<String, Object> memo = new TreeMap<String, Object>();
			memo.put("cause", new Utils().handleExceptionMessage(e));
			memo.put("zip_code", zipCode);
			memo.put("address", address);
			new Utils().logRecorder("ERROR", "", "", memo);
		}
		logger.info("retail return json: " + jsonRtn);
		return jsonRtn;
	}
	
	@Override
	public JSONObject refreshCache(String[] apis) {
		if(null == apis || 0 == apis.length){
			JSONObject json = new JSONObject();
			json.put("Error", "Input string is null or index samll than 0");
			logger.debug("Error-Input string is null or index samll than 0");
			return json;
		}else{
			try {
				Class<?> tsp = this.getClass();
				JSONObject json = new JSONObject();
				for(String api : apis){
					if(StringUtils.isNotBlank(api)){
						try {
							Object instance = tsp.newInstance();
							context.getAutowireCapableBeanFactory().autowireBean(instance);
							Method method = tsp.getDeclaredMethod(StringUtils.upperCase(api) + "REFRESH", new Class<?>[]{});
							json.put(api, method.invoke(instance, new Object[]{}));
						} catch (Exception e) {
							e.printStackTrace();
							JSONObject error = new JSONObject();
							error.put("執行狀態", "error-" + e.getMessage());
							json.put(api, error);
						}
					}
				}
				logger.info("refreshCache return json: " + json);
				return json;
			} catch (Exception e) {
				e.printStackTrace();
//				Log message to db
	    		Map<String, Object> memo = new TreeMap<String, Object>();
				memo.put("cause", new Utils().handleExceptionMessage(e));
				memo.put("apis", ReflectionToStringBuilder.toString(apis));
				new Utils().logRecorder("ERROR", "", "", memo);
				return null;
			}
		}
	}

	@Override
	public JSONObject depositBankInfo() {
		JSONObject jsonRtn = new JSONObject();
		try {
			String wsdlURL = propertiesUtil.getProperty("tsp_CMS_EXTEND_url"); 
    		logger.info("wsdlURL: " + wsdlURL);
	        WebServiceCoverageSoapProxy webServiceCoverageSoapProxy = new WebServiceCoverageSoapProxy(wsdlURL);
	        WsResponse wsResponse = webServiceCoverageSoapProxy.getBankInfo();
        	logger.info("WsResponse: " + ReflectionToStringBuilder.toString(wsResponse));
	        WsBankInfo[] wsBankInfos = (WsBankInfo[]) wsResponse.getResultData();
	        if("0000".equals(wsResponse.getStatusCode())){
	        	if(null == wsBankInfos){
	            	logger.info("Error BankInfo. No data exist");
	    			jsonRtn.put("status", "99999");
	    			jsonRtn.put("message", "系統處理錯誤");
	            }else{
	    	        JSONArray banks = new JSONArray();
	            	for(WsBankInfo wsBankInfo : wsBankInfos){
	            		JSONObject bankInfo = new JSONObject();
	            		String bankIDName = wsBankInfo.getBANK_ID() + "/" + wsBankInfo.getBANK_NAME();//銀行代碼家銀行名稱  ex:004/台灣銀行
	            		bankInfo.put("bank", bankIDName);
	            		banks.add(bankInfo);
	            	}
	            	jsonRtn.put("banks", banks);
	            	jsonRtn.put("status", wsResponse.getStatusCode());
	            	jsonRtn.put("message", wsResponse.getStatusDesc());
	            }
	        }else{
	        	logger.info("wsdl error: " + wsResponse.getStatusCode());
	        	jsonRtn.put("status", wsResponse.getStatusCode());
	        	jsonRtn.put("message", wsResponse.getStatusDesc());
	        }
		} catch (Exception e) {
			e.printStackTrace();
			jsonRtn.put("status", "99999");
			jsonRtn.put("message", "系統處理錯誤");
//			Log message to db
    		Map<String, Object> memo = new TreeMap<String, Object>();
			memo.put("cause", new Utils().handleExceptionMessage(e));
			new Utils().logRecorder("ERROR", "", "", memo);
		}
		logger.info("depositBankInfo return json: " + jsonRtn);
		return jsonRtn;
	}

	@Override
	public JSONObject cwsOptions() {
		JSONObject jsonRtn = new JSONObject();
		try {
            jsonRtn.put("gen", getCwsOptionsJson(cwsOptionsRecord.optJSONObject("gen"), "gen"));
            jsonRtn.put("net", getCwsOptionsJson(cwsOptionsRecord.optJSONObject("net"), "net"));
//          call的web service是同一支，只是帶不同參數取值，所以只要其中一支回傳0000就代表執行成功
            if("0000".equals(jsonRtn.optJSONObject("gen").optString("status")) || "0000".equals(jsonRtn.optJSONObject("net").optString("status"))){
            	jsonRtn.optJSONObject("gen").remove("status");
            	jsonRtn.optJSONObject("gen").remove("message");
            	jsonRtn.optJSONObject("net").remove("status");
            	jsonRtn.optJSONObject("net").remove("message");
            	jsonRtn.put("status", "0000");
            	jsonRtn.put("message", "執行成功");
            }else{
            	jsonRtn.put("status", "9999");
            	jsonRtn.put("message", "執行失敗");
            }
		} catch (Exception e) {
			e.printStackTrace();
			jsonRtn.put("status", "99999");
			jsonRtn.put("message", "系統處理錯誤");
//			Log message to db
    		Map<String, Object> memo = new TreeMap<String, Object>();
			memo.put("cause", new Utils().handleExceptionMessage(e));
			new Utils().logRecorder("ERROR", "", "", memo);
		}
		logger.info("cwsOptions return json: " + jsonRtn);
		return jsonRtn;
	}

	@Override
	public JSONObject cwsContactUS(org.json.JSONObject formData) {
		JSONObject jsonRtn = new JSONObject();
		try {
    		WsParam[] param = new WsParam[22];
        	if("GEN".equals(formData.optString("type"))){
        		param[0] = new WsParam("Type",formData.optString("type"));
        		param[1] = new WsParam("NAME",formData.optString("name"));
        		param[2] = new WsParam("PHONE_NUMBER",formData.optString("phone_number"));
        		param[3] = new WsParam("DAYTIME_CONTACT_AREA",formData.optString("daytime_contact_area"));
        		param[4] = new WsParam("DAYTIME_CONTACT_PHONE",formData.optString("daytime_contact_phone"));
        		param[5] = new WsParam("DAYTIME_CONTACT_EXT",formData.optString("daytime_contac_text"));
        		param[6] = new WsParam("NIGHT_CONTACT_AREA",formData.optString("night_contact_area"));
                param[7] = new WsParam("NIGHT_CONTACT_PHONE",formData.optString("night_contact_phone"));
                param[8] = new WsParam("EMAIL",formData.optString("email"));
                param[9] = new WsParam("Channel","app");
                param[10] = new WsParam("CUSTOMER_TYPE",formData.optString("customer_type"));
                param[11] = new WsParam("CONTRACT_NUMBER",formData.optString("contract_number"));
                param[12] = new WsParam("ISSUE_IDENTIFY_1",formData.optString("issue_identify1"));
                param[13] = new WsParam("ISSUE_DESCRIPTION",formData.optString("issue_description"));
        	}else if("NET".equals(formData.optString("type"))){
                param[0] = new WsParam("Type",formData.optString("type"));
                param[1] = new WsParam("NAME",formData.optString("name"));
                param[2] = new WsParam("PHONE_NUMBER",formData.optString("phone_number"));
                param[3] = new WsParam("DAYTIME_CONTACT_AREA",formData.optString("daytime_contact_area"));
                param[4] = new WsParam("DAYTIME_CONTACT_PHONE",formData.optString("daytime_contact_phone"));
                param[5] = new WsParam("DAYTIME_CONTACT_EXT",formData.optString("daytime_contac_text"));
                param[6] = new WsParam("NIGHT_CONTACT_AREA",formData.optString("night_contact_area"));
                param[7] = new WsParam("NIGHT_CONTACT_PHONE",formData.optString("night_contact_phone"));       
                param[8] = new WsParam("EMAIL",formData.optString("email"));
                param[9] = new WsParam("Channel","app");
                param[10] = new WsParam("CUSTOMER_TYPE",formData.optString("customer_type"));
                param[11] = new WsParam("CONTRACT_NUMBER",formData.optString("contract_number"));
                param[12] = new WsParam("ISSUE_IDENTIFY_2",formData.optString("issue_identify2"));
                param[13] = new WsParam("ISSUE_IDENTIFY_3",formData.optString("issue_identify3"));
                param[14] = new WsParam("SIGNAL_TYPE",formData.optString("signal_type"));
                param[15] = new WsParam("SIGNAL_POSITION",formData.optString("signal_position"));
                param[16] = new WsParam("SIGNAL_STRENGTH",formData.optString("signal_strength"));
                param[17] = new WsParam("ADDRESS_TYPE1_CITY",formData.optString("address_type1_city"));
                param[18] = new WsParam("ADDRESS_TYPE1_SECTION",formData.optString("address_type1_section"));
                if(null == formData.optString("address_type2_addr")){
                	param[19] = new WsParam("ADDRESS_TYPE1_ADDR",formData.optString("address_type1_addr"));
                }else{
                	param[19] = new WsParam("ADDRESS_TYPE1_ADDR",formData.optString("address_type2_addr"));
                }
                param[20] = new WsParam("ADDRESS_TYPE2_ADDR","");
                param[21] = new WsParam("ISSUE_DESCRIPTION",formData.optString("issue_description"));
        	}

//        	Post wsdl
    		try{
        		String wsdlURL = propertiesUtil.getProperty("tsp_CMS_EXTEND_url"); 
        		logger.info("wsdlURL: " + wsdlURL);
        		WebServiceCoverageSoapProxy webServiceCoverageSoapProxy = new WebServiceCoverageSoapProxy(wsdlURL);	
            	WsResponse wsResponse = webServiceCoverageSoapProxy.addContactUs(param);
            	logger.info("WsResponse: " + ReflectionToStringBuilder.toString(wsResponse));
            	if(null == wsResponse){
        			jsonRtn.put("status", "99999");
            		jsonRtn.put("message", "wsResponse null");
        		}else{
            		jsonRtn.put("status", wsResponse.getStatusCode());
            		jsonRtn.put("message", wsResponse.getStatusDesc());
        		}
    		} catch (Exception e){
    			e.printStackTrace();
    		}
		} catch (Exception e) {
			e.printStackTrace();
			jsonRtn.put("status", "99999");
			jsonRtn.put("message", "系統處理錯誤");
//			Log message to db
    		Map<String, Object> memo = new TreeMap<String, Object>();
			memo.put("cause", new Utils().handleExceptionMessage(e));
			memo.put("form_data", formData);
			new Utils().logRecorder("ERROR", "", "", memo);
		}
		logger.info("cwsContactUS return json: " + jsonRtn);
		return jsonRtn;
	}

	@Override
	public JSONObject contactUsIssueQuery(String contractId, String startDate) {
		JSONObject jsonRtn = new JSONObject();
		try {
    		String wsdlURL = propertiesUtil.getProperty("tsp_CMS_EXTEND_url"); 
    		logger.info("wsdlURL: " + wsdlURL);
    		WebServiceCoverageSoapProxy webServiceCoverageSoapProxy = new WebServiceCoverageSoapProxy(wsdlURL);	
    		WsParam[] param = new WsParam[2];
			param[0] = new WsParam("CONTRACT_NUMBER", contractId);
			param[1] = new WsParam("START_DATE", startDate);
        	WsResponse wsResponse = webServiceCoverageSoapProxy.contactUsIssueQuery(param);
        	logger.info("WsResponse: " + ReflectionToStringBuilder.toString(wsResponse));
        	WsRepliesDetail[] wsRepliesDetails = (WsRepliesDetail[]) wsResponse.getResultData();

            if(null == wsRepliesDetails || 0 >= wsRepliesDetails.length){
            	jsonRtn.put("status", "00001");
            	jsonRtn.put("message", "查無資料"); 
            }else{ 
            	JSONArray data = new JSONArray();
            	for(WsRepliesDetail wsRepliesDetail : wsRepliesDetails){
            		wsRepliesDetailParser(data, wsRepliesDetail, "", 0);
            	}
            	jsonRtn.put("response_data", data);
            }
        	
    		jsonRtn.put("status", wsResponse.getStatusCode());
    		jsonRtn.put("message", wsResponse.getStatusDesc());
		} catch (Exception e) {
			e.printStackTrace();
			jsonRtn.put("status", "99999");
			jsonRtn.put("message", "系統處理錯誤");
//			Log message to db
    		Map<String, Object> memo = new TreeMap<String, Object>();
			memo.put("cause", new Utils().handleExceptionMessage(e));
			new Utils().logRecorder("ERROR", "", "", memo);
		}
		logger.info("contactUsIssueQuery return json: " + jsonRtn);
		return jsonRtn;
	}

//	Refresh detectors
    private void zipRefreshDetector(long liveTime) {
    	try {
        	if(!zipCodeRecord.has("callTime") || (Calendar.getInstance().getTimeInMillis() - zipCodeRecord.getLong("callTime")) > liveTime){
        		logger.info("Refreshed zipcode:" + ZIPCODEREFRESH());
        		zipCodeRecord.put("status", "refresh");
        	}else{ 
        		zipCodeRecord.put("status", "cache");
        	} 
		} catch (Exception e) {
			e.printStackTrace();
    		zipCodeRecord.put("StatusCode", "99999");
    		zipCodeRecord.put("StatusDesc", "wsResponse null");
		}
	}

	@Scheduled(cron="${system_config_tsp_retail_fq}")
	public void retailRefreshDetector() {
    	logger.info("Refreshed retail:" + RETAILREFRESH());
	}

	@Scheduled(cron="${system_config_tsp_cwsoptions_fq}")
	public void cwsOptionsRefreshDetector() {
    	logger.info("Refreshed cwsOptions:" + CWSOPTIONSREFRESH());
	}

//	Get service data methods
	private JSONArray getRetailJson(JSONArray locateJson, String type, String value) {
		try {
			if(null == locateJson){
				retailRefreshDetector();
				locateJson = retailRecord.optJSONArray("location");
			}
			JSONArray currentRetail = new JSONArray();
			for(int x = 0; x < locateJson.size(); x++) {
				JSONObject location = (JSONObject) locateJson.get(x);
				try {
					JSONObject retail = new JSONObject();
					retail.put("address", location.getString("address"));
					retail.put("name", location.getString("name"));
					retail.put("operationTime", location.getString("operationTime"));
					retail.put("phoneNumber", location.getString("phoneNumber"));
					retail.put("latitude", location.getString("latitude"));
					retail.put("longitude", location.getString("longitude"));
					retail.put("zipCode", location.getString("zipCode"));
					if("type_all".equals(type) && StringUtils.isBlank(value)){
						return locateJson;
					}else if("type_zipCode".equals(type) && value.equals(location.getString("zipCode"))){
						currentRetail.add(retail);
					}else if("type_address".equals(type) && value.equals(location.getString("address"))){
						currentRetail.add(retail);
					}else if("type_both".equals(type)){
						String[] both = value.split(",");
						if(both[0].equals(location.getString("zipCode")) && both[1].equals(location.getString("address"))){
	    					currentRetail.add(retail);
						}
					}
				} catch (Exception e) {
					logger.info("Error-" + locateJson.get(x));
					e.printStackTrace();
				}
			}
			return currentRetail;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	private JSONObject getCwsOptionsJson(JSONObject json, String type) {
		try {
			if(null == json){
				cwsOptionsRefreshDetector();
				json = cwsOptionsRecord.optJSONObject(type);
			}
			return json;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
    
    private void wsRepliesDetailParser(JSONArray data, WsRepliesDetail wsRepliesDetail, String parentId, int count){
		try {
			ObjectMapper objectMapper = new ObjectMapper();
			String convertObjectToStringValue = objectMapper.writeValueAsString(wsRepliesDetail);// 物件轉json字串
			
			JSONObject wsRepliesDetailJson = JSONObject.fromObject(convertObjectToStringValue);
			if(null != wsRepliesDetail){
				String currentId = "";
				if (!"null".equals(wsRepliesDetailJson.optString("id"))) {
					currentId = wsRepliesDetailJson.optString("id");
				}
				else if (StringUtils.isNotBlank(parentId)) {
					wsRepliesDetailJson.put("parentId", parentId);
					currentId = parentId + "-" + count;
					wsRepliesDetailJson.put("id", currentId);
				}

				if (!"null".equals(wsRepliesDetailJson.optString("issueNote"))) {
					wsRepliesDetailJson.put("issueNote",
							Base64.encodeBase64(wsRepliesDetailJson.optString("issueNote").getBytes("utf-8")));

				}
				if (!"null".equals(wsRepliesDetailJson.optString("replyContent"))) {
					wsRepliesDetailJson.put("replyContent",
							Base64.encodeBase64(wsRepliesDetailJson.optString("replyContent").getBytes("utf-8")));
				}
				
//				檢查是否有子節點的回覆訊息
				if(null != wsRepliesDetailJson.optJSONArray("subList") && 0 < wsRepliesDetailJson.optJSONArray("subList").size()){
					int i = 0;
					for(WsRepliesDetail subList : wsRepliesDetail.getSubList()){
						wsRepliesDetailParser(data, subList, currentId, i);
						i++;
					}
				}
				
//				遞迴最後從function return出來再將sub list節點移除在塞入data
				wsRepliesDetailJson.remove("subList");
//				為什麼要先轉成map再轉成string請參考:http://wnli350.iteye.com/blog/2244449
				Map<String, String> map = objectMapper.readValue(wsRepliesDetailJson.toString(), new TypeReference<TreeMap<String, String>>(){});
		        DefaultSerializerProvider defaultSerializerProvider = new DefaultSerializerProvider.Impl();// 產生預設序列化過濾器物件
		        defaultSerializerProvider.setNullValueSerializer(new NullSerializer());// 設定預設空值序列化過濾器方法
		        objectMapper.setSerializerProvider(defaultSerializerProvider);// 過濾物件中的值若是null則轉成空字串(""
				String ignoreNullValue = objectMapper.writeValueAsString(map);
				JSONObject result = JSONObject.fromObject(ignoreNullValue);
				data.add(result);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
    }

//	Reflection for refreshCache
	private JSONObject ZIPCODEREFRESH(){
		JSONObject json = new JSONObject();
		try{
    		String wsdlURL = propertiesUtil.getProperty("tsp_CMS_EXTEND_url"); 
    		logger.info("wsdlURL: " + wsdlURL);
    		WebServiceCoverageSoapProxy webServiceCoverageSoapProxy = new WebServiceCoverageSoapProxy(wsdlURL);

        	long begin = Calendar.getInstance().getTimeInMillis();
    		WsResponse wsResponse = webServiceCoverageSoapProxy.getZipByCity(""); 
        	logger.info("WsResponse: " + ReflectionToStringBuilder.toString(wsResponse));
            WsZip[]	zipCodes = (WsZip[]) wsResponse.getResultData(); 
            if(null == zipCodes){
            	logger.debug("Error-zipList is null");
            }else{
//        		ZipCode
                JSONObject zipCodeJson = new JSONObject(); 
                for(WsZip wsZip : zipCodes){
                	String zipcode = wsZip.getZipCode();
                    String city = wsZip.getCity();
                    String district = wsZip.getDistrict();
                    if(null == zipCodeJson.get(city)) {
                    	JSONObject cityData = new JSONObject();
                    	cityData.put(district, zipcode);
                    	zipCodeJson.put(city, cityData);
                    } else {
                    	JSONObject cityData = new JSONObject();
                    	cityData = (JSONObject) zipCodeJson.get(city);
                    	cityData.put(district, zipcode);
                    }
                }  
        		zipCodeRecord.put("zipCodes", zipCodeJson);
        		
//        		City
                JSONArray cityJson = new JSONArray();
            	for(WsZip wsZip : zipCodes){    		
            		JSONObject cityData = new JSONObject();
            		cityData.put("city", wsZip.getCity());
            		cityData.put("town", wsZip.getDistrict());
            		cityData.put("zipcode", wsZip.getZipCode());
            		cityJson.add(cityData);
            	}
            	zipCodeRecord.put("citys", cityJson);
            }
    		zipCodeRecord.put("StatusCode", wsResponse.getStatusCode());
    		zipCodeRecord.put("StatusDesc", wsResponse.getStatusDesc());
    		zipCodeRecord.put("callTime", Calendar.getInstance().getTimeInMillis());
        	long end = Calendar.getInstance().getTimeInMillis();
       	 	
        	json.put("執行狀態", "success");
        	json.put("執行時間", end-begin + " ms");
		} catch (Exception e){
			e.printStackTrace();
			json.put("執行狀態", "error-" + e.getMessage());
		}
		return json;
	}
	
	private JSONObject RETAILREFRESH(){
		JSONObject json = new JSONObject();
		try{
    		String wsdlURL = propertiesUtil.getProperty("tsp_CMS_EXTEND_url"); 
    		logger.info("wsdlURL: " + wsdlURL);
    		WebServiceCoverageSoapProxy webServiceCoverageSoapProxy = new WebServiceCoverageSoapProxy(wsdlURL);

        	long begin = Calendar.getInstance().getTimeInMillis();
    		WsResponse wsResponse = webServiceCoverageSoapProxy.getServiceLocationeDefault(); 
        	logger.info("WsResponse: " + ReflectionToStringBuilder.toString(wsResponse));
        	JSONArray retailJson = new JSONArray();     
            WsServiceLocation[]	retails = (WsServiceLocation[]) wsResponse.getResultData();
            if(retails == null){
            	logger.debug("Error-retails is null");
            }else{
                for(WsServiceLocation wsServiceLocation : retails){
                	try {
                    	JSONObject location = new JSONObject();
                    	location.put("address", wsServiceLocation.getStoreAddress());
                    	location.put("name", wsServiceLocation.getLocationName());
                    	location.put("operationTime", wsServiceLocation.getOperateTime());
                    	location.put("phoneNumber", wsServiceLocation.getPhoneNumber());
                    	location.put("zipCode", wsServiceLocation.getZipCode());
            			if(StringUtils.isNotBlank(wsServiceLocation.getLatlng())){
            				String[] locate = wsServiceLocation.getLatlng().split(",");
            				location.put("latitude", Double.parseDouble(locate[0]));
            				location.put("longitude", Double.parseDouble(locate[1]));
            			}else{
            				location.put("latitude", "0.0");
            				location.put("longitude", "0.0");
            			}
            			retailJson.add(location);
					} catch (Exception e) {
						logger.info("Error-" + wsServiceLocation.getZipCode());
					}
                }   
            }
            retailRecord.put("location", retailJson);
            retailRecord.put("StatusCode", wsResponse.getStatusCode());
            retailRecord.put("StatusDesc", wsResponse.getStatusDesc());
        	long end = Calendar.getInstance().getTimeInMillis();
       	 	
        	json.put("執行狀態", "success");
        	json.put("執行時間", end-begin + " ms");
		} catch (Exception e){
			e.printStackTrace();
			json.put("執行狀態", "error-" + e.getMessage());
		}
		return json;
	}
	
	private JSONObject CWSOPTIONSREFRESH() {
		JSONObject json = new JSONObject();
		try{
    		String wsdlURL = propertiesUtil.getProperty("tsp_CMS_EXTEND_url"); 
    		logger.info("wsdlURL: " + wsdlURL);
    		WebServiceCoverageSoapProxy webServiceCoverageSoapProxy = new WebServiceCoverageSoapProxy(wsdlURL);

        	long begin = Calendar.getInstance().getTimeInMillis();
//        	Gen operation
    		JSONObject genMainObject = new JSONObject();
	        WsResponse genWsResponse = webServiceCoverageSoapProxy.newlistCategory("GEN");
        	logger.info("WsResponse genWsResponse: " + ReflectionToStringBuilder.toString(genWsResponse));
    		try {
    	    	WsCallType[] resultData = (WsCallType[]) genWsResponse.getResultData();
    	        JSONArray parent = new JSONArray();
    	    	for(WsCallType wsCallType : resultData){
    	    		String callType = wsCallType.getCallType() == null ? "" : wsCallType.getCallType();	
    	    		String crmName = wsCallType.getCRMName() == null ? "" : wsCallType.getCRMName();
    	    		JSONObject detail = new JSONObject();
    	    		detail.put("call_type", callType);
    	    		detail.put("crm_name", crmName);
    	    		parent.add(detail);
    	    	}
    	    	genMainObject.put("parent", parent);
    	    	genMainObject.put("status", genWsResponse.getStatusCode());
    	    	genMainObject.put("message", genWsResponse.getStatusDesc());
    		} catch (Exception e) {
    			e.printStackTrace();
    	    	genMainObject.put("status", genWsResponse.getStatusCode());
    	    	genMainObject.put("message", genWsResponse.getStatusDesc());
    		}
	    	cwsOptionsRecord.put("gen", genMainObject);
	    	
//	    	Net operation
	        JSONObject netMainObject = new JSONObject();
            WsResponse netWsResponse = webServiceCoverageSoapProxy.newlistCategory("NET");
        	logger.info("WsResponse netWsResponse: " + ReflectionToStringBuilder.toString(genWsResponse));
			try {
	            WsCallType[] resultData = (WsCallType[]) netWsResponse.getResultData();
	            JSONArray parant = new JSONArray();
	        	for(WsCallType wsCallType : resultData){
	        		String callType = wsCallType.getCallType() == null ? "" : wsCallType.getCallType();
	        		String crmName = wsCallType.getCRMName() == null ? "" : wsCallType.getCRMName();
	        		JSONObject detail = new JSONObject();
	        		detail.put("call_type", callType);
	        		detail.put("crm_name", crmName);
	        		parant.add(detail);
	        	}
	        	netMainObject.put("parent", parant);

	    		JSONArray child = new JSONArray();
	        	for(int x = 0; x < parant.size(); x++){
	        		try {
	            		WsResponse wsResponseChild = webServiceCoverageSoapProxy.newlistCategoryChild(parant.getJSONObject(x).getString("call_type"));
	            		WsCallType[] resultDataChild = (WsCallType[]) wsResponseChild.getResultData();
	            		for(WsCallType wsCallType : resultDataChild){
	                		String callType = wsCallType.getCallType() == null ? "" : wsCallType.getCallType();
	                		String crmName = wsCallType.getCRMName() == null ? "" : wsCallType.getCRMName();
	                		JSONObject detail = new JSONObject();
	                		detail.put("parent_call_type", parant.getJSONObject(x).getString("call_type"));
	                		detail.put("call_type", callType);
	                		detail.put("crm_name", crmName);
	            			child.add(detail);
	            		}
					} catch (Exception e) {
						e.printStackTrace();
					}
	        	}
	        	netMainObject.put("child", child);
	        	netMainObject.put("status", netWsResponse.getStatusCode());
	        	netMainObject.put("message", netWsResponse.getStatusDesc());
			} catch (Exception e) {
				e.printStackTrace();
			}
	    	cwsOptionsRecord.put("net", netMainObject);
        	long end = Calendar.getInstance().getTimeInMillis();
       	 	
        	json.put("執行狀態", "success");
        	json.put("執行時間", end-begin + " ms");
		} catch (Exception e){
			e.printStackTrace();
			json.put("執行狀態", "error-" + e.getMessage());
		}
		return json;
	}
}