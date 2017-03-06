package com.tstar.cron;

import java.net.InetAddress;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.builder.ReflectionToStringBuilder;
import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.tstar.model.tapp.SystemLookup;
import com.tstar.model.tapp.TransactionLog;
import com.tstar.service.SystemLookupService;
import com.tstar.service.TransactionLogService;
import com.tstar.service.TspService;
import com.tstar.utility.PropertiesUtil;
import com.tstar.utility.Utils;

@Component
public class CronSelfCheck{
	private final Logger logger = Logger.getLogger(CronSelfCheck.class);

	@Autowired
	TransactionLogService transactionLogService;
	
	@Autowired
	TspService tspService;
	
	@Autowired
	SystemLookupService systemLookupService;

	@Autowired
	PropertiesUtil propertiesUtil;
	
	@Autowired
	ApplicationContext context;
	
	/**
	 * cron - 固定的時間或週期，週期式行為同 fixedRate
	 * 固定六個值：秒(0-59) 分(0-59) 時(0-23) 日(1-31) 月(1-12) 週(1,日-7,六)
	 * 日與週互斥，其中之一必須為 ?
	 * 可使用的值有：單一數值（26）、範圍（50-55）、清單（9,10）、不指定（*）與週期（* /3）
	 *
	 * @Scheduled(cron="0 0 6,12,18 * * ?")
	 * @Scheduled(cron="0 * /2 * * * ?")
	 * @Scheduled(fixedDelay = 5000)
	 * 
	 * @throws Exception
	 */
//	@Scheduled(cron="${cron.self.check.fq}")
    public void run(){
    	List<SystemLookup> systemLookups = systemLookupService.getLikeValue("mytstar", "SELF_CHECK_TSP_");
    	
    	if(0 == systemLookups.size()){
			logger.info("Error-No default data");
    	}else{
        	String ip = Utils.getRealIpAddress();// 取得IP位置  
    		String id = String.valueOf(Calendar.getInstance().getTimeInMillis());
    		int seq = 0;
	    	List<TransactionLog> records = new ArrayList<TransactionLog>();
			for(SystemLookup systemLookup : systemLookups){
				String api = systemLookup.getKey().replace("SELF_CHECK_TSP_", "");
		    	TransactionLog record = new TransactionLog();
    			record.setId(id);
    			record.setSeq(String.valueOf(++seq));
    			record.setAction(api);
    			record.setRequestIp(ip);
				if(null == systemLookup.getValue()){
        			logger.debug("Error-NullPointException of key or values");
        			records.add(failTxLog(record));
				}else{
					try {
	            		JSONObject values = new JSONObject(systemLookup.getValue());

//	            		tsp_CMS_BIL_url
	            		if(StringUtils.equalsIgnoreCase(api, "remainVal")){
	            			logger.debug("RemainVal input: " + values);
	            	        
	            	        long begin = Calendar.getInstance().getTimeInMillis();
	            			net.sf.json.JSONObject returnJson = tspService.remainVal(
	            					values.optString("contract_id"), values.optString("msisdn"), values.optString("account_num"), ip);
	            	        long end = Calendar.getInstance().getTimeInMillis();
	            	        
	            	        records.add(txLog(record, values, returnJson, propertiesUtil.getProperty("tsp_CMS_BIL_url"), null, null, end - begin));
	            		}

//	            		tsp_CMS_CRM_url
	            		else if(StringUtils.equalsIgnoreCase(api, "queryTicket")){
	            			logger.debug("QueryTicket input: " + values);
	            	        
	            	        long begin = Calendar.getInstance().getTimeInMillis();
	            			net.sf.json.JSONObject returnJson = tspService.queryTicket(
	            					values.optString("contract_id"), values.optString("msisdn"), values.optString("account_num"), 
	            					values.optString("ticket_id"), values.optString("year"), values.optString("month"), 
	            					values.optString("conn_ip"));
	            	        long end = Calendar.getInstance().getTimeInMillis();
	            	        
	            	        records.add(txLog(record, values, returnJson, propertiesUtil.getProperty("tsp_CMS_CRM_url"), null, null, end - begin));
	            		}

//	            		tsp_CMS_EXTEND_url
	            		else if(StringUtils.equalsIgnoreCase(api, "contactUsReplyRead")){
	            			logger.debug("ContactUsReplyRead input: " + values);
	            	        
	            	        long begin = Calendar.getInstance().getTimeInMillis();
	            			net.sf.json.JSONObject returnJson = tspService.contactUsReplyRead(values.optString("issue_id"));
	            	        long end = Calendar.getInstance().getTimeInMillis();
	            	        
	            	        records.add(txLog(record, values, returnJson, propertiesUtil.getProperty("tsp_CMS_EXTEND_url"), null, null, end - begin));
	            		}else if(StringUtils.equalsIgnoreCase(api, "contactUsIssueAddAgain")){
	            			logger.debug("ContactUsIssueAddAgain input: " + values);

	            			long begin = Calendar.getInstance().getTimeInMillis();
	            			net.sf.json.JSONObject returnJson = tspService.contactUsIssueAddAgain(
	            					values.optString("issue_id"), values.optString("issue_note"));
	            	        long end = Calendar.getInstance().getTimeInMillis();
	            	        
	            	        records.add(txLog(record, values, returnJson, propertiesUtil.getProperty("tsp_CMS_EXTEND_url"), null, null, end - begin));
	            		}else if(StringUtils.equalsIgnoreCase(api, "zipCode")){
	            			logger.debug("ZipCode input: " + values);
	            	        
	            	        long begin = Calendar.getInstance().getTimeInMillis();
	            			net.sf.json.JSONObject returnJson = tspService.zipCode(values.optString("function_type"));
	            	        long end = Calendar.getInstance().getTimeInMillis();
	            	        
	            	        records.add(txLog(record, values, returnJson, propertiesUtil.getProperty("tsp_CMS_EXTEND_url"), null, null, end - begin));
	            		}else if(StringUtils.equalsIgnoreCase(api, "retail")){
	            			logger.debug("Retail input: " + values);
	            	        
	            	        long begin = Calendar.getInstance().getTimeInMillis();
	            			net.sf.json.JSONObject returnJson = tspService.retail(values.optString("zip_code"), values.optString("address"));
	            	        long end = Calendar.getInstance().getTimeInMillis();
	            	        
	            	        records.add(txLog(record, values, returnJson, propertiesUtil.getProperty("tsp_CMS_EXTEND_url"), null, null, end - begin));
	            		}else if(StringUtils.equalsIgnoreCase(api, "depositBankInfo")){
	            			logger.debug("DepositBankInfo input: " + values);
	            	        
	            	        long begin = Calendar.getInstance().getTimeInMillis();
	            			net.sf.json.JSONObject returnJson = tspService.depositBankInfo();
	            	        long end = Calendar.getInstance().getTimeInMillis();
	            	        
	            	        records.add(txLog(record, values, returnJson, propertiesUtil.getProperty("tsp_CMS_EXTEND_url"), null, null, end - begin));
	            		}else if(StringUtils.equalsIgnoreCase(api, "cwsOptions")){
	            			logger.debug("CWSOptions input: " + values);
	            	        
	            	        long begin = Calendar.getInstance().getTimeInMillis();
	            			net.sf.json.JSONObject returnJson = tspService.cwsOptions();
	            	        long end = Calendar.getInstance().getTimeInMillis();
	            	        
	            	        records.add(txLog(record, values, returnJson, propertiesUtil.getProperty("tsp_CMS_EXTEND_url"), null, null, end - begin));
	            		}else if(StringUtils.equalsIgnoreCase(api, "cwsContactUS")){
	            			logger.debug("CWSContactUS input: " + values);
	            	        
	            	        long begin = Calendar.getInstance().getTimeInMillis();
	            			net.sf.json.JSONObject returnJson = tspService.cwsContactUS(values);
	            	        long end = Calendar.getInstance().getTimeInMillis();
	            	        
	            	        records.add(txLog(record, values, returnJson, propertiesUtil.getProperty("tsp_CMS_EXTEND_url"), null, null, end - begin));
	            		}else if(StringUtils.equalsIgnoreCase(api, "contactUsIssueQuery")){
	            			logger.debug("ContactUsIssueQuery input: " + values);
	            	        
	            	        long begin = Calendar.getInstance().getTimeInMillis();
	            			net.sf.json.JSONObject returnJson = tspService.contactUsIssueQuery(values.optString("contract_id"), values.optString("start_date"));
	            	        long end = Calendar.getInstance().getTimeInMillis();
	            	        
	            	        records.add(txLog(record, values, returnJson, propertiesUtil.getProperty("tsp_CMS_EXTEND_url"), null, null, end - begin));
	            		}
					} catch (Exception e) {
						e.printStackTrace();
	    				records.add(failTxLog(record));
					}
        		}
        	}
        	for(TransactionLog record : records){
        		try {
        			logger.info("Aciton name-" + record.getAction() + ":" + ReflectionToStringBuilder.toString(record));
        			transactionLogService.insertTransactionLogSelective(record);
				} catch (Exception e) {
					logger.info(record.getAction() + " Error-" + e.getMessage());
				}
        	}
    	}
	}

