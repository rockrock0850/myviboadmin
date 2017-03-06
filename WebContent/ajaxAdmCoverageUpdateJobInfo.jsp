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

String mapIdx	= nullToString(request.getParameter("mapIdx"), "");  
String type		= nullToString(request.getParameter("type"), "");
String isTemp	= nullToString(request.getParameter("isTemp"), "");
String loginId  = nullToString(request.getParameter("loginId"), "");


if (beEmpty(mapIdx) || beEmpty(type)){
	out.print("傳入之參數不足!");
	return;
}

session.setAttribute("mapIdx", mapIdx);
session.setAttribute("type", type);
session.setAttribute("isTemp", isTemp);
session.setAttribute("loginId", loginId);


out.print("processresult:success"+ isTemp + "," + loginId);
%>