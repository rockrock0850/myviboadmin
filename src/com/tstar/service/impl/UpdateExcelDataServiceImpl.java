package com.tstar.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;

import com.tstar.dao.tapp.RateProjectsMapper;
import com.tstar.model.tapp.RateProjects;
import com.tstar.model.tapp.RateProjectsExample;
import com.tstar.model.tapp.RateProjectsExample.Criteria;
import com.tstar.service.UpdateExcelDataService;

@Controller
@Transactional("transactionManager")
public class UpdateExcelDataServiceImpl implements UpdateExcelDataService{
	private final Logger logger = Logger.getLogger(UpdateExcelDataServiceImpl.class);
	
	@Autowired
	private RateProjectsMapper rateProjectsMapper;

	@Override
	public boolean insertExcelDate(RateProjects rateProjects) {
		int success = rateProjectsMapper.insert(rateProjects);
		return success > 0 ? true : false;
	}

	@Override
	public boolean deleteAndBackup() {
		RateProjectsExample example = new RateProjectsExample();
		RateProjects rateProjects = new RateProjects();
		Criteria criteria = example.createCriteria();
		criteria.andLinkToBillingEqualTo("Y");
		criteria.andStatusEqualTo("1");
		if(rateProjectsMapper.selectByExample(example).size() != 0){
			example.clear();
			criteria = example.createCriteria();
			List<String> values = new ArrayList<String>();
			values.add("8");
			values.add("null");
			criteria.andStatusIn(values);
			rateProjectsMapper.deleteByExample(example);

			example.clear();
			criteria = example.createCriteria();
			criteria.andLinkToBillingEqualTo("Y");
			criteria.andStatusEqualTo("1");
			rateProjects.setStatus("8");
			rateProjectsMapper.updateByExampleSelective(rateProjects, example);
			return true;
		}else{
			return false;
		}
	}

	@Override
	public boolean insertErrorMechanism() {
		RateProjects rateProjects = new RateProjects();
		RateProjectsExample example = new RateProjectsExample();
		
		Criteria criteria = example.createCriteria();
		criteria.andLinkToBillingEqualTo("Y");
		criteria.andStatusEqualTo("8");
		rateProjects.setStatus("1");
		int success = rateProjectsMapper.updateByExampleSelective(rateProjects, example);
		return success > 0 ? true : false;
	}

	@Override
	public boolean rollBackMechanism() {
		RateProjectsExample example = new RateProjectsExample();
		Criteria criteria = example.createCriteria();
		criteria.andLinkToBillingEqualTo("Y");
		int success = rateProjectsMapper.deleteByExample(example);
		return success > 0 ? true : false;
	}
}
