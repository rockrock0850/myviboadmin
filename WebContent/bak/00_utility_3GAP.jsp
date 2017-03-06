<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>

<%@page import = "java.io.*" %>
<%@page import="java.sql.*" %>
<%@page import="java.naming.*" %>
<%@page import="java.util.*" %>

<%
//Oracle connection
	Class.forName("oracle.jdbc.driver.OracleDriver");
%>

<%!
/*
public static final String	gc3GAPServerName	= "172.20.7.25";	//3GAP DB Server Name
public static final String	gc3GAPServerPort	= "1521";			//3GAP DB Server Port
public static final String	gc3GAPSID			= "SPP";			//3GAP DB Service ID (Name)
public static final String	gc3GAPUserName		= "ecadm";		//3GAP DB User Name
public static final String	gc3GAPPassword		= "ec123";		//3GAP DB Password
*/

/****以下是正式環境*/
public static final String	gc3GAPServerName	= "172.24.0.140";	//3GAP DB Server Name
public static final String	gc3GAPServerPort	= "1521";			//3GAP DB Server Port
public static final String	gc3GAPSID			= "TCSLEE";			//3GAP DB Service ID (Name)
public static final String	gc3GAPUserName		= "mvnotap";		//3GAP DB User Name
public static final String	gc3GAPPassword		= "mvnotap";		//3GAP DB Password


/*********************************************************************************************************************/
// db connection
public Connection DBConnection3GAP(){
        /************************************
        txtServerName: server IP
        txtSid: SID
        txtUserName: user name
        txtPassword: password
        *************************************/
 	 Connection dbcn = null;

        try{
                dbcn = DriverManager.getConnection("jdbc:oracle:thin:@" + gc3GAPServerName+ ":" + gc3GAPServerPort + ":" + gc3GAPSID, gc3GAPUserName, gc3GAPPassword);
                return dbcn;
        }catch (SQLException e){
                return null;
        }       //try{
}       //public Connection doDBConnection(String txtServerName, String txtSid, String txtUserName, String txtPassword){

/*********************************************************************************************************************/

//關閉資料庫連線及相關的ResultSet、Statement
public  void closeDBConnection3GAP(ResultSet rs, Statement stmt, Connection dbconn){
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

/*********************************************************************************************************************/
//依照輸入的SQL statement取得ResultSet，並將ResultSet轉換成String Array回覆給呼叫端
public Hashtable get3GAPDBData(String sSQL, int iColCount){
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
	
	dbconn = DBConnection3GAP();
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
		writeToFile("系統錯誤!||Function=getECDBData||參數:||sSQL=" + sSQL + "||iColCount=" + String.valueOf(iColCount) + "||錯誤描述=" + e.toString());
	}finally{
		//Clean up resources, close the connection.
		closeDBConnection3GAP(rs, stmt, dbconn);
	}	//}finally{
	
	htResponse.put("ResultCode", sResultCode);
	htResponse.put("ResultText", sResultText);
	if (iRowCount>0) htResponse.put("Data", s);
	return htResponse;
}	//public String getECDBData(String sSQL, int iColCount){

/*********************************************************************************************************************/
//依照輸入的SQL statement對DB執行單一insert, update, delete指令，並將執行結果回覆給呼叫端
public Hashtable execSQLOn3GAPDB(String sSQL){
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
	
	dbconn = DBConnection3GAP();
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
		writeToFile("系統錯誤!||Function=execSQLOnECDB||參數:||sSQL=" + sSQL + "||錯誤描述=" + e.toString());
	}finally{
		//Clean up resources, close the connection.
		closeDBConnection3GAP(null, stmt, dbconn);
	}	//}finally{
	
	htResponse.put("ResultCode", sResultCode);
	htResponse.put("ResultText", sResultText);
	return htResponse;
}	//public String getECDBData(String sSQL, int iColCount){

/*********************************************************************************************************************/
//依照輸入的SQL statement對DB執行多個insert, update, delete指令(可指定是否需每個指令自動commit)，並將執行結果回覆給呼叫端
public Hashtable execMultiSQLOn3GAPDB(String sSQL[], Boolean bAutoCommit){
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
	
	dbconn = DBConnection3GAP();
	if (dbconn==null){	//資料庫連線失敗
		htResponse.put("ResultCode", gcResultCodeDBTimeout);
		htResponse.put("ResultText", gcResultTextDBTimeout);
		return htResponse;
	}	//if (dbconn==null){	//資料庫連線失敗

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
			writeToFile("系統錯誤!||Function=execMultiSQLOnECDB(無法執行rollback)||參數:||已執行的sSQL=" + s + "||錯誤描述=" + e1.toString());
		};
		sResultCode = gcResultCodeUnknownError;
		sResultText = e.toString();
		writeToFile("系統錯誤!||Function=execMultiSQLOnECDB||參數:||已執行的sSQL=" + s + "||錯誤描述=" + e.toString());
	}finally{
		try{
			dbconn.setAutoCommit(true);
		}catch(SQLException e2){
			writeToFile("系統錯誤!||Function=execMultiSQLOnECDB(無法將AutoCommit設為true)||參數:||已執行的sSQL=" + s + "||錯誤描述=" + e2.toString());
		}
		//Clean up resources, close the connection.
		closeDBConnection3GAP(null, stmt, dbconn);
	}	//}finally{
	
	htResponse.put("ResultCode", sResultCode);
	htResponse.put("ResultText", sResultText);
	return htResponse;
}	//public Hashtable execMultiSQLOnECDB(String sSQL[], Boolean bAutoCommit){

