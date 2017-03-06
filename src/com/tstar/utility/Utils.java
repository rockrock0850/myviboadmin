package com.tstar.utility;

import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.URL;
import java.util.Enumeration;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.struts2.ServletActionContext;

import com.fasterxml.jackson.databind.ObjectMapper;

import net.sf.json.JSONObject;


public class Utils {
	public static final String	gcDateFormatDateDashTime = "yyyyMMdd-HHmmss";
	
	//產生20碼的RequestId
	public static String generateRequestId(){
		//以【日期+時間+四位數隨機數】作為送給BSC API的 RequestId，例如【20110816-102153-6221】
		java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat(gcDateFormatDateDashTime);
		java.util.Date currentTime = new java.util.Date();//得到當前系統時間
		String txtRandom = String.valueOf(Math.round(Math.random()*10000));
		String txtRequestId = formatter.format(currentTime) + "-" + txtRandom; //將日期時間格式化，加上一個隨機數，作為RequestId，格式是yyyyMMdd-HHmmss-xxxx

		return txtRequestId;
	}
	/**
	 * 換算傳輸量的方法
	 * @param num 換算的值
	 * @param unitFrom (Byte、KB、MB、GM)大小寫都可
	 * @param unitTo (Byte、KB、MB、GM)大小寫都可
	 * @param limit 極限值(若num>=limit->進行換算)
	 * @return 返回double
	 */
    public double converter(double num, String unitFrom, String unitTo, int limit){
    	try {
    		if(num >= limit){
    			if(unitFrom.equals("b") && unitTo.equals("kb")){
    				num = num / Math.pow(1024, 1);
    			}else if(unitFrom.equals("b") && unitTo.equals("mb")){
    				num = num / Math.pow(1024, 2);
    			}else if(unitFrom.equals("b") && unitTo.equals("gb")){
    				num = num / Math.pow(1024, 3);
    			}else if(unitFrom.equals("kb") && unitTo.equals("b")){
    				num = num * Math.pow(1024, 1);
    			}else if(unitFrom.equals("kb") && unitTo.equals("mb")){
    				num = num / Math.pow(1024, 1);
    			}else if(unitFrom.equals("kb") && unitTo.equals("gb")){
    				num = num / Math.pow(1024, 2);
    			}else if(unitFrom.equals("mb") && unitTo.equals("b")){
    				num = num * Math.pow(1024, 2);
    			}else if(unitFrom.equals("mb") && unitTo.equals("kb")){
    				num = num * Math.pow(1024, 1);
    			}else if(unitFrom.equals("mb") && unitTo.equals("gb")){
    				num = num / Math.pow(1024, 1);
    			}else if(unitFrom.equals("gb") && unitTo.equals("b")){
    				num = num * Math.pow(1024, 3);
    			}else if(unitFrom.equals("gb") && unitTo.equals("kb")){
    				num = num * Math.pow(1024, 2);
    			}else if(unitFrom.equals("gb") && unitTo.equals("mb")){
    				num = num * Math.pow(1024, 1);
    			}else if(unitFrom.equals("b".toUpperCase()) && unitTo.equals("kb".toUpperCase())){
    				num = num / Math.pow(1024, 1);
    			}else if(unitFrom.equals("b".toUpperCase()) && unitTo.equals("mb".toUpperCase())){
    				num = num / Math.pow(1024, 2);
    			}else if(unitFrom.equals("b".toUpperCase()) && unitTo.equals("gb".toUpperCase())){
    				num = num / Math.pow(1024, 3);
    			}else if(unitFrom.equals("kb".toUpperCase()) && unitTo.equals("b".toUpperCase())){
    				num = num * Math.pow(1024, 1);
    			}else if(unitFrom.equals("kb".toUpperCase()) && unitTo.equals("mb".toUpperCase())){
    				num = num / Math.pow(1024, 1);
    			}else if(unitFrom.equals("kb".toUpperCase()) && unitTo.equals("gb".toUpperCase())){
    				num = num / Math.pow(1024, 2);
    			}else if(unitFrom.equals("mb".toUpperCase()) && unitTo.equals("b".toUpperCase())){
    				num = num * Math.pow(1024, 2);
    			}else if(unitFrom.equals("mb".toUpperCase()) && unitTo.equals("kb".toUpperCase())){
    				num = num * Math.pow(1024, 1);
    			}else if(unitFrom.equals("mb".toUpperCase()) && unitTo.equals("gb".toUpperCase())){
    				num = num / Math.pow(1024, 1);
    			}else if(unitFrom.equals("gb".toUpperCase()) && unitTo.equals("b".toUpperCase())){
    				num = num * Math.pow(1024, 3);
    			}else if(unitFrom.equals("gb".toUpperCase()) && unitTo.equals("kb".toUpperCase())){
    				num = num * Math.pow(1024, 2);
    			}else if(unitFrom.equals("gb".toUpperCase()) && unitTo.equals("mb".toUpperCase())){
    				num = num * Math.pow(1024, 1);
    			}else{
    				System.out.println("Not match");
    			}
    		}else{
    			return formatFloat(num, 2);
    		}
    		return formatFloat(num, 2);
		} catch (Exception e) {
			System.out.println(e);
		}
    	return -1;
    }

