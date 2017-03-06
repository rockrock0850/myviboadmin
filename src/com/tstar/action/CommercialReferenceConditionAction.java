package com.tstar.action;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.Action;
import com.tstar.model.tapp.CommercialReference;
import com.tstar.model.tapp.SystemLookup;
import com.tstar.service.CommercialReferenceService;
import com.tstar.service.SystemLookupService;

@Component
@Scope("prototype")
public class CommercialReferenceConditionAction implements Action{
	private final Logger logger = Logger.getLogger(CommercialReferenceConditionAction.class);
	private String msidn;
	private String contractId;
	private String sourceId;
	private String osAction;
	private String status;
	private String createtimestart;
	private String createtimeend;
	private String dataId;
	private String dataStatus;
	private String updateStatus;
	private JSONObject actionselect;
	private List<CommercialReference> commercialReference;
	
	@Autowired
	private CommercialReferenceService cmmercialReferenceService;
	
	@Autowired
	private SystemLookupService systemLookupService;
	
	@Override
	public String execute() throws Exception {
		actionselect = actionSelectData();
		return SUCCESS;
	}
	
	public String queryList(){
		logger.info(" msidn : "+msidn+" contractId : "+contractId+" sourceId : "+sourceId +
				" osAction : "+osAction+" status :"+status+" createtimestart : "+createtimestart+" createtimeend : "+createtimeend);
		actionselect = actionSelectData();
		commercialReference = getcommerial(msidn, contractId, sourceId, osAction, status, createtimestart, createtimeend);	
		if(commercialReference == null){
			updateStatus = "查無資料";
		}
		return SUCCESS;
	}
	public String changeStatus(){
		logger.info("dataId : "+dataId +" dataStatus : "+dataStatus);
		boolean dbStatus = cmmercialReferenceService.updateStatus(dataId, dataStatus);
		if(dbStatus){
			updateStatus = "更新成功";
		}else{
			updateStatus = "更新失敗";
		}
		actionselect = actionSelectData();//存放action下拉選單資料
		commercialReference = getcommerial(msidn, contractId, sourceId, osAction, status, createtimestart, createtimeend);
		return SUCCESS;
	}
	
	public JSONObject actionSelectData(){
		List<SystemLookup> systemLookupList = systemLookupService.getLikeValueAsc("mytstar","commercial_reference_action.");
//		Map<String, Object> actionSelectData = new TreeMap<String, Object>();//存放action下拉選單資料	
		if(systemLookupList.size() > 0){
//			for(int i = 0; i < systemLookupList.size(); i++){
//				actionSelectData.add(systemLookupList.get(i).getValue());
//				logger.debug("Systemlookuplist:"+systemLookupList.size());
//				logger.debug("Systemlookuplist:"+actionSelectData.get(i));
//			}	
			return JSONObject.fromObject(systemLookupList.get(0).getValue());
		}
		return null;
	}
	
	public List<CommercialReference> getcommerial(String msidn,String contractId,String sourceId, String osAction ,String status ,String createtimestart ,String createtimeend){
		List<SystemLookup> systemLookupList = systemLookupService.getLikeValueAsc("mytstar","commercial_reference_action.");
		Timestamp timestampstart =null;
		Timestamp timestampend =null;
		if(StringUtils.isNotBlank(createtimestart) & StringUtils.isNotBlank(createtimeend)){
			createtimestart = createtimestart.replace("/", "-");//日期格式轉換把/轉成-
			timestampstart = Timestamp.valueOf(createtimestart);//轉換timestamp格式
			createtimeend = createtimeend.replace("/", "-");
			timestampend = Timestamp.valueOf(createtimeend);
		}
		List<CommercialReference> resultData = cmmercialReferenceService.queryCommercialReferenceCondition(msidn, contractId, sourceId, osAction, status,timestampstart,timestampend);
		if(resultData.size()>0){
			List<String> actiondata = null;//存放action資料
			//把systemLookupList查詢完的資料放入actiondata
			if(systemLookupList.size()>0){
				actiondata = new ArrayList<String>();
				JSONObject actions = JSONObject.fromObject(systemLookupList.get(0).getValue());
				for(CommercialReference commercialReference : resultData){
					Set<String> keys = actions.keySet();
					for(String key : keys){
						if(key.equals(commercialReference.getAction())){
							actiondata.add(actions.getString(key));
						}
					}
				}
			}
			if(actiondata != null){
				for(int i=0;i<resultData.size();i++){
					logger.debug("action:" + actiondata.get(i));
					resultData.get(i).setAction(actiondata.get(i));
				}
			}		
			return resultData;
		}
		return null;
	}
	public String getMsidn() {
		return msidn;
	}

	public void setMsidn(String msidn) {
		this.msidn = msidn;
	}

	public String getContractId() {
		return contractId;
	}

	public void setContractId(String contractId) {
		this.contractId = contractId;
	}

	public String getSourceId() {
		return sourceId;
	}

	public void setSourceId(String sourceId) {
		this.sourceId = sourceId;
	}
	
	public String getOsAction() {
		return osAction;
	}

	public void setOsAction(String osAction) {
		this.osAction = osAction;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	public String getDataId() {
		return dataId;
	}

	public void setDataId(String dataId) {
		this.dataId = dataId;
	}

	public String getDataStatus() {
		return dataStatus;
	}

	public void setDataStatus(String dataStatus) {
		this.dataStatus = dataStatus;
	}

	public List<CommercialReference> getCommercialReference() {
		return commercialReference;
	}

	public void setCommercialReference(List<CommercialReference> commercialReference) {
		this.commercialReference = commercialReference;
	}

	public String getCreatetimestart() {
		return createtimestart;
	}

	public void setCreatetimestart(String createtimestart) {
		this.createtimestart = createtimestart;
	}

	public String getCreatetimeend() {
		return createtimeend;
	}

	public void setCreatetimeend(String createtimeend) {
		this.createtimeend = createtimeend;
	}

	public String getUpdateStatus() {
		return updateStatus;
	}

	public void setUpdateStatus(String updateStatus) {
		this.updateStatus = updateStatus;
	}

	public JSONObject getActionselect() {
		return actionselect;
	}

	public void setActionselect(JSONObject actionselect) {
		this.actionselect = actionselect;
	}
}
