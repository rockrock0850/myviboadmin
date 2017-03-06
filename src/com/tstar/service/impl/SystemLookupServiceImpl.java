package com.tstar.service.impl;

import java.sql.Timestamp;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;

import com.tstar.dao.tapp.SystemLookupMapper;
import com.tstar.model.tapp.SystemLookup;
import com.tstar.model.tapp.SystemLookupExample;
import com.tstar.model.tapp.SystemLookupExample.Criteria;
import com.tstar.service.SystemLookupService;


@Controller
@Transactional("transactionManager")
public class SystemLookupServiceImpl implements SystemLookupService{
	
	@Autowired
	private SystemLookupMapper systemLookupMapper;
	
	public String getValue(String serviceId, String qry) {
		SystemLookupExample example = new SystemLookupExample();
		Criteria criteria = example.createCriteria();
		criteria.andKeyEqualTo(qry);
		criteria.andServiceIdEqualTo(serviceId);
		criteria.andStatusEqualTo("1");
		List<SystemLookup> systemLookupList = systemLookupMapper.selectByExample(example);
		String rtn = "";
		if(null != systemLookupList && 0 < systemLookupList.size()){
			rtn = systemLookupList.get(0).getValue();
		}
		return rtn;
	}
	
	public List<SystemLookup> getSystemLookup(String serviceId, String qry) {
		SystemLookupExample example = new SystemLookupExample();
		Criteria criteria = example.createCriteria();
		criteria.andKeyEqualTo(qry);
		criteria.andServiceIdEqualTo(serviceId);
		criteria.andStatusEqualTo("1");
		List<SystemLookup> systemLookupList = systemLookupMapper.selectByExample(example);		
		return systemLookupList;
	}
	
	
	public List<SystemLookup> getLikeValue(String serviceId, String qry) {
		SystemLookupExample example = new SystemLookupExample();
		Criteria criteria = example.createCriteria();
		criteria.andKeyLike("%" + qry + "%");
		criteria.andServiceIdEqualTo(serviceId);
		criteria.andStatusEqualTo("1");	
		List<SystemLookup> systemLookupList = systemLookupMapper.selectByExample(example);
		return systemLookupList;
	}
	
	public List<SystemLookup> getLikeValueAsc(String serviceId, String qry) {
		SystemLookupExample example = new SystemLookupExample();
		Criteria criteria = example.createCriteria();
		criteria.andKeyLike("%" + qry + "%");
		criteria.andServiceIdEqualTo(serviceId);
		criteria.andStatusEqualTo("1");
		example.setOrderByClause("key Asc");
		List<SystemLookup> systemLookupList = systemLookupMapper.selectByExample(example);	
		return systemLookupList;
	}
	/*
	 * Short one line description
	 * <p>
	 * Longer description. If there were any, it would be
     * @param SystemLookup
     * @return boolean
	 * @see 更新SystemLookup資料
	 */
	public boolean updateSystemLookup(SystemLookup systemLookup) {
		SystemLookupExample example = new SystemLookupExample();
		Criteria criteria = example.createCriteria();
		criteria.andKeyEqualTo(systemLookup.getKey());
		criteria.andServiceIdEqualTo(systemLookup.getServiceId());	
		int result = systemLookupMapper.updateByExampleSelective(systemLookup, example);
		return 0 < result ? true : false;
	}
	
	public boolean insertSystemLookup(SystemLookup systemLookup) {			
		int result = systemLookupMapper.insert(systemLookup);
		return 0 < result ? true : false;
	}

	@Override
	public List<SystemLookup> getLikeValueformkey(String serviceId,String qry , String formkey ,String formtitle) {
		SystemLookupExample example = new SystemLookupExample();
		Criteria criteria = example.createCriteria();
		criteria.andKeyLike("%" + qry + "%");
		return null;
	}

