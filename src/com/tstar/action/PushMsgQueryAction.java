package com.tstar.action;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.ArrayList;
import java.util.List;

import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.Action;
import com.tstar.service.PushMsgQueryService;
import com.tstar.dto.PushMsgQueryDto;
import com.tstar.dto.QueryPushMsgQueryDto;
import com.tstar.model.tapp.MvPushMessageRecordDetail;
import com.tstar.utility.MD5Encription;
import com.tstar.service.AccountListService;
@Component
@Scope("prototype")
public class PushMsgQueryAction implements Action{
	private final Logger logger = Logger.getLogger(PushMsgQueryAction.class);
	
	@Autowired
	private PushMsgQueryService pushMsgQueryService;
	@Autowired
	private MD5Encription mD5Encription;	
	@Autowired
	private AccountListService accountListService;
	
	private JSONObject jsonStr;
	private PushMsgQueryDto request;	
	private String functionId = "pmq";
	
	public String execute() throws Exception{
		logger.info(" MSISDN: " + request.getMsisdn() + " osType: " + request.getOsType());
		jsonStr = new JSONObject();
		
		if(request != null && StringUtils.isNotBlank(this.request.getTime()) && StringUtils.isNotBlank(this.request.getMsisdn()) && 
		   StringUtils.isNotBlank(this.request.getOsType()) && StringUtils.isNotBlank(this.request.getSystemKey())
		   && StringUtils.isNotBlank(this.request.getSystemId())){
				//systemkey加密
				String password = mD5Encription.encrypt(this.request.getSystemKey());
				this.request.setSystemKey(password);		
				//確認登入狀態
				boolean checkaccount = accountListService.authUser(this.request.getSystemId(), this.request.getSystemKey(), functionId);
				
				if(checkaccount){
					Calendar cal = Calendar.getInstance();
					cal.setTimeInMillis(Long.parseLong(this.request.getTime()));						
					List<MvPushMessageRecordDetail> MessageRecordDetailall = new ArrayList<MvPushMessageRecordDetail>();	
					//抓取Message的所有資料							
					MessageRecordDetailall = pushMsgQueryService.queryMessageRecordDetail(new Timestamp(cal.getTimeInMillis()), this.request.getMsisdn(),this.request.getOsType());	
					//存放回傳的資料
					List<QueryPushMsgQueryDto> MessageRecorAll =new ArrayList<QueryPushMsgQueryDto>();							
						if(MessageRecordDetailall != null){
							//抓取所有Messageid去查詢要回傳的資料
							for(int i=0;i<MessageRecordDetailall.size();i++){
								//撈出來日期轉成timemilliseconds的格式 資料型態String
								String time = Long.toString(MessageRecordDetailall.get(i).getCreateTime().getTime());																		
								//查詢結果有可能多筆所以用addAll
								MessageRecorAll.addAll(pushMsgQueryService.queryPushMessageRecordMain(MessageRecordDetailall.get(i).getMessageid(),this.request.getMsisdn(),time));												
							}
						}						
						jsonStr.put("message", "success");	
						jsonStr.put("status", "00000");
						jsonStr.put("data", MessageRecorAll);
				}else{
					jsonStr.put("message", "您無權限使用此程式");	
					jsonStr.put("status", "11201");						
				}
		}else{
			jsonStr.put("message", "傳入之參數不足");	
			jsonStr.put("status", "00004");
		}
		
		return SUCCESS;
	}
	
	public String deleteMessage() throws Exception{
		logger.info(" MSISDN: " + request.getMsisdn() + " osType: " + request.getOsType() + " messageid: " + request.getMessageid());
		jsonStr = new JSONObject();
		
		if(request != null && StringUtils.isNotBlank(this.request.getMsisdn()) && StringUtils.isNotBlank(this.request.getMessageid()) && 
		   StringUtils.isNotBlank(this.request.getOsType()) && StringUtils.isNotBlank(this.request.getSystemKey())
		   && StringUtils.isNotBlank(this.request.getSystemId())){
				//systemkey加密
				String password = mD5Encription.encrypt(this.request.getSystemKey());
				this.request.setSystemKey(password);		
				//確認登入狀態
				boolean checkaccount = accountListService.authUser(this.request.getSystemId(), this.request.getSystemKey(), functionId);
				
				if(checkaccount){
					boolean rtn = pushMsgQueryService.disablePushMessage(this.request.getOsType(), this.request.getMessageid(), this.request.getMsisdn());	
					if(rtn){
						jsonStr.put("message", "success");	
						jsonStr.put("status", "00000");
					}else{
						jsonStr.put("message", "推播訊息刪除失敗");	
						jsonStr.put("status", "99999");
					}
					
				}else{
					jsonStr.put("message", "您無權限使用此程式");	
					jsonStr.put("status", "11201");						
				}
		}else{
			jsonStr.put("message", "傳入之參數不足");	
			jsonStr.put("status", "00004");
		}
		
		return SUCCESS;
	}
	
	public JSONObject getJsonStr() {
		return jsonStr;
	}
	
	
	public PushMsgQueryDto getRequest() {
		return request;
	}
	
	public void setRequest(PushMsgQueryDto request) {
		this.request = request;
	}
}
