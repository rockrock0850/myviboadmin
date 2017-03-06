<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>

<%@ page import="java.net.*" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.w3c.dom.*, javax.xml.parsers.*, org.xml.sax.InputSource" %>
<%@ page import="javax.mail.*"%>
<%@ page import="javax.mail.internet.*"%>
<%@ page import="javax.activation.*"%>

<%
//Oracle connection
	Class.forName("oracle.jdbc.driver.OracleDriver");
%>

<%!
//注意：因為有些程式使用jxl.jar執行Excel檔案匯出，而jxl.jar有自己的Boolean，所以這裡的Boolean都宣告為java.lang.Boolean，以免compile失敗

/*********************************************************************************************************************/
//檢查字串是否為空值
public java.lang.Boolean beEmpty(String s) {
	return (s==null || s.length()<1);
}	//public java.lang.Boolean beEmpty(String s) {
/*********************************************************************************************************************/

/*********************************************************************************************************************/
//檢查字串是否不為空值
public java.lang.Boolean notEmpty(String s) {
	return (s!=null && s.length()>0);
}	//public java.lang.Boolean notEmpty(String s) {

/*********************************************************************************************************************/

//若字串為null或空值就改為另一字串(例如""或"&nbsp;")
public String nullToString(String sOld, String sReplace){
	return (beEmpty(sOld)?sReplace:sOld);
}
/*********************************************************************************************************************/

//檢查字串是否為數字格式
public java.lang.Boolean isNumber(String str)  
{  
  try  
  {  
    double d = Double.parseDouble(str);  
  }  
  catch(NumberFormatException nfe)  
  {  
    return false;  
  }  
  return true;  
}

/*********************************************************************************************************************/
//建立資料庫連線
public Connection DBConnection(){
	Connection dbcn = null;
	try{
        //Test server
// 		dbcn = DriverManager.getConnection("jdbc:oracle:thin:@" + "172.23.1.184" + ":" + "1530" + ":" + "TAPPDEV", "TAPPADMIN", "TAPPADMIN_APP");
		//Local
		dbcn = DriverManager.getConnection("jdbc:oracle:thin:@" + "172.22.128.212" + ":" + "1527" + ":" + "TAPPDEV", "TAPPADMIN", "TAPPADMIN_APP");
		return dbcn;
	}catch (Exception e){
		writeToFile("系統錯誤!||Function=DBConnection||錯誤描述=" + e.toString());
		return null;
	}       //try{
}       //public Connection DBConnection(){

/*********************************************************************************************************************/
//關閉資料庫連線及相關的ResultSet、Statement
public  void closeDBConnection(ResultSet rs, Statement stmt, Connection dbconn){
	if(rs != null){
		try{
			rs.close();
		}catch (Exception ignored) {}
	}	//if(rs != null){
	if(stmt != null){
		try{
			stmt.close();
		}catch (Exception ignored) {}
	}	//if(stmt != null){
	if(dbconn != null){
		try{
			dbconn.close();
		}catch (Exception ignored) {}
	}	//if(dbconn != null){
}	//public  void String closeDBConnection(ResultSet rs, Statement stmt, Connection dbconn)


/*********************************************************************************************************************/
//取得目前系統時間，並依指定的格式產生字串
public String getDateTimeNow(String sDateFormat){
	/************************************
	sDateFormat:	指定的格式，例如"yyyyMMdd-HHmmss"或"yyyyMMdd"
	*************************************/
	String s;
	SimpleDateFormat nowdate = new java.text.SimpleDateFormat(sDateFormat);
	s = nowdate.format(new java.util.Date());
	return s;
}	//public String getDateTimeNow(String sDateFormat){

/*********************************************************************************************************************/

//產生20碼的RequestId
public String generateRequestId(){
	//以【日期+時間+四位數隨機數】作為送給BSC API的 RequestId，例如【20110816-102153-6221】
	java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat(gcDateFormatDateDashTime);
	java.util.Date currentTime = new java.util.Date();//得到當前系統時間
	String txtRandom = String.valueOf(Math.round(Math.random()*10000));
	String txtRequestId = formatter.format(currentTime) + "-" + txtRandom; //將日期時間格式化，加上一個隨機數，作為RequestId，格式是yyyyMMdd-HHmmss-xxxx

	return txtRequestId;
}

/*********************************************************************************************************************/
//寫入Log檔
public String writeToFile(String content){
	return writeToFile(content, "", "", "", "");
}
public String writeToFile(String content, String sAccountId, String sAccountName, String sLoginIP, String sLoginIPPrivate){
	//fileType=1是debug log，2是CDR檔案
	//content是寫入的內容
	String s = "";
	String sFilePath = "";
	String s1 = "";
	if (content==null || content.length()==0) return "";

	java.io.File dir = new java.io.File(gcLogFilePath);	//若目錄不存在則建立目錄
	if(!dir.exists()) dir.mkdir();

	sFilePath = gcLogFilePath + "MyVIBOAdmin_" + getDateTimeNow(gcDateFormatYMD) + "_" + gcCDRFileSerialNo + ".log";

	s1 = getDateTimeNow(gcDateFormatDateDashTime) + "||";
	if (sAccountId != null || sAccountId.length()>0) s1 = s1 + "AccountId=" + sAccountId + "||";
	if (sAccountName != null || sAccountName.length()>0) s1 = s1 + "AccountName=" + sAccountName + "||";
	if (sLoginIP != null || sLoginIP.length()>0) s1 = s1 + "LoginIP=" + sLoginIP + "||";
	if (sLoginIPPrivate != null || sLoginIPPrivate.length()>0) s1 = s1 + "LoginIP_Private=" + sLoginIPPrivate + "||";

	try{
		FileWriter fw=new FileWriter(sFilePath, true);
		fw.write(s1 + content + "\n\n");
		fw.flush();
		fw.close();
	}catch(Exception e){
		s = "Error write to log file, filePath=" + sFilePath + "<p>" + e.toString();
	}
	return s;
}	//public String writeToFile(int fileType, String content){

