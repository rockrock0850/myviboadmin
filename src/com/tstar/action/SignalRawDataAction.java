package com.tstar.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts2.ServletActionContext;
import org.apache.struts2.interceptor.ServletRequestAware;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.exc.UnrecognizedPropertyException;
import com.opensymphony.xwork2.Action;
import com.tstar.dto.CellStrengthResp;
import com.tstar.utility.AES;
import com.tstar.utility.PostData;
import com.tstar.utility.PropertiesUtil;
import com.tstar.utility.SspException;

@Component
@Scope("prototype")
public class SignalRawDataAction implements Action, ServletRequestAware{
	
	private final Logger logger = Logger.getLogger(SignalRawDataAction.class);
	
	@Autowired
	private PropertiesUtil propertiesUtil;
	
	@Autowired
	private PostData postData;
	
	
	@Autowired
	private AES aes;
	
	private String request;
	private String status;
	private String message;
	private List<CellStrengthResp> data;
	HttpServletRequest servletRequest;
	
    public String execute() {
		
		try{
			logger.debug("request: " + request);
			
			//解密字串
			String decryptedStr = aes.decrypt4AES(propertiesUtil.getProperty("aes.iv"), propertiesUtil.getProperty("aes.key"),request);
			logger.info("decryptedStr: " + decryptedStr);
			
    		JSONObject jsObj = new JSONObject();
    		jsObj.put("method", "addSignal");
    		jsObj.put("request", decryptedStr);
    		
    		Map<String, String> returnMap = postData.jsonPost(propertiesUtil.getProperty("ntsApUrl") + "ntsService", jsObj.toString());

    		if("success".equals(returnMap.get("code"))){
    			logger.info("return value: " + returnMap.get("value"));
    			JSONObject json = new JSONObject( returnMap.get("value") );
    			status = json.getString("status");
    			message = json.getString("message");
    			
    			ObjectMapper mapper = new ObjectMapper();
    			List<CellStrengthResp> cellStrengthRespList = mapper.readValue(json.getJSONArray("data").toString(), mapper.getTypeFactory().constructCollectionType(List.class, CellStrengthResp.class));
    			data = cellStrengthRespList;
    			
    		}else{
    			status = "10002";
    			message = returnMap.get("value");
    		}
		} catch (UnrecognizedPropertyException e){
			e.printStackTrace();
			status = "10001";
			message = "輸入資料錯誤";
		} catch (SspException e){
			e.printStackTrace();
			status = e.getCode();
			message = e.getMessage();
			e.printStackTrace();
		} catch (Exception e){
			e.printStackTrace();
			status = "99999";
			message = "系統處理錯誤";
		} catch (Throwable e){
			e.printStackTrace();
			status = "99999";
			message = "系統處理錯誤";
		}
		
		return SUCCESS;
    }
    
    
    public String queryCellStrength() {
		
    	try{
			logger.debug("request: " + request);
			
			//解密字串
			String decryptedStr = aes.decrypt4AES(propertiesUtil.getProperty("aes.iv"), propertiesUtil.getProperty("aes.key"),request);
			logger.info("decryptedStr: " + decryptedStr);
			
    		JSONObject jsObj = new JSONObject();
    		jsObj.put("method", "queryCellStrength");
    		jsObj.put("request", decryptedStr);
    		
    		Map<String, String> returnMap = postData.jsonPost(propertiesUtil.getProperty("ntsApUrl") + "queryCellStrength", jsObj.toString());

    		if("success".equals(returnMap.get("code"))){
    			logger.info("return value: " + returnMap.get("value"));
    			JSONObject json = new JSONObject( returnMap.get("value") );
    			
    			JSONObject jObj = new JSONObject();
    			jObj.put("status", json.getString("status"));
    			jObj.put("message", json.getString("message"));
    			jObj.put("data", json.getJSONArray("data"));
    			
    			write2Response(jObj);
    		}else{
    			status = "10002";
    			message = returnMap.get("value");
    		}
		} catch (UnrecognizedPropertyException e){
			e.printStackTrace();
			status = "10001";
			message = "輸入資料錯誤";
		} catch (SspException e){
			e.printStackTrace();
			status = e.getCode();
			message = e.getMessage();
			e.printStackTrace();
		} catch (Exception e){
			e.printStackTrace();
			status = "99999";
			message = "系統處理錯誤";
		} catch (Throwable e){
			e.printStackTrace();
			status = "99999";
			message = "系統處理錯誤";
		}
		
		return SUCCESS;
    }
    
    private void write2Response(JSONObject jObj){
    	PrintWriter writer;
        HttpServletResponse response = ServletActionContext.getResponse();
        response.setCharacterEncoding("UTF-8");
        try {
            writer = response.getWriter();//将内容输出到response
            
            writer.write(jObj.toString());
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

	public String getStatus() {
		return status;
	}

	public String getMessage() {
		return message;
	}


	public void setServletRequest(HttpServletRequest servletRequest) {
		this.servletRequest = servletRequest;
	}

	public void setRequest(String request) {
		this.request = request;
	}

	public List<CellStrengthResp> getData() {
		return data;
	}

}
