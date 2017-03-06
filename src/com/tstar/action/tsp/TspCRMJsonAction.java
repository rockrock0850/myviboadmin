package com.tstar.action.tsp;

import java.util.Map;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.apache.struts2.interceptor.ServletRequestAware;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.Action;
import com.tstar.utility.TspUtil;
import com.tstar.utility.Utils;

@Component
@Scope("prototype")
public class TspCRMJsonAction implements Action, ServletRequestAware{
	private final Logger logger = Logger.getLogger(TspCRMJsonAction.class);
	
	@Autowired
	TspUtil tspUtil;
	
	private String request;
	private String status;
	private String message;
	HttpServletRequest servletRequest;
	
	@Override
	public String execute() throws Exception {
		return SUCCESS;
	}
	
    public String queryTicket(){
		return actionRun(Thread.currentThread().getStackTrace()[1].getMethodName());
    }
    
    private String actionRun(String methodName){
    	try {
        	JSONObject json = tspUtil.actionRun(request, methodName);
    		status = json.getString("resultCode");
    		message = json.getString("resultText");
		} catch (Exception e) {
			e.printStackTrace();
    		status = "99999";
    		message = "系統處理錯誤";
//			Log message to db
    		Map<String, Object> memo = new TreeMap<String, Object>();
			memo.put("cause", new Utils().handleExceptionMessage(e));
			memo.put("methodName", methodName);
			new Utils().logRecorder("ERROR", "", "", memo);
		}
    	return null;
    }

//  getter setter
	public String getStatus() {
		return status;
	}

	public String getMessage() {
		return message;
	}

	public void setServletRequest(HttpServletRequest servletRequest) {
		this.servletRequest = servletRequest;
	}

	public void setRequest(String request) {
		this.request = request;
	}
}
