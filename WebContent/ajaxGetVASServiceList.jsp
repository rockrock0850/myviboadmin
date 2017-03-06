<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>

<%@ page import="net.sf.json.*" %>
<%@ page import="net.sf.json.xml.XMLSerializer" %>
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

/*********************開始做事吧*********************/

String	ss			= "";
JSON	json		= null;

Hashtable	ht					= new Hashtable();
String		sResultCode			= gcResultCodeSuccess;
String		sResultText			= gcResultTextSuccess;
String		s[][]				= null;
int			iColCount			= 0;
String		sSQL				= "";
int			i					= 0;
int			j					= 0;

String		sBasicService		= "";	//基本服務
String		sContentCategory	= "";	//服務類別
String		sContentService		= "";	//需露出的服務清單
String		sContentBanner		= "";	//需露出的服務banner圖檔清單

/*****************先找基本服務 MV_VASServiceBasic*******************************/
iColCount = 3;
sSQL = "select ServiceId, ServiceName, LinkURL";
sSQL += " from MV_VASServiceBasic";
sSQL += " order by SortOrder, ServiceId";

ht = getDBData(sSQL, iColCount);
sResultCode = ht.get("ResultCode").toString();
sResultText = ht.get("ResultText").toString();

if (sResultCode.equals(gcResultCodeSuccess)){	//有資料
	s = (String[][])ht.get("Data");
	sBasicService = "<BasicServices>";
	for (i=0;i<s.length;i++){
		sBasicService += "<BasicService>";
		sBasicService += "<ServiceId>"				+ nullToString(s[i][0], "") + "</ServiceId>";
		sBasicService += "<ServiceName><![CDATA["	+ nullToString(s[i][1], "") + "]]></ServiceName>";
		sBasicService += "<LinkURL><![CDATA["		+ nullToString(s[i][2], "") + "]]></LinkURL>";
		sBasicService += "</BasicService>";
	}
	sBasicService += "</BasicServices>";
}else{
	ss = ComposeXMLResponse(sResultCode, sResultText, "");
	json = new XMLSerializer().read( ss );
	out.println(json.toString());
	return;
}


/*****************再找服務類別 MV_VASServiceContentCategory*********************/
iColCount = 5;
sSQL = "select CategoryId, CategoryName, ShortDesc, ParentCategoryId, LinkURL";
sSQL += " from MV_VASServiceContentCategory";
sSQL += " order by SortOrder, CategoryId";

ht = getDBData(sSQL, iColCount);
sResultCode = ht.get("ResultCode").toString();
sResultText = ht.get("ResultText").toString();

if (sResultCode.equals(gcResultCodeSuccess)){	//有資料
	s = (String[][])ht.get("Data");
	sContentCategory = "<ContentCategorys>";
	for (i=0;i<s.length;i++){
		sContentCategory += "<ContentCategory>";
		sContentCategory += "<CategoryId>"					+ nullToString(s[i][0], "") + "</CategoryId>";
		sContentCategory += "<CategoryName><![CDATA["		+ nullToString(s[i][1], "") + "]]></CategoryName>";
		sContentCategory += "<ShortDesc><![CDATA["			+ nullToString(s[i][2], "") + "]]></ShortDesc>";
		sContentCategory += "<ParentCategoryId><![CDATA["	+ nullToString(s[i][3], "") + "]]></ParentCategoryId>";
		sContentCategory += "<LinkURL><![CDATA["			+ nullToString(s[i][4], "") + "]]></LinkURL>";
		sContentCategory += "</ContentCategory>";
	}
	sContentCategory += "</ContentCategorys>";
}else{
	ss = ComposeXMLResponse(sResultCode, sResultText, "");
	json = new XMLSerializer().read( ss );
	out.println(json.toString());
	return;
}


/*****************最後找需露出的服務清單 MV_VASServiceContentService************/
iColCount = 18;
sSQL = "select ServiceId, ServiceName, CategoryId, ServiceIcon, ServicePic, ShowBanner, Vendor, ShortDesc, BodyText, BodyText2, LinkURLAndroid, LinkURLiOS, LinkURLWeb, CSRTel, CSRTime, CSREmail, Platform, ServiceType from MV_VASServiceContentService";
sSQL += " where EffectDate<=sysdate and ExpireDate>=sysdate";
sSQL += " order by SortOrder, to_number(ServiceId) desc";
ht = getDBData(sSQL, iColCount);
sResultCode = ht.get("ResultCode").toString();
sResultText = ht.get("ResultText").toString();