	private TransactionLog txLog(TransactionLog record, JSONObject values, net.sf.json.JSONObject returnJson, String destinationUrl, String MEMO1, String MEMO2, long duration){
		try {
			record.setMsisdn(values.optString("msisdn"));
			record.setContractId(values.optString("contract_id"));
			record.setAccountNumber(values.optString("account_num"));
			values.remove("msisdn");
			values.remove("contract_id");
			values.remove("account_num");
			record.setKeys(new Utils().subOracleStringByLength(values.toString(), 30));
			record.setRequestValue(null);
			record.setDestinationSystem("TSP");
			record.setDestinationUrl(destinationUrl);
			record.setReturnCode(returnJson.optString("status"));
			record.setReturnValue(new Utils().subOracleStringByLength(returnJson.toString(), 1000));
			record.setMemo1(MEMO1);
			record.setMemo2(MEMO2);
			record.setStatus("1");
			record.setDuration(duration);
			record.setCreateUser(InetAddress.getLocalHost().getHostName());
			record.setCreateTime(new Timestamp(System.currentTimeMillis()));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return record;
	}
	
	private TransactionLog failTxLog(TransactionLog record){
		try {
			record.setMemo1("API錯誤-資料量不足");
			record.setStatus("0");
			record.setCreateUser(InetAddress.getLocalHost().getHostName());
			record.setCreateTime(new Timestamp(System.currentTimeMillis()));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return record;
	}
}
