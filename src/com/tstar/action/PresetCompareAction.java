package com.tstar.action;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.apache.poi.POIXMLException;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.FormulaEvaluator;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.Action;
import com.tstar.model.tapp.Projects;
import com.tstar.model.tapp.RateProjects;
import com.tstar.model.tapp.SelectList;
import com.tstar.model.tapp.SystemLookup;
import com.tstar.service.ProjectsService;
import com.tstar.service.SelectListService;
import com.tstar.service.SystemLookupService;
import com.tstar.service.UpdateExcelDataService;
import com.tstar.utility.PropertiesUtil;

@Component
@Scope("prototype")
public class PresetCompareAction implements Action{
	
	private final Logger logger = Logger.getLogger(PresetCompareAction.class);
	
	@Autowired
	private SystemLookupService systemLookupService;
	
	@Autowired
	private SelectListService selectListService;
	
	@Autowired
	private PropertiesUtil propertiesUtil;

	@Autowired
	private UpdateExcelDataService updateExcelDataService;
	
	@Autowired
	private ProjectsService projectsService;
	
	String id = "mytstar";
	
	private String feeRangeData;/*返回頁面下拉選單所需的值的Json String*/
	private String feeSelData;/*返回頁面下拉選單所需的值的Json String*/
	private String typeSelData;/*返回頁面下拉選單所需的值的Json String*/
	
	private String fee_type;
	private String fee_range;
	private String fee_sel;
	private String voice_on_net;
	private String voice_off_net;
	private String pstn;
	private String data_usage;
	private String sms_on_net;
	private String sms_off_net;
	private String message;//預設方案狀態
	private String message1;//保護文字狀態
	private String rtnJson;
	
	private String text_type;
	private String protect_word;
	private String word_id;
	private String word_limit;
	
//	2015/10/19
	private List<Projects> projectsList;
	private DataFormatter dataFmt;
	private SimpleDateFormat dateFmt;
    private File assignFile;
	private String excelFileName;
    private String assignFileName;
	private String popMessage;
	private String timeBegin;
	private String timeEnd;
	private String calculate_rule;
	
	@Override
	public String execute() throws Exception {
		this.word_limit = wordlimit();		
		this.getSelectList();
		return SUCCESS;
	}
	
	public String changeData() {
		logger.info(" voice_on_net:"+voice_on_net+" voice_off_net:"+voice_off_net+" pstn:"+pstn+" data_usage:"+data_usage
					+" sms_on_net:"+sms_on_net+" sms_off_net:"+sms_off_net);
		this.word_limit = wordlimit();
		this.getSelectList();
		
		if(StringUtils.isNotBlank(fee_type) && StringUtils.isNotBlank(fee_range) && StringUtils.isNotBlank(fee_sel)){
			
			String queryKey = "COMPARE_DEFAULT_" + calculate_rule+ "_" +fee_type+ "_" +fee_range+ "_" + fee_sel;
			JSONObject json = new JSONObject();
			json.put("voice_on_net", voice_on_net);
			json.put("voice_off_net", voice_off_net);
			json.put("pstn", pstn);
			json.put("data_usage", data_usage);
			json.put("sms_on_net", sms_on_net);
			json.put("sms_off_net", sms_off_net);
			
			List<SystemLookup> checkdata = new ArrayList<SystemLookup>();
			checkdata = systemLookupService.getSystemLookup(id, queryKey);
			if(checkdata.size()>0){
				try{
					boolean status;
					Date date = new Date();
					SystemLookup systemLookup = new SystemLookup();
					systemLookup.setServiceId(id);
					systemLookup.setKey(queryKey);
					systemLookup.setValue(json.toString());
					systemLookup.setUpdateTime(new Timestamp(date.getTime()));
					status = systemLookupService.updateSystemLookup(systemLookup);
					if(status){
						message = "方案預設資料更新成功";
					}else{
						message = "方案預設更新失敗";
					}
				}catch(Exception e){
					logger.error(e.getMessage());
					message = "系統異常請洽系統管理人員";
				}		
			}else{
				try{
					Date date = new Date();
					int random=(int)(Math.random()*900)+100; 
					Calendar cal = Calendar.getInstance();
					String milliseconds = Long.toString(cal.getTimeInMillis()+(long)random);
					boolean status;
					SystemLookup systemLookup = new SystemLookup();
					systemLookup.setId(milliseconds);
					systemLookup.setServiceId(id);
					systemLookup.setKey(queryKey);
					systemLookup.setValue(json.toString());			
					systemLookup.setStatus("1");
					systemLookup.setCreateTime(new Timestamp(date.getTime()));
					systemLookup.setUpdateTime(new Timestamp(date.getTime()));
					status = systemLookupService.insertSystemLookup(systemLookup);
					if(status){
						message = "方案預設資料新增成功";
					}else{
						message = "方案預設新增失敗";
					}
				}catch(Exception e){
					logger.error(e.getMessage());
					message = "系統異常請洽系統管理人員";
				}		
			}
		}else{
			message ="";
		}	
		return SUCCESS;
	}
	
