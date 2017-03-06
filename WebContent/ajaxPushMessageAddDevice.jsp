﻿<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>
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

/*********************新增GCM/APNS的device至DB中*********************/

/*********************開始做事吧*********************/

String sServiceId		= nullToString(request.getParameter("ServiceId"), "");
String sDeviceId		= nullToString(request.getParameter("DeviceId"), "");
String sDeviceType		= nullToString(request.getParameter("DeviceType"), "");
String sMSISDN			= nullToString(request.getParameter("MSISDN"), "");
String sToken			= nullToString(request.getParameter("Token"), "");
String sContractId		= nullToString(request.getParameter("ContractId"), "");
String sAllowSend		= nullToString(request.getParameter("AllowSend"), "");
String sResponseType	= nullToString(request.getParameter("ResponseType"), "");	//希望server端回覆的資料類型，可為 json 或 xml
String sResponse		= "";	//回覆給呼叫端的字串

if (beEmpty(sServiceId) || beEmpty(sDeviceId) || beEmpty(sDeviceType) || beEmpty(sToken) || (beEmpty(sMSISDN) && beEmpty(sContractId))){	//MSISDN及ContractId不可皆為空值
	sResponse = ComposeXMLResponse(gcResultCodeParametersNotEnough, gcResultTextParametersNotEnough, "");
	if (sResponseType.equalsIgnoreCase("json")){
		net.sf.json.JSON json = new XMLSerializer().read( sResponse );
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

//先看DB中有沒有既有資料
iColCount = 1;
sSQL = "select DeviceId from MV_PushMessageUsers where";
sSQL += " ServiceId='" + sServiceId + "'";
sSQL += " and DeviceId='" + sDeviceId + "'";
sSQL += " and DeviceType='" + sDeviceType + "'";
//sSQL += " and MSISDN='" + sMSISDN + "'";
//先不管MSISDN及ContractId
//if (notEmpty(MSISDN)) sSQL += " and MSISDN='" + sMSISDN + "'";
//if (notEmpty(ContractId)) sSQL += " and ContractId='" + sContractId + "'";

ht = getDBData(sSQL, iColCount);
sResultCode = ht.get("ResultCode").toString();
sResultText = ht.get("ResultText").toString();

if (sResultCode.equals(gcResultCodeSuccess)){	//有資料，更新既有資料
	sSQL = "update MV_PushMessageUsers set";
	sSQL += " ALLOWSEND='" + sAllowSend + "'";
	sSQL += " , TOKEN='" + sToken + "'";
	sSQL += " , MSISDN='" + sMSISDN + "'";
	sSQL += " , ContractId='" + sContractId + "'";
	sSQL += " where ServiceId='" + sServiceId + "'";
	sSQL += " and DeviceId='" + sDeviceId + "'";
	sSQL += " and DeviceType='" + sDeviceType + "'";
	
	
	
	System.out.println("=====================ajaxPushMessageAddDevice update sSQL: " + sSQL);
	ht = execSQLOnDB(sSQL);
	sResultCode = ht.get("ResultCode").toString();
	sResultText = ht.get("ResultText").toString();
	
	if (sResultCode.equals(gcResultCodeSuccess)){	//成功
		sResponse = ComposeXMLResponse(gcResultCodeSuccess, gcResultTextSuccess, "");
	}else{
		writeToFile("使用功能失敗:更新GCM/APNS的device至DB中(ajaxPushMessageAddDevice.jsp):" + sResultCode + ":" + sResultText);
		sResponse = ComposeXMLResponse(sResultCode, sResultText, "");
	}	//if (sResultCode.equals(gcResultCodeSuccess)){	//成功
	
	if (sResponseType.equalsIgnoreCase("json")){
		net.sf.json.JSON json = new XMLSerializer().read( sResponse );
		sResponse = json.toString();
	}
	out.println(sResponse);
	return;
}

//新增資料至DB
sSQL = "insert into MV_PushMessageUsers (ServiceId, DeviceId, DeviceType, MSISDN, ContractId, RegisterDate, AllowSend, Token)";
sSQL += " values (";
sSQL += " '"	+	sServiceId		+ "'";
sSQL += ", '"	+	sDeviceId		+ "'";
sSQL += ", '"	+	sDeviceType		+ "'";
sSQL += ", '"	+	sMSISDN			+ "'";
sSQL += ", '"	+	sContractId		+ "'";
sSQL += ", "	+	"sysdate";
sSQL += ", '"	+	"Y"				+ "'";	//預設允許發送訊息給這個device
sSQL += ", '"	+	sToken			+ "'";
sSQL += " )";
System.out.println("=====================ajaxPushMessageAddDevice insert sSQL: " + sSQL);
ht = execSQLOnDB(sSQL);
sResultCode = ht.get("ResultCode").toString();
sResultText = ht.get("ResultText").toString();

if (sResultCode.equals(gcResultCodeSuccess)){	//成功
	sResponse = ComposeXMLResponse(gcResultCodeSuccess, gcResultTextSuccess, "");
}else{
	writeToFile("使用功能失敗:新增GCM/APNS的device至DB中(ajaxPushMessageAddDevice.jsp):" + sResultCode + ":" + sResultText);
	sResponse = ComposeXMLResponse(sResultCode, sResultText, "");
}	//if (sResultCode.equals(gcResultCodeSuccess)){	//成功

if (sResponseType.equalsIgnoreCase("json")){
	net.sf.json.JSON json = new XMLSerializer().read( sResponse );
	sResponse = json.toString();
}
out.println(sResponse);

%>