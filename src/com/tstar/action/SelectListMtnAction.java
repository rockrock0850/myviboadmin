package com.tstar.action;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.Action;
import com.tstar.model.tapp.SelectList;
import com.tstar.service.SelectListService;

@Component
@Scope("prototype")
public class SelectListMtnAction implements Action{
	
	private final Logger logger = Logger.getLogger(SelectListMtnAction.class);
	
	@Autowired
	private SelectListService selectListService;

	private String serviceSel;//mytstar
    private String groupSel; // 頁面群組查詢
    private String statusSel;//1.0
    private String parentSel;//ROOT
    
    //用來修改DB
    private String idNo;
    private String serviceId;
    private String functionId;
    private String parentId;
    private String val;
    private String text;
    private String status;
    private String dscr;
    private String seq;
    private String currentUser;
   
    private String clickRecord;//紀錄頁面點選到哪一層
    //若頁面是一個array, 如[ROOT,20141020091002]，因為java這裡用clickRecord[] 接值，會變成clickRecordArray[0]=ROOT,20141020091002，不如預期
    //所以用String clickRecord來接值，結果為ROOT,20141020091002，再將其轉成List -->Json丟回jsp頁面，較好控制
    //private List<String> clickRecordList;
    //private String[] clickRecordArray;
    
    //丟回頁面的Json
    private String idChildIdMapJson;
    private String idTextMapJson;
    private String parentIdLevelMapJson;
    private String functionIdDscrMapJson;
    private String baseInfoMapJson;
    private String groupListJson;
    private String clickRecordListJson;
    
	public SelectListMtnAction() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public String execute() throws Exception{
		logger.info("----------------SelectListMtnAction.execute()---------------------");
		this.queryForSelectListMtn(this.serviceSel, this.statusSel, this.groupSel, this.parentSel);
		return SUCCESS;
    }
	
	public String add() throws Exception{
		logger.info("---------------SelectListMtnAction.add()--------------------------");
		selectListService.insertSelectList(this.serviceId, this.functionId, this.parentId, this.val, this.text, this.status, this.dscr, this.seq, this.currentUser);
		this.queryForSelectListMtn(this.serviceId, "1,0", this.functionId, "ROOT");
		
		//jsp頁面按下新增，修改時，頁面點到哪一層["ROOT", "parentId", "parentId",....]
		List<String> clickRecordList = Arrays.asList(clickRecord.split(","));
		JSONArray jsonArray = JSONArray.fromObject(clickRecordList);//用JSONObject，将map对象转换成json类型数据
	    this.clickRecordListJson = jsonArray.toString();//给result赋值，传递给页面
		
		return SUCCESS;
	}

	public String update() throws Exception{
		logger.info("---------------SelectListMtnAction.update()--------------------------");
		selectListService.updateSelectList(this.idNo, this.val, this.text, this.status, this.seq, this.currentUser);
		this.queryForSelectListMtn(this.serviceId, "1,0", this.functionId, "ROOT");
		
		//jsp頁面按下新增，修改時，頁面點到哪一層["ROOT", "parentId", "parentId",....]
		List<String> clickRecordList = Arrays.asList(clickRecord.split(","));
		JSONArray jsonArray = JSONArray.fromObject(clickRecordList);//用JSONObject，将map对象转换成json类型数据
	    this.clickRecordListJson = jsonArray.toString();//给result赋值，传递给页面
	    
		return SUCCESS;
	}

	public String addGroup() throws Exception{
		logger.info("---------------SelectListMtnAction.addGroup()--------------------------");
		String newFunctionId = selectListService.addGroupSelectList("mytstar", "ROOT", dscr, "1", this.currentUser);
		this.groupSel = newFunctionId;
		
		//因為是新增群組，所以只帶出第一層，第一筆
		this.queryForSelectListMtn(this.serviceId, "1,0", newFunctionId, "ROOT");
		return SUCCESS;
	}

