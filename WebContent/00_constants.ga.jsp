<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>
<%!

//CDR的起始判別符號，兩台Server分別為01及02
public static final String	gcCDRFileSerialNo						= "01";

//系統參數

public static final String	gcLogFilePath							= "/AP/tomcat/logs/tstapp/";	//寫入系統Log檔的路徑(writeToFile()使用)
public static final String	gcBasePathForFileUpload					= "/AP/tomcat/webapps/ROOT/myviboadmin_pic/";	//預設檔案上傳路徑
//public static final String	gcBasePathForFileUpload					= "/usr/local/tomcat/webapps/ROOT/myviboadmin/pic/";	//預設檔案上傳路徑
public static final String	gcURLForUploadedFile					= "https://vas.tstartel.com/myviboadmin_pic/";	//瀏覽圖檔的URL
//public static final String	gcURLForUploadedFile					= "http://172.23.1.106:8080/myviboadmin/pic/";	//瀏覽圖檔的URL
public static final float	gcLongSideLengthOfThumbImage			= 100;	//產生縮圖時，最長邊的長度(pixel)
public static final String	gcDefaultPageTimeout					= "300000";	//瀏覽器使用AJAX連到server時，在AJAX中設的timeout時間

/*****************************************************************************/
//使用者角色
public static final String gcUserEditor								= "1";	//一般使用者，可編輯訊息
public static final String gcUserManager							= "2";	//主管，可approve訊息
public static final String gcUserAdmin								= "9";	//系統管理者，所有功能皆可執行

//訊息管理頁面的六個功能
public static final String[] mesSearchReject                        = {"3", "4"};
public static final String[] mesGetBasicReject                      = {"3", "4"};
public static final String[] mesPicRemoveReject                     = {"3", "4"};
public static final String[] mesSaveReject                          = {"3", "4"};
public static final String[] mesDeleteReject                        = {"3", "4"};
public static final String[] mesReorderReject                       = {"3", "4"};
public static final String[] mesApproveReject                       = {"1", "3", "4"};

/*****************************************************************************/
//BSC API的URL
// public static final String gcBSCURL					= "http://172.24.12.1:8080/";	//注意最右邊一定要有"/"
//public static final String gcBSCURL					= "http://172.24.1.36:80/TSCAPI/";	//注意最右邊一定要有"/"
// public static final String gcBSCURL					= "http://172.24.12.1:8080/TSCAPI/";	//注意最右邊一定要有"/"
// public static final String gcBSCURL					= "http://172.16.24.95:8080/TSCAPI/";	//注意最右邊一定要有"/"
public static final String gcBSCURL					= "http://tappbs.tstartel.com:8080/TSCAPI/";	//注意最右邊一定要有"/"
public static final String gcVASId					= "MyviboWeb";					//BSC API的VASId
public static final String gcVASPassword			= "56789";							//BSC API的VASPassword

// public static final String gcBSCURLNEW					= "http://172.24.12.1:8080/";	//注意最右邊一定要有"/"
// public static final String gcBSCURLNEW					= "http://172.16.24.95:8080/";	//注意最右邊一定要有"/"
public static final String gcBSCURLNEW					= "http://tappbs.tstartel.com:8080/";	//注意最右邊一定要有"/"
public static final String gcVASIdNEW					= "VStoreWeb";					//BSC API的VASId
public static final String gcVASPasswordNEW			= "123456";							//BSC API的VASPassword

/*****************************************************************************/
//Email相關設定
public static final String	gcDefaultEmailSMTPServer				= "172.23.1.13";	//發送email的郵件主機(OA，可寄送至外部信箱)
//public static final String	gcDefaultEmailSMTPServer				= "172.19.5.10";	//發送email的郵件主機(OA，可寄送至外部信箱)
//public static final String	gcDefaultEmailFromAddress				= "vshopservice@tstartel.com";	//發送email的發信人email address
public static final String	gcDefaultEmailFromAddress				= "vshopadmin@tstartel.com";	//發送email的發信人email address
public static final String	gcDefaultEmailFromName					= "MyVIBO APP 管理系統";	//發送email的發信人名稱

//MSP 相關參數
//public static final String gcMSPSendURL									= "http://172.24.128.131:8001/mspweb/xmlreqreceiver"; //MSP發送簡訊API的URL(測試環境)
//public static final String gcMSPSendURL									= "http://202.144.209.40:8001/mspweb/xmlreqreceiver"; //MSP發送簡訊API的URL(測試環境)
//public static final String gcMSPClientId								= "Sunny"; //MSP發送簡訊API的ClientId(測試環境)
//public static final String gcMSPClientUserName							= "entadm"; //MSP發送簡訊API的ClientUserName(測試環境)
//public static final String gcMSPClientPassword							= "entadm"; //MSP發送簡訊API的ClientPassword(測試環境)
public static final String gcMSPSendURL									= "http://172.24.128.157/mspweb/xmlreqreceiver"; //MSP發送簡訊API的URL(正式環境)
public static final String gcMSPClientId								= "CL-6999123"; //MSP發送簡訊API的ClientId(正式環境)
public static final String gcMSPClientUserName							= "Ent-0986999123"; //MSP發送簡訊API的ClientUserName(正式環境)
public static final String gcMSPClientPassword							= "09869991"; //MSP發送簡訊API的ClientPassword(正式環境)

//呼叫BSC API或checkUserPrivilege等function時的ResultCode及ResultText定義
public static final String	gcResultCodeSuccess						= "00000";
public static final String	gcResultTextSuccess						= "作業成功";
public static final String	gcResultCodeParametersNotEnough			= "00004";
public static final String	gcResultTextParametersNotEnough			= "傳入之參數不足!";
public static final String	gcResultCodeParametersValidationError	= "00005";
public static final String	gcResultTextParametersValidationError	= "傳入之參數有誤!";
public static final String	gcResultCodeNoDataFound					= "00006";
public static final String	gcResultTextNoDataFound					= "找不到符合條件的資料!";
public static final String	gcResultCodeNoLoginInfoFound			= "00007";
public static final String	gcResultTextNoLoginInfoFound			= "無法取得登入資訊，可能為網頁閒置過久，請重新登入本系統!";
public static final String	gcResultCodeNoPriviledge				= "00008";
public static final String	gcResultTextNoPriviledge				= "您無權限使用此程式!!!";
public static final String	gcResultCodeAPPExpired					= "99002";
public static final String	gcResultTextAPPExpired					= "本APP已終止服務，請至Google Play或App Store下載新的APP!";
public static final String	gcResultCodeDBTimeout					= "99001";
public static final String	gcResultTextDBTimeout					= "資料庫連線失敗或逾時!";
public static final String	gcResultCodeUnknownError				= "99999";
public static final String	gcResultTextUnknownError				= "發生未知的錯誤!";

public static final String	gcDataSourceName						= "jdbc/myvibooracle";

//日期格式
public static final String	gcDateFormatDateDashTime				= "yyyyMMdd-HHmmss";
public static final String	gcDateFormatSlashYMDTime				= "yyyy/MM/dd HH:mm:ss";
public static final String	gcDateFormatYMD							= "yyyyMMdd";
public static final String	gcDateFormatSlashYMD					= "yyyy/MM/dd";
public static final String	gcDateFormatdashYMD						= "yyyy-MM-dd";

%>
