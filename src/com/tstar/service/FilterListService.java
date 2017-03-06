package com.tstar.service;

import java.sql.Timestamp;
import java.util.List;

import com.tstar.model.tapp.FilterList;

public interface FilterListService {
	public List<FilterList> checkList(String filterValue,String filterType,String filterKey,String status);
	
	public List<FilterList> queryList(String filterKey,String name,String filterValue,String filterType ,String status,Timestamp timestampstart ,Timestamp timestampend);
	
	public boolean updateFilter(FilterList filterList, String id);
		
	public boolean insertFilter(FilterList filterLis);
	
	public boolean insertcheck(String key,String value);
}