	public String changeProtecWord() {
		logger.info("do change ProtectWord text_type:"+text_type+" protect_word:" +protect_word);
		this.word_limit = wordlimit();
		this.getSelectList();
		String queryKey = "COMPARE_DEFAULT_"+text_type;
		List<SystemLookup> checkdata = new ArrayList<SystemLookup>();
		checkdata = systemLookupService.getSystemLookup(id, queryKey);
		if(checkdata.size()>0){
			try{
				boolean status;
				Date date = new Date();
				SystemLookup systemLookup = new SystemLookup();
				systemLookup.setId(word_id);
				systemLookup.setServiceId(id);
				systemLookup.setKey(queryKey);
				systemLookup.setValue(protect_word);
				systemLookup.setUpdateTime(new Timestamp(date.getTime()));
				status = systemLookupService.updateSystemLookup(systemLookup);
				if(status){
					message = "保護文字資料更新成功";
				}else{
					message = "保護文字更新失敗";
				}
			}catch(Exception e){
				logger.error(e.getMessage());
				message = "系統異常請洽系統管理人員";
			}		
		}else{
			try{
				Date date = new Date();
				int random=(int)(Math.random()*900)+100; 
				Calendar cal = Calendar.getInstance();
				String milliseconds = Long.toString(cal.getTimeInMillis()+(long)random);
				boolean status;
				SystemLookup systemLookup = new SystemLookup();
				systemLookup.setId(milliseconds);
				systemLookup.setServiceId(id);
				systemLookup.setKey(queryKey);
				systemLookup.setValue(protect_word);			
				systemLookup.setStatus("1");
				systemLookup.setCreateTime(new Timestamp(date.getTime()));
				systemLookup.setUpdateTime(new Timestamp(date.getTime()));
				status = systemLookupService.insertSystemLookup(systemLookup);
				if(status){
					message = "保護文字資料新增成功";
				}else{
					message = "保護文字新增失敗";
				}
			}catch(Exception e){
				logger.error(e.getMessage());
				message = "系統異常請洽系統管理人員";
			}		
		}
		return SUCCESS;
	}

	public String presetvalue(){
		logger.info("do ajax query queryKey: " + "COMPARE_DEFAULT_" +calculate_rule+ "_" +fee_type+ "_" +fee_range+ "_" +fee_sel);
		String queryKey = "COMPARE_DEFAULT_" +calculate_rule+ "_" +fee_type+ "_" +fee_range+ "_"+fee_sel;
		String jsonString = systemLookupService.getValue(id, queryKey);
		JSONObject json = new JSONObject();
		if(!jsonString.equals("")){
			json = JSONObject.fromObject(jsonString);
			rtnJson = json.toString();
		}else{
			rtnJson ="";
		}	
		return SUCCESS;
	}
	
