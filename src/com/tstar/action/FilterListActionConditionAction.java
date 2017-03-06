package com.tstar.action;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.Action;
import com.tstar.model.tapp.FilterList;
import com.tstar.service.FilterListService;

@Component
@Scope("prototype")
public class FilterListActionConditionAction implements Action{
	private final Logger logger = Logger.getLogger(FilterListActionConditionAction.class);
	private String filterKey;
	private String name;
	private String filterValue;
	private String filterType;
	private String status;
	private String createtimestart;
	private String createtimeend;
	private String createuser;
	private String insertKey;
	private String insertName;
	private String insertValue;
	private String insertType;
	private String insertStatus;
	private String message;
	private String update_id;
	private String update_user;
	private String update_filtername;
	private String update_filtervalue;
	private String update_status;
	private String update_filterType;
	private List<FilterList> filterList;
	
	@Autowired
	private FilterListService filterListService;
	
	@Override
	public String execute() throws Exception {
		
		return SUCCESS;
	}
	
	public String queryList(){
		logger.info(" filterKey : "+ filterKey + " name : "+ name +" filterValue : "+ filterValue +
					" filterType : "+filterType+" status :"+ status +" createtimestart : "+createtimestart+" createtimeend : "+createtimeend);
		filterList = querydata(filterKey, name , filterValue , filterType, status , createtimestart , createtimeend);
		if(filterList.size()==0){
			message = "查無資料";
		}
		return SUCCESS;
	}
	
	public String insertdata (){
		logger.info("Do insert "+" insertKey : "+ insertKey + " insertName : "+ insertName +" insertValue : "+ insertValue +
				" insertType : "+insertType+" insertStatus :"+ insertStatus +" createuser : "+createuser);	
		boolean dataExist = filterListService.insertcheck(insertKey, insertValue);
		if(dataExist){
			message = "資料已存在";
		}else{
			Date date = new Date();
			Timestamp timestamp = new Timestamp(date.getTime());
			int random=(int)(Math.random()*900)+100; 
			Calendar cal = Calendar.getInstance();
			String milliseconds = Long.toString(cal.getTimeInMillis()+(long)random);
			FilterList insertdata = new FilterList();
			insertdata.setId(milliseconds);
			insertdata.setFilterKey(insertKey);
			insertdata.setName(insertName);
			insertdata.setValue(insertValue);
			insertdata.setFilterType(insertType);
			insertdata.setStatus(insertStatus);
			insertdata.setCreateTime(timestamp);
			insertdata.setUpdateTime(timestamp);
			insertdata.setCreateUser(createuser);
			boolean checkinsert = filterListService.insertFilter(insertdata);
			if(checkinsert){
				message = "新增成功";
			}else{
				message = "新增失敗";
			}
		}	
		return SUCCESS;
	}
	public String changeStatus(){
		logger.info(" update_id : "+update_id +" update_user : "+update_user +" update_filtername: "+update_filtername+
					" update_filtervalue: "+update_filtervalue+" update_status: "+update_status +" update_filterType: "+update_filterType);
		Date date = new Date();
		Timestamp timestamp = new Timestamp(date.getTime());
		FilterList updatedata = new FilterList();
		updatedata.setUpdateUser(update_user);
		updatedata.setUpdateTime(timestamp);
		updatedata.setName(update_filtername);
		updatedata.setValue(update_filtervalue);
		updatedata.setFilterType(update_filterType);
		updatedata.setStatus(update_status);
		boolean dbStatus = filterListService.updateFilter(updatedata, update_id);
		if(dbStatus){
			message = "更新成功";
		}else{
			message = "更新失敗";
		}
		filterList = querydata(filterKey, name , filterValue , filterType, status , createtimestart , createtimeend);
		return SUCCESS;
	}
	
	public List<FilterList> querydata(String filterKey,String name ,String filterValue ,String filterType,String status ,String createtimestart ,String createtimeend){
		Timestamp timestampstart =null;
		Timestamp timestampend =null;
		if(StringUtils.isNotBlank(createtimestart) && StringUtils.isNotBlank(createtimeend)){
			createtimestart = createtimestart.replace("/", "-");//日期格式轉換把/轉成-
			timestampstart = Timestamp.valueOf(createtimestart);//轉換timestamp格式
			createtimeend = createtimeend.replace("/", "-");
			timestampend = Timestamp.valueOf(createtimeend);
		}
		List<FilterList> result = new ArrayList<FilterList>();
		result = filterListService.queryList(filterKey, name, filterValue, filterType, status, timestampstart, timestampend);
		return result;
	}
	
	public String getFilterKey() {
		return filterKey;
	}
	public void setFilterKey(String filterKey) {
		this.filterKey = filterKey;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getFilterValue() {
		return filterValue;
	}
	public void setFilterValue(String filterValue) {
		this.filterValue = filterValue;
	}
	public String getFilterType() {
		return filterType;
	}
	public void setFilterType(String filterType) {
		this.filterType = filterType;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getCreatetimestart() {
		return createtimestart;
	}
	public void setCreatetimestart(String createtimestart) {
		this.createtimestart = createtimestart;
	}
	public String getCreatetimeend() {
		return createtimeend;
	}
	public void setCreatetimeend(String createtimeend) {
		this.createtimeend = createtimeend;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public List<FilterList> getFilterList() {
		return filterList;
	}
	public void setFilterList(List<FilterList> filterList) {
		this.filterList = filterList;
	}
	public String getCreateuser() {
		return createuser;
	}
	public void setCreateuser(String createuser) {
		this.createuser = createuser;
	}
	public String getUpdate_id() {
		return update_id;
	}
	public void setUpdate_id(String update_id) {
		this.update_id = update_id;
	}
	public String getUpdate_user() {
		return update_user;
	}
	public void setUpdate_user(String update_user) {
		this.update_user = update_user;
	}
	public String getUpdate_filtername() {
		return update_filtername;
	}
	public void setUpdate_filtername(String update_filtername) {
		this.update_filtername = update_filtername;
	}
	public String getUpdate_filtervalue() {
		return update_filtervalue;
	}
	public void setUpdate_filtervalue(String update_filtervalue) {
		this.update_filtervalue = update_filtervalue;
	}
	public String getUpdate_status() {
		return update_status;
	}
	public void setUpdate_status(String update_status) {
		this.update_status = update_status;
	}
	public String getUpdate_filterType() {
		return update_filterType;
	}
	public void setUpdate_filterType(String update_filterType) {
		this.update_filterType = update_filterType;
	}
	public String getInsertKey() {
		return insertKey;
	}
	public void setInsertKey(String insertKey) {
		this.insertKey = insertKey;
	}
	public String getInsertName() {
		return insertName;
	}
	public void setInsertName(String insertName) {
		this.insertName = insertName;
	}
	public String getInsertValue() {
		return insertValue;
	}
	public void setInsertValue(String insertValue) {
		this.insertValue = insertValue;
	}
	public String getInsertType() {
		return insertType;
	}
	public void setInsertType(String insertType) {
		this.insertType = insertType;
	}
	public String getInsertStatus() {
		return insertStatus;
	}
	public void setInsertStatus(String insertStatus) {
		this.insertStatus = insertStatus;
	}
}