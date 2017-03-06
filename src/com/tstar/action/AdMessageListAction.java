package com.tstar.action;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletContext;

import net.sf.json.JSON;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;
import net.sf.json.xml.XMLSerializer;

import org.apache.axis.utils.StringUtils;
import org.apache.commons.io.IOUtils;
import org.apache.http.HttpStatus;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.util.EntityUtils;
import org.apache.log4j.Logger;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.Action;
import com.tstar.dto.News;
import com.tstar.dto.Promotebanner;
import com.tstar.dto.TitleBanner;
import com.tstar.dto.Video;
import com.tstar.model.tapp.MvMessageList;
import com.tstar.model.tapp.SystemLookup;
import com.tstar.service.MessageListService;
import com.tstar.service.SystemLookupService;
import com.tstar.utility.PropertiesUtil;
import com.tstar.utility.Utils;

/*
 * APP首頁排版格式
 * 
 */
@Component
@Scope("prototype")
public class AdMessageListAction implements Action{
	
	private final Logger logger = Logger.getLogger(AdMessageListAction.class);
	
	@Autowired
	private PropertiesUtil propertiesUtil;
	
	@Autowired
	private SystemLookupService systemLookupService;
	
	@Autowired
	private MessageListService messageListService;
	
	private JSONObject jsonStr;
	
	private String osType;
	String id = "mytstar";
	   
