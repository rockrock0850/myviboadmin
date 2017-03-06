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
String sServiceId = request.getParameter("sid");

Hashtable	ht					= new Hashtable();
String		sResultCode			= gcResultCodeSuccess;
String		sResultText			= gcResultTextSuccess;
String		s[][]				= null;
int			iColCount			= 0;
String		sSQL				= "";
String		sWhere				= "";

String		ss					= "";
int			i					= 0;

iColCount = 10;
sSQL = "select A.ServiceId, A.ServiceName, B.CategoryName, A.Vendor, A.Platform, A.ServiceType, TO_CHAR(EffectDate,'YYYY/MM/DD HH24:MI:SS'), TO_CHAR(ExpireDate,'YYYY/MM/DD HH24:MI:SS')";
sSQL += ", CASE WHEN A.EffectDate<sysdate AND A.ExpireDate>sysdate THEN '1' ELSE '0' END";
sSQL += ", A.SortOrder";
sSQL += " from MV_VASServiceContentService A, MV_VASServiceContentCategory B";
sSQL += " where A.CategoryId=B.CategoryId";
if (notEmpty(sServiceId)) sSQL += " and A.ServiceId='" + sServiceId + "'";
sSQL += " order by A.SortOrder, to_number(A.ServiceId) DESC";

//writeToFile(sSQL);

ht = getDBData(sSQL, iColCount);
sResultCode = ht.get("ResultCode").toString();
sResultText = ht.get("ResultText").toString();

if (sResultCode.equals(gcResultCodeSuccess)){	//有資料
	s = (String[][])ht.get("Data");
	ss = "<items>";
	for (i=0;i<s.length;i++){
		ss += "<item>";
		ss += "<ServiceId>"					+ nullToString(s[i][0], "") + "</ServiceId>";
		ss += "<ServiceName><![CDATA["		+ nullToString(s[i][1], "") + "]]></ServiceName>";
		ss += "<CategoryName><![CDATA["		+ nullToString(s[i][2], "") + "]]></CategoryName>";
		ss += "<Vendor><![CDATA["			+ nullToString(s[i][3], "") + "]]></Vendor>";
		ss += "<Platform>"					+ nullToString(s[i][4], "") + "</Platform>";
		ss += "<ServiceType>"				+ nullToString(s[i][5], "") + "</ServiceType>";
		ss += "<EffectDate>"				+ nullToString(s[i][6], "") + "</EffectDate>";
		ss += "<ExpireDate>"				+ nullToString(s[i][7], "") + "</ExpireDate>";
		ss += "<Status>"					+ nullToString(s[i][8], "") + "</Status>";
		ss += "<SortOrder>"					+ nullToString(s[i][9], "") + "</SortOrder>";
		ss += "</item>";
	}
	ss += "</items>";
}else{
	out.println(ComposeXMLResponse(sResultCode, sResultText, ""));
	return;
}

out.println(ComposeXMLResponse(gcResultCodeSuccess, gcResultTextSuccess, ss));


%>