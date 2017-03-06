package com.tstar.action;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.builder.ReflectionToStringBuilder;
import org.apache.http.HttpStatus;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.apache.log4j.Logger;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.Action;
import com.tstar.dto.ProjectDeviceDto;
import com.tstar.dto.QueryCompareProjectDto;
import com.tstar.model.custom.ProJsonCompare;
import com.tstar.model.custom.ProJsonTstar;
import com.tstar.model.custom.ProjectDevice;
import com.tstar.model.custom.ProjectRate;
import com.tstar.model.tapp.Projects;
import com.tstar.model.tapp.RateProjects;
import com.tstar.model.tapp.SelectList;
import com.tstar.service.ComparsionService;
import com.tstar.service.SelectListService;
import com.tstar.service.SystemLookupService;
import com.tstar.utility.PropertiesUtil;
import com.tstar.utility.Utils;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.util.JSONUtils;

@Component
@Scope("prototype")
public class ComparsionAction implements Action{
	
	private final Logger logger = Logger.getLogger(ComparsionAction.class);

	private Utils utils = new Utils();
//	private EncriptionSimple encriptinSimple = new EncriptionSimple();
	
	private final String COMPARE_DEFAULT = "COMPARE_DEFAULT_";
		
	@Autowired
	private ComparsionService comparsionService;
	
	@Autowired
	private SystemLookupService systemLookupService;
	
	@Autowired
	private SelectListService selectListService;
	
	@Autowired
	private PropertiesUtil propertiesUtil;
	
	private String company_sel;
	private String fee_sel;
	private String fee_range;
	private ProjectRate projectRateTstar;
	private ProjectRate projectRateChosen;
	private Map<String, ProjectDeviceDto> projectDevicemap;
	private List<ProjectDeviceDto> ProjectDeviceDtoOrder;
	private String feeRangeData;/*返回頁面下拉選單所需的值的Json String*/
	private String feeSelData;/*返回頁面下拉選單所需的值的Json String*/
	private String companySelData;/*返回頁面下拉選單所需的值的Json String*/
	private String mobileDataJson;/*返回頁面下拉選單所需的值的 String*/
	private String fee_type;
	private String typeSelData;
	private String company;
	private String tStar = "台灣之星";
	private Map<String, String> mobileData;
	
	//20150610
	private String calRule;	//試算規則
	private QueryCompareProjectDto queryCompareProject1Dto = new QueryCompareProjectDto();
	private QueryCompareProjectDto queryCompareProject2Dto = new QueryCompareProjectDto();
	private QueryCompareProjectDto tmp = new QueryCompareProjectDto();
	private String fee_sel1;//資費試算-手機專案價
	private String fee_sel2;//資費試算-單門號
	private String tab;//識別頁籤
	private ProJsonTstar proJsonTstar;
	private ProJsonCompare proJsonCompare;
	private String chooseDeviceName;
	private String priceTstar;
	private String singlePhoneTstar;
	private String singlePhoneChosen;
	private String prepaymentAmountTstar;
	private String priceChoose;
	private String prepaymentAmountChoose;
	private String applyType;
	private String selectKey;

	private String rtnJson;
	private String protectWord;
	
//	20160315 用戶登入後，將平均值帶入資料欄位
//	private String token;
//	private JSONObject request;
//	private String msisdn;
//	private String contractId;
//	private String loginDefault;
	
	public String execute() throws Exception{
		logger.debug("ComparsionAction.execute():");
        HttpServletResponse response = ServletActionContext.getResponse();
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");//HTTP 1.1.
        response.setHeader("Pragma", "no-cache");//HTTP 1.1.
        response.setDateHeader("Expires", 0);//Proxies.
        this.getSelectList();
        logger.debug("tmp_resultBack: " + ReflectionToStringBuilder.toString(tmp));
		return SUCCESS;
    }

	public String compare() throws Exception{
		logger.info("ComparsionAction.compare()");
		
		this.getSelectList();
		
		if(null == fee_sel || "".equals(fee_sel)){
			return execute();
		}
		
		String[] feeRange = fee_sel.split("~");
		
		// 台灣之星id=1
		//取得台灣之星符合條件的最低資費
		projectRateTstar = comparsionService.comparseProjectSelectMin("1", feeRange[0], feeRange[1], fee_type);
		//取得上述資費的所有搭配手機方案
		List<ProjectDevice> projectDeviceListTstar = comparsionService.getProjectByRateId(projectRateTstar.getRateId());
		//取得選擇對手符合條件的最低資費
		projectRateChosen = comparsionService.comparseProjectSelectMin(company_sel, feeRange[0], feeRange[1], fee_type);
		//取得上述資費的所有搭配手機方案
		List<ProjectDevice> projectDeviceListChosen = comparsionService.getProjectByRateId(projectRateChosen.getRateId());
		
		//將所有專案搭手機的清單整合
		projectDevicemap = new HashMap<String, ProjectDeviceDto>();
		//台灣之星的清單
		for(ProjectDevice projectDevice : projectDeviceListTstar){
			if(projectDevicemap.containsKey(projectDevice.getDeviceName())){
				ProjectDeviceDto projectDeviceDto = projectDevicemap.get(projectDevice.getDeviceName());
				projectDeviceDto.setPriceTstar(projectDevice.getPrice());
				projectDeviceDto.setPrepaymentAmountTstar(projectDevice.getPrepaymentAmount());
			}else{
				ProjectDeviceDto projectDeviceDto = new ProjectDeviceDto();
				projectDeviceDto.setDeviceModel(projectDevice.getDeviceModel());
				projectDeviceDto.setDeviceName(projectDevice.getDeviceName());
				projectDeviceDto.setPriceTstar(projectDevice.getPrice());
				projectDeviceDto.setProjectName(projectDevice.getProjectName());
				projectDeviceDto.setPrepaymentAmountTstar(projectDevice.getPrepaymentAmount());
				projectDevicemap.put(projectDevice.getDeviceName(), projectDeviceDto);
			}
		}
		//塞要比較電信的資料
		for(ProjectDevice projectDevice : projectDeviceListChosen){
			if(projectDevicemap.containsKey(projectDevice.getDeviceName())){
				ProjectDeviceDto projectDeviceDto = projectDevicemap.get(projectDevice.getDeviceName());
				projectDeviceDto.setPriceChosen(projectDevice.getPrice());
				projectDeviceDto.setPrepaymentAmountChosen(projectDevice.getPrepaymentAmount());
			}else{
				ProjectDeviceDto projectDeviceDto = new ProjectDeviceDto();
				projectDeviceDto.setDeviceModel(projectDevice.getDeviceModel());
				projectDeviceDto.setDeviceName(projectDevice.getDeviceName());
				projectDeviceDto.setPriceChosen(projectDevice.getPrice());
				projectDeviceDto.setProjectName(projectDevice.getProjectName());
				projectDeviceDto.setPrepaymentAmountChosen(projectDevice.getPrepaymentAmount());
				projectDevicemap.put(projectDevice.getDeviceName(), projectDeviceDto);
			}
		}
		
		ProjectDeviceDtoOrder = new ArrayList<ProjectDeviceDto>();
		for(String deviceName : projectDevicemap.keySet()){
			logger.debug("手機名稱: " + deviceName + " 專案名稱: " + projectDevicemap.get(deviceName).getProjectName() 
					+ " T: " + projectDevicemap.get(deviceName).getPriceTstar()
					+ " C: " + projectDevicemap.get(deviceName).getPriceChosen());
			ProjectDeviceDtoOrder.add(projectDevicemap.get(deviceName));
		}
		//確定有值再比較
		if(null != projectDeviceListTstar && 0 < projectDeviceListTstar.size()){
			//製造排序
			Collections.sort(ProjectDeviceDtoOrder, new Comparator<ProjectDeviceDto>() {
	            public int compare(ProjectDeviceDto o1, ProjectDeviceDto o2) {
	            	Integer o1Price = 0;
	            	Integer o2Price = 0;
	            	try{
		            	o1Price = Integer.parseInt(o1.getPriceTstar());
	            	}catch(Exception e){
	            		logger.debug("deviceName: " + o1.getDeviceName() + " 金額錯誤: " + e.getCause());
	            	}
	            	try{
		            	o2Price = Integer.parseInt(o2.getPriceTstar());
	            	}catch(Exception e){
	            		logger.debug("deviceName: " + o1.getDeviceName() + " 金額錯誤: " + e.getCause());
	            	}
	            	return o1Price.compareTo(o2Price);
	            }
	        });
		}
		
//		for(ProjectDeviceDto dto : ProjectDeviceDtoOrder){
//			logger.info("手機名稱: " + dto.getDeviceName() + " 專案名稱: " + dto.getPriceTstar()); 
//		}
		
		return SUCCESS;
    }
	
