package com.tstar.utility;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

public class JsonValidate{
	private final Logger logger = Logger.getLogger(JsonValidate.class);

	/**
	 * 檢核API的輸入值是否含有規定的key<pre>
	 * ex.
	 * checkCompositeJsonKeys(checkJson, new String[] {"ContractId", "AccountNum", "MSISDN"}, 3);
	 * @param checkJson 輸入的值
	 * @param values 規定要檢核的值
	 * @param pickRule 指定可被檢核通過的值的總數
	 * @return
	 * @throws JSONException 
	 */
	public boolean checkCompositeJsonKeys(JSONObject checkJson, String[] values, int pickRule){
		try {
			int pick = 0;
			
			if(null == checkJson){
				logger.debug("Error-checkJson = null");
				return false;
			}else{
				if(null == values || 0 == values.length){
					logger.debug("Error-checkValues = null or checkValues.size() = 0");
					return true;
				}else{
					List<String> checkValues = new ArrayList<String>();
					for(String value : values){
						checkValues.add(value);
					}
					for(int i = 0; i < checkValues.size(); i++){
						String[] keys = checkValues.get(i).split(",");
						if(1 < keys.length){
							int dependentCount = 0;
							for(int x = 0; x < keys.length; x ++){
								if(checkJson.has(keys[x])){
									if(StringUtils.isBlank(checkJson.optString(keys[x]))){
										if("ContractId".equals(keys[x]) || "MSISDN".equals(keys[x]) || "AccountNum".equals(keys[x])){
											logger.debug("Error-" +keys[x]+ " can't not be null");
											return false;
										}
									}
									dependentCount++;
								}
					    		if(x == keys.length-1){
					    			if(dependentCount == keys.length){
					    				pick++;
										if(pick == pickRule){
											return true;
										}else if(i == checkValues.size()-1){
											logger.debug("Error-The Validate doesn't check with the rules");
											return false;
										}
					    			}else{
										logger.debug("Error-The dependent values aren't match");
										return false;
					    			}
					    		}
							}
						}else{
							if(checkJson.has(keys[0])){
								if(StringUtils.isBlank(checkJson.optString(keys[0]))){
									if("ContractId".equals(keys[0]) || "MSISDN".equals(keys[0]) || "AccountNum".equals(keys[0])){
										logger.debug("Error-" +keys[0]+ " can't not be null");
										return false;
									}
								}
								pick++;
								if(pick == pickRule){
									return true;
								}else if(i == checkValues.size()-1){
									logger.debug("Error-The Validate doesn't check with the rules");
									return false;
								}
							}else if(i == checkValues.size()-1){
								logger.debug("Error-The single value isn't match");
								return false;
							}
						}
					}
				}
			}
			logger.debug("Error-Have no any idea");
			return false;
		} catch (Exception e) {
			e.printStackTrace();
//			Log message to db
    		Map<String, Object> memo = new TreeMap<String, Object>();
			memo.put("cause", new Utils().handleExceptionMessage(e));
			new Utils().logRecorder("ERROR", "", "", memo);
			return true;
		}
	}

	/**
	 * 
	 * @param json 需確認的Json
	 * @param checkKey 需檢核的key
	 * @return
	 */
    public boolean checkJsonValue(JSONObject json, String checkKey){
		String[] keyList = checkKey.split(",");
		for(String key : keyList){
			if(json.has(key)){
	    		try {
					if(StringUtils.isBlank(json.optString(key))){
						logger.info("validation fail: " + key + " can't be empty");
						return false;
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
	    	}else{
	    		logger.info("validation fail: " + key + " can't be null");
	    		return false;
	    	}
		}
    	return true;
    }
}
