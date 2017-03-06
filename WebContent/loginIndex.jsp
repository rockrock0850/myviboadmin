<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>台灣之星APP後台管理系統</title>
	<link href="css/default.css" rel="stylesheet" type="text/css" media="all" />
	<link rel="stylesheet" href="css/jquery-ui-1.10.3.custom.min.css" />
	<link rel="stylesheet" href="css/tablesorter.css" /><!-- 以 table column 排序用，請參考 http://tablesorter.com/docs/ -->
	<script src="js/ga.js"></script>
	<script src="js/jquery-1.9.1.js"></script>
	<script src="js/jquery-ui-1.10.3.custom.min.js"></script>
	<script src="js/jquery.blockUI.js"></script>
	<script src="js/util.js?<%=System.currentTimeMillis()%>"></script>
	<script src="js/jquery-ui-timepicker-addon.js"></script> <!-- 將 JQuery UI 的 date picker 加上時間功能，請參考 http://trentrichardson.com/examples/timepicker/ -->
	<script src="js/jquery.tablesorter.min.js"></script> <!-- 以 table column 排序用，請參考 http://tablesorter.com/docs/ -->
</head>
<body>
<div id="header-wrapper">
	<div id="header" class="container">
		<div id="logo">
			<table><tr><td><h1><a href="index.jsp">台灣之星APP後台管理系統</a></h1></td><td class="headeruserid"><span id="FunctionName"></span><span>-</span></td><td class="headeruserid"><span id="LoginId"></span></td></tr></table>
		</div>
		<div id="mainmenu">
			<ul id="mainmenuitem">
				<!--
				<li class="current_page_item"><a href="MessageQuery.html">訊息維護</a></li>
				<li><a href="AccountSetting">權限設定</a></li>
				<li><a href="#" onclick="doLogout();">登出</a></li>
				-->
			</ul>
		</div>
	</div>
</div>
<div id="wrapper">
	<div id="page" class="container">
	</div>
</div>
<div id="footer" class="container">
	<div id="copyright" class="container">
	<p>台灣之星電信版權所有 Copyright© 2014 Taiwan Star Telecom Co., Ltd. All Rights Reserved.&nbsp;&nbsp;&nbsp;&nbsp;(最佳解析度1280X800)</p>
</div>
</body>
</html>


<script>
	$(function() {
		//$(".button").button().click(function(event){event.preventDefault();});	//將class=button的物件做成 JQuery UI 的 button
		$(".button").button();	//將class=button的物件做成 JQuery UI 的 button

		if (notEmpty(getParameterByName('action')) && getParameterByName('action')=='a'){
			getLoginId('首頁');	//取得目前登入使用者的ID
			$('#tblResult thead tr').append('<th>審核</th>');
		}else{
			getLoginId('首頁');	//取得目前登入使用者的ID
		}
		
		getServiceList();	//取得服務清單

		//設定顯示明細資料的 iframe
		$("#dialog").dialog({
			autoOpen: false,
			modal: true,
			height: 500,
			width: 1000,
			title: '訊息明細'
		});
		
		$('#tblResult').tablesorter();
	});
	//取得服務清單
	function getServiceList(success){
		showBlockUI();
		//以下是執行AJAX要求server端處理資料
		$.ajax({
			url: "ajaxAdmGetServiceList.jsp",
			type: 'POST', //根據實際情況，可以是'POST'或者'GET'
			data: '',
			dataType: 'xml', //指定數據類型，注意server要有一行：response.setContentType("text/xml;charset=utf-8");
			timeout: 300000, //設置timeout時間，以千分之一秒為單位，1000 = 1秒
			error: function (){	//錯誤提示
				unBlockUI();
				alert ('系統忙碌中，請稍候再試!!');
			},
			success: function (xml){ //ajax請求成功後do something with xml
				unBlockUI();
				var ResultCode = $(xml).find("ResultCode").text();
				var ResultText = $(xml).find("ResultText").text();
				if (ResultCode=='00000'){	//作業成功
					var ss = "";
					$(xml).find("item").each( function() {
						ss += "<option value='" + $(this).children("ServiceId").text() + "'>" + $(this).children("ServiceName").text() + "</option>";
					});
					$('#ServiceId').append(ss);
					if (success!=null && typeof(success)=="function") success();
				}else{
					alert(ResultText);
				}	//if (ResultCode=='00000'){	//作業成功
			}	//success: function (xml){ //ajax請求成功後do something with xml
		});	//$.ajax({
		//以上是執行AJAX要求server端處理資料
	}	//function getServiceList(){
</script>
