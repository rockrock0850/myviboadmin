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


/* if (!sLoginRole.equals(gcUserAdmin)){	//回傳 00000 & 作業成功  & ""
	out.println(ComposeXMLResponse(gcResultCodeSuccess, gcResultTextSuccess, ""));
	return;
}  */

/*********************開始做事吧*********************/
String sServiceId = request.getParameter("sid");

Hashtable	ht					= new Hashtable();
String		sResultCode			= gcResultCodeSuccess;
String		sResultText			= gcResultTextSuccess;
String		s[][]				= null;
int			iColCount			= 0;
String		sSQL				= "";
String		sWhere				= "";

String		ss					= "";
int			i					= 0;

iColCount = 9;
sSQL = "select ServiceId, ServiceName, GoogleAPIKey, GCMSenderId, APNSCertNameProd, APNSCertPasswordProd, APNSCertNameTest, APNSCertPasswordTest, Status";
sSQL += " from MV_ServiceList";
if (notEmpty(sServiceId)) sSQL += " where ServiceId='" + sServiceId + "'";
sSQL += " order by ServiceId";

//writeToFile(sSQL);

ht = getDBData(sSQL, iColCount);
sResultCode = ht.get("ResultCode").toString();
sResultText = ht.get("ResultText").toString();

if (sResultCode.equals(gcResultCodeSuccess)){	//有資料
	s = (String[][])ht.get("Data");
	ss = "<items>";
	for (i=0;i<s.length;i++){
		ss += "<item>";
		ss += "<ServiceId>"				+ nullToString(s[i][0], "") + "</ServiceId>";
		ss += "<ServiceName>"			+ nullToString(s[i][1], "") + "</ServiceName>";
		ss += "<GoogleAPIKey>"			+ nullToString(s[i][2], "") + "</GoogleAPIKey>";
		ss += "<GCMSenderId>"			+ nullToString(s[i][3], "") + "</GCMSenderId>";
		ss += "<APNSCertNameProd>"		+ nullToString(s[i][4], "") + "</APNSCertNameProd>";
		ss += "<APNSCertPasswordProd>"	+ nullToString(s[i][5], "") + "</APNSCertPasswordProd>";
		ss += "<APNSCertNameTest>"		+ nullToString(s[i][6], "") + "</APNSCertNameTest>";
		ss += "<APNSCertPasswordTest>"	+ nullToString(s[i][7], "") + "</APNSCertPasswordTest>";
		ss += "<Status>"				+ nullToString(s[i][8], "") + "</Status>";
		ss += "</item>";
	}
	ss += "</items>";
}else{
	out.println(ComposeXMLResponse(sResultCode, sResultText, ""));
	return;
}

out.println(ComposeXMLResponse(gcResultCodeSuccess, gcResultTextSuccess, ss));


%>