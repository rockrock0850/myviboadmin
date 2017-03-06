package com.tstar.service.impl;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;

import com.tstar.dao.tapp.MvPushMessageRecordDetailMapper;
import com.tstar.dao.tapp.MvPushMessageRecordMainMapper;
import com.tstar.dto.QueryPushMsgQueryDto;
import com.tstar.model.tapp.MvPushMessageRecordDetail;
import com.tstar.model.tapp.MvPushMessageRecordDetailExample;
import com.tstar.model.tapp.MvPushMessageRecordMain;
import com.tstar.model.tapp.MvPushMessageRecordMainExample;
import com.tstar.service.PushMsgQueryService;


@Controller
@Transactional("transactionManager")
public class PushMsgQueryServiceImpl implements PushMsgQueryService{
	@Autowired
	MvPushMessageRecordDetailMapper mvPushMessageRecordDetailMapper;
	
	@Autowired
	MvPushMessageRecordMainMapper mvPushMessageRecordMainMapper;
	
	@Override
	public List<MvPushMessageRecordDetail> queryMessageRecordDetail(Timestamp time,String msisdn, String osType) {
		List<MvPushMessageRecordDetail> result = new ArrayList<MvPushMessageRecordDetail>();	
			if(StringUtils.isNotBlank(msisdn) && StringUtils.isNotBlank(osType) & time !=null){
				try{
					MvPushMessageRecordDetailExample example = new MvPushMessageRecordDetailExample();		
					com.tstar.model.tapp.MvPushMessageRecordDetailExample.Criteria criteria = example.createCriteria();
					criteria.andCreateTimeGreaterThan(time);
					criteria.andMsisdnEqualTo(msisdn);
					criteria.andDeviceEqualTo(osType);
					//移除已經disable的資料
					criteria.andStatusNotEqualTo("D");
					result = mvPushMessageRecordDetailMapper.selectByExample(example);
				}catch(Exception e){
					e.printStackTrace();
				}
			}
		return result;
	}
	
	@Override
	public List<QueryPushMsgQueryDto> queryPushMessageRecordMain(String id ,String msisdn ,String time) {
		//查詢結果
		List<MvPushMessageRecordMain> mvPushMessageRecordMain = new ArrayList<MvPushMessageRecordMain>();
		//要回傳的資料
		List<QueryPushMsgQueryDto> result = new ArrayList<QueryPushMsgQueryDto>();
		if(StringUtils.isNotBlank(id)){
			try{
				MvPushMessageRecordMainExample example = new MvPushMessageRecordMainExample();
				com.tstar.model.tapp.MvPushMessageRecordMainExample.Criteria criteria = example.createCriteria();
				criteria.andMessageidEqualTo(id);
				mvPushMessageRecordMain = mvPushMessageRecordMainMapper.selectByExample(example);				
				for(MvPushMessageRecordMain mvp : mvPushMessageRecordMain){
					QueryPushMsgQueryDto queryPushMsgQueryDto = new QueryPushMsgQueryDto();
					queryPushMsgQueryDto.setMessageid(id);
					queryPushMsgQueryDto.setMsisdn(msisdn);
					queryPushMsgQueryDto.setTime(time);
					queryPushMsgQueryDto.setMsgBody(mvp.getMessagebody());			
					queryPushMsgQueryDto.setMsgTitle(mvp.getMessagetitle());
					result.add(queryPushMsgQueryDto);
				}
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		return result;
	}
	
	
	@Override
	public boolean disablePushMessage(String osType, String id ,String msisdn){
		MvPushMessageRecordDetailExample example = new MvPushMessageRecordDetailExample();		
		com.tstar.model.tapp.MvPushMessageRecordDetailExample.Criteria criteria = example.createCriteria();
		criteria.andDeviceEqualTo(osType);
		criteria.andMessageidEqualTo(id);
		criteria.andMsisdnEqualTo(msisdn);
		
		MvPushMessageRecordDetail pushMessageRecordDetail= new MvPushMessageRecordDetail();
		pushMessageRecordDetail.setStatus("D");
		
		int rtn = mvPushMessageRecordDetailMapper.updateByExampleSelective(pushMessageRecordDetail, example);
		
		return 0 < rtn ? true : false;
	}
}
