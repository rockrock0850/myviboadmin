<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>

<%@ page import="net.sf.json.*" %>
<%@ page import="net.sf.json.xml.XMLSerializer" %>
<%@include file="00_constants.jsp"%>
<%@include file="00_utility.jsp"%>

<%
request.setCharacterEncoding("utf-8");
response.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=utf-8");
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-cache");
response.setDateHeader("Expires", 0);

out.clear();	//注意，一定要有out.clear();，要不然client端無法解析XML，會認為XML格式有問題

String sFunction	= "";	//BSC API名稱，例如GetPOSItems
String sRequest		= "";    //Request端送來的request字串，sRequest應為<ItemCode></ItemCode><ItemName>HTC</ItemName><QtyFlag>N</QtyFlag>一類的字串
String sResponseType = "";	//希望server端回覆的資料類型，可為 json 或 xml

try{
	//sFunction	= new String(request.getParameter("Function"));
	//sRequest	= new String(URLDecoder.decode(request.getParameter("Request")).getBytes("iso8859-1"),"utf-8");
	sFunction	= request.getParameter("Function");
	sRequest	= request.getParameter("Request");
	sResponseType	= request.getParameter("ResponseType");
}catch(Exception e){
	writeToFile("使用功能失敗:BSCAPIBridge(BSCAPIBridge.jsp):無法取得所需參數!!");
	out.println(ComposeXMLResponse(gcResultCodeUnknownError, "作業失敗，無法取得所需參數!!", ""));
	return;
}

//if (sFunction.length()<1 || sRequest.length()<1){
if (sFunction.length()<1){
	out.println(ComposeXMLResponse(gcResultCodeUnknownError, "作業失敗，請確定必要欄位均有填寫!!", ""));
	return;
}
//writeToFile(sRequest);
/**********************有資料了，開始做事吧*********************************************/
String	sRequestId	= generateRequestId();	//產生呼叫 BSC API 所需的 RequestId
String	sURL		= gcBSCURL + sFunction + ".jsp?xml=";	//BSC API URL
String	sXML		= "";									//呼叫BSC的XML內容
String	sResponse	= "";									//BSC回覆的XML

//組合要送出的XML
sXML = "<BscXmlApi><" + sFunction + "Req><VASId>" + gcVASId + "</VASId><VASPassword>" + gcVASPassword + "</VASPassword><RequestId>" + sRequestId + "</RequestId>";
/************************以下是每個BSC API各自的參數************************/
sXML = sXML + sRequest;
/************************以上是每個BSC API各自的參數************************/
sXML = sXML + "</" + sFunction + "Req></BscXmlApi>";
writeToFile(sXML);
Hashtable htResponse = sendToBSC(sURL, URLEncoder.encode(sXML, "utf-8"));	//呼叫 BSC API

//if (htResponse.get("ResultCode").equals(gcResultCodeSuccess)){	//正常回覆，顯示回覆資料內容
	sResponse = htResponse.get("Response").toString();
//}else{
//	sResponse = ComposeXMLResponse(htResponse.get("ResultCode").toString(), htResponse.get("ResultText").toString(), "");
//}	//if (htResponse.get("ResultCode").equals(gcResultCodeSuccess)){	//正常回覆，顯示回覆資料內容

writeToFile(sResponse);

if (sResponseType.equalsIgnoreCase("json")){
//writeToFile(sResponse);
	JSON json = new XMLSerializer().read( sResponse );
	sResponse = json.toString();
}

//writeToFile(sResponse);
out.println(sResponse);
%>
