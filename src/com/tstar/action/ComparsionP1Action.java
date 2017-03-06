package com.tstar.action;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
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
import com.tstar.dto.ProjectDeviceDto;
import com.tstar.model.custom.ProjectDevice;
import com.tstar.model.custom.ProjectRate;
import com.tstar.model.tapp.SelectList;
import com.tstar.service.ComparsionService;
import com.tstar.service.SelectListService;
import com.tstar.service.SystemLookupService;


public class ComparsionP1Action implements Action{
	
	private final Logger logger = Logger.getLogger(ComparsionP1Action.class);
	
	@Autowired
	private ComparsionService comparsionService;
	
	@Autowired
	private SystemLookupService systemLookupService;
	
	@Autowired
	private SelectListService selectListService;
	
	private String company_sel;
	private String fee_sel;
	private String fee_range;
	private ProjectRate projectRateTstar;
	private ProjectRate projectRateChosen;
	private Map<String, ProjectDeviceDto> projectDevicemap;
	private List<ProjectDeviceDto> ProjectDeviceDtoOrder;
	private String feeRangeData;/*返回頁面下拉選單所需的值的Json String*/
	private String feeSelData;/*返回頁面下拉選單所需的值的Json String*/
	private String companySelData;/*返回頁面下拉選單所需的值的Json String*/
	private String fee_type;
	private String typeSelData;
	
	public String execute() throws Exception{
		logger.info("ComparsionP1Action.execute()");
        this.getSelectList();
		return SUCCESS;
    }

	public String compare() throws Exception{
		logger.info("ComparsionAction.compare()");
		
		this.getSelectList();
		
		if(null == fee_sel || "".equals(fee_sel)){
			return execute();
		}
		
		String[] feeRange = fee_sel.split("~");
		
		// 台灣之星id=1
		//取得台灣之星符合條件的最低資費
		projectRateTstar = comparsionService.comparseProjectSelectMin("1", feeRange[0], feeRange[1], fee_type);
		//取得上述資費的所有搭配手機方案
		List<ProjectDevice> projectDeviceListTstar = comparsionService.getProjectByRateId(projectRateTstar.getRateId());
		//取得選擇對手符合條件的最低資費
		projectRateChosen = comparsionService.comparseProjectSelectMin(company_sel, feeRange[0], feeRange[1], fee_type);
		//取得上述資費的所有搭配手機方案
		List<ProjectDevice> projectDeviceListChosen = comparsionService.getProjectByRateId(projectRateChosen.getRateId());
		
		//將所有專案搭手機的清單整合
		projectDevicemap = new HashMap<String, ProjectDeviceDto>();
		//台灣之星的清單
		for(ProjectDevice projectDevice : projectDeviceListTstar){
			if(projectDevicemap.containsKey(projectDevice.getDeviceName())){
				ProjectDeviceDto projectDeviceDto = projectDevicemap.get(projectDevice.getDeviceName());
				projectDeviceDto.setPriceTstar(projectDevice.getPrice());
				projectDeviceDto.setPrepaymentAmountTstar(projectDevice.getPrepaymentAmount());
			}else{
				ProjectDeviceDto projectDeviceDto = new ProjectDeviceDto();
				projectDeviceDto.setDeviceModel(projectDevice.getDeviceModel());
				projectDeviceDto.setDeviceName(projectDevice.getDeviceName());
				projectDeviceDto.setPriceTstar(projectDevice.getPrice());
				projectDeviceDto.setProjectName(projectDevice.getProjectName());
				projectDeviceDto.setPrepaymentAmountTstar(projectDevice.getPrepaymentAmount());
				projectDevicemap.put(projectDevice.getDeviceName(), projectDeviceDto);
			}
		}
		//塞要比較電信的資料
		for(ProjectDevice projectDevice : projectDeviceListChosen){
			if(projectDevicemap.containsKey(projectDevice.getDeviceName())){
				ProjectDeviceDto projectDeviceDto = projectDevicemap.get(projectDevice.getDeviceName());
				projectDeviceDto.setPriceChosen(projectDevice.getPrice());
				projectDeviceDto.setPrepaymentAmountChosen(projectDevice.getPrepaymentAmount());
			}else{
				ProjectDeviceDto projectDeviceDto = new ProjectDeviceDto();
				projectDeviceDto.setDeviceModel(projectDevice.getDeviceModel());
				projectDeviceDto.setDeviceName(projectDevice.getDeviceName());
				projectDeviceDto.setPriceChosen(projectDevice.getPrice());
				projectDeviceDto.setProjectName(projectDevice.getProjectName());
				projectDeviceDto.setPrepaymentAmountChosen(projectDevice.getPrepaymentAmount());
				projectDevicemap.put(projectDevice.getDeviceName(), projectDeviceDto);
			}
		}
		
		ProjectDeviceDtoOrder = new ArrayList<ProjectDeviceDto>();
		for(String deviceName : projectDevicemap.keySet()){
			logger.info("手機名稱: " + deviceName + " 專案名稱: " + projectDevicemap.get(deviceName).getProjectName() 
					+ " T: " + projectDevicemap.get(deviceName).getPriceTstar()
					+ " C: " + projectDevicemap.get(deviceName).getPriceChosen());
			ProjectDeviceDtoOrder.add(projectDevicemap.get(deviceName));
		}
		//確定有值再比較
		if(null != projectDeviceListTstar && 0 < projectDeviceListTstar.size()){
			//製造排序
			Collections.sort(ProjectDeviceDtoOrder, new Comparator<ProjectDeviceDto>() {
	            public int compare(ProjectDeviceDto o1, ProjectDeviceDto o2) {
	            	Integer o1Price = 0;
	            	Integer o2Price = 0;
	            	try{
		            	o1Price = Integer.parseInt(o1.getPriceTstar());
	            	}catch(Exception e){
	            		logger.debug("deviceName: " + o1.getDeviceName() + " 金額錯誤: " + e.getCause());
	            	}
	            	try{
		            	o2Price = Integer.parseInt(o2.getPriceTstar());
	            	}catch(Exception e){
	            		logger.debug("deviceName: " + o1.getDeviceName() + " 金額錯誤: " + e.getCause());
	            	}
	            	return o1Price.compareTo(o2Price);
	            }
	        });
		}
		
		
//		for(ProjectDeviceDto dto : ProjectDeviceDtoOrder){
//			logger.info("手機名稱: " + dto.getDeviceName() + " 專案名稱: " + dto.getPriceTstar()); 
//		}
		
		return SUCCESS;
    }
    