	public String comparebybsc() throws Exception{
		logger.debug("ComparsionAction.comparebybsc()");
		if(queryCompareProject1Dto == null && queryCompareProject2Dto == null){
			logger.debug("==queryCompareProject1Dto: " + (queryCompareProject1Dto == null) + "  ==queryCompareProject2Dto: " + (queryCompareProject2Dto == null));
			return "comparsion";
		}
		fee_sel1 = queryCompareProject1Dto.getFee_sel();
		fee_sel2 = queryCompareProject2Dto.getFee_sel();
		logger.info("===============: " + ("w_p".equals(calRule) ? "手機專案價" : "單門號"));
		if(null != queryCompareProject1Dto.getOp_id()){
			logger.debug("===============queryCompareProjectDto:" + ReflectionToStringBuilder.toString(queryCompareProject1Dto));
		}
		else {
			logger.debug("===============queryCompareProjectDto:" + ReflectionToStringBuilder.toString(queryCompareProject2Dto));
		}
		logger.debug("===============fee_sel1: " + fee_sel1);
		logger.debug("===============fee_sel2: " + fee_sel2);
				
		
		try{
			CloseableHttpClient client = HttpClientBuilder.create().build();
			HttpPost httpPost = new HttpPost(propertiesUtil.getProperty("bscUrl") + "compareproject.action");
			logger.debug("BSC address: " + propertiesUtil.getProperty("bscUrl") + "compareproject.action");
			httpPost.setHeader("Content-type", "text/html");
			List<NameValuePair> param = new ArrayList<NameValuePair>();

			// CHT:中華/TWM:台哥大/FET:遠傳/APW:亞太
			String op_id = queryCompareProject1Dto.getOp_id();
			param.add(new BasicNameValuePair("op_id", getOpid(op_id)));
			
			//資費區間(起)
			if("w_p".equals(calRule)){	//手機專案價	
				//是否查詢單門號
				param.add(new BasicNameValuePair("device_flag", "Y"));
				
				// 約期
				if (Utils.isInt(queryCompareProject1Dto.getPeriod())) {
					param.add(new BasicNameValuePair("period", queryCompareProject1Dto.getPeriod()));
				}
				
				//3G/4G
				if(StringUtils.isNotBlank(queryCompareProject1Dto.getGtype())){
					param.add(new BasicNameValuePair("gtype", queryCompareProject1Dto.getGtype()));
				}
				
				//資費範圍
				if(null == queryCompareProject1Dto.getFee_sel() || "".equals(queryCompareProject1Dto.getFee_sel()) 
						|| !queryCompareProject1Dto.getFee_sel().contains("~")){
					logger.info(null == queryCompareProject1Dto.getFee_sel() + " : " + "".equals(queryCompareProject1Dto.getFee_sel()) + " : " + !queryCompareProject1Dto.getFee_sel().contains("~"));
					return execute();
				}
				String[] feeRange = queryCompareProject1Dto.getFee_sel().split("~");
				if(Utils.isInt(feeRange[0]) && Utils.isInt(feeRange[1])){
					param.add(new BasicNameValuePair("range_from", feeRange[0]));
					param.add(new BasicNameValuePair("range_to", feeRange[1]));
				}else{
					logger.info(feeRange[0] + " : " + feeRange[1]);
					return execute();
				}

				//選擇資費
				if(StringUtils.isNotBlank(queryCompareProject1Dto.getProject_code())){
					param.add(new BasicNameValuePair("project_code", queryCompareProject1Dto.getProject_code()));
				}
				
				//網內
				if(Utils.isInt(queryCompareProject1Dto.getVoice_on_net())){
					//頁面是分要轉成秒
					param.add(new BasicNameValuePair("voice_on_net", utils.min2sec(queryCompareProject1Dto.getVoice_on_net())));
				}
				//網外
				if(Utils.isInt(queryCompareProject1Dto.getVoice_off_net())){
					//頁面是分要轉成秒
					param.add(new BasicNameValuePair("voice_off_net", utils.min2sec(queryCompareProject1Dto.getVoice_off_net())));
				}
				//市話
				if(Utils.isInt(queryCompareProject1Dto.getPstn())){
					//頁面是分要轉成秒
					param.add(new BasicNameValuePair("pstn", utils.min2sec(queryCompareProject1Dto.getPstn())));
				}
				//上網傳輸量
				if(Utils.isDouble(queryCompareProject1Dto.getData_usage())){
					double num = Double.parseDouble(queryCompareProject1Dto.getData_usage());
					param.add(new BasicNameValuePair("data_usage", String.valueOf(utils.converter(num, "gb", "b", 1))));
				}
				//網內簡訊
				if(Utils.isInt(queryCompareProject1Dto.getSms_on_net())){
					param.add(new BasicNameValuePair("sms_on_net", queryCompareProject1Dto.getSms_on_net()));
				}
				//網外簡訊
				if(Utils.isInt(queryCompareProject1Dto.getSms_off_net())){
					param.add(new BasicNameValuePair("sms_off_net", queryCompareProject1Dto.getSms_off_net()));
				}
				//手機
//					if(Utils.isInt(queryCompareProject1Dto.getData_usage())){
//						param.add(new BasicNameValuePair("data_usage", queryCompareProject1Dto.getData_usage()));
//					}
				
				//保護文字
				company_sel = queryCompareProject1Dto.getOp_id();
				company = getCompanyName();	
				String gtype = queryCompareProject1Dto.getGtype();
				if(!("".equals(gtype)) || !("null".equals(gtype))){
					protectWord(queryCompareProject1Dto.getGtype());
				}else{
					protectWord = "";
				}
				//暫存狀態儲存
				tmp.setCal_rule(calRule);
				tmp.setApply_type(applyType);
				tmp.setOp_id(queryCompareProject1Dto.getOp_id());
				tmp.setFee_type(queryCompareProject1Dto.getGtype());
				tmp.setFee_range(queryCompareProject1Dto.getFee_range());
				tmp.setFee_sel(queryCompareProject1Dto.getFee_sel());
				tmp.setPeriod(queryCompareProject1Dto.getPeriod());
				tmp.setProject_code(queryCompareProject1Dto.getProject_code());
				tmp.setVoice_on_net(queryCompareProject1Dto.getVoice_on_net());
				tmp.setVoice_off_net(queryCompareProject1Dto.getVoice_off_net());
				tmp.setPstn(queryCompareProject1Dto.getPstn());
				tmp.setData_usage(queryCompareProject1Dto.getData_usage());
				tmp.setSms_on_net(queryCompareProject1Dto.getSms_on_net());
				tmp.setSms_off_net(queryCompareProject1Dto.getSms_off_net());
				tmp.setPhone_code(queryCompareProject1Dto.getPhone_code());
				logger.debug("tmp wp: " + ReflectionToStringBuilder.toString(tmp));
			}else if("w_o_p".equals(calRule)){	//單門號
				//是否查詢單門號
				param.add(new BasicNameValuePair("device_flag", "N"));
				
				// 約期
				if (Utils.isInt(queryCompareProject2Dto.getPeriod())) {
					param.add(new BasicNameValuePair("period", queryCompareProject2Dto.getPeriod()));
				}
				//3G,4G
				if(StringUtils.isNotBlank(queryCompareProject2Dto.getGtype())){
					param.add(new BasicNameValuePair("gtype", queryCompareProject2Dto.getGtype()));
				}
				
				//資費範圍
				if(null == queryCompareProject2Dto.getFee_sel() || "".equals(queryCompareProject2Dto.getFee_sel()) 
						|| !queryCompareProject2Dto.getFee_sel().contains("~")){
					logger.info(null == queryCompareProject2Dto.getFee_sel() + " : " + "".equals(queryCompareProject2Dto.getFee_sel()) + " : " + !queryCompareProject2Dto.getFee_sel().contains("~"));
					return execute();
				}
				String[] feeRange = queryCompareProject2Dto.getFee_sel().split("~");
				if(Utils.isInt(feeRange[0]) && Utils.isInt(feeRange[1])){
					param.add(new BasicNameValuePair("range_from", feeRange[0]));
					param.add(new BasicNameValuePair("range_to", feeRange[1]));
				}else{
					logger.info(feeRange[0] + " : " + feeRange[1]);
					return execute();
				}
				//網內
				if(Utils.isInt(queryCompareProject2Dto.getVoice_on_net())){
					//頁面是分要轉成秒
					param.add(new BasicNameValuePair("voice_on_net", utils.min2sec(queryCompareProject2Dto.getVoice_on_net())));
				}
				//網外
				if(Utils.isInt(queryCompareProject2Dto.getVoice_off_net())){
					//頁面是分要轉成秒
					param.add(new BasicNameValuePair("voice_off_net", utils.min2sec(queryCompareProject2Dto.getVoice_off_net())));
				}
				//市話
				if(Utils.isInt(queryCompareProject2Dto.getPstn())){
					//頁面是分要轉成秒
					param.add(new BasicNameValuePair("pstn", utils.min2sec(queryCompareProject2Dto.getPstn())));
				}
				//上網傳輸量
				if(Utils.isDouble(queryCompareProject2Dto.getData_usage())){
					double num = Double.parseDouble(queryCompareProject2Dto.getData_usage());
					param.add(new BasicNameValuePair("data_usage", String.valueOf(utils.converter(num, "gb", "b", 1))));
				}
				//網內簡訊
				if(Utils.isInt(queryCompareProject2Dto.getSms_on_net())){
					param.add(new BasicNameValuePair("sms_on_net", queryCompareProject2Dto.getSms_on_net()));
				}
				//網外簡訊
				if(Utils.isInt(queryCompareProject2Dto.getSms_off_net())){
					param.add(new BasicNameValuePair("sms_off_net", queryCompareProject2Dto.getSms_off_net()));
				}
				//手機
//					if(Utils.isInt(queryCompareProject2Dto.getData_usage())){
//						param.add(new BasicNameValuePair("data_usage", queryCompareProject2Dto.getData_usage()));
//					}
				String gtype = queryCompareProject2Dto.getGtype();
				if(!("".equals(gtype)) || !("null".equals(gtype))){
					protectWord(queryCompareProject2Dto.getGtype());
				}else{
					protectWord = "";
				}
				//暫存狀態儲存
				tmp.setCal_rule(calRule);
				tmp.setFee_type(queryCompareProject2Dto.getGtype());
				tmp.setFee_range(queryCompareProject2Dto.getFee_range());
				tmp.setFee_sel(queryCompareProject2Dto.getFee_sel());
				tmp.setPeriod("30");
				tmp.setVoice_on_net(queryCompareProject2Dto.getVoice_on_net());
				tmp.setVoice_off_net(queryCompareProject2Dto.getVoice_off_net());
				tmp.setPstn(queryCompareProject2Dto.getPstn());
				tmp.setData_usage(queryCompareProject2Dto.getData_usage());
				tmp.setSms_on_net(queryCompareProject2Dto.getSms_on_net());
				tmp.setSms_off_net(queryCompareProject2Dto.getSms_off_net());
				tmp.setPhone_code(queryCompareProject2Dto.getPhone_code());
				logger.debug("tmp wop: " + ReflectionToStringBuilder.toString(tmp));
			}else{
				return "comparsion";
			}
			httpPost.setHeader("Content-Type", "application/x-www-form-urlencoded");
			httpPost.setEntity(new UrlEncodedFormEntity(param, "UTF-8"));
			// 收Server吐出來的資料
			CloseableHttpResponse response = client.execute(httpPost);
			String responseString = EntityUtils.toString(response.getEntity());
			JSONObject json = new JSONObject();
			if (response.getStatusLine().getStatusCode() == HttpStatus.SC_OK ) {// 如果回傳是 200 OK 的話才輸出
	        	if("".equals(responseString)){
	        		json.put("Status", "1");
	        		json.put("StatusMsg", "無資料回傳");
	        		logger.debug("===============responseString is NULL.");
	        		rtnJson = json.toString();
	        	}else{
	        		logger.debug("===============responseString: " + responseString);
	        		rtnJson = JSONUtils.quote(responseString);
	        		searchJSONValue(responseString);//為了給html判斷是否有資費在後端多解析一次json(正在尋找方法解決)	
	        		
	        		//取得所選手機型號
	        		String mobile = "";
	        		if("w_p".equals(calRule)){//手機專案價
	        			mobile = queryCompareProject1Dto.getPhone_code();
	        		}else{
	        			mobile = queryCompareProject2Dto.getPhone_code();// 單門號
	        		}
	        		
	        		logger.debug("===============mobile: " + mobile);
	        		
	        		//由JSON取得專案代碼
	        		String companyProjectCode = "";
	        		String companyProjectCode2 = "";
	        		String competitorProjectCode = "";
	        		JSONObject jsonResp1 = JSONObject.fromObject(responseString);
	        		if(jsonResp1.has("compare_data")){
	        			if(0 < jsonResp1.getJSONArray("compare_data").size()){
	        				JSONArray array = jsonResp1.getJSONArray("compare_data");
	        				for(int i = 0; i < array.size(); i++){
	        					JSONObject jsonResp2 = array.getJSONObject(i);
	        					if(jsonResp2.has("Po_cur_company")){
	        						companyProjectCode = jsonResp2.getJSONArray("Po_cur_company").getJSONObject(0).getString("Project_code");
	        						if("w_o_p".equals(calRule)){
	        							if(1 < jsonResp2.getJSONArray("Po_cur_company").size()){
	        								companyProjectCode2 = jsonResp2.getJSONArray("Po_cur_company").getJSONObject(1).getString("Project_code");
	        							}
	        						}
	        					}else if(jsonResp2.has("Po_cur_competitor")){
	        						competitorProjectCode = jsonResp2.getJSONArray("Po_cur_competitor").getJSONObject(0).getString("Project_code");
	        					}
	        				}
	        			}
	        		}
	        		//增加手機資料
	        		//取得資費專案的所有搭配手機方案
	        		List<ProjectDevice> projectDeviceListTstar = comparsionService.getProjectByRateId(companyProjectCode);
	        		List<ProjectDevice> projectDeviceListTstar2 = null;
	        		List<ProjectDevice> projectDeviceListChosen = null;
	        		
	        		if("w_p".equals(calRule)){
		        		//取得資費專案的所有搭配手機方案
		        		projectDeviceListChosen = comparsionService.getProjectByRateId(competitorProjectCode);
	        		}else if("w_o_p".equals(calRule) && StringUtils.isNotBlank(companyProjectCode2)){
	        			projectDeviceListTstar2 = comparsionService.getProjectByRateId(companyProjectCode2.trim());
	        		}
	        		
	        		//將所有專案搭手機的清單整合
	        		projectDevicemap = new HashMap<String, ProjectDeviceDto>();
	        		
	        		//台灣之星的清單
	        		for(ProjectDevice projectDevice : projectDeviceListTstar){
	        			//只給所選手機
	        			try {
		        			logger.debug("ProjectId:" + projectDevice.getProjectId() + 
		        							" 單機價: " + projectDevice.getSinglePhone() + 
		        							" 專案價: " + projectDevice.getPrice() +
		        							" MobileId:" + mobile + 
		        							" match: " + projectDevice.getProjectId().equals(mobile));
		        			if(projectDevice.getProjectId().equals(mobile)){
			        			if(projectDevicemap.containsKey(projectDevice.getDeviceName())){
			        				ProjectDeviceDto projectDeviceDto = projectDevicemap.get(projectDevice.getDeviceName());
			        				projectDeviceDto.setPriceTstar(projectDevice.getPrice());
			        				projectDeviceDto.setPrepaymentAmountTstar(projectDevice.getPrepaymentAmount());
			        				projectDeviceDto.setSinglePhoneTstar(projectDevice.getSinglePhone());
			        			}else{
			        				ProjectDeviceDto projectDeviceDto = new ProjectDeviceDto();
			        				projectDeviceDto.setDeviceModel(projectDevice.getDeviceModel());
			        				projectDeviceDto.setDeviceName(projectDevice.getDeviceName());
			        				projectDeviceDto.setPriceTstar(projectDevice.getPrice());
			        				projectDeviceDto.setProjectName(projectDevice.getProjectName());
			        				projectDeviceDto.setPrepaymentAmountTstar(projectDevice.getPrepaymentAmount());
			        				projectDeviceDto.setSinglePhoneTstar(projectDevice.getSinglePhone());
			        				projectDevicemap.put(projectDevice.getDeviceName(), projectDeviceDto);
			        			}
		        			}
						} catch (Exception e) {
							logger.info(e.toString());
						}
	        		}
	        		
					if ("w_o_p".equals(calRule) && projectDeviceListTstar2 != null) {
						//台灣之星的清單
		        		for(ProjectDevice projectDevice : projectDeviceListTstar2){
		        			//只給所選手機
		        			try {
			        			logger.debug("ProjectId:" + projectDevice.getProjectId() + 
	        							" 單機價: " + projectDevice.getSinglePhone() + 
	        							" 專案價: " + projectDevice.getPrice() +
	        							" MobileId:" + mobile + 
	        							" match: " + projectDevice.getProjectId().equals(mobile));
			        			if(projectDevice.getProjectId().equals(mobile)){
			        				if(projectDevicemap.containsKey(projectDevice.getDeviceName())){
				        				ProjectDeviceDto projectDeviceDto = projectDevicemap.get(projectDevice.getDeviceName());
				        				projectDeviceDto.setPriceChosen(projectDevice.getPrice());
				        				projectDeviceDto.setPrepaymentAmountChosen(projectDevice.getPrepaymentAmount());
				        				projectDeviceDto.setSinglePhoneChosen(projectDevice.getSinglePhone());
				        			}else{
				        				ProjectDeviceDto projectDeviceDto = new ProjectDeviceDto();
				        				projectDeviceDto.setDeviceModel(projectDevice.getDeviceModel());
				        				projectDeviceDto.setDeviceName(projectDevice.getDeviceName());
				        				projectDeviceDto.setPriceChosen(projectDevice.getPrice());
				        				projectDeviceDto.setProjectName(projectDevice.getProjectName());
				        				projectDeviceDto.setPrepaymentAmountChosen(projectDevice.getPrepaymentAmount());
				        				projectDeviceDto.setSinglePhoneChosen(projectDevice.getSinglePhone());
				        				projectDevicemap.put(projectDevice.getDeviceName(), projectDeviceDto);
				        			}
			        			}
							} catch (Exception e) {
								logger.info(e.toString());
							}
		        		}
					}
	        		
	        		if("w_p".equals(calRule)){	//單門號沒有比較競業專案
		        		//塞要比較電信的資料(手機)
		        		for(ProjectDevice projectDevice : projectDeviceListChosen){
		        			try {
			        			logger.debug("Chosen:" + projectDevice.getProjectId() + " 單機價: " + projectDevice.getSinglePhone());
			        			if(projectDevice.getProjectId().equals(mobile)){
				        			if(projectDevicemap.containsKey(projectDevice.getDeviceName())){
				        				ProjectDeviceDto projectDeviceDto = projectDevicemap.get(projectDevice.getDeviceName());
				        				projectDeviceDto.setPriceChosen(projectDevice.getPrice());
				        				projectDeviceDto.setPrepaymentAmountChosen(projectDevice.getPrepaymentAmount());
				        				projectDeviceDto.setSinglePhoneChosen(projectDevice.getSinglePhone());
				        			}else{
				        				ProjectDeviceDto projectDeviceDto = new ProjectDeviceDto();
				        				projectDeviceDto.setDeviceModel(projectDevice.getDeviceModel());
				        				projectDeviceDto.setDeviceName(projectDevice.getDeviceName());
				        				projectDeviceDto.setPriceChosen(projectDevice.getPrice());
				        				projectDeviceDto.setProjectName(projectDevice.getProjectName());
				        				projectDeviceDto.setPrepaymentAmountChosen(projectDevice.getPrepaymentAmount());
				        				projectDeviceDto.setSinglePhoneChosen(projectDevice.getSinglePhone());
				        				projectDevicemap.put(projectDevice.getDeviceName(), projectDeviceDto);
				        			}
			        			}
							} catch (Exception e) {
								logger.info(e.toString());
							}
		        		}
	        		}
	        		
	        		ProjectDeviceDtoOrder = new ArrayList<ProjectDeviceDto>();
	        		for(String deviceName : projectDevicemap.keySet()){
	        			logger.debug("手機名稱: " + deviceName + " 專案名稱: " + projectDevicemap.get(deviceName).getProjectName() 
	        					+ " T: " + projectDevicemap.get(deviceName).getPriceTstar()
	        					+ " C: " + projectDevicemap.get(deviceName).getPriceChosen());
	        			ProjectDeviceDtoOrder.add(projectDevicemap.get(deviceName));
	        		}
	        		mobileData = getCompareMobile();
	        		if(projectDevicemap.get(mobileData.get(queryCompareProject1Dto.getPhone_code())) != null){
	        			chooseDeviceName = projectDevicemap.get(mobileData.get(queryCompareProject1Dto.getPhone_code())).getDeviceName();
	        			priceTstar = projectDevicemap.get(mobileData.get(queryCompareProject1Dto.getPhone_code())).getPriceTstar();
	        			prepaymentAmountTstar = (projectDevicemap.get(mobileData.get(queryCompareProject1Dto.getPhone_code())).getPrepaymentAmountTstar());
	        			priceChoose = projectDevicemap.get(mobileData.get(queryCompareProject1Dto.getPhone_code())).getPriceChosen();
	        			prepaymentAmountChoose = projectDevicemap.get(mobileData.get(queryCompareProject1Dto.getPhone_code())).getPrepaymentAmountChosen();
	        		}
	        		
	        		if(projectDevicemap.get(mobileData.get(queryCompareProject2Dto.getPhone_code())) != null){
	        			chooseDeviceName = projectDevicemap.get(mobileData.get(queryCompareProject2Dto.getPhone_code())).getDeviceName();
	        			priceTstar = projectDevicemap.get(mobileData.get(queryCompareProject2Dto.getPhone_code())).getPriceChosen();
	        			prepaymentAmountTstar = (projectDevicemap.get(mobileData.get(queryCompareProject2Dto.getPhone_code())).getPrepaymentAmountTstar());
		        		singlePhoneTstar = projectDevicemap.get(mobileData.get(queryCompareProject2Dto.getPhone_code())).getSinglePhoneTstar();
		        		singlePhoneChosen = projectDevicemap.get(mobileData.get(queryCompareProject2Dto.getPhone_code())).getSinglePhoneChosen();
	        		}
	        		
	        		//確定有值再比較
	        		if(null != projectDeviceListTstar && 0 < projectDeviceListTstar.size()){
	        			//製造排序
	        			Collections.sort(ProjectDeviceDtoOrder, new Comparator<ProjectDeviceDto>() {
	        	            public int compare(ProjectDeviceDto o1, ProjectDeviceDto o2) {
	        	            	Integer o1Price = 0;
	        	            	Integer o2Price = 0;
	        	            	try{
	        		            	o1Price = Integer.parseInt(o1.getPriceTstar());
	        	            	}catch(Exception e){
	        	            		logger.debug("deviceName: " + o1.getDeviceName() + " 金額錯誤: " + e.getCause());
	        	            	}
	        	            	try{
	        		            	o2Price = Integer.parseInt(o2.getPriceTstar());
	        	            	}catch(Exception e){
	        	            		logger.debug("deviceName: " + o1.getDeviceName() + " 金額錯誤: " + e.getCause());
	        	            	}
	        	            	return o1Price.compareTo(o2Price);
	        	            }
	        	        });
	        		}
	        	}
	        } else {
				logger.debug("StatusMsg:" + response.getStatusLine().getStatusCode());
	        	json.put("Status", "1");
        		json.put("StatusMsg", "網路錯誤 StatusCode: " + response.getStatusLine().getStatusCode());
        		rtnJson = json.toString();        		
	        }
			
			Utils utils = new Utils();
			utils.closeHttpClient(response, client);
		}catch(Exception e){
			logger.error("error",e);
		}
		return SUCCESS;	
	}
	
	
	private void protectWord(String gtype) {
		String rule;
		if("w_p".equals(calRule)){
			rule = "PROJECT";
		}else{
			rule = "SIM";
		}
		protectWord  = systemLookupService.getValue("mytstar", COMPARE_DEFAULT + gtype + "_" + rule + "_PS");
		logger.debug("protectWord:" + protectWord);
	}

