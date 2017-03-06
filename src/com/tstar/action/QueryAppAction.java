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
import com.tstar.dto.AppInfo;
import com.tstar.model.tapp.SystemLookup;
import com.tstar.service.SystemLookupService;
import com.tstar.utility.PropertiesUtil;

@Component
@Scope("prototype")
public class QueryAppAction implements Action{
	
	private final Logger logger = Logger.getLogger(QueryAppAction.class);
	
	@Autowired
	private PropertiesUtil propertiesUtil;
	
	private File appUpimage;//上傳檔案
	private String appUpimageFileName;//上傳檔案名稱
	private String appUpimageContentType;//上傳文件型態
	private String appUpimagePath;  //文件路径
	private String osType;	//查詢輸入的作業系統
	private String id = "mytstar"; //資料庫查詢用的值
	private List<SystemLookup> systemLookupList ;	
	private HashMap map ;	
	private String copy;   //檢查是否兩者套用
	private String banner1;
	private String url1;
	private String banner2;
	private String url2;
	private String banner3;
	private String url3;	
	private String banner4;
	private String url4;	
	private String url7;	
	private String banner8;	
	private String url8;	
	private String banner9;	
	private String url9;
	private String url10;
	private String url11;
	private String url12;
	private String mktUrl;
	private String msg;
	private String mktId;
	private String mktmsg;
	
	@Autowired
	private SystemLookupService systemLookupService;
	
	public String execute() throws Exception {		
		List<SystemLookup> systemLookup = systemLookupService.getSystemLookup(id, "app_mkt_store_kpi_url");
		if(systemLookup != null && systemLookup.size() == 1){
			mktUrl = systemLookup.get(0).getValue();
			mktId = systemLookup.get(0).getId();
		}else if(systemLookup.size()==0){
			mktUrl = "";
			mktId = "";
		}else{
			mktmsg = "推廣畫面url異常請聯絡管理人員";
		}
    	return SUCCESS;
	}
	
	public String queryList(){
		map = new HashMap();
		if(null != osType){			
			systemLookupList = systemLookupService.getLikeValue(id, "app_home_");  
			for(int i=0;i<systemLookupList.size();i++){				
				map.put(systemLookupList.get(i).getKey(),systemLookupList.get(i).getValue());					
			}								
		}		
		return SUCCESS;		
	}
	
	public String SaveMktUrl(){
		if(mktId.isEmpty()){
			int random=(int)(Math.random()*900)+100; 
			Calendar cal = Calendar.getInstance();
			String milliseconds = Long.toString(cal.getTimeInMillis()+(long)random);
			boolean status;
			Date date = new Date();
			SystemLookup systemLookup = new SystemLookup();
			systemLookup.setId(milliseconds);
			systemLookup.setServiceId(id);
			systemLookup.setKey("app_mkt_store_kpi_url");
			systemLookup.setValue(mktUrl);			
			systemLookup.setStatus("1");
			systemLookup.setCreateTime(new Timestamp(date.getTime()));
			systemLookup.setUpdateTime(new Timestamp(date.getTime()));
			status = systemLookupService.insertSystemLookup(systemLookup);
			if(status){
				msg = "推廣畫面url新增成功!!";
			}else{
				msg = "新增失敗";
			}
			mktId = milliseconds;//回傳id給前端頁面
		}else{
			boolean status;
			Date date = new Date();
			SystemLookup systemLookup = new SystemLookup();
			systemLookup.setServiceId(id);
			systemLookup.setKey("app_mkt_store_kpi_url");
			systemLookup.setValue(mktUrl);
			systemLookup.setUpdateTime(new Timestamp(date.getTime()));
			status = systemLookupService.updateSystemLookup(systemLookup);
			if(status){
				msg = "推廣畫面url修改成功!!";
			}else{
				msg = "修改失敗";
			}
		}
		return SUCCESS;		
	}
	
