package com.tstar.action;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.TimeZone;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.builder.ToStringBuilder;
import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.apache.log4j.Logger;
import org.apache.struts2.ServletActionContext;
import org.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.Action;
import com.tstar.dto.PushMessageUsersDto;
import com.tstar.dto.SendPushMessageDto;
import com.tstar.model.tapp.MvPushMessageUsers;
import com.tstar.service.AccountListService;
import com.tstar.service.PushMessageUserService;
import com.tstar.service.UpdateAppFileUserService;
import com.tstar.utility.MD5Encription;
import com.tstar.utility.PostData;
import com.tstar.utility.PropertiesUtil;

/*
 * APP首頁排版格式
 * 
 */
@Component
@Scope("prototype")
public class SendPushMessageAction implements Action {
	
	private final Logger logger = Logger.getLogger(SendPushMessageAction.class);
	
	@Autowired
	private PropertiesUtil propertiesUtil;
	@Autowired
	private MD5Encription md5Encription;
	@Autowired
	AccountListService accountListService;
	@Autowired
	PushMessageUserService pushMessageUserService;
	@Autowired
	private UpdateAppFileUserService updateAppFileUserService;
	
	
	private String functionId = "pm";	//push message
	private SendPushMessageDto request;
	private JSONObject jsonStr;
	private List<PushMessageUsersDto> pushMessageUsersDtoList;
	
	
//	private String ContractId;	  //合約編號(ContractId)
//	private String DeviceId;	  //Device ID(DeviceId)
	