	/*取得comparsion.jsp頁面下拉選單的值*/
	private void getSelectList(){
		/*組成comparsion.jsp頁面下拉選單的Json資料，第一層:資費範圍，第二層:選擇資費*/
		List<Object> feeTypeList = new ArrayList<Object>();
		Map<String, Object> feeTypeKeyMap = new HashMap<String, Object>();
		Map<String, Object> feeRangeKeyMap = new HashMap<String, Object>();
		Map<String, Object> feeRangeMap = new HashMap<String, Object>();
		Map<String, Object> feeSelMap = new HashMap<String, Object>();
        
        List<SelectList> selectListFee = selectListService.querySelectList("mytstar", "1", "comparsionSelect001");
        /*組第一層:資費類型*/
        for(SelectList root : selectListFee){
        	Map<String, Object> typeItemMap = new HashMap<String, Object>();
        	if("ROOT".equals(root.getParentId())){
        		typeItemMap.put("text", root.getText());
        		typeItemMap.put("value", root.getVal());
            	feeTypeList.add(typeItemMap);
            	feeTypeKeyMap.put(root.getId(), root.getVal());
        	}
        }
        /*組第二層:資費範圍*/
        for(String key : feeTypeKeyMap.keySet()){
        	List<Object> feeRangeList = new ArrayList<Object>();
        	for(SelectList list : selectListFee){
            	Map<String, Object> rangeItemMap = new HashMap<String, Object>();
            	if(key.equals(list.getParentId())){
            		rangeItemMap.put("text", list.getText());
                	rangeItemMap.put("value", list.getId());
                	feeRangeList.add(rangeItemMap);
                	feeRangeKeyMap.put(list.getId(), list.getVal());
            	}
            }
        	//key=parentId, value=list of select
        	feeRangeMap.put((String)feeTypeKeyMap.get(key), feeRangeList);
        }
        
        /*組第三層:選擇資費*/
        for(String key : feeRangeKeyMap.keySet()){
        	List<Object> feeSelList = new ArrayList<Object>();
        	for(SelectList list : selectListFee){
            	Map<String, Object> selItemMap = new HashMap<String, Object>();
            	if(key.equals(list.getParentId())){
            		selItemMap.put("text", list.getText());
            		selItemMap.put("value", list.getVal());
            		feeSelList.add(selItemMap);
            	}
            }
        	//key=parentId, value=list of select
        	feeSelMap.put(key, feeSelList);
        }
        
        /*組成comparsion.jsp頁面下拉選單的Json資料，第一層:選擇其他電信業者*/
        Map<String, Object> companySelMap = new HashMap<String, Object>();
        List<Object> companySelList = new ArrayList<Object>();
        
        List<SelectList> selectListCo = selectListService.querySelectList("mytstar", "1", "comparsionSelect002");
        for(SelectList root : selectListCo){
        	/*組第一層:選擇其他電信業者*/
        	Map<String, Object> companySelItemMap = new HashMap<String, Object>();
        	companySelItemMap.put("text", root.getText());
        	companySelItemMap.put("value", root.getVal());
        	companySelList.add(companySelItemMap);
        }
        companySelMap.put("companySel", companySelList);
        
        JSONObject json = JSONObject.fromObject(feeRangeMap);//將map對象轉換成json類型數據
        System.out.println("json: " + json);
        feeRangeData = json.toString();//給result賦值，傳遞給頁面
        
        json = JSONObject.fromObject(feeSelMap);//將map對象轉換成json類型數據
        feeSelData = json.toString();//給result賦值，傳遞給頁面
        
        json = JSONObject.fromObject(companySelMap);//將map對象轉換成json類型數據
        companySelData = json.toString();//給result賦值，傳遞給頁面
        
        JSONArray jsonArray = JSONArray.fromObject(feeTypeList);//將map對象轉換成json類型數據
        typeSelData = jsonArray.toString();//給result賦值，傳遞給頁面
        
        
        /*
         * 選單一
         * 組成comparsion.jsp頁面資費類型下拉選單的Json資料
         * */
//        Map<String, Object> typeSelMap = new HashMap<String, Object>();
//        List<Object> typeSelList = new ArrayList<Object>();
//        List<SelectList> selectListType = selectListService.querySelectList("mytstar", "1", "comparsionSelect004");
//        for(SelectList root : selectListType){
//        	/*組第一層:選擇其他電信業者*/
//        	Map<String, Object> typeSelItemMap = new HashMap<String, Object>();
//        	typeSelItemMap.put("text", root.getText());
//        	typeSelItemMap.put("value", root.getVal());
//        	typeSelList.add(typeSelItemMap);
//        }
//        System.out.println("size: " + typeSelList.size());
//        typeSelMap.put("typeSel", typeSelList);
//        
//        json = JSONObject.fromObject(typeSelMap);//將map對象轉換成json類型數據
//        System.out.println("json: " + json);
//        typeSelData = json.toString();//給result賦值，傳遞給頁面
	}
	
