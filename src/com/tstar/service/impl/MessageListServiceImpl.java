package com.tstar.service.impl;

import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;

import com.tstar.dao.tapp.MvMessageListMapper;
import com.tstar.model.tapp.MvMessageList;
import com.tstar.model.tapp.MvMessageListExample;
import com.tstar.service.MessageListService;

@Controller
@Transactional("transactionManager")
public class MessageListServiceImpl implements MessageListService{
	
	@Autowired
	private MvMessageListMapper messageListMapper;
	
	private final Logger logger = Logger.getLogger(MessageListServiceImpl.class);

	public List<MvMessageList> querySnowLeopard(String serviceId){
		MvMessageListExample example = new MvMessageListExample();
		com.tstar.model.tapp.MvMessageListExample.Criteria criteria = example.createCriteria();
		criteria.andServiceidEqualTo(serviceId);
		criteria.andStatusEqualTo("1");
		criteria.andShowsnowleopardEqualTo("Y");
		criteria.andEffectdateLessThanOrEqualTo(new Date());
		criteria.andExpiredateGreaterThan(new Date());
		
		List<MvMessageList> messageList = messageListMapper.selectByExample(example);
		
		return messageList;
	}
}
