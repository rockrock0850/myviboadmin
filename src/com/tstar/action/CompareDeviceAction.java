package com.tstar.action;

import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.builder.ReflectionToStringBuilder;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.Action;
import com.tstar.model.tapp.Projects;
import com.tstar.model.tapp.RateProjects;
import com.tstar.service.ComparsionService;

@Component
@Scope("prototype")
public class CompareDeviceAction implements Action{
	
	private final Logger logger = Logger.getLogger(CompareDeviceAction.class);
	
	private String queryStr;
	private String queryStatus;
	private String actionMethod;
	private String projectRateId;
	private String newProjectRateId;
	private List<RateProjects> rateProjectsList;
	private List<Projects> projectsList;
	private String showMsg;
	private String jsonStr;
	
	@Autowired
	private ComparsionService comparsionService;
	
	public String execute(){
		
		if("query".equals(actionMethod)){
			if(!StringUtils.isEmpty(queryStr)){
				rateProjectsList = comparsionService.queryRateProjects(queryStr, true, queryStatus);
				logger.info("原始資料:" + ReflectionToStringBuilder.toString(rateProjectsList));
				//取得所有手機
				projectsList = comparsionService.getAllProjects();
				//過濾STATUS
				for(int i = 0; i < rateProjectsList.size(); i++){
					RateProjects rateProjects = rateProjectsList.get(i);
					boolean projectExist = false;
					for(Projects projects: projectsList){
						if(projects.getId().equals(rateProjects.getProjectId())){
							projectExist = true;
						}
					}
					
					if(!projectExist){
						rateProjectsList.remove(i);
						i--;
					}
				}
				logger.info("過濾停用:" + ReflectionToStringBuilder.toString(rateProjectsList));
				
				//過濾重覆
				Map<String, String> map = new HashMap<String, String>();
				for(int i = 0; i < rateProjectsList.size(); i++){
					RateProjects rateProjects = rateProjectsList.get(i);
					//移除非資費試算的資料
					if(!"Y".equals(rateProjects.getLinkToBilling())){
						rateProjectsList.remove(i);
						i--;
					}else{
						if(!map.containsKey(rateProjects.getRateId())){
							map.put(rateProjects.getRateId(), rateProjects.getRateId());
						}else{
							rateProjectsList.remove(i);
							i--;
						}
					}
				}
				logger.info("過濾重覆:" + ReflectionToStringBuilder.toString(rateProjectsList));
			}
		}else if("edit".equals(actionMethod)){
			//編輯舊有資料
			if(StringUtils.isNotBlank(projectRateId)){
				rateProjectsList = comparsionService.queryRateProjectsByRateId(projectRateId);
				logger.info("原始資料:" + ReflectionToStringBuilder.toString(rateProjectsList));
				//移除非資費試算的資料
				for(int i = 0; i < rateProjectsList.size(); i++){
					RateProjects rateProjects = rateProjectsList.get(i);
					logger.info("資料:" + ReflectionToStringBuilder.toString(rateProjects));
					if(rateProjects != null && !"Y".equals(rateProjects.getLinkToBilling())){
						rateProjectsList.remove(i);
						i--;
					}
				}
				logger.info("非資費試算的資料:" + ReflectionToStringBuilder.toString(rateProjectsList));
			}
			projectsList = comparsionService.getAllProjects();
		}else{
			rateProjectsList = null;
		}
		
    	return SUCCESS;
    }
	
	//保存異動資料
	public String saveData(){
		if(null != rateProjectsList){
			for(RateProjects rateProjects :rateProjectsList){
				logger.info("rateProjects: " + ToStringBuilder.reflectionToString(rateProjects));
			}
		}
		
		try{		
			boolean isNew = true;
			if(null != projectRateId && StringUtils.isNotBlank(projectRateId)){
				isNew = false;
			}
			logger.info("isNew: " + isNew + " newProjectRateId: " + newProjectRateId);
			//新資料全部新增
			if(isNew){
				if(null != rateProjectsList){
					int i = 0;
					logger.info("rateProjectsList.size: " + rateProjectsList.size());
					for(RateProjects rateProjects :rateProjectsList){
						rateProjects.setId(newProjectRateId + i);
						rateProjects.setRateId(newProjectRateId);
						rateProjects.setLinkToBilling("Y");
						comparsionService.insertRateProjects(rateProjects);
						i++;
					}
				}
			}else{
				if(null != rateProjectsList){
					logger.info("rateProjectsList.size: " + rateProjectsList.size());
					for(RateProjects rateProjects :rateProjectsList){
						if(null != rateProjects && null != rateProjects.getPrice()){
							//有id代表是舊資料
							if(!StringUtils.isEmpty(rateProjects.getId())){
								rateProjects.setRateId(projectRateId);
								rateProjects.setLinkToBilling("Y");
								logger.info("更新 rateProjects: " + rateProjects.getId());
								comparsionService.updateRateProjects(rateProjects);
							}else{
								//流水號產生
								int random = (int)(Math.random()*1000);
								String rateProjectsId = Calendar.getInstance().getTimeInMillis() + "" + random;
								
								rateProjects.setId(rateProjectsId);
								rateProjects.setRateId(projectRateId);
								rateProjects.setLinkToBilling("Y");
								logger.info("新增rateProjects: " + rateProjects.getRateId());
								comparsionService.insertRateProjects(rateProjects);
							}
						}
					}
				}
			}
			showMsg = "更新成功!";
		}catch(Exception e){
			showMsg = "異動失敗，請洽系統人員!";
			e.printStackTrace();
		}
		
    	return execute();
    }
	
	public String checkProjectRateId(){
		JSONObject json = new JSONObject();
		try {
			if(StringUtils.isNotBlank(projectRateId)){
				List<RateProjects> rateProjectsList = comparsionService.queryRateProjects(projectRateId, false, "");
				if(rateProjectsList != null && 0 < rateProjectsList.size()){
					json.put("isExist", true);
				}else{
					json.put("isExist", false);
				}
			}
		} catch (JSONException e) {
			try {
				json.put("isExist", true);
			} catch (JSONException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
		}
		jsonStr = json.toString();
		return SUCCESS;
	}
	
	public String getQueryStr() {
		return queryStr;
	}

	public void setQueryStr(String queryStr) {
		this.queryStr = queryStr;
	}

	public String getQueryStatus() {
		return queryStatus;
	}

	public void setQueryStatus(String queryStatus) {
		this.queryStatus = queryStatus;
	}




	public List<RateProjects> getRateProjectsList() {
		return rateProjectsList;
	}




	public void setRateProjectsList(List<RateProjects> rateProjectsList) {
		this.rateProjectsList = rateProjectsList;
	}




	public void setActionMethod(String actionMethod) {
		this.actionMethod = actionMethod;
	}




	public List<Projects> getProjectsList() {
		return projectsList;
	}




	public void setProjectRateId(String projectRateId) {
		this.projectRateId = projectRateId;
	}




	public String getProjectRateId() {
		return projectRateId;
	}

	public String getShowMsg() {
		return showMsg;
	}

	public void setNewProjectRateId(String newProjectRateId) {
		this.newProjectRateId = newProjectRateId;
	}

	public String getJsonStr() {
		return jsonStr;
	}
}
