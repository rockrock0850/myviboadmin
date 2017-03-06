<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>

<%@ page import="net.sf.json.*" %>
<%@ page import="net.sf.json.xml.XMLSerializer" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="org.apache.commons.io.IOUtils" %>

<%@include file="00_constants.jsp"%>
<%@include file="00_utility.jsp"%>

<%
request.setCharacterEncoding("utf-8");
response.setContentType("text/html;charset=utf-8");
response.setHeader("Pragma","no-cache"); 
response.setHeader("Cache-Control","no-cache"); 
response.setDateHeader("Expires", 0); 

out.clear();	//注意，一定要有out.clear();，要不然client端無法解析XML，會認為XML格式有問題

/*********************開始做事吧*********************/
System.out.println("ajaxGetAdMessageList.jsp========");
String	sType		= "";
String	sServiceId	= "";
String	sMessageId	= "";
String	ss			= "";
JSON	json		= null;


sType		= request.getParameter("type");	//訊息類型：HomeBanner=首頁圖檔、Recommand=熱門推薦圖檔、NewEvent=最新活動、Program=優惠方案、NewEventBanner=最新活動banner、ProgramBanner=優惠方案banner、PushMessage=訊息提醒
sServiceId	= request.getParameter("sid");	//服務ID：myvibo
sMessageId	= request.getParameter("mid");	//MessageId訊息編號，若有輸入則只撈出此編號的訊息
// if (beEmpty(sType)){
// 	ss = ComposeXMLResponse(gcResultCodeParametersNotEnough, gcResultTextParametersNotEnough, "");
// 	json = new XMLSerializer().read( ss );
// 	out.println(json.toString());
// 	return;
// }

