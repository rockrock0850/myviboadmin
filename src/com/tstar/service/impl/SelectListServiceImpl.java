package com.tstar.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;

import com.tstar.dao.tapp.SelectListMapper;
import com.tstar.model.tapp.SelectList;
import com.tstar.model.tapp.SelectListExample;
import com.tstar.service.SelectListService;

@Controller
@Transactional("transactionManager")
public class SelectListServiceImpl implements SelectListService{
	
	@Autowired
	private SelectListMapper selectListMapper;
	
	private final Logger logger = Logger.getLogger(SelectListServiceImpl.class);

    public List<SelectList> querySelectList(String serviceId, String status, String functionId){
		SelectListExample example = new SelectListExample();
		com.tstar.model.tapp.SelectListExample.Criteria criteria = example.createCriteria();
		criteria.andServiceIdEqualTo(serviceId);
		criteria.andStatusEqualTo(status);
		criteria.andFunctionIdEqualTo(functionId);
		criteria.andTextNotEqualTo("null");
		example.setOrderByClause("seq ASC");
		
		List<SelectList> selectList = selectListMapper.selectByExample(example);
		
		return selectList;
	}
    

    
    public List<SelectList> selectHierarchy(String serviceId, List<String> statusList, String functionId, String parentId){
    	logger.info("--------this is SelectListServiceImpl.selectHierarchy function---------");
    	Map<String, Object> map = new HashMap<String, Object>();
    	
    	map.put("serviceId", serviceId);
    	map.put("functionId", functionId);
    	map.put("statusList", statusList);
    	map.put("parentId", parentId);
    	
    	List<SelectList> selectList = selectListMapper.selectHierarchy(map);
    	return selectList;
    }
    
    public void insertSelectList(String serviceId, String functionId, String parentId, String val, String text, String status, String description, String seq, String insertUser){
    	logger.info("--------this is SelectListServiceImpl.insertSelectList function---------");
    	SelectList record = new SelectList();
    	String	gcDateFormatDateDashTime = "yyyyMMddHHmmss";
		String id = getSelectListId(gcDateFormatDateDashTime);
    	
    	record.setId(id);
    	record.setServiceId(serviceId);
    	record.setFunctionId(functionId);
    	record.setParentId(parentId);
    	record.setVal(val);
    	record.setText(text);
    	record.setStatus(status);
    	record.setInsertTime(new Date());
    	record.setInsertUser(insertUser);
    	record.setDescription(description);
    	record.setSeq(Short.valueOf(seq));

    	int i = selectListMapper.insert(record);
    	
    }
    
    public void updateSelectList(String id, String val, String text, String status, String seq, String updateUser){
    	logger.info("--------this is SelectListServiceImpl.updateSelectList function---------");
    	SelectList record = new SelectList();
    	record.setId(id);
    	record.setVal(val);
    	record.setText(text);
    	record.setStatus(status);
    	record.setUpdateTime(new Date());
    	record.setUpdateUser(updateUser);
    	record.setSeq(Short.valueOf(seq));
    	selectListMapper.updateByPrimaryKeySelective(record);
    	
    }
    
    public String addGroupSelectList(String serviceId, String parentId, String dscr, String seq, String insertUser){
    	logger.info("--------this is SelectListServiceImpl.addGroupSelectList function---------");
    	SelectList record = new SelectList();
    	
    	String	gcDateFormatDateDashTime = "yyyyMMddHHmmss";
		String id = getSelectListId(gcDateFormatDateDashTime);
		
		Map map = new HashMap();
		List<SelectList> selectList = selectListMapper.selectMaxFunctionId(map);
		String maxId = selectList.get(0).getFunctionId();
		//取出最大的function_id後三碼+1
		int no = Integer.parseInt(maxId.substring(maxId.length()-3))+1;
		String functionId = "comparsionSelect" + String.format("%03d", no);
    	record.setId(id);
    	record.setServiceId(serviceId);
    	record.setFunctionId(functionId);
    	record.setParentId(parentId);
    	record.setDescription(dscr);
    	record.setSeq(Short.valueOf(seq));
    	record.setStatus("1");
    	record.setInsertUser(insertUser);
    	record.setInsertTime(new Date());
    	
    	selectListMapper.insert(record);
    	
    	return functionId;
    	
    }
    
    public List<SelectList> getGroupList(){
    	logger.info("--------this is SelectListServiceImpl.getGroupList function---------");
    	Map map = new HashMap();
    	return selectListMapper.selectDisFunctionIdDscr(map);
    }
    
    //按當前日期產出selectList.Id
    private String getSelectListId(String timeFormat){

    	logger.info("--------this is SelectListServiceImpl.getSelectListId function---------");
    	String	gcDateFormatDateDashTime = timeFormat;
    	java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat(gcDateFormatDateDashTime);
		java.util.Date currentTime = new java.util.Date();//得到當前系統時間
		String id = formatter.format(currentTime); //將日期時間格式化， 得到timeFormat格式的String
		
		return id;
    }

}
