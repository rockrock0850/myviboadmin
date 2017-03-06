<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>


<%@ page import="java.net.*" %>
<%@ page import="java.io.*,java.io.File,java.awt.Image,java.awt.image.*" %>
<%@ page import="java.awt.Dimension,java.awt.Dimension.*,java.awt.Graphics2D" %>
<%@ page import="javax.imageio.ImageIO" %>
<%@ page import="java.util.*" %>

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
//String mapIdx					= nullToString(request.getParameter("mapIdx"), "");  
//String type						= nullToString(request.getParameter("type"), "");

String mapIdx  =  (String)session.getAttribute("mapIdx");	//0:TW/1:金門/2:馬祖/3:澎湖
String type     =  (String)session.getAttribute("type");	//35G/3G4G/4G
String isTemp	= (String)session.getAttribute("isTemp");	//是否為TEMP圖檔
String loginId  = (String)session.getAttribute("loginId");	//登入者ID

String		sResultCode		= gcResultCodeSuccess;
String		sResultText		= gcResultTextSuccess;


if (beEmpty(mapIdx) || beEmpty(type) ){
	out.println(ComposeXMLResponse(gcResultCodeParametersNotEnough, gcResultTextParametersNotEnough,  "mapIdx="+mapIdx+",type ="+type));
	return;
}

String name = "";
name += type;
switch(Integer.parseInt(mapIdx)){
case 0:
	//TW
	name += "_TW";
	break;
case 1:
	//KM
	name += "_KM";
	break;
case 2:
	//MJ
	name += "_MJ";
	break;
case 3:
	//PH
	name += "_PH";
	break;
default:
	out.println(ComposeXMLResponse(gcResultCodeParametersValidationError, gcResultTextParametersValidationError, ""));
	return;
}

Boolean bOK = true;	//是否上傳或複製成功

// 上傳之後的檔保存在這個檔夾下
//String filepath = this.getServletContext().getRealPath("")+java.io.File.separator+"picture"+java.io.File.separator;
String filepath = gcBasePathForFileUpload;
String filename = "";
String result = "";

//注意：若有新的圖片類別，要記得在這裡加入該圖片類別的路徑
filepath = gcBasePathForFileUpload;

