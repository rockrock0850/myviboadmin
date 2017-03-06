package com.tstar.utility;

import java.io.StringReader;
import java.io.StringWriter;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import net.sf.json.JSONArray;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

public class StringFilter {
	
	private final static Logger logger = Logger.getLogger(StringFilter.class);
	
	/*
	 * 要過濾的關鍵字
	 */
	static String[][] filterKey = {
		{"encrypt","MSISDN"},	//電話號碼
		{"encrypt","MainMSISDN"},	//電話號碼
		{"encrypt","TaxIDNumber"},	//身分證
		{"encrypt","CustomerId"},	//身分證CustId
		{"encrypt","CustId"},	//身分證
		{"encrypt","OtherPhone"},	//電話
		{"encrypt","WorkPhone"},	//電話
		{"encrypt","HomePhone"},	//電話
		{"encrypt","CustomerName"},	//姓名
		{"encrypt","Street"}	//地址
            };
	static String maskWord = "*";
	
	static EncriptionSimple encriptionSimple;
	
	
	//取得XML中單一欄位的值
	public static String replaceXMLValue(String xml){
		String rtnXml = new String(xml);
		try {
			DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();  
			DocumentBuilder builder = dbFactory.newDocumentBuilder();
			InputSource is = new InputSource(new StringReader(rtnXml));
			Document doc = builder.parse(is);
			
			for (String[] row : filterKey){
            	NodeList list = doc.getElementsByTagName(row[1]);
		        
            	for(int i = 0; i< list.getLength() ; i ++){
		        	Node node = list.item(i);
		        	
		        	String val = "";
		        	if(node != null && node.getFirstChild() != null){
		        		if("mobile".equals(row[0])){
			        		val = replacePhone(node.getFirstChild().getNodeValue());
			        	}else if("name".equals(row[0])){
			        		val = replaceName(node.getFirstChild().getNodeValue());
			        	}else if("encrypt".equals(row[0])){
			        		val = encription(node.getFirstChild().getNodeValue());
			        	}else{
			        		val = encription(node.getFirstChild().getNodeValue());
			        	}
		        		node.getFirstChild().setNodeValue(val);
		        	}
		        }
	        }
			
	        
	        rtnXml = xmlToString(doc);
		} catch (Exception e) {
			logger.error("input xml: " + xml);
			logger.error(e);
		}
		
        return rtnXml;
	}
	
	public static String replaceJSONValue(String json){
		String rtnJson = new String(json);
		try {
			net.sf.json.JSONObject jsonObj = net.sf.json.JSONObject.fromObject(rtnJson);  
			
			for (String[] row : filterKey){
		        		if("mobile".equals(row[0])){
		        			
			        	}else if("encrypt".equals(row[0])){
			        		jsonObject(row[1], jsonObj);
			        	}
	        }
			rtnJson = jsonObj.toString();
		} catch (Exception e) {
//			e.printStackTrace();
		}
		
        return rtnJson;
	}
	
	private static void jsonObject(String exp, net.sf.json.JSONObject jsonObj){
		for(Object set : jsonObj.keySet()){
			if(set instanceof String){
				String key = (String)set;
				if(exp.equals(key)){
					jsonObj.put(key, encription(jsonObj.getString(key)));
				}else if (jsonObj.get(key) instanceof net.sf.json.JSONObject){
					jsonObject(exp, jsonObj.getJSONObject(key));
				}else if(jsonObj.get(key) instanceof JSONArray){
					jsonArray(exp, jsonObj.getJSONArray(key));
				}
			}
		}
	}
		
	private static void jsonArray(String exp, JSONArray jsonArray){
		for(Object obj : jsonArray){
			if(obj instanceof net.sf.json.JSONObject){
				jsonObject(exp, (net.sf.json.JSONObject)obj);
			}else if(obj instanceof JSONArray){
				jsonArray(exp, (JSONArray)obj);
			}
		}
	}
	
	private static String xmlToString(Document doc) {
	    try {
	        StringWriter sw = new StringWriter();
	        TransformerFactory tf = TransformerFactory.newInstance();
	        Transformer transformer = tf.newTransformer();
	        transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
	        transformer.setOutputProperty(OutputKeys.METHOD, "xml");
	        transformer.setOutputProperty(OutputKeys.INDENT, "no");
	        transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");

	        transformer.transform(new DOMSource(doc), new StreamResult(sw));
	        return sw.toString();
	    } catch (Exception ex) {
	        throw new RuntimeException("Error converting to String", ex);
	    }
	}
	
	//隱碼電話號碼
	private static String replacePhone(String replacePhone){
		return replaceLastString(4, replacePhone);
	}
	
	//隱碼姓名
	private static String replaceName(String name){
		StringBuffer strBuffer = new StringBuffer();
		if(StringUtils.isNotBlank(name)){
			if(3 <= name.length()){
				strBuffer.append(name.substring(0,1));
				for(int i = 0; i < name.length()-2; i++){
					strBuffer.append(maskWord);
				}
				strBuffer.append(name.substring(name.length()-1));
			}else if(2 == name.length()){
				strBuffer.append(name.substring(0, 1));
				strBuffer.append(maskWord);
			}else if(1 == name.length()){
				strBuffer.append(maskWord);
			}
		}
		
		return strBuffer.toString();
	}
	
	//隱碼後4碼
	private static String replaceOther4(String val){
		return replaceLastString(4, val);
	}
	
	private static String replaceLastString(int count, String word){
		StringBuffer strBuffer = new StringBuffer();
		if(StringUtils.isNotBlank(word)){
			if(count <= word.length()){
				strBuffer.append(word.substring(0, word.length()-count));
				for(int i = 0; i < count; i++){
					strBuffer.append(maskWord);
				}
			}else{
				for(int i = 0; i < word.length(); i++){
					strBuffer.append(maskWord);
				}
			}
		}
		
		return strBuffer.toString();
	}
	
	//加密
	private static String encription(String word){
		if(encriptionSimple == null){
			encriptionSimple = new EncriptionSimple();
		}
		return encriptionSimple.encrypt(word);
	}
	
}
