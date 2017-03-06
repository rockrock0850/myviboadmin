package com.tstar.service.impl;

import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.tstar.dao.custom.CustomMapper;
import com.tstar.dao.tapp.MvPushMessageUsersMapper;
import com.tstar.model.tapp.MvPushMessageUsers;
import com.tstar.model.tapp.MvPushMessageUsersExample;
import com.tstar.model.tapp.MvPushMessageUsersExample.Criteria;
import com.tstar.service.PushMessageUserService;
import com.tstar.utility.PropertiesUtil;

@Controller
public class PushMessageUserServiceImpl implements PushMessageUserService {
	
	@Autowired
	private MvPushMessageUsersMapper pushMessageUsersMapper;
	
	@Autowired
	private CustomMapper customMapper;
	
	@Autowired
	private PropertiesUtil propertiesUtil;
	
	private final Logger logger = Logger.getLogger(PushMessageUserServiceImpl.class);
	
	List<MvPushMessageUsers> devicesList;
	Long updateTime = 0L;
	
	
	/**
	 * isUserExist: 確認USER是否存在推撥清單
	 * @author KT
	 * @version 1.0 2015-02-24
	 */
	public boolean isUserExist(String serviceId,String msisdn){
		Long feq = 5L;
		try{
			feq = Long.valueOf(propertiesUtil.getProperty("MvPushMessageUsers_feq"));
		}catch(Exception e){
			e.printStackTrace();
		}
		logger.info("msisdn: " + msisdn + " feq: " + feq + " lastUpdate time: " + new Date(updateTime));
		Date date = new Date();
		Long diff = date.getTime() - updateTime;
		if(feq < diff / (60 * 1000)){
			updateData();
		}
		if(devicesList != null && 0 < devicesList.size()){
			for(MvPushMessageUsers pushMessageUsers : devicesList){
				if(pushMessageUsers.getServiceid().equals(serviceId) && pushMessageUsers.getMsisdn().equals(msisdn)){
					return true;
				}
			}
		}
		return false;
	}
	
	public List<MvPushMessageUsers> getUserList(String serviceId){
		MvPushMessageUsersExample example = new MvPushMessageUsersExample();
		Criteria criteria = example.createCriteria();
		criteria.andServiceidEqualTo(serviceId);
		criteria.andAllowsendEqualTo("Y");
		
		return customMapper.queryMvPushMessageUsersSimple(example);
	}
	
	private void updateData(){
		logger.info("lastUpdate time: " + new Date(updateTime));
		MvPushMessageUsersExample example = new MvPushMessageUsersExample();
		Criteria criteria = example.createCriteria();
		criteria.andAllowsendEqualTo("Y");
		
		devicesList = pushMessageUsersMapper.selectByExample(example);
		Date date = new Date();
		updateTime = date.getTime();
	}
}
