package com.tstar.action;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.Action;
import com.tstar.utility.PostData;
import com.tstar.utility.PropertiesUtil;

import net.sf.json.JSONObject;

@Component
@Scope("prototype")
public class SendSmsAction implements Action {

	private final Logger logger = Logger.getLogger(this.getClass());

	private String msisdn;
	private JSONObject jsonStr;

	@Autowired
	private PostData postData;

	@Autowired
	private PropertiesUtil propertiesUtil;

	public HttpServletRequest request;

	public String execute() {
		logger.info("msisdn: " + msisdn);
		jsonStr = new JSONObject();

		if (StringUtils.isNotBlank(msisdn)) {
			JSONObject jsObj = new JSONObject();
			jsObj.put("toAddress", msisdn);
			jsObj.put("categoryId", "A07");
			jsObj.put("tariffId", "00");

			postData.jsonPost(
					propertiesUtil.getProperty("tappbs.url") + propertiesUtil.getProperty("tappbs.sendSms.url"),
					jsObj.toString());

			jsonStr.put("result", true);
		}
		else {
			jsonStr.put("result", false);
			jsonStr.put("msg", "手機號碼必填!");
		}
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/html");
		response.setCharacterEncoding("utf-8");
		PrintWriter out = null;
		try {
			out = response.getWriter();
			out.print(jsonStr.toString());
			out.flush();
			out.close();
		}
		catch (Exception ex) {
			logger.error(ex, ex);
		}

		return null;
	}

	public JSONObject getJsonStr() {
		return jsonStr;
	}

	public void setMsisdn(String msisdn) {
		this.msisdn = msisdn;
	}
}
