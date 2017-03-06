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

String sOrder	= nullToString(request.getParameter("order"), "");	//排序，格式為 MessageId1,MessageId2,MessageId3...

if (beEmpty(sOrder)){
	out.println(ComposeXMLResponse(gcResultCodeParametersNotEnough, gcResultTextParametersNotEnough, ""));
	return;
}

String	a[]	= sOrder.split(",");
if (a==null || a.length<2){
	out.println(ComposeXMLResponse(gcResultCodeParametersNotEnough, gcResultTextParametersNotEnough, ""));
	return;
}

List<String>	s1				= new ArrayList<String>();	//存放所有要執行的SQL指令
Hashtable	ht					= new Hashtable();
String		sResultCode			= gcResultCodeSuccess;
String		sResultText			= gcResultTextSuccess;
String		sSQL				= "";
int			i					= 0;

for (i=0;i<a.length;i++){
	sSQL = "update MV_VASServiceContentService set SortOrder=" + String.valueOf(i+1) + " where ServiceId='" + a[i] + "'";
	s1.add(sSQL);
}

ht = execMultiSQLOnDB(s1, false);

sResultCode = ht.get("ResultCode").toString();
sResultText = ht.get("ResultText").toString();

out.println(ComposeXMLResponse(sResultCode, sResultText, ""));
	
%>