if (beEmpty(sServiceId)) sServiceId = "mytstar";	//預設是MyVIBO APP，因為舊版MyVIBO APP不會帶這個參數
//writeToFile(sType);
/*
Hashtable	ht					= new Hashtable();
String		sResultCode			= gcResultCodeSuccess;
String		sResultText			= gcResultTextSuccess;
String		s[][]				= null;
int			iColCount			= 0;
String		sSQL				= "";
int			i					= 0;
int			j					= 0;


iColCount = 11;
//sSQL = "select MessageId, LastModifiedPerson, TO_CHAR(LastModifiedDate,'YYYY/MM/DD HH24:MI:SS'), Subject, SubjectPic, SubText1, SubText2, SubText3, BodyText, BodyPic, BodyText2, ShowHomeBanner, ShowRecommand, ShowNewEvent, ShowProgram, ShowPushMessage, TO_CHAR(EffectDate,'YYYY/MM/DD HH24:MI:SS'), TO_CHAR(ExpireDate,'YYYY/MM/DD HH24:MI:SS'), TO_CHAR(EffectDateHome,'YYYY/MM/DD HH24:MI:SS'), TO_CHAR(ExpireDateHome,'YYYY/MM/DD HH24:MI:SS'), TO_CHAR(EffectDateRecommand,'YYYY/MM/DD HH24:MI:SS'), TO_CHAR(ExpireDateRecommand,'YYYY/MM/DD HH24:MI:SS') from MV_MessageList";
sSQL = "select MessageId, Subject, SubjectPic, SubText1, SubText2, BodyText, BodyPic, BodyText2, LinkURL, ShowNewEvent, ShowProgram from MV_MessageList";
sSQL += " where EffectDate<=sysdate and ExpireDate>=sysdate";
sSQL += " and status='1'";
if (sType.equalsIgnoreCase("HomeBanner")){
	sSQL += " and ShowHomeBanner='Y' and (EffectDateHome is null or EffectDateHome<=sysdate) and (ExpireDateHome is null or ExpireDateHome>=sysdate)";
}
if (sType.equalsIgnoreCase("Recommand")){
	sSQL += " and ShowRecommand='Y' and (EffectDateRecommand is null  or EffectDateRecommand<=sysdate) and (ExpireDateRecommand is null or ExpireDateRecommand>=sysdate)";
}
if (sType.equalsIgnoreCase("NewEventBanner")){
	sSQL += " and ShowRecommand='Y' and (EffectDateRecommand is null  or EffectDateRecommand<=sysdate) and (ExpireDateRecommand is null or ExpireDateRecommand>=sysdate)";
	sSQL += " and ShowNewEvent='Y'";
}
if (sType.equalsIgnoreCase("ProgramBanner")){
	sSQL += " and ShowRecommand='Y' and (EffectDateRecommand is null  or EffectDateRecommand<=sysdate) and (ExpireDateRecommand is null or ExpireDateRecommand>=sysdate)";
	sSQL += " and ShowProgram='Y'";
}
if (sType.equalsIgnoreCase("NewEvent")){
	sSQL += " and ShowNewEvent='Y'";
}
if (sType.equalsIgnoreCase("Program")){
	sSQL += " and ShowProgram='Y'";
}
if (sType.equalsIgnoreCase("PushMessage")){
	sSQL += " and ShowPushMessage='Y'";
}
if (notEmpty(sServiceId)){
	sSQL += " and ServiceId='" + sServiceId + "'";
}
if (notEmpty(sMessageId)){
	sSQL += " and MessageId='" + sMessageId + "'";
}

//sSQL += " order by to_number(MessageId) desc";
sSQL += " order by SortOrder, to_number(MessageId) desc";

ht = getDBData(sSQL, iColCount);
sResultCode = ht.get("ResultCode").toString();
sResultText = ht.get("ResultText").toString();
//writeToFile(sSQL);
if (sResultCode.equals(gcResultCodeSuccess)){	//有資料
	s = (String[][])ht.get("Data");
	ss = "<items>";
	for (i=0;i<s.length;i++){
		j = 0;
		ss += "<item>";
		ss += "<MessageId>"				+ nullToString(s[i][j], "") + "</MessageId>";		j++;
		ss += "<Subject><![CDATA["		+ nullToString(s[i][j], "") + "]]></Subject>";		j++;
		ss += "<SubjectPic><![CDATA["	+ nullToString(s[i][j], "") + "]]></SubjectPic>";	j++;
		ss += "<SubText1><![CDATA["		+ nullToString(s[i][j], "") + "]]></SubText1>";		j++;
		ss += "<SubText2><![CDATA["		+ nullToString(s[i][j], "") + "]]></SubText2>";		j++;
		ss += "<BodyText><![CDATA["		+ nullToString(s[i][j], "") + "]]></BodyText>";		j++;
		ss += "<BodyPic><![CDATA["		+ nullToString(s[i][j], "") + "]]></BodyPic>";		j++;
		ss += "<BodyText2><![CDATA["	+ nullToString(s[i][j], "") + "]]></BodyText2>";	j++;
		ss += "<LinkURL><![CDATA["		+ nullToString(s[i][j], "") + "]]></LinkURL>";		j++;
		ss += "<ShowNewEvent><![CDATA["	+ nullToString(s[i][j], "") + "]]></ShowNewEvent>";	j++;
		ss += "<ShowProgram><![CDATA["	+ nullToString(s[i][j], "") + "]]></ShowProgram>";
		ss += "</item>";
	}
	ss += "</items>";
}else{
	ss = ComposeXMLResponse(sResultCode, sResultText, "");
	json = new XMLSerializer().read( ss );
	out.println(json.toString());
	return;
}
//writeToFile(ss);
ss = ComposeXMLResponse(sResultCode, sResultText, ss);
json = new XMLSerializer().read( ss );
//writeToFile(json.toString());
*/
try {
	String path = getServletContext().getRealPath("/") + "data/json_20140828.js";
	File f = new File( path);
	System.out.println(f.getAbsolutePath());
	System.out.println(getServletContext().getRealPath("/"));
	InputStream is = new FileInputStream(f);
	String jsonTxt = IOUtils.toString( is );
	json = (JSONObject) JSONSerializer.toJSON( jsonTxt );        
	System.out.println(json.toString());
} catch (Exception e) {
	// TODO Auto-generated catch block
	e.printStackTrace();
}

out.println(json.toString());


%>