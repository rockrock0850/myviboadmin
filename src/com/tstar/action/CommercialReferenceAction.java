package com.tstar.action;

import java.util.ArrayList;
import java.util.List;
import java.util.Calendar;
import java.util.Date;
import java.sql.Timestamp;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;
import org.apache.commons.lang.StringUtils;

import com.opensymphony.xwork2.Action;
import com.tstar.dto.CommercialReferenceDto;
import com.tstar.model.tapp.CommercialReference;
import com.tstar.service.AccountListService;
import com.tstar.service.CommercialReferenceService;
import com.tstar.utility.MD5Encription;

@Component
@Scope("prototype")
public class CommercialReferenceAction implements Action{
	private final Logger logger = Logger.getLogger(CommercialReferenceAction.class);
	@Autowired
	private MD5Encription mD5Encription;	
	@Autowired
	private AccountListService accountListService;
	@Autowired
	private CommercialReferenceService commercialReferenceService;
	
	private JSONObject jsonStr;
	private CommercialReferenceDto request;
	private String functionId = "cr";
	@Override
	public String execute() throws Exception {
		jsonStr = new JSONObject();
		if (request != null && StringUtils.isNotBlank(this.request.getSystemId()) && StringUtils.isNotBlank(this.request.getSystemKey())
				&& StringUtils.isNotBlank(this.request.getMsisdn()) && StringUtils.isNotBlank(this.request.getSourceId()) 
				&& StringUtils.isNotBlank(this.request.getAction())) {
			logger.info(" MSISDN: " + request.getMsisdn() + " SourceId: " + request.getSourceId()+" Action: " + request.getAction());
			//systemkey加密
			String password = mD5Encription.encrypt(this.request.getSystemKey());
			this.request.setSystemKey(password);
			//確認登入狀態
			boolean checkaccount = accountListService.authUser(this.request.getSystemId(), this.request.getSystemKey(), functionId);
			if(checkaccount){
				List<CommercialReference> resultdata = new ArrayList<CommercialReference>();
				resultdata = commercialReferenceService.queryCommercialReference(this.request.getMsisdn(), this.request.getAction(), this.request.getContractId(), this.request.getSourceId());
				
				HttpServletRequest httpServletRequest = ServletActionContext.getRequest();
				String ip = httpServletRequest.getRemoteAddr();
				Date date = new Date();
				Timestamp timestamp = new Timestamp(date.getTime());
				int random=(int)(Math.random()*900)+100; 
				Calendar cal = Calendar.getInstance();
				String milliseconds = Long.toString(cal.getTimeInMillis()+(long)random);
				
				CommercialReference commercialReference = new CommercialReference();
				
				//確認資料是否重複
				if(resultdata == null || resultdata.size() == 0){
					commercialReference.setId(milliseconds);
					commercialReference.setMsisdn(this.request.getMsisdn());
					commercialReference.setStatus("1");
					if(StringUtils.isNotBlank(this.request.getContractId())){
						commercialReference.setContractId(this.request.getContractId());
					}else{
						commercialReference.setContractId("non");
					}
					commercialReference.setSourceId(this.request.getSourceId());
					commercialReference.setSourceIp(ip);
					commercialReference.setAction(this.request.getAction());
					commercialReference.setMemo1(this.request.getMemo1());
					commercialReference.setMemo2(this.request.getMemo2());
					commercialReference.setCreateUser(this.request.getSystemId());
					commercialReference.setUpdateUser(this.request.getSystemId());
					commercialReference.setCreateTime(timestamp);
					commercialReference.setUpdateTime(timestamp);
					boolean checkinsert = commercialReferenceService.insertCommercialReferenc(commercialReference);
					if(checkinsert){
						jsonStr.put("message", "success");	
						jsonStr.put("status", "00000");
					}else{
						jsonStr.put("message", "新增失敗");	
						jsonStr.put("status", "99001");
					}
				}else{
					//安裝雪豹可以更新資料
					if("2".equals(request.getAction())){
						if(resultdata != null && 1 == resultdata.size()){
							commercialReference = resultdata.get(0);
							commercialReference.setSourceId(this.request.getSourceId());
							commercialReference.setMemo1(this.request.getMemo1());
							commercialReference.setMemo2(this.request.getMemo2());
							commercialReference.setUpdateUser(this.request.getSystemId());
							commercialReference.setUpdateTime(timestamp);
							boolean checkUpdate = commercialReferenceService.updateCommercialReferenc(commercialReference);
							
							if(checkUpdate){
								jsonStr.put("message", "success");	
								jsonStr.put("status", "00000");
							}else{
								jsonStr.put("message", "更新失敗");	
								jsonStr.put("status", "99001");
							}
						}
					}else{
						jsonStr.put("message", "資料錯誤");
						jsonStr.put("status", "11204");
					}
				}
			}else{
				jsonStr.put("message", "您無權限使用此程式");	
				jsonStr.put("status", "00008");	
			}
		}else{
			jsonStr.put("message", "傳入之參數不足");	
			jsonStr.put("status", "00004");
		}
		return SUCCESS;
	}
	public CommercialReferenceDto getRequest() {
		return request;
	}
	public void setRequest(CommercialReferenceDto request) {
		this.request = request;
	}
	public JSONObject getJsonStr() {
		return jsonStr;
	}	
}