	private void queryForSelectListMtn(String serviceId, String status, String functionId, String parentId){
		
		List<String> statusList = null;
		if(status != null){
			statusList = Arrays.asList(status.split(","));
		}
		
		List<SelectList> selectListResult = selectListService.selectHierarchy(serviceId, statusList, functionId, parentId);
		
		Map<String, List<SelectList>> map = new HashMap<String, List<SelectList>>();
		for(SelectList s1 : selectListResult){
			String id = s1.getId();
			List<SelectList> list = new ArrayList<SelectList>();
			for(SelectList s2 : selectListResult){
				if(id.equals(s2.getParentId())){
					list.add(s2);
				}
			}
			map.put(s1.getId(), list);
		}
		
		List<SelectList> listRoot = new ArrayList<SelectList>();
		Map<String, String> idTextMap = new HashMap<String, String>();
		Map<String, Short> parentIdLevelMap = new HashMap<String, Short>();
		Map<String, String> functionIdDscrMap = new HashMap<String, String>();
		
		
		for(SelectList s1 : selectListResult){
			if("ROOT".equals(s1.getParentId())){
				listRoot.add(s1);
			}
			idTextMap.put(s1.getId(), s1.getText());
			if(null != s1.getParentId()) parentIdLevelMap.put(s1.getParentId(), s1.getHierarchy());
			functionIdDscrMap.put(s1.getFunctionId(), s1.getDescription());
			
		}
		map.put("ROOT", listRoot);
		idTextMap.put("1", "有效");
		idTextMap.put("0", "停效");
		idTextMap.put("ROOT", "第1層");
		
		Map<String, String> baseInfoMap = new HashMap<String, String>();
		for(int i=0; i<selectListResult.size(); i++){
			if(i == 0){//只跑一次，因為只要取serviceId,functionId,dscr
				baseInfoMap.put("serviceId", selectListResult.get(i).getServiceId());
				baseInfoMap.put("functionId", selectListResult.get(i).getFunctionId());
				baseInfoMap.put("dscr", selectListResult.get(i).getDescription());
			}

		}
		
		List<SelectList> groupList = selectListService.getGroupList();
		
		//{id:[下一層的id,......];....}
		JSONObject jsonMap = JSONObject.fromObject(map);//用JSONObject，将map对象转换成json类型数据
        this.idChildIdMapJson = jsonMap.toString();//给result赋值，传递给页面
        //System.out.println("idParentIdJsonMap="+idChildIdMapJson);
        
        //{id:text;....}
        jsonMap = JSONObject.fromObject(idTextMap);//用JSONObject，将map对象转换成json类型数据
        this.idTextMapJson = jsonMap.toString();//给result赋值，传递给页面
        //System.out.println("idTextMapJson="+idTextMapJson);
        
        //{"ROOT":"1" ; parentId:Hierarchy(第幾層);....}
        jsonMap = JSONObject.fromObject(parentIdLevelMap);//用JSONObject，将map对象转换成json类型数据
        this.parentIdLevelMapJson = jsonMap.toString();//给result赋值，传递给页面
        //System.out.println("parentIdLevelMapJson="+parentIdLevelMapJson);
        
        //{functionId : description ;....}
        //jsonMap = JSONObject.fromObject(functionIdDscrMap);//用JSONObject，将map对象转换成json类型数据
        //this.functionIdDscrMapJson = jsonMap.toString();//给result赋值，传递给页面
        //System.out.println("functionIdDscrMapJson="+functionIdDscrMapJson);
        
        //{serviceId:mytstar ; functionId:compareSelect001 ; dscr:電信資費}
        jsonMap = JSONObject.fromObject(baseInfoMap);//用JSONObject，将map对象转换成json类型数据
        this.baseInfoMapJson = jsonMap.toString();//给result赋值，传递给页面
        //System.out.println("baseInfoMapJson="+baseInfoMapJson);
        
        //查詢群組下拉選單用[functionId : description]
        JSONArray jsonArray = JSONArray.fromObject(groupList);//用JSONObject，将map对象转换成json类型数据
        this.groupListJson = jsonArray.toString();//给result赋值，传递给页面
        //System.out.println("groupListJson="+groupListJson);
        
        //jsp頁面按下新增，修改時，頁面點到哪一層["ROOT", "parentId", "parentId",....]
        jsonArray = JSONArray.fromObject(new ArrayList<String>());
        this.clickRecordListJson = jsonArray.toString();
        //System.out.println("clickRecordListJson="+clickRecordListJson);
        
	}
	