	public String update(){
		logger.info("Make changedata");
		List<SystemLookup> systemLookup = systemLookupService.getSystemLookup(id, "app_mkt_store_kpi_url");
		if(systemLookup != null && systemLookup.size() == 1){
			mktUrl = systemLookup.get(0).getValue();
			mktId = systemLookup.get(0).getId();
		}else if(systemLookup.size()==0){
			mktUrl = "";
			mktId = "";
		}else{
			mktmsg = "推廣畫面url異常請聯絡管理人員";
		}
		//撈取全部app_home_的資料 可以檢查資料是否有異動
		HashMap<String ,String> checkmap = new HashMap();						
		systemLookupList = systemLookupService.getLikeValue(id, "app_home_");  		
		for(int i=0;i<systemLookupList.size();i++){	
		    checkmap.put(systemLookupList.get(i).getKey(),systemLookupList.get(i).getValue());				
		}											
		//沒有兩版共用 所放的資料空間
		List<AppInfo> appinfo = new ArrayList<AppInfo>();
		HttpServletRequest request = ServletActionContext.getRequest();
		String requestUrl = request.getScheme().toString()+"://"+request.getServerName()+":"+request.getServerPort();	
		AppInfo urldata = new AppInfo();
		appinfo = changedata(appinfo, checkmap, "app_home_"+this.osType+"_title_banner.[1].pic", this.banner1.replace(requestUrl,""), "找手機圖片");
		appinfo = changedata(appinfo, checkmap, "app_home_"+this.osType+"_title_banner.[1].url", this.url1, "找手機url");
		appinfo = changedata(appinfo, checkmap, "app_home_"+this.osType+"_title_banner.[2].pic", this.banner2.replace(requestUrl, ""), "找資費圖片");
		appinfo = changedata(appinfo, checkmap, "app_home_"+this.osType+"_title_banner.[2].url", this.url2, "找資費url");
		appinfo = changedata(appinfo, checkmap, "app_home_"+this.osType+"_title_banner.[3].pic", this.banner3.replace(requestUrl, ""), "懶人包圖片");
		appinfo = changedata(appinfo, checkmap, "app_home_"+this.osType+"_title_banner.[3].url", this.url3, "懶人包url");
		appinfo = changedata(appinfo, checkmap, "app_home_"+this.osType+"_title_banner.[4].pic", this.banner4.replace(requestUrl, ""), "粉絲團圖片");
		appinfo = changedata(appinfo, checkmap, "app_home_"+this.osType+"_title_banner.[4].url", this.url4, "粉絲團url");
		appinfo = changedata(appinfo, checkmap, "app_home_"+this.osType+"_promote_banner.more_url", this.url7, "找優惠_more");
		appinfo = changedata(appinfo, checkmap, "app_home_"+this.osType+"_promote_banner.promote_data.[1].pic", this.banner8.replace(requestUrl, ""), "找優惠圖片一");
		appinfo = changedata(appinfo, checkmap, "app_home_"+this.osType+"_promote_banner.promote_data.[1].url", this.url8, "找優惠圖片一url");
		appinfo = changedata(appinfo, checkmap, "app_home_"+this.osType+"_promote_banner.promote_data.[2].pic", this.banner9.replace(requestUrl, ""), "找優惠圖片二");
		appinfo = changedata(appinfo, checkmap, "app_home_"+this.osType+"_promote_banner.promote_data.[2].url", this.url9, "找優惠圖片二url");
		appinfo = changedata(appinfo, checkmap, "app_home_"+this.osType+"_video.more_url", this.url10, "影音專區_more");
		appinfo = changedata(appinfo, checkmap, "app_home_"+this.osType+"_video.youtube_url", this.url11, "影音專區");
		appinfo = changedata(appinfo, checkmap, "app_home_"+this.osType+"_news.more_url", this.url12, "最新消息_more");			
		//狀態判定更新成功失敗 或者沒有異動資料			
		String dataStatus ="";
		String checkStatus = "";
		for(int i = 0 ;i<appinfo.size();i++){				
			if(appinfo.get(i).getValue() !=null && StringUtils.isNotBlank(appinfo.get(i).getValue())){						
				try{ 
					dataStatus = appinfo.get(i).getStatus();
					if(dataStatus.equals("insert")){
						checkStatus = insertdata(appinfo.get(i).getValue(), appinfo.get(i).getKey());
						if(checkStatus.equals("ok")){
							request.getSession().setAttribute("msg"+Integer.toString(i), appinfo.get(i).getMessage()+"更新成功!!");
						}else{
							request.getSession().setAttribute("msg"+Integer.toString(i), appinfo.get(i).getMessage()+"更新失敗!!");
						}
					  }	
					if(dataStatus.equals("update")){
						checkStatus = updatedata(appinfo.get(i).getValue(), appinfo.get(i).getKey());
						if(checkStatus.equals("ok")){
							request.getSession().setAttribute("msg"+Integer.toString(i), appinfo.get(i).getMessage()+"更新成功!!");
						}else{
							request.getSession().setAttribute("msg"+Integer.toString(i), appinfo.get(i).getMessage()+"更新失敗!!");
						}
					} 
				}catch(Exception e){
					e.printStackTrace();
					request.getSession().setAttribute("msg"+Integer.toString(i), appinfo.get(i).getMessage()+"新增失敗!!");
				}	
			}				
		}
		//若有勾選兩版共用則會執行下面程式
		if(this.copy !=null){
			//兩版共用的變數
			String type ="";			
			if(this.osType.equals("and")){
				type = "ios";				
			}else{
				type = "and";				
			}
			//兩版共用的List
			List<AppInfo> bothappinfo = new ArrayList<AppInfo>();
			bothappinfo = changedata(bothappinfo, checkmap, "app_home_"+type+"_title_banner.[1].pic", this.banner1.replace(requestUrl,""), "找手機圖片");
			bothappinfo = changedata(bothappinfo, checkmap, "app_home_"+type+"_title_banner.[1].url", this.url1, "找手機url");
			bothappinfo = changedata(bothappinfo, checkmap, "app_home_"+type+"_title_banner.[2].pic", this.banner2.replace(requestUrl, ""), "找資費圖片");
			bothappinfo = changedata(bothappinfo, checkmap, "app_home_"+type+"_title_banner.[2].url", this.url2, "找資費url");
			bothappinfo = changedata(bothappinfo, checkmap, "app_home_"+type+"_title_banner.[3].pic", this.banner3.replace(requestUrl, ""), "懶人包圖片");
			bothappinfo = changedata(bothappinfo, checkmap, "app_home_"+type+"_title_banner.[3].url", this.url3, "懶人包url");
			bothappinfo = changedata(bothappinfo, checkmap, "app_home_"+type+"_title_banner.[4].pic", this.banner4.replace(requestUrl, ""), "粉絲團圖片");
			bothappinfo = changedata(bothappinfo, checkmap, "app_home_"+type+"_title_banner.[4].url", this.url4, "粉絲團url");
			bothappinfo = changedata(bothappinfo, checkmap, "app_home_"+type+"_promote_banner.more_url", this.url7, "找優惠_more");
			bothappinfo = changedata(bothappinfo, checkmap, "app_home_"+type+"_promote_banner.promote_data.[1].pic", this.banner8.replace(requestUrl, ""), "找優惠圖片一");
			bothappinfo = changedata(bothappinfo, checkmap, "app_home_"+type+"_promote_banner.promote_data.[1].url", this.url8, "找優惠圖片一url");
			bothappinfo = changedata(bothappinfo, checkmap, "app_home_"+type+"_promote_banner.promote_data.[2].pic", this.banner9.replace(requestUrl, ""), "找優惠圖片二");
			bothappinfo = changedata(bothappinfo, checkmap, "app_home_"+type+"_promote_banner.promote_data.[2].url", this.url9, "找優惠圖片二url");
			bothappinfo = changedata(bothappinfo, checkmap, "app_home_"+type+"_video.more_url", this.url10, "影音專區_more");
			bothappinfo = changedata(bothappinfo, checkmap, "app_home_"+type+"_video.youtube_url", this.url11, "影音專區");
			bothappinfo = changedata(bothappinfo, checkmap, "app_home_"+type+"_news.more_url", this.url12, "最新消息_more");	
			for(int i = 0 ;i<bothappinfo.size();i++){				
				if(bothappinfo.get(i).getValue() !=null && StringUtils.isNotBlank(bothappinfo.get(i).getValue())){						
					try{ 
						dataStatus = bothappinfo.get(i).getStatus();
						if(dataStatus.equals("insert")){
							checkStatus = insertdata(bothappinfo.get(i).getValue(), bothappinfo.get(i).getKey());
							if(checkStatus.equals("ok")){
								request.getSession().setAttribute("msg"+Integer.toString(i), bothappinfo.get(i).getMessage()+"更新成功!!");
							}else{
								request.getSession().setAttribute("msg"+Integer.toString(i), bothappinfo.get(i).getMessage()+"更新失敗!!");
							}
						}	
						if(dataStatus.equals("update")){
							checkStatus = updatedata(bothappinfo.get(i).getValue(), bothappinfo.get(i).getKey());
							if(checkStatus.equals("ok")){
								request.getSession().setAttribute("msg"+Integer.toString(i), bothappinfo.get(i).getMessage()+"更新成功!!");
							}else{
								request.getSession().setAttribute("msg"+Integer.toString(i), bothappinfo.get(i).getMessage()+"更新失敗!!");
							}
						} 
					}catch(Exception e){
						e.printStackTrace();
						request.getSession().setAttribute("msg"+Integer.toString(i), bothappinfo.get(i).getMessage()+"新增失敗!!");
					}	
				}	
			}	
		}
				
		return SUCCESS;
	}
	
