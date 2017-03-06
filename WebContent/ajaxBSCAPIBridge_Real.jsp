<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>

<%@ page import="net.sf.json.*" %>
<%@ page import="net.sf.json.xml.XMLSerializer" %>
<%@include file="00_constants.jsp"%>
<%@include file="00_utility.jsp"%>
<%@include file="00_utility_3GAP.jsp"%>

<%
request.setCharacterEncoding("UTF-8");
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
	System.out.println("   ");
	//sFunction	= new String(request.getParameter("Function"));
	//sRequest	= new String(URLDecoder.decode(request.getParameter("Request")).getBytes("iso8859-1"),"utf-8");
	sFunction	= request.getParameter("Function");
	sRequest	= request.getParameter("Request");
	sResponseType	= request.getParameter("ResponseType");
	
	System.out.println("=====================sFunction: " + sFunction);
	System.out.println("=====================sRequest: " + sRequest);
	
}catch(Exception e){
	writeToFile("使用功能失敗:BSCAPIBridge(BSCAPIBridge.jsp):無法取得所需參數!!");
	out.println(ComposeXMLResponse(gcResultCodeUnknownError, "作業失敗，無法取得所需參數!!", ""));
	return;
}

if (beEmpty(sFunction) || 1 > sFunction.length()){
	out.println(ComposeXMLResponse(gcResultCodeUnknownError, "作業失敗，請確定必要欄位均有填寫!!", ""));
	return;
}
/**********************有資料了，開始做事吧*********************************************/
String	sRequestId	= generateRequestId();	//產生呼叫 BSC API 所需的 RequestId
String	sURL		= gcBSCURLNEW + sFunction + ".jsp?xml=";	//BSC API URL
String	sXML		= "";									//呼叫BSC的XML內容
String	sResponse	= "";									//BSC回覆的XML
boolean bSendToBSC	= true;

//組合要送出的XML
sXML = "<BscXmlApi><" + sFunction + "Req><VASId>" + gcVASIdNEW + "</VASId><VASPassword>" + gcVASPasswordNEW + "</VASPassword><RequestId>" + sRequestId + "</RequestId>";
/************************以下是每個BSC API各自的參數************************/
sXML = sXML + sRequest;
/************************以上是每個BSC API各自的參數************************/
sXML = sXML + "</" + sFunction + "Req></BscXmlApi>";
writeToFile(sXML);

System.out.println("=====================sXML:" + sXML);

if (sFunction.equals("DoAuthCheck")){
	sResponse = DoAuthCheck(sXML);	//換成新API，由GetServiceProfile檢查
	bSendToBSC = false;
}

if (sFunction.equals("GetRstDMSStoreAddressId") || sFunction.equals("DoSend2VSP")  || sFunction.equals("GetPromotionAgreementInfo")){	//這兩個放在BSC目錄底下
	sURL = gcBSCURLNEW + "BSC/" + sFunction + ".jsp?xml=";	//BSC API URL
}

System.out.println("=====================sURL: " + sURL);

if (bSendToBSC){	//需要後送至BSC
	Hashtable htResponse = sendToBSC(sURL, URLEncoder.encode(sXML, "utf-8"));	//呼叫 BSC API
	sResponse = htResponse.get("Response").toString();
	
	if(sFunction.equals("GetPromotionAgreementInfo")){
		if("00006".equals(htResponse.get("ResultCode"))){
			sResponse = "<BscXmlApi><GetPromotionAgreementInfoRes><ResultCode>00000</ResultCode><ResultText></ResultText></GetPromotionAgreementInfoRes></BscXmlApi>";
		}
	}
}
writeToFile(sResponse);

//隱藏過長訊息
if (sFunction.equals("GetPromotionAgreementInfo") || sFunction.equals("GetRstDMSStoreAddressId") ){
	System.out.println("resp=================sFunction: " + sFunction);
}else{
	System.out.println("resp=re==============sFunction: " + sFunction + " ===sResponse:" + sResponse);
}

if (notEmpty(sResponseType) && sResponseType.equalsIgnoreCase("json")){
	JSON json = new XMLSerializer().read( sResponse );
	sResponse = json.toString();
}
out.println(sResponse);
%>
