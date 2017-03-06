package com.tstar.action;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.Action;
import com.tstar.model.tapp.SelectList;
import com.tstar.model.tapp.SystemLookup;
import com.tstar.service.SelectListService;
import com.tstar.service.SystemLookupService;
import com.tstar.utility.PropertiesUtil;

@Component
@Scope("prototype")
public class SurveyFormDataAction implements Action{
	
	private final Logger logger = Logger.getLogger(SurveyFormDataAction.class);
	private List<SelectList> groupList;
	private String form_img;
	private String form_key;
	private String form_title;
	private String form_text;
	private String form_img_path;
	private String searchKey;
	private String searchTitle;
	private String status;
	private String createtimestart;
	private String createtimeend;
	private List<SystemLookup> alldata;
	private String message;
	private String dataKey;
	private String dataStatus;
	private String changeKey;
	private String id = "mytstar"; //資料庫查詢用的值
	private List<String> formName;
	private List<String> formType;
	private List<String> formValue;
	private List<String> formValueSelect;
	private File formimage;//上傳檔案	
	private String formimageFileName;//上傳檔案名稱
	private String formimageContentType;//上傳文件型態
	private String formimagePath;  //文件路径    
	
	
	@Autowired
	private SelectListService selectListService;
	
	@Autowired
	private SystemLookupService systemLookupService;
	
	@Autowired
	private PropertiesUtil propertiesUtil;
	
	@Override
	public String execute() throws Exception {
		groupList = selectListService.getGroupList();
		logger.info(" groupList : "+groupList);
		return SUCCESS;
	}
	
	public String condition() throws Exception{	
		logger.info(" do query systemlookup");
		return SUCCESS;
	}
	