if (sResultCode.equals(gcResultCodeSuccess)){	//有資料
	s = (String[][])ht.get("Data");
	sContentService = "<ContentServices>";
	sContentBanner = "<ContentBanners>";
	for (i=0;i<s.length;i++){
		j = 0;
		sContentService += "<ContentService>";
		sContentService += "<ServiceId>"				+ nullToString(s[i][j], "") + "</ServiceId>";			j++;
		sContentService += "<ServiceName><![CDATA["		+ nullToString(s[i][j], "") + "]]></ServiceName>";		j++;
		sContentService += "<CategoryId><![CDATA["		+ nullToString(s[i][j], "") + "]]></CategoryId>";		j++;
		sContentService += "<ServiceIcon><![CDATA["		+ nullToString(s[i][j], "") + "]]></ServiceIcon>";		j++;
		sContentService += "<ServicePic><![CDATA["		+ nullToString(s[i][j], "") + "]]></ServicePic>";		j++;
		sContentService += "<ShowBanner>"				+ nullToString(s[i][j], "") + "</ShowBanner>";			j++;
		sContentService += "<Vendor><![CDATA["			+ nullToString(s[i][j], "") + "]]></Vendor>";			j++;
		sContentService += "<ShortDesc><![CDATA["		+ nullToString(s[i][j], "") + "]]></ShortDesc>";		j++;
		sContentService += "<BodyText><![CDATA["		+ nullToString(s[i][j], "") + "]]></BodyText>";			j++;
		sContentService += "<BodyText2><![CDATA["		+ nullToString(s[i][j], "") + "]]></BodyText2>";		j++;
		sContentService += "<LinkURLAndroid><![CDATA["	+ nullToString(s[i][j], "") + "]]></LinkURLAndroid>";	j++;
		sContentService += "<LinkURLiOS><![CDATA["		+ nullToString(s[i][j], "") + "]]></LinkURLiOS>";		j++;
		sContentService += "<LinkURLWeb><![CDATA["		+ nullToString(s[i][j], "") + "]]></LinkURLWeb>";		j++;
		sContentService += "<CSRTel><![CDATA["			+ nullToString(s[i][j], "") + "]]></CSRTel>";			j++;
		sContentService += "<CSRTime><![CDATA["			+ nullToString(s[i][j], "") + "]]></CSRTime>";			j++;
		sContentService += "<CSREmail><![CDATA["		+ nullToString(s[i][j], "") + "]]></CSREmail>";			j++;
		sContentService += "<Platform>"					+ nullToString(s[i][j], "") + "</Platform>";			j++;
		sContentService += "<ServiceType>"				+ nullToString(s[i][j], "") + "</ServiceType>";			j++;
		sContentService += "</ContentService>";
		if (notEmpty(s[i][5]) && s[i][5].equals("Y") && notEmpty(s[i][4])){	//需露出 banner，且有banner圖檔
			sContentBanner += "<ContentBanner>";
			sContentBanner += "<ServiceId>"				+ nullToString(s[i][0], "") + "</ServiceId>";
			sContentBanner += "<CategoryId><![CDATA["	+ nullToString(s[i][2], "") + "]]></CategoryId>";
			sContentBanner += "<ServicePic><![CDATA["	+ nullToString(s[i][4], "") + "]]></ServicePic>";
			sContentBanner += "<Platform>"				+ nullToString(s[i][16], "") + "</Platform>";
			sContentBanner += "</ContentBanner>";
		}	//if (notEmpty(s[i][5]) && s[i][5].equals("Y")){	//需露出 banner，且有banner圖檔
	}
	sContentService += "</ContentServices>";
	sContentBanner += "</ContentBanners>";
}else{
	ss = ComposeXMLResponse(sResultCode, sResultText, "");
	json = new XMLSerializer().read( ss );
	out.println(json.toString());
	return;
}

ss = sBasicService + sContentCategory + sContentService + sContentBanner;	//把所有資料加起來回覆給 client 端

//writeToFile(ss);
ss = ComposeXMLResponse(sResultCode, sResultText, ss);
json = new XMLSerializer().read( ss );
//writeToFile(json.toString());
out.println(json.toString());


%>