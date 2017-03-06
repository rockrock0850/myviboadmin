package com.tstar.service;

import java.util.List;

import com.tstar.model.tapp.SelectList;


public interface SelectListService {
	
	public List<SelectList> querySelectList(String serviceId, String status, String functionId);
	
	public List<SelectList> selectHierarchy(String serviceId, List<String> statusList, String functionId, String parentId);
	
	public void insertSelectList(String serviceId, String functionId, 
		String parentId, String val, String text, String status, String description, String seq, String insertUser);
    
    public void updateSelectList(String id, String val, String text, String status, String seq, String updateUser);
    
    public String addGroupSelectList(String serviceId, String parentId, String dscr, String seq, String insertUser);
    
    public List<SelectList> getGroupList();
    

}