/*********************************************************************************************************************/
//讀取某個文字檔的內容
public String readFileContent(String sPath){
	//sPath:檔案的路徑及檔名，呼叫此函數前請先以【String fileName=getServletContext().getRealPath("directory/jsp.txt");】取得檔案的徑名，然後以此徑名做為sPath參數送給此函數
	File file = new File(sPath);
	FileInputStream fis = null;
	BufferedInputStream bis = null;
	DataInputStream dis = null;
	String content = "";
	try {
		fis = new FileInputStream(file);
		bis = new BufferedInputStream(fis);
		dis = new DataInputStream(bis);
		while (dis.available() != 0) {
			content += dis.readLine()+"\r\n";
		}
		content = new String(content.getBytes("8859_1"),"utf-8");
	} catch (FileNotFoundException e) {
		content = "";
		writeToFile("系統錯誤!||Function=readFileContent||參數sPath=" + sPath + "||錯誤描述=" + e.toString());
	} catch (IOException e) {
		content = "";
		writeToFile("系統錯誤!||Function=readFileContent||參數sPath=" + sPath + "||錯誤描述=" + e.toString());
	}finally{
		if (dis!=null){ try{dis.close();}catch (Exception ignored) {}}
		if (bis!=null){ try{bis.close();}catch (Exception ignored) {}}
		if (fis!=null){ try{fis.close();}catch (Exception ignored) {}}
	}
	return content;
}

/*********************************************************************************************************************/
//刪除某個檔案
public java.lang.Boolean DeleteFile(String sFileName){
	java.lang.Boolean bOK = true;
	if (sFileName==null || sFileName.length()<1)	return false;
	
	File f = new File(sFileName);
	if(f.exists()){//檢查是否存在
		writeToFile("刪除檔案:" + sFileName);
		f.delete();//刪除文件
	} 
	return bOK;
}	//public java.lang.Boolean DeleteFile(String sPath, String sFileName){

/*********************************************************************************************************************/
//依照輸入的SQL statement取得ResultSet，並將ResultSet轉換成String Array回覆給呼叫端
public Hashtable getDBData(String sSQL, int iColCount){
	//sSQL是SQL statement
	//iColCount是ResultSet中每個row的column數
	
	Hashtable	htResponse		= new Hashtable();	//儲存回覆資料的 hash table
	String		s[][]			= null;
	String		sResultCode		= gcResultCodeSuccess;
	String		sResultText		= gcResultTextSuccess;
	int			i				= 0;
	int			j				= 0;
	int			iRowCount		= 0;
	
	if ((sSQL==null || sSQL.length()<1) || iColCount<1){
		htResponse.put("ResultCode", gcResultCodeParametersValidationError);
		htResponse.put("ResultText", gcResultTextParametersValidationError);
		return htResponse;
	}

	//找出DB中的資料
	Connection	dbconn	= null;	//連接 Oracle DB 的 Connection 物件
	Statement	stmt	= null;	//SQL statement 物件
	ResultSet	rs		= null;	//Resultset 物件
	
	dbconn = DBConnection();
	if (dbconn==null){	//資料庫連線失敗
		htResponse.put("ResultCode", gcResultCodeDBTimeout);
		htResponse.put("ResultText", gcResultTextDBTimeout);
		return htResponse;
	}	//if (dbconn==null){	//資料庫連線失敗

	try{	//擷取資料
		stmt = dbconn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
		//System.out.println("DB getDBData......SQL: " + sSQL);
		rs = stmt.executeQuery(sSQL);
		if (rs!=null){
			rs.last();
			iRowCount = rs.getRow();
			rs.beforeFirst();
		}
		//System.out.println("DB getDBData......iRowCount: " + iRowCount);
		if (iRowCount>0){	//有資料
			s = new String[iRowCount][iColCount];
			i = 0;
			while (rs != null && rs.next()) { //有資料則顯示
				for (j=0;j<iColCount;j++){	//產生String Array的值
					s[i][j] = rs.getString(j+1);
				}
				i++;
			}	//while(rs.next()){	//有資料則顯示
		}else{	//無資料
			sResultCode = gcResultCodeNoDataFound;
			sResultText = gcResultTextNoDataFound;
		}	//if (iRowCount>0){	//有資料
		     /***********************************************************************************************************/
	}catch(SQLException e){
		sResultCode = gcResultCodeUnknownError;
		sResultText = e.toString();
		writeToFile("系統錯誤!||Function=getDBData||參數:||sSQL=" + sSQL + "||iColCount=" + String.valueOf(iColCount) + "||錯誤描述=" + e.toString());
	}finally{
		//Clean up resources, close the connection.
		closeDBConnection(rs, stmt, dbconn);
	}	//}finally{
	
	htResponse.put("ResultCode", sResultCode);
	htResponse.put("ResultText", sResultText);
	if (iRowCount>0) htResponse.put("Data", s);
	return htResponse;
}	//public String getDBData(String sSQL, int iColCount){

/*********************************************************************************************************************/
//依照輸入的SQL statement取得ResultSet，並將ResultSet轉換成String Array回覆給呼叫端，這是找CLOB的資料
public Hashtable getDBDataClob(String sSQL, int iColCount){
	//sSQL是SQL statement
	//iColCount是ResultSet中每個row的column數
	
	Hashtable	htResponse		= new Hashtable();	//儲存回覆資料的 hash table
	String		s[][]			= null;
	String		sResultCode		= gcResultCodeSuccess;
	String		sResultText		= gcResultTextSuccess;
	int			i				= 0;
	int			j				= 0;
	int			iRowCount		= 0;
	oracle.sql.CLOB clob		=  null ;
	
	if ((sSQL==null || sSQL.length()<1) || iColCount<1){
		htResponse.put("ResultCode", gcResultCodeParametersValidationError);
		htResponse.put("ResultText", gcResultTextParametersValidationError);
		return htResponse;
	}

	//找出DB中的資料
	Connection	dbconn	= null;	//連接 Oracle DB 的 Connection 物件
	Statement	stmt	= null;	//SQL statement 物件
	ResultSet	rs		= null;	//Resultset 物件
	
	dbconn = DBConnection();
	if (dbconn==null){	//資料庫連線失敗
		htResponse.put("ResultCode", gcResultCodeDBTimeout);
		htResponse.put("ResultText", gcResultTextDBTimeout);
		return htResponse;
	}	//if (dbconn==null){	//資料庫連線失敗

	try{	//擷取資料
		stmt = dbconn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
		rs = stmt.executeQuery(sSQL);
		if (rs!=null){
			rs.last();
			iRowCount = rs.getRow();
			rs.beforeFirst();
		}
		if (iRowCount>0){	//有資料
			s = new String[iRowCount][iColCount];
			i = 0;
			while (rs != null && rs.next()) { //有資料則顯示
				for (j=0;j<iColCount;j++){	//產生String Array的值
					if (rs.getClob(j+1)!=null){
						clob = (oracle.sql.CLOB) rs.getClob(j+1);
						try{
							s[i][j] = ClobToString(clob);
						}catch(Exception e){
							s[i][j] = "取得資料時發生錯誤!!";
						}
					}else{
						s[i][j] = "";
					}
				}
				i++;
			}	//while(rs.next()){	//有資料則顯示
		}else{	//無資料
			sResultCode = gcResultCodeNoDataFound;
			sResultText = gcResultTextNoDataFound;
		}	//if (iRowCount>0){	//有資料
		     /***********************************************************************************************************/
	}catch(SQLException e){
		sResultCode = gcResultCodeUnknownError;
		sResultText = e.toString();
		writeToFile("系統錯誤!||Function=getDBDataClob||參數:||sSQL=" + sSQL + "||iColCount=" + String.valueOf(iColCount) + "||錯誤描述=" + e.toString());
	}finally{
		//Clean up resources, close the connection.
		closeDBConnection(rs, stmt, dbconn);
	}	//}finally{
	
	htResponse.put("ResultCode", sResultCode);
	htResponse.put("ResultText", sResultText);
	if (iRowCount>0) htResponse.put("Data", s);
	return htResponse;
}	//public String getDBData(String sSQL, int iColCount){

