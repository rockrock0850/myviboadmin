package com.tstar.action;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.apache.struts2.ServletActionContext;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.Action;
import com.tstar.utility.PropertiesUtil;

@Component
@Scope("prototype")
public class HealthCheckAction implements Action{
	private final Logger logger = Logger.getLogger(HealthCheckAction.class);
	
	@Autowired
	private PropertiesUtil propertiesUtil;
	
	private JSONObject jsonStr;
	
	@Override
	public String execute() throws JSONException{
		jsonStr = new JSONObject();
		jsonStr.put("status", "00000");
		jsonStr.put("disk_IO", "ok");
		BufferedWriter fw = null;	
		HttpServletRequest request = ServletActionContext.getRequest();
		String ip = request.getRemoteAddr();	
		try{
			File fileorder = new File(propertiesUtil.getProperty("imagepath"));
	        if(!fileorder.exists()){
	        	fileorder.mkdirs();
	        }
	        File file = new File(propertiesUtil.getProperty("imagepath")+ File.separator +"healthcheck.txt");       
			fw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file, true), "UTF-8")); // 指點編碼格式，以免讀取時中文字符異常			
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss.SSS");		
			String nowtime = sdf.format(new Date());					
			fw.append(ip+"  "+nowtime);
			fw.newLine();
			fw.flush(); // 全部寫入緩存中的內容		
			fw.close();					
		} catch (Exception e) {
			jsonStr.put("status", "00001");
			jsonStr.put("disk_IO", e.getMessage());
		} finally {
			//關閉BufferedWriter
			try {
			  if(fw != null){
				fw.close();
			  }
			} catch (Exception e) {
				e.getMessage();
			}
		}			
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss.SSS");
		String nowtime = sdf.format(new Date());
		jsonStr.put("time",nowtime);
		logger.info("jsonStr: " + jsonStr);
		
		return SUCCESS;
	}
	
	public JSONObject getJsonStr() {
		return jsonStr;
	}
}
