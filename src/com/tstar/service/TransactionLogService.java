package com.tstar.service;

import com.tstar.model.tapp.TransactionLog;

public interface TransactionLogService {
	boolean insertTransactionLogSelective(TransactionLog record);
}
