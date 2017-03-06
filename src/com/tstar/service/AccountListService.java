package com.tstar.service;

public interface AccountListService {
	
	public boolean authUser(String systemId, String systemKey, String functionId);
	
	/**
	 * 
	 * @param systemId
	 * @param systemKey
	 * @param functionId
	 * @param cache(true:使用CACHE, false:不用CACHE)
	 * @return
	 */
	public boolean authUser(String systemId, String systemKey, String functionId, boolean cache);

}
