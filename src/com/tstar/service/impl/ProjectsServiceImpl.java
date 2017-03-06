package com.tstar.service.impl;

import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;

import com.tstar.dao.tapp.DevicesMapper;
import com.tstar.dao.tapp.ProjectsMapper;
import com.tstar.model.tapp.Devices;
import com.tstar.model.tapp.DevicesExample;
import com.tstar.model.tapp.Projects;
import com.tstar.model.tapp.ProjectsExample;
import com.tstar.model.tapp.ProjectsExample.Criteria;
import com.tstar.service.ProjectsService;

@Controller
@Transactional("transactionManager")
public class ProjectsServiceImpl implements ProjectsService{
	
	@Autowired
	private DevicesMapper devicesMapper;
	
	@Autowired
	private ProjectsMapper projectsMapper;

	@Override
	public List<Devices> queryAllDevices() {
		DevicesExample example = new DevicesExample();
		
		List<Devices> devicesList = devicesMapper.selectByExample(example);
		
		return devicesList;
	}

	@Override
	public List<Projects> queryProjectsByLike(String str) {
		ProjectsExample example = new ProjectsExample();
		Criteria criteria = example.createCriteria();
		
		criteria.andNameLikeInsensitive("%" + str + "%");
		
		List<Projects> projectsList = projectsMapper.selectByExample(example);
		
		return projectsList;
	}

	@Override
	public List<Projects> queryProjectsByName(String str) {
		ProjectsExample example = new ProjectsExample();
		Criteria criteria = example.createCriteria();
		criteria.andNameEqualTo(str);
		List<Projects> projectsList = projectsMapper.selectByExample(example);
		return projectsList;
	}
	
	public List<Projects> queryProjectsByLike(String str, String status) {
		ProjectsExample example = new ProjectsExample();
		Criteria criteria = example.createCriteria();
		criteria.andNameLikeInsensitive("%" + str + "%");
		if(StringUtils.isNotBlank(status)){
			criteria.andStatusEqualTo(status);
		}
		
		List<Projects> projectsList = projectsMapper.selectByExample(example);
		
		return projectsList;
	}

	@Override
	public boolean insertDevices(Devices devices) {
		int result = devicesMapper.insert(devices);
		
		return 0 < result ? true : false;
	}

	@Override
	public boolean insertProjects(Projects projects) {
		int result = projectsMapper.insert(projects);
		
		return 0 < result ? true : false;
	}

	@Override
	public boolean insertProjectsAndDevice(Projects projects, Devices devices) {
		return insertProjects(projects) && insertDevices(devices);
	}

	@Override
	public boolean updateDevices(Devices devices) {
		int result = devicesMapper.updateByPrimaryKey(devices);
		
		return 0 < result ? true : false;
	}

	@Override
	public boolean updateProjects(Projects projects) {
		int result = projectsMapper.updateByPrimaryKey(projects);
		
		return 0 < result ? true : false;
	}

	@Override
	public boolean updateProjectsAndDevice(Projects projects, Devices devices) {
		return updateProjects(projects) && updateDevices(devices);
	}
}
