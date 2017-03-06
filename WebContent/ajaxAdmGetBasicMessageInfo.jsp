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
String	sLoginId = (String)session.getAttribute("LoginId");
String	sLoginRole = (String)session.getAttribute("LoginRole");
if (beEmpty(sLoginId) || beEmpty(sLoginRole)){	//未登入
	out.println(ComposeXMLResponse(gcResultCodeNoLoginInfoFound, gcResultTextNoLoginInfoFound, ""));
	return;
}

//if (sLoginRole.equals(gcUserManager)){	//您無權限使用此程式
List<String> rejectList = Arrays.asList(mesGetBasicReject);
if(rejectList.contains(sLoginRole)){
	out.println(ComposeXMLResponse(gcResultCodeNoPriviledge, gcResultTextNoPriviledge, ""));
	return;
}


/*********************開始做事吧*********************/

String sMessageId = request.getParameter("mid");

Hashtable	ht					= new Hashtable();
String		sResultCode			= gcResultCodeSuccess;
String		sResultText			= gcResultTextSuccess;
String		s[][]				= null;
int			iColCount			= 0;
String		sSQL				= "";

String		ss					= "";
int			i					= 0;

if (beEmpty(sMessageId)){	//新訊息，取得新的序號
	iColCount = 1;
	sSQL = "select MV_MessageId.NEXTVAL from dual";
	ht = getDBData(sSQL, iColCount);
	sResultCode = ht.get("ResultCode").toString();
	sResultText = ht.get("ResultText").toString();
	
	if (sResultCode.equals(gcResultCodeSuccess)){	//有資料
		s = (String[][])ht.get("Data");
		if (s.length==1){	//有找到最新的序號
			sMessageId = s[0][0];
		}
	}
	if (beEmpty(sMessageId)){
		out.println(ComposeXMLResponse(gcResultCodeUnknownError, "無法取得新的訊息編號(ID)!", ""));
		return;
	}else{
		ss = "<MessageId>"				+ sMessageId + "</MessageId>";
		ss += "<VersionNo>"				+ "1" + "</VersionNo>";
		ss += "<Status>"				+ "0" + "</Status>";
		ss += "<LastModifiedPerson>"	+ sLoginId + "</LastModifiedPerson>";
		ss += "<LastModifiedDate>"		+ getDateTimeNow(gcDateFormatSlashYMDTime) + "</LastModifiedDate>";
	}
}else{	//既有訊息，取得既有的資料
	iColCount = 25;
	sSQL = "select VersionNo, Status, LastModifiedPerson, TO_CHAR(LastModifiedDate,'YYYY/MM/DD HH24:MI:SS'), Subject, SubjectPic, SubText1, SubText2, BodyText, BodyPic, BodyText2, ShowHomeBanner, ShowRecommand, ShowNewEvent, ShowProgram, ShowPushMessage, TO_CHAR(EffectDate,'YYYY/MM/DD HH24:MI:SS'), TO_CHAR(ExpireDate,'YYYY/MM/DD HH24:MI:SS'), TO_CHAR(EffectDateHome,'YYYY/MM/DD HH24:MI:SS'), TO_CHAR(ExpireDateHome,'YYYY/MM/DD HH24:MI:SS'), TO_CHAR(EffectDateRecommand,'YYYY/MM/DD HH24:MI:SS'), TO_CHAR(ExpireDateRecommand,'YYYY/MM/DD HH24:MI:SS'), LinkURL, ServiceId, ShowSnowLeopard from MV_MessageList";
	sSQL += " where MessageId='" + sMessageId + "'";
	ht = getDBData(sSQL, iColCount);
	sResultCode = ht.get("ResultCode").toString();
	sResultText = ht.get("ResultText").toString();
	//writeToFile(sSQL);
	if (sResultCode.equals(gcResultCodeSuccess)){	//有資料
		s = (String[][])ht.get("Data");
		i = 0;
		ss = "<MessageId>"				+ sMessageId + "</MessageId>";
		ss += "<VersionNo>"				+ nullToString(s[0][i], "") + "</VersionNo>";			i++;
		ss += "<Status>"				+ nullToString(s[0][i], "") + "</Status>";				i++;
		ss += "<LastModifiedPerson>"	+ nullToString(s[0][i], "") + "</LastModifiedPerson>";	i++;
		ss += "<LastModifiedDate>"		+ nullToString(s[0][i], "") + "</LastModifiedDate>";	i++;
		ss += "<Subject><![CDATA["		+ nullToString(s[0][i], "") + "]]></Subject>";				i++;
		ss += "<SubjectPic><![CDATA["	+ nullToString(s[0][i], "") + "]]></SubjectPic>";		i++;
		ss += "<SubText1><![CDATA["		+ nullToString(s[0][i], "") + "]]></SubText1>";			i++;
		ss += "<SubText2><![CDATA["		+ nullToString(s[0][i], "") + "]]></SubText2>";			i++;
		ss += "<BodyText><![CDATA["		+ nullToString(s[0][i], "") + "]]></BodyText>";			i++;
		ss += "<BodyPic><![CDATA["		+ nullToString(s[0][i], "") + "]]></BodyPic>";			i++;
		ss += "<BodyText2><![CDATA["	+ nullToString(s[0][i], "") + "]]></BodyText2>";		i++;
		ss += "<ShowHomeBanner>"		+ nullToString(s[0][i], "") + "</ShowHomeBanner>";		i++;
		ss += "<ShowRecommand>"			+ nullToString(s[0][i], "") + "</ShowRecommand>";		i++;
		ss += "<ShowNewEvent>"			+ nullToString(s[0][i], "") + "</ShowNewEvent>";		i++;
		ss += "<ShowProgram>"			+ nullToString(s[0][i], "") + "</ShowProgram>";			i++;
		ss += "<ShowPushMessage>"		+ nullToString(s[0][i], "") + "</ShowPushMessage>";		i++;
		ss += "<EffectDate>"			+ nullToString(s[0][i], "") + "</EffectDate>";			i++;
		ss += "<ExpireDate>"			+ nullToString(s[0][i], "") + "</ExpireDate>";			i++;
		ss += "<EffectDateHome>"		+ nullToString(s[0][i], "") + "</EffectDateHome>";		i++;
		ss += "<ExpireDateHome>"		+ nullToString(s[0][i], "") + "</ExpireDateHome>";		i++;
		ss += "<EffectDateRecommand>"	+ nullToString(s[0][i], "") + "</EffectDateRecommand>";	i++;
		ss += "<ExpireDateRecommand>"	+ nullToString(s[0][i], "") + "</ExpireDateRecommand>";	i++;
		ss += "<LinkURL><![CDATA["		+ nullToString(s[0][i], "") + "]]></LinkURL>";			i++;
		ss += "<ServiceId>"				+ nullToString(s[0][i], "") + "</ServiceId>";			i++;
		ss += "<ShowSnowLeopard>"		+ nullToString(s[0][i], "") + "</ShowSnowLeopard>";			i++;
	}else{
		out.println(ComposeXMLResponse(gcResultCodeUnknownError, "無法取得此訊息編號(" + sMessageId + ")的資料!", ""));
		return;
	}
}	//if (beEmpty(sMessageId)){	//新訊息，取得新的序號
System.out.println("ajaxAdmGetBasicMessageInfo.jsp ss: " + ss);
ss += "<CurrentUser>" + sLoginId + "</CurrentUser>";	//目前登入的使用者
//writeToFile(ss);
out.println(ComposeXMLResponse(gcResultCodeSuccess, gcResultTextSuccess, ss));


%>