	/**
	 * 小數點後幾位捨去
	 * @param num 小數位數
	 * @param pos 捨去小數點後幾位
	 * @return 返回double數字
	 */
	public double formatFloat(double num, int pos) {
		if(num < 1){
			double size = Math.pow(10, pos);
			return Math.round(num * size) / size;
		}else{
			return num;
		}
	}
	
	//產生UUID
	public String getUUID(Boolean dash){
        String s = "M-" + UUID.randomUUID().toString();
        if (dash){
            return s;
        } else{
            //去掉「-」符號
            return s.substring(0,8)+s.substring(9,13)+s.substring(14,18)+s.substring(19,23)+s.substring(24);
        }
    }
	
	//確定是否為Int
	public static boolean isInt(String str) {
		try {
			Integer.parseInt(str);
		} catch (NumberFormatException nfe) {
			return false;
		}
		return true;
	}
	
	//確定是否為double
	public static boolean isDouble(String str) {
		try {
			Double.parseDouble(str);
		} catch (NumberFormatException nfe) {
			return false;
		}
		return true;
	}
	
	/**
	 * 分轉成秒
	 * @param min 分鐘數
	 * @return 秒數
	 */
	public String min2sec(String min){
		String sec = "0";
		
		try{
			double num = Double.parseDouble(min);
			sec = String.valueOf(num*60);
		}catch(Exception e){
			
		}
		
		return sec;
	}
	
	public void hasKey(JSONObject json, String chk){
		if(!(json.has(chk))){
			json.put(chk, "1");
		}
	}
	
