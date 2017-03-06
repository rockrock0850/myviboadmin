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
	out.println(gcResultTextNoLoginInfoFound);
	return;
}

/*********************開始做事吧*********************/

String sMessageId			= nullToString(request.getParameter("mid"), "");

if (beEmpty(sMessageId)){
	out.println("不要亂連");
	return;
}

Hashtable	ht					= new Hashtable();
String		sResultCode			= gcResultCodeSuccess;
String		sResultText			= gcResultTextSuccess;
String		s[][]				= null;
int			iColCount			= 0;
String		sSQL				= "";

String		ss					= "";
int			i					= 0;

iColCount = 2;
sSQL = "select MSISDN, ContractId";
sSQL += " from MV_PushMessageRecordDetail";
sSQL += " where MessageId='" + sMessageId + "'";
sSQL += " order by MSISDN DESC";

//writeToFile(sSQL);

ht = getDBData(sSQL, iColCount);
sResultCode = ht.get("ResultCode").toString();
sResultText = ht.get("ResultText").toString();

if (sResultCode.equals(gcResultCodeSuccess)){	//有資料
	s = (String[][])ht.get("Data");
	out.println("<html><head><link href='css/default.css' rel='stylesheet' type='text/css' media='all' /></head><body>");
	out.println("<div id='wrapper'><div id='page' class='container'>");
	out.println("<table class='hasBorder'>");
	for (i=0;i<s.length;i++){
		ss = "<tr>";
		ss += "<td>"				+ nullToString(s[i][0], "") + "</td>";
		ss += "<td>"				+ nullToString(s[i][1], "") + "</td>";
		ss += "</tr>";
		out.println(ss);
	}
	out.println("</table>");
	out.println("</div></div>");
	out.println("</body></html>");
}else{
	out.println(sResultText);
	return;
}



%>