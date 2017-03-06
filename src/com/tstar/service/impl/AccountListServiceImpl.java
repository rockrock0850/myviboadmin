package com.tstar.service.impl;

import java.util.Date;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;

import com.tstar.dao.tapp.MvAccountlistMapper;
import com.tstar.model.tapp.MvAccountlist;
import com.tstar.model.tapp.MvAccountlistExample;
import com.tstar.service.AccountListService;
import com.tstar.utility.PropertiesUtil;

@Controller
@Transactional("transactionManager")
public class AccountListServiceImpl implements AccountListService{
	
	@Autowired
	private MvAccountlistMapper mvAccountlistMapper;
	
	@Autowired
	private PropertiesUtil propertiesUtil;
	
	private final Logger logger = Logger.getLogger(AccountListServiceImpl.class);
	private Long updateTime = 0L;
	private List<MvAccountlist> accountlist;
	

	public boolean authUser(String systemId, String systemKey, String functionId){
		boolean authResult = false;
		if(StringUtils.isNotBlank(systemId) && StringUtils.isNotBlank(systemKey) && StringUtils.isNotBlank(functionId)){
			logger.info("auth user id: " + systemId);
			MvAccountlist mvAccount = mvAccountlistMapper.selectByPrimaryKey(systemId);
			if(mvAccount == null){
				logger.info("auth result: user doesn't exist");
			}else if(!systemKey.equals(mvAccount.getLoginpassword())){
				logger.info("auth result: wrong password");
			}else{
				String[] roleArray = mvAccount.getLoginrole().split(",");
				for(String func : roleArray){
					if(functionId.equals(func)){
						return true;
					}
				}
				logger.info("auth result: unauthorized function id: " + functionId);
			}
		}else{
			logger.info("auth result: missing parameter");
		}
		return authResult;
	}
	
	
	public boolean authUser(String systemId, String systemKey, String functionId, boolean cache){
		boolean authResult = false;
		if(StringUtils.isNotBlank(systemId) && StringUtils.isNotBlank(systemKey) && StringUtils.isNotBlank(functionId)){
			if(!cache){
				return authUser(systemId, systemKey, functionId);
			}
			
			Long feq = 5L;
			try{
				feq = Long.valueOf(propertiesUtil.getProperty("MvAccountlist_feq"));
			}catch(Exception e){
				e.printStackTrace();
			}
			logger.info("feq: " + feq + " lastUpdate time: " + new Date(updateTime));
			
			Date date = new Date();
			Long diff = date.getTime() - updateTime;
			//間隔大於設定時間就更新資料
			if(feq < diff / (60 * 1000)){
				updateAccountList();
			}else{
				//如果查的USER不存在也要更新資料
				boolean isUserIdExist = false;
				for(MvAccountlist mvAccountlist : accountlist){
					if(systemId.equals(mvAccountlist.getLoginid())){
						isUserIdExist = true;
						break;
					}
				}
				if(!isUserIdExist){
					updateAccountList();
				}
			}
			
			logger.info("auth user id: " + systemId);
			
			boolean isUserIdExist = false;
			for(MvAccountlist mvAccount : accountlist){
				if(systemId.equals(mvAccount.getLoginid())){
					if(!systemKey.equals(mvAccount.getLoginpassword())){
						logger.info("auth result: wrong password");
					}else{
						String[] roleArray = mvAccount.getLoginrole().split(",");
						for(String func : roleArray){
							if(functionId.equals(func)){
								return true;
							}
						}
						logger.info("auth result: unauthorized function id: " + functionId);
					}
					isUserIdExist = true;
					break;
				}
			}
			
			if(!isUserIdExist){
				logger.info("auth result: user doesn't exist");
			}
		}else{
			logger.info("auth result: missing parameter");
		}
		return authResult;
	}
	
	private void updateAccountList(){
		MvAccountlistExample example = new MvAccountlistExample();
		
		this.accountlist = mvAccountlistMapper.selectByExample(example);
		
		//更新最後時間
		Date date = new Date();
		updateTime = date.getTime();
	}
}
