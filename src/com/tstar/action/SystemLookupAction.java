package com.tstar.action;


import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.Action;
import com.tstar.model.tapp.SystemLookup;
import com.tstar.service.SystemLookupService;

@Component
@Scope("prototype")
public class SystemLookupAction implements Action{
	
	private final Logger logger = Logger.getLogger(SystemLookupAction.class);
	
	//ios, android
	private String osType;
	private String systemKey;
	private String isLike;
	private JSONObject jsonStr;
	
	@Autowired
	private SystemLookupService systemLookupService;
	   
	public String execute(){
		logger.debug("osType: " + osType);
		try{
			if(StringUtils.isNotBlank(osType)){
				JSONObject json = new JSONObject();
				List<SystemLookup> systemLookupList = systemLookupService.getLikeValue("mytstar", "app_");
				if("android".equals(osType)){
					for(SystemLookup sl : systemLookupList){
						if(-1 != sl.getKey().indexOf("app_and_")){
							json.put(sl.getKey().replace("app_and_", ""), sl.getValue());
						}
					}
				}else if("ios".equals(osType)){
					for(SystemLookup sl : systemLookupList){
						if(-1 != sl.getKey().indexOf("app_ios_")){
							json.put(sl.getKey().replace("app_ios_", ""), sl.getValue());
						}
					}
				}
				logger.debug(json.toString());
				jsonStr = json;
			}
		}catch(Exception e ){
			e.printStackTrace();
		}
		
    	return SUCCESS;
    }
	
	public String queryAppSystemKey(){
		logger.info("osType: " + osType + ", systemKey: " + systemKey);
		JSONObject json = new JSONObject();
		try{
			//判斷必填參數
			if(StringUtils.isNotBlank(osType) && StringUtils.isNotBlank(systemKey)){
				List<SystemLookup> systemLookupList = new ArrayList<SystemLookup>();
				if(StringUtils.isBlank(isLike) || "N".equals(isLike)){
					systemLookupList = systemLookupService.getSystemLookup("mytstar", systemKey);
				}else{
					systemLookupList = systemLookupService.getLikeValue("mytstar", systemKey);
				}
				
				
				if(systemLookupList != null && !systemLookupList.isEmpty()){
					JSONArray jsonArr = new JSONArray();
					for(SystemLookup systemLookup : systemLookupList){
						JSONObject jsonIn = new JSONObject();
						jsonIn.put("systemKey", systemLookup.getKey());
						jsonIn.put("value", systemLookup.getValue());
						jsonArr.add(jsonIn);
					}
					
					logger.debug("jsonArr: " + jsonArr.toString());
					
					json.put("status", "00000");
					json.put("osType", osType);
					json.put("data", jsonArr);
					
					logger.debug("json: " + json.toString());
				}else{
					json.put("status", "11203");
					json.put("message", "查無資料");
				}
				
			}else{
				json.put("status", "00004");
				json.put("message", "傳入之參數不足");
			}
		}catch(Exception e ){
			e.printStackTrace();
			json.put("status", "99999");
			json.put("message", e.getMessage());
		}
		
		logger.info(json.toString());
		
//		json = new JSONObject();
//		json.put("test", "test");
//		
//		logger.info(json);
		
		jsonStr = json;
    	return SUCCESS;
    }
	
	public String queryAppSystemTime(){
		JSONObject json = new JSONObject();
		try{
			Date date = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");
				
			json.put("status", "00000");
			json.put("dateTime", sdf.format(date));
			
		}catch(Exception e ){
			e.printStackTrace();
			json.put("status", "99999");
			json.put("message", e.getMessage());
		}
		
		logger.info(json.toString());
		
		jsonStr = json;
    	return SUCCESS;
    }

	public JSONObject getJsonStr() {
		return jsonStr;
	}

	public void setOsType(String osType) {
		this.osType = osType;
	}

	public void setSystemKey(String systemKey) {
		this.systemKey = systemKey;
	}

	public void setIsLike(String isLike) {
		this.isLike = isLike;
	}
    

}
