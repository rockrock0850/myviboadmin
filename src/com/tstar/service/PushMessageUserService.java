package com.tstar.service;

import java.util.List;

import com.tstar.model.tapp.MvPushMessageUsers;


public interface PushMessageUserService {
	/**
	 * PushMessageUserService API
	 * @author KT
	 * @version 1.0 2015-02-24
	 */
	public boolean isUserExist(String serviceId,String msisdn);
	
	public List<MvPushMessageUsers> getUserList(String serviceId);
	
}