	public String fileUpload() { 
		    if(appUpimage != null){			
				SimpleDateFormat sdFormat = new SimpleDateFormat("yyyyMMdd");					
				Date current = new Date();
				//資料夾名稱
				String filefolder = sdFormat.format(current);	
				FileOutputStream fos = null;
			    FileInputStream fis = null;	        
			    //本機測試建立資料夾
			    //File file = new File("C:\\"+filefolder);		        
			    //線上建立資料夾
			    File file = new File(propertiesUtil.getProperty("imagepath")+"/"+filefolder);
				if(!file.exists()){
				   file.mkdirs();
				}
			    logger.info("filelocation:"+propertiesUtil.getProperty("imagepath")+"/"+filefolder);
			    HttpServletRequest request = ServletActionContext.getRequest();
			    //回傳圖片url
			    String requestUrl = request.getScheme().toString()+"://"+request.getServerName()+":"+request.getServerPort()+"/"+propertiesUtil.getProperty("imagefolder")+"/"+filefolder+"/";	        
		        //抓取後面檔案類型名稱
		        String type[] = this.appUpimageFileName.split("\\.");		        	
		        sdFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		        //產生的亂數
		        int random=(int)(Math.random()*900)+100;
		        //檔案名稱
		        String filename = sdFormat.format(current)+Integer.toString(random);	        	
		        this.appUpimageFileName = filename+getAppUpimageFileName();
		        logger.info("filemake:"+"start");
			try {
				// 本機測試
				// fos = new
				// FileOutputStream("C:\\"+filefolder+"\\"+filename+"."+
				// type[1]);
				// 線上寫法
				fos = new FileOutputStream(propertiesUtil.getProperty("imagepath") + "/"
											+ filefolder + "/" + filename + "." + type[1]);
				this.appUpimagePath = requestUrl + filename + "." + type[1];
				fis = new FileInputStream(getAppUpimage());
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
	
	private List<AppInfo> changedata(List<AppInfo> appinfo,HashMap<String ,String> checkmap,String key,String value,String msg){
		AppInfo urldata = new AppInfo();
		urldata.setKey(key);
		urldata.setValue(value);
		urldata.setMessage(msg);
		if(checkmap !=null && checkmap.containsKey(key)){
		   //執行更新會去判斷是否需要	
		   if(!checkmap.get(key).equals(value)){
			   urldata.setStatus("update");	
			   appinfo.add(urldata);	
		   }		
		}else{
			//執行新增	
		   urldata.setStatus("insert");	
		   appinfo.add(urldata);
		} 	
		return appinfo;
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
	public String getCopy() {
		return copy;
	}

	public void setCopy(String copy) {
		this.copy = copy;
	}

	public String getOsType() {
		return osType;
	}

	public void setOsType(String osType) {
		this.osType = osType;
	}

	public List<SystemLookup> getSystemLookupList() {
		return systemLookupList;
	}

	public void setSystemLookupList(List<SystemLookup> systemLookupList) {
		this.systemLookupList = systemLookupList;
	}

	public HashMap getMap() {
		return map;
	}

	public void setMap(HashMap map) {
		this.map = map;
	}

	public String getBanner1() {
		return banner1;
	}

	public void setBanner1(String banner1) {
		this.banner1 = banner1;
	}

	public String getUrl1() {
		return url1;
	}

	public void setUrl1(String url1) {
		this.url1 = url1;
	}

	public String getBanner2() {
		return banner2;
	}

	public void setBanner2(String banner2) {
		this.banner2 = banner2;
	}

	public String getUrl2() {
		return url2;
	}

	public void setUrl2(String url2) {
		this.url2 = url2;
	}

	public String getBanner3() {
		return banner3;
	}

	public void setBanner3(String banner3) {
		this.banner3 = banner3;
	}

	public String getUrl3() {
		return url3;
	}

	public void setUrl3(String url3) {
		this.url3 = url3;
	}

	public String getBanner4() {
		return banner4;
	}

	public void setBanner4(String banner4) {
		this.banner4 = banner4;
	}

	public String getUrl4() {
		return url4;
	}

	public void setUrl4(String url4) {
		this.url4 = url4;
	}
	
	public String getUrl7() {
		return url7;
	}

	public void setUrl7(String url7) {
		this.url7 = url7;
	}

	public String getBanner8() {
		return banner8;
	}

	public void setBanner8(String banner8) {
		this.banner8 = banner8;
	}

	public String getUrl8() {
		return url8;
	}

	public void setUrl8(String url8) {
		this.url8 = url8;
	}

	public String getBanner9() {
		return banner9;
	}

	public void setBanner9(String banner9) {
		this.banner9 = banner9;
	}

	public String getUrl9() {
		return url9;
	}

	public void setUrl9(String url9) {
		this.url9 = url9;
	}

	public String getUrl10() {
		return url10;
	}

	public void setUrl10(String url10) {
		this.url10 = url10;
	}

	public String getUrl11() {
		return url11;
	}

	public void setUrl11(String url11) {
		this.url11 = url11;
	}

	public String getUrl12() {
		return url12;
	}

	public void setUrl12(String url12) {
		this.url12 = url12;
	}
	
	public String getAppUpimagePath() {
		return appUpimagePath;
	}

	public void setAppUpimagePath(String appUpimagePath) {
		this.appUpimagePath = appUpimagePath;
	}

	public File getAppUpimage() {
		return appUpimage;
	}

	public void setAppUpimage(File appUpimage) {
		this.appUpimage = appUpimage;
	}

	public String getAppUpimageFileName() {
		return appUpimageFileName;
	}

	public void setAppUpimageFileName(String appUpimageFileName) {
		this.appUpimageFileName = appUpimageFileName;
	}

	public String getAppUpimageContentType() {
		return appUpimageContentType;
	}

	public void setAppUpimageContentType(String appUpimageContentType) {
		this.appUpimageContentType = appUpimageContentType;
	}

	public String getMktUrl() {
		return mktUrl;
	}

	public void setMktUrl(String mktUrl) {
		this.mktUrl = mktUrl;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

	public String getMktId() {
		return mktId;
	}

	public void setMktId(String mktId) {
		this.mktId = mktId;
	}

	public String getMktmsg() {
		return mktmsg;
	}

	public void setMktmsg(String mktmsg) {
		this.mktmsg = mktmsg;
	}	
	
}