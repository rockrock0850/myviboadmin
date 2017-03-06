package com.tstar.service;

import java.sql.Timestamp;
import java.util.List;

import com.tstar.model.tapp.SystemLookup;

public interface SystemLookupService {
	public String getValue(String serviceId, String qry);
	public List<SystemLookup> getSystemLookup(String serviceId, String qry);
	public List<SystemLookup> getLikeValue(String serviceId, String qry);
	public List<SystemLookup> getLikeValueAsc(String serviceId, String qry);
	public List<SystemLookup> getLikeValueFormAsc(String serviceId, String qry);
	public List<SystemLookup> checkLikeValueFormAsc(String serviceId, String qry);
	public List<SystemLookup> getLikeValueformkey(String serviceId,String qry , String formkey ,String formtitle);
	public boolean updateSystemLookup(SystemLookup systemLookup);
	//2015/07/17
	public boolean updateSystemLookupById(SystemLookup systemLookup);
	public boolean insertSystemLookup(SystemLookup systemLookup);
	public List<SystemLookup> queryFromdata(String searchKey,String searchTitle,String status,Timestamp timestampstart, Timestamp timestampend);
	public boolean changestatus(String key,String status);	
	public List<SystemLookup> getPreUpdate(String serviceId, String qry);
}
