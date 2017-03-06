package com.tstar.action;

import java.util.ArrayList;
import java.util.List;

import net.sf.json.JSONObject;

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
public class FilterListAction implements Action{
	
	private final Logger logger = Logger.getLogger(FilterListAction.class);	
	private JSONObject jsonStr;
	private String filterValue;
	private String filterType;
	private String filterKey;
	
	@Autowired
	FilterListService filterListService;
	
	public String execute() {
		logger.info("filterValue : " + filterValue+" filterType : "+filterType+" filterKey : "+filterKey);
		jsonStr = new JSONObject();
		if(StringUtils.isNotBlank(filterValue) && StringUtils.isNotBlank(filterType) && StringUtils.isNotBlank(filterKey)){
			if(!filterType.equals("W") && !filterType.equals("B")){	
				jsonStr.put("status", "00005");
				jsonStr.put("filterType", filterType);
				return SUCCESS;	
			}
			List<FilterList> filterList = new ArrayList<FilterList>();
			try{
				filterList = filterListService.checkList(filterValue, filterType, filterKey,"1");//1的字串參數代表啟用狀態
				jsonStr.put("status", "00000");
				jsonStr.put("filterType", filterType);
				jsonStr.put("filterValue", filterValue);
				if(filterList != null && filterList.size()>0){
					jsonStr.put("filterResult", "1");
					//20150513增加回傳NAME
					if(filterList.get(0) != null && StringUtils.isNotBlank(filterList.get(0).getName())){
						jsonStr.put("filterName", filterList.get(0).getName());
					}else{
						jsonStr.put("filterName", "");
					}
				}else{
					jsonStr.put("filterResult", "0");
					jsonStr.put("filterName", "");
				}
				
			}catch(Exception e){
				jsonStr.put("message", e.getMessage());
				jsonStr.put("status", "99999");
			}
		}else{
			jsonStr.put("message", "傳入之參數不足");
			jsonStr.put("status", "00004");
		}
		return SUCCESS;
	}

	public JSONObject getJsonStr() {
		return jsonStr;
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

	public String getFilterKey() {
		return filterKey;
	}

	public void setFilterKey(String filterKey) {
		this.filterKey = filterKey;
	}	
}
