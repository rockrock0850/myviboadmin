<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>

<%@page import="java.sql.*" %>
<%@page import="java.util.Date" %>
<%@ page import="net.sf.json.*" %>
<%@ page import="net.sf.json.xml.XMLSerializer" %>


<%@include file="00_constants.jsp"%>
<%@include file="00_utility.jsp"%>

<%
request.setCharacterEncoding("utf-8");
response.setContentType("text/html;charset=utf-8");
response.setHeader("Pragma","no-cache"); 
response.setHeader("Cache-Control","no-cache"); 
response.setDateHeader("Expires", 0); 

out.clear();	//注意，一定要有out.clear();，要不然client端無法解析XML，會認為XML格式有問題

/*********************新增GCM/APNS的device至DB中*********************/

/*********************開始做事吧*********************/

String sServiceId		= nullToString(request.getParameter("ServiceId"), "");
String sDeviceType		= nullToString(request.getParameter("DeviceType"), "");
String sMSISDN			= nullToString(request.getParameter("MSISDN"), "");
String sContractId		= nullToString(request.getParameter("ContractId"), "");
String sResponseType	= nullToString(request.getParameter("ResponseType"), "");	//希望server端回覆的資料類型，可為 json 或 xml
String sResponse		= "";	//回覆給呼叫端的字串

if (beEmpty(sServiceId) || beEmpty(sDeviceType) || (beEmpty(sMSISDN) && beEmpty(sContractId))){	//MSISDN及ContractId不可皆為空值
	sResponse = ComposeXMLResponse(gcResultCodeParametersNotEnough, gcResultTextParametersNotEnough, "");
	if (sResponseType.equalsIgnoreCase("json")){
		net.sf.json.JSON json = new XMLSerializer().read( sResponse );
		sResponse = json.toString();
	}
	out.println(sResponse);
	return;
}

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

if (notEmpty(sMSISDN) && beEmpty(sContractId)){	//某個門號
	if (sDeviceType.equals("B")){
		sWhere += " and ((A.SendType='1') or (A.SendType='2' and exists (select B.MessageId from MV_PushMessageRecordDetail B where B.MessageId=A.MessageId and B.MSISDN='" + sMSISDN + "')))";
	}else{
		sWhere += " and ((A.SendType='1' and (A.DeviceType='" + sDeviceType + "' or A.DeviceType='B')) or (A.SendType='2' and exists (select B.MessageId from MV_PushMessageRecordDetail B where B.MessageId=A.MessageId and B.MSISDN='" + sMSISDN + "')))";
	}
}else if (beEmpty(sMSISDN) && notEmpty(sContractId)){	//某個ContractId
	if (sDeviceType.equals("B")){
		sWhere += " and ((A.SendType='1') or (A.SendType='2' and exists (select B.MessageId from MV_PushMessageRecordDetail B where B.MessageId=A.MessageId and B.ContractId='" + sContractId + "')))";
	}else{
		sWhere += " and ((A.SendType='1' and (A.DeviceType='" + sDeviceType + "' or A.DeviceType='B')) or (A.SendType='2' and exists (select B.MessageId from MV_PushMessageRecordDetail B where B.MessageId=A.MessageId and B.MSISDN='" + sMSISDN + "')))";
	}
}else if (notEmpty(sMSISDN) && notEmpty(sContractId)){	//某個門號及ContractId
	if (sDeviceType.equals("B")){
		sWhere += " and ((A.SendType='1') or (A.SendType='2' and exists (select B.MessageId from MV_PushMessageRecordDetail B where B.MessageId=A.MessageId and B.MSISDN='" + sMSISDN + "' and B.ContractId='" + sContractId + "')))";
	}else{
		sWhere += " and ((A.SendType='1' and (A.DeviceType='" + sDeviceType + "' or A.DeviceType='B')) or (A.SendType='2' and exists (select B.MessageId from MV_PushMessageRecordDetail B where B.MessageId=A.MessageId and B.MSISDN='" + sMSISDN + "')))";
	}
}else{	//全體用戶
	if (!sDeviceType.equals("B")){	//某種裝置，Android或iOS
		//sWhere += " and ((A.SendType='1' and (A.DeviceType='" + sDeviceType + "' or A.DeviceType='B')) or (A.SendType='2'))";
		sWhere += " and (A.SendType='1' and (A.DeviceType='" + sDeviceType + "' or A.DeviceType='B'))";
	}
}

sWhere += " and A.ExpiryDate>sysdate";	//只找未到期的資料

//看DB中有沒有資料
if (notEmpty(sWhere)) sWhere = sWhere.substring(4);

iColCount = 3;
sSQL = "select A.MessageTitle, A.MessageBody, TO_CHAR(SendDate,'MM/DD')";
sSQL += " from mv_pushmessagerecordmain A";
if (notEmpty(sWhere)) sSQL += " where" + sWhere;
sSQL += " order by to_number(A.MessageId) DESC";

ht = getDBData(sSQL, iColCount);
sResultCode = ht.get("ResultCode").toString();
sResultText = ht.get("ResultText").toString();

if (sResultCode.equals(gcResultCodeSuccess)){	//有資料
	s = (String[][])ht.get("Data");
	ss = "<items>";
	for (i=0;i<s.length;i++){
		ss += "<item>";
		ss += "<MessageTitle><![CDATA["		+ nullToString(s[i][0], "") + "]]></MessageTitle>";
		ss += "<MessageBody><![CDATA["		+ nullToString(s[i][1], "") + "]]></MessageBody>";
		ss += "<SendDate>"					+ nullToString(s[i][2], "") + "</SendDate>";
		
		ss += "</item>";
	}
	ss += "</items>";
	sResponse = ComposeXMLResponse(gcResultCodeSuccess, gcResultTextSuccess, ss);
}else{
	writeToFile("使用功能失敗:取得某用戶的推播通知訊息清單(ajaxPushMessageGetMessage.jsp):" + sResultCode + ":" + sResultText);
	sResponse = ComposeXMLResponse(sResultCode, sResultText, "");
}

//writeToFile(sSQL);
//writeToFile(sResponse);

//out.println(ComposeXMLResponse(gcResultCodeSuccess, "<![CDATA["+sSQL+"]]>", ss));

if (sResponseType.equalsIgnoreCase("json")){
	net.sf.json.JSON json = new XMLSerializer().read( sResponse );
	sResponse = json.toString();
}
out.println(sResponse);

%>