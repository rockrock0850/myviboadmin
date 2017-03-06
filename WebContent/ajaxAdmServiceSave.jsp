<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>

<%@page import="java.sql.*" %>
<%@page import="java.util.Date" %>

<%@include file="00_constants.jsp"%>
<%@include file="00_utility.jsp"%>

<%
request.setCharacterEncoding("utf-8");
response.setContentType("text/html;charset=utf-8");
response.setHeader("Pragma","no-cache"); 
response.setHeader("Cache-Control","no-cache"); 
response.setDateHeader("Expires", 0); 

out.clear();	//注意，一定要有out.clear();，要不然client端無法解析XML，會認為XML格式有問題

/*********************檢查登入資料及權限*********************/
String	sLoginId=(String)session.getAttribute("LoginId");
String	sLoginRole=(String)session.getAttribute("LoginRole");
if (beEmpty(sLoginId)||beEmpty(sLoginRole)){	//未登入
	out.println(ComposeXMLResponse(gcResultCodeNoLoginInfoFound,gcResultTextNoLoginInfoFound,""));
	return;
}

if (!sLoginRole.equals(gcUserAdmin)){	//您無權限使用此程式
	out.println(ComposeXMLResponse(gcResultCodeNoPriviledge, gcResultTextNoPriviledge,""));
	return;
}


/*********************開始做事吧*********************/

String sJobType					= nullToString(request.getParameter("jobType"), "");                              
String sServiceId				= nullToString(request.getParameter("ServiceId"), "");
String sServiceName				= nullToString(request.getParameter("ServiceName"), "");                              
String sGoogleAPIKey			= nullToString(request.getParameter("GoogleAPIKey"), "");                              
String sGCMSenderId				= nullToString(request.getParameter("GCMSenderId"), "");                              
String sAPNSCertNameProd		= nullToString(request.getParameter("APNSCertNameProd"), "");                              
String sAPNSCertPasswordProd	= nullToString(request.getParameter("APNSCertPasswordProd"), "");                              
String sAPNSCertNameTest		= nullToString(request.getParameter("APNSCertNameTest"), "");                              
String sAPNSCertPasswordTest	= nullToString(request.getParameter("APNSCertPasswordTest"), "");                              
String sStatus					= nullToString(request.getParameter("Status"), "");

if (beEmpty(sServiceId) || beEmpty(sJobType) || !(sJobType.equals("a")||sJobType.equals("e")) || beEmpty(sServiceName)){
	out.println(ComposeXMLResponse(gcResultCodeParametersNotEnough, gcResultTextParametersNotEnough, ""));
	return;
}

sServiceId				= sServiceId.replace("'", "''");			//處理Oracle的單引號
sServiceName			= sServiceName.replace("'", "''");			//處理Oracle的單引號
sGoogleAPIKey			= sGoogleAPIKey.replace("'", "''");			//處理Oracle的單引號
sGCMSenderId			= sGCMSenderId.replace("'", "''");			//處理Oracle的單引號
sAPNSCertNameProd		= sAPNSCertNameProd.replace("'", "''");		//處理Oracle的單引號
sAPNSCertPasswordProd	= sAPNSCertPasswordProd.replace("'", "''");	//處理Oracle的單引號
sAPNSCertNameTest		= sAPNSCertNameTest.replace("'", "''");		//處理Oracle的單引號
sAPNSCertPasswordTest	= sAPNSCertPasswordTest.replace("'", "''");	//處理Oracle的單引號

Hashtable	ht					= new Hashtable();
String		sResultCode			= gcResultCodeSuccess;
String		sResultText			= gcResultTextSuccess;
String		s[][]				= null;
int			iColCount			= 0;
String		sSQL				= "";

String		ss					= "";
int			i					= 0;

if (sJobType.equals("a")){	//新增訊息
	sSQL = "insert into MV_ServiceList (ServiceId, ServiceName, GoogleAPIKey, GCMSenderId, APNSCertNameProd, APNSCertPasswordProd, APNSCertNameTest, APNSCertPasswordTest, Status)";
	sSQL += " values (";
	sSQL += " '" +    sServiceId			+ "'";
	sSQL += ", '" +   sServiceName			+ "'";
	sSQL += ", '" +   sGoogleAPIKey			+ "'";
	sSQL += ", '" +   sGCMSenderId			+ "'";
	sSQL += ", '" +   sAPNSCertNameProd		+ "'";
	sSQL += ", '" +   sAPNSCertPasswordProd	+ "'";
	sSQL += ", '" +   sAPNSCertNameTest		+ "'";
	sSQL += ", '" +   sAPNSCertPasswordTest	+ "'";
	sSQL += ", '" +   sStatus				+ "'";
	sSQL += " )";
}

if (sJobType.equals("e")){	//修改訊息
	//更新資料
	sSQL = "update MV_ServiceList";
	sSQL += " set";
	sSQL += "  ServiceName='"			+	sServiceName			+ "'";
	sSQL += ", GoogleAPIKey='"			+	sGoogleAPIKey			+ "'";
	sSQL += ", GCMSenderId='"			+	sGCMSenderId			+ "'";
	sSQL += ", APNSCertNameProd='"		+	sAPNSCertNameProd		+ "'";
	sSQL += ", APNSCertPasswordProd='"	+	sAPNSCertPasswordProd	+ "'";
	sSQL += ", APNSCertNameTest='"		+	sAPNSCertNameTest		+ "'";
	sSQL += ", APNSCertPasswordTest='"	+	sAPNSCertPasswordTest	+ "'";
	sSQL += ", Status='"				+	sStatus					+ "'";
	sSQL += " where ServiceId='"		+	sServiceId				+ "'";
}

if (notEmpty(sSQL)){
	ht = execSQLOnDB(sSQL);
	sResultCode = ht.get("ResultCode").toString();
	sResultText = ht.get("ResultText").toString();
	
	if (sResultCode.equals(gcResultCodeSuccess)){	//成功
		out.println(ComposeXMLResponse(gcResultCodeSuccess, gcResultTextSuccess, ""));
	}else{
		out.println(ComposeXMLResponse(sResultCode, sResultText, ""));
	}	//if (sResultCode.equals(gcResultCodeSuccess)){	//成功
}	//if (notEmpty(sSQL)){


%>