package com.tstar.service;

import java.util.List;

import com.tstar.model.tapp.MvMessageList;


public interface MessageListService {
	public List<MvMessageList> querySnowLeopard(String serviceId);
}