    public String execute() throws Exception{
    	HttpServletRequest httpServletRequest = ServletActionContext.getRequest();
    	jsonStr = new JSONObject();
    	
    	logger.info("getRemoteAddr: " + httpServletRequest.getRemoteAddr());
    	logger.info("request: " + ToStringBuilder.reflectionToString(request));
    	if(!httpServletRequest.getRemoteAddr().startsWith("172.2") && !httpServletRequest.getRemoteAddr().startsWith("211.21.78") && !httpServletRequest.getRemoteAddr().startsWith("172.1") 
    			&& !httpServletRequest.getRemoteAddr().startsWith("0:0:0:0:0:0") && !httpServletRequest.getRemoteAddr().startsWith("127.0.0.1")){
    		jsonStr.put("status", "11997");
    		jsonStr.put("message", "無權限使用此程式!");
    		logger.info(jsonStr.toString());
    		return SUCCESS;
    	}
    	
    	if(request == null || StringUtils.isBlank(request.getSystemId()) || StringUtils.isBlank(request.getSystemKey()) || StringUtils.isBlank(functionId) 
    			|| StringUtils.isBlank(request.getTitleBody()) || StringUtils.isBlank(request.getMessageBody())){
    		jsonStr.put("status", "00004");
    		jsonStr.put("message", "傳入之參數不足!");
    		logger.info(jsonStr.toString());
    		return SUCCESS;
    	}
    	//加密密碼
    	String systemKey = md5Encription.encrypt(request.getSystemKey());
    	if(!accountListService.authUser(request.getSystemId(), systemKey, functionId, true)){
    		jsonStr.put("status", "00008");
    		jsonStr.put("message", "您無權限使用此程式!");
    		logger.info(jsonStr.toString());
    		return SUCCESS;
    	}
    	
    	//預設一些資料
    	String ServiceId = "mytstar";	//服務名稱(ServiceId)
    	if(StringUtils.isNotBlank(request.getServiceId())){
    		ServiceId = request.getServiceId();
    	}
    	
    	String DeviceTypeA = "A";	//裝置類型Android(DeviceTypeA)
    	String DeviceTypeI = "I";	//裝置類型iOS(DeviceTypeI)
    	/*
    	 * 1=測試門號(不會紀錄至DB)
    	 * 2=測試合約編號(不會紀錄至DB)
    	 * 3=測試Device Id(不會紀錄至DB)
    	 * 4=正式門號
    	 * 5=正式合約編號
    	 * 6=正式Device Id
    	 * 7=該服務全用戶
    	 */
    	String SendType = "4";	//4=正式門號, 發送對象(SendType)
    	String TitleTag = "title";	//通知訊息主旨標籤(TitleTag)
    	String MessageTag = "message";	//通知訊息內容標籤(MessageTag)
    	String ExpiryTag = "exp";	//訊息有效期限標籤(ExpiryTag)
    	
    	//因為效能問題先不使用
    	//確認MSISDN是否存在cache中
//    	if(pushMessageUserService.isUserExist(ServiceId, request.getMSISDN())){
//    	}
    		PostData postData = new PostData();
        	
        	SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        	Calendar cal = Calendar.getInstance();
        	cal.add(Calendar.MONTH, 1);
        	String ExpiryDate = sdf.format(cal.getTime());	//訊息有效期限(ExpiryDate)
        	
        	cal.setTimeZone(TimeZone.getTimeZone("UTC"));
        	String ExpiryDateUTC = Long.toString(cal.getTimeInMillis());	//訊息有效期限UTC格式(ExpiryDateUTC)
        	
        	logger.info("ExpiryDateUTC: " + ExpiryDateUTC);
        	logger.info("TitleBody: " + request.getTitleBody());
        	logger.info("MessageBody: " + request.getMessageBody());
        	logger.info("MSISDN: " + request.getMSISDN());
        	logger.info("SenderId: " + request.getSystemId());
        	logger.info("action: " + request.getAction());
        	
        	ArrayList<NameValuePair> pairList = new ArrayList<NameValuePair>();
    		pairList.add(new BasicNameValuePair("ServiceId", ServiceId));
    		pairList.add(new BasicNameValuePair("DeviceTypeA", DeviceTypeA));
    		pairList.add(new BasicNameValuePair("DeviceTypeI", DeviceTypeI));
    		pairList.add(new BasicNameValuePair("SendType", SendType));
    		pairList.add(new BasicNameValuePair("TitleTag", TitleTag));
    		pairList.add(new BasicNameValuePair("TitleBody", request.getTitleBody()));
    		pairList.add(new BasicNameValuePair("MessageTag", MessageTag));
    		pairList.add(new BasicNameValuePair("MessageBody", request.getMessageBody()));
    		pairList.add(new BasicNameValuePair("ExpiryTag", ExpiryTag));
    		pairList.add(new BasicNameValuePair("ExpiryDate", ExpiryDate));
    		pairList.add(new BasicNameValuePair("ExpiryDateUTC", ExpiryDateUTC));
    		pairList.add(new BasicNameValuePair("SenderId", request.getSystemId()));
    		pairList.add(new BasicNameValuePair("ActionTag", "action"));
    		pairList.add(new BasicNameValuePair("ActionValue", request.getAction()));
    		pairList.add(new BasicNameValuePair("ActionParamTag", "actionParam"));
    		pairList.add(new BasicNameValuePair("ActionParam", request.getActionParam()));
        	
    		String[] strArray = request.getMSISDN().split(",");
    		//預設一次送100筆
    		int maxCount = 100;
    		try{
    			maxCount = Integer.parseInt(propertiesUtil.getProperty("push_msg_maxx_count"));
    		}catch(Exception e){
    			e.printStackTrace();
    		}
    		//大於預設值就要分批送
        	if(strArray.length > maxCount){
        		int i = 0;
        		String msisdn = "";
        		for(String str : strArray){
        			logger.info("loop i: " + i);
        			//串出每次要送的MSISDN
        			if(i >= maxCount) {
        				logger.info("post MSISDN data: " + msisdn);
        				pairList.add(new BasicNameValuePair("MSISDN", msisdn));
        				postData.post(propertiesUtil.getProperty("pushmessage_url"), pairList);
        				i = 0;
        				msisdn = "";
        			}else{
        				if(i == 0){
            				msisdn += str;
            			}else{
            				//串SQL的字串
            				msisdn += ("," + str);
            			}
            			i++;
        			}
        		}
        	}else{
        		pairList.add(new BasicNameValuePair("MSISDN", request.getMSISDN()));
        		postData.post(propertiesUtil.getProperty("pushmessage_url"), pairList);
        	}

    	
    	jsonStr.put("status", "00000");
    	jsonStr.put("message", "success");
    	
		return SUCCESS;
    }
    
