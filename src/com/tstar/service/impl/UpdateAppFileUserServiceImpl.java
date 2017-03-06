package com.tstar.service.impl;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tstar.model.tapp.MvPushMessageUsers;
import com.tstar.service.PushMessageUserService;
import com.tstar.service.UpdateAppFileUserService;
import com.tstar.utility.PropertiesUtil;

/*
 * 
 * 
 */
@Service
public class UpdateAppFileUserServiceImpl implements UpdateAppFileUserService{
	
	private final Logger logger = Logger.getLogger(UpdateAppFileUserServiceImpl.class);
	
	@Autowired
	PushMessageUserService pushMessageUserService;
	
	@Autowired
	private PropertiesUtil propertiesUtil;
	
	
	public void updateFile(){
		try{
			List<MvPushMessageUsers> pushMessageUsersList = pushMessageUserService.getUserList("mytstar");
			
//			JSONArray jsonArray = new JSONArray();
			StringBuffer stringBuffer = new StringBuffer();
			stringBuffer.append("MSISDN,contractid");
			stringBuffer.append(System.getProperty("line.separator"));
			
			for(MvPushMessageUsers pushMessageUsers: pushMessageUsersList){
				stringBuffer.append(pushMessageUsers.getMsisdn() + "," + pushMessageUsers.getContractid());
				stringBuffer.append(System.getProperty("line.separator"));
//				JSONObject jsonInner = new JSONObject();
//				jsonInner.put("MSISDN", pushMessageUsers.getMsisdn());
//				jsonInner.put("contractid", pushMessageUsers.getContractid());
//				jsonArray.put(jsonInner);
			}
			
//			System.out.println(jsonArray.toString());
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
			Date date = new Date();
			
//			JSONObject json = new JSONObject();
//			json.put("updatetime", sdf.format(date));
//			json.put("appUser", jsonArray);
			
//			System.out.println(json.toString());
			
			//開始寫檔
			String filePath = propertiesUtil.getProperty("temp.file.path") + "/";
			//如果不存在就建一個
	        File filetemp = new File(filePath);
	        if(!filetemp.exists()) {
	        	filetemp.mkdirs();
	        }
	        
	        
			File file = new File(filePath + "appUserFile" + sdf.format(date) + ".csv");
			
			Writer output = null;
			try {
				output = new BufferedWriter(new FileWriter(file));
//				output.write(json.toString());
				output.write(stringBuffer.toString());
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
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}
