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

String sJobType					= nullToString(request.getParameter("jobType"), "");                              
String sServiceId				= nullToString(request.getParameter("ServiceId"), "");
String sServiceName				= nullToString(request.getParameter("ServiceName"), "");                              
String sLinkURL					= nullToString(request.getParameter("LinkURL"), "");                              

if (beEmpty(sServiceId) || beEmpty(sJobType) || !(sJobType.equals("a")||sJobType.equals("e")) || beEmpty(sServiceName)){
	out.println(ComposeXMLResponse(gcResultCodeParametersNotEnough, gcResultTextParametersNotEnough, ""));
	return;
}

sServiceId				= sServiceId.replace("'", "''");			//處理Oracle的單引號
sServiceName			= sServiceName.replace("'", "''");			//處理Oracle的單引號
sLinkURL				= sLinkURL.replace("'", "''");				//處理Oracle的單引號

Hashtable	ht					= new Hashtable();
String		sResultCode			= gcResultCodeSuccess;
String		sResultText			= gcResultTextSuccess;
String		s[][]				= null;
int			iColCount			= 0;
String		sSQL				= "";

String		ss					= "";
int			i					= 0;

if (sJobType.equals("a")){	//新增訊息
	sSQL = "insert into MV_VASServiceBasic (ServiceId, ServiceName, LinkURL, SortOrder)";
	sSQL += " values (";
	sSQL += " '" +    sServiceId		+ "'";
	sSQL += ", '" +   sServiceName		+ "'";
	sSQL += ", '" +   sLinkURL			+ "'";
	sSQL += ", "  +   "0"				;
	sSQL += " )";
}

if (sJobType.equals("e")){	//修改訊息
	//更新資料
	sSQL = "update MV_VASServiceBasic";
	sSQL += " set";
	sSQL += " ServiceName='"		+	sServiceName		+ "'";
	sSQL += ", LinkURL='"			+	sLinkURL			+ "'";
	sSQL += " where ServiceId='"	+	sServiceId			+ "'";
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