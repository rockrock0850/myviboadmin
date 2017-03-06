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

String sJobType			= nullToString(request.getParameter("jobType"), "");                              
String sServiceId		=nullToString(request.getParameter("ServiceId"), "");
String sServiceName		=nullToString(request.getParameter("ServiceName"), "");
String sCategoryId		=nullToString(request.getParameter("CategoryId"), "");
String sServiceIcon		=nullToString(request.getParameter("ServiceIcon"), "");
String sServicePic		=nullToString(request.getParameter("ServicePic"), "");
String sShowBanner		=nullToString(request.getParameter("ShowBanner"), "");
String sVendor			=nullToString(request.getParameter("Vendor"), "");
String sShortDesc		=nullToString(request.getParameter("ShortDesc"), "");
String sBodyText		=nullToString(request.getParameter("BodyText"), "");
String sBodyText2		=nullToString(request.getParameter("BodyText2"), "");
String sLinkURLAndroid	=nullToString(request.getParameter("LinkURLAndroid"), "");
String sLinkURLiOS		=nullToString(request.getParameter("LinkURLiOS"), "");
String sLinkURLWeb		=nullToString(request.getParameter("LinkURLWeb"), "");
String sCSRTel			=nullToString(request.getParameter("CSRTel"), "");
String sCSRTime			=nullToString(request.getParameter("CSRTime"), "");
String sCSREmail		=nullToString(request.getParameter("CSREmail"), "");
String sPlatform		=nullToString(request.getParameter("Platform"), "");
String sServiceType		=nullToString(request.getParameter("ServiceType"), "");
String sEffectDate		=nullToString(request.getParameter("EffectDate"), "");
String sExpireDate		=nullToString(request.getParameter("ExpireDate"), "");

if (beEmpty(sServiceId) || beEmpty(sJobType) || !(sJobType.equals("a")||sJobType.equals("e")) || beEmpty(sServiceId)){
	out.println(ComposeXMLResponse(gcResultCodeParametersNotEnough, gcResultTextParametersNotEnough, ""));
	return;
}

sServiceName	= sServiceName.replace("'", "''");		//處理Oracle的單引號
sVendor			= sVendor.replace("'", "''");			//處理Oracle的單引號
sShortDesc		= sShortDesc.replace("'", "''");			//處理Oracle的單引號
sBodyText		= sBodyText.replace("'", "''");			//處理Oracle的單引號
sBodyText2		= sBodyText2.replace("'", "''");			//處理Oracle的單引號
sLinkURLAndroid	= sLinkURLAndroid.replace("'", "''");	//處理Oracle的單引號
sLinkURLiOS		= sLinkURLiOS.replace("'", "''");		//處理Oracle的單引號
sLinkURLWeb		= sLinkURLWeb.replace("'", "''");		//處理Oracle的單引號

if (notEmpty(sShowBanner) && sShowBanner.equals("on"))		sShowBanner = "Y";	else sShowBanner	= "N";

Hashtable	ht					= new Hashtable();
String		sResultCode			= gcResultCodeSuccess;
String		sResultText			= gcResultTextSuccess;
String		s[][]				= null;
int			iColCount			= 0;
String		sSQL				= "";

String		ss					= "";
int			i					= 0;

if (sJobType.equals("a")){	//新增訊息

	sSQL = "insert into MV_VASServiceContentService (ServiceId, ServiceName, CategoryId, ServiceIcon, ServicePic, ShowBanner, Vendor, ShortDesc, BodyText, BodyText2, LinkURLAndroid, LinkURLiOS, LinkURLWeb, CSRTel, CSRTime, CSREmail, Platform, ServiceType, EffectDate, ExpireDate, SortOrder)";
	sSQL += " values (";
	sSQL += " '" +    sServiceId			+ "'";
	sSQL += ", '" +    sServiceName			+ "'";
	sSQL += ", '" +    sCategoryId			+ "'";
	sSQL += ", '" +    sServiceIcon			+ "'";
	sSQL += ", '" +    sServicePic			+ "'";
	sSQL += ", '" +    sShowBanner			+ "'";
	sSQL += ", '" +    sVendor				+ "'";
	sSQL += ", '" +    sShortDesc			+ "'";
	sSQL += ", '" +    sBodyText			+ "'";
	sSQL += ", '" +    sBodyText2			+ "'";
	sSQL += ", '" +    sLinkURLAndroid		+ "'";
	sSQL += ", '" +    sLinkURLiOS			+ "'";
	sSQL += ", '" +    sLinkURLWeb			+ "'";
	sSQL += ", '" +    sCSRTel			    + "'";
	sSQL += ", '" +    sCSRTime			    + "'";
	sSQL += ", '" +    sCSREmail			+ "'";
	sSQL += ", '" +    sPlatform			+ "'";
	sSQL += ", '" +    sServiceType			+ "'";
	sSQL += ", " +   "TO_DATE('" + sEffectDate + "','YYYY/MM/DD HH24:MI:SS')";
	sSQL += ", " +   "TO_DATE('" + sExpireDate + "','YYYY/MM/DD HH24:MI:SS')";
	sSQL += ", " +	  "0";
	sSQL += " )";
}

