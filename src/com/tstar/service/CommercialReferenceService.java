package com.tstar.service;

import java.sql.Timestamp;
import java.util.List;

import com.tstar.model.tapp.CommercialReference;

public interface CommercialReferenceService {
	public boolean insertCommercialReferenc(CommercialReference CommercialReference);
	
	public boolean updateCommercialReferenc(CommercialReference commercialReference);
	
	public List<CommercialReference> queryCommercialReference(String msidn,String action, String contractId,String sourceId);
	
	public List<CommercialReference> queryCommercialReferenceCondition(String msidn ,String contractId ,String sourceId ,String action ,String status ,Timestamp timestampstart ,Timestamp timestampend);
	
	public boolean updateStatus(String id ,String status);
}
