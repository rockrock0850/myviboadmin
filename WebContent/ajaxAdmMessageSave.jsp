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
List<String> rejectList = Arrays.asList(mesSaveReject);
if(rejectList.contains(sLoginRole)){
	out.println(ComposeXMLResponse(gcResultCodeNoPriviledge, gcResultTextNoPriviledge,""));
	return;
}


/*********************開始做事吧*********************/

String sJobType				= nullToString(request.getParameter("jobType"), "");                              
String sMessageId			= nullToString(request.getParameter("MessageId"), "");                              
String sVersionNo			= nullToString(request.getParameter("VersionNo"), "");
String sStatus				= nullToString(request.getParameter("Status"), "");
String sLastModifiedPerson	= nullToString(request.getParameter("LastModifiedPerson"), "");
String sLastModifiedDate	= nullToString(request.getParameter("LastModifiedDate"), "");
String sSubject				= nullToString(request.getParameter("Subject"), "");
String sSubjectPic			= nullToString(request.getParameter("SubjectPic"), "");
String sSubText1			= nullToString(request.getParameter("SubText1"), "");
String sSubText2			= nullToString(request.getParameter("SubText2"), "");
String sBodyText			= nullToString(request.getParameter("BodyText"), "");
String sBodyPic				= nullToString(request.getParameter("BodyPic"), "");
String sBodyText2			= nullToString(request.getParameter("BodyText2"), "");
String sShowHomeBanner		= nullToString(request.getParameter("ShowHomeBanner"), "");
String sShowRecommand		= nullToString(request.getParameter("ShowRecommand"), "");
String sShowSnowLeopard		= nullToString(request.getParameter("ShowSnowLeopard"), "");
String sShowNewEvent		= nullToString(request.getParameter("ShowNewEvent"), "");
String sShowProgram			= nullToString(request.getParameter("ShowProgram"), "");
String sShowPushMessage		= nullToString(request.getParameter("ShowPushMessage"), "");
String sEffectDate			= nullToString(request.getParameter("EffectDate"), "");
String sExpireDate			= nullToString(request.getParameter("ExpireDate"), "");
String sEffectDateHome		= nullToString(request.getParameter("EffectDateHome"), "");
String sExpireDateHome		= nullToString(request.getParameter("ExpireDateHome"), "");
String sEffectDateRecommand	= nullToString(request.getParameter("EffectDateRecommand"), "");
String sExpireDateRecommand	= nullToString(request.getParameter("ExpireDateRecommand"), "");
String sLinkURL				= nullToString(request.getParameter("LinkURL"), "");
String sServiceId			= nullToString(request.getParameter("ServiceId"), "");

if (beEmpty(sMessageId) || beEmpty(sJobType) || !(sJobType.equals("a")||sJobType.equals("e")) || beEmpty(sServiceId)){
	out.println(ComposeXMLResponse(gcResultCodeParametersNotEnough, gcResultTextParametersNotEnough, ""));
	return;
}

sSubject	= sSubject.replace("'", "''");		//處理Oracle的單引號
sSubText1	= sSubText1.replace("'", "''");		//處理Oracle的單引號
sSubText2	= sSubText2.replace("'", "''");		//處理Oracle的單引號
sBodyText	= sBodyText.replace("'", "''");		//處理Oracle的單引號
sBodyText2	= sBodyText2.replace("'", "''");	//處理Oracle的單引號
sLinkURL	= sLinkURL.replace("'", "''");		//處理Oracle的單引號
sServiceId	= sServiceId.replace("'", "''");	//處理Oracle的單引號

if (notEmpty(sShowHomeBanner) && sShowHomeBanner.equals("on"))		sShowHomeBanner = "Y";	else sShowHomeBanner	= "N";
if (notEmpty(sShowRecommand) && sShowRecommand.equals("on"))		sShowRecommand = "Y";	else sShowRecommand	= "N";
if (notEmpty(sShowSnowLeopard) && sShowSnowLeopard.equals("on"))		sShowSnowLeopard = "Y";	else sShowSnowLeopard	= "N";
if (notEmpty(sShowNewEvent) && sShowNewEvent.equals("on"))			sShowNewEvent = "Y";	else sShowNewEvent	= "N";
if (notEmpty(sShowProgram) && sShowProgram.equals("on"))			sShowProgram = "Y";		else sShowProgram	= "N";
if (notEmpty(sShowPushMessage) && sShowPushMessage.equals("on"))	sShowPushMessage = "Y";	else sShowPushMessage	= "N";

