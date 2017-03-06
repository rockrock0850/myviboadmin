package com.tstar.service.impl;

import java.util.ArrayList;
import java.util.Map;

import net.sf.json.JSON;
import net.sf.json.JSONSerializer;
import net.sf.json.xml.XMLSerializer;

import org.apache.commons.lang.StringUtils;
import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.apache.log4j.Logger;
import org.json.modify.JSONException;
import org.json.modify.JSONObject;
import org.json.modify.XML;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.tstar.service.MemberCenterService;
import com.tstar.utility.PostData;
import com.tstar.utility.PropertiesUtil;
import com.tstar.utility.StringFilter;
import com.tstar.utility.Utils;

@Controller
public class MemberCenterServiceImpl implements MemberCenterService{
	
	private final Logger logger = Logger.getLogger(MemberCenterServiceImpl.class);
	
	
	@Autowired
	private PropertiesUtil propertiesUtil;
	
	public Map<String, String> getCustProfile(String requestXml){
		StringBuffer queryXml = new StringBuffer("<GetCustProfileReq><RequestId>" + Utils.generateRequestId() + "</RequestId>");
		queryXml.append("<ServiceId>" + propertiesUtil.getProperty("mc_id") + "</ServiceId>");
		queryXml.append("<ServicePassword>" + propertiesUtil.getProperty("mc_pw") + "</ServicePassword>");
		queryXml.append(requestXml);
		queryXml.append("</GetCustProfileReq>");
		
		logger.info("queryXml: " + StringFilter.replaceXMLValue(queryXml.toString()));
		
		ArrayList<NameValuePair> pairList = new ArrayList<NameValuePair>();
		pairList.add(new BasicNameValuePair("xml", queryXml.toString()));
		
		PostData postData = new PostData();
		String mcUrl = propertiesUtil.getProperty("mc_url") + "MC/GetCustProfile.action";
		return postData.post(mcUrl, pairList);
	}
	
	public Map<String, String> ssoLogin(String requestXml){
		StringBuffer queryXml = new StringBuffer("<SSOLoginReq><RequestId>" + Utils.generateRequestId() + "</RequestId>");
		queryXml.append("<ServiceId>" + propertiesUtil.getProperty("mc_id") + "</ServiceId>");
		queryXml.append("<ServicePassword>" + propertiesUtil.getProperty("mc_pw") + "</ServicePassword>");
		queryXml.append(requestXml);
		queryXml.append("</SSOLoginReq>");
		
		logger.info("queryXml: " + StringFilter.replaceXMLValue(queryXml.toString()));
		
		ArrayList<NameValuePair> pairList = new ArrayList<NameValuePair>();
		pairList.add(new BasicNameValuePair("xml", queryXml.toString()));
		
		PostData postData = new PostData();
		String mcUrl = propertiesUtil.getProperty("mc_url") + "MC/SSOLogin.action";
		
		return postData.post(mcUrl, pairList);
	}
	
	public Map<String, String> login(String requestXml){
		StringBuffer queryXml = new StringBuffer("<SSOLoginReq><RequestId>" + Utils.generateRequestId() + "</RequestId>");
		queryXml.append("<ServiceId>" + propertiesUtil.getProperty("mc_id") + "</ServiceId>");
		queryXml.append("<ServicePassword>" + propertiesUtil.getProperty("mc_pw") + "</ServicePassword>");
		queryXml.append(requestXml);
		queryXml.append("</SSOLoginReq>");
		
		logger.info("queryXml: " + StringFilter.replaceXMLValue(queryXml.toString()));
		
		ArrayList<NameValuePair> pairList = new ArrayList<NameValuePair>();
		pairList.add(new BasicNameValuePair("xml", queryXml.toString()));
		
		PostData postData = new PostData();
		String mcUrl = propertiesUtil.getProperty("mc_url") + "MC/SSOLogin.action";
		
		Map<String, String> returnMap = postData.post(mcUrl, pairList);
		
		if("success".equals(returnMap.get("code"))){
			try {
				String str = returnMap.get("value").replaceAll(" ", "").replaceAll("\n", "");
				JSONObject json = XML.toJSONObject(str);
				logger.info("json: " + StringFilter.replaceJSONValue(json.toString()));
				json = json.getJSONObject("SSOLoginRes");
				logger.debug("json: " + json);
				if("00000".equals(json.get("ResultCode"))){
					String loginToken = (String)json.get("LoginToken");
					logger.debug("loginToken: " + loginToken);
					Map<String, String> profileMap = getCustProfile("<Token>" + loginToken + "</Token>");
					if("success".equals(profileMap.get("code"))){
						String profileStr = profileMap.get("value").replaceAll(" ", "").replaceAll("\n", "");
						JSONObject profileJson = XML.toJSONObject(profileStr);
						logger.info("profileJson: " + StringFilter.replaceJSONValue(profileJson.toString()));
						profileJson = profileJson.getJSONObject("GetCustProfileRes");
						logger.debug("profileJson: " + profileJson);
						//
						if("00000".equals(profileJson.get("ResultCode"))){
							json.put("ContractId", profileJson.get("ContractId"));
							json.put("CustomerId", profileJson.get("CustId"));
							json.put("OperatorId", profileJson.get("OperatorId"));
							json.put("CompanyId", profileJson.get("CompanyId"));
							//空的就回空的
							if(StringUtils.isNotBlank((String)profileJson.get("PicUrl"))){
								json.put("PicURL", propertiesUtil.getProperty("mc_pic_url") + profileJson.get("PicUrl"));
							}else{
								json.put("PicURL", "");
							}
							
							JSONObject jsonRtn = new JSONObject();
							jsonRtn.put("SSOLoginRes", json);
							JSON json2xml = JSONSerializer.toJSON( jsonRtn.toString() );
							XMLSerializer xmlSerializer = new XMLSerializer();
							xmlSerializer.setTypeHintsEnabled( false );
							System.out.println(json2xml);
							String xml = (xmlSerializer.write( json2xml ));
							xml = xml.substring( xml.indexOf("<o>") + 3, xml.indexOf("</o>"));
							logger.info("xml: " + StringFilter.replaceXMLValue(xml));
							returnMap.put("value", xml);
						}else{
							logger.info("profileJson.get(ResultCode): " + profileJson.get("ResultCode"));
						}
					}
				}else{
					logger.info("json.get(ResultCode): " + json.get("ResultCode"));
				}
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
		return returnMap;
	}
}
