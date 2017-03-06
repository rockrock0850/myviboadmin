package com.tstar.dto;

import java.sql.Timestamp;
import java.util.List;

public class FormDataQueryDto {
	String formKey;
	String formId;
	Timestamp createTime;
	List<String> columnName;
	List<String> columnValue;
	public String getFormKey() {
		return formKey;
	}
	public void setFormKey(String formKey) {
		this.formKey = formKey;
	}
	public String getFormId() {
		return formId;
	}
	public void setFormId(String formId) {
		this.formId = formId;
	}
	public Timestamp getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Timestamp createTime) {
		this.createTime = createTime;
	}
	public List<String> getColumnName() {
		return columnName;
	}
	public void setColumnName(List<String> columnName) {
		this.columnName = columnName;
	}
	public List<String> getColumnValue() {
		return columnValue;
	}
	public void setColumnValue(List<String> columnValue) {
		this.columnValue = columnValue;
	}
	
}
