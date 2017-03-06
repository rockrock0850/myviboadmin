package com.tstar.service;

import org.springframework.scheduling.annotation.Scheduled;

import com.tstar.dto.TspDto;

import net.sf.json.JSONObject;

public interface TspService{
	/**
	 * 申請掛失
	 * @param msisdn
	 * @param accountNum
	 * @param contractId
	 * @param connIp
	 * @return
	 */
	public JSONObject simLostServiceApply(TspDto tspDto);
	
	/**
	 * 申請停話
	 * @param msisdn
	 * @param accountNum
	 * @param contractId
	 * @param connIp
	 * @return
	 */
	public JSONObject simDisableServiceApply(TspDto tspDto);
	
	/**
	 * 換補卡申請
	 * @param tspDto (sendType=0:遺失/1:卡片毀損/2:爆卡)
	 * @return
	 */
	public JSONObject insTroubleTicket(TspDto tspDto);
	
	/**
	 * 查詢預繳款餘額
	 * @param contractId
	 * @param MSISDN
	 * @param accountNum
	 * @param ip
	 * @return
	 */
	public JSONObject remainVal(String contractId, String MSISDN, String accountNum, String ip);
	
	/**
	 * 後送案件查詢
	 * @param contractId
	 * @param MSISDN
	 * @param accountNum
	 * @param ticketid
	 * @param year
	 * @param month
	 * @param ip
	 * @return
	 */
	public JSONObject queryTicket(String contractId, String MSISDN, String accountNum, String ticketid, String year, String month, String ip);
	
	/**
	 * 回覆已讀
	 * @param issueId
	 * @return
	 */
	public JSONObject contactUsReplyRead(String issueId);
	
	/**
	 * 客服信箱-再發問
	 * @param issueId
	 * @param issueNote
	 * @return
	 */
	public JSONObject contactUsIssueAddAgain(String issueId, String issueNote);

	/**
	 * 郵遞區號
	 * @param apiAccount
	 * @param apiPassword
	 * @param FunctionType
	 * @return
	 */
	public JSONObject zipCode(String FunctionType);
	
	/**
	 * 門市查詢
	 * @param zipcode
	 * @param address
	 * @return
	 */
	public JSONObject retail(String zipCode ,String address);
	
	 /**
	  * 刷新cache機制
	  * 目前可刷新api:zipCode、retail、cwsOptions
	  * @return
	  */
	public JSONObject refreshCache(String[] apis);

	/**
	 * 銀行行號
	 * @return
	 */
	public JSONObject depositBankInfo();

	/**
	 * Tstar app 客服信箱-意見類別
	 * @return
	 */
	public JSONObject cwsOptions();

	/**
	 * 紀錄客服信箱之問題
	 * @param jsonReq 
	 * @return
	 */
	public JSONObject cwsContactUS(org.json.JSONObject formData);

	/**
	 * 問答紀錄
	 * @param contractId 
	 * @param startDate 
	 * @return
	 */
	public JSONObject contactUsIssueQuery(String contractId, String startDate);
		
	public void retailRefreshDetector() ;
	
	public void cwsOptionsRefreshDetector() ;
}