/*********************************************************************************************************************/
//檢查用戶門號密碼是否正確
public String DoAuthCheck(String sRequestXML){	//不使用
	String		sRequestId		= "";
	String		sMSISDN			= "";
	String		sPassword		= "";
	String		sResponse		= "<BscXmlApi><DoAuthCheckRes><RequestId>99999999-999999-9999-9</RequestId><ResultCode>00004</ResultCode><ResultText>傳入之參數不足</ResultText><ContractId></ContractId><CustomerId></CustomerId></DoAuthCheckRes></BscXmlApi>";
	String		sSQL			= "";
	Hashtable	ht				= new Hashtable();
	String		sResultCode		= gcResultCodeSuccess;
	String		sResultText		= gcResultTextSuccess;
	int			iColCount		= 0;
	String[][]	s				= null;
	String		sContractId		= "";
	String		sCustomerId		= "";
	
	if (beEmpty(sRequestXML)) return sResponse;

	sRequestId = GetXMLSingleValue(sRequestXML, "RequestId");
	sMSISDN = GetXMLSingleValue(sRequestXML, "MSISDN");
	sPassword = GetXMLSingleValue(sRequestXML, "Password");
	if (beEmpty(sRequestId) || beEmpty(sMSISDN) || beEmpty(sPassword)) return sResponse;
	
	iColCount = 2;
	sSQL = "select contractid, custid from tap_usermain";
	sSQL += " where msisdn='" + sMSISDN + "'";
	sSQL += " and password='" + sPassword + "'";
	sSQL += " and operatorid='01'";
	sSQL += " and userstate=0";
	//writeToFile(sSQL);
	ht = get3GAPDBData(sSQL, iColCount);
	sResultCode = ht.get("ResultCode").toString();
	sResultText = ht.get("ResultText").toString();
	if (sResultCode.equals(gcResultCodeSuccess)){
		s = (String[][])ht.get("Data");
		if (s!=null && s.length>0){	//找到資料
			sContractId = s[0][0];
			sCustomerId = s[0][1];
		}
	}	//if (sResultCode.equals(gcResultCodeSuccess)){
	
	if (notEmpty(sContractId) && notEmpty(sCustomerId)){
		sResponse	= "<BscXmlApi><DoAuthCheckRes><RequestId>" + sRequestId + "</RequestId><ResultCode>00000</ResultCode><ResultText>Success</ResultText><ContractId>" + sContractId + "</ContractId><CustomerId>" + sCustomerId + "</CustomerId></DoAuthCheckRes></BscXmlApi>";
	}else{
		sResponse	= "<BscXmlApi><DoAuthCheckRes><RequestId>" + sRequestId + "</RequestId><ResultCode>00006</ResultCode><ResultText>找不到符合條件的資料</ResultText><ContractId></ContractId><CustomerId></CustomerId></DoAuthCheckRes></BscXmlApi>";
	}
	
	return sResponse;
}

public String DoAuthCheck_new(String sRequestXML){
	/**********************有資料了，開始做事吧*********************************************/
	String	sRequestId	= generateRequestId();	//產生呼叫 BSC API 所需的 RequestId
	String	sURL		= gcBSCURL + "GetServiceProfile" + ".jsp?xml=";	//BSC API URL
	String	sXML		= "";									//呼叫BSC的XML內容
	String	sResponse	= "";									//BSC回覆的XML
	boolean bSendToBSC	= true;
	String	sOperatorId	= "";
	
	//組合要送出的XML
	sXML = "<BscXmlApi><GetServiceProfileReq><VASId>" + gcVASId + "</VASId><VASPassword>" + gcVASPassword + "</VASPassword><RequestId>" + sRequestId + "</RequestId>";
	/************************以下是每個BSC API各自的參數************************/
	sXML = sXML + sRequestXML;
	/************************以上是每個BSC API各自的參數************************/
	sXML = sXML + "</GetServiceProfileReq></BscXmlApi>";
	writeToFile(sXML);
	
	try{
		Hashtable htResponse = sendToBSC(sURL, URLEncoder.encode(sXML, "utf-8"));	//呼叫 BSC API
		
		if (htResponse.get("ResultCode").equals(gcResultCodeSuccess)){	//正常回覆，顯示回覆資料內容
			sResponse = htResponse.get("Response").toString();
		}else if (htResponse.get("ResultCode").equals(gcResultCodeNoDataFound)){	//找不到資料，看有沒有OperatorId資料
			sOperatorId = htResponse.get("Response").toString();
			sOperatorId = GetXMLSingleValue(sOperatorId, "OperatorId");
			if (notEmpty(sOperatorId) && (sOperatorId.equals("25") || sOperatorId.equals("26"))){
				sResponse = ComposeXMLResponse(htResponse.get("ResultCode").toString(), "本服務僅供威寶3G用戶使用!", "");
			}else{
				sResponse = ComposeXMLResponse(htResponse.get("ResultCode").toString(), htResponse.get("ResultText").toString(), "");
			}
		}else{
			sResponse = ComposeXMLResponse(htResponse.get("ResultCode").toString(), htResponse.get("ResultText").toString(), "");
		}	//if (htResponse.get("ResultCode").equals(gcResultCodeSuccess)){	//正常回覆，顯示回覆資料內容
	}catch (IOException e){
		sResponse = ComposeXMLResponse(gcResultCodeUnknownError, gcResultTextUnknownError, "");
	}
	
	writeToFile(sResponse);
	
	return sResponse;
}

%>