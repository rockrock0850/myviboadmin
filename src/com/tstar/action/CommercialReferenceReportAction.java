package com.tstar.action;

import java.io.OutputStream;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.Action;
import com.tstar.model.tapp.CommercialReference;
import com.tstar.service.CommercialReferenceService;

@Component
public class CommercialReferenceReportAction implements Action{
	private final Logger logger = Logger.getLogger(CommercialReferenceReportAction.class);
	private final String enter = "\n";

	@Autowired
	private CommercialReferenceService commercialReferenceService;
	
	private String createtimestart;
	private String createtimeend;
	
	@Override
	public String execute() throws Exception {
		logger.debug("execute() executed.");
		return SUCCESS;
	}

	public String downloadExcel() throws Exception{
		logger.debug("comRefReportDownloadExcel() executed.");
		createtimestart = createtimestart.replace('/', '-');
		createtimeend = createtimeend.replace('/', '-');
		List<CommercialReference> commercialList = commercialReferenceService.queryCommercialReferenceCondition(null, null, null, "2", null, Timestamp.valueOf(createtimestart), Timestamp.valueOf(createtimeend));
		HSSFWorkbook workbook = new HSSFWorkbook();
		Sheet sheet = workbook.createSheet("Sample sheet");
		//Create a new row in current sheet
		Row titleRow = sheet.createRow(0);
		titleRow.createCell(0).setCellValue("電話號碼");
		titleRow.createCell(1).setCellValue("合約編號");
		titleRow.createCell(2).setCellValue("資料來源");
		titleRow.createCell(3).setCellValue("建立時間");
		for(int i = 1; i < commercialList.size()+1; i++){
			Row row = sheet.createRow(i);
			CommercialReference cr = commercialList.get(i-1);
			//Create a new cell in current row and set value to new value
			row.createCell(0).setCellValue(cr.getMsisdn());
			row.createCell(1).setCellValue(cr.getContractId());
			row.createCell(2).setCellValue(cr.getSourceId());
			row.createCell(3).setCellValue(cr.getCreateTime().toString());
			logger.debug("getCreateTime:" + cr.getCreateTime());
		}

		String[] time1 = commercialList.get(0).getCreateTime().toString().split(" ");
		String[] time2 = commercialList.get(commercialList.size()-1).getCreateTime().toString().split(" ");
		List<String> sort = new ArrayList<String>();
		sort.add(time1[0]);
		sort.add(time2[0]);
		Collections.sort(sort);
		String name = sort.get(0) + "-" + sort.get(1) + ".xls";
        HttpServletResponse response = ServletActionContext.getResponse();
        response.setContentType("appllication/vnd.ms-excel");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + name + "\"");
        OutputStream out = response.getOutputStream();
	    workbook.write(out);
	    out.flush();
	    out.close();
		logger.info(enter + "File name:" + name + enter + "Download Success.");
		return null;
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
}