	public String wordvalue(){
		logger.info("do ajax query queryKey:"+"text_type"+text_type);
		String queryKey = "COMPARE_DEFAULT_"+text_type;
		List<SystemLookup> word_data = systemLookupService.getSystemLookup(id, queryKey);
		JSONObject json = new JSONObject();
		if(word_data.size()>0){
			json.put("id", word_data.get(0).getId());
			json.put("protect_word", word_data.get(0).getValue());
			rtnJson = json.toString();
		}else{
			rtnJson ="";
		}	
		return SUCCESS;
	}
	
	public String wordlimit(){
		String word = systemLookupService.getValue(id, "COMPARE_DEFAULT_TEXT_MAXIMUM");
		if(word.equals("")){
			word = "1000";
		}
		return word;
	}
	
	public String updateExcelData(){
		Map<String, String> emptyPhoneMap = new HashMap<String, String>();
		Map<String, String> errorPhoneMap = new HashMap<String, String>();	
		List<Integer> failedRows = new ArrayList<Integer>();
		try {
			dateFmt = new SimpleDateFormat("hh:mm:ss");
			projectsList = new ArrayList<Projects>();
			dataFmt = new DataFormatter();//去除excel數字自行在字尾加上[.0]
			
			if(assignFile != null){
				logger.debug("Delete and Backup:" + updateExcelDataService.deleteAndBackup());
				readExcel(false, emptyPhoneMap, errorPhoneMap, failedRows);
			}else{
				popMessage = "No file selected";
				logger.debug("Error from [assignFile]");
			}
		}catch (Exception e) {
			e.printStackTrace();
		} 
		return SUCCESS;
	}

