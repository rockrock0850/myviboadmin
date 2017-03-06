package com.tstar.service;

import java.util.List;

import com.tstar.model.tapp.Devices;
import com.tstar.model.tapp.Projects;

public interface ProjectsService {
	public List<Devices> queryAllDevices();
	
	public List<Projects> queryProjectsByLike(String str);

	public List<Projects> queryProjectsByName(String str);
	
	public List<Projects> queryProjectsByLike(String str, String status);
	
	public boolean insertDevices(Devices devices);
	
	public boolean insertProjects(Projects projects);
	
	public boolean insertProjectsAndDevice(Projects projects, Devices devices);
	
	public boolean updateDevices(Devices devices);
	
	public boolean updateProjects(Projects projects);
	
	public boolean updateProjectsAndDevice(Projects projects, Devices devices);
}
