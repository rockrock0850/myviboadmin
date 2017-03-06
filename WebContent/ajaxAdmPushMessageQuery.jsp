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

String sServiceId	= nullToString(request.getParameter("ServiceId"), "");	//服務名稱
String sMSISDN		= nullToString(request.getParameter("MSISDN"), "");
String sDeviceType	= nullToString(request.getParameter("DeviceType"), "");	//裝置類型，B=全部、A=Android、I=iOS
String sStatus		= nullToString(request.getParameter("Status"), "");	//狀態，2=全部、0=未到期、1=已過期


Hashtable	ht					= new Hashtable();
String		sResultCode			= gcResultCodeSuccess;
String		sResultText			= gcResultTextSuccess;
String		s[][]				= null;
int			iColCount			= 0;
String		sSQL				= "";
String		sWhere				= "";

String		ss					= "";
int			i					= 0;

if (notEmpty(sServiceId))	sWhere += " and A.ServiceId='" + sServiceId + "'";

if (beEmpty(sDeviceType))	sDeviceType = "B";
if (notEmpty(sMSISDN)){	//某個門號
	if (sDeviceType.equals("B")){
		sWhere += " and ((A.SendType='1') or (A.SendType='2' and exists (select B.MessageId from MV_PushMessageRecordDetail B where B.MessageId=A.MessageId and B.MSISDN='" + sMSISDN + "')))";
	}else{
		sWhere += " and ((A.SendType='1' and (A.DeviceType='" + sDeviceType + "' or A.DeviceType='B')) or (A.SendType='2' and exists (select B.MessageId from MV_PushMessageRecordDetail B where B.MessageId=A.MessageId and B.MSISDN='" + sMSISDN + "')))";
	}
}else{	//全體用戶
	if (!sDeviceType.equals("B")){	//某種裝置，Android或iOS
		//sWhere += " and ((A.SendType='1' and (A.DeviceType='" + sDeviceType + "' or A.DeviceType='B')) or (A.SendType='2'))";
		sWhere += " and (A.SendType='1' and (A.DeviceType='" + sDeviceType + "' or A.DeviceType='B'))";
	}
}

if (notEmpty(sStatus) && !sStatus.equals("2")){	//只要某種狀態
	if (sStatus.equals("0")){
		sWhere += " and A.ExpiryDate>=sysdate";
	}
	if (sStatus.equals("1")){
		sWhere += " and A.ExpiryDate<sysdate";
	}
}

if (notEmpty(sWhere)) sWhere = sWhere.substring(4);

iColCount = 10;
sSQL = "select A.MessageId, A.ServiceId, A.SendType, A.DeviceType, A.MessageTitle, A.MessageBody, TO_CHAR(A.SendDate,'YYYY/MM/DD HH24:MI:SS'), TO_CHAR(A.ExpiryDate,'YYYY/MM/DD HH24:MI:SS'), A.LoginId";
sSQL += ", CASE WHEN A.ExpiryDate<sysdate THEN '1' ELSE '0' END";
sSQL += " from mv_pushmessagerecordmain A";
if (notEmpty(sWhere)) sSQL += " where" + sWhere;
sSQL += " order by to_number(A.MessageId) DESC";

//writeToFile(sSQL);

ht = getDBData(sSQL, iColCount);
sResultCode = ht.get("ResultCode").toString();
sResultText = ht.get("ResultText").toString();

if (sResultCode.equals(gcResultCodeSuccess)){	//有資料
	s = (String[][])ht.get("Data");
	ss = "<items>";
	for (i=0;i<s.length;i++){
		ss += "<item>";
		ss += "<MessageId>"					+ nullToString(s[i][0], "") + "</MessageId>";
		ss += "<ServiceId>"					+ nullToString(s[i][1], "") + "</ServiceId>";
		ss += "<SendType>"					+ nullToString(s[i][2], "") + "</SendType>";
		ss += "<DeviceType>"				+ nullToString(s[i][3], "") + "</DeviceType>";
		ss += "<MessageTitle><![CDATA["		+ nullToString(s[i][4], "") + "]]></MessageTitle>";
		ss += "<MessageBody><![CDATA["		+ nullToString(s[i][5], "") + "]]></MessageBody>";
		ss += "<SendDate>"					+ nullToString(s[i][6], "") + "</SendDate>";
		ss += "<ExpiryDate>"				+ nullToString(s[i][7], "") + "</ExpiryDate>";
		ss += "<SenderId>"					+ nullToString(s[i][8], "") + "</SenderId>";
		ss += "<Status>"					+ nullToString(s[i][9], "") + "</Status>";
		ss += "</item>";
	}
	ss += "</items>";
}else{
	out.println(ComposeXMLResponse(sResultCode, sResultText, ""));
	return;
}

out.println(ComposeXMLResponse(gcResultCodeSuccess, gcResultTextSuccess, ss));
//out.println(ComposeXMLResponse(gcResultCodeSuccess, "<![CDATA["+sSQL+"]]>", ss));


%>