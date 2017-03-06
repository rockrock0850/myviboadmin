package com.tstar.action;

import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.apache.axis.utils.StringUtils;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.Action;
import com.tstar.model.tapp.Projects;
import com.tstar.model.tapp.RateProjects;
import com.tstar.model.tapp.SystemLookup;
import com.tstar.model.tapp.TelecomRate;
import com.tstar.service.ComparsionService;
import com.tstar.service.SystemLookupService;

@Component
@Scope("prototype")
public class EditCompareDataAction implements Action{
	
	private final Logger logger = Logger.getLogger(EditCompareDataAction.class);
	
	@Autowired
	private ComparsionService comparsionService;
	
	@Autowired
	private SystemLookupService systemLookupService;
	
	private TelecomRate telecomRate;
	private List<Projects> projectsList;
	private List<RateProjects> rateProjectsList;
	private List<TelecomRate> telecomRateList;
	private String queryStart;
	private String queryEnd;
	private String qryTelecomId;
	private String qryTelecomName;
	private String telecomRateId;
	private String psString;
	private String actionMethod;
	private String showMsg;
	
	   
	public String execute(){
		logger.info("actionMethod:" + actionMethod);
		
		//修改說明文字
		if("editPs".equals(actionMethod)){
			logger.info("修改說明文字");
			SystemLookup systemLookup = new SystemLookup();
			systemLookup.setKey("app_compare_ps");
			systemLookup.setValue(psString);
			Date date = new Date();
			systemLookup.setUpdateTime(new Timestamp(date.getTime()));
			systemLookup.setServiceId("mytstar");
			
			systemLookupService.updateSystemLookup(systemLookup);
		}else{
			if(!isInteger(queryStart)){
				queryStart = "-9999";
			}
			
			if(!isInteger(queryEnd)){
				queryEnd = "9999";
			}
			
			if(null != qryTelecomId && !StringUtils.isEmpty(qryTelecomId)){
				logger.info("qryTelecomId: " + qryTelecomId);
				telecomRateList = comparsionService.queryTelecomRateByRange(qryTelecomId, Integer.parseInt(queryStart), Integer.parseInt(queryEnd));
			}else{
				logger.info("第一次進入");
			}
			
			//轉換系統別
			if("1".equals(qryTelecomId)){
				qryTelecomName = "台灣之星";
			}else if("2".equals(qryTelecomId)){
				qryTelecomName = "中華電信";
			}else if("3".equals(qryTelecomId)){
				qryTelecomName = "遠傳電信";
			}else if("4".equals(qryTelecomId)){
				qryTelecomName = "台灣大哥大";
			}else if("5".equals(qryTelecomId)){
				qryTelecomName = "亞太電信";
			}
		}
		
		//說明文字
		psString = systemLookupService.getValue("mytstar", "app_compare_ps");
		
    	return SUCCESS;
    }
	
	//取得要異動的telecomRate資料
	public String editData(){
		if(!StringUtils.isEmpty(telecomRateId)){
			telecomRate = comparsionService.queryTelecomRateById(telecomRateId);
			rateProjectsList = comparsionService.queryRateProjectsByRateId(telecomRateId);
		}
		
		projectsList = comparsionService.getAllProjects();
    	return SUCCESS;
	}
	
	//保存異動資料
	/**
	 * @return
	 */
	public String saveData(){
		logger.info("telecomRate: " + ToStringBuilder.reflectionToString(telecomRate));
		if(null != rateProjectsList){
			for(RateProjects rateProjects :rateProjectsList){
				logger.info("rateProjects: " + ToStringBuilder.reflectionToString(rateProjects));
			}
		}
		
		try{		
			if(null != telecomRate && !StringUtils.isEmpty(telecomRate.getName())){
				String id = "";
				boolean isNew = true;
				if(null == telecomRate || StringUtils.isEmpty(telecomRate.getId())){
					id = Calendar.getInstance().getTimeInMillis() + "";
					telecomRate.setId(id);
				}else{
					isNew = false;
					id = telecomRate.getId();
				}
				//新資料全部新增
				if(isNew){
					if(null != rateProjectsList){
						int i = 0;
						logger.info("rateProjectsList.size: " + rateProjectsList.size());
						for(RateProjects rateProjects :rateProjectsList){
							rateProjects.setId(id + i);
							rateProjects.setRateId(id);
							i++;
						}
					}
					comparsionService.insertNewProjectRate(telecomRate, rateProjectsList);
				}else{
					logger.info("getContractMonths: " + telecomRate.getContractMonths());
					//更新TelecomRate
					comparsionService.updateTelecomRate(telecomRate);
					
					if(null != rateProjectsList){
						logger.info("rateProjectsList.size: " + rateProjectsList.size());
						for(RateProjects rateProjects :rateProjectsList){
							if(null != rateProjects && null != rateProjects.getPrice()){
								//有id代表是舊資料
								if(!StringUtils.isEmpty(rateProjects.getId())){
									rateProjects.setRateId(id);
									logger.info("更新 rateProjects: " + rateProjects.getRateId());
									comparsionService.updateRateProjects(rateProjects);
								}else{
									//流水號產生
									int random = (int)(Math.random()*1000);
									String rateProjectsId = Calendar.getInstance().getTimeInMillis() + "" + random;
									
									rateProjects.setId(rateProjectsId);
									rateProjects.setRateId(id);
									logger.info("新增rateProjects: " + rateProjects.getRateId());
									comparsionService.insertRateProjects(rateProjects);
								}
							}
						}
					}
					
					comparsionService.updateProjectRate(telecomRate, rateProjectsList);
				}
			}
		}catch(Exception e){
			showMsg = "異動失敗，請洽系統人員!";
			e.printStackTrace();
		}
		
    	return execute();
    }
	
	private boolean isInteger(String s) {
	    try { 
	        Integer.parseInt(s); 
	    } catch(NumberFormatException e) { 
	        return false; 
	    }
	    // only got here if we didn't return false
	    return true;
	}

	
	public TelecomRate getTelecomRate() {
		return telecomRate;
	}

	public void setTelecomRate(TelecomRate telecomRate) {
		this.telecomRate = telecomRate;
	}

	public List<Projects> getProjectsList() {
		return projectsList;
	}

	public void setRateProjectsList(List<RateProjects> rateProjectsList) {
		this.rateProjectsList = rateProjectsList;
	}

	public List<RateProjects> getRateProjectsList() {
		return rateProjectsList;
	}

	public String getQueryStart() {
		return queryStart;
	}

	public void setQueryStart(String queryStart) {
		this.queryStart = queryStart;
	}

	public String getQueryEnd() {
		return queryEnd;
	}

	public void setQueryEnd(String queryEnd) {
		this.queryEnd = queryEnd;
	}

	public String getQryTelecomId() {
		return qryTelecomId;
	}

	public void setQryTelecomId(String qryTelecomId) {
		this.qryTelecomId = qryTelecomId;
	}

	public List<TelecomRate> getTelecomRateList() {
		return telecomRateList;
	}

	public String getQryTelecomName() {
		return qryTelecomName;
	}

	public void setTelecomRateId(String telecomRateId) {
		this.telecomRateId = telecomRateId;
	}

	public String getPsString() {
		return psString;
	}

	public void setPsString(String psString) {
		this.psString = psString;
	}

	public void setActionMethod(String actionMethod) {
		this.actionMethod = actionMethod;
	}

	public String getShowMsg() {
		return showMsg;
	}
}
