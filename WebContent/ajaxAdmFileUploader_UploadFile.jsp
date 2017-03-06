<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>


<%@ page import="java.net.*" %>
<%@ page import="java.io.*,java.awt.Image,java.awt.image.*,com.sun.image.codec.jpeg.*" %>

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
String sMessageId="";
sMessageId = (String)session.getAttribute("FileUploader_MessageId");	//取得訊息編號
if (beEmpty(sMessageId)){
	out.println("無法取得訊息編號，可能為網頁閒置過久!");
	return;
}


String		sId				= "";	//目前的圖檔類別，1:標題圖檔、2:內文圖檔
sId = (String)session.getAttribute("FileUploader_PicIndex");	//取得圖檔索引

Boolean bOK = true;

// 上傳之後的檔保存在這個檔夾下
//String filepath = this.getServletContext().getRealPath("")+java.io.File.separator+"picture"+java.io.File.separator;
String filepath = gcBasePathForFileUpload;
String filename = "";
String type="";
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
	    int j = filename.lastIndexOf("\"");
	    int p = filename.lastIndexOf("."); 
	    //文件類型
	    type = filename.substring(p,j);
	    type = type.toLowerCase();
	    if (type.indexOf("jpg")>0 || type.indexOf("gif")>0 || type.indexOf("png")>0 || type.indexOf("bmp")>0){
		    //檔案名稱
		    //filename = System.currentTimeMillis()+type;  
		    filename = sMessageId + "-" + sId + type;

		    DataOutputStream fileStream = new DataOutputStream(
			new BufferedOutputStream(new FileOutputStream(filepath + filename))
		    );
			
		    len = in.readLine(buf, 0, buf.length); 
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
		    //檔案增加亂數避免cache
			result = "newfilename:" + gcURLForUploadedFile + filename + "?" + UUID.randomUUID().toString();

	    }else{	//上傳的檔案不是圖檔
	    	result = "上傳檔案格式錯誤，請上傳jpg、gif、png、bmp格式的圖檔!!";
	    	bOK = false;
	    	break;
	    }	//if (type.equals("jpg") || type.equals("gif") || type.equals("png") || type.equals("bmp")){

	}	//while ((len = in.readLine(buf, 0, buf.length)) != -1) {
	in.close();
}catch(Exception e){
	bOK = false;
	result = e.toString();
	writeToFile("系統錯誤!||Function=FileUploader_UploadFile.jsp||參數filepath=" + filepath + "||錯誤描述=" + e.toString());
}	//try{


//-----------------------上傳完成，開始產生縮圖-------------------------    
//參考網址：http://rritw.com/a/caozuoxitong/OS/20110923/130269.html
/*************20120824改為人工縮圖***********************/
/*
if (bOK){	//大圖上傳成功
	try{
		java.io.File file = new java.io.File(filepath+ filename);        //讀入剛才上傳的文件
		//String newurl=request.getRealPath("/")+url+filename+"_min."+ext;  //新的縮略圖保存地址
		String newurl = filepath + sItemCode + "-" + sPicIndex + "_s" + type;
		Image src = javax.imageio.ImageIO.read(file);                     //構造Image對象
		float tagsize=gcLongSideLengthOfItemThumbImage;
		int old_w=src.getWidth(null);                                     //得到源圖寬
		int old_h=src.getHeight(null);   
		int new_w=0;
		int new_h=0;                            //得到源圖長
		int tempsize;
		float tempdouble; 
		
		if(old_w>old_h){
			tempdouble=old_w/tagsize;
		}else{
			tempdouble=old_h/tagsize;
		}
		new_w=Math.round(old_w/tempdouble);
		new_h=Math.round(old_h/tempdouble);//計算新圖長寬
		BufferedImage tag = new BufferedImage(new_w,new_h,BufferedImage.TYPE_INT_RGB);
		tag.getGraphics().drawImage(src,0,0,new_w,new_h,null);       //繪制縮小後的圖
		FileOutputStream newimage=new FileOutputStream(newurl);          //輸出到文件流
		JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(newimage);       
		encoder.encode(tag);                                               //近JPEG編碼
		newimage.close();
		result = result + "thumb:" + sItemCode + "-" + sPicIndex + "_s" + type;
	}catch(Exception e){
		bOK = false;
		result = "產生縮圖時發生錯誤：" + e.toString();
		//要不要刪除大圖啊？
		writeToFile("系統錯誤!||Function=FileUploader_Item.jsp||參數filepath=" + filepath + "||縮圖時錯誤，錯誤描述=" + e.toString());
	}
}	//if (bOK){	//大圖上傳成功
*/
	out.print(result);
%>