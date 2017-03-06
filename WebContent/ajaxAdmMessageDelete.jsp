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

//if (sLoginRole.equals(gcUserManager)){	//您無權限使用此程式
List<String> rejectList = Arrays.asList(mesDeleteReject);
if(rejectList.contains(sLoginRole)){
	out.println(ComposeXMLResponse(gcResultCodeNoPriviledge, gcResultTextNoPriviledge,""));
	return;
}


/*********************開始做事吧*********************/

String sMessageId	= nullToString(request.getParameter("MessageId"), "");                              

if (beEmpty(sMessageId)){
	out.println(ComposeXMLResponse(gcResultCodeParametersNotEnough, gcResultTextParametersNotEnough, ""));
	return;
}

Hashtable	ht					= new Hashtable();
String		sResultCode			= gcResultCodeSuccess;
String		sResultText			= gcResultTextSuccess;
String		s[][]				= null;
int			iColCount			= 0;
String		sSQL				= "";
String		sSubjectPic			= "";	//標題圖檔(URL)
String 		sBodyPic			= "";	//內文圖檔(URL)
int			i					= 0;

iColCount = 2;
sSQL = "select SubjectPic, BodyPic from MV_MessageList where MessageId='" + sMessageId + "'";

ht = getDBData(sSQL, iColCount);
sResultCode = ht.get("ResultCode").toString();
sResultText = ht.get("ResultText").toString();

if (sResultCode.equals(gcResultCodeSuccess)){	//有資料
	s = (String[][])ht.get("Data");
	sSubjectPic = s[0][0];
	sBodyPic = s[0][1];
}else{
	out.println(ComposeXMLResponse(sResultCode, sResultText, ""));
	return;
}

if (notEmpty(sSubjectPic)){
	i = sSubjectPic.lastIndexOf(".");
	sSubjectPic = gcBasePathForFileUpload + sMessageId + "-1" + sSubjectPic.substring(i);
}
if (notEmpty(sBodyPic)){
	i = sBodyPic.lastIndexOf(".");
	sBodyPic = gcBasePathForFileUpload + sMessageId + "-2" + sBodyPic.substring(i);
}

//刪除資料
sSQL = "delete from MV_MessageList where MessageId='" + sMessageId + "'";
ht = execSQLOnDB(sSQL);
sResultCode = ht.get("ResultCode").toString();
sResultText = ht.get("ResultText").toString();

if (sResultCode!=null && sResultCode.equals(gcResultCodeSuccess)){	//資料已從DB刪除，開始刪除圖檔
	if (notEmpty(sSubjectPic)){
		DeleteFile(sSubjectPic);
	}
	if (notEmpty(sBodyPic)){
		DeleteFile(sBodyPic);
	}
}	//if (sResultCode!=null && sResultCode.equals(gcResultCodeSuccess)){	//資料已從DB刪除，開始刪除圖檔

out.println(ComposeXMLResponse(sResultCode, sResultText, ""));


%>