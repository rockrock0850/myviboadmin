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
List<String> rejectList = Arrays.asList(mesSearchReject);
if(rejectList.contains(sLoginRole)){
	out.println(ComposeXMLResponse(gcResultCodeNoPriviledge, gcResultTextNoPriviledge,""));
	return;
}


/*********************開始做事吧*********************/

String sMessageId			= nullToString(request.getParameter("MessageId"), "");                              
String sServiceId			= nullToString(request.getParameter("ServiceId"), "");	//服務名稱
String sEffectDateFrom		= nullToString(request.getParameter("EffectDateFrom"), "");
String sEffectDateTo		= nullToString(request.getParameter("EffectDateTo"), "");
String sExpireDateFrom		= nullToString(request.getParameter("ExpireDateFrom"), "");
String sExpireDateTo		= nullToString(request.getParameter("ExpireDateTo"), "");
String sSubject				= nullToString(request.getParameter("Subject"), "");
String sOutDateFrom			= nullToString(request.getParameter("OutDateFrom"), "");
String sStatus				= nullToString(request.getParameter("Status"), "");
String sShowHomeBanner		= nullToString(request.getParameter("ShowHomeBanner"), "");
String sShowRecommand		= nullToString(request.getParameter("ShowRecommand"), "");
String sShowNewEvent		= nullToString(request.getParameter("ShowNewEvent"), "");
String sShowProgram			= nullToString(request.getParameter("ShowProgram"), "");
String sShowPushMessage		= nullToString(request.getParameter("ShowPushMessage"), "");

sSubject	= sSubject.replace("'", "''");		//處理Oracle的單引號
sServiceId	= sServiceId.replace("'", "''");	//處理Oracle的單引號
/*
if (notEmpty(sShowHomeBanner) && sShowHomeBanner.equals("on"))		sShowHomeBanner = "Y";	else sShowHomeBanner	= "N";
if (notEmpty(sShowRecommand) && sShowRecommand.equals("on"))		sShowRecommand = "Y";	else sShowRecommand	= "N";
if (notEmpty(sShowNewEvent) && sShowNewEvent.equals("on"))			sShowNewEvent = "Y";	else sShowNewEvent	= "N";
if (notEmpty(sShowProgram) && sShowProgram.equals("on"))			sShowProgram = "Y";		else sShowProgram	= "N";
if (notEmpty(sShowPushMessage) && sShowPushMessage.equals("on"))	sShowPushMessage = "Y";	else sShowPushMessage	= "N";
*/
Hashtable	ht					= new Hashtable();
String		sResultCode			= gcResultCodeSuccess;
String		sResultText			= gcResultTextSuccess;
String		s[][]				= null;
int			iColCount			= 0;
String		sSQL				= "";
String		sWhere				= "";

String		ss					= "";
int			i					= 0;


