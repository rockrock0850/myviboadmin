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

//if (sLoginRole.equals(gcUserEditor)){	//您無權限使用此程式
List<String> rejectList = Arrays.asList(mesApproveReject);
if(rejectList.contains(sLoginRole)){
	out.println(ComposeXMLResponse(gcResultCodeNoPriviledge, gcResultTextNoPriviledge,""));
	return;
}


/*********************開始做事吧*********************/

String sApprove	= nullToString(request.getParameter("Approve"), "");                              
String sMessageId	= nullToString(request.getParameter("MessageId"), "");                              

if (beEmpty(sApprove) || beEmpty(sMessageId)){
	out.println(ComposeXMLResponse(gcResultCodeParametersNotEnough, gcResultTextParametersNotEnough, ""));
	return;
}

if (sApprove.equals("true"))	sApprove = "1";
else							sApprove = "0";

Hashtable	ht					= new Hashtable();
String		sResultCode			= gcResultCodeSuccess;
String		sResultText			= gcResultTextSuccess;
String		s[][]				= null;
int			iColCount			= 0;
String		sSQL				= "";
String		sLastModifiedPersonMail	= getLastModifiedPersonMail(sMessageId);	//最後一次編輯此訊息的人

sSQL = "update MV_MessageList set Status='" + sApprove + "', LastModifiedPerson='" + sLoginId + "', LastModifiedDate=sysdate where MessageId='" + sMessageId + "'";
ht = execSQLOnDB(sSQL);
sResultCode = ht.get("ResultCode").toString();
sResultText = ht.get("ResultText").toString();

if (sResultCode.equals(gcResultCodeSuccess)){	//成功
	String sEmailSubject = "";
	String sEmailBody = "";
	if (sApprove.equals("1")){
		sEmailSubject = "台灣之星APP 訊息簽核完成通知";
		sEmailBody = "您的訊息已簽核完成，目前狀態為已上線，訊息編號：" + sMessageId + "<br>您可至<a href='https://vas.tstartel.com/myviboadmin/index.html'>台灣之星APP後台管理系統</a>觀看此訊息!";
	}else{
		sEmailSubject = "台灣之星APP 訊息退回通知";
		sEmailBody = "您的訊息已被退回，目前狀態為未上線，訊息編號：" + sMessageId + "<br>您可至<a href='https://vas.tstartel.com/myviboadmin/index.html'>台灣之星APP後台管理系統</a>觀看此訊息!";
	}
	sendHTMLMail(gcDefaultEmailSMTPServer, gcDefaultEmailFromAddress, gcDefaultEmailFromName, getManagerMailList(), sEmailSubject, sEmailBody);
}

out.println(ComposeXMLResponse(sResultCode, sResultText, ""));


%>