package com.tstar.action;

import java.util.Calendar;
import java.util.List;

import org.apache.axis.utils.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.Action;
import com.tstar.model.tapp.Devices;
import com.tstar.model.tapp.Projects;
import com.tstar.service.ProjectsService;

@Component
@Scope("prototype")
public class QueryDeviceAction implements Action{
	
	private final Logger logger = Logger.getLogger(QueryDeviceAction.class);
	
	private String queryStr;
	private String queryStatus;
	private List<Projects> projectsList;
	
	@Autowired
	private ProjectsService projectsService;
	
	public String execute(){
		
		if(!StringUtils.isEmpty(queryStr)){
			projectsList = projectsService.queryProjectsByLike(queryStr, queryStatus);
		}
		
    	return SUCCESS;
    }
	
	public String saveData(){
		if(null != projectsList){
			String id = "";
			
			for(Projects projects : projectsList){
				logger.info("projectsList.size: " + projectsList.size());
				if(null != projects && !StringUtils.isEmpty(projects.getName())){
					boolean isNew = true;
					if(null == projects || StringUtils.isEmpty(projects.getId())){
						id = Calendar.getInstance().getTimeInMillis() + "";
						projects.setId(id);
					}else{
						isNew = false;
						id = projects.getId();
					}
					projects.setDeviceId(id);
					
					Devices devices = new Devices();
					devices.setId(id);
					devices.setDeviceModel(projects.getName());
					devices.setName(projects.getName());
					
					if(isNew){
						projectsService.insertProjectsAndDevice(projects, devices);
					}else{
						projectsService.updateProjectsAndDevice(projects, devices);
					}
				}
			}
			projectsList.clear();
		}
		
    	return SUCCESS;
    }
	
	
	public String getQueryStr() {
		return queryStr;
	}

	public void setQueryStr(String queryStr) {
		this.queryStr = queryStr;
	}

	public List<Projects> getProjectsList() {
		return projectsList;
	}

	public void setProjectsList(List<Projects> projectsList) {
		this.projectsList = projectsList;
	}

	public String getQueryStatus() {
		return queryStatus;
	}

	public void setQueryStatus(String queryStatus) {
		this.queryStatus = queryStatus;
	}

}