try{
	System.out.println("==========ajaxAdmCoverageUploadFile=========");
	if("true".equals(isTemp)){
		
		System.out.println("==========UPLOAD TEMP PIC=========");
		
		//上傳TEMP圖檔
		ServletInputStream in = request.getInputStream();
		byte[] buf = new byte[4048];
		int len = in.readLine(buf, 0, buf.length);
		System.out.println("len="+len);
		String f = new String(buf, 0, len - 1);
		int maxSize = 1048576;
		int calcSize = 0 ;
		
		
		while ((len = in.readLine(buf, 0, buf.length)) != -1) {
			filename = new String(buf, 0, len, "utf-8");
		    int j = filename.lastIndexOf("\"");
		    int p = filename.lastIndexOf("."); 
		    
		    //檔案名稱
		    //filename = System.currentTimeMillis()+type;  
		    if("true".equals(isTemp)){
		    	SimpleDateFormat  sdf = new SimpleDateFormat ("yyyyMMdd");
		    	java.util.Date date = new java.util.Date();
		    	String dateString = sdf.format(date);
		    	
		    	filename = name + "_" + loginId + "_" + dateString + ".png";
		    }else{
		    	filename = name + ".png";	
		    }
		    

		    DataOutputStream fileStream = new DataOutputStream(
			new BufferedOutputStream(new FileOutputStream(filepath+ filename))
		    );

		    len = in.readLine(buf, 0, buf.length); 
		    len = in.readLine(buf, 0, buf.length); 
		    while ((len = in.readLine(buf, 0, buf.length)) != -1) {
		    	
		    	calcSize += len;
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
		    if(calcSize > maxSize){
		    	sResultCode = "99999";
		    	sResultText = "檔案大小請勿超過1MB";
		    	File delFile = new File(filepath+ filename);
		    	delFile.delete();
		    	bOK = false;
		    }else{
				result += "<url>" + gcURLForUploadedFile + filename +"</url>";
				result += "<filePath>" + gcBasePathForFileUpload + "</filePath>";
				result += "<fileName>" + filename +"</fileName>";
		    }

		}	//while ((len = in.readLine(buf, 0, buf.length)) != -1) {
		in.close();
	}else{
		System.out.println("==========COPY TEMP PIC=========");
		//複製TEMP圖檔
		String tempPath ;	//temp圖檔路徑
		InputStream fis = null;
	    OutputStream fos = null;
		
		SimpleDateFormat  sdf = new SimpleDateFormat ("yyyyMMdd");
    	java.util.Date date = new java.util.Date();
    	String dateString = sdf.format(date);
    	
    	tempPath = name + "_" + loginId + "_" + dateString + ".png";
    	
    	System.out.println("tempFile=" + gcBasePathForFileUpload + tempPath);
    	System.out.println("offFile=" + gcBasePathForFileUpload + name+ ".png");
    	
    	java.io.File tempFile = new java.io.File(gcBasePathForFileUpload + tempPath);
    	java.io.File offFile = new java.io.File(gcBasePathForFileUpload + name+ ".png");
    	if(tempFile.exists()){
    		System.out.println("==========tempFile exists=========");
    		try{
    		//開始複製
    		fos = new FileOutputStream(offFile);
    	    fis = new FileInputStream(tempFile);
    	    byte[] b = new byte[1024];
    	      int off = 0;
    	      int len = 0;
    	      while((len = fis.read(b)) != -1){
    	        fos.write(b,off,len);        
    	      }
    	      fos.flush();
    		}catch(IOException e){
    			System.out.println(e.getMessage());
    			result = e.toString();
    		}finally{
   		      fos.close();
   		      fis.close();
    		}
    		
    		result = "<url>" + gcURLForUploadedFile + name + ".png" +"</url>";
    		result += "<filePath>" + gcBasePathForFileUpload + "</filePath>";
			result += "<fileName>" +  name + ".png" +"</fileName>";
    	}else{
    		bOK = false;	//無TEMP檔，就不用複製到正式圖檔，也不需縮圖
    	}
		
	}
	
	
}catch(Exception e){
	e.printStackTrace();
	bOK = false;
	result = e.toString();
	writeToFile("系統錯誤!||Function=FileUploader_UploadFile.jsp||參數filepath=" + filepath + "||錯誤描述=" + e.toString());
}	//try{


//-----------------------上傳完成，開始產生縮圖-------------------------    
//參考網址：http://rritw.com/a/caozuoxitong/OS/20110923/130269.html
/*************20120824改為人工縮圖***********************/
if("false".equals(isTemp) && bOK){
	java.io.File original_image = new java.io.File(gcBasePathForFileUpload + name+ ".png");
	java.io.File resized_image = new java.io.File(gcBasePathForFileUpload + name+ "_a.png");

	BufferedImage originalImage = ImageIO.read(original_image);
	
	int imageType = originalImage.getType();
	
	int originalWidth = originalImage.getWidth();
	int originalHeight = originalImage.getHeight();
	int maxLength = 200;
	int newWidth = 0;
	int newHeight = 0;
	if(name.indexOf("TW")>-1){
		maxLength = 800;	
	}
	if(originalWidth > originalHeight){
		newWidth = maxLength ;
		newHeight = newWidth * originalHeight / originalWidth;
	}else{
		newHeight = maxLength ;
		newWidth = newHeight * originalWidth / originalHeight;
	}
	Dimension new_dim  = new  Dimension(newWidth, newHeight);
	BufferedImage resizedImage = new BufferedImage(newWidth, newHeight, imageType);
	Graphics2D g = resizedImage.createGraphics();
	g.drawImage(originalImage, 0, 0, (int) new_dim.getWidth(), (int) new_dim.getHeight(), null);
    g.dispose();
    
    ImageIO.write(resizedImage, "png", resized_image);
	
	result += ",imageType="+imageType+",width="+originalImage.getWidth()+",height="+originalImage.getHeight();
	result += ",newWidth="+newWidth+",newHeight="+newHeight+",name="+name;
	//imageType=6,width=751,height=1156
	out.print(ComposeXMLResponse(sResultCode, sResultText, result));
//以下方式為JPG的縮圖，無法保留透明度

/* 	//縮圖比例計算,並縮圖,回傳縮圖名稱
	final int reSizePer = 10000;
	
	BufferedImage im = ImageIO.read(new java.io.File(gcBasePathForFileUpload + name+ ".png"));
    int ori_width = im.getWidth();	//台灣測試的原圖：751,1156
    int ori_height = im.getHeight();
    
    int reWidth = ori_width ;
    int reHeight = ori_height;
    
    int width = 200 ; //臺灣為800，其餘為200
    int height = 200;
    
	if(filename.lastIndexOf("TW")>-1){
		width = 800;
		height = 800;
	}

    //原圖較大，才需RESIZE
    int tmp = 0 ;
    if(ori_width > width || ori_height > height){
    	
        //要縮小幾%才會在350pix以下
        int w = (width*reSizePer) / ori_width;
        int h = (height*reSizePer) / ori_height;
        if(w>reSizePer && h > reSizePer)
          tmp = reSizePer;
        else if (w>reSizePer && h < reSizePer)
          tmp = h;
        else if (h>reSizePer && w < reSizePer)
          tmp = w;
        else
          tmp = w<h?w:h;
        if(tmp==0)
          tmp= reSizePer;
        //長跟寬誰壓縮後會最接近要壓縮的資料
        
        reWidth = java.lang.Math.round(ori_width*tmp/reSizePer);
        reHeight = java.lang.Math.round(ori_height*tmp/reSizePer);
        
    }
    
    //resize(im,rimage,reWidth,reHeight);
    //REIZE原圖
    BufferedImage src= im ;	//構造Image物件
    BufferedImage tag= new BufferedImage(reWidth, reHeight, BufferedImage.TYPE_INT_RGB);
    
    tag.getGraphics().drawImage(src, 0, 0, reWidth, reHeight, null); //繪製縮小後的圖
    
    //BufferedImage tag= new BufferedImage(519, 799, BufferedImage.TYPE_INT_RGB); //測試4G_TW:519,799
    //tag.getGraphics().drawImage(src, 0, 0, 519, 799, null); //繪製縮小後的圖
    
    //writeImage(tag,picTo, extName);
    //function writeImage(BufferedImage img,String to,String extName)
    //寫入圖檔
    //app file path
    String to = filepath + name +"_a.png";

    FileOutputStream newimage = new FileOutputStream(to); //輸出到文件流
        //  System.out.println("newimage:"+newimage);
       ImageIO.write(tag, "png", newimage);
       if(newimage!=null)
       {
         newimage.close();
         newimage = null ;
       }
    
	result += "<urla>" + gcURLForUploadedFile + name+"_a.png" +"</urla>";
	result += "<filePath>" + gcBasePathForFileUpload + "</filePath>";
	result += "<fileaName>" + name+"_a.png" +"</fileaName>";
    
    //out.print(result+","+name+","+reWidth+","+reHeight+","+tmp);	//,129,199,1730
	out.print(ComposeXMLResponse("","",result));
     */
}else{
	out.print(ComposeXMLResponse(sResultCode, sResultText, result));
}



/* if (bOK){	//大圖上傳成功
	try{
		java.io.File file = new java.io.File(filepath+ filename);        //讀入剛才上傳的文件
		//String newurl=request.getRealPath("/")+url+filename+"_min."+ext;  //新的縮略圖保存地址
		//String newurl = filepath + sItemCode + "-" + sPicIndex + "_s" + type;
		String newurl = filepath + filename + "_a" +type;
		Image src = javax.imageio.ImageIO.read(file);                     //構造Image對象
		float tagsize= 800;													//台灣為800，其他為200
		int old_w=src.getWidth(null);                                     //得到源圖寬
		int old_h=src.getHeight(null);   
		int new_w=0;
		int new_h=0;                            //得到原圖長
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
		result = result + ",app image:"+newurl;
	}catch(Exception e){
		bOK = false;
		result = "產生縮圖時發生錯誤：" + e.toString();
		//要不要刪除大圖啊？
		writeToFile("系統錯誤!||Function=FileUploader_Item.jsp||參數filepath=" + filepath + "||縮圖時錯誤，錯誤描述=" + e.toString());
	}
}	//if (bOK){	//大圖上傳成功 */

	
%>