/*********************************************************************************************************************/
// 將字CLOB轉成STRING類型   
public  String ClobToString(oracle.sql.CLOB clob)  throws  SQLException, IOException {   
	String reString =  "" ;   
	Reader is = clob.getCharacterStream(); //得到流   
	BufferedReader br =  new  BufferedReader(is);   
	String s = br.readLine();   
	StringBuffer sb =  new  StringBuffer();   
	while  (s !=  null ) { //執行循環將字符串全部取出付值給StringBuffer由StringBuffer轉成STRING   
		sb.append(s);   
		s = br.readLine();   
	}   
	reString = sb.toString();   
	return  reString;   
}   

/*********************************************************************************************************************/
//Update DB 中的 CLOB 欄位
public Hashtable UpdateClobOnDB(String sSQL, String sValue){
	//sSQL是SQL statement
	
	Hashtable	htResponse		= new Hashtable();	//儲存回覆資料的 hash table
	String		sResultCode		= gcResultCodeSuccess;
	String		sResultText		= gcResultTextSuccess;
	
	if (sSQL==null || sSQL.length()<1){
		htResponse.put("ResultCode", gcResultCodeParametersValidationError);
		htResponse.put("ResultText", gcResultTextParametersValidationError);
		return htResponse;
	}

	//對DB執行SQL指令
	Connection	dbconn	= null;	//連接 Oracle DB 的 Connection 物件
	PreparedStatement	stmt	= null;	//SQL statement 物件
	//ResultSet	rs		= null;	//Resultset 物件
	int			i		= 0;	//executeUpdate後回覆的row count數
	
	dbconn = DBConnection();
	if (dbconn==null){	//資料庫連線失敗
		htResponse.put("ResultCode", gcResultCodeDBTimeout);
		htResponse.put("ResultText", gcResultTextDBTimeout);
		return htResponse;
	}	//if (dbconn==null){	//資料庫連線失敗

	try{	//執行SQL指令
		stmt = dbconn.prepareStatement(sSQL);
		Reader clobReader =  new  StringReader(sValue);
		stmt.setCharacterStream( 1 , clobReader, sValue.length());
		i = stmt.executeUpdate();
		if (i<=0){
			sResultCode = gcResultCodeUnknownError;
			sResultText = "執行update CLOB失敗";
			writeToFile("系統錯誤!||Function=UpdateClobOnDB||參數:||sSQL=" + sSQL + "||錯誤描述=" + "執行update CLOB失敗");
		}
	}catch(SQLException e){
		sResultCode = gcResultCodeUnknownError;
		sResultText = e.toString();
		writeToFile("系統錯誤!||Function=UpdateClobOnDB||參數:||sSQL=" + sSQL + "||錯誤描述=" + e.toString());
	}finally{
		//Clean up resources, close the connection.
		closeDBConnection(null, stmt, dbconn);
	}	//}finally{
	
	htResponse.put("ResultCode", sResultCode);
	htResponse.put("ResultText", sResultText);
	return htResponse;
}	//public String getDBData(String sSQL, int iColCount){


/*********************************************************************************************************************/
//依照輸入的SQL statement對DB執行單一insert, update, delete指令，並將執行結果回覆給呼叫端
public Hashtable execSQLOnDB(String sSQL){
	//sSQL是SQL statement
	
	Hashtable	htResponse		= new Hashtable();	//儲存回覆資料的 hash table
	String		sResultCode		= gcResultCodeSuccess;
	String		sResultText		= gcResultTextSuccess;
	
	if (sSQL==null || sSQL.length()<1){
		htResponse.put("ResultCode", gcResultCodeParametersValidationError);
		htResponse.put("ResultText", gcResultTextParametersValidationError);
		return htResponse;
	}

	//對DB執行SQL指令
	Connection	dbconn	= null;	//連接 Oracle DB 的 Connection 物件
	Statement	stmt	= null;	//SQL statement 物件
	//ResultSet	rs		= null;	//Resultset 物件
	int			i		= 0;	//executeUpdate後回覆的row count數
	
	dbconn = DBConnection();
	if (dbconn==null){	//資料庫連線失敗
		htResponse.put("ResultCode", gcResultCodeDBTimeout);
		htResponse.put("ResultText", gcResultTextDBTimeout);
		return htResponse;
	}	//if (dbconn==null){	//資料庫連線失敗

	try{	//執行SQL指令
		stmt = dbconn.createStatement();
		i = stmt.executeUpdate(sSQL);
	}catch(SQLException e){
		sResultCode = gcResultCodeUnknownError;
		sResultText = e.toString();
		writeToFile("系統錯誤!||Function=execSQLOnDB||參數:||sSQL=" + sSQL + "||錯誤描述=" + e.toString());
	}finally{
		//Clean up resources, close the connection.
		closeDBConnection(null, stmt, dbconn);
	}	//}finally{
	
	htResponse.put("ResultCode", sResultCode);
	htResponse.put("ResultText", sResultText);
	return htResponse;
}	//public String getDBData(String sSQL, int iColCount){

