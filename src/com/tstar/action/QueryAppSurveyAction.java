package com.tstar.action;


import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.Action;
import com.tstar.dto.FormName;
import com.tstar.model.tapp.FormData;
import com.tstar.model.tapp.SystemLookup;
import com.tstar.service.FormDataService;
import com.tstar.service.SelectListService;
import com.tstar.service.SystemLookupService;
import com.tstar.utility.PropertiesUtil;
import com.tstar.model.tapp.SelectList;



@Component
@Scope("prototype")
public class QueryAppSurveyAction implements Action{
	private final Logger logger = Logger.getLogger(QueryAppAction.class);
	private String moblieNumber;//手機門號
	private String key;//查詢的key值
	private String id = "mytstar"; //資料庫查詢用的值
	private String datamesssage = "";
	private String picurl;//圖片位置
	private List<SystemLookup> systemLookupList ;
	private String banner;
	private String title;
	private String title_desc;
	private String formkey;
	private List<String> columnName;
	private List<String> columnValue;
	private List<LinkedHashMap<String,String>> mapList ;
	
	@Autowired
	private SystemLookupService systemLookupService;
	@Autowired
	private SelectListService selectListService;
	@Autowired
	private FormDataService formDataService;
	@Autowired
	private PropertiesUtil propertiesUtil;
	
	public String execute() throws Exception {
		return SUCCESS;
	}
	
