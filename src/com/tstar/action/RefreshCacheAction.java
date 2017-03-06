package com.tstar.action;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.ActionSupport;
import com.tstar.utility.TspUtil;

@Component
@Scope("prototype")
public class RefreshCacheAction extends ActionSupport{
	private static final long serialVersionUID = 1L;
	private final Logger logger = Logger.getLogger(RefreshCacheAction.class);

	@Autowired
	TspUtil tspUtil;

	private String request;
	private String status;
	private String message;
	
	@Override
	public String execute() throws Exception {
		return null;
	}
    
    public String refreshCache()  throws Exception{
    	tspUtil.refresher(request);
		return null;
    }

//    getter setter
	public String getRequest() {
		return request;
	}

	public void setRequest(String request) {
		this.request = request;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}
}
