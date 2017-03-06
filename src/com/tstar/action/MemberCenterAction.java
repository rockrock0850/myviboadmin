package com.tstar.action;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.apache.log4j.Logger;
import org.json.modify.JSONException;
import org.json.modify.JSONObject;
import org.json.modify.XML;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.Action;
import com.tstar.service.MemberCenterService;
import com.tstar.utility.PostData;
import com.tstar.utility.PropertiesUtil;
import com.tstar.utility.StringFilter;
import com.tstar.utility.Utils;

@Component
@Scope("prototype")
public class MemberCenterAction implements Action{
	
	private final Logger logger = Logger.getLogger(MemberCenterAction.class);
	
	private String Function;
	private String ResponseType;
	private String Request;
	
	private InputStream inputStream;
	
	@Autowired
	private PropertiesUtil propertiesUtil;
	
	@Autowired
	private MemberCenterService memberCenterService;
	
	public String execute(){
		String response = "";
    	logger.debug("MemberCenterAction.execute() Function:" + Function);
    	
    	Map<String, String> returnMap = new HashMap<String, String>();
    	
    	//用戶大頭照圖檔更新
    	if("setProfilePic".equals(Function)){
    		StringBuffer queryXml = new StringBuffer("<SetCustomerProfilePicReq><RequestId>" + Utils.generateRequestId() + "</RequestId>");
    		queryXml.append("<ServiceId>" + propertiesUtil.getProperty("mc_id") + "</ServiceId>");
    		queryXml.append("<ServicePassword>" + propertiesUtil.getProperty("mc_pw") + "</ServicePassword>");
    		queryXml.append(Request);
    		queryXml.append("</SetCustomerProfilePicReq>");
    		
    		//圖檔太大，不印
    		logger.debug("query memberCenter xml: " + queryXml);
    		
    		ArrayList<NameValuePair> pairList = new ArrayList<NameValuePair>();
    		pairList.add(new BasicNameValuePair("xml", queryXml.toString()));
    		
    		PostData postData = new PostData();
    		String mcUrl = propertiesUtil.getProperty("mc_url") + "setPic/setProfilePic.action";
    		returnMap = postData.post(mcUrl, pairList);
    	
    	//忘記密碼功能
    	}else if("forgetPwd".equals(Function)){
    		StringBuffer queryXml = new StringBuffer("<ResetCustomerPasswordReq><RequestId>" + Utils.generateRequestId() + "</RequestId>");
    		queryXml.append("<ServiceId>" + propertiesUtil.getProperty("mc_id") + "</ServiceId>");
    		queryXml.append("<ServicePassword>" + propertiesUtil.getProperty("mc_pw") + "</ServicePassword>");
    		queryXml.append(Request);
    		queryXml.append("</ResetCustomerPasswordReq>");
    		
    		logger.info("queryXml: " + StringFilter.replaceXMLValue(queryXml.toString()));
    		
    		ArrayList<NameValuePair> pairList = new ArrayList<NameValuePair>();
    		pairList.add(new BasicNameValuePair("xml", queryXml.toString()));
    		
    		PostData postData = new PostData();
    		String mcUrl = propertiesUtil.getProperty("mc_url") + "forget/forgetPwd.action";
    		returnMap = postData.post(mcUrl, pairList);
    		
    	//變更密碼功能
    	}else if("setPassword".equals(Function)){
    		StringBuffer queryXml = new StringBuffer("<SetCustomerPasswordReq><RequestId>" + Utils.generateRequestId() + "</RequestId>");
    		queryXml.append("<ServiceId>" + propertiesUtil.getProperty("mc_id") + "</ServiceId>");
    		queryXml.append("<ServicePassword>" + propertiesUtil.getProperty("mc_pw") + "</ServicePassword>");
    		queryXml.append(Request);
    		queryXml.append("</SetCustomerPasswordReq>");
    		
    		logger.info("queryXml: " + StringFilter.replaceXMLValue(queryXml.toString()));
    		
    		ArrayList<NameValuePair> pairList = new ArrayList<NameValuePair>();
    		pairList.add(new BasicNameValuePair("xml", queryXml.toString()));
    		
    		PostData postData = new PostData();
    		String mcUrl = propertiesUtil.getProperty("mc_url") + "setPwd/setPassword.action";
    		returnMap = postData.post(mcUrl, pairList);
    	//SSOLogin
    	}else if("SSOLogin".equals(Function)){
    		returnMap = memberCenterService.login(Request);
    	//GetCustProfile
    	}else if("GetCustProfile".equals(Function)){
    		returnMap = memberCenterService.getCustProfile(Request);
    	}
    	
    	logger.debug("result code: " + returnMap.get("code") + " value: " + StringFilter.replaceXMLValue(returnMap.get("value")));
    	
    	if("success".equals(returnMap.get("code"))){
			if("json".equals(ResponseType)){
				try {
					String str = returnMap.get("value").replaceAll(" ", "").replaceAll("\n", "");
					logger.debug(str);
					JSONObject json = XML.toJSONObject(str);
					response = json.toString();
					logger.debug(response);
				} catch (JSONException e) {
					e.printStackTrace();
					response = returnMap.get("value");
				}
			}else{
				response = returnMap.get("value");
			}
		//如果錯誤要組錯誤訊息回傳
		}else{
			if("setProfilePic".equals(Function)){
				response = "<SetCustomerProfilePicRes><ResultCode>99999</ResultCode>"
						+ "<ResultText>" + returnMap.get("value") + "</ResultText></SetCustomerProfilePicRes>";
			}else if("forgetPwd".equals(Function)){
				response = "<ResetCustomerPasswordRes><ResultCode>99999</ResultCode>"
						+ "<ResultText>" + returnMap.get("value") + "</ResultText></ResetCustomerPasswordRes>";
			}else if("setPassword".equals(Function)){
				response = "<SetCustomerPasswordRes><ResultCode>99999</ResultCode>"
						+ "<ResultText>" + returnMap.get("value") + "</ResultText></SetCustomerPasswordRes>";
			}else if("SSOLogin".equals(Function)){
				response = "<SSOLoginRes><ResultCode>99999</ResultCode>"
						+ "<ResultText>" + returnMap.get("value") + "</ResultText></SSOLoginRes>";
			}else if("GetCustProfile".equals(Function)){
				response = "<GetCustProfileRes><ResultCode>99999</ResultCode>"
						+ "<ResultText>" + returnMap.get("value") + "</ResultText></GetCustProfileRes>";
			}
		}
    	
    	logger.info("response: " + StringFilter.replaceJSONValue(response));
    	
    	try {
			inputStream = new ByteArrayInputStream(response.getBytes("UTF-8"));
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
    	
    	return SUCCESS;
    }

	public InputStream getInputStream() {
		return inputStream;
	}

	public void setFunction(String function) {
		Function = function;
	}

	public void setResponseType(String responseType) {
		ResponseType = responseType;
	}

	public void setRequest(String request) {
		Request = request;
	}
}