/*********************************************************************************************************************/
//依照輸入的SQL statement對DB執行多個insert, update, delete指令(可指定是否需每個指令自動commit)，並將執行結果回覆給呼叫端
public Hashtable execMultiSQLOnDB(List<String> sSQLList, java.lang.Boolean bAutoCommit){	//輸入參數為 List 型態
	return execMultiSQLOnDB(sSQLList.toArray(new String[0]), bAutoCommit);
}
public Hashtable execMultiSQLOnDB(String sSQL[], java.lang.Boolean bAutoCommit){			//輸入參數為 String array 型態
	//sSQL[]是SQL statement
	
	Hashtable	htResponse		= new Hashtable();	//儲存回覆資料的 hash table
	String		sResultCode		= gcResultCodeSuccess;
	String		sResultText		= gcResultTextSuccess;
	String		s				= "";
	
	if (sSQL==null || sSQL.length<1){
		htResponse.put("ResultCode", gcResultCodeParametersValidationError);
		htResponse.put("ResultText", gcResultTextParametersValidationError);
		return htResponse;
	}

	//對DB執行SQL指令
	Connection	dbconn	= null;	//連接 Oracle DB 的 Connection 物件
	Statement	stmt	= null;	//SQL statement 物件
	int			i		= 0;	//executeUpdate後回覆的row count數
	int			j		= 0;	//sSQL string array的指標
	
	dbconn = DBConnection();
	if (dbconn==null){	//資料庫連線失敗
		htResponse.put("ResultCode", gcResultCodeDBTimeout);
		htResponse.put("ResultText", gcResultTextDBTimeout);
		return htResponse;
	}	//if (dbconn==null){	//資料庫連線失敗
	/*
	for(j=0;j<sSQL.length;j++){
		writeToFile(sSQL[j]);
	}
	*/
	try{	//執行SQL指令
		stmt = dbconn.createStatement();
		if (bAutoCommit==false) dbconn.setAutoCommit(false);
		for(j=0;j<sSQL.length;j++){
			if (notEmpty(sSQL[j])){
				s = s + sSQL[j] + ";";
				i = stmt.executeUpdate(sSQL[j]);
			}
        }	//for(j=0;j<=sSQL.length;j++){
        if (bAutoCommit==false) dbconn.commit();
	}catch(SQLException e){
		try{
			if (bAutoCommit==false) dbconn.rollback();
		}catch(SQLException e1){
			writeToFile("系統錯誤!||Function=execMultiSQLOnDB(無法執行rollback)||參數:||已執行的sSQL=" + s + "||錯誤描述=" + e1.toString());
		};
		sResultCode = gcResultCodeUnknownError;
		sResultText = e.toString();
		writeToFile("系統錯誤!||Function=execMultiSQLOnDB||參數:||已執行的sSQL=" + s + "||錯誤描述=" + e.toString());
	}finally{
		try{
			dbconn.setAutoCommit(true);
		}catch(SQLException e2){
			writeToFile("系統錯誤!||Function=execMultiSQLOnDB(無法將AutoCommit設為true)||參數:||已執行的sSQL=" + s + "||錯誤描述=" + e2.toString());
		}
		//Clean up resources, close the connection.
		closeDBConnection(null, stmt, dbconn);
	}	//}finally{
	
	htResponse.put("ResultCode", sResultCode);
	htResponse.put("ResultText", sResultText);
	return htResponse;
}	//public Hashtable execMultiSQLOnDB(String sSQL[], java.lang.Boolean bAutoCommit){

/*********************************************************************************************************************/

//呼叫 BSC API
public Hashtable sendToBSC(String sURL, String sXML){
	/************************************
	sURL：BSC API網址，例如：http://172.24.129.111:8080/BSC/GetPOSItems.jsp?xml=
	sXML：傳給 BSC API 的 XML 內容，例如：<BscXmlApi><GetPOSItemsReq><VASId>abc</VASId><VASPassword>123</VASPassword><RequestId>20120206-141330-8799-1</RequestId><ItemCode></ItemCode><ItemName>HTC</ItemName><QtyFlag>N</QtyFlag></GetPOSItemsReq></BscXmlApi>
	*************************************/
	
	Hashtable	htResponse	= new Hashtable();	//儲存回覆資料的 hash table	
	String		sRequest	= "";				//要送HTTP GET給 BSC 的內容，含URL及XML
	
	String s = "";
	int i;
	//String s2 = "";
	//s2 = new String(sXML.getBytes(), "utf-8");
	
	//sRequest = sURL + URLEncoder.encode(sXML, "utf-8");
	
	//sRequest = sURL + URLEncoder.encode(sXML.getBytes("utf-8").toString());
	sRequest = sURL + sXML;

	try
	{
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
// 		System.out.println("sendToBSC RECEIVED DATA=====================: " + s);
		htResponse.put("Request", sRequest);	//傳給BSC的HTTP GET (其中XML已被HTTP URL encoded)
		htResponse.put("Response", s);			//BSC回應的XML
		
		if (s.indexOf("<ResultCode>")>0 && s.indexOf("</ResultCode>")>0){	//BSC有回應ResultCode
			htResponse.put("ResultCode", GetXMLSingleValue(s, "ResultCode"));	//BSC回應的ResultCode
		}else{
			htResponse.put("ResultCode", "99999");	//無法取得BSC回應的ResultCode，自行設為99999
			writeToFile("sendToBSC發生錯誤：\nXML=" + sXML + "\nBSC回應=" + s);
		}	//if (s.indexOf("<ResultCode>")>0 && s.indexOf("</ResultCode>")>0){	//BSC有回應ResultCode
		
		/*
		if (s.indexOf("<ResultText>")>0 && s.indexOf("</ResultText>")>0){	//BSC有回應ResultText
			if (htResponse.get("ResultCode").toString().equals(gcResultCodeNoDataFound)){
				htResponse.put("ResultText", gcResultTextNoDataFound);	//取代掉BSC回應的ResultText
			}else{
				htResponse.put("ResultText", GetXMLSingleValue(s, "ResultText"));	//BSC回應的ResultText
			}
		}else{
			htResponse.put("ResultText", "99999未知的錯誤");	//無法取得BSC回應的ResultText，自行設為99999未知的錯誤
		}	//if (s.indexOf("<ResultText>")>0 && s.indexOf("</ResultText>")>0){	//BSC有回應ResultText
		*/
	}catch (Exception e){ 
		System.out.println("sendToBSC ERROR=====================error: " + e);
		s = "連線錯誤，訊息如下：" + e.toString();
		e.printStackTrace();
		htResponse.put("Request", sRequest);	//傳給BSC的XML (還未被Base64 encoded)
		htResponse.put("Response", "");
		htResponse.put("ResultCode", "99998");
		htResponse.put("ResultText", s);
	}
	//writeToFile(htResponse.get("ResultCode").toString());
	//writeToFile(htResponse.get("ResultText").toString());
	return htResponse;
}	//呼叫 BSC API


/*********************************************************************************************************************/

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

/*********************************************************************************************************************/

