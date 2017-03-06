package com.tstar.service.impl;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;

import com.tstar.dao.tapp.CommercialReferenceMapper;
import com.tstar.model.tapp.CommercialReference;
import com.tstar.model.tapp.CommercialReferenceExample;
import com.tstar.service.CommercialReferenceService;

@Controller
@Transactional("transactionManager")
public class CommercialReferenceServiceImpl implements CommercialReferenceService{
	
	@Autowired
	private CommercialReferenceMapper commercialReferenceMapper;
	
	public boolean insertCommercialReferenc(CommercialReference commercialReference) {
		int result = commercialReferenceMapper.insertSelective(commercialReference);
		return 0 < result ? true : false;
	}
	
	public boolean updateCommercialReferenc(CommercialReference commercialReference) {
		int result = commercialReferenceMapper.updateByPrimaryKeySelective(commercialReference);
		return 0 < result ? true : false;
	}

	@Override
	public List<CommercialReference> queryCommercialReference(String msidn,String action, String contractId,String sourceId) {
		CommercialReferenceExample example = new CommercialReferenceExample();
		com.tstar.model.tapp.CommercialReferenceExample.Criteria criteria = example.createCriteria();
		criteria.andMsisdnEqualTo(msidn);
		if(StringUtils.isNotBlank(contractId)){
			criteria.andContractIdEqualTo(contractId);
		}
		criteria.andActionEqualTo(action);
		criteria.andSourceIdEqualTo(sourceId);
		List<CommercialReference> result = commercialReferenceMapper.selectByExample(example);
		for(int i=0;i<result.size();i++){
			System.out.println(result.get(i).getStatus());
		}
		return result;
	}
	
	@Override
	public List<CommercialReference> queryCommercialReferenceCondition(String msidn, String contractId, String sourceId, String action,
			String status ,Timestamp timestampstart ,Timestamp timestampend) {
		
		List<CommercialReference> result = new ArrayList<CommercialReference>();
		CommercialReferenceExample example = new CommercialReferenceExample();
		com.tstar.model.tapp.CommercialReferenceExample.Criteria criteria = example.createCriteria();
		if(StringUtils.isNotBlank(action) && !action.equals("9999")){//代號9999代表安裝類型是查詢所有安裝類型全部
			criteria.andActionEqualTo(action);
		}		
		if(StringUtils.isNotBlank(status)){
			if(status.equals("all")){
				criteria.andStatusBetween("0", "1");
			}else{
				criteria.andStatusEqualTo(status);
			}
			
		}
		if(StringUtils.isNotBlank(msidn)){
			criteria.andMsisdnEqualTo(msidn);
		}
		if(StringUtils.isNotBlank(contractId)){
			criteria.andContractIdEqualTo(contractId);
		}
		if(StringUtils.isNotBlank(sourceId)){
			criteria.andSourceIdEqualTo(sourceId);
		}
		if(timestampstart !=null && timestampend !=null){
			criteria.andCreateTimeBetween(timestampstart, timestampend);
		}
		result = commercialReferenceMapper.selectByExample(example);
		return result;
	}

	@Override
	public boolean updateStatus(String id, String status) {
		CommercialReferenceExample example = new CommercialReferenceExample();
		com.tstar.model.tapp.CommercialReferenceExample.Criteria criteria = example.createCriteria();
		criteria.andIdEqualTo(id);
		CommercialReference commercialReference = new CommercialReference();
		if(StringUtils.isNotBlank(status) && status.equals("0")){
			commercialReference.setStatus("1");
		}
		if(StringUtils.isNotBlank(status) && status.equals("1")){
			commercialReference.setStatus("0");
		}
		int result = commercialReferenceMapper.updateByExampleSelective(commercialReference, example);
		return 0 < result ? true : false;
	}
}