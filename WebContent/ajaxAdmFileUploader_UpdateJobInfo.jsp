<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>


<%@ page import="java.net.*" %>

<%@include file="00_constants.jsp"%>
<%@include file="00_utility.jsp"%>

<%
request.setCharacterEncoding("utf-8");
response.setContentType("text/html;charset=utf-8");
response.setHeader("Pragma","no-cache"); 
response.setHeader("Cache-Control","no-cache"); 
response.setDateHeader("Expires", 0); 

String sMessageId = "";	//訊息編號
String sPicIndex = "";	//上傳檔案為第幾張圖
sMessageId	= request.getParameter("txtMessageId");
sPicIndex	= request.getParameter("txtPicIndex");

if (beEmpty(sMessageId) || beEmpty(sPicIndex)){
	out.print("無法取得您上傳的訊息編號或圖片索引，請重新選擇圖片再上傳檔案!!");
	return;
}

session.setAttribute("FileUploader_MessageId", sMessageId);
session.setAttribute("FileUploader_PicIndex", sPicIndex);
out.print("processresult:success");
%>