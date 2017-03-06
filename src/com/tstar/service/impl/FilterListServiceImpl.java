package com.tstar.service.impl;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;

import com.tstar.dao.tapp.FilterListMapper;
import com.tstar.model.tapp.FilterList;
import com.tstar.model.tapp.FilterListExample;
import com.tstar.service.FilterListService;

@Controller
@Transactional("transactionManager")
public class FilterListServiceImpl implements FilterListService{
	
	@Autowired
	FilterListMapper filterListMapper;
	
	@Override
	public List<FilterList> checkList(String filterValue, String filterType,String filterKey,String status) {
		FilterListExample example = new FilterListExample();
		com.tstar.model.tapp.FilterListExample.Criteria criteria = example.createCriteria();
		criteria.andValueEqualTo(filterValue);
		criteria.andFilterTypeEqualTo(filterType);
		criteria.andFilterKeyEqualTo(filterKey);
		criteria.andStatusEqualTo(status);
		List<FilterList> filterList = filterListMapper.selectByExample(example);
		return filterList;
	}

	@Override
	public List<FilterList> queryList(String filterKey, String name,String filterValue, String filterType, 
			String status,Timestamp timestampstart, Timestamp timestampend) {
		
		List<FilterList> result = new ArrayList<FilterList>();
		FilterListExample example = new FilterListExample();
		com.tstar.model.tapp.FilterListExample.Criteria criteria = example.createCriteria();
		if(StringUtils.isNotBlank(status)){
			if(status.equals("all")){
				criteria.andStatusBetween("0", "1");
			}else{
				criteria.andStatusEqualTo(status);
			}
			
		}
		if(StringUtils.isNotBlank(filterKey)){
			criteria.andFilterKeyEqualTo(filterKey);
		}
		if(StringUtils.isNotBlank(name)){
			criteria.andNameEqualTo(name);
		}
		if(StringUtils.isNotBlank(filterValue)){
			criteria.andValueEqualTo(filterValue);
		}
		if(StringUtils.isNotBlank(filterType) && !filterType.equals("all")){
			criteria.andFilterTypeEqualTo(filterType);
		}
		if(timestampstart !=null && timestampend !=null){
			criteria.andCreateTimeBetween(timestampstart, timestampend);
		}
		result = filterListMapper.selectByExample(example);
		return result;
	}

	@Override
	public boolean updateFilter(FilterList filterList, String id) {
		FilterListExample example = new FilterListExample();
		com.tstar.model.tapp.FilterListExample.Criteria criteria = example.createCriteria();
		criteria.andIdEqualTo(id);	
		int result = filterListMapper.updateByExampleSelective(filterList, example);
		return 0 < result ? true : false;
	}

	@Override
	public boolean insertFilter(FilterList filterList) {
		int result = filterListMapper.insertSelective(filterList);
		return 0 < result ? true : false;
	}

	@Override
	public boolean insertcheck(String key, String value) {
		FilterListExample example = new FilterListExample();
		com.tstar.model.tapp.FilterListExample.Criteria criteria = example.createCriteria();
		criteria.andFilterKeyEqualTo(key);
		criteria.andValueEqualTo(value);
		List<FilterList> result = filterListMapper.selectByExample(example);
		if(result.size()>0){
			return true;
		}else{
			return false;
		}		
	}
}
