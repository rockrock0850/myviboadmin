<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>

<%@page import="java.util.Date" %>
<%@ page import="java.net.*" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.w3c.dom.*, javax.xml.parsers.*, org.xml.sax.InputSource" %>
<%@ page import="javax.mail.*"%>
<%@ page import="javax.mail.internet.*"%>
<%@ page import="javax.activation.*"%>


<%!


public String findCoverage(){
	Hashtable	ht					= new Hashtable();
	String		sResultCode			= gcResultCodeSuccess;
	String		sResultText			= gcResultTextSuccess;
	String		s[][]				= null;
	int			iColCount			= 0;
	String		sSQL				= "";

	String		ss					= "";
	int			i					= 0;

		//sSQL += "SELECT NAME,SOUTH,WEST,NORTH,EAST,URL,URLA,TYPE,TO_CHAR(UPDATETIME,'YYYY/MM/DD HH24:MI:SS') FROM MV_COVERAGE ORDER BY TYPE";
		sSQL += "SELECT NAME,SOUTH,WEST,NORTH,EAST,URL,URLA,TYPE,(UPDATETIME-to_date('1970-01-01','yyyy-mm-dd'))*24*60*60*1000 FROM MV_COVERAGE ORDER BY TYPE";
		
		
		iColCount = 9 ;
		ht = getDBData(sSQL, iColCount);
		sResultCode = ht.get("ResultCode").toString();
		sResultText = ht.get("ResultText").toString();

		ss = "{";
		ss += " \"return_code\": \""+sResultCode+"\",";
		ss += " \"return_desc\":\" " + sResultText +" \" ," ;
		
		if (sResultCode.equals(gcResultCodeSuccess)){	//有資料
			s = (String[][])ht.get("Data");

			ss += " \"coverage\": [" ;
		 	for(i = 0; i < s.length ; i++ ){
		 		ss += "{" ;	
		 		ss += " \"name\": " + "\"" + nullToString(s[i][0], "") + "\",";
		 		ss += " \"south\": " + nullToString(s[i][1], "") + ",";
		 		ss += " \"west\": " + nullToString(s[i][2], "") + ",";
		 		ss += " \"north\": " + nullToString(s[i][3], "")+ ",";
		 		ss += " \"east\": " + nullToString(s[i][4], "") + ",";
		 		ss += " \"url\": " + "\"" + nullToString(s[i][5], "") + "\",";
		 		ss += " \"urla\": " + "\"" + nullToString(s[i][6], "") + "\",";
		 		ss += " \"type\": " + "\"" + nullToString(s[i][7], "") + "\",";
		 		ss += " \"updatetime\": " + "\"" + s[i][8] + "\"";
		 		ss += "}" ;
		 		if(i < s.length-1){
		 			ss += ",";
		 		}
		 	}
		 	ss += " ]" ;
		}
		 ss += "}";
	return ss;
}
 
	
	
%>