	public String queryList() {
		logger.info(" searchKey : "+searchKey +" searchTitle : "+searchTitle+" status: "+status +" createtimestart: "+ createtimestart+" createtimeend: "+createtimeend);
		Timestamp timestampstart =null;
		Timestamp timestampend =null;
		if(StringUtils.isNotBlank(createtimestart) && StringUtils.isNotBlank(createtimeend)){
			createtimestart = createtimestart.replace("/", "-");//日期格式轉換把/轉成-
			timestampstart = Timestamp.valueOf(createtimestart);//轉換timestamp格式
			createtimeend = createtimeend.replace("/", "-");
			timestampend = Timestamp.valueOf(createtimeend);
		}
		if(StringUtils.isNotBlank(status)){
			if(status.equals("all")){
				status = "";
			}
		}
		alldata = systemLookupService.queryFromdata(searchKey, searchTitle, status, timestampstart, timestampend);
		if(alldata.size()==0){
			message = "查無資料";
		}
		return SUCCESS;
	}
	public String changestatus() {
		logger.info("changestatus "+" dataKey : "+dataKey +" dataStatus : "+dataStatus);
		Timestamp timestampstart =null;
		Timestamp timestampend =null;
		if(StringUtils.isNotBlank(createtimestart) && StringUtils.isNotBlank(createtimeend)){
			createtimestart = createtimestart.replace("/", "-");//日期格式轉換把/轉成-
			timestampstart = Timestamp.valueOf(createtimestart);//轉換timestamp格式
			createtimeend = createtimeend.replace("/", "-");
			timestampend = Timestamp.valueOf(createtimeend);
		}
		String changekey[] = dataKey.split("\\.");
		boolean dbStatus = systemLookupService.changestatus(changekey[1], dataStatus);
		if(dbStatus){
			message = "狀態變更成功";
		}else{
			message = "狀態變更失敗";
		}
		alldata = systemLookupService.queryFromdata(searchKey, searchTitle, status, timestampstart, timestampend);
		
		return SUCCESS;
	}
	public String insertFormdata() {
		logger.info(" searchKey : "+searchKey +" form_title : "+form_title+" form_text: "+form_text +" formName: "+ formName+" formType: "+formType+"formValue: "+formValue+"formValueSelect: "+formValueSelect);
		List<SystemLookup> systemLookupList = new ArrayList<SystemLookup>();
		systemLookupList = systemLookupService.checkLikeValueFormAsc(id, "."+form_key);
		if(systemLookupList.size()>0){
			message = "form_key已被使用";
		}else{
			try{
				insertdata(form_img,"form_banner."+form_key);
				insertdata(form_title,"form_title."+form_key);
				insertdata(form_text,"form_title_desc."+form_key);
				for(int i=0;i<formName.size();i++){
					insertdata(formName.get(i),"form_column.["+String.valueOf(i+1)+"].name."+form_key);
					insertdata(formType.get(i),"form_column.["+String.valueOf(i+1)+"].type."+form_key);
					if(formType.get(i).equals("text")){
						insertdata(formValue.get(i),"form_column.["+String.valueOf(i+1)+"].value."+form_key);
					}else{
						insertdata(formValueSelect.get(i),"form_column.["+String.valueOf(i+1)+"].value."+form_key);
					}
				}
				message = "資料新增成功";
			}catch(Exception e){
				e.printStackTrace();
				message = "資料新增失敗";
			}
		}	
		return SUCCESS;
	}
	public String preupdate() {
		logger.info("pre update data");
		groupList = selectListService.getGroupList();
		List<SystemLookup> systemLookupList = new ArrayList<SystemLookup>();
		HttpServletRequest request = ServletActionContext.getRequest();
		systemLookupList = systemLookupService.getPreUpdate(id, "."+changeKey);
		if(systemLookupList.size()>0){
			formName = new ArrayList<String>();
			formType = new ArrayList<String>();
			formValue = new ArrayList<String>();
			for(int i=0;i<systemLookupList.size();i++){
				if(systemLookupList.get(i).getKey().contains("form_banner.")){
					form_img = systemLookupList.get(i).getValue();
					if(StringUtils.isNotBlank(systemLookupList.get(i).getValue())){
						form_img_path = request.getScheme().toString()+"://"+request.getServerName()+":"+request.getServerPort()+"/"+propertiesUtil.getProperty("imagepath")+"/"+propertiesUtil.getProperty("formimagefolder")+"/"+propertiesUtil.getProperty("formkey")+"/"+systemLookupList.get(i).getValue();
					}		
				}else if(systemLookupList.get(i).getKey().contains("form_title.")){
					form_title= systemLookupList.get(i).getValue();
				}else if(systemLookupList.get(i).getKey().contains("form_title_desc.")){
					form_text = systemLookupList.get(i).getValue();
				}else if(systemLookupList.get(i).getKey().contains("name")){
					formName.add(systemLookupList.get(i).getValue());
				}else if(systemLookupList.get(i).getKey().contains("type")){
					formType.add(systemLookupList.get(i).getValue());
				}else if(systemLookupList.get(i).getKey().contains("value")){
					formValue.add(systemLookupList.get(i).getValue());
				}
			}	
		}
		
		return SUCCESS;
	}
	public String update(){
		logger.info("do update");
		List<SystemLookup> systemLookupList = new ArrayList<SystemLookup>();
		systemLookupList = systemLookupService.getPreUpdate(id, "."+form_key);
		HashMap<String,String> map = new HashMap<String,String>();
		for(int i =0;i<systemLookupList.size();i++){
			map.put(systemLookupList.get(i).getKey(), systemLookupList.get(i).getValue());				
		}
		
		try{
			if(map.containsKey("form_banner."+form_key)){
				if(map.get("form_banner."+form_key) !=null){
					if(!map.get("form_banner."+form_key).equals(form_img)){
						updatedata(form_img,"form_banner."+form_key);
					}
				}else{
					if(form_img !=null){
						updatedata(form_img,"form_banner."+form_key);
					}
				}
				
			}
			
			if(map.containsKey("form_title."+form_key)){
				if(!map.get("form_title."+form_key).equals(form_title)){
					updatedata(form_title,"form_title."+form_key);
				}
			}
			if(map.containsKey("form_title_desc."+form_key)){
				if(!map.get("form_title_desc."+form_key).equals(form_text)){
					updatedata(form_text,"form_title_desc."+form_key);
				}
			}
			
			for(int i=0;i<formName.size();i++){
				if(map.containsKey("form_column.["+String.valueOf(i+1)+"].name."+form_key)){
					if(!map.get("form_column.["+String.valueOf(i+1)+"].name."+form_key).equals(formName.get(i))){
						updatedata(formName.get(i),"form_column.["+String.valueOf(i+1)+"].name."+form_key);
					}
				}
				if(map.containsKey("form_column.["+String.valueOf(i+1)+"].type."+form_key)){
					if(!map.get("form_column.["+String.valueOf(i+1)+"].type."+form_key).equals(formType.get(i))){
						updatedata(formType.get(i),"form_column.["+String.valueOf(i+1)+"].type."+form_key);
					}
				}
				if(formType.get(i).equals("text")){
					if(map.containsKey("form_column.["+String.valueOf(i+1)+"].value."+form_key)){
						if(map.get("form_column.["+String.valueOf(i+1)+"].value."+form_key) !=null){
							if(!map.get("form_column.["+String.valueOf(i+1)+"].value."+form_key).equals(formValue.get(i))){
								updatedata(formValue.get(i),"form_column.["+String.valueOf(i+1)+"].value."+form_key);
							}
						}else{
							if(formValue.get(i) !=null){
								updatedata(formValue.get(i),"form_column.["+String.valueOf(i+1)+"].value."+form_key);
							}
						}	
					}
				}else{
					if(map.containsKey("form_column.["+String.valueOf(i+1)+"].value."+form_key)){
						if(map.get("form_column.["+String.valueOf(i+1)+"].value."+form_key) !=null){
							if(!map.get("form_column.["+String.valueOf(i+1)+"].value."+form_key).equals(formValueSelect.get(i))){
								updatedata(formValueSelect.get(i),"form_column.["+String.valueOf(i+1)+"].value."+form_key);
							}
						}
			
					}
				}
			}
			message = "資料更新成功";
		}catch(Exception e){
			e.printStackTrace();
			message = "資料更新失敗";
		}
		return SUCCESS;
	}
	public String fileUpload() { 
	    if(formimage != null){			
			SimpleDateFormat sdFormat = new SimpleDateFormat("yyyyMMdd");					
			Date current = new Date();
			//資料夾名稱
			String filefolder = propertiesUtil.getProperty("formkey");	
			FileOutputStream fos = null;
		    FileInputStream fis = null;	        
		    //本機測試建立資料夾
		    //File file = new File("C:\\"+filefolder);		        
		    //線上建立資料夾
		    String path = propertiesUtil.getProperty("imagepath")+"/"+propertiesUtil.getProperty("formimagefolder")+"/"+filefolder;
		    File file = new File(path);
			if(!file.exists()){
			   file.mkdirs();
			}
		    logger.info("filelocation:"+path);
		    HttpServletRequest request = ServletActionContext.getRequest();
		    //回傳圖片url
		    String requestUrl = request.getScheme().toString()+"://"+request.getServerName()+":"+request.getServerPort()+"/"+propertiesUtil.getProperty("imagepath")+"/"+propertiesUtil.getProperty("formimagefolder")+"/"+filefolder+"/";	        
	        //抓取後面檔案類型名稱
	        String type[] = this.formimageFileName.split("\\.");		        	
	        sdFormat = new SimpleDateFormat("yyyyMMddHHmmss");
	        //產生的亂數
	        int random=(int)(Math.random()*900)+100;
	        //檔案名稱
	        String filename = sdFormat.format(current)+Integer.toString(random);	        	
	        this.formimageFileName = filename;
	        logger.info("filemake:"+"start");
		try {
			//本機測試
			//fos = new FileOutputStream("C:\\"+filefolder+"\\"+filename+"."+type[1]);
			// 線上寫法
			fos = new FileOutputStream(path+ "/" + filename + "." + type[1]);
			this.formimagePath = requestUrl + filename + "." + type[1];
			fis = new FileInputStream(getFormimage());
			byte[] buffer = new byte[1024];
			int len = 0;
			while((len = fis.read(buffer)) > 0){
				fos.write(buffer, 0, len);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			try{
				fis.close();
				fos.close();
			}catch (IOException e) {
				e.printStackTrace();
			}
		}  		            		                
		logger.info("filemake:"+"end");           
        } 
	    return SUCCESS;  
	}
	
	private String insertdata(String datavalue ,String key){	
		boolean status;
		Date date = new Date();
		int random=(int)(Math.random()*900)+100; 
		Calendar cal = Calendar.getInstance();
		String milliseconds = Long.toString(cal.getTimeInMillis()+(long)random);
		SystemLookup systemLookup = new SystemLookup();
		systemLookup.setId(milliseconds);
		systemLookup.setServiceId(this.id);
		systemLookup.setKey(key);							
		systemLookup.setValue(datavalue);
		systemLookup.setStatus("1");
		systemLookup.setCreateTime(new Timestamp(date.getTime()));
		systemLookup.setUpdateTime(new Timestamp(date.getTime()));
		status = systemLookupService.insertSystemLookup(systemLookup);
		if(status){
			return "ok";
		}else{
			return "fail";
		}
		
	}
	
	private String updatedata(String datavalue ,String key){
		boolean status;	
		Date date = new Date();
		SystemLookup systemLookup = new SystemLookup();
		systemLookup.setServiceId(this.id);
		systemLookup.setKey(key);
		systemLookup.setUpdateTime(new Timestamp(date.getTime()));						
		systemLookup.setValue(datavalue);						
		status = systemLookupService.updateSystemLookup(systemLookup);
		if(status){
			return "ok";
		}else{
			return "fail";
		}
								
	}
	public List<SelectList> getGroupList() {
		return groupList;
	}

	public void setGroupList(List<SelectList> groupList) {
		this.groupList = groupList;
	}

	public String getForm_img() {
		return form_img;
	}

	public void setForm_img(String form_img) {
		this.form_img = form_img;
	}

	public String getForm_key() {
		return form_key;
	}

	public void setForm_key(String form_key) {
		this.form_key = form_key;
	}

	public String getForm_title() {
		return form_title;
	}

	public void setForm_title(String form_title) {
		this.form_title = form_title;
	}

	public String getForm_text() {
		return form_text;
	}

	public void setForm_text(String form_text) {
		this.form_text = form_text;
	}
		
	public String getForm_img_path() {
		return form_img_path;
	}

	public void setForm_img_path(String form_img_path) {
		this.form_img_path = form_img_path;
	}

	public String getSearchKey() {
		return searchKey;
	}

	public void setSearchKey(String searchKey) {
		this.searchKey = searchKey;
	}

	public String getSearchTitle() {
		return searchTitle;
	}

	public void setSearchTitle(String searchTitle) {
		this.searchTitle = searchTitle;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	public String getChangeKey() {
		return changeKey;
	}

	public void setChangeKey(String changeKey) {
		this.changeKey = changeKey;
	}

	public String getCreatetimestart() {
		return createtimestart;
	}

	public void setCreatetimestart(String createtimestart) {
		this.createtimestart = createtimestart;
	}

	public String getCreatetimeend() {
		return createtimeend;
	}

	public void setCreatetimeend(String createtimeend) {
		this.createtimeend = createtimeend;
	}
	
	public List<SystemLookup> getAlldata() {
		return alldata;
	}

	public void setAlldata(List<SystemLookup> alldata) {
		this.alldata = alldata;
	}
	
	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}
	
	public String getDataKey() {
		return dataKey;
	}

	public void setDataKey(String dataKey) {
		this.dataKey = dataKey;
	}

	public String getDataStatus() {
		return dataStatus;
	}

	public void setDataStatus(String dataStatus) {
		this.dataStatus = dataStatus;
	}

	public List<String> getFormName() {
		return formName;
	}

	public void setFormName(List<String> formName) {
		this.formName = formName;
	}

	public List<String> getFormType() {
		return formType;
	}

	public void setFormType(List<String> formType) {
		this.formType = formType;
	}

	public List<String> getFormValue() {
		return formValue;
	}

	public void setFormValue(List<String> formValue) {
		this.formValue = formValue;
	}

	public List<String> getFormValueSelect() {
		return formValueSelect;
	}

	public void setFormValueSelect(List<String> formValueSelect) {
		this.formValueSelect = formValueSelect;
	}

	public File getFormimage() {
		return formimage;
	}

	public void setFormimage(File formimage) {
		this.formimage = formimage;
	}

	public String getFormimageFileName() {
		return formimageFileName;
	}

	public void setFormimageFileName(String formimageFileName) {
		this.formimageFileName = formimageFileName;
	}

	public String getFormimageContentType() {
		return formimageContentType;
	}

	public void setFormimageContentType(String formimageContentType) {
		this.formimageContentType = formimageContentType;
	}

	public String getFormimagePath() {
		return formimagePath;
	}

	public void setFormimagePath(String formimagePath) {
		this.formimagePath = formimagePath;
	}
}