	@Override
	public List<SystemLookup> getLikeValueFormAsc(String serviceId, String qry) {
		SystemLookupExample example = new SystemLookupExample();
		Criteria criteria = example.createCriteria();
		criteria.andKeyLike("form_" + "%");
		criteria.andKeyLike("%" + qry);
		criteria.andServiceIdEqualTo(serviceId);
		criteria.andStatusEqualTo("1");
		example.setOrderByClause("key Asc");
		List<SystemLookup> systemLookupList = systemLookupMapper.selectByExample(example);	
		return systemLookupList;
	}
	@Override
	public List<SystemLookup> checkLikeValueFormAsc(String serviceId, String qry) {
		SystemLookupExample example = new SystemLookupExample();
		Criteria criteria = example.createCriteria();
		criteria.andKeyLike("form_" + "%");
		criteria.andKeyLike("%" + qry);
		criteria.andServiceIdEqualTo(serviceId);
		example.setOrderByClause("key Asc");
		List<SystemLookup> systemLookupList = systemLookupMapper.selectByExample(example);	
		return systemLookupList;
	}
	@Override
	public List<SystemLookup> queryFromdata(String searchKey,String searchTitle, String status, Timestamp timestampstart, Timestamp timestampend) {
		SystemLookupExample example = new SystemLookupExample();
		Criteria criteria = example.createCriteria();		
		
		if(StringUtils.isNotBlank(searchKey)){
			searchKey = "form_banner"+"."+searchKey;
			criteria.andKeyEqualTo(searchKey);
		}else{
			criteria.andKeyLike("form_title." + "%");
		}
		if(StringUtils.isNotBlank(searchTitle)){
			criteria.andValueLike("%" + searchTitle + "%");
		}
		if(StringUtils.isNotBlank(status)){
			criteria.andStatusEqualTo(status);		
		}
		if(timestampstart !=null && timestampend !=null){
			criteria.andCreateTimeBetween(timestampstart, timestampend);
		}
		example.setOrderByClause("key Asc");
		List<SystemLookup> systemLookupList = systemLookupMapper.selectByExample(example);
		return systemLookupList;
	}

	@Override
	public boolean changestatus(String key, String status) {
		key = "."+key;
		SystemLookupExample example = new SystemLookupExample();
		Criteria criteria = example.createCriteria();
		criteria.andKeyLike("form_" + "%");
		criteria.andKeyLike("%" + key);
		if(status.equals("1")){
			status = "0";
		}else{
			status = "1";
		}
		List<SystemLookup> systemLookupList = systemLookupMapper.selectByExample(example);
		int resultdata = 0;
		for(int i=0;i<systemLookupList.size();i++){
			systemLookupList.get(i).setStatus(status);	
			example = new SystemLookupExample();
			criteria = example.createCriteria();
			criteria.andIdEqualTo(systemLookupList.get(i).getId());
			int result = systemLookupMapper.updateByExampleSelective(systemLookupList.get(i), example);
			resultdata = resultdata+result;
		}	
		return 0 < resultdata ? true : false;	
	}
	
	@Override
	public List<SystemLookup> getPreUpdate(String serviceId, String qry) {
		SystemLookupExample example = new SystemLookupExample();
		Criteria criteria = example.createCriteria();
		criteria.andKeyLike("form_" + "%");
		criteria.andKeyLike("%" + qry);
		criteria.andServiceIdEqualTo(serviceId);
		example.setOrderByClause("key Asc");
		List<SystemLookup> systemLookupList = systemLookupMapper.selectByExample(example);	
		return systemLookupList;
	}
	//2015/07/17
	@Override
	public boolean updateSystemLookupById(SystemLookup systemLookup) {
		SystemLookupExample example = new SystemLookupExample();
		Criteria criteria = example.createCriteria();
		criteria.andIdEqualTo(systemLookup.getId());
		int result = systemLookupMapper.updateByExampleSelective(systemLookup, example);
		return 0 < result ? true : false;	
	}
}
