package com.tstar.service;

import java.util.Map;

public interface MemberCenterService {
	/**
	 * CustProfile API
	 * @author KT
	 * @version 1.0 2014-12-08
	 */
	public Map<String, String> getCustProfile(String requestXml);
	
	/**
	 * login API
	 * @author KT
	 * @version 1.0 2014-12-08
	 */
	public Map<String, String> ssoLogin(String requestXml);
	
	/**
	 * login API
	 * 回傳包含CustProfile資料
	 * @return xml
	 * @author KT
	 * @version 1.0 2014-12-08
	 */
	public Map<String, String> login(String requestXml);
}
