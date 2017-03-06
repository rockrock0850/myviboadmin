<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>

<%@page import="java.sql.*" %>
<%@page import="java.util.Date" %>
<%@ page import="net.sf.json.*" %>
<%@ page import="net.sf.json.xml.XMLSerializer" %>


<%@include file="00_constants.jsp"%>
<%@include file="00_utility.jsp"%>

<%
request.setCharacterEncoding("utf-8");
response.setContentType("text/html;charset=utf-8");
response.setHeader("Pragma","no-cache"); 
response.setHeader("Cache-Control","no-cache"); 
response.setDateHeader("Expires", 0); 

out.clear();	//注意，一定要有out.clear();，要不然client端無法解析XML，會認為XML格式有問題

/*********************從DB刪除GCM/APNS的device*********************/

/*********************開始做事吧*********************/

String sServiceId		= nullToString(request.getParameter("ServiceId"), "");
String sDeviceId		= nullToString(request.getParameter("DeviceId"), "");
String sDeviceType		= nullToString(request.getParameter("DeviceType"), "");
String sResponseType	= nullToString(request.getParameter("ResponseType"), "");	//希望server端回覆的資料類型，可為 json 或 xml
String sResponse		= "";	//回覆給呼叫端的字串

if (beEmpty(sServiceId) || beEmpty(sDeviceId) || beEmpty(sDeviceType)){
	sResponse = ComposeXMLResponse(gcResultCodeParametersNotEnough, gcResultTextParametersNotEnough, "");
	if (sResponseType.equalsIgnoreCase("json")){
		JSON json = new XMLSerializer().read( sResponse );
		sResponse = json.toString();
	}
	out.println(sResponse);
	return;
}

Hashtable	ht					= new Hashtable();
String		sResultCode			= gcResultCodeSuccess;
String		sResultText			= gcResultTextSuccess;
String		s[][]				= null;
int			iColCount			= 0;
String		sSQL				= "";

//從DB刪除資料
sSQL = "delete from MV_PushMessageUsers where";
sSQL += " ServiceId='" + sServiceId + "'";
sSQL += " and DeviceId='" + sDeviceId + "'";
sSQL += " and DeviceType='" + sDeviceType + "'";

ht = execSQLOnDB(sSQL);
sResultCode = ht.get("ResultCode").toString();
sResultText = ht.get("ResultText").toString();

if (sResultCode.equals(gcResultCodeSuccess)){	//成功
	sResponse = ComposeXMLResponse(gcResultCodeSuccess, gcResultTextSuccess, "");
}else{
	writeToFile("使用功能失敗:從DB刪除GCM/APNS的device(ajaxPushMessageDeleteDevice.jsp):" + sResultCode + ":" + sResultText);
	sResponse = ComposeXMLResponse(sResultCode, sResultText, "");
}	//if (sResultCode.equals(gcResultCodeSuccess)){	//成功

if (sResponseType.equalsIgnoreCase("json")){
	JSON json = new XMLSerializer().read( sResponse );
	sResponse = json.toString();
}
out.println(sResponse);

%>