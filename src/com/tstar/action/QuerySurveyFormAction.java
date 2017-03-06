package com.tstar.action;

import java.sql.Timestamp;

import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.Action;
import com.tstar.dto.FormDataQueryDto;
import com.tstar.service.FormDataService;
import com.tstar.service.SystemLookupService;

@Component
@Scope("prototype")
public class QuerySurveyFormAction implements Action{
	private String formKey;
	private String createtimestart;
	private String createtimeend;
	private String message;
	private List<FormDataQueryDto> datalist;
	
	@Autowired
	private FormDataService formDataService ;
	@Autowired
	private SystemLookupService systemLookupService ;
	
	@Override
	public String execute() throws Exception {
		return SUCCESS;
	}
	
	public String queryList(){
		Timestamp timestampstart =null;
		Timestamp timestampend =null;
		if(StringUtils.isNotBlank(createtimestart) && StringUtils.isNotBlank(createtimeend)){
			createtimestart = createtimestart.replace("/", "-");//日期格式轉換把/轉成-
			timestampstart = Timestamp.valueOf(createtimestart);//轉換timestamp格式
			createtimeend = createtimeend.replace("/", "-");
			timestampend = Timestamp.valueOf(createtimeend);
		}
		datalist = formDataService.queryFormdata(formKey,timestampstart,timestampend);
		if(datalist.size()==0){
			message = "查無資料";
		}
		return SUCCESS;
	}
	
	public String getFormKey() {
		return formKey;
	}
	public void setFormKey(String formKey) {
		this.formKey = formKey;
	}
	
	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
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

	public List<FormDataQueryDto> getDatalist() {
		return datalist;
	}

	public void setDatalist(List<FormDataQueryDto> datalist) {
		this.datalist = datalist;
	}
}
