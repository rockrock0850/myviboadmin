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

/*********************取得目前的帳號清單*********************/
String	sLoginId = (String)session.getAttribute("LoginId");
String	sLoginRole = (String)session.getAttribute("LoginRole");
if (beEmpty(sLoginId) || beEmpty(sLoginRole)){	//未登入
	out.println(ComposeXMLResponse(gcResultCodeNoLoginInfoFound, gcResultTextNoLoginInfoFound, ""));
	return;
}

if (!sLoginRole.equals(gcUserAdmin)){	//您無權限使用此程式
	out.println(ComposeXMLResponse(gcResultCodeNoPriviledge, gcResultTextNoPriviledge, ""));
	return;
}


/*********************開始做事吧*********************/

Hashtable	ht					= new Hashtable();
String		sResultCode			= gcResultCodeSuccess;
String		sResultText			= gcResultTextSuccess;
String		s[][]				= null;
int			iColCount			= 0;
String		sSQL				= "";

String		ss					= "";
int			i					= 0;

iColCount = 3;
sSQL = "select LoginId, LoginRole, AccountEmail from MV_AccountList order by LoginRole, LoginId";
ht = getDBData(sSQL, iColCount);
sResultCode = ht.get("ResultCode").toString();
sResultText = ht.get("ResultText").toString();

if (sResultCode.equals(gcResultCodeSuccess)){	//有資料
	s = (String[][])ht.get("Data");
	ss = "<items>";
	for (i=0;i<s.length;i++){
		ss += "<item>";
		ss += "<LoginId>"		+ s[i][0] + "</LoginId>";
		ss += "<LoginRole>"		+ s[i][1] + "</LoginRole>";
		ss += "<AccountEmail>"	+ s[i][2] + "</AccountEmail>";
		ss += "</item>";
	}
	ss += "</items>";
}
//writeToFile(ss);
out.println(ComposeXMLResponse(sResultCode, sResultText, ss));


%>