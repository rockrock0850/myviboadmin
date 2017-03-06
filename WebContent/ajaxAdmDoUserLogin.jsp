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

String sLoginId = request.getParameter("sId");
String sLoginPassword = request.getParameter("sPassword");

//先將Session資料清除
session.setAttribute("LoginId", "");
session.setAttribute("LoginRole", "");


if (beEmpty(sLoginId) || beEmpty(sLoginPassword)) {
	out.println(ComposeXMLResponse(gcResultCodeParametersNotEnough, gcResultTextParametersNotEnough, ""));
	return;
}

/**************************以下為【只允許OA的IP連線】*********************/
String LoginIP = "";
LoginIP = request.getRemoteAddr();
//if (!LoginIP.startsWith("172.2")){
//	out.println(ComposeXMLResponse(gcResultCodeUnknownError, "不要亂連!", ""));
//	return;
//}
/**************************以上為【只允許OA的IP連線】*********************/

Hashtable	ht				= new Hashtable();
String		sResultCode		= gcResultCodeSuccess;
String		sResultText		= gcResultTextSuccess;
String		s[][]			= null;
int			iColCount		= 0;
String		sSQL			= "";

iColCount = 3;
sSQL = "select LoginId, LoginPassword, LoginRole from MV_AccountList where";
sSQL += " LoginId='" + sLoginId + "'";
sSQL += " and LoginPassword='" + sLoginPassword + "'";

ht = getDBData(sSQL, iColCount);
sResultCode = ht.get("ResultCode").toString();
sResultText = ht.get("ResultText").toString();

if (sResultCode.equals(gcResultCodeSuccess)){	//有資料
	//帳號密碼驗證通過，開始將相關參數紀錄至Session中
	s = (String[][])ht.get("Data");
	if (notEmpty(s[0][2])){
		session.setAttribute("LoginId", sLoginId);
		session.setAttribute("LoginRole", s[0][2]);
		out.println(ComposeXMLResponse(gcResultCodeSuccess, gcResultTextSuccess, "<LoginRole>" + s[0][2] + "</LoginRole>"));
	}else{
		out.println(ComposeXMLResponse(gcResultCodeNoDataFound, gcResultTextNoDataFound, ""));
	}
}else{
	out.println(ComposeXMLResponse(sResultCode, sResultText, ""));
}

%>