Hashtable	ht					= new Hashtable();
String		sResultCode			= gcResultCodeSuccess;
String		sResultText			= gcResultTextSuccess;
String		s[][]				= null;
int			iColCount			= 0;
String		sSQL				= "";

String		ss					= "";
int			i					= 0;

if (sJobType.equals("a")){	//新增訊息
	sSQL = "insert into MV_MessageList (MessageId, VersionNo, Status, LastModifiedPerson, LastModifiedDate, Subject, SubjectPic, SubText1, SubText2, BodyText, BodyPic, BodyText2, ShowHomeBanner, ShowRecommand, ShowNewEvent, ShowProgram, ShowPushMessage, EffectDate, ExpireDate, EffectDateHome, ExpireDateHome, EffectDateRecommand, ExpireDateRecommand, LinkURL, ServiceId, SortOrder, ShowSnowLeopard)";
	sSQL += " values (";
	sSQL += " '" +    sMessageId			                                + "'";
	sSQL += ", " +   sVersionNo			                                 ;
	sSQL += ", '" +   sStatus				                                 + "'";
	sSQL += ", '" +   sLastModifiedPerson	                                 + "'";
	sSQL += ", " +   "sysdate";
	sSQL += ", '" +   sSubject				                                 + "'";
	sSQL += ", '" +   sSubjectPic			                                 + "'";
	sSQL += ", '" +   sSubText1			                                     + "'";
	sSQL += ", '" +   sSubText2			                                     + "'";
	sSQL += ", '" +   sBodyText			                                     + "'";
	sSQL += ", '" +   sBodyPic				                                 + "'";
	sSQL += ", '" +   sBodyText2			                                 + "'";
	sSQL += ", '" +   sShowHomeBanner		                                 + "'";
	sSQL += ", '" +   sShowRecommand		                                 + "'";
	sSQL += ", '" +   sShowNewEvent		                                     + "'";
	sSQL += ", '" +   sShowProgram			                                 + "'";
	sSQL += ", '" +   sShowPushMessage										+ "'";
	sSQL += ", " +   "TO_DATE('" + sEffectDate + "','YYYY/MM/DD HH24:MI:SS')";
	sSQL += ", " +   "TO_DATE('" + sExpireDate + "','YYYY/MM/DD HH24:MI:SS')";
	sSQL += ", " +   "TO_DATE('" + sEffectDateHome + "','YYYY/MM/DD HH24:MI:SS')";
	sSQL += ", " +   "TO_DATE('" + sExpireDateHome + "','YYYY/MM/DD HH24:MI:SS')";
	sSQL += ", " +   "TO_DATE('" + sEffectDateRecommand + "','YYYY/MM/DD HH24:MI:SS')";
	sSQL += ", " +   "TO_DATE('" + sExpireDateRecommand + "','YYYY/MM/DD HH24:MI:SS')";
	sSQL += ", '" +   sLinkURL			                                     + "'";
	sSQL += ", '" +   sServiceId		                                     + "'";
	sSQL += ", " +	  "0";
	sSQL += ", '" +	  sShowSnowLeopard										+ "'";
	sSQL += " )";
}

String sSubjectPicOld	= "";
String sBodyPicOld		= "";

