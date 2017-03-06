<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>

<%@page import="java.sql.*" %>
<%@page import="java.util.Date" %>

<%@ page import="net.sf.json.*" %>
<%@ page import="net.sf.json.xml.XMLSerializer" %>
<%@ page import="org.w3c.dom.*, javax.xml.parsers.*, org.xml.sax.InputSource" %>

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
Hashtable	ht					= new Hashtable();
String		sResultCode			= gcResultCodeSuccess;
String		sResultText			= gcResultTextSuccess;
String		s[][]				= null;
int			iColCount			= 0;
String		sSQL				= "";

String		ss					= "";
int			i					= 0;


	sSQL += "SELECT NAME,SOUTH,WEST,NORTH,EAST,URL,URLA,TYPE,TO_CHAR(A.UPDATETIME,'YYYY/MM/DD HH24:MI:SS') FROM MV_COVERAGE where name ='4G_TW' ORDER BY TYPE";
	
	iColCount = 8 ;
	ht = getDBData(sSQL, iColCount);
	sResultCode = ht.get("ResultCode").toString();
	sResultText = ht.get("ResultText").toString();
	
	 if (sResultCode.equals(gcResultCodeSuccess)){	//有資料
		s = (String[][])ht.get("Data");
		ss = "{";
		ss += " \"return_code\": \""+sResultCode+"\",";
		ss += " \"return_desc\":\" " + sResultText +" \" ," ;
		//ss += " \"coverage\": [" ;
	 	for(i = 0; i < s.length ; i++ ){
	 		
	 		
	 		ss += " \"name\": " + " \" " + nullToString(s[0][0], "") + " \" ";
	 		
	 		
	 		/* ss += "<item>";
	 		ss += "<Name>"					+ nullToString(s[0][0], "") + "</Name>";
			ss += "<South>"					+ nullToString(s[0][1], "") + "</South>";
			ss += "<West>"					+ nullToString(s[0][2], "") + "</West>";
			ss += "<North>"					+ nullToString(s[0][3], "") + "</North>";
			ss += "<East>"					+ nullToString(s[0][4], "") + "</East>";
			ss += "<Url>"					+ nullToString(s[0][5], "") + "</Url>";
			ss += "<Urla>"					+ nullToString(s[0][6], "") + "</Urla>";
			ss += "<Type>"					+ nullToString(s[0][7], "") + "</Type>"; 
			ss += "</item>"; */
	 	}
	 	ss += " ]" ;
	 	ss += "}";
		//out.println(ComposeXMLResponse(gcResultCodeSuccess, gcResultTextSuccess, ss));
	 	out.println(ss);
		
	}else if(sResultCode.equals(gcResultCodeNoDataFound)){
		out.println(ComposeXMLResponse(sResultCode, sResultText, ss ));
	}else{
		ss += "<Sql>"+ sSQL + "</Sql>";
		out.println(ComposeXMLResponse(sResultCode, sResultText, ss ));
	}	//if (sResultCode.equals(gcResultCodeSuccess)){	//成功
		 
	
	
%>