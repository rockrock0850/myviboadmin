package com.tstar.service;

import com.tstar.model.tapp.RateProjects;

public interface UpdateExcelDataService {

	boolean deleteAndBackup();

	boolean insertExcelDate(RateProjects rateProjects);
	
	boolean insertErrorMechanism();
	
	boolean rollBackMechanism();
}