	/**
	 * 關閉所有HttpClient開啟的連線
	 * @param response
	 * @param client
	 */
	public void closeHttpClient(CloseableHttpResponse response, CloseableHttpClient client){
		try {
			if(response != null){
				response.close();
			}
			if(client != null){
				client.close();
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
    public void write2Response(org.json.JSONObject json){
    	PrintWriter writer;
        HttpServletResponse response = ServletActionContext.getResponse();
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        try {
            writer = response.getWriter();//將內容輸出到response
            writer.write(json.toString());
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
	
    public void write2Response(org.json.JSONArray json){
    	PrintWriter writer;
        HttpServletResponse response = ServletActionContext.getResponse();
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        try {
            writer = response.getWriter();//將內容輸出到response
            writer.write(json.toString());
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
     /**
      * 擷取字串(可過濾中文與英文)
      * @param subString 要擷取的字串
      * @param subOffset 擷取位元位址
      * @return
      */
    public String subOracleStringByLength(String subString, int subOffset){
    	try {
    		if(StringUtils.isBlank(subString) || 0 > subOffset){
            	return "";
    		}else if(subOffset < getOracleStringLength(subString)){
                byte[] result = new byte[subOffset];
//              Trace back the string and byte log
//              System.out.println("Bytes to array row: " + Arrays.toString(subString.getBytes("utf-8")));
                System.arraycopy(subString.getBytes("utf-8"), 0, result, 0, subOffset);
                String chinese = new String(result, "utf-8");
                if((subOffset+1) == chinese.getBytes().length){// 燃燒生命發現的規則:[subOffset+1 == length]代表擷取到中文的第[3]位元
                	result = new byte[subOffset-2];
                    System.arraycopy(subString.getBytes("utf-8"), 0, result, 0, subOffset-2);// 所以-2讓指標指向第1位元
                }else if((subOffset+2) == chinese.getBytes().length){// 燃燒生命發現的規則:[subOffset+2 == length]代表擷取到中文的第[2]位元
                	result = new byte[subOffset-1];
                    System.arraycopy(subString.getBytes("utf-8"), 0, result, 0, subOffset-1);// 所以-1讓指標指向第1位元
                }
            	return new String(result, "utf-8");
    		}else{
            	return subString;
    		}
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
    }
    
    /**
     * 取得字串長度(Byte)
     * @param str
     * @return
     */
    public int getOracleStringLength(String str){
    	if(StringUtils.isBlank(str)){
    		return 0;
    	}else{
    		try {
            	return str.getBytes("utf-8").length;
			} catch (Exception e) {
				e.printStackTrace();
				return 0;
			}
    	}
    }

    /**
     * 分析出在哪個類別的第幾行出現exception
     * @return
     */
    public static String handleExceptionMessage(Exception e){
		try {
			ByteArrayOutputStream out = new ByteArrayOutputStream();
			e.printStackTrace(new PrintStream(out));
			String cause = out.toString("utf-8");
//			Thread陣列index等於[2]表示呼叫此類別的上一層類別編號，反之等於[1]表示本類別編號
			int header = cause.indexOf(Thread.currentThread().getStackTrace()[2].getClassName());
			String classHeader = cause.substring(header);
			int offset = Thread.currentThread().getStackTrace()[2].getMethodName().length();
			int begin = classHeader.indexOf(Thread.currentThread().getStackTrace()[2].getMethodName()) + offset+1;
			int end = begin + classHeader.substring(begin).indexOf(")");
			return classHeader.substring(begin, end);
		} catch (Exception e2) {
			e2.printStackTrace();
			return null;
		}
    }
    
    public static void main(String[] args) {
    	String str = handleExceptionMessage(new Exception("123213"));
    	System.out.println("----------" + str);
	}
    
    /**
     * 呼叫MCSUsageLog servlet
     * @param logType
     * @param functionCode
     * @param contractId
     * @param msisdn
     * @param memo
     * @return
     */
    public String logRecorder(String logType, String contractId, String msisdn, Map<String, Object> memo){
    	try {
    		logType = logType == null ? "" : logType;
    		contractId = contractId == null ? "" : contractId;
    		msisdn = msisdn == null ? "" : msisdn;
    		
    		URL url = new URL(new PropertiesUtil().getProperty("bscUrl") + "TSCAPI/mcsUsageLog.action");
    		HttpURLConnection httpUrlConnection = (HttpURLConnection) url.openConnection();
    		
//    		Set connection timeout
    		httpUrlConnection.setConnectTimeout(3000);
    		
//    		Add reuqest header
    		httpUrlConnection.setRequestMethod("POST");
    		
//    		Conver map to json
    		ObjectMapper objectMapper = new ObjectMapper();
    		String memoToJson = objectMapper.writeValueAsString(memo);
    		
//    		Send post request
    		httpUrlConnection.setDoOutput(true);
    		DataOutputStream wr = new DataOutputStream(httpUrlConnection.getOutputStream());
    		wr.writeBytes(
    				"logType=" + logType + "&" + 
    				"functionCode=" + StringUtils.upperCase(Thread.currentThread().getStackTrace()[2].getMethodName()) + "&" +
    				"contractId=" + contractId + "&" + 
    				"msisdn=" + msisdn + "&" + 
    				"memo=" + memoToJson);
    		wr.flush();
    		wr.close();
        	return String.valueOf(httpUrlConnection.getResponseCode()) + "-" + httpUrlConnection.getResponseMessage();
		} catch (Exception e) {
			e.printStackTrace();
        	return e.getMessage();
		}
    }    
    
    /**
     * 
     * @return
     */
    public static String getRealIpAddress(){
    	String result = null;
	    Enumeration<NetworkInterface> interfaces = null;
	    try {
	        interfaces = NetworkInterface.getNetworkInterfaces();
		     
		    if (interfaces != null) {
		        while (interfaces.hasMoreElements() && StringUtils.isBlank(result)) {
		            NetworkInterface i = interfaces.nextElement();
		            Enumeration<InetAddress> addresses = i.getInetAddresses();
		            while (addresses.hasMoreElements() && (result == null || result.isEmpty())) {
		                InetAddress address = addresses.nextElement();
		                if (!address.isLoopbackAddress()  &&
		                        address.isSiteLocalAddress()) {
		                    result = address.getHostAddress();
		                }
		            }
		        }
		    }
	    	return result;
	    } catch (Exception e) {
	    	e.printStackTrace();
	    	return result;
	    }
    }
	
    /**
     * 
     * @param req
     * @return
     */
	public static String getIp(HttpServletRequest req){
    	// 取得IP位置
		String ipAddress = req.getHeader("X-FORWARDED-FOR");
		if (ipAddress == null) {
			ipAddress = req.getRemoteAddr();
		}
		return ipAddress;
    }
}
