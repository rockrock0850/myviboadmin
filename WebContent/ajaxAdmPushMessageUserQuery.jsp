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
String sDeviceType	= nullToString(request.getParameter("DeviceType"), "");	//裝置類型，空白=全部、A=Android、I=iOS
String sMSISDN		= nullToString(request.getParameter("MSISDN"), "");		//門號
String sContractId	= nullToString(request.getParameter("ContractId"), "");	//合約編號


Hashtable	ht					= new Hashtable();
String		sResultCode			= gcResultCodeSuccess;
String		sResultText			= gcResultTextSuccess;
String		s[][]				= null;
int			iColCount			= 0;
String		sSQL				= "";
String		sWhere				= "";

String		ss					= "";
int			i					= 0;

if (notEmpty(sServiceId))	sWhere += " and ServiceId='" + sServiceId + "'";
if (notEmpty(sDeviceType))	sWhere += " and DeviceType='" + sDeviceType + "'";
if (notEmpty(sMSISDN))		sWhere += " and MSISDN='" + sMSISDN + "'";
if (notEmpty(sContractId))	sWhere += " and ContractId='" + sContractId + "'";

if (notEmpty(sWhere)) sWhere = sWhere.substring(4);

iColCount = 7;
sSQL = "select ServiceId, DeviceId, DeviceType, MSISDN, ContractId, TO_CHAR(RegisterDate,'YYYY/MM/DD HH24:MI:SS'), AllowSend";
sSQL += " from MV_PushMessageUsers";
if (notEmpty(sWhere)) sSQL += " where" + sWhere;
sSQL += " order by MSISDN";

//writeToFile(sSQL);

ht = getDBData(sSQL, iColCount);
sResultCode = ht.get("ResultCode").toString();
sResultText = ht.get("ResultText").toString();

if (sResultCode.equals(gcResultCodeSuccess)){	//有資料
	s = (String[][])ht.get("Data");
	ss = "<items>";
	for (i=0;i<s.length;i++){
		ss += "<item>";
		ss += "<ServiceId>"		+ nullToString(s[i][0], "") + "</ServiceId>";
		ss += "<DeviceId>"		+ nullToString(s[i][1], "") + "</DeviceId>";
		ss += "<DeviceType>"	+ nullToString(s[i][2], "") + "</DeviceType>";
		ss += "<MSISDN>"		+ nullToString(s[i][3], "") + "</MSISDN>";
		ss += "<ContractId>"	+ nullToString(s[i][4], "") + "</ContractId>";
		ss += "<RegisterDate>"	+ nullToString(s[i][5], "") + "</RegisterDate>";
		ss += "<AllowSend>"		+ nullToString(s[i][6], "") + "</AllowSend>";
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