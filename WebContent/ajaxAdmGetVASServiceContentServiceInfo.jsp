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

/*********************開始做事吧*********************/

String sServiceId = request.getParameter("sid");

Hashtable	ht					= new Hashtable();
String		sResultCode			= gcResultCodeSuccess;
String		sResultText			= gcResultTextSuccess;
String		s[][]				= null;
int			iColCount			= 0;
String		sSQL				= "";

String		ss					= "";
int			i					= 0;

if (beEmpty(sServiceId)){	//新訊息，取得新的序號(與促銷訊息共用MV_MessageId序號檔)
	iColCount = 1;
	sSQL = "select MV_MessageId.NEXTVAL from dual";
	ht = getDBData(sSQL, iColCount);
	sResultCode = ht.get("ResultCode").toString();
	sResultText = ht.get("ResultText").toString();
	
	if (sResultCode.equals(gcResultCodeSuccess)){	//有資料
		s = (String[][])ht.get("Data");
		if (s.length==1){	//有找到最新的序號
			sServiceId = s[0][0];
		}
	}
	if (beEmpty(sServiceId)){
		out.println(ComposeXMLResponse(gcResultCodeUnknownError, "無法取得新的服務代碼(ID)!", ""));
		return;
	}else{
		ss = "<ServiceId>"				+ sServiceId + "</ServiceId>";
	}
}else{	//既有訊息，取得既有的資料
	iColCount = 19;
	sSQL = "select ServiceName, CategoryId, ServiceIcon, ServicePic, ShowBanner, Vendor, ShortDesc, BodyText, BodyText2, LinkURLAndroid, LinkURLiOS, LinkURLWeb, CSRTel, CSRTime, CSREmail, Platform, ServiceType, TO_CHAR(EffectDate,'YYYY/MM/DD HH24:MI:SS'), TO_CHAR(ExpireDate,'YYYY/MM/DD HH24:MI:SS') from MV_VASServiceContentService";
	sSQL += " where ServiceId='" + sServiceId + "'";
	ht = getDBData(sSQL, iColCount);
	sResultCode = ht.get("ResultCode").toString();
	sResultText = ht.get("ResultText").toString();
	//writeToFile(sSQL);
	if (sResultCode.equals(gcResultCodeSuccess)){	//有資料
		s = (String[][])ht.get("Data");
		i = 0;
		ss = "<ServiceId>"					+ sServiceId + "</ServiceId>";
		ss += "<ServiceName><![CDATA["		+ nullToString(s[0][i], "") + "]]></ServiceName>";		i++;
		ss += "<CategoryId><![CDATA["		+ nullToString(s[0][i], "") + "]]></CategoryId>";		i++;
		ss += "<ServiceIcon><![CDATA["		+ nullToString(s[0][i], "") + "]]></ServiceIcon>";		i++;
		ss += "<ServicePic><![CDATA["		+ nullToString(s[0][i], "") + "]]></ServicePic>";		i++;
		ss += "<ShowBanner>"				+ nullToString(s[0][i], "") + "</ShowBanner>";			i++;
		ss += "<Vendor><![CDATA["			+ nullToString(s[0][i], "") + "]]></Vendor>";			i++;
		ss += "<ShortDesc><![CDATA["		+ nullToString(s[0][i], "") + "]]></ShortDesc>";		i++;
		ss += "<BodyText><![CDATA["			+ nullToString(s[0][i], "") + "]]></BodyText>";			i++;
		ss += "<BodyText2><![CDATA["		+ nullToString(s[0][i], "") + "]]></BodyText2>";		i++;
		ss += "<LinkURLAndroid><![CDATA["	+ nullToString(s[0][i], "") + "]]></LinkURLAndroid>";	i++;
		ss += "<LinkURLiOS><![CDATA["		+ nullToString(s[0][i], "") + "]]></LinkURLiOS>";		i++;
		ss += "<LinkURLWeb><![CDATA["		+ nullToString(s[0][i], "") + "]]></LinkURLWeb>";		i++;
		ss += "<CSRTel><![CDATA["			+ nullToString(s[0][i], "") + "]]></CSRTel>";			i++;
		ss += "<CSRTime><![CDATA["			+ nullToString(s[0][i], "") + "]]></CSRTime>";			i++;
		ss += "<CSREmail><![CDATA["			+ nullToString(s[0][i], "") + "]]></CSREmail>";			i++;
		ss += "<Platform>"					+ nullToString(s[0][i], "") + "</Platform>";			i++;
		ss += "<ServiceType>"				+ nullToString(s[0][i], "") + "</ServiceType>";			i++;
		ss += "<EffectDate>"				+ nullToString(s[0][i], "") + "</EffectDate>";			i++;
		ss += "<ExpireDate>"				+ nullToString(s[0][i], "") + "</ExpireDate>";			i++;
	}else{
		out.println(ComposeXMLResponse(gcResultCodeUnknownError, "無法取得此服務代碼(" + sServiceId + ")的資料!", ""));
		return;
	}
}	//if (beEmpty(sServiceId)){	//新訊息，取得新的序號

//writeToFile(ss);
out.println(ComposeXMLResponse(gcResultCodeSuccess, gcResultTextSuccess, ss));


%>