	private String getOpid(String op_id){
		// CHT:中華/TWM:台哥大/FET:遠傳/APW:亞太
		String opId = "%";
		if ("2".equals(op_id)) {
			opId = "CHT"; // 中華
		} else if ("3".equals(op_id)) {
			opId = "FET"; // 遠傳
		} else if ("4".equals(op_id)) {
			opId = "TWM"; // 台哥大
		} else if ("5".equals(op_id)) {
			opId = "APW"; // 亞太
		}
		return opId;
	}
	
	public String projectList(){
		JSONObject json = new JSONObject();
		if(queryCompareProject1Dto != null){
			CloseableHttpClient client = HttpClientBuilder.create().build();
			HttpPost httpPost = new HttpPost(propertiesUtil.getProperty("bscUrl") + "projectList.action");
			httpPost.setHeader("Content-type", "text/html");
			httpPost.setHeader("Content-Type", "application/x-www-form-urlencoded");
			List<NameValuePair> param = new ArrayList<NameValuePair>();
			
			// CHT:中華/TWM:台哥大/FET:遠傳/APW:亞太
			String op_id = queryCompareProject1Dto.getOp_id();
			param.add(new BasicNameValuePair("op_id", getOpid(op_id)));
			if(StringUtils.isNotBlank(queryCompareProject1Dto.getGtype())){
				param.add(new BasicNameValuePair("gtype", queryCompareProject1Dto.getGtype()));
			}
			if(StringUtils.isNotBlank(queryCompareProject1Dto.getRange_from()) && StringUtils.isNotBlank(queryCompareProject1Dto.getRange_to())){
				param.add(new BasicNameValuePair("range_from", queryCompareProject1Dto.getRange_from()));
				param.add(new BasicNameValuePair("range_to", queryCompareProject1Dto.getRange_to()));
			}
			
			CloseableHttpResponse response = null;
			try {
				httpPost.setEntity(new UrlEncodedFormEntity(param, "UTF-8"));
				response = client.execute(httpPost);
				
				String responseString = EntityUtils.toString(response.getEntity());
				if (response.getStatusLine().getStatusCode() == HttpStatus.SC_OK ) {
		            // 如果回傳是 200 OK 的話才輸出
		        	if("".equals(responseString)){
		        		json.put("Status", "0");
		        		json.put("StatusMsg", "無資料回傳");
		        		rtnJson = json.toString();
		        	}else{
		        		logger.debug("===============responseString: " + responseString);
		        		json.put("Status", "1");
		        		json.put("data", "");
		        		//塞值
		        		JSONObject jsonRtn = JSONObject.fromObject(responseString);
		        		if(jsonRtn.containsKey("Status") && "1".equals(jsonRtn.getString("Status"))){
		        			if(jsonRtn.containsKey("projectList")){
			        			json.put("data", jsonRtn.getJSONArray("projectList"));
			        		}
		        		}
		        	}
				}
			} catch (Exception e) {
				e.printStackTrace();
				json.put("Status", "0");
        		json.put("StatusMsg", "系統錯誤");
        		rtnJson = json.toString();
			}
			
			Utils utils = new Utils();
			utils.closeHttpClient(response, client);
			
		}else{
			json.put("status", "0");
			json.put("StatusMsg", "參數錯誤");
		}
		logger.debug("projectList result: " + json.toString());
		rtnJson = json.toString();
		return SUCCESS;
	}
	