if (sJobType.equals("e")){	//修改訊息
	//先取得原始資料中的圖檔資訊
	iColCount = 2;
	sSQL = "select SubjectPic, BodyPic from MV_MessageList where MessageId='" + sMessageId + "'";
	
	ht = getDBData(sSQL, iColCount);
	sResultCode = ht.get("ResultCode").toString();
	sResultText = ht.get("ResultText").toString();
	
	if (sResultCode.equals(gcResultCodeSuccess)){	//有資料
		s = (String[][])ht.get("Data");
		sSubjectPicOld = s[0][0];
		sBodyPicOld = s[0][1];
	}else{
		out.println(ComposeXMLResponse(sResultCode, sResultText, ""));
		return;
	}
	
	if (notEmpty(sSubjectPicOld)){
		i = sSubjectPicOld.lastIndexOf(".");
		sSubjectPicOld = gcBasePathForFileUpload + sMessageId + "-1" + sSubjectPicOld.substring(i);
	}
	if (notEmpty(sBodyPicOld)){
		i = sBodyPicOld.lastIndexOf(".");
		sBodyPicOld = gcBasePathForFileUpload + sMessageId + "-2" + sBodyPicOld.substring(i);
	}

	//更新資料
	sSQL = "update MV_MessageList";
	sSQL += " set";
	sSQL += " VersionNo="				+   "VersionNo+1"			;		//將版本編號+1
	sSQL += ", Status='"				+   sStatus					+ "'";
	sSQL += ", LastModifiedPerson='"	+   sLastModifiedPerson		+ "'";
	sSQL += ", LastModifiedDate="		+   "sysdate"				;
	sSQL += ", Subject='"				+   sSubject				+ "'";
	sSQL += ", SubjectPic='"			+   sSubjectPic				+ "'";
	sSQL += ", SubText1='"				+   sSubText1				+ "'";
	sSQL += ", SubText2='"				+   sSubText2				+ "'";
	sSQL += ", BodyText='"				+   sBodyText				+ "'";
	sSQL += ", BodyPic='"				+   sBodyPic				+ "'";
	sSQL += ", BodyText2='"				+   sBodyText2				+ "'";
	sSQL += ", ShowHomeBanner='"		+   sShowHomeBanner			+ "'";
	sSQL += ", ShowRecommand='"			+   sShowRecommand			+ "'";
	sSQL += ", ShowSnowLeopard='"		+   sShowSnowLeopard		+ "'";
	sSQL += ", ShowNewEvent='"			+   sShowNewEvent			+ "'";
	sSQL += ", ShowProgram='"			+   sShowProgram			+ "'";
	sSQL += ", ShowPushMessage='"		+   sShowPushMessage		+ "'";
	sSQL += ", EffectDate="				+   "TO_DATE('" + sEffectDate + "','YYYY/MM/DD HH24:MI:SS')";
	sSQL += ", ExpireDate="				+   "TO_DATE('" + sExpireDate + "','YYYY/MM/DD HH24:MI:SS')";
	sSQL += ", EffectDateHome="			+   "TO_DATE('" + sEffectDateHome + "','YYYY/MM/DD HH24:MI:SS')";
	sSQL += ", ExpireDateHome="			+   "TO_DATE('" + sExpireDateHome + "','YYYY/MM/DD HH24:MI:SS')";
	sSQL += ", EffectDateRecommand="	+   "TO_DATE('" + sEffectDateRecommand + "','YYYY/MM/DD HH24:MI:SS')";
	sSQL += ", ExpireDateRecommand="	+   "TO_DATE('" + sExpireDateRecommand + "','YYYY/MM/DD HH24:MI:SS')";
	sSQL += ", LinkURL='"				+   sLinkURL				+ "'";
	sSQL += ", ServiceId='"				+   sServiceId				+ "'";
	sSQL += " where MessageId='" + sMessageId + "'";
}
System.out.println("ajaxAdmMessageSave.jsp SQL: " + sSQL);
if (notEmpty(sSQL)){
	ht = execSQLOnDB(sSQL);
	sResultCode = ht.get("ResultCode").toString();
	sResultText = ht.get("ResultText").toString();
	
	if (sResultCode.equals(gcResultCodeSuccess)){	//成功
		if (sJobType.equals("e")){	//修改訊息，若之前有圖檔而現在沒圖檔，則將原圖檔刪除
			if (beEmpty(sSubjectPic) && notEmpty(sSubjectPicOld)){
				DeleteFile(sSubjectPicOld);
			}
			if (beEmpty(sBodyPic) && notEmpty(sBodyPicOld)){
				DeleteFile(sBodyPicOld);
			}
		}	//if (sJobType.equals("e")){	//修改訊息，若之前有圖檔而現在沒圖檔，則將原圖檔刪除
		if (sStatus.equals("0")){	//未上線，發email給主管
			String sEmailSubject = "";
			String sEmailBody = "";
			sEmailSubject = "台灣之星APP 訊息簽核通知";
			sEmailBody = "您有一個待簽核訊息，訊息編號：" + sMessageId + "<br>請記得至<a href='https://vas.tstartel.com/myviboadmin/index.html'>台灣之星APP後台管理系統</a>進行簽核!";
			sendHTMLMail(gcDefaultEmailSMTPServer, gcDefaultEmailFromAddress, gcDefaultEmailFromName, getManagerMailList(), sEmailSubject, sEmailBody);
			//writeToFile(getManagerMailList());
		}
		out.println(ComposeXMLResponse(gcResultCodeSuccess, gcResultTextSuccess, ""));
	}else{
		out.println(ComposeXMLResponse(sResultCode, sResultText, ""));
	}	//if (sResultCode.equals(gcResultCodeSuccess)){	//成功
}	//if (notEmpty(sSQL)){


%>