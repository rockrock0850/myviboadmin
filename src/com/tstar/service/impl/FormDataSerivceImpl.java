package com.tstar.service.impl;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;

import com.tstar.dao.tapp.FormDataMapper;
import com.tstar.dto.FormDataQueryDto;
import com.tstar.model.tapp.FormData;
import com.tstar.model.tapp.FormDataExample;
import com.tstar.service.FormDataService;

@Controller
@Transactional("transactionManager")
public class FormDataSerivceImpl implements FormDataService{
	
	@Autowired
	private FormDataMapper formDataMapper;
	
	@Override
	public boolean insertFormData(FormData formData) {
		int result = formDataMapper.insertSelective(formData);
		return 0 < result ? true : false;
	}
	@Override
	public List<FormData> queryAll() {
		List<FormData> result = new ArrayList<FormData>();
		FormDataExample example = new FormDataExample();
		com.tstar.model.tapp.FormDataExample.Criteria criteria= example.createCriteria();
		example.setOrderByClause("seq Asc");
		result = formDataMapper.selectByExample(example);
		return result;
	}
	@Override
	public boolean deleteFormData() {
		FormDataExample example = new FormDataExample();
		//com.tstar.model.tapp.FormDataExample.Criteria criteria= example.createCriteria();		
		//formDataMapper.deleteByPrimaryKey(id);
		formDataMapper.deleteByExample(example);
		return true;
	}
	@Override
	public List<FormDataQueryDto> queryFormdata(String formKey,Timestamp timestampstart, Timestamp timestampend) {
		FormDataExample example = new FormDataExample();
		List<FormData> result = new ArrayList<FormData>();
		com.tstar.model.tapp.FormDataExample.Criteria criteria= example.createCriteria();
		if(StringUtils.isNotBlank(formKey)){
			criteria.andFormKeyEqualTo(formKey);
		}
		if(timestampstart !=null && timestampend !=null){
			criteria.andCreateTimeBetween(timestampstart, timestampend);
		}
		
		example.setOrderByClause("form_id asc , seq asc");
		
		List<FormDataQueryDto> allresult = new ArrayList<FormDataQueryDto>();
		result = formDataMapper.selectByExample(example);
		if(result.size()>0){
			String formid = result.get(0).getFormId();
			Timestamp createtime = result.get(0).getCreateTime();
			List<String> columnName = new ArrayList<String>();
			List<String> columnValue = new ArrayList<String>();
			FormDataQueryDto formDataQueryDto = new FormDataQueryDto();
			formDataQueryDto.setCreateTime(createtime);
			for(int i=0;i<result.size();i++){
				if(!formid.equals(result.get(i).getFormId())){
					formid = result.get(i).getFormId();
					formDataQueryDto.setFormId(result.get(i-1).getFormId());
					formDataQueryDto.setFormKey(result.get(i-1).getFormKey());
					formDataQueryDto.setColumnName(columnName);
					formDataQueryDto.setColumnValue(columnValue);
					allresult.add(formDataQueryDto);	
					formDataQueryDto = new FormDataQueryDto();
					formDataQueryDto.setCreateTime(result.get(i).getCreateTime());
					columnName = new ArrayList<String>();
					columnValue = new ArrayList<String>();
				}
				columnName.add(result.get(i).getColumnName());
				columnValue.add(result.get(i).getColumnValue());
				if(i == result.size()-1){
					formDataQueryDto.setFormId(result.get(i).getFormId());
					formDataQueryDto.setFormKey(result.get(i).getFormKey());
					formDataQueryDto.setColumnName(columnName);
					formDataQueryDto.setColumnValue(columnValue);
					allresult.add(formDataQueryDto);
				}
			}
		}
		return allresult;
	}
}