    public String execute() throws Exception{
		String status = systemLookupService.getValue(id,"app_home_source_is_file");
		
		if (status != null && status.equals("false")) {
			jsonStr = getDbJson();
		} else {
			jsonStr = getFileJson();
		}
		// 官網取得最新消息
		String officialNews = "";
		
		officialNews = getNewSource();
		logger.debug("officialNews: " + officialNews);
		JSONObject official = new JSONObject();
		JSONObject news = (JSONObject) jsonStr.get("news");
		try {
			if (null != officialNews && !StringUtils.isEmpty(officialNews)) {
				official = (JSONObject) JSONSerializer.toJSON(officialNews);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		if(official.has("result")){
			JSONArray array1 = official.getJSONArray("result");
			JSONArray array2 = new JSONArray();
			for(int i = 0; i < array1.size(); i++){
				if(i < 3){
					array2.add(array1.get(i));
				}
			}
			news.put("news_data", array2);
			news.put("year", "");
		}
		
		List<MvMessageList> messageList = new ArrayList<MvMessageList>();
		if ("ios".equals(osType)) {
			messageList = messageListService.querySnowLeopard("mytstar_ios");
		} else {
			messageList = messageListService.querySnowLeopard("mytstar");
		}
		
		//取得ID最大的資料
		MvMessageList message = new MvMessageList();
		int messageID = 0;
		if(messageList != null){
			for(MvMessageList mvMessageList : messageList){
				
				if(mvMessageList != null){
					try{
						if(messageID < Integer.parseInt(mvMessageList.getMessageid())){
							message = mvMessageList;
							messageID = Integer.parseInt(mvMessageList.getMessageid());
						}
					}catch(Exception e){
						
					}
				}
			}
		}
		jsonStr.put("snowLeopard_pic", message.getSubjectpic());
		
		logger.debug((((JSONObject) jsonStr.get("news")).get("news_data")));
		
		return SUCCESS;
    }

	public JSON getJsonStr() {
		return jsonStr;
	}
	
	//由官網取得最新消息
	private String getNew(){
		String rtnStr = "";
		CloseableHttpClient client = HttpClientBuilder.create().build();
		CloseableHttpResponse response = null;
		try {
			HttpPost httpPost = new HttpPost(propertiesUtil.getProperty("Official_website_news"));
			response = client.execute(httpPost);
			if (response.getStatusLine().getStatusCode() == HttpStatus.SC_OK) {
				String respStr = EntityUtils.toString(response.getEntity());
				if(null != respStr && !StringUtils.isEmpty(respStr)){
					respStr = respStr.trim().replaceFirst("^([\\W]+)<", "<");
					respStr = respStr.replace("&", "and");
					JSON json = new XMLSerializer().read( respStr );
					rtnStr = json.toString();
					logger.debug("respStr: " + rtnStr);
				}
			}else{
				logger.debug("CWS最新消息取得錯誤: " + response.getStatusLine());
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		Utils utils = new Utils();
		utils.closeHttpClient(response, client);
		
		
		return rtnStr;
	}
	
	
	//由新官網取得最新消息
	private String getNewSource(){
		String rtnStr = "";
		//3s 自動TimeOut
		int timeout = 3;
		//由DB取得timeout設定秒數
		String dbTimeout = systemLookupService.getValue(id,"app_getnews_timeout");
		try{
			if(dbTimeout != null && Utils.isInt(dbTimeout)){
				timeout = Integer.parseInt(dbTimeout);
			}
		}catch(Exception e){
			
		}
		
		RequestConfig config = RequestConfig.custom() 
		  .setConnectTimeout(timeout * 1000) 
		  .setConnectionRequestTimeout(timeout * 1000) 
		  .setSocketTimeout(timeout * 1000).build(); 

		CloseableHttpClient client = HttpClientBuilder.create().setDefaultRequestConfig(config).build();
		CloseableHttpResponse response = null;
			try {
				HttpGet httpGet = new HttpGet(propertiesUtil.getProperty("tspNews"));
				response = client.execute(httpGet);
				if (HttpStatus.SC_OK == response.getStatusLine().getStatusCode()) {
					rtnStr = EntityUtils.toString(response.getEntity());
				}else{
					logger.debug("CWS最新消息取得錯誤: " + response.getStatusLine());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			Utils utils = new Utils();
			utils.closeHttpClient(response, client);
			return rtnStr;
	}
	
	private JSONObject getFileJson(){
		JSONObject fileJson = new JSONObject();
		try {
			// 取得APP首頁排版JSON
			ServletContext context = ServletActionContext.getServletContext();
			String path = "";
			if ("ios".equals(osType)) {
				path = context.getRealPath("/") + "data/json_20141006_ios.json";
			} else {
				path = context.getRealPath("/") + "data/json_20141006.json";
			}
			File f = new File(path);
			InputStream is = new FileInputStream(f);
			String jsonTxt = IOUtils.toString(is, "UTF-8");
			fileJson = (JSONObject) JSONSerializer.toJSON(jsonTxt);

			logger.debug("jsonStr: " + jsonStr);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return fileJson;
	}
	
	private JSONObject getDbJson() {
		JSONObject dbJson = new JSONObject();
		try {
			// 把所有app相關資訊撈出來放在這裡
			List<SystemLookup> systemLookupList;
			// DB查詢的ID
			String id = "mytstar";
			// 從systemLookupList撈出來放在map裡面
			HashMap<String, String> title_banner_map = new HashMap<String, String>();
			systemLookupList = systemLookupService
					.getLikeValue(id, "app_home_");
			// 執行放到map動作
			for (int i = 0; i < systemLookupList.size(); i++) {
				title_banner_map.put(systemLookupList.get(i).getKey(),systemLookupList.get(i).getValue());
			}
			// json的資料容器
			List<TitleBanner> titleBanner = new ArrayList<TitleBanner>();
			Promotebanner promotebanner = new Promotebanner();
			Video video = new Video();
			News newsdata = new News();
			if ("ios".equals(osType)) {
				// 放ios版本的title_banner
				TitleBanner titleBannerdata = new TitleBanner();
				if (title_banner_map.containsKey("app_home_ios_title_banner.[1].pic")) {
					titleBannerdata.setPic(title_banner_map.get("app_home_ios_title_banner.[1].pic").toString());
				} else {
					titleBannerdata.setPic("");
				}
				if (title_banner_map.containsKey("app_home_ios_title_banner.[1].url")) {
					titleBannerdata.setUrl(title_banner_map.get("app_home_ios_title_banner.[1].url").toString());
				} else {
					titleBannerdata.setUrl("");
				}
				titleBanner.add(titleBannerdata);
				titleBannerdata = new TitleBanner();
				if (title_banner_map.containsKey("app_home_ios_title_banner.[2].pic")) {
					titleBannerdata.setPic(title_banner_map.get("app_home_ios_title_banner.[2].pic").toString());
				} else {
					titleBannerdata.setPic("");
				}
				if (title_banner_map.containsKey("app_home_ios_title_banner.[2].url")) {
					titleBannerdata.setUrl(title_banner_map.get("app_home_ios_title_banner.[2].url").toString());
				} else {
					titleBannerdata.setUrl("");
				}
				titleBanner.add(titleBannerdata);

				titleBannerdata = new TitleBanner();
				if (title_banner_map.containsKey("app_home_ios_title_banner.[3].pic")) {
					titleBannerdata.setPic(title_banner_map.get("app_home_ios_title_banner.[3].pic").toString());
				} else {
					titleBannerdata.setPic("");
				}
				if (title_banner_map.containsKey("app_home_ios_title_banner.[3].url")) {
					titleBannerdata.setUrl(title_banner_map.get("app_home_ios_title_banner.[3].url").toString());
				} else {
					titleBannerdata.setUrl("");
				}
				titleBanner.add(titleBannerdata);

				titleBannerdata = new TitleBanner();
				if (title_banner_map.containsKey("app_home_ios_title_banner.[4].pic")) {
					titleBannerdata.setPic(title_banner_map.get("app_home_ios_title_banner.[4].pic").toString());
				} else {
					titleBannerdata.setPic("");
				}
				if (title_banner_map.containsKey("app_home_ios_title_banner.[4].url")) {
					titleBannerdata.setUrl(title_banner_map.get("app_home_ios_title_banner.[4].url").toString());
				} else {
					titleBannerdata.setUrl("");
				}
				titleBanner.add(titleBannerdata);

				// 放ios版本的promote_banner
				if (title_banner_map.containsKey("app_home_promote_banner.title_pic_android")) {
					promotebanner.setTitle_pic_android(title_banner_map.get("app_home_promote_banner.title_pic_android").toString());
				} else {
					promotebanner.setTitle_pic_android("");
				}
				if (title_banner_map.containsKey("app_home_promote_banner.title_pic_ios")) {
					promotebanner.setTitle_pic_ios(title_banner_map.get("app_home_promote_banner.title_pic_ios").toString());
				} else {
					promotebanner.setTitle_pic_ios("");
				}
				if (title_banner_map.containsKey("app_home_ios_promote_banner.more_url")) {
					promotebanner.setMore_url(title_banner_map.get("app_home_ios_promote_banner.more_url").toString());
				} else {
					promotebanner.setMore_url("");
				}
				// promote_banner資料裡的promote_data跟title_banner的資料格式依樣所以用TitleBanner的型態
				List<TitleBanner> Promote_data = new ArrayList<TitleBanner>();
				titleBannerdata = new TitleBanner();
				if (title_banner_map.containsKey("app_home_ios_promote_banner.promote_data.[1].pic")) {
					titleBannerdata.setPic(title_banner_map.get("app_home_ios_promote_banner.promote_data.[1].pic").toString());
				} else {
					titleBannerdata.setPic("");
				}
				if (title_banner_map.containsKey("app_home_ios_promote_banner.promote_data.[1].url")) {
					titleBannerdata.setUrl(title_banner_map.get("app_home_ios_promote_banner.promote_data.[1].url").toString());
				} else {
					titleBannerdata.setUrl("");
				}
				Promote_data.add(titleBannerdata);

				titleBannerdata = new TitleBanner();
				if (title_banner_map.containsKey("app_home_ios_promote_banner.promote_data.[2].pic")) {
					titleBannerdata.setPic(title_banner_map.get("app_home_ios_promote_banner.promote_data.[2].pic").toString());
				} else {
					titleBannerdata.setPic("");
				}
				if (title_banner_map.containsKey("app_home_ios_promote_banner.promote_data.[2].url")) {
					titleBannerdata.setUrl(title_banner_map.get("app_home_ios_promote_banner.promote_data.[2].url").toString());
				} else {
					titleBannerdata.setUrl("");
				}
				Promote_data.add(titleBannerdata);
				promotebanner.setPromote_data(Promote_data);
				// 放ios版本的video
				if (title_banner_map.containsKey("app_home_ios_video.more_url")) {
					video.setMore_url(title_banner_map.get("app_home_ios_video.more_url").toString());
				} else {
					video.setMore_url("");
				}
				if (title_banner_map.containsKey("app_home_ios_video.youtube_url")) {
					video.setYoutube_url(title_banner_map.get("app_home_ios_video.youtube_url").toString());
				} else {
					video.setYoutube_url("");
				}
				// 放ios版本的news
				if (title_banner_map.containsKey("app_home_ios_news.more_url")) {
					newsdata.setMore_url(title_banner_map.get("app_home_ios_news.more_url").toString());
				} else {
					newsdata.setMore_url("");
				}
			} else {
				// 放android版本的title_banner
				TitleBanner titleBannerdata = new TitleBanner();
				if (title_banner_map.containsKey("app_home_and_title_banner.[1].pic")) {
					titleBannerdata.setPic(title_banner_map.get("app_home_and_title_banner.[1].pic").toString());
				} else {
					titleBannerdata.setPic("");
				}
				if (title_banner_map.containsKey("app_home_and_title_banner.[1].url")) {
					titleBannerdata.setUrl(title_banner_map.get("app_home_and_title_banner.[1].url").toString());
				} else {
					titleBannerdata.setUrl("");
				}
				titleBanner.add(titleBannerdata);
				titleBannerdata = new TitleBanner();
				if (title_banner_map.containsKey("app_home_and_title_banner.[2].pic")) {
					titleBannerdata.setPic(title_banner_map.get("app_home_and_title_banner.[2].pic").toString());
				} else {
					titleBannerdata.setPic("");
				}
				if (title_banner_map.containsKey("app_home_and_title_banner.[2].url")) {
					titleBannerdata.setUrl(title_banner_map.get("app_home_and_title_banner.[2].url").toString());
				} else {
					titleBannerdata.setUrl("");
				}
				titleBanner.add(titleBannerdata);
				titleBannerdata = new TitleBanner();
				if (title_banner_map.containsKey("app_home_and_title_banner.[3].pic")) {
					titleBannerdata.setPic(title_banner_map.get("app_home_and_title_banner.[3].pic").toString());
				} else {
					titleBannerdata.setPic("");
				}
				if (title_banner_map.containsKey("app_home_and_title_banner.[3].url")) {
					titleBannerdata.setUrl(title_banner_map.get("app_home_and_title_banner.[3].url").toString());
				} else {
					titleBannerdata.setUrl("");
				}
				titleBanner.add(titleBannerdata);
				titleBannerdata = new TitleBanner();
				if (title_banner_map.containsKey("app_home_and_title_banner.[4].pic")) {
					titleBannerdata.setPic(title_banner_map.get("app_home_and_title_banner.[4].pic").toString());
				} else {
					titleBannerdata.setPic("");
				}
				if (title_banner_map.containsKey("app_home_and_title_banner.[4].url")) {
					titleBannerdata.setUrl(title_banner_map.get("app_home_and_title_banner.[4].url").toString());
				} else {
					titleBannerdata.setUrl("");
				}
				titleBanner.add(titleBannerdata);
				// 放android版本的promote_banner
				if (title_banner_map.containsKey("app_home_promote_banner.title_pic_android")) {
					promotebanner.setTitle_pic_android(title_banner_map.get("app_home_promote_banner.title_pic_android").toString());
				} else {
					promotebanner.setTitle_pic_android("");
				}
				if (title_banner_map.containsKey("app_home_promote_banner.title_pic_ios")) {
					promotebanner.setTitle_pic_ios(title_banner_map.get("app_home_promote_banner.title_pic_ios").toString());
				} else {
					promotebanner.setTitle_pic_ios("");
				}
				if (title_banner_map.containsKey("app_home_and_promote_banner.more_url")) {
					promotebanner.setMore_url(title_banner_map.get("app_home_and_promote_banner.more_url").toString());
				} else {
					promotebanner.setMore_url("");
				}
				// promote_banner資料裡的promote_data跟title_banner的資料格式依樣所以用TitleBanner的型態
				List<TitleBanner> Promote_data = new ArrayList<TitleBanner>();
				titleBannerdata = new TitleBanner();
				if (title_banner_map.containsKey("app_home_and_promote_banner.promote_data.[1].pic")) {
					titleBannerdata.setPic(title_banner_map.get("app_home_and_promote_banner.promote_data.[1].pic").toString());
				} else {
					titleBannerdata.setPic("");
				}
				if (title_banner_map.containsKey("app_home_and_promote_banner.promote_data.[1].url")) {
					titleBannerdata.setUrl(title_banner_map.get("app_home_and_promote_banner.promote_data.[1].url").toString());
				} else {
					titleBannerdata.setUrl("");
				}
				Promote_data.add(titleBannerdata);
				titleBannerdata = new TitleBanner();
				if (title_banner_map.containsKey("app_home_and_promote_banner.promote_data.[2].pic")) {
					titleBannerdata.setPic(title_banner_map.get("app_home_and_promote_banner.promote_data.[2].pic").toString());
				} else {
					titleBannerdata.setPic("");
				}
				if (title_banner_map.containsKey("app_home_and_promote_banner.promote_data.[2].url")) {
					titleBannerdata.setUrl(title_banner_map.get("app_home_and_promote_banner.promote_data.[2].url").toString());
				} else {
					titleBannerdata.setUrl("");
				}
				Promote_data.add(titleBannerdata);
				promotebanner.setPromote_data(Promote_data);
				// 放android版本的video
				if (title_banner_map.containsKey("app_home_and_video.more_url")) {
					video.setMore_url(title_banner_map.get("app_home_and_video.more_url").toString());
				} else {
					video.setMore_url("");
				}
				if (title_banner_map
						.containsKey("app_home_and_video.youtube_url")) {
					video.setYoutube_url(title_banner_map.get("app_home_and_video.youtube_url").toString());
				} else {
					video.setYoutube_url("");
				}
				// 放android版本的news
				if (title_banner_map.containsKey("app_home_and_news.more_url")) {
					newsdata.setMore_url(title_banner_map.get("app_home_and_news.more_url").toString());
				} else {
					newsdata.setMore_url("");
				}
			}
			dbJson.put("title_banner", titleBanner);
			dbJson.put("promote_banner", promotebanner);
			dbJson.put("video", video);
			dbJson.put("news", newsdata);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return dbJson;
	}
	public void setOsType(String osType) {
		this.osType = osType;
	}
}