String sServiceIconOld	= "";
String sServicePicOld		= "";

if (sJobType.equals("e")){	//修改訊息
	//先取得原始資料中的圖檔資訊
	iColCount = 2;
	sSQL = "select ServiceIcon, ServicePic from MV_VASServiceContentService where ServiceId='" + sServiceId + "'";
	
	ht = getDBData(sSQL, iColCount);
	sResultCode = ht.get("ResultCode").toString();
	sResultText = ht.get("ResultText").toString();
	
	if (sResultCode.equals(gcResultCodeSuccess)){	//有資料
		s = (String[][])ht.get("Data");
		sServiceIconOld = s[0][0];
		sServicePicOld = s[0][1];
	}else{
		out.println(ComposeXMLResponse(sResultCode, sResultText, ""));
		return;
	}
	
	if (notEmpty(sServiceIconOld)){
		i = sServiceIconOld.lastIndexOf(".");
		sServiceIconOld = gcBasePathForFileUpload + sServiceId + "-1" + sServiceIconOld.substring(i);
	}
	if (notEmpty(sServicePicOld)){
		i = sServicePicOld.lastIndexOf(".");
		sServicePicOld = gcBasePathForFileUpload + sServiceId + "-2" + sServicePicOld.substring(i);
	}

	//更新資料
	sSQL = "update MV_VASServiceContentService";
	sSQL += " set";
	sSQL += " ServiceName='"		+	sServiceName				+ "'";
	sSQL += ", CategoryId='"		+	sCategoryId					+ "'";
	sSQL += ", ServiceIcon='"		+	sServiceIcon				+ "'";
	sSQL += ", ServicePic='"		+	sServicePic					+ "'";
	sSQL += ", ShowBanner='"		+	sShowBanner					+ "'";
	sSQL += ", Vendor='"			+	sVendor						+ "'";
	sSQL += ", ShortDesc='"			+	sShortDesc					+ "'";
	sSQL += ", BodyText='"			+	sBodyText					+ "'";
	sSQL += ", BodyText2='"			+	sBodyText2					+ "'";
	sSQL += ", LinkURLAndroid='"	+	sLinkURLAndroid				+ "'";
	sSQL += ", LinkURLiOS='"		+	sLinkURLiOS					+ "'";
	sSQL += ", LinkURLWeb='"		+	sLinkURLWeb					+ "'";
	sSQL += ", CSRTel='"			+	sCSRTel						+ "'";
	sSQL += ", CSRTime='"			+	sCSRTime					+ "'";
	sSQL += ", CSREmail='"			+	sCSREmail					+ "'";
	sSQL += ", Platform='"			+	sPlatform					+ "'";
	sSQL += ", ServiceType='"		+	sServiceType				+ "'";
	sSQL += ", EffectDate="			+   "TO_DATE('" + sEffectDate + "','YYYY/MM/DD HH24:MI:SS')";
	sSQL += ", ExpireDate="			+   "TO_DATE('" + sExpireDate + "','YYYY/MM/DD HH24:MI:SS')";
	sSQL += " where ServiceId='" + sServiceId + "'";
}

if (notEmpty(sSQL)){
	ht = execSQLOnDB(sSQL);
	sResultCode = ht.get("ResultCode").toString();
	sResultText = ht.get("ResultText").toString();
	
	if (sResultCode.equals(gcResultCodeSuccess)){	//成功
		if (sJobType.equals("e")){	//修改訊息，若之前有圖檔而現在沒圖檔，則將原圖檔刪除
			if (beEmpty(sServiceIcon) && notEmpty(sServiceIconOld)){
				DeleteFile(sServiceIconOld);
			}
			if (beEmpty(sServicePic) && notEmpty(sServicePicOld)){
				DeleteFile(sServicePicOld);
			}
		}	//if (sJobType.equals("e")){	//修改訊息，若之前有圖檔而現在沒圖檔，則將原圖檔刪除
		out.println(ComposeXMLResponse(gcResultCodeSuccess, gcResultTextSuccess, ""));
	}else{
		out.println(ComposeXMLResponse(sResultCode, sResultText, ""));
	}	//if (sResultCode.equals(gcResultCodeSuccess)){	//成功
}	//if (notEmpty(sSQL)){


%>