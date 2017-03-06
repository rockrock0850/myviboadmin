package com.tstar.service;

import java.sql.Timestamp;
import java.util.List;

import com.tstar.dto.QueryPushMsgQueryDto;
import com.tstar.model.tapp.MvPushMessageRecordDetail;

public interface PushMsgQueryService {
	
	public List<MvPushMessageRecordDetail> queryMessageRecordDetail(Timestamp time, String msisdn, String osType);
	
	public List<QueryPushMsgQueryDto> queryPushMessageRecordMain(String id ,String msisdn,String time);
	
	public boolean disablePushMessage(String osType, String id ,String msisdn);
}
