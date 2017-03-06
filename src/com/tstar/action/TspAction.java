package com.tstar.action;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.Action;
import com.tstar.dto.TspDto;
import com.tstar.service.TspService;
import com.tstar.utility.PropertiesUtil;

@Component
@Scope("prototype")
public class TspAction implements Action{
	
	private final Logger logger = Logger.getLogger(TspAction.class);
	
	private String function;
	private String request;
	
	private InputStream inputStream;
	
	@Autowired
	private PropertiesUtil propertiesUtil;
	
	@Autowired
	private TspService tspService;
	
	
	public String execute(){
    	logger.info("Function:" + function);
    	
    	JSONObject jsonRtn = new JSONObject();
    	
    	// 取得IP位置
		HttpServletRequest req = ServletActionContext.getRequest();
		String ipAddress = req.getHeader("X-FORWARDED-FOR");
		if (ipAddress == null) {
			ipAddress = req.getRemoteAddr();
		}
		
		try {
			JSONObject json = JSONObject.fromObject(request);
			boolean isSuccess = false;
			JSONObject jsonObj = null;
	    	//申請掛失,申請停話
	    	if("simLostServiceApply".equals(function) || "simDisableServiceApply".equals(function)){
					if (json.has("MSISDN") && json.has("AccountNum") && json.has("ContractId")) {
						TspDto tspDto = new TspDto();
						tspDto.setMsisdn(json.getString("MSISDN"));
						tspDto.setAccountNum(json.getString("AccountNum"));
						tspDto.setContractId(json.getString("ContractId"));
						tspDto.setConnIp(ipAddress);
						
						if("simLostServiceApply".equals(function)){
							//申請掛失
							jsonObj = tspService.simLostServiceApply(tspDto);
						}else if("simDisableServiceApply".equals(function)){
							//申請停話
							jsonObj = tspService.simDisableServiceApply(tspDto);
						}
						
						isSuccess = true;
					}else{
						jsonRtn.put("ResultCode", "00004");
						jsonRtn.put("ResultText", "傳入之參數不足");
					}
	    	}else if("insTroubleTicket".equals(function)){
	    	//換補卡申請
	    		//參數驗證(sendType=0:遺失/1:卡片毀損/2:爆卡)
	    		if (json.has("MSISDN") && json.has("AccountNum") && json.has("ContractId") &&
	    				json.has("city") && json.has("county") && json.has("addr") && json.has("zip") && json.has("sendType")) {
					TspDto tspDto = new TspDto();
					tspDto.setMsisdn(json.getString("MSISDN"));
					tspDto.setAccountNum(json.getString("AccountNum"));
					tspDto.setContractId(json.getString("ContractId"));
					tspDto.setConnIp(ipAddress);
					tspDto.setCity(json.getString("city"));
					tspDto.setCounty(json.getString("county"));
					tspDto.setAddr(json.getString("addr"));
					tspDto.setZip(json.getString("zip"));
					tspDto.setSentType(json.getString("sendType"));
					
					jsonObj = tspService.insTroubleTicket(tspDto);
					
					isSuccess = true;
	    		}else{
					jsonRtn.put("ResultCode", "00004");
					jsonRtn.put("ResultText", "傳入之參數不足");
				}
			}else{
	    		jsonRtn.put("ResultCode", "00004");
				jsonRtn.put("ResultText", "傳入之參數不足");
	    	}
	    	
	    	if(isSuccess && jsonObj != null){
	    		jsonRtn.put("ResultCode", "00000");
				//確認回傳訊息正確
				if(jsonObj != null && jsonObj.has("statusCode")){
					//0000代表成功
					if("0000".equals(jsonObj.get("statusCode"))){
						jsonRtn.put("status", "1");
						jsonRtn.put("ResultText", jsonObj.get("statusDesc"));
					}else{
						jsonRtn.put("status", "0");
						jsonRtn.put("ResultText", jsonObj.get("statusDesc"));
					}
				}else{
					jsonRtn.put("ResultCode", "99999");
	    			jsonRtn.put("ResultText", jsonObj == null ? "SYS ERROR" : jsonObj.toString());
				}
	    	}
		}catch(Exception e){
			jsonRtn.put("ResultCode", "99999");
			jsonRtn.put("ResultText", e.getMessage());
		}
    	
    	logger.info("jsonRtn: " + jsonRtn);
    	
    	try {
			inputStream = new ByteArrayInputStream(jsonRtn.toString().getBytes("UTF-8"));
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
    	
    	return SUCCESS;
    }

	public InputStream getInputStream() {
		return inputStream;
	}

	public void setFunction(String function) {
		this.function = function;
	}

	public void setRequest(String request) {
		this.request = request;
	}

}