	public String queryList(){
		logger.info("moblieNumber : "+moblieNumber);
		if(StringUtils.isNotBlank(key)){
			systemLookupList = systemLookupService.getLikeValueFormAsc(id, "."+key);
			if(systemLookupList.size()<=0){
				this.datamesssage = "無此表單可用";
				return NONE;
			}
			List<FormName> htmDataList = new ArrayList<FormName>();
			for(int i=0;i<systemLookupList.size();i++){
				if(systemLookupList.get(i).getKey().contains("form_banner.")){
					HttpServletRequest request = ServletActionContext.getRequest();
					if(StringUtils.isNotBlank(systemLookupList.get(i).getValue())){
						banner = request.getScheme().toString()+"://"+request.getServerName()+":"+request.getServerPort()+"/"+propertiesUtil.getProperty("imagepath")+"/"+propertiesUtil.getProperty("formimagefolder")+"/"+propertiesUtil.getProperty("formkey")+"/"+systemLookupList.get(i).getValue();
					}	
				}else if(systemLookupList.get(i).getKey().contains("form_title_desc.")){
					title_desc = systemLookupList.get(i).getValue();
				}else if(systemLookupList.get(i).getKey().contains("form_title.")){
					title= systemLookupList.get(i).getValue();
				}else{
					FormName formName= new FormName();
					formName.setKey(systemLookupList.get(i).getKey());
					formName.setValue(systemLookupList.get(i).getValue());				
					htmDataList.add(formName);
				}
			}
			if(htmDataList.size()>0){
				mapList = new ArrayList<LinkedHashMap<String,String>>();
				String checknumber[] = htmDataList.get(0).getKey().split("\\.");
				formkey = checknumber[3];
				LinkedHashMap<String ,String> linked = new LinkedHashMap<String ,String>();
				for(int i=0;i<htmDataList.size();i++){
					String number[] = htmDataList.get(i).getKey().split("\\.");
					if(!checknumber[1].equals(number[1])){
						mapList.add(linked);
						linked = new LinkedHashMap<String ,String>();
						checknumber[1] = number[1];
					}
					if(htmDataList.get(i).getKey().contains("name")){
						linked.put("name", htmDataList.get(i).getValue());
			
					}else if(htmDataList.get(i).getKey().contains("value")){
						linked.put("value", htmDataList.get(i).getValue());
						
					}else if(htmDataList.get(i).getKey().contains("type")){
						linked.put("type", htmDataList.get(i).getValue());
						
					}
					if(i == htmDataList.size()-1){
						mapList.add(linked);
					}
				}					
				for(int i=0;i<mapList.size();i++){
					if(!mapList.get(i).containsKey("name")){
						mapList.get(i).put("name", "columnName"+(i+1));
					}
					if(!mapList.get(i).containsKey("value")){
						mapList.get(i).put("value", "columnValue"+(i+1));
					}
					if(!mapList.get(i).containsKey("type")){
						mapList.get(i).put("type", "空型態"+(i+1));
					}
					if(mapList.get(i).containsKey("name") && mapList.get(i).get("name").equals("門號") && StringUtils.isNotBlank(moblieNumber)){
						mapList.get(i).put("value", moblieNumber);
						mapList.get(i).put("type", "moblieNumber");
					}
					if(mapList.get(i).containsKey("type") && mapList.get(i).get("type").equals("select")){
						List<SelectList> selectList = selectListService.querySelectList(id, "1", mapList.get(i).get("value").toString());
						String selecttext="";
						String selectvalue="";
						for(int k=0;k<selectList.size();k++){		
							selecttext = selecttext + selectList.get(k).getText()+",";
							selectvalue = selectvalue + selectList.get(k).getVal()+",";
						}
						selecttext = StringUtils.substringBeforeLast(selecttext , ",");
						selectvalue = StringUtils.substringBeforeLast(selectvalue , ",");					
						mapList.get(i).put("selecttext", selecttext);
						mapList.get(i).put("selectvalue", selectvalue);
					}
				}
			}
			//未來回傳圖片位置用的url
			HttpServletRequest request = ServletActionContext.getRequest();
			picurl = request.getScheme().toString()+"://"+request.getServerName()+":"+request.getServerPort()+"/"+propertiesUtil.getProperty("imagefolder");
			return SUCCESS;
		}else{
			this.datamesssage = "無此表單可用";
			return NONE;
		}
		
	}
	public String savedata(){
		logger.info("formkey : "+formkey +" columnName : "+columnName+ " columnValue : "+columnValue);
		int random=(int)(Math.random()*900)+100; 
		Calendar cal = Calendar.getInstance();
		String milliseconds = Long.toString(cal.getTimeInMillis()+(long)random);
		String formId = formkey+"_"+milliseconds;
		try{
			for(int i=0;i<columnName.size();i++){
				short seq = (short)(i+1);
				Date date = new Date();
				Timestamp timestamp = new Timestamp(date.getTime());
				random=(int)(Math.random()*900)+100; 
				cal = Calendar.getInstance();
				milliseconds = Long.toString(cal.getTimeInMillis()+(long)random);
				FormData formData = new FormData();
				formData.setId(milliseconds);
				formData.setFormKey(formkey);
				formData.setFormId(formId);
				formData.setColumnName(columnName.get(i));
				formData.setColumnValue(columnValue.get(i));
				formData.setSeq(seq);
				formData.setStatus("1");
				formData.setCreateTime(timestamp);
				formData.setUpdateTime(timestamp);
				formDataService.insertFormData(formData);
			}
			this.datamesssage = "新增成功";
		}catch(Exception e){
			e.printStackTrace();
			this.datamesssage = "新增失敗";
		}
		
		return SUCCESS;
	}
	public String getMoblieNumber() {
		return moblieNumber;
	}

	public void setMoblieNumber(String moblieNumber) {
		this.moblieNumber = moblieNumber;
	}

	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}

	public String getPicurl() {
		return picurl;
	}

	public void setPicurl(String picurl) {
		this.picurl = picurl;
	}

	public List<LinkedHashMap<String, String>> getMapList() {
		return mapList;
	}

	public void setMapList(List<LinkedHashMap<String, String>> mapList) {
		this.mapList = mapList;
	}

	public String getDatamesssage() {
		return datamesssage;
	}

	public void setDatamesssage(String datamesssage) {
		this.datamesssage = datamesssage;
	}

	public String getBanner() {
		return banner;
	}

	public void setBanner(String banner) {
		this.banner = banner;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getTitle_desc() {
		return title_desc;
	}

	public void setTitle_desc(String title_desc) {
		this.title_desc = title_desc;
	}

	public List<String> getColumnName() {
		return columnName;
	}

	public void setColumnName(List<String> columnName) {
		this.columnName = columnName;
	}

	public List<String> getColumnValue() {
		return columnValue;
	}

	public void setColumnValue(List<String> columnValue) {
		this.columnValue = columnValue;
	}

	public String getFormkey() {
		return formkey;
	}

	public void setFormkey(String formkey) {
		this.formkey = formkey;
	}
}
