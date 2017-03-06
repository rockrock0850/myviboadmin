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

String sJobType = request.getParameter("sJobType");
sLoginId = request.getParameter("sLoginId");
String sLoginPassword = request.getParameter("sLoginPassword");
sLoginRole = request.getParameter("sLoginRole");
String sAccountEmail = request.getParameter("sAccountEmail");

if (beEmpty(sJobType) || beEmpty(sLoginId) || (sJobType.equals("a") && beEmpty(sLoginPassword)) || beEmpty(sLoginRole) || beEmpty(sAccountEmail)) {
	out.println(ComposeXMLResponse(gcResultCodeParametersNotEnough, gcResultTextParametersNotEnough+"若為新增使用者，請務必輸入密碼!", ""));
	return;
}

Hashtable	ht				= new Hashtable();
String		sResultCode		= gcResultCodeSuccess;
String		sResultText		= gcResultTextSuccess;
String		s[][]			= null;
int			iColCount		= 0;
String		sSQL			= "";

if (sJobType.equals("a")){	//新增使用者
	sSQL = "insert into MV_AccountList (LoginId, LoginPassword, LoginRole, AccountEmail) values (";
	sSQL += " '" + sLoginId + "'";
	sSQL += ", '" + sLoginPassword + "'";
	sSQL += ", '" + sLoginRole + "'";
	sSQL += ", '" + sAccountEmail + "'";
	sSQL += ")";
}	//if (sJobType.equals("a")){	//新增使用者

if (sJobType.equals("e")){	//修改既有使用者
		sSQL = "update MV_AccountList set";
		sSQL += " LoginRole='" + sLoginRole + "'";
		sSQL += ", AccountEmail='" + sAccountEmail + "'";
		if (notEmpty(sLoginPassword)) sSQL += ", LoginPassword='" + sLoginPassword + "'";
		sSQL += " where";
		sSQL += " LoginId='" + sLoginId + "'";
}	//if (sJobType.equals("e")){	//新增使用者

	if (notEmpty(sSQL)){
		ht = execSQLOnDB(sSQL);
		sResultCode = ht.get("ResultCode").toString();
		sResultText = ht.get("ResultText").toString();
		out.println(ComposeXMLResponse(sResultCode, sResultText, ""));
	}else{
		out.println(ComposeXMLResponse(gcResultCodeParametersNotEnough, gcResultTextParametersNotEnough, ""));
	}

%>