	public String getIdChildIdMapJson() {
		return idChildIdMapJson;
	}

	public void setIdChildIdMapJson(String idChildIdMapJson) {
		this.idChildIdMapJson = idChildIdMapJson;
	}

	public String getGroupSel() {
		return groupSel;
	}

	public void setGroupSel(String groupSel) {
		this.groupSel = groupSel;
	}

	public String getIdTextMapJson() {
		return idTextMapJson;
	}

	public void setIdTextMapJson(String idTextMapJson) {
		this.idTextMapJson = idTextMapJson;
	}

	public String getParentIdLevelMapJson() {
		return parentIdLevelMapJson;
	}

	public void setParentIdLevelMapJson(String parentIdLevelMapJson) {
		this.parentIdLevelMapJson = parentIdLevelMapJson;
	}

	public String getFunctionIdDscrMapJson() {
		return functionIdDscrMapJson;
	}

	public void setFunctionIdDscrMapJson(String functionIdDscrMapJson) {
		this.functionIdDscrMapJson = functionIdDscrMapJson;
	}

	public String getIdNo() {
		return idNo;
	}

	public void setIdNo(String idNo) {
		this.idNo = idNo;
	}

	public String getServiceId() {
		return serviceId;
	}

	public void setServiceId(String serviceId) {
		this.serviceId = serviceId;
	}

	public String getFunctionId() {
		return functionId;
	}

	public void setFunctionId(String functionId) {
		this.functionId = functionId;
	}

	public String getParentId() {
		return parentId;
	}

	public void setParentId(String parentId) {
		this.parentId = parentId;
	}

	public String getVal() {
		return val;
	}

	public void setVal(String val) {
		this.val = val;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getDscr() {
		return dscr;
	}

	public void setDscr(String dscr) {
		this.dscr = dscr;
	}

	public String getSeq() {
		return seq;
	}

	public void setSeq(String seq) {
		this.seq = seq;
	}

	public String getBaseInfoMapJson() {
		return baseInfoMapJson;
	}

	public void setBaseInfoMapJson(String baseInfoMapJson) {
		this.baseInfoMapJson = baseInfoMapJson;
	}

	public String getGroupListJson() {
		return groupListJson;
	}

	public void setGroupListJson(String groupListJson) {
		this.groupListJson = groupListJson;
	}

	public String getClickRecord() {
		return clickRecord;
	}

	public void setClickRecord(String clickRecord) {
		this.clickRecord = clickRecord;
	}

	public String getClickRecordListJson() {
		return clickRecordListJson;
	}

	public void setClickRecordListJson(String clickRecordListJson) {
		this.clickRecordListJson = clickRecordListJson;
	}

	public String getServiceSel() {
		return serviceSel;
	}

	public void setServiceSel(String serviceSel) {
		this.serviceSel = serviceSel;
	}

	public String getStatusSel() {
		return statusSel;
	}

	public void setStatusSel(String statusSel) {
		this.statusSel = statusSel;
	}

	public String getParentSel() {
		return parentSel;
	}

	public void setParentSel(String parentSel) {
		this.parentSel = parentSel;
	}

	public String getCurrentUser() {
		return currentUser;
	}

	public void setCurrentUser(String currentUser) {
		this.currentUser = currentUser;
	}

}