	public String rollbackExcelData(){
		Map<String, String> emptyPhoneMap = new HashMap<String, String>();
		Map<String, String> errorPhoneMap = new HashMap<String, String>();	
		List<Integer> failedRows = new ArrayList<Integer>();
        String root = propertiesUtil.getProperty("rec.file.path") + File.separator + "excel_phoneData_upload" + File.separator;
        assignFile = new File(root + excelFileName);
		try {
			dateFmt = new SimpleDateFormat("hh:mm:ss");
			projectsList = new ArrayList<Projects>();
			dataFmt = new DataFormatter();//去除excel數字自行在字尾加上[.0]
			
			if(assignFile != null){
				logger.debug("Roll Back:" + updateExcelDataService.rollBackMechanism());
				readExcel(true, emptyPhoneMap, errorPhoneMap, failedRows);
			}else{
				popMessage = "No file selected";
				logger.debug("Error from [assignFile]");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} 
		return SUCCESS;
	}
	
	public String getExcelFileName(){
        String root = propertiesUtil.getProperty("rec.file.path") + File.separator + "excel_phoneData_upload" + File.separator;
		try {
			if("Search".equals(rtnJson)){
				File file = new File(root);
	        	File[] fs = file.listFiles();
				if(null == fs || 0 == fs.length){
					JSONObject response = new JSONObject();
					response.put("error", "none");
					response.put("none", "資料庫內無任何備份檔!");
					rtnJson = response.toString();
					logger.debug("Error because file not found");
				}else{
					JSONArray fileNameJson = new JSONArray();
					List<Date> fileDates = new ArrayList<Date>();
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
					
					for(File f : fs){fileDates.add(new Date(f.lastModified()));}
//					Sort the files by date
					Collections.sort(fileDates, new Comparator<Date>() {
						@Override
						public int compare(Date o1, Date o2) {
							return o2.compareTo(o1);//大到小 降幕
						}
					});
//					Put the file name into json array by sorted fileDates list object
					for(Date date : fileDates){
						for(File f : fs){
							if(sdf.format(date).equals(sdf.format(f.lastModified()))){
								fileNameJson.add(f.getName());
							}
						}
					}
					rtnJson = fileNameJson.toString();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return SUCCESS;
	}
	
//	inner methods
	
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
        
        JSONObject json = JSONObject.fromObject(feeRangeMap);//將map對象轉換成json類型數據
        System.out.println("json: " + json);
        feeRangeData = json.toString();//給result賦值，傳遞給頁面
        
        json = JSONObject.fromObject(feeSelMap);//將map對象轉換成json類型數據
        feeSelData = json.toString();//給result賦值，傳遞給頁面
        
        JSONArray jsonArray = JSONArray.fromObject(feeTypeList);//將map對象轉換成json類型數據
        typeSelData = jsonArray.toString();//給result賦值，傳遞給頁面
	}
	
	private void readExcel(boolean isRollBack, Map<String, String> emptyPhoneMap, Map<String, String> errorPhoneMap, List<Integer> failedRows){
		Workbook workBook = null;
		timeBegin = dateFmt.format(new Date());
		String path = assignFile.getAbsolutePath();
		int insertCount = 0;
		try {
			workBook = new XSSFWorkbook(new FileInputStream(path));
		}catch (POIXMLException poixmle) {
			try {
				workBook = WorkbookFactory.create(new FileInputStream(path));
			}catch (Exception e) {
				popMessage = "Invaild format file";
			}
		}catch(FileNotFoundException fnfe){
			popMessage = "No file selected";
			fnfe.getCause();
		}catch (Exception e) {
			e.printStackTrace();
		}
		readRowCell(workBook, isRollBack, emptyPhoneMap, errorPhoneMap, failedRows, 1, insertCount);
	}
	
	private void readRowCell(Workbook workBook, boolean isRollBack, Map<String, String> emptyPhoneMap, Map<String, String> errorPhoneMap, List<Integer> failedRows, int startRow, int insertCount){
		int nextRow = startRow;
		
		try {
			if(null == workBook){
				logger.debug("Error from [workBook]");
			}else{
				FormulaEvaluator fe = workBook.getCreationHelper().createFormulaEvaluator();
				Sheet sheet = workBook.getSheet(workBook.getSheetName(0));
				int rowsNumber = sheet.getPhysicalNumberOfRows();
				for(int rowNumber = startRow; rowNumber < rowsNumber; rowNumber++){
					nextRow++;
					RateProjects rateProjects = new RateProjects();
					if(null != sheet.getRow(rowNumber)){
						Row row = sheet.getRow(rowNumber);
//						int cellsNumber = row.getPhysicalNumberOfCells(); //動態抓掃描到的cell(cell number不固定，當有null cell時，不好操作因為有的row掃的到；有的掃不到)
						int cellsNumber = 20;//固定只讀前20個cell
						boolean price = true, prepaymentAmount = true, singlePhone = true;
						for(int cellNumber = 0; cellNumber < cellsNumber; cellNumber++){
							if(null != rateProjects){
								switch (cellNumber) {//cell number
								case 0://公司別
									break;
								case 1://專案代碼(RATE_ID)
									if(null == row.getCell(cellNumber) || StringUtils.isBlank(row.getCell(cellNumber).toString())){
										rateProjects = null;
									}else{
										rateProjects.setRateId(checkCell(row.getCell(cellNumber), fe, false));
									}
									break;
								case 2://3G4G
									break;
								case 3://是否為手機專案(LINK_TO_BILLING)
									rateProjects.setLinkToBilling("Y");
									break;
								case 4://專案名稱
									break;
								case 5://手機型號(PROJECT_ID)
									if(null == row.getCell(cellNumber) || StringUtils.isBlank(row.getCell(cellNumber).toString())){
										rateProjects = null;
									}else{
										String phoneName = row.getCell(cellNumber).toString();
										List<Projects> list = projectsService.queryProjectsByName(phoneName);
										int isStatus1 = 0;
										for(Projects p : list){
											Projects project = new Projects();
											String stus = p.getStatus();
											if(stus.equals("1")){
												isStatus1++;
											}
											project.setId(p.getId());
											project.setName(p.getName());
											project.setStatus(p.getStatus());
											project.setDeviceId(p.getDeviceId());
											projectsList.add(project);
										}
										int size = projectsList.size();
										switch (size) {//檢查手機的STATUS=1屬性
										case 0://沒有找到對應的手機ID
											emptyPhoneMap.put(phoneName, phoneName);
											rateProjects = null;
											break;
										case 1://如果只有1支手機就直接存起來
											Projects p = projectsList.get(0);
											rateProjects.setProjectId(p.getId());
											rateProjects.setStatus("1");
											break;
										default://size > 1
											if(isStatus1 > 1){//STATUS=1的手機有2支以上
												errorPhoneMap.put(phoneName, phoneName);
												rateProjects = null;
											}else{
												for(int i = 0; i < size; i++){//找STATUS=1的手機
													Projects p1 = projectsList.get(i);
													if(p1.getStatus().equals("1")){
														rateProjects.setProjectId(p1.getId());
														rateProjects.setStatus("1");
														break;
													}else if(i == size - 1){//若找到最後一支都沒有就直接存起來
														rateProjects.setProjectId(p1.getId());
														rateProjects.setStatus("1");
													}
												}
											}
											break;
										}
										projectsList.clear();
									}
									break;
								case 6://約期24/30
									break;
								case 7://專案價(PRICE)
									rateProjects.setPrice(Integer.valueOf(checkCell(row.getCell(cellNumber), fe, true)));
									price = isPriceCellNull(row.getCell(cellNumber));	
									break;
								case 8://攜碼價(PREPAYMENT_AMOUNT)
									rateProjects.setPrepaymentAmount(Integer.valueOf(checkCell(row.getCell(cellNumber), fe, true)));
									prepaymentAmount = isPriceCellNull(row.getCell(cellNumber));	
									break;
								case 9://單機價(SINGLE_PHONE)
									rateProjects.setSinglePhone(checkCell(row.getCell(cellNumber), fe, true));	
									singlePhone = isPriceCellNull(row.getCell(cellNumber));	
									break;
								}
							}else{
								break;
							}
						}
						//存入table:RATE_PROJECTS
						if(null != rateProjects && (price || prepaymentAmount || singlePhone)){
							rateProjects.setId(String.valueOf(Calendar.getInstance().getTimeInMillis() + insertCount++));
							logger.debug("Row:" + (rowNumber + 1) + "-" + rateProjects.toString());
							if(updateExcelDataService.insertExcelDate(rateProjects)){
								logger.debug("Insert Success.");
							}else{
								logger.debug(isInsertError(insertCount, true));
								break;
							}
						}else{
							failedRows.add(rowNumber + 1);
							logger.debug("Failed row:" + (rowNumber + 1));
						}
					}
				}
				logger.debug(isInsertError(insertCount, false));
				showResult(emptyPhoneMap, errorPhoneMap, failedRows, insertCount);
				logger.debug(isRollBack(isRollBack, insertCount));
			}
		}catch(NumberFormatException nfe){
			failedRows.add(nextRow);
			logger.debug("NumberFormatException row:" + nextRow);
			readRowCell(workBook, isRollBack, emptyPhoneMap, errorPhoneMap, failedRows, nextRow, insertCount);
		}catch (NullPointerException npe) {
			failedRows.add(nextRow);
			logger.debug("NullPointerException row:" + nextRow);
			readRowCell(workBook, isRollBack, emptyPhoneMap, errorPhoneMap, failedRows, nextRow, insertCount);
		}catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private String isRollBack(boolean isRollBack, int insertCount){
		if(!isRollBack){
			storeExcel(insertCount);	
			return "Roll backing. Store Excel now!";
		}else{
			assignFile = null;
			popMessage = "Success";
			return "Upload excel success.";
		}
	}
	
	/**
	 * 檢查在insert時錯誤還是最後沒有任何資料輸入，做出對應的回應訊息但背後的錯誤處理機制是一樣的。
	 * @param insertCount 輸入資料筆數
	 * @param isInsertFail 是否為insert時產生例外錯誤
	 * @return 提示訊息
	 */
	private String isInsertError(int insertCount, boolean isInsertFail){
		if(insertCount == 0){
			return "No insert any data and roll back now:" + updateExcelDataService.insertErrorMechanism();
		}else if(isInsertFail){
			return "Insert failed. Roll back now:" + updateExcelDataService.insertErrorMechanism();
		}else{
			return "";
		}
	}
	
	/**
	 * 檢查手機價格是不是空值，為了處理三種手機價格都為空值則不insert條件
	 * @param cell
	 * @return
	 */
	private boolean isPriceCellNull(Cell cell){
		if(null == cell || StringUtils.isBlank(cell.toString())){
			return false;
		}else{
			return true;
		}
	}
	
	private void storeExcel(int insertCount){
		FileOutputStream fos = null;
		FileInputStream fis = null;
		SimpleDateFormat sdf = new SimpleDateFormat("HHmmss");
		
		try {
			String[] splitBySeparator = assignFileName.split("\\\\");
			String currentTime = sdf.format(Calendar.getInstance().getTimeInMillis());
			String fileName = splitBySeparator[splitBySeparator.length-1].split("\\.")[0] + "-" + currentTime + ".xlsx";
	        String root = propertiesUtil.getProperty("rec.file.path") + File.separator + "excel_phoneData_upload" + File.separator;
			//Create directory if not exist
	        File makeFile = new File(root);
			if (!makeFile.exists()) {
				logger.info("Mkdirs:" + makeFile.mkdirs());
			}
			fos = new FileOutputStream(root + fileName);
			fis = new FileInputStream(assignFile);
	        byte[] buffer = new byte[1024];
	        int len = 0;
	        while ((len = fis.read(buffer)) != -1) {
	            fos.write(buffer, 0, len);
	        }
			popMessage = "Success";
		}catch(FileNotFoundException fnfe){
			logger.debug(isInsertError(insertCount, true));
			popMessage = "Storing error";
			fnfe.getCause();
		}catch (Exception e) {
			e.printStackTrace();
			popMessage = "Storing error";
		}finally{
			closeStream(fis, fos);
			assignFile = null;
		}
	}
	
	private void closeStream(FileInputStream fis, FileOutputStream fos){
        if (fis != null) {
            try {
                fis.close();
                fis = null;
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        if (fos != null) {
            try {
                fos.close();
                fis = null;
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
	}
	
	/**
	 * 檢查cell內的值，如果是X、0.0、空、-都視為0
	 * @param xc
	 * @param fe
	 * @param isPrice
	 * @return
	 */
	private String checkCell(Cell xc, FormulaEvaluator fe, boolean isPrice){
		if(isPrice){
			if(xc != null){
//				If cell contains formula, it evaluates the formula, and puts the formula result back into the cell, in place of the old formula.
				Cell c = fe.evaluateInCell(xc);
				if(StringUtils.equalsIgnoreCase("X", c.toString()) || 
					StringUtils.equals("0.0", c.toString()) ||
					StringUtils.isEmpty(c.toString()) || 
					StringUtils.equals("-", c.toString())){
					return "0";
				}else{
					String str = dataFmt.formatCellValue(c).toString();
					if(str.indexOf(",") != -1){
						str = str.replace(",", "");
					}
					return str;
				}
			}
			return "0";
		}else{
			if(xc != null){
				if(StringUtils.equalsIgnoreCase("X", xc.toString()) || 
					StringUtils.equals("0.0", xc.toString()) ||
					StringUtils.isEmpty(xc.toString()) || 
					StringUtils.equals("-", xc.toString())){
					return "null";
				}else{
					return dataFmt.formatCellValue(xc);
				}
			}
			return "null";
		}
	}

	private void showResult(Map<String, String> emptyPhoneMap, Map<String, String> errorPhoneMap, List<Integer> failedRows, int insertCount) {
//		For view
		JSONObject result = new JSONObject();
		
		List<String> emptyPhones = new ArrayList<String>();
		for(String key : emptyPhoneMap.keySet()){
			emptyPhones.add(emptyPhoneMap.get(key));
		}
		result.put("emptyPhones", emptyPhones);
		
		result.put("successCount", insertCount);
		result.put("failedRows", failedRows);
		
		List<String> errorPhones = new ArrayList<String>();
		for(String key : errorPhoneMap.keySet()){
			errorPhones.add(errorPhoneMap.get(key));
		}
		result.put("errorPhones", errorPhones);
		rtnJson = result.toString();
		
//		For console
		System.out.println("Empty phone:---------------------");
		for(String key : emptyPhoneMap.keySet()){
			System.out.println(emptyPhoneMap.get(key));
		}
		System.out.println("---------------------------------");
		System.out.println("Error phone:---------------------");
		for(String key : errorPhoneMap.keySet()){
			System.out.println(errorPhoneMap.get(key));
		}
		System.out.println("---------------------------------");
		System.out.println("Failed Rows:---------------------");
		for(Integer row : failedRows){
			System.out.print(row + ", ");
		}
		System.out.println();
		System.out.println("---------------------------------");
		System.out.println("Total Insert:--------------------");
		System.out.println(insertCount);
		System.out.println("---------------------------------");
		String str = dateFmt.format(new Date());
		timeEnd = str;
		System.out.println("Time Record:--------------------");
		System.out.println("Begin Time:" + timeBegin);
		System.out.println("End Time:" + timeEnd);
		System.out.println("---------------------------------");
	}
	
//	getter setter
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

	public String getTypeSelData() {
		return typeSelData;
	}

	public void setTypeSelData(String typeSelData) {
		this.typeSelData = typeSelData;
	}
	
	
	public String getRtnJson() {
		return rtnJson;
	}

	public String getFee_type() {
		return fee_type;
	}

	public void setFee_type(String fee_type) {
		this.fee_type = fee_type;
	}

	public String getFee_range() {
		return fee_range;
	}

	public void setFee_range(String fee_range) {
		this.fee_range = fee_range;
	}

	public String getFee_sel() {
		return fee_sel;
	}

	public void setFee_sel(String fee_sel) {
		this.fee_sel = fee_sel;
	}

	public String getVoice_on_net() {
		return voice_on_net;
	}

	public void setVoice_on_net(String voice_on_net) {
		this.voice_on_net = voice_on_net;
	}

	public String getVoice_off_net() {
		return voice_off_net;
	}

	public void setVoice_off_net(String voice_off_net) {
		this.voice_off_net = voice_off_net;
	}

	public String getPstn() {
		return pstn;
	}

	public void setPstn(String pstn) {
		this.pstn = pstn;
	}

	public String getData_usage() {
		return data_usage;
	}

	public void setData_usage(String data_usage) {
		this.data_usage = data_usage;
	}

	public String getSms_on_net() {
		return sms_on_net;
	}

	public void setSms_on_net(String sms_on_net) {
		this.sms_on_net = sms_on_net;
	}

	public String getSms_off_net() {
		return sms_off_net;
	}

	public void setSms_off_net(String sms_off_net) {
		this.sms_off_net = sms_off_net;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public String getMessage1() {
		return message1;
	}

	public void setMessage1(String message1) {
		this.message1 = message1;
	}

	public String getText_type() {
		return text_type;
	}

	public void setText_type(String text_type) {
		this.text_type = text_type;
	}

	public String getProtect_word() {
		return protect_word;
	}

	public void setProtect_word(String protect_word) {
		this.protect_word = protect_word;
	}

	public String getWord_id() {
		return word_id;
	}

	public void setWord_id(String word_id) {
		this.word_id = word_id;
	}

	public String getWord_limit() {
		return word_limit;
	}

	public void setWord_limit(String word_limit) {
		this.word_limit = word_limit;
	}

	public File getAssignFile() {
		return assignFile;
	}

	public void setAssignFile(File assignFile) {
		this.assignFile = assignFile;
	}

	public void setRtnJson(String rtnJson) {
		this.rtnJson = rtnJson;
	}

	public void setExcelFileName(String excelFileName) {
		this.excelFileName = excelFileName;
	}

	public String getPopMessage() {
		return popMessage;
	}

	public void setPopMessage(String popMessage) {
		this.popMessage = popMessage;
	}

	public String getAssignFileName() {
		return assignFileName;
	}

	public void setAssignFileName(String assignFileName) {
		this.assignFileName = assignFileName;
	}

	public String getCalculate_rule() {
		return calculate_rule;
	}

	public void setCalculate_rule(String calculate_rule) {
		this.calculate_rule = calculate_rule;
	}
}