    public String getCompanyName(){
    	if("1".equals(company_sel)){
			return "台灣之星";
		}else if("2".equals(company_sel)){
			return "中華電信";
		}else if("3".equals(company_sel)){
			return "遠傳電信";
		}else if("4".equals(company_sel)){
			return "台灣大哥大";
		}
    	return "";
    }
    
    public String getPsString(){
    	return systemLookupService.getValue("mytstar", "app_compare_ps");
    }
    
 
	public void setCompany_sel(String company_sel) {
		this.company_sel = company_sel;
	}
	public void setFee_sel(String fee_sel) {
		this.fee_sel = fee_sel;
	}

	public ProjectRate getProjectRateChosen() {
		return projectRateChosen;
	}

	public ProjectRate getProjectRateTstar() {
		return projectRateTstar;
	}

	public String getCompany_sel() {
		return company_sel;
	}

	public String getFee_sel() {
		return fee_sel;
	}

	public String getFee_range() {
		return fee_range;
	}

	public void setFee_range(String fee_range) {
		this.fee_range = fee_range;
	}

	public Map<String, ProjectDeviceDto> getProjectDevicemap() {
		return projectDevicemap;
	}
	
	public String getFeeRangeData() {
		return feeRangeData;
	}

	public void setFeeRangeData(String feeRangeData) {
		this.feeRangeData = feeRangeData;
	}

	public String getFeeSelData() {
		return feeSelData;
	}

	public void setFeeSelData(String feeSelData) {
		this.feeSelData = feeSelData;
	}
	
	public String getCompanySelData() {
		return companySelData;
	}

	public void setCompanySelData(String companySelData) {
		this.companySelData = companySelData;
	}


	public List<ProjectDeviceDto> getProjectDeviceDtoOrder() {
		return ProjectDeviceDtoOrder;
	}

	public void setProjectDeviceDtoOrder(
			List<ProjectDeviceDto> projectDeviceDtoOrder) {
		ProjectDeviceDtoOrder = projectDeviceDtoOrder;
	}


	public String getTypeSelData() {
		return typeSelData;
	}

	public String getFee_type() {
		return fee_type;
	}

	public void setFee_type(String fee_type) {
		this.fee_type = fee_type;
	}
}
