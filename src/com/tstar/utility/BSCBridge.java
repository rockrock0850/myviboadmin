package com.tstar.utility;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Hashtable;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

public class BSCBridge {
	// 呼叫 BSC API
	public Hashtable sendToBSC(String sURL, String sXML) {
		/************************************
		 * sURL：BSC API網址，例如：http://172.24.129.111:8080/BSC/GetPOSItems.jsp?xml=
		 * sXML：傳給 BSC API 的 XML
		 * 內容，例如：<BscXmlApi><GetPOSItemsReq><VASId>abc</VASId
		 * ><VASPassword>123</VASPassword
		 * ><RequestId>20120206-141330-8799-1</RequestId
		 * ><ItemCode></ItemCode><ItemName
		 * >HTC</ItemName><QtyFlag>N</QtyFlag></GetPOSItemsReq></BscXmlApi>
		 *************************************/

		Hashtable htResponse = new Hashtable(); // 儲存回覆資料的 hash table
		String sRequest = ""; // 要送HTTP GET給 BSC 的內容，含URL及XML

		String s = "";
		int i;
		// String s2 = "";
		// s2 = new String(sXML.getBytes(), "utf-8");

		// sRequest = sURL + URLEncoder.encode(sXML, "utf-8");

		// sRequest = sURL +
		// URLEncoder.encode(sXML.getBytes("utf-8").toString());
		sRequest = sURL + sXML;

		try {
			URL u;
			u = new URL(sRequest);
			HttpURLConnection uc = (HttpURLConnection) u.openConnection();

			uc.setRequestMethod("GET");
			uc.setDoOutput(true);
			uc.setDoInput(true);

			InputStream in = uc.getInputStream();
			BufferedReader r = new BufferedReader(new InputStreamReader(in,
					"utf-8"));
			StringBuffer buf = new StringBuffer();
			String line;
			while ((line = r.readLine()) != null) {
				buf.append(line);
			}
			in.close();

			s = buf.toString();
			s = s.trim().replaceFirst("^([\\W]+)<", "<"); // 將XML開頭之前的雜亂字元移除，否則可能有【org.xml.sax.SAXParseException:
															// Content is not
															// allowed in
															// prolog】的error，參考【http://mark.koli.ch/2009/02/resolving-orgxmlsaxsaxparseexception-content-is-not-allowed-in-prolog.html】
			s = s.replace("&", "and"); // 不做replace的話，若XML中有"&"則會造成parsing
										// error:org.xml.sax.SAXParseException:
										// The entity name must immediately
										// follow the '&' in the entity
										// reference.

			htResponse.put("Request", sRequest); // 傳給BSC的HTTP GET (其中XML已被HTTP
													// URL encoded)
			htResponse.put("Response", s); // BSC回應的XML

			if (s.indexOf("<ResultCode>") > 0 && s.indexOf("</ResultCode>") > 0) { // BSC有回應ResultCode
				htResponse
						.put("ResultCode", GetXMLSingleValue(s, "ResultCode")); // BSC回應的ResultCode
			} else {
				htResponse.put("ResultCode", "99999"); // 無法取得BSC回應的ResultCode，自行設為99999
//				writeToFile("sendToBSC發生錯誤：\nXML=" + sXML + "\nBSC回應=" + s);
			} // if (s.indexOf("<ResultCode>")>0 &&
				// s.indexOf("</ResultCode>")>0){ //BSC有回應ResultCode

			/*
			 * if (s.indexOf("<ResultText>")>0 && s.indexOf("</ResultText>")>0){
			 * //BSC有回應ResultText if
			 * (htResponse.get("ResultCode").toString().equals
			 * (gcResultCodeNoDataFound)){ htResponse.put("ResultText",
			 * gcResultTextNoDataFound); //取代掉BSC回應的ResultText }else{
			 * htResponse.put("ResultText", GetXMLSingleValue(s, "ResultText"));
			 * //BSC回應的ResultText } }else{ htResponse.put("ResultText",
			 * "99999未知的錯誤"); //無法取得BSC回應的ResultText，自行設為99999未知的錯誤 } //if
			 * (s.indexOf("<ResultText>")>0 && s.indexOf("</ResultText>")>0){
			 * //BSC有回應ResultText
			 */
		} catch (IOException e) {
			s = "連線錯誤，訊息如下：" + e.toString();
			htResponse.put("Request", sRequest); // 傳給BSC的XML (還未被Base64
													// encoded)
			htResponse.put("Response", "");
			htResponse.put("ResultCode", "99998");
			htResponse.put("ResultText", s);
		}
		// writeToFile(htResponse.get("ResultCode").toString());
		// writeToFile(htResponse.get("ResultText").toString());
		return htResponse;
	} // 呼叫 BSC API
	
	//取得XML中單一欄位的值
	public String GetXMLSingleValue(String sXML, String sElement){
		/**************************************************************************
		sXml:		XML字串，例如："<BscXmlApi><GetPOSSinglePromotionRes><RequestId>20120206-141330-8799-1</RequestId><ResultCode>00000</ResultCode><ResultText>success</ResultText><SinglePromotion><PromotionId>4927</PromotionId><PromotionCode>121213</PromotionCode><PromotionName>暢打300_上網399</PromotionName><GrpSeq>1</GrpSeq><ItemId>13646</ItemId><ItemCode>1WHTDEHD1002K</ItemCode><ItemName>HTC Desire HD 簡配 黑色</ItemName><SalesQty>2</SalesQty><ItemPrice>28000</ItemPrice><DiscountAmt>12990</DiscountAmt><ItemVendorId>84</ItemVendorId><ItemVendorName>HTC</ItemVendorName><ItemModel>Desire HD</ItemModel><ColorCode>黑色</ColorCode><DetailRemark></DetailRemark></SinglePromotion><SinglePromotion><PromotionId>4927</PromotionId><PromotionCode>121213</PromotionCode><PromotionName>暢打300_上網399</PromotionName><GrpSeq>1</GrpSeq><ItemId>14164</ItemId><ItemCode>1WHTDESS1002B</ItemCode><ItemName>HTC Desire S 簡配 藍色</ItemName><SalesQty>1</SalesQty><ItemPrice>26100</ItemPrice><DiscountAmt>11090</DiscountAmt><ItemVendorId>84</ItemVendorId><ItemVendorName>HTC</ItemVendorName><ItemModel>Desire S</ItemModel><ColorCode>藍色</ColorCode><DetailRemark></DetailRemark></SinglePromotion></GetPOSSinglePromotionRes></BscXmlApi>"
		sElement:	欲尋找的欄位，例如："RequestId"
		回覆String值: 例如："20120206-141330-8799-1"
		**************************************************************************/
		String sValue = "";
		try{
			DocumentBuilderFactory	docFactory	= DocumentBuilderFactory.newInstance();
			DocumentBuilder			docBuilder	= docFactory.newDocumentBuilder();
			Document				document	= docBuilder.parse(new InputSource(new StringReader(sXML)));
			Element					rootElement	= document.getDocumentElement();
			
			NodeList nl	= null;
			Node n		= null;
			int i;
			int j;
			
			//這是取得單一Element的值--start
			nl = rootElement.getElementsByTagName(sElement);
			i = nl.getLength();
			if (i>0){
				n = nl.item(0);
				sValue = n.getTextContent();
			}	//if (i>0){
			//這是取得單一Element的值--end
		}catch(Exception e){
			sValue = e.toString();
		}
		return sValue;
	}	//public String GetSingleValue(String sXML, String sElement){
	
}
