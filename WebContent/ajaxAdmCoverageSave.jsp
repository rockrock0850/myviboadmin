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
String south					= nullToString(request.getParameter("south"), "");  
String west						= nullToString(request.getParameter("west"), "");  
String north					= nullToString(request.getParameter("north"), "");  
String east						= nullToString(request.getParameter("east"), "");  

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
String		iSQL				= "";
String		uSQL				= "";

String		ss					= "";
int			i					= 0;
String urlPath = "myviboadmin_pic/";
String urlValue ;
String urlaValue ;
String extension = ".png";

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
	
	urlValue = urlPath + name + extension;
	urlaValue = urlPath + name + "_a" + extension;
	
	 if (sResultCode.equals(gcResultCodeSuccess)){	//有資料
		//執行update
		uSQL = "UPDATE MV_COVERAGE SET UPDATETIME = CURRENT_DATE , SOUTH = "+ south +", WEST = "+ west ;
		uSQL += ", NORTH = "+ north +", EAST = "+ east ;
		uSQL += ", URL = '" + urlValue + "' , URLA = '" + urlaValue +"' ";
		uSQL += " WHERE NAME = '" + name + "'"; 
		//uSQL = "UPDATE MV_COVERAGE SET SOUTH = 212.860086, WEST = 119.940403, NORTH = 25.391177, EAST = 122.047676 WHERE NAME = '4G_TW';";
		
		ht = execSQLOnDB(uSQL);
		sResultCode = ht.get("ResultCode").toString();
		sResultText = ht.get("ResultText").toString();
		
		if (sResultCode.equals(gcResultCodeSuccess)){	//成功
			out.println(ComposeXMLResponse(gcResultCodeSuccess, gcResultTextSuccess, "1"));
			
		}else{
			out.println(ComposeXMLResponse(sResultCode, sResultText, "2, "+uSQL));
		}
	 }else{
		  	//改為insert
			iSQL = "INSERT INTO MV_COVERAGE(NAME, SOUTH, WEST, NORTH, EAST, URL, URLA, TYPE, UPDATETIME) VALUES (";
			iSQL += "'"+ name +"',";
			iSQL += south + "," + west  + "," + north  + "," + east + ",'" + urlValue +"','"+ urlaValue+"','"+ type +"' , CURRENT_DATE )";
			
			ht = execSQLOnDB(iSQL);
			sResultCode = ht.get("ResultCode").toString();
			sResultText = ht.get("ResultText").toString();
			
			 if (sResultCode.equals(gcResultCodeSuccess)){	//成功
				 out.println(ComposeXMLResponse(gcResultCodeSuccess, gcResultTextSuccess, iSQL));
				
			}else{
				out.println(ComposeXMLResponse(sResultCode, sResultText, "4"));
			}	//if (sResultCode.equals(gcResultCodeSuccess)){	//成功 
				 
			
	 }
	
		
	
	


	
%>