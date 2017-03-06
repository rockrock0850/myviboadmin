package com.tstar.utility;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.util.EntityUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

@Service
public class PostData {
	
	private final Logger logger = Logger.getLogger(PostData.class);
	
	public Map<String, String> post(String url, ArrayList<NameValuePair> pairList){
		return doPost(url, pairList, false);
	}
	
	public Map<String, String> jsonPost(String url, String stringEntity){
		return doPost(url, stringEntity, true);
	}
	
	@SuppressWarnings("unchecked")
	private Map<String, String> doPost(String url, Object entity, boolean isJsonPost){
		logger.info("url: " + url);
		Map<String, String> returnMap = new HashMap<String, String>();
		CloseableHttpClient client = HttpClientBuilder.create().build();
		try{
			HttpPost httpPost = new HttpPost(url);
			if(isJsonPost){
				httpPost.setHeader("Content-type", "application/json");
				httpPost.setEntity(new StringEntity((String)entity, "UTF-8"));
			}else{
				httpPost.setEntity(new UrlEncodedFormEntity((ArrayList<NameValuePair>)entity, "UTF-8"));
			}
	        HttpResponse response = client.execute(httpPost);
	        
	        String responseString = EntityUtils.toString(response.getEntity());
	        
	        if (response.getStatusLine().getStatusCode() == HttpStatus.SC_OK ) {
	            // 如果回傳是 200 OK 的話才輸出
	        	if("".equals(responseString)){
	        		returnMap.put("code", "fail");
		        	returnMap.put("value", "資料錯誤");
	        	}else{
	        		returnMap.put("code", "success");
		        	returnMap.put("value", responseString);
	        	}
	        } else {
	        	logger.info("HttpStatus: " + response.getStatusLine().getStatusCode() + " responseString: " + responseString);
	        	returnMap.put("code", "fail");
	        	returnMap.put("value", response.getStatusLine().toString());
	        }
		}catch(Exception e){
			returnMap.put("code", "fail");
        	returnMap.put("value", e.getMessage());
		}
		
		if(client != null){
			try {
				client.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		
        return returnMap;
	}
	
	
}
