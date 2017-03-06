package com.tstar.service;

import java.sql.Timestamp;
import java.util.List;

import com.tstar.dto.FormDataQueryDto;
import com.tstar.model.tapp.FormData;

public interface FormDataService {
	public List<FormData> queryAll();
	public boolean insertFormData(FormData formData);
	public boolean deleteFormData();
	public List<FormDataQueryDto> queryFormdata(String formKey,Timestamp timestampstart, Timestamp timestampend);
}