//取得XML中重複項目的值
public String[][] GetXMLNodesValue(String sXML, String sElement){
	/**************************************************************************
	sXml:		XML字串，例如："<BscXmlApi><GetPOSSinglePromotionRes><RequestId>20120206-141330-8799-1</RequestId><ResultCode>00000</ResultCode><ResultText>success</ResultText><SinglePromotion><PromotionId>4927</PromotionId><PromotionCode>121213</PromotionCode><PromotionName>暢打300_上網399</PromotionName><GrpSeq>1</GrpSeq><ItemId>13646</ItemId><ItemCode>1WHTDEHD1002K</ItemCode><ItemName>HTC Desire HD 簡配 黑色</ItemName><SalesQty>2</SalesQty><ItemPrice>28000</ItemPrice><DiscountAmt>12990</DiscountAmt><ItemVendorId>84</ItemVendorId><ItemVendorName>HTC</ItemVendorName><ItemModel>Desire HD</ItemModel><ColorCode>黑色</ColorCode><DetailRemark></DetailRemark></SinglePromotion><SinglePromotion><PromotionId>4927</PromotionId><PromotionCode>121213</PromotionCode><PromotionName>暢打300_上網399</PromotionName><GrpSeq>1</GrpSeq><ItemId>14164</ItemId><ItemCode>1WHTDESS1002B</ItemCode><ItemName>HTC Desire S 簡配 藍色</ItemName><SalesQty>1</SalesQty><ItemPrice>26100</ItemPrice><DiscountAmt>11090</DiscountAmt><ItemVendorId>84</ItemVendorId><ItemVendorName>HTC</ItemVendorName><ItemModel>Desire S</ItemModel><ColorCode>藍色</ColorCode><DetailRemark></DetailRemark></SinglePromotion></GetPOSSinglePromotionRes></BscXmlApi>"
	sElement:	欲尋找的項目，例如："SinglePromotion"
	回覆String值: 例如："20120206-141330-8799-1"
	**************************************************************************/
	String[][] ss = null;
	try{
		DocumentBuilderFactory	docFactory	= DocumentBuilderFactory.newInstance();
		DocumentBuilder			docBuilder	= docFactory.newDocumentBuilder();
		Document				document	= docBuilder.parse(new InputSource(new StringReader(sXML)));
		Element					rootElement	= document.getDocumentElement();
		
		NodeList	nl		= null;
		NodeList	nlChild	= null;
		Node		n		= null;
		Node		nChild	= null;
		int i;
		int j;
		int k;
		int l;
		
		//這是取得多個Node的值--start
		nl = rootElement.getElementsByTagName(sElement);
		i = nl.getLength();
		if (i>0){
			n = nl.item(0);
			nlChild = n.getChildNodes();
			k = nlChild.getLength();
			if (k>0){
				ss = new String[i][k];
				for (j=0;j<i;j++){
					n = nl.item(j);	//每個n是一個sElement的項目，例如：<PromotionId>4927</PromotionId><PromotionCode>121213</PromotionCode><PromotionName>暢打300_上網399</PromotionName><GrpSeq>1</GrpSeq><ItemId>13646</ItemId><ItemCode>1WHTDEHD1002K</ItemCode><ItemName>HTC Desire HD 簡配 黑色</ItemName><SalesQty>2</SalesQty><ItemPrice>28000</ItemPrice><DiscountAmt>12990</DiscountAmt><ItemVendorId>84</ItemVendorId><ItemVendorName>HTC</ItemVendorName><ItemModel>Desire HD</ItemModel><ColorCode>黑色</ColorCode><DetailRemark></DetailRemark>
					nlChild = n.getChildNodes();
					k = nlChild.getLength();
					if (k>0){
						for(l=0;l<k;l++){
							nChild = nlChild.item(l);	//每個nChild是一個sElement中的小項目，例如：<PromotionId>4927</PromotionId>
							ss[j][l] = nChild.getTextContent();
						}	//for(l=0;l<k;l++){
					}	//if (k>0){
				}	//for (j=0;j<i;j++){
			}	//if (k>0){
		}	//if (i>0){
		//這是取得多個Node的值--end
	}catch(Exception e){
		ss = null;
	}
	return ss;
}	//public String[][] GetNodesValue(String sXML, String sElement){

/*********************************************************************************************************************/

//組合要回覆給Client端的XML內容
public String ComposeXMLResponse(String sResultCode, String sResultText, String sData){
	String s = "";
	if (sResultCode == null)	sResultCode = "";
	if (sResultText == null)	sResultText = "";
	if (sData == null)			sData = "";
	/*
	s = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" + "\n";	//XML表頭宣告
	s = s + "<ServerResponse>" + "\n";
	s = s + "<ResultCode>" + sResultCode + "</ResultCode>" + "\n";
	s = s + "<ResultText>" + sResultText + "</ResultText>" + "\n";
	s = s + "<ResultData>" + "\n";
	s = s + sData + "\n";
	s = s + "</ResultData>" + "\n";
	s = s + "</ServerResponse>";
	*/
	s = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";	//XML表頭宣告
	s = s + "<ServerResponse>";
	s = s + "<ResultCode>" + sResultCode + "</ResultCode>";
	s = s + "<ResultText>" + sResultText + "</ResultText>";
	s = s + "<ResultData>";
	s = s + sData;
	s = s + "</ResultData>";
	s = s + "</ServerResponse>";
	return s;
}

/*********************************************************************************************************************/

//將字串中的特殊字元改為全型
public String convertSpecialLetter(String sOld){
	String s = "";
	if (beEmpty(sOld)) return "";
	s = sOld.replace("+", "＋");
	s = s.replace("%", "％");
	s = s.replace("&", "＆");
	s = s.replace("™", "(tm)");
	return s;
}

/*********************************************************************************************************************/
//將金額字串加上千位的逗點
public String toCurrency(String s){
	if (beEmpty(s))		return "";	//字串為空
	if (!isNumeric(s))	return s;	//不是數字，回覆原字串
	
	int i = 0;
	int j = 0;
	int k = 0;
	int l = 0;
	String s2 = "";
	//s = trim(s);
	i = s.length();			//i為字串長度
	if (i<4) return s;		//長度太短，不用加逗點，直接回覆原字串
	j = (int)Math.floor(i/3);	//j為字串長度除以3的商數
	k = i % 3;				//k為字串長度除以3的餘數
	s2 = "";
	if (k>0) s2 = s.substring(0, k);
	for (l=0;l<j;l++){
		s2 = s2 + (s2==""?"":",") + s.substring(k+(l*3), k+(l+1)*3);
	}
	return s2;
}

/*********************************************************************************************************************/
//判斷字串內容是否為數字
public java.lang.Boolean isNumeric(String number) { 
	try {
		Integer.parseInt(number);
		return true;
	}catch (NumberFormatException sqo) {
		return false;
	}
}

/*******************************************************************************
以下為使用 MSP API 時所需的各個函數
*******************************************************************************/