	public String netSwitch(){
		logger.debug("netSwitch:" + COMPARE_DEFAULT + selectKey);
		try {
			String jsonString = systemLookupService.getValue("mytstar", COMPARE_DEFAULT + selectKey);
			if(jsonString != ""){
				JSONObject json = JSONObject.fromObject(jsonString);
				utils.hasKey(json, "voice_on_net");
				utils.hasKey(json, "voice_off_net");
				utils.hasKey(json, "pstn");
				utils.hasKey(json, "data_usage");
				utils.hasKey(json, "sms_on_net");
				utils.hasKey(json, "sms_off_net");
				rtnJson = json.toString();
			}else{
				JSONObject json = new JSONObject();
				json.put("voice_on_net", "1");
				json.put("voice_off_net", "1");
				json.put("pstn", "1");
				json.put("data_usage", "1");
				json.put("sms_on_net", "1");
				json.put("sms_off_net", "1");
				rtnJson = json.toString();
			}
		} catch (Exception e) {
			logger.debug("netSwitch", e);
		}
		logger.debug("netSwitch rtnJson:" + rtnJson);
		return SUCCESS;
	}

	//搜尋Tstar和Compare的json內容
	@SuppressWarnings("unchecked")
	public void searchJSONValue(String json) {
		JSONObject j = JSONObject.fromObject(json);
		Iterator<String> ks = j.keys();
		while (ks.hasNext()) {
			try {
				String k = ks.next();
				if (j.get(k) instanceof JSONObject) {
//					logger.debug(k + "-obj");
					jObjSearch(j.getJSONObject(k));
				} else if (j.get(k) instanceof JSONArray) {
//					logger.debug(k + "-ary");
					jArySearch(j.getJSONArray(k));
				} else if (j.get(k) instanceof String) {
//					logger.debug(k + "-str");	
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	private void jArySearch(JSONArray a) {
		for (int k = 0; k < a.size(); k++) {
			try {
				if (a.get(k) instanceof JSONObject) {
//					logger.debug(k + "-obj");
					jObjSearch(a.getJSONObject(k));
				} else if (a.get(k) instanceof JSONArray) {
//					logger.debug(k + "-ary");
					jArySearch(a.getJSONArray(k));
				} else if (a.get(k) instanceof String) {
//					logger.debug(k + "-str");	
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	@SuppressWarnings("unchecked")
	private void jObjSearch(JSONObject o) {
		Iterator<String> ks = o.keys();
		while (ks.hasNext()) {
			try {
				String k = ks.next();
				if (o.get(k) instanceof JSONObject) {
//					logger.debug(k + "-obj");
					jObjSearch(o.getJSONObject(k));
				} else if (o.get(k) instanceof JSONArray) {
//					 logger.debug(k + "-ary");
					 if(k.equals("Po_cur_company")){
						proJsonTstar = new ProJsonTstar();
						findSearch(tStar, o.getJSONArray(k), null);
					 }
					 if(k.equals("Po_cur_competitor")){
						proJsonCompare = new ProJsonCompare();
						findSearch(getCompanyName(), o.getJSONArray(k), null);
					 }
//					logger.debug("find");
					jArySearch(o.getJSONArray(k));
				} else if (o.get(k) instanceof String) {
//					logger.debug(k + "-str");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	//要判斷找到的專案是Array還是Object
	private void findSearch(String key, JSONArray a, JSONObject o) {
//		logger.debug("findSearch:" + key + "-str");	
		if(key.equals(tStar)){
			proJsonTstar.setCompany(tStar);
			if(a.size() == 1){
				if(a.get(0) instanceof JSONObject){
					JSONObject j = a.getJSONObject(0);
					proJsonTstar.setProject_name(j.getString("Project_name"));
				}
			}else if(a.size() == 2){
				if(a.get(0) instanceof JSONObject){
					JSONObject j = a.getJSONObject(0);
					proJsonTstar.setProject_name(j.getString("Project_name"));
				}
				if(a.get(1) instanceof JSONObject){
					JSONObject j = a.getJSONObject(1);
					proJsonTstar.setSingle_project_name(j.getString("Project_name"));
				}
			}else{
				logger.debug("a.size:" + a.size());
			}
		}else if(key.equals(getCompanyName())){
			proJsonCompare.setCompany(getCompanyName());
			if(a.get(0) instanceof JSONObject){
				JSONObject j = a.getJSONObject(0);
				proJsonCompare.setProject_name(j.getString("Project_name"));
			}
		}
	}

	/*取得comparsion.jsp頁面下拉選單的值*/
	private void getSelectList(){
		/*組成comparsion.jsp頁面下拉選單的Json資料，第一層:資費範圍，第二層:選擇資費*/
		List<Object> feeTypeList = new ArrayList<Object>();
		Map<String, Object> feeTypeKeyMap = new HashMap<String, Object>();
		Map<String, Object> feeRangeKeyMap = new HashMap<String, Object>();
		Map<String, Object> feeRangeMap = new HashMap<String, Object>();
		Map<String, Object> feeSelMap = new HashMap<String, Object>();
        
        List<SelectList> selectListFee = selectListService.querySelectList("mytstar", "1", "comparsionSelect001");
        /*組第一層:資費類型*/
        for(SelectList root : selectListFee){
        	Map<String, Object> typeItemMap = new HashMap<String, Object>();
        	if("ROOT".equals(root.getParentId())){
        		typeItemMap.put("text", root.getText());
        		typeItemMap.put("value", root.getVal());
            	feeTypeList.add(typeItemMap);
            	feeTypeKeyMap.put(root.getId(), root.getVal());
        	}
        }
        /*組第二層:資費範圍*/
        for(String key : feeTypeKeyMap.keySet()){
        	List<Object> feeRangeList = new ArrayList<Object>();
        	for(SelectList list : selectListFee){
            	Map<String, Object> rangeItemMap = new HashMap<String, Object>();
            	if(key.equals(list.getParentId())){
            		rangeItemMap.put("text", list.getText());
                	rangeItemMap.put("value", list.getId());
                	feeRangeList.add(rangeItemMap);
                	feeRangeKeyMap.put(list.getId(), list.getVal());
            	}
            }
        	//key=parentId, value=list of select
        	feeRangeMap.put((String)feeTypeKeyMap.get(key), feeRangeList);
        }
        
        /*組第三層:選擇資費*/
        for(String key : feeRangeKeyMap.keySet()){
        	List<Object> feeSelList = new ArrayList<Object>();
        	for(SelectList list : selectListFee){
            	Map<String, Object> selItemMap = new HashMap<String, Object>();
            	if(key.equals(list.getParentId())){
            		selItemMap.put("text", list.getText());
            		selItemMap.put("value", list.getVal());
            		feeSelList.add(selItemMap);
            	}
            }
        	//key=parentId, value=list of select
        	feeSelMap.put(key, feeSelList);
        }
        
        /*組成comparsion.jsp頁面下拉選單的Json資料，第一層:選擇其他電信業者*/
        Map<String, Object> companySelMap = new HashMap<String, Object>();
        List<Object> companySelList = new ArrayList<Object>();
        
        List<SelectList> selectListCo = selectListService.querySelectList("mytstar", "1", "comparsionSelect002");
        for(SelectList root : selectListCo){
        	/*組第一層:選擇其他電信業者*/
        	Map<String, Object> companySelItemMap = new HashMap<String, Object>();
        	companySelItemMap.put("text", root.getText());
        	companySelItemMap.put("value", root.getVal());
        	companySelList.add(companySelItemMap);
        }
        companySelMap.put("companySel", companySelList);
        
        JSONObject json = JSONObject.fromObject(feeRangeMap);//將map對象轉換成json類型數據
        feeRangeData = json.toString();//給result賦值，傳遞給頁面
        
        json = JSONObject.fromObject(feeSelMap);//將map對象轉換成json類型數據
        feeSelData = json.toString();//給result賦值，傳遞給頁面
        
        json = JSONObject.fromObject(companySelMap);//將map對象轉換成json類型數據
        companySelData = json.toString();//給result賦值，傳遞給頁面
        
        JSONArray jsonArray = JSONArray.fromObject(feeTypeList);//將map對象轉換成json類型數據
        typeSelData = jsonArray.toString();//給result賦值，傳遞給頁面
        
        Map<String, String> map = getCompareMobile();
        JSONArray jsonAry = JSONArray.fromObject(map);
        mobileDataJson = jsonAry.toString();//給result賦值，傳遞給頁面
        mobileData = new HashMap<String, String>();
        mobileData.putAll(map);
        
//        如果用戶登入，載入三個月內門號平均資料
//        request = new JSONObject();
//        try {
//            if(StringUtils.isNotBlank(token) && !StringUtils.equals("back", loginDefault)){
//                JSONObject requestDefault = new JSONObject();
//                requestDefault.put("token", token);
//                requestDefault.put("contractId", contractId);
//                requestDefault.put("msisdn", msisdn);
//                
//                request.put("moduleName", "myviboadmin");
//                request.put("data", encriptinSimple.encrypt(requestDefault.toString()));
//                loginDefault = utils.apiRequest(
//                		new PropertiesUtil().getProperty("tagUrl") + "TAG/rest/frontend/getCustProfile", request.toString());
//                logger.info("loginDefault: " + loginDefault);
//                
//                if(StringUtils.isNotBlank(loginDefault)){
//                    JSONObject responseDefault = JSONObject.fromObject(loginDefault);
//                    if(StringUtils.equals("9999", responseDefault.optString("code"))){
//                    	loginDefault = "";
//                    	logger.debug("Response error: " + responseDefault.optString("message"));
//                    }else{
//                    	JSONObject data = JSONObject.fromObject(responseDefault.optString("data"));
//                        JSONArray estoreCdrInfoResList = JSONArray.fromObject(data.optString("estoreCdrInfoResList"));
//                        
//                        int total = estoreCdrInfoResList.size();
//                        double onnetModur = 0;
//                        double offnetModur = 0;
//                        double fixedlineModur = 0;
//                        double iaVol = 0;
//                        double smsMoCnt = 0;
//                        double smsMtCnt = 0;
//                        Iterator<?> iterator = estoreCdrInfoResList.iterator();
//                        while(iterator.hasNext()){
//                        	JSONObject contractJson = JSONObject.fromObject(iterator.next().toString());
//                            onnetModur += Double.valueOf(
//                            		(StringUtils.equals("null", contractJson.optString("onnetModur")) ? "0" : contractJson.optString("onnetModur")));
//                            offnetModur += Double.valueOf(
//                            		(StringUtils.equals("null", contractJson.optString("offnetModur")) ? "0" : contractJson.optString("offnetModur")));
//                            fixedlineModur += Double.valueOf(
//                            		(StringUtils.equals("null", contractJson.optString("fixedlineModur")) ? "0" : contractJson.optString("fixedlineModur")));
//                            iaVol += Double.valueOf(
//                            		(StringUtils.equals("null", contractJson.optString("iaVol")) ? "0" : contractJson.optString("iaVol")));
//                            smsMoCnt += Double.valueOf(
//                            		(StringUtils.equals("null", contractJson.optString("smsMoCnt")) ? "0" : contractJson.optString("smsMoCnt")));
//                            smsMtCnt += Double.valueOf(
//                            		(StringUtils.equals("null", contractJson.optString("smsMtCnt")) ? "0" : contractJson.optString("smsMtCnt")));
//                        }
//                        
//                        //算出平均值(回傳幾筆資料就除以幾筆)取小數點後兩位
//                        DecimalFormat df = new DecimalFormat("###,###.##");
//                        JSONObject defaultJson = new JSONObject();
//                        defaultJson.put("onnetModur", df.format((onnetModur / total)));
//                        defaultJson.put("offnetModur", df.format((offnetModur / total)));
//                        defaultJson.put("fixedlineModur", df.format((fixedlineModur / total)));
//                        defaultJson.put("iaVol", df.format((iaVol / total)));
//                        defaultJson.put("smsMoCnt", df.format((smsMoCnt / total)));
//                        defaultJson.put("smsMtCnt", df.format((smsMtCnt / total)));
//                        logger.debug("defaultJson: " + defaultJson);
//                        loginDefault = defaultJson.toString();	
//                    }
//                }
//            }else if(StringUtils.equals("back", loginDefault)){//用戶登入後從結果頁返回選擇頁時將預設資料帶回選擇頁
//            	JSONObject tmpJson = new JSONObject();
//				utils.hasKey(json, "voice_on_net");
//				utils.hasKey(json, "voice_off_net");
//				utils.hasKey(json, "pstn");
//				utils.hasKey(json, "data_usage");
//				utils.hasKey(json, "sms_on_net");
//				utils.hasKey(json, "sms_off_net");
//            	tmpJson.put("onnetModur", tmp.getVoice_on_net());
//            	tmpJson.put("offnetModur",  tmp.getVoice_off_net());
//            	tmpJson.put("fixedlineModur",  tmp.getPstn());
//            	tmpJson.put("iaVol",  tmp.getData_usage());
//            	tmpJson.put("smsMoCnt",  tmp.getSms_on_net());
//            	tmpJson.put("smsMtCnt",  tmp.getSms_off_net());
//                loginDefault = tmpJson.toString();	
//            }
//		} catch (Exception e) {
//			logger.error("取得預設用戶資料", e);
//		}
	}
	
    public String getCompanyName(){
    	if("1".equals(company_sel)){
			return "台灣之星";
		}else if("2".equals(company_sel)){
			return "中華電信";
		}else if("3".equals(company_sel)){
			return "遠傳電信";
		}else if("4".equals(company_sel)){
			return "台灣大哥大";
		}else if("5".equals(company_sel)){
			return "亞太電信";
		}
    	return "";
    }
    
    public Map<String, String> getCompareMobile(){
    	Map<String, String> map = new HashMap<String, String>();
    	//取得所有手機
    	List<Projects> projectsList = comparsionService.getAllProjects();
    	List<String> projectsIdList = new ArrayList<String>();
    	for(Projects projects: projectsList){
    		projectsIdList.add(projects.getId());
		}
    	
    	List<RateProjects> rateProjectsList = comparsionService.queryRateProjectsByProjectsId(projectsIdList);
    	
		//過濾重覆
    	for(RateProjects RateProjects : rateProjectsList){
    		for(Projects projects: projectsList){
    			if(RateProjects.getProjectId().equals(projects.getId())){
    				map.put(projects.getId(), projects.getName());
    			}
    		}
    	}
    	logger.debug("過濾重覆:" + rateProjectsList.size());
    	logger.debug("result:" + map);
		
    	return map;
    }
    
    public String getPsString(){
    	return systemLookupService.getValue("mytstar", "app_compare_ps");
    }
    
 
	public void setCompany_sel(String company_sel) {
		this.company_sel = company_sel;
	}
	public void setFee_sel(String fee_sel) {
		this.fee_sel = fee_sel;
	}

	public ProjectRate getProjectRateChosen() {
		return projectRateChosen;
	}

	public ProjectRate getProjectRateTstar() {
		return projectRateTstar;
	}

	public String getCompany_sel() {
		return company_sel;
	}

	public String getFee_sel() {
		return fee_sel;
	}

	public String getFee_range() {
		return fee_range;
	}

	public void setFee_range(String fee_range) {
		this.fee_range = fee_range;
	}

	public Map<String, ProjectDeviceDto> getProjectDevicemap() {
		return projectDevicemap;
	}
	
	public String getFeeRangeData() {
		return feeRangeData;
	}

	public void setFeeRangeData(String feeRangeData) {
		this.feeRangeData = feeRangeData;
	}

	public String getFeeSelData() {
		return feeSelData;
	}

	public void setFeeSelData(String feeSelData) {
		this.feeSelData = feeSelData;
	}
	
	public String getCompanySelData() {
		return companySelData;
	}

	public void setCompanySelData(String companySelData) {
		this.companySelData = companySelData;
	}


	public List<ProjectDeviceDto> getProjectDeviceDtoOrder() {
		return ProjectDeviceDtoOrder;
	}

	public void setProjectDeviceDtoOrder(
			List<ProjectDeviceDto> projectDeviceDtoOrder) {
		ProjectDeviceDtoOrder = projectDeviceDtoOrder;
	}


	public String getTypeSelData() {
		return typeSelData;
	}

	public String getFee_type() {
		return fee_type;
	}

	public void setFee_type(String fee_type) {
		this.fee_type = fee_type;
	}
	
	public String getTab() {
		return tab;
	}

	public void setTab(String tab) {
		this.tab = tab;
	}

	public String getCalRule() {
		return calRule;
	}

	public void setCalRule(String calRule) {
		this.calRule = calRule;
	}


	public String getFee_sel1() {
		return fee_sel1;
	}

	public void setFee_sel1(String fee_sel1) {
		this.fee_sel1 = fee_sel1;
	}

	public String getFee_sel2() {
		return fee_sel2;
	}

	public void setFee_sel2(String fee_sel2) {
		this.fee_sel2 = fee_sel2;
	}


	public QueryCompareProjectDto getQueryCompareProject2Dto() {
		return queryCompareProject2Dto;
	}

	public void setQueryCompareProject2Dto(
			QueryCompareProjectDto queryCompareProject2Dto) {
		this.queryCompareProject2Dto = queryCompareProject2Dto;
	}

	public QueryCompareProjectDto getQueryCompareProject1Dto() {
		return queryCompareProject1Dto;
	}

	public void setQueryCompareProject1Dto(
			QueryCompareProjectDto queryCompareProject1Dto) {
		this.queryCompareProject1Dto = queryCompareProject1Dto;
	}

	public String getRtnJson() {
		return rtnJson;
	}

	public String getCompany() {
		return company;
	}

	public void setCompany(String company) {
		this.company = company;
	}

	public Map<String, String> getMobileData() {
		return mobileData;
	}

	public void setMobileData(Map<String, String> mobileData) {
		this.mobileData = mobileData;
	}

	public ProJsonTstar getProJsonTstar() {
		return proJsonTstar;
	}

	public void setProJsonTstar(ProJsonTstar proJsonTstar) {
		this.proJsonTstar = proJsonTstar;
	}

	public ProJsonCompare getProJsonCompare() {
		return proJsonCompare;
	}

	public void setProJsonCompare(ProJsonCompare proJsonCompare) {
		this.proJsonCompare = proJsonCompare;
	}

	public String getChooseDeviceName() {
		return chooseDeviceName;
	}

	public void setChooseDeviceName(String chooseDeviceName) {
		this.chooseDeviceName = chooseDeviceName;
	}

	public String getPriceTstar() {
		return priceTstar;
	}

	public void setPriceTstar(String priceTstar) {
		this.priceTstar = priceTstar;
	}

	public String getSinglePhoneTstar() {
		return singlePhoneTstar;
	}

	public void setSinglePhoneTstar(String singlePhoneTstar) {
		this.singlePhoneTstar = singlePhoneTstar;
	}

	public String getApplyType() {
		return applyType;
	}

	public void setApplyType(String applyType) {
		this.applyType = applyType;
	}

	public String getPrepaymentAmountTstar() {
		return prepaymentAmountTstar;
	}

	public void setPrepaymentAmountTstar(String prepaymentAmountTstar) {
		this.prepaymentAmountTstar = prepaymentAmountTstar;
	}

	public String getPriceChoose() {
		return priceChoose;
	}

	public void setPriceChoose(String priceChoose) {
		this.priceChoose = priceChoose;
	}

	public String getPrepaymentAmountChoose() {
		return prepaymentAmountChoose;
	}

	public void setPrepaymentAmountChoose(String prepaymentAmountChoose) {
		this.prepaymentAmountChoose = prepaymentAmountChoose;
	}

	public String getSinglePhoneChosen() {
		return singlePhoneChosen;
	}

	public void setSinglePhoneChosen(String singlePhoneChosen) {
		this.singlePhoneChosen = singlePhoneChosen;
	}

	public String getMobileDataJson() {
		return mobileDataJson;
	}

	public void setMobileDataJson(String mobileDataJson) {
		this.mobileDataJson = mobileDataJson;
	}

	public String getSelectKey() {
		return selectKey;
	}

	public void setSelectKey(String selectKey) {
		this.selectKey = selectKey;
	}

	public String getProtectWord() {
		return protectWord;
	}

	public void setProtectWord(String protectWord) {
		this.protectWord = protectWord;
	}

	public QueryCompareProjectDto getTmp() {
		return tmp;
	}

	public void setTmp(QueryCompareProjectDto tmp) {
		this.tmp = tmp;
	}

//	public String getContractId() {
//		return contractId;
//	}
//
//	public void setContractId(String contractId) {
//		this.contractId = contractId;
//	}
//
//	public String getLoginDefault() {
//		return loginDefault;
//	}
//
//	public void setLoginDefault(String loginDefault) {
//		this.loginDefault = loginDefault;
//	}
//
//	public String getToken() {
//		return token;
//	}
//
//	public void setToken(String token) {
//		this.token = token;
//	}
//
//	public String getMsisdn() {
//		return msisdn;
//	}
//
//	public void setMsisdn(String msisdn) {
//		this.msisdn = msisdn;
//	}
}