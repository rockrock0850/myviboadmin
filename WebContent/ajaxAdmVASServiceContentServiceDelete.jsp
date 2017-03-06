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

/*********************開始做事吧*********************/

String sServiceId	= nullToString(request.getParameter("ServiceId"), "");                              

if (beEmpty(sServiceId)){
	out.println(ComposeXMLResponse(gcResultCodeParametersNotEnough, gcResultTextParametersNotEnough, ""));
	return;
}

Hashtable	ht					= new Hashtable();
String		sResultCode			= gcResultCodeSuccess;
String		sResultText			= gcResultTextSuccess;
String		s[][]				= null;
int			iColCount			= 0;
String		sSQL				= "";
int			i					= 0;
String		sServiceIcon		= "";	//標題圖檔(URL)
String 		sServicePic			= "";	//服務大圖檔(URL)

iColCount = 2;
sSQL = "select ServiceIcon, ServicePic from MV_VASServiceContentService where ServiceId='" + sServiceId + "'";

ht = getDBData(sSQL, iColCount);
sResultCode = ht.get("ResultCode").toString();
sResultText = ht.get("ResultText").toString();

if (sResultCode.equals(gcResultCodeSuccess)){	//有資料
	s = (String[][])ht.get("Data");
	sServiceIcon = s[0][0];
	sServicePic = s[0][1];
}else{
	out.println(ComposeXMLResponse(sResultCode, sResultText, ""));
	return;
}

if (notEmpty(sServiceIcon)){
	i = sServiceIcon.lastIndexOf(".");
	sServiceIcon = gcBasePathForFileUpload + sServiceId + "-1" + sServiceIcon.substring(i);
}
if (notEmpty(sServicePic)){
	i = sServicePic.lastIndexOf(".");
	sServicePic = gcBasePathForFileUpload + sServiceId + "-2" + sServicePic.substring(i);
}

//刪除資料
sSQL = "delete from MV_VASServiceContentService where ServiceId='" + sServiceId + "'";
ht = execSQLOnDB(sSQL);
sResultCode = ht.get("ResultCode").toString();
sResultText = ht.get("ResultText").toString();

if (sResultCode!=null && sResultCode.equals(gcResultCodeSuccess)){	//資料已從DB刪除，開始刪除圖檔
	if (notEmpty(sServiceIcon)){
		DeleteFile(sServiceIcon);
	}
	if (notEmpty(sServicePic)){
		DeleteFile(sServicePic);
	}
}	//if (sResultCode!=null && sResultCode.equals(gcResultCodeSuccess)){	//資料已從DB刪除，開始刪除圖檔

out.println(ComposeXMLResponse(sResultCode, sResultText, ""));


%>