    public String queryPushMessageUser(){
		
    	updateAppFileUserService.updateFile();
		
		logger.info("寫檔完成");
		
		jsonStr = new JSONObject();
		jsonStr.put("status", "00000");
    	jsonStr.put("message", "寫檔完成");
		
		
    	return SUCCESS;
    }
    
    public String queryPushMessageUser_bak() throws Exception{
		
    	List<MvPushMessageUsers> pushMessageUsersList = pushMessageUserService.getUserList("mytstar");
    	
    	logger.info("完成資料取得，共: + " + pushMessageUsersList.size());
    	
    	JSONArray jsonArray = new JSONArray();
		
		for(MvPushMessageUsers pushMessageUsers: pushMessageUsersList){
			JSONObject jsonInner = new JSONObject();
			jsonInner.put("MSISDN", pushMessageUsers.getMsisdn());
			jsonInner.put("contractid", pushMessageUsers.getContractid());
			jsonArray.put(jsonInner);
		}
		
		
		String filePath = propertiesUtil.getProperty("temp.file.path") + "/";
		//如果不存在就建一個
        File filetemp = new File(filePath);
        if(!filetemp.exists()) {
        	filetemp.mkdirs();
        }
        
        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");
		Date date = new Date();

		org.json.JSONObject json = new org.json.JSONObject();
		json.put("updatetime", sdf.format(date));
		json.put("appUser", jsonArray);
		
		
		File file = new File(filePath + "appUserFIle.txt");
		
		Writer output = null;
		try {
			output = new BufferedWriter(new FileWriter(file));
			output.write(json.toString());
		}catch(Exception e){
			e.printStackTrace();
    	}finally {
			if(output != null){
				try {
					logger.info("關閉寫檔連線");
					output.close();
				} catch (IOException ex) {
					ex.printStackTrace();
				}
			}
		}
		
		logger.info("寫檔完成");
		
		jsonStr = new JSONObject();
		jsonStr.put("status", "00000");
    	jsonStr.put("message", "寫檔完成");
		
		/*
		HttpServletResponse response = (HttpServletResponse)ActionContext.getContext().get(org.apache.struts2.StrutsStatics.HTTP_RESPONSE);
		response.setContentType("application/octet-stream");
		response.setHeader("Content-Disposition", "attachment;filename=" + fileName);
		
		ServletOutputStream out = null;
		FileInputStream in = null;
		
		try {
			out = response.getOutputStream();
			byte[] outputString = jsonArray.toString().getBytes();
			out.write(outputString, 0, outputString.length);
		} catch (Exception e) {
//			e.printStackTrace();
//			logger.error(e.getMessage());
		}finally{
			try{
				in.close();
			}catch(Exception ex){
				logger.error(ex.getMessage());
			}
			try{
				out.flush();
				out.close();
			}catch(Exception ex){
//				logger.error(ex.getMessage());
			}
		}
        */
		
    	return SUCCESS;
    }

	public JSONObject getJsonStr() {
		return jsonStr;
	}

	public SendPushMessageDto getRequest() {
		return request;
	}

	public void setRequest(SendPushMessageDto request) {
		this.request = request;
	}

	public List<PushMessageUsersDto> getPushMessageUsersDtoList() {
		return pushMessageUsersDtoList;
	}

	public void setPushMessageUsersDtoList(
			List<PushMessageUsersDto> pushMessageUsersDtoList) {
		this.pushMessageUsersDtoList = pushMessageUsersDtoList;
	}
}
