package com.tstar.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;

import com.tstar.dao.custom.CustomMapper;
import com.tstar.dao.tapp.ProjectsMapper;
import com.tstar.dao.tapp.RateProjectsMapper;
import com.tstar.dao.tapp.TelecomRateMapper;
import com.tstar.model.custom.ProjectDevice;
import com.tstar.model.custom.ProjectRate;
import com.tstar.model.tapp.Projects;
import com.tstar.model.tapp.ProjectsExample;
import com.tstar.model.tapp.ProjectsExample.Criteria;
import com.tstar.model.tapp.RateProjects;
import com.tstar.model.tapp.RateProjectsExample;
import com.tstar.model.tapp.TelecomRate;
import com.tstar.model.tapp.TelecomRateExample;
import com.tstar.service.ComparsionService;

@Controller
@Transactional("transactionManager")
public class ComparsionServiceImpl implements ComparsionService{
	
	@Autowired
	private CustomMapper customMapper;
	
	@Autowired
	private ProjectsMapper projectsMapper;
	
	@Autowired
	TelecomRateMapper telecomRateMapper;
	
	@Autowired
	RateProjectsMapper rateProjectsMapper;
	
	
	public List<ProjectRate> comparseProject(String telId, String upperFee, String lowerFee, String feeType){
		Map<String, String> map = new HashMap<String, String>();
		map.put("telId", telId);
		map.put("upperFee", upperFee);
		map.put("lowerFee", lowerFee);
		map.put("feeType", feeType);
		List<ProjectRate> projectRateList = customMapper.queryProject(map);
		
		return projectRateList;
	};
	
	public ProjectRate comparseProjectSelectMax(String telId, String upperFee, String lowerFee){
		
		ProjectRate projectRate = new ProjectRate();
		
		List<ProjectRate> projectRateList = comparseProject(telId, upperFee, lowerFee, null);
		for(ProjectRate pr : projectRateList){
			if(null == projectRate.getChargesMonth() || 
					Integer.parseInt(projectRate.getChargesMonth()) < Integer.parseInt(pr.getChargesMonth())){
				projectRate = pr;
			}
		}
		return projectRate;
	};
	
	public ProjectRate comparseProjectSelectMax(String telId, String upperFee, String lowerFee, String feeType){
		
		ProjectRate projectRate = new ProjectRate();
		
		List<ProjectRate> projectRateList = comparseProject(telId, upperFee, lowerFee, feeType);
		for(ProjectRate pr : projectRateList){
			if(null == projectRate.getChargesMonth() || 
					Integer.parseInt(projectRate.getChargesMonth()) < Integer.parseInt(pr.getChargesMonth())){
				projectRate = pr;
			}
		}
		return projectRate;
	};
	
	public ProjectRate comparseProjectSelectMin(String telId, String upperFee, String lowerFee, String feeType){
		
		ProjectRate projectRate = new ProjectRate();
		
		List<ProjectRate> projectRateList = comparseProject(telId, upperFee, lowerFee, feeType);
		for(ProjectRate pr : projectRateList){
			System.out.println("==pr.getChargesMonth(): " + pr.getChargesMonth());
			if(null == projectRate.getChargesMonth() || 
					Integer.parseInt(projectRate.getChargesMonth()) > Integer.parseInt(pr.getChargesMonth())){
				projectRate = pr;
			}
		}
		return projectRate;
	};
	
	public List<ProjectDevice> getProjectByRateId(String rateId){
		Map<String, String> map = new HashMap<String, String>();
		map.put("rateId", rateId);
		List<ProjectDevice> ProjectDevice = customMapper.queryProjectByRateId(map);
		
		return ProjectDevice;
	}

	public List<Projects> getAllProjects() {
		ProjectsExample example = new ProjectsExample();
		Criteria criteria = example.createCriteria();
		criteria.andStatusEqualTo("1");
		List<Projects> projectsList = projectsMapper.selectByExample(example);
		
		return projectsList;
	}
	
	/*
	 * Short one line description
	 * <p>
	 * Longer description. If there were any, it would be
     * @param telecomRate
     * @return boolean
	 * @see 更新TelecomRate資料
	 */
	public boolean updateTelecomRate(TelecomRate telecomRate) {
		int result = telecomRateMapper.updateByPrimaryKey(telecomRate);
		
		return 0 < result ? true : false;
	}

	@Override
	public boolean insertRateProjects(RateProjects rateProjects) {
		int result = rateProjectsMapper.insert(rateProjects);
		
		return 0 < result ? true : false;
	}

	@Override
	public boolean updateRateProjects(RateProjects rateProjects) {
		int result = rateProjectsMapper.updateByPrimaryKey(rateProjects);
		
		return 0 < result ? true : false;
	}

	public boolean insertNewProjectRate(TelecomRate telecomRate, List<RateProjects> rateProjectsList) {
		int result = telecomRateMapper.insert(telecomRate);
		
		if(0 < result){
			for(RateProjects rateProjects :rateProjectsList){
				result = rateProjectsMapper.insert(rateProjects);
				if(1 > result){
					continue;
				}
			}
		}
		
		return 0 < result ? true : false;
	}
	
	@Override
	public boolean updateProjectRate(TelecomRate telecomRate, List<RateProjects> rateProjectsList) {
		int result = telecomRateMapper.updateByPrimaryKey(telecomRate);
		
		if(0 < result){
			for(RateProjects rateProjects :rateProjectsList){
				result = rateProjectsMapper.updateByPrimaryKey(rateProjects);
				if(1 > result){
					continue;
				}
			}
		}
		
		return 0 < result ? true : false;
	}

	public List<TelecomRate> queryTelecomRateByRange(String qryTelecomId, int queryStart, int queryEnd) {
		TelecomRateExample example = new TelecomRateExample();
		com.tstar.model.tapp.TelecomRateExample.Criteria criteria = example.createCriteria();
		criteria.andTelecomIdEqualTo(qryTelecomId);
		criteria.andChargesMonthBetween(queryStart, queryEnd);
		
		List<TelecomRate> telecomRateList = telecomRateMapper.selectByExample(example);
		
		return telecomRateList;
	}

	@Override
	public TelecomRate queryTelecomRateById(String id) {
		
		TelecomRate telecomRate = telecomRateMapper.selectByPrimaryKey(id);
		
		return telecomRate;
	}

	@Override
	public List<RateProjects> queryRateProjectsByRateId(String rateId) {
		List<RateProjects> rateProjectsList = customMapper.queryRateProjectsByRateId(rateId);
		
		return rateProjectsList;
	}
	
	public List<RateProjects> queryRateProjects(String rateId, boolean isLike, String status){
		RateProjectsExample example = new RateProjectsExample();
		com.tstar.model.tapp.RateProjectsExample.Criteria criteria = example.createCriteria();
		if(isLike){
			criteria.andRateIdLike("%" + rateId + "%");
		}else{
			criteria.andRateIdEqualTo(rateId);
		}
		
		if(StringUtils.isNotBlank(status)){
			criteria.andStatusEqualTo(status);
		}
		
		List<RateProjects> rateProjectsList = rateProjectsMapper.selectByExample(example);
		
		return rateProjectsList;
	}
	
	public List<RateProjects> queryRateProjectsByProjectsId(List<String> rateIdList){
		List<RateProjects> testList = customMapper.queryRateProjectsByProjectsId(rateIdList);
		
		return testList;
	}
}
