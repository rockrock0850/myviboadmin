package com.tstar.utility;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import org.apache.log4j.Logger;

public class HttpGet {
	private final Logger logger = Logger.getLogger(HttpGet.class);
	
	public String sendToBSC(String url, String requestStr) throws Exception{
		String s = "";
//		url = "http://localhost:8081/myviboadmin/ajaxBSCAPIBridge.jsp?";
//		requestStr = "Function=GetDMSStoreAddressId"
//				+ "&Request=<FunctionType>001</FunctionType>"
//				+ "<SalesClass>001,002</SalesClass>"
//				+ "</GetDMSStoreAddressIdReq>";
		String sRequest = url + requestStr;
		logger.info("HttpGet.sendToBSC(sRequest): " + sRequest);
		URL u;
		u = new URL(sRequest);
		HttpURLConnection uc = (HttpURLConnection)u.openConnection();
		
		uc.setRequestMethod("GET");
		uc.setDoOutput(true);
		uc.setDoInput(true);

		InputStream in = uc.getInputStream();
		BufferedReader r = new BufferedReader(new InputStreamReader(in, "utf-8"));
		StringBuffer buf = new StringBuffer();
		String line;
		while ((line = r.readLine())!=null) {
			buf.append(line);
		}
		in.close();
		
		s = buf.toString();
		s = s.trim().replaceFirst("^([\\W]+)<","<");	//將XML開頭之前的雜亂字元移除，否則可能有【org.xml.sax.SAXParseException: Content is not allowed in prolog】的error，參考【http://mark.koli.ch/2009/02/resolving-orgxmlsaxsaxparseexception-content-is-not-allowed-in-prolog.html】
		s = s.replace("&", "and");	//不做replace的話，若XML中有"&"則會造成parsing error:org.xml.sax.SAXParseException: The entity name must immediately follow the '&' in the entity reference.
		
		logger.info("傳給BSC的request:" + sRequest);	//傳給BSC的HTTP GET (其中XML已被HTTP URL encoded)
		logger.debug("BSC response: " + s);			//BSC回應的XML
		
		return s;
	}
}