//發送簡訊給 MSP API
public Hashtable sendToMSP(String txtURL, String txtRequestId, String txtClientId, String txtClientUserName, 
							String txtClientPassword, String txtTariffId, String txtMSISDNList, String txtBody){
	/************************************
	txtURL：MSP server網址
	txtRequestId：RequestId
	txtClientId：ClientId
	txtClientUserName：ClientUserName
	txtClientPassword：ClientPassword
	txtTariffId：TariffId
	txtMSISDNList：門號清單，若為多個門號的話須以逗號(,)分隔
	txtBody：簡訊內文，可為單則簡訊或長簡訊
	*************************************/
	
	Hashtable htResponse = new Hashtable();	//儲存回覆資料的 hash table	
	String txtPostContent = "";	//要 post 給 MSP 的內容

	boolean bMultiSMS = false;	//判斷是否有多個收件人，bMultiSMS=true表示有多個收件人
	boolean bLongSMS = false;	//判斷是否為長簡訊
	boolean bChineseSMS = true;	//判斷是否為中文簡訊
	
	String s = "";
	int i;

	bChineseSMS = hasChinese(txtBody);	//判斷是否為中文簡訊
	
	txtMSISDNList = txtMSISDNList.replace(";", ",");
	if (txtMSISDNList.lastIndexOf(",")>0) bMultiSMS = true;	//判斷是否有多個收件人，bMultiSMS=true表示有多個收件人
	
	if (bChineseSMS == true){	//中文簡訊，看長度是否超過70
		if (txtBody.length()>70) bLongSMS = true;
	}else{	//英文簡訊，看長度是否超過160
		if (txtBody.length()>160) bLongSMS = true;
	}
	
	//將簡訊內文以 Base64 進行編碼
	String txtBodyBase64 = "";
	try{
		txtBodyBase64 = new sun.misc.BASE64Encoder().encode(txtBody.getBytes("utf-8"));
	}catch(UnsupportedEncodingException e){
		txtBodyBase64 = new sun.misc.BASE64Encoder().encode(txtBody.getBytes());
	}

	String xml = "<MspXmlApi>";
	
	if (bLongSMS == false && bMultiSMS == false) xml = xml + "<SmsSubmitReq>";			//單則簡訊 & 一個收件人
	if (bLongSMS == false && bMultiSMS == true) xml = xml + "<SmsSubmitMultiReq>";		//單則簡訊 & 多個收件人
	if (bLongSMS == true && bMultiSMS == false) xml = xml + "<SmsSubmitLongReq>";		//長簡訊 & 一個收件人
	if (bLongSMS == true && bMultiSMS == true) xml = xml + "<SmsSubmitMultiLongReq>";	//長簡訊 & 多個收件人

	xml = xml + "<RequestId>" + txtRequestId + "</RequestId>";
	xml = xml +	"<ClientId>" + txtClientId + "</ClientId>";
	xml = xml +	"<ClientUserName>" + txtClientUserName + "</ClientUserName>";
	xml = xml +	"<ClientPassword>" + txtClientPassword + "</ClientPassword>";
	xml = xml +	"<TariffId>" + txtTariffId + "</TariffId>";
	
	if (bMultiSMS == true){	//有多個收件人
		s = getMSISDNXML(txtMSISDNList);
		if (s.length()==0){	//門號有誤
			htResponse.put("xml", "");	//傳給MSP的XML (未傳送，填入空字串)
			htResponse.put("response", "");
			htResponse.put("ResultCode", "99997");
			//htResponse.put("ResultText", "門號格式錯誤");	//奇怪，中文顯示好像有問題
			htResponse.put("ResultText", "Phone number format is incorrect");
			htResponse.put("messagecount", "0");
			htResponse.put("recipientcount", "0");
			return htResponse;
		}
		xml = xml + s;
		i = s.length()/54;
		htResponse.put("recipientcount", i);
		s = "";
	}else{	//單一收件人
		xml = xml + "<ToAddress>" + txtMSISDNList + "</ToAddress>";
		htResponse.put("recipientcount", "1");
	}	//if (bMultiSMS == true){	//有多個收件人
	
	if (bChineseSMS == true){	//中文簡訊
		xml = xml +	"<Charset>utf8</Charset>";
	}else{	//英文簡訊
		xml = xml +	"<Charset>ascii</Charset>";
	}
	
	xml = xml +	"<SmsEncoding>base64</SmsEncoding>";
	xml = xml +	"<SmsBody>" + txtBodyBase64 + "</SmsBody>";

	if (bLongSMS == false && bMultiSMS == false) xml = xml + "</SmsSubmitReq>";			//單則簡訊 & 一個收件人
	if (bLongSMS == false && bMultiSMS == true) xml = xml + "</SmsSubmitMultiReq>";		//單則簡訊 & 多個收件人
	if (bLongSMS == true && bMultiSMS == false) xml = xml + "</SmsSubmitLongReq>";		//長簡訊 & 一個收件人
	if (bLongSMS == true && bMultiSMS == true) xml = xml + "</SmsSubmitMultiLongReq>";	//長簡訊 & 多個收件人

	xml = xml +	"</MspXmlApi>";

	txtPostContent = "xml=" + URLEncoder.encode(xml);

	try
	{
		URL u;
		u = new URL(txtURL);
		HttpURLConnection uc = (HttpURLConnection)u.openConnection();
		uc.setRequestMethod("POST");
		uc.setDoOutput(true);
		uc.setDoInput(true);
		uc.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
		uc.setAllowUserInteraction(false);
		DataOutputStream dstream = new DataOutputStream(uc.getOutputStream());
		dstream.writeBytes(txtPostContent);
		dstream.close();
		InputStream in = uc.getInputStream();
		BufferedReader r = new BufferedReader(new InputStreamReader(in));
		StringBuffer buf = new StringBuffer();
		String line;
		while ((line = r.readLine())!=null) {
			buf.append(line);
		}
		in.close();
		s = buf.toString();	//正常取得MSP回應值
		
		htResponse.put("xml", xml);	//傳給MSP的XML (還未被Base64 encoded)
		htResponse.put("response", s);	//MSP回應的XML
		
		if (s.indexOf("<ResultCode>")>0 && s.indexOf("</ResultCode>")>0){	//MSP有回應ResultCode
			htResponse.put("ResultCode", s.substring(s.indexOf("<ResultCode>")+12,s.indexOf("</ResultCode>")));	//MSP回應的ResultCode
		}else{
			htResponse.put("ResultCode", "99999");	//無法取得MSP回應的ResultCode，自行設為99999
		}	//if (s.indexOf("<ResultCode>")>0 && s.indexOf("</ResultCode>")>0){	//MSP有回應ResultCode

		if (s.indexOf("<ResultText>")>0 && s.indexOf("</ResultText>")>0){	//MSP有回應ResultText
			htResponse.put("ResultText", s.substring(s.indexOf("<ResultText>")+12,s.indexOf("</ResultText>")));	//MSP回應的ResultText
		}else{
			htResponse.put("ResultText", "99999未知的錯誤");	//無法取得MSP回應的ResultText，自行設為99999未知的錯誤
		}	//if (s.indexOf("<ResultText>")>0 && s.indexOf("</ResultText>")>0){	//MSP有回應ResultText
		
		if (bLongSMS == false){	//單則簡訊
			htResponse.put("messagecount", "1");
		}else{	//多則簡訊
			if (s.indexOf("<MessageCount>")>0 && s.indexOf("</MessageCount>")>0){	//MSP有回應MessageCount
				htResponse.put("messagecount", s.substring(s.indexOf("<MessageCount>")+14,s.indexOf("</MessageCount>")));	//MSP回應的MessageCount
			}else{
				htResponse.put("messagecount", "0");	//無法取得MSP回應的MessageCount，自行設為0
			}	//if (s.indexOf("<MessageCount>")>0 && s.indexOf("</MessageCount>")>0){	//MSP有回應MessageCount
		}	//if (bLongSMS == false){	//單則簡訊
	}catch (IOException e){ 
		s = "連線錯誤，訊息如下：" + e.toString();
		htResponse.put("xml", xml);	//傳給MSP的XML (還未被Base64 encoded)
		htResponse.put("response", "");
		htResponse.put("ResultCode", "99998");
		htResponse.put("ResultText", s);
		htResponse.put("messagecount", "0");
	}
	
	if (!htResponse.get("ResultCode").toString().equals(gcResultCodeSuccess)){
		writeToFile("Send SMS 失敗:" + htResponse.get("ResultCode").toString() + ", " + htResponse.get("ResultText").toString() + "||RequestId=" + txtRequestId + "||To=" + txtMSISDNList + "||Body=" + txtBody);
	}
	return htResponse;
}	////發送簡訊給 MSP API