if (notEmpty(sMessageId))												sWhere += " and MessageId='" + sMessageId + "'";
if (notEmpty(sServiceId))												sWhere += " and ServiceId='" + sServiceId + "'";
if (notEmpty(sEffectDateFrom))											sWhere += " and EffectDate>=TO_DATE('" + sEffectDateFrom + "','YYYY/MM/DD HH24:MI:SS')";
if (notEmpty(sEffectDateTo))											sWhere += " and EffectDate<=TO_DATE('" + sEffectDateTo + "','YYYY/MM/DD HH24:MI:SS')";
if (notEmpty(sExpireDateFrom))											sWhere += " and ExpireDate>=TO_DATE('" + sExpireDateFrom + "','YYYY/MM/DD HH24:MI:SS')";
if (notEmpty(sExpireDateTo))											sWhere += " and ExpireDate<=TO_DATE('" + sExpireDateTo + "','YYYY/MM/DD HH24:MI:SS')";
if (notEmpty(sSubject)) 												sWhere += " and UPPER(Subject) like '%" + sSubject.toUpperCase() + "%'";
if (notEmpty(sOutDateFrom)) 											sWhere += "	and EffectDate<=TO_DATE('" + sOutDateFrom + "','YYYY/MM/DD HH24:MI:SS') and ExpireDate>=TO_DATE('" + sOutDateFrom + "','YYYY/MM/DD HH24:MI:SS')";
if (notEmpty(sStatus) && (sStatus.equals("0")||sStatus.equals("1")))	sWhere += " and Status='" + sStatus + "'";
if (notEmpty(sStatus) && sStatus.equals("2"))							sWhere += " and Status='1' and EffectDate<sysdate and ExpireDate>sysdate";
if (notEmpty(sShowHomeBanner) && sShowHomeBanner.equals("on"))			sWhere += " and ShowHomeBanner='Y'";
if (notEmpty(sShowRecommand) && sShowRecommand.equals("on"))			sWhere += " and ShowRecommand='Y'";
if (notEmpty(sShowNewEvent) && sShowNewEvent.equals("on"))				sWhere += " and ShowNewEvent='Y'";
if (notEmpty(sShowProgram) && sShowProgram.equals("on"))				sWhere += " and ShowProgram='Y'";
if (notEmpty(sShowPushMessage) && sShowPushMessage.equals("on"))		sWhere += " and ShowPushMessage='Y'";

if (notEmpty(sWhere)) sWhere = sWhere.substring(4);

iColCount = 11;
sSQL = "select MessageId, VersionNo, Subject, TO_CHAR(EffectDate,'YYYY/MM/DD HH24:MI:SS'), TO_CHAR(ExpireDate,'YYYY/MM/DD HH24:MI:SS'), TO_CHAR(LastModifiedDate,'YYYY/MM/DD HH24:MI:SS'), LastModifiedPerson, Status";
sSQL += ", CASE WHEN EffectDate<sysdate AND ExpireDate>sysdate THEN '1' ELSE '0' END";
sSQL += ", ServiceId, SortOrder";
sSQL += " from MV_MessageList";
if (notEmpty(sWhere)) sSQL += " where" + sWhere;
sSQL += " order by SortOrder, to_number(MessageId) DESC";
//writeToFile(sSQL);
ht = getDBData(sSQL, iColCount);
sResultCode = ht.get("ResultCode").toString();
sResultText = ht.get("ResultText").toString();

if (sResultCode.equals(gcResultCodeSuccess)){	//有資料
	s = (String[][])ht.get("Data");
	ss = "<items>";
	for (i=0;i<s.length;i++){
		ss += "<item>";
		ss += "<MessageId>"				+ nullToString(s[i][0], "") + "</MessageId>";
		ss += "<VersionNo>"				+ nullToString(s[i][1], "") + "</VersionNo>";
		ss += "<Subject><![CDATA["		+ nullToString(s[i][2], "") + "]]></Subject>";
		ss += "<EffectDate>"			+ nullToString(s[i][3], "") + "</EffectDate>";
		ss += "<ExpireDate>"			+ nullToString(s[i][4], "") + "</ExpireDate>";
		ss += "<LastModifiedDate>"		+ nullToString(s[i][5], "") + "</LastModifiedDate>";
		ss += "<LastModifiedPerson>"	+ nullToString(s[i][6], "") + "</LastModifiedPerson>";
		ss += "<Status>"				+ nullToString(s[i][7], "") + "</Status>";
		ss += "<Online>"				+ nullToString(s[i][8], "") + "</Online>";
		ss += "<ServiceId>"				+ nullToString(s[i][9], "") + "</ServiceId>";
		ss += "<SortOrder>"				+ nullToString(s[i][10], "") + "</SortOrder>";
		ss += "</item>";
	}
	ss += "</items>";
}else{
	out.println(ComposeXMLResponse(sResultCode, sResultText, ""));
	return;
}

out.println(ComposeXMLResponse(gcResultCodeSuccess, gcResultTextSuccess, ss));


%>