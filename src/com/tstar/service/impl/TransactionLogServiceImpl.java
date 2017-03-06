package com.tstar.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;

import com.tstar.dao.tapp.TransactionLogMapper;
import com.tstar.model.tapp.TransactionLog;
import com.tstar.service.TransactionLogService;

@Controller
@Transactional("transactionManager")
public class TransactionLogServiceImpl implements TransactionLogService{

	@Autowired
	TransactionLogMapper transactionLogMapper;

	@Override
	public boolean insertTransactionLogSelective(TransactionLog record) {
		int result = transactionLogMapper.insertSelective(record);
		return result > 0 ? true : false;
	}
}