public String getMSISDNXML(String s){		//將以逗號分割的門號列表轉換成MSP API中的XML內容，每個門號的格式為 <Receiver><ToAddress>0986543210</ToAddress></Receiver>
/*
	int i;
	int j;
	int x;
	int iCount = 0;
	String sMSISDN = "";
*/
	String sNew = "";

	sNew = s.replace(",", "</ToAddress></Receiver><Receiver><ToAddress>");
	sNew = "<Receiver><ToAddress>" + sNew + "</ToAddress></Receiver>";
	sNew = sNew.replace("<Receiver><ToAddress></ToAddress></Receiver>", "");	//去除空白門號

/*
	s = s.replace(" ", "");	//去除空白
	i = s.indexOf(",");
	j = 0;
	x = s.length();

	while (i>-1 && i<x){
		if (iCount==0){
			sMSISDN = s.substring(j, i);
		}else{
			sMSISDN = s.substring(j+1, i);	//第二個號碼開始要跳過逗號的位置
		}	//if (iCount==0){
		if (sMSISDN.length()==10){
			if (sMSISDN.substring(0,2).equals("09")){	//不是行動電話號碼
				sNew = sNew + "<Receiver><ToAddress>" + sMSISDN + "</ToAddress></Receiver>";
			}else{
				sNew = "";
				break;
			}	//if (sMSISDN.substring(0,2).equals("09")){
		}else{	//碼長錯誤
			sNew = "";
			break;
		}	//if (sMSISDN.length()==10){
		
		iCount = iCount+1;
		j = i;
		i = s.indexOf(",", i+1);
		if (i<0 && s.length()>j+5){	//目前已經是最後一個逗號了，逗號右邊還有一個號碼
			sMSISDN = s.substring(j+1, s.length());
			sNew = sNew + "<Receiver><ToAddress>" + sMSISDN + "</ToAddress></Receiver>";
			iCount = iCount+1;
		}	//if (i<0 && s.length()>j+5){	//目前已經是最後一個逗號了，逗號右邊還有一個號碼
	}	//while (i>-1 && i<x){
	
	if (s.lastIndexOf(",")==s.length()-1) sNew="";	//字串最右邊是逗號
*/
	return sNew;
}	//public String getMSISDNXML(String s){		//將以逗號分割的門號列表轉換成MSP API中的XML內容，每個門號的格式為 <Receiver><ToAddress>0986543210</ToAddress></Receiver>

public boolean hasChinese(String value) {	//判斷是否為中文字串
	int n = 0;
	int c = 0;
	
	if (value.length() == 0) {
		return false;
	}
	for(n=0; n < value.length(); n++) {
		//c=value.charCodeAt(n);
		c=value.charAt(n);
		if (c>127) {
			return true;
		}
	}
	return false;
}	//public boolean hasChinese(String value) {	//判斷是否為中文字串

/*******************************************************************************
以上為使用 MSP API 時所需的各個函數
*******************************************************************************/

/*********************************************************************************************************************/

