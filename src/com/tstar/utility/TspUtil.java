package com.tstar.utility;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.builder.ReflectionToStringBuilder;
import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.databind.exc.UnrecognizedPropertyException;
import com.tstar.service.TspService;

@Component
public class TspUtil {
	private final Logger logger = Logger.getLogger(TspUtil.class);

	@Autowired
	private PropertiesUtil propertiesUtil;

	@Autowired
	private TspService tspService;

	@Autowired
	private AES aes;

	@Autowired
	ApplicationContext context;
	
	/**
	 * @param request User請求的條件
	 * @param api tspService的方法名稱
	 * @return
	 */
	public JSONObject actionRun(String request, String api){
		logger.info("request: " + request);
		
    	JSONObject json = new JSONObject();
    	String status, message = "";
    	
		try{
			String decryptedStr = aes.decrypt4AES(propertiesUtil.getProperty("aes.iv"), propertiesUtil.getProperty("aes.key"), request);// 解密字串
			logger.info("decryptedStr: " + decryptedStr);
			
			JSONObject jsonReq;
			if(StringUtils.isBlank(decryptedStr)){
				jsonReq = new JSONObject();
			}else{
				jsonReq = new JSONObject(decryptedStr);
			}

			JsonValidate jsonValidate = new JsonValidate();
			JSONArray data = new JSONArray();
//			檢核機制
			if("remainVal".equals(api)){
				if(!jsonValidate.checkCompositeJsonKeys(jsonReq, new String[] {"ContractId", "AccountNum", "MSISDN"}, 3)){
					throw new SspException("10004", "傳入之參數不足", new Exception());
				}
				data.put(tspService.remainVal(jsonReq.optString("ContractId"), jsonReq.optString("MSISDN"), jsonReq.optString("AccountNum"), Utils.getRealIpAddress()));
			}else if("queryTicket".equals(api)){
				if(!jsonValidate.checkCompositeJsonKeys(jsonReq, new String[] {"ContractId", "AccountNum", "MSISDN"}, 3)){
					throw new SspException("10004", "傳入之參數不足", new Exception());
				}
				data.put(tspService.queryTicket(jsonReq.optString("ContractId"), jsonReq.optString("MSISDN"), jsonReq.optString("AccountNum"), jsonReq.optString("ticketId"), jsonReq.optString("year"), jsonReq.optString("month"), Utils.getRealIpAddress()));
			}else if("contactUsReplyRead".equals(api)){
				if(!jsonValidate.checkCompositeJsonKeys(jsonReq,  new String[] {"issueId"}, 1)){
					throw new SspException("10004", "傳入之參數不足", new Exception());
				}
				data.put(tspService.contactUsReplyRead(jsonReq.optString("issueId")));
			}else if("contactUsIssueAddAgain".equals(api)){
				if(!jsonValidate.checkCompositeJsonKeys(jsonReq, new String[] {"issueId", "issueNote"}, 2)){
					throw new SspException("10004", "傳入之參數不足", new Exception());
				}
				data.put(tspService.contactUsIssueAddAgain(jsonReq.optString("issueId"), jsonReq.optString("issueNote")));
			}else if("zipCode".equals(api)){
				if(!jsonValidate.checkCompositeJsonKeys(jsonReq, new String[] {"function_type"}, 1)){
					throw new SspException("10004", "傳入之參數不足", new Exception());
				}
				data.put(tspService.zipCode(jsonReq.optString("function_type")));
			}else if("retail".equals(api)){
				if(!jsonValidate.checkCompositeJsonKeys(jsonReq, new String[] {"zipCode", "address"}, 2)){
					throw new SspException("10004", "傳入之參數不足", new Exception());
				}
				data.put(tspService.retail(jsonReq.optString("zipCode"), jsonReq.optString("address")));
			}else if("depositBankInfo".equals(api)){
				if(!jsonValidate.checkCompositeJsonKeys(jsonReq, null, 0)){
					throw new SspException("10004", "傳入之參數不足", new Exception());
				}
				data.put(tspService.depositBankInfo());
			}else if("cwsOptions".equals(api)){
				if(!jsonValidate.checkCompositeJsonKeys(jsonReq, null, 0)){
					throw new SspException("10004", "傳入之參數不足", new Exception());
				}
				data.put(tspService.cwsOptions());
			}
			json.put("data", data);
			status = "00000";
		} catch (Exception e){
			Map<String, String> errorMessage = exceptionParser(e);
			status = errorMessage.get("status");
			message = errorMessage.get("message");
		}
		
		try {
			json.put("resultCode", status);
			json.put("resultText", message);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		
		Utils utils = new Utils();
		utils.write2Response(json);
		logger.info("actionRun return json:" + json);
		return json;
	}
	
	public JSONArray refresher(String request){
		JSONArray json = new JSONArray();
    	
		try{
			logger.info("request: " + request);
			String decryptedStr = aes.decrypt4AES(propertiesUtil.getProperty("aes.iv"), propertiesUtil.getProperty("aes.key"), request);// 解密字串
			logger.info("decryptedStr: " + decryptedStr);

			String[] apis = parseRefreshApi(decryptedStr);
			logger.info("Refresh apis:" + ReflectionToStringBuilder.toString(apis));
			
			net.sf.json.JSONObject response = tspService.refreshCache(apis);
			json.put(response);
		} catch (Exception e){
			Map<String, String> errorMessage = exceptionParser(e);
			json.put(errorMessage.get("status"));
			json.put(errorMessage.get("message"));
		}
		Utils utils = new Utils();
		utils.write2Response(json);
		return json;
	}

	private String[] parseRefreshApi(String decryptedStr){
		try {
			String[] apisFromProp = propertiesUtil.getProperty("refresh_apis").split(",");
			String[] apisFromReq = new JSONObject(decryptedStr).optString("function").split(",");
			if(StringUtils.isBlank(decryptedStr)){
				return new String[]{};
			}else if("all".equals(apisFromReq[0])){
				return apisFromProp;
			}else{
				for(int i = 0; i < apisFromReq.length; i++){
					for(int j = 0; j < apisFromProp.length; j++){
						if(apisFromProp[j].equals(StringUtils.upperCase(apisFromReq[i]))){
							break;
						}else if(j == apisFromProp.length-1){
							logger.debug("Removed: " + apisFromReq[i]);
							apisFromReq[i] = "";
						}
					}
				}
			}
			return apisFromReq;
		} catch (Exception e) {
			e.printStackTrace();
			return new String[]{};
		}
	}
	
	private Map<String, String> exceptionParser(Exception e){
		if(e instanceof SspException){
			SspException sspException = (SspException)e;
			return returnErrorMessage(sspException.getCode(), sspException.getMessage());
		}else if(e instanceof UnrecognizedPropertyException){
			e.printStackTrace();
			return returnErrorMessage("10001", "輸入資料錯誤");
		}else if(e instanceof JSONException){
			e.printStackTrace();
			return returnErrorMessage("99999", "系統處理錯誤");
		}else{
			e.printStackTrace();
			return returnErrorMessage("99999", "系統處理錯誤");
		}
	}
	
	private Map<String, String> returnErrorMessage(String status, String message){
		Map<String, String> errorMessage = new HashMap<String, String>();
		errorMessage.put("status", status);
		errorMessage.put("message", message);
		return errorMessage;
	}
}
