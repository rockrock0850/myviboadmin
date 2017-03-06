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
/* String	sLoginId=(String)session.getAttribute("LoginId");
String	sLoginRole=(String)session.getAttribute("LoginRole");
if (beEmpty(sLoginId)||beEmpty(sLoginRole)){	//未登入
	out.println(ComposeXMLResponse(gcResultCodeNoLoginInfoFound,gcResultTextNoLoginInfoFound,""));
	return;
} */

/*********************開始做事吧*********************/
String mapIdx					= nullToString(request.getParameter("mapIdx"), "");  
String type						= nullToString(request.getParameter("type"), "");  

if (beEmpty(mapIdx) || beEmpty(type) ){
	out.println(ComposeXMLResponse(gcResultCodeParametersNotEnough, gcResultTextParametersNotEnough, ""));
	return;
}

Hashtable	ht					= new Hashtable();
String		sResultCode			= gcResultCodeSuccess;
String		sResultText			= gcResultTextSuccess;
String		s[][]				= null;
int			iColCount			= 0;
String		sSQL				= "";

String		ss					= "";
int			i					= 0;

String name = "";
name += type;
switch(Integer.parseInt(mapIdx)){
case 0:
	//TW
	name += "_TW";
	break;
case 1:
	//KM
	name += "_KM";
	break;
case 2:
	//MJ
	name += "_MJ";
	break;
case 3:
	//PH
	name += "_PH";
	break;
default:
	out.println(ComposeXMLResponse(gcResultCodeParametersValidationError, gcResultTextParametersValidationError, ""));
	return;
}

	sSQL += "SELECT * FROM MV_COVERAGE WHERE NAME = '" + name +"'";
	
	iColCount = 8 ;
	ht = getDBData(sSQL, iColCount);
	sResultCode = ht.get("ResultCode").toString();
	sResultText = ht.get("ResultText").toString();
	
	 if (sResultCode.equals(gcResultCodeSuccess)){	//有資料
		s = (String[][])ht.get("Data");
		ss += "<Name>"					+ nullToString(s[0][0], "") + "</Name>";
		ss += "<South>"					+ nullToString(s[0][1], "") + "</South>";
		ss += "<West>"					+ nullToString(s[0][2], "") + "</West>";
		ss += "<North>"					+ nullToString(s[0][3], "") + "</North>";
		ss += "<East>"					+ nullToString(s[0][4], "") + "</East>";
		ss += "<Url>"					+ nullToString(s[0][5], "") + "</Url>";
		ss += "<Urla>"					+ nullToString(s[0][6], "") + "</Urla>";
		ss += "<Type>"					+ nullToString(s[0][7], "") + "</Type>"; 
		out.println(ComposeXMLResponse(gcResultCodeSuccess, gcResultTextSuccess, ss));
	}else if(sResultCode.equals(gcResultCodeNoDataFound)){
		ss += "<Name>"+ name + "</Name>";
		out.println(ComposeXMLResponse(sResultCode, sResultText, ss ));
	}else{
		ss += "<Name>"+ name + "</Name>";
		ss += "<Sql>"+ sSQL + "</Sql>";
		out.println(ComposeXMLResponse(sResultCode, sResultText, ss ));
	}	//if (sResultCode.equals(gcResultCodeSuccess)){	//成功
		 
	
	
%>