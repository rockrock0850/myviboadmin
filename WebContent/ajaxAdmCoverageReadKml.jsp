<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>


<%@ page import="java.net.*" %>
<%@ page import="java.util.Date.*" %>
<%@ page import="java.io.*,java.awt.Image,java.awt.image.*" %>
<%@ page import="javax.imageio.ImageIO" %>

<%-- <%@ page import="com.sun.image.codec.jpeg.*,com.jspsmart.upload.*,java.util.*" %> --%>

<%@include file="00_constants.jsp"%>
<%@include file="00_utility.jsp"%>

<%
request.setCharacterEncoding("utf-8");
response.setContentType("text/html;charset=utf-8");
response.setHeader("Pragma","no-cache"); 
response.setHeader("Cache-Control","no-cache"); 
response.setDateHeader("Expires", 0); 


/*****************************************************************************/

//以下為處理程序本體
String name = "";
String type = ".KML";

Boolean bOK = true;

// 上傳之後的檔保存在這個檔夾下
//String filepath = this.getServletContext().getRealPath("")+java.io.File.separator+"picture"+java.io.File.separator;
String filepath = gcBasePathForFileUpload;
String filename = "";
String result = "";

//注意：若有新的圖片類別，要記得在這裡加入該圖片類別的路徑
filepath = gcBasePathForFileUpload;

 try{
	ServletInputStream in = request.getInputStream();
	byte[] buf = new byte[4048];
	int len = in.readLine(buf, 0, buf.length);
	String f = new String(buf, 0, len - 1); 

	while ((len = in.readLine(buf, 0, buf.length)) != -1) {
		filename = new String(buf, 0, len, "utf-8");
	    //檔案名稱
	    java.util.Date nowDate = new java.util.Date();
	    name = String.valueOf(nowDate.getTime()/1000);
	    filename = name + type;

	    DataOutputStream fileStream = new DataOutputStream(
		new BufferedOutputStream(new FileOutputStream(filepath+ filename))
	    );

	    len = in.readLine(buf, 0, buf.length); 
	    while ((len = in.readLine(buf, 0, buf.length)) != -1) {
	        String tempf = new String(buf, 0, len - 1);
	        if (tempf.equals(f) || tempf.equals(f + "--")) {
	            break;    
	        }
	        else{
			 // 寫入
	        	 fileStream.write(buf, 0, len);
	        }
	    }
	    fileStream.close();
		result = "newfilename:" + gcURLForUploadedFile + filename;

	}	//while ((len = in.readLine(buf, 0, buf.length)) != -1) {
	in.close();
}catch(Exception e){
	bOK = false;
	result = e.toString();
	writeToFile("系統錯誤!||Function=FileUploader_UploadFile.jsp||參數filepath=" + filepath + "||錯誤描述=" + e.toString());
}	//try{

if(bOK){
	String		sResultCode			= gcResultCodeSuccess;
	String		sResultText			= gcResultTextSuccess;
	try{
		FileReader fr = new FileReader(filepath + filename);

		//用BufferedReader 讀取 
		BufferedReader br = new BufferedReader(fr);
		String strLine = "";
		
		StringBuffer sb = new StringBuffer();
		while ((strLine=br.readLine())!=null){
			
		   if(strLine.indexOf("north")>-1){
			   sb.append(strLine);
		   }else if(strLine.indexOf("south")>-1){
			   sb.append(strLine);
		   }else if(strLine.indexOf("west")>-1){
			   sb.append(strLine);
		   }else if(strLine.indexOf("east")>-1){
			   sb.append(strLine);
		   }
		}
		File kmlFile = new File(filepath + filename); 
		if(kmlFile.exists()){
			kmlFile.delete();
		}
		out.println(ComposeXMLResponse(sResultCode, sResultCode, sb.toString()  ));
		//out.println(ComposeXMLResponse(sResultCode, sResultCode, "<south>11</south><west>22</west><north>33</north><east>44</east>"  ));
	}catch(Exception e){
		out.println(ComposeXMLResponse(gcResultCodeUnknownError, gcResultTextUnknownError, ""));		
	}
}
/*
if(bOK){
	File file = new File(filepath + filename);
	DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
	DocumentBuilder db = dbf.newDocumentBuilder();
	Document doc = db.parse(file);
	
} */

	
%>