//發送HTML格式的信件(含附件)
public java.lang.Boolean sendHTMLMail(String sSMTPServer, String sFromEmail, String sFromName, String sToEmail, String sSubject, String sBody){
	return sendHTMLMail(sSMTPServer, sFromEmail, sFromName, sToEmail, sSubject, sBody, "", "");
}
public java.lang.Boolean sendHTMLMail(String sSMTPServer, String sFromEmail, String sFromName, String sToEmail, String sSubject, String sBody, String sFiles){
	return sendHTMLMail(sSMTPServer, sFromEmail, sFromName, sToEmail, sSubject, sBody, sFiles, "");
}
public java.lang.Boolean sendHTMLMail(String sSMTPServer, String sFromEmail, String sFromName, String sToEmail, String sSubject, String sBody, String sFiles, String sBcc){
	/*************************************************************************
		sSMTPServer:	SMTP server的 IP
		sFromEmail:		寄件者的 email address
		sFromName:		寄件者名稱，若輸入空字串則設為與 sFromEmail 相同值
		sToEmail:		收件人 email address，若有多個收件人則以【;】區隔
		sSubject:		信件主旨
		sBody:			信件內容 HTML，從<html><head>至</body></html>
		sFiles:			附件
		sBcc:			BCC的 email address，若有多個BCC收件人則以【;】區隔
		回覆值:			執行成功回覆 true，失敗時回覆 false
	*************************************************************************/
	java.lang.Boolean	bOK		= true;
	String[]			aTo		= null;
	String[]			aBcc	= null;
	String[]			aFile	= null;
	int					i		= 0;
	
	if (beEmpty(sSMTPServer) || beEmpty(sFromEmail) || beEmpty(sFromName) || beEmpty(sToEmail) || beEmpty(sSubject) || beEmpty(sBody)){
		return false;
	}
	
	sToEmail = sToEmail.replace(",", ";");
	aTo = sToEmail.split(";");
	if (aTo.length<1){
		return false;
	}
	
	//BCC 收件人
	if (notEmpty(sBcc)){
		sBcc = sBcc.replace(",", ";");
		aBcc = sBcc.split(";");
	}

	//附件
	if (notEmpty(sFiles)){
		aFile = sFiles.split(";");
	}
	
	try{
		try{
			Properties props = new Properties();
			props.put("mail.smtp.host", sSMTPServer);
			//props.put("mail.smtp.auth", "true");	//需要認證則為 true，記得在transport.connect的後兩個參數填入 id、pwd
			Session s = Session.getInstance(props);
			//s.setDebug(true);	//需要 debug 時再打開
			
			javax.mail.internet.MimeMessage message = new MimeMessage(s);
			
			//設定發信人/收信人/主題/發信時間
			if (beEmpty(sFromName)) sFromName = sFromEmail;
			InternetAddress from = new InternetAddress(sFromEmail, sFromName, "utf-8");
			message.setFrom(from);
			//message.setSender(new InternetAddress(sFromEmail));
			/*
			InternetAddress[] replyAddrs = new InternetAddress[1];
			replyAddrs[0] = new InternetAddress(sFromEmail, sFromName, "utf-8");
			message.setReplyTo(replyAddrs);
			*/
			
			InternetAddress[] mailAddrs = new InternetAddress[aTo.length];
			for (i=0;i<aTo.length;i++){
				 mailAddrs[i] = new InternetAddress(aTo[i].toLowerCase(), aTo[i], "utf-8");	//第一個參數是email，第二個參數是收件人名稱，第三個參數是encoding
			}
			message.setRecipients(javax.mail.Message.RecipientType.TO, mailAddrs);
			
			if (aBcc!=null && aBcc.length>0){	//BCC收件人
				InternetAddress[] mailAddrsBcc = new InternetAddress[aBcc.length];
				for (i=0;i<aBcc.length;i++){
					 mailAddrsBcc[i] = new InternetAddress(aBcc[i].toLowerCase(), aBcc[i], "utf-8");	//第一個參數是email，第二個參數是收件人名稱，第三個參數是encoding
				}
				message.setRecipients(javax.mail.Message.RecipientType.BCC, mailAddrsBcc);
			}	//if (aBcc!=null && aBcc.length>0){	//BCC收件人
			
			message.setSubject(sSubject, "utf-8");
			message.setSentDate(new java.util.Date());
			
			//給消息對像設置內容
			BodyPart mdp = new MimeBodyPart();//新建一個存放信件內容的BodyPart對像
			mdp.setContent(sBody, "text/html;charset=utf-8");//給BodyPart對像設置內容和格式/編碼方式
			Multipart mm = new MimeMultipart();//新建一個MimeMultipart對像用來存放BodyPart對象(事實上可以存放多個)
			mm.addBodyPart(mdp);//將BodyPart加入到MimeMultipart對像中(可以加入多個BodyPart)
			
			//設定附件
			if (aFile!=null && aFile.length>0){	//可能有多個附件
				for (i=0;i<aFile.length;i ++ ){
					mdp = new  MimeBodyPart(); 
					FileDataSource fileds = new  FileDataSource (aFile[i]); 
					mdp.setDataHandler( new  DataHandler(fileds)); 
					mdp.setFileName(fileds.getName()); 
					mm.addBodyPart(mdp); 
				} 
			}	//if (aFile!=null && aFile.length>0){	//可能有多個附件

			message.setContent(mm);//把mm作為消息對象的內容
			
			message.saveChanges();
			Transport transport = s.getTransport("smtp");
			transport.connect(gcDefaultEmailSMTPServer, "", "");
			transport.sendMessage(message, message.getAllRecipients());
			transport.close();
		}catch(UnsupportedEncodingException e){
			bOK = false;
		}
	}catch(javax.mail.MessagingException e){
		writeToFile("sendHTMLMail 失敗:" + e.toString());
		bOK = false;
	}
	if (!bOK) writeToFile("Send Mail 失敗||To=" + sToEmail + "||Subject=" + sSubject);
	return bOK;
}

/*********************************************************************************************************************/
//取得系統通知信的收件人名單
public String getManagerMailList(){
	Hashtable	ht				= new Hashtable();
	String		sResultCode		= gcResultCodeSuccess;
	String		sResultText		= gcResultTextSuccess;
	String		s[][]		= null;
	String		sSQL		= "";
	int			iColCount	= 0;
	String		ss			= "";
	int			i			= 0;
	iColCount = 1;
	sSQL = "select AccountEmail from MV_AccountList where LoginRole='2' or LoginRole='9'";	//取得email清單
	ht = getDBData(sSQL, iColCount);
	sResultCode = ht.get("ResultCode").toString();
	if (sResultCode.equals(gcResultCodeSuccess)){	//有資料
		s = (String[][])ht.get("Data");
		ss = s[0][0];
		for (i=1;i<s.length;i++){
			ss += ";" + s[i][0];
		}
	}	//if (sResultCode.equals(gcResultCodeSuccess)){	//有資料
	return ss;
}	//public String getManagerMailList(){

/*********************************************************************************************************************/
//取得最後編輯過某個訊息的人的email
public String getLastModifiedPersonMail(String sMessageId){
	Hashtable	ht				= new Hashtable();
	String		sResultCode		= gcResultCodeSuccess;
	String		sResultText		= gcResultTextSuccess;
	String		s[][]		= null;
	String		sSQL		= "";
	int			iColCount	= 0;
	String		sLastModifiedPerson	= "";
	String		ss			= "";
	int			i			= 0;
	iColCount = 1;
	sSQL = "select LastModifiedPerson from MV_MessageList where MessageId='" + sMessageId + "'";
	ht = getDBData(sSQL, iColCount);
	sResultCode = ht.get("ResultCode").toString();
	if (sResultCode.equals(gcResultCodeSuccess)){	//有資料
		s = (String[][])ht.get("Data");
		sLastModifiedPerson = s[0][0];
	}else{
		return "";
	}	//if (sResultCode.equals(gcResultCodeSuccess)){	//有資料
	sSQL = "select AccountEmail from MV_AccountList where LoginId='" + sLastModifiedPerson + "'";	//取得email清單
	ht = getDBData(sSQL, iColCount);
	sResultCode = ht.get("ResultCode").toString();
	if (sResultCode.equals(gcResultCodeSuccess)){	//有資料
		s = (String[][])ht.get("Data");
		ss = s[0][0];
	}	//if (sResultCode.equals(gcResultCodeSuccess)){	//有資料
	return ss;
}	//public String getLastModifiedPersonMail(sMessageId){

/*********************************************************************************************************************/


%>