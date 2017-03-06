<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<html>
<head>
<title>台灣之星APP後台管理系統</title>
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/default.css"  media="all"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui-1.10.3.custom.min.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/tablesorter.css" />
<script src="${pageContext.request.contextPath}/js/ga.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-1.9.1.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-ui-1.10.3.custom.min.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery.blockUI.js"></script>
<script src="${pageContext.request.contextPath}/js/util.js"></script>
<script src="${pageContext.request.contextPath}/js/tools.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery.blockUI.js"></script>
<style type="text/css">
	#charsLeft {
		color: #f00;
	}
</style>
<script>
	var word_limit = '${word_limit}';//設定保護文字長度
	var popMessage = '${popMessage}';
	
	$(function() {
		$('table').attr('width', (screen.width/2));
		
		$(".btn").addClass("button ui-button ui-widget ui-state-default ui-corner-all ui-state-hover");
		getLoginId('比一比預設資料維護');	//取得目前登入使用者的ID
		<c:if test='${not empty projectsList}'>
			<c:forEach items="${projectsList}" var="projects">
				addRow('${projects.id}', '${projects.name}', '${projects.status}');
			</c:forEach>
		</c:if>
		$("#company").val('${telecomRate.telecomId}');
		<c:if test='${empty projectsList}'>
			addRow('', '', '');
		</c:if>
		var feeRangeJson = jQuery.parseJSON('${feeRangeData}');
		var feeSelJson = jQuery.parseJSON('${feeSelData}');
		var typeSelJson = jQuery.parseJSON('${typeSelData}');
		$(typeSelJson).each(function() {
			$("#fee_type").append("<option value='"+this.value+"'>"+this.text+"</option>");	
		});
		$("#fee_type").change(function() {
			if($("#fee_range").val()!='' && $("#fee_sel").val()!=''){
				$('#voice_on_net').val('');
				$('#voice_off_net').val('');
				$('#pstn').val('');
				$('#data_usage').val('');
				$('#sms_on_net').val('');
				$('#sms_off_net').val('');	
			}
			buildFeeRange();
			checkIsTypeSelect();
		});
		/* 組成"資費範圍"選項 */
		function buildFeeRange(){
			$("#fee_range").empty();
			$("#fee_range").append('<option value="" selected>資費範圍</option>');
			$("#fee_sel").empty();
			$("#fee_sel").append('<option value="" selected>選擇資費</option>');
			
			var typeSel = $("#fee_type").val();
			$(eval('feeRangeJson["'+ typeSel + '"]')).each(function() {
				$("#fee_range").append("<option value='"+this.value+"'>"+this.text+"</option>");
			});
			
			/* 根據所選的"資費範圍"組成"選擇資費"選項 */
			$("#fee_range").change(function() {
				if($("#fee_sel").val()!='' && $("#fee_type").val()!=''){
					$('#voice_on_net').val('');
					$('#voice_off_net').val('');
					$('#pstn').val('');
					$('#data_usage').val('');
					$('#sms_on_net').val('');
					$('#sms_off_net').val('');	
				}
				$("#fee_sel").empty();
				$("#fee_sel").append('<option value="" selected>選擇資費</option>');
				
				var rangeSel = $("#fee_range").val();
				$(eval('feeSelJson["'+ rangeSel + '"]')).each(function() {
					$("#fee_sel").append("<option value='"+this.value+"'>"+this.text+"</option>");
				})
			});
		};
		//資費範圍有選，才能選其他選項
		function checkIsTypeSelect(){
			if('' == $("#fee_type").val()){
				$('#fee_range').attr('disabled', true);
				$('#fee_sel').attr('disabled', true);
				$('#company_sel').attr('disabled', true);
			}else{
				$('#fee_range').attr('disabled', false);
				$('#fee_sel').attr('disabled', false);
				$('#company_sel').attr('disabled', false);
			}
		};
		$('#calculate_rule').change(function(){
			if('' != $('#fee_sel').val()){
				presetvalue();
			}
		});
		$("#fee_sel").change(function() {
			presetvalue();
		});
		$("#text_type").change(function() {
			wordvalue();
		});
		changeText();

// 		Message dialog
		$( "#message_dialog" ).dialog({
			autoOpen: false,
			width:'auto', 
			buttons: {
				"確認": function() {
					$(this).dialog( "close" );
				}
			}
		});	
		
// 		Show result dialog
		$( "#show_result_dialog" ).dialog({
			autoOpen: false,
			width:'auto',
			buttons: {
				"確認": function() {
					$(this).dialog( "close" );
				}
			}
		});	
		
// 		Roll back dialog
		$( "#show_excel_file" ).dialog({
			autoOpen: false,
			title:'訊息', 
			width:'auto', 
			buttons: {
				"查詢": function() {
					$( this ).dialog( "close" );
					$('#rollBack_form').find('div').empty();
					var limitStart = $('#limit_start').val();
					var limitEnd = $('#limit_end').val();
					ajaxRequestExcelFile(limitStart, limitEnd);
				},
				"確認": function() {
					showBlockUI();
					$('#rollBack_form').submit();
					$( this ).dialog( "close" );
				},
				"取消": function() {
					$('#rollBack_form').find('div').empty();
					$('#limit_start').val('1');
					$('#limit_end').val('3');
					$( this ).dialog( "close" );
				}
			}
		});	
		
		switch (popMessage) {
		case 'Success':
			$('#show_result_dialog').append('<div id="results"></div>');
			var json = $.parseJSON('${rtnJson}');
			var results = '';

// 			success count
			results += '<div><a>上傳成功筆數:' +json.successCount+ '</a><br></div>';
			
// 			failed rows
			if(json.failedRows.length > 0){
				results = setFailRows(json.failedRows, results);
			}

// 			emptyPhones
			if(json.emptyPhones.length > 0){
				results += '<div><a>不在資料庫內之手機名稱:</a><br>';
				results = setFailPhone(json.emptyPhones, results);
				results += '</div>';
			}
			
// 			errorPhones
			if(json.errorPhones.length > 0){
				results += '<div><a>多支啟用狀態之手機名稱:</a><br>';
				results = setFailPhone(json.errorPhones, results);
				results += '</div>';
			}

			$('#results').append(results);
			$('#show_result_dialog').dialog('option', 'title', '訊息');
			$('#show_result_dialog').dialog('open');
			break;

		case 'No file selected':
			$('#message_dialog').dialog('option', 'title', '錯誤');
			$('#pop_message').html('上傳失敗，請選擇檔案!');
			$('#message_dialog').dialog('open');
			break;

		case 'Invaild format file':
			$('#message_dialog').dialog('option', 'title', '錯誤');
			$('#pop_message').html('上傳失敗，請選擇Excel類型的檔案!');
			$('#message_dialog').dialog('open');
			break;

		case 'Storing error':
			$('#message_dialog').dialog('option', 'title', '錯誤');
			$('#pop_message').html('上傳失敗，儲存備份檔錯誤，請聯絡工作人員!');
			$('#message_dialog').dialog('open');
			break;
		}

		$( "#search_dialog" ).dialog({
			autoOpen: false,
			buttons: {
				"確認": function() {
					$('#show_excel_file').dialog('open');
					$( this ).dialog( "close" );
				}
			}
		});	
	});

	function presetvalue() {
		showBlockUI();
		var formData = {calculate_rule:$('#calculate_rule').val(),fee_type:$("#fee_type").val(),fee_range:$("#fee_range").val(),fee_sel:$("#fee_sel").val()}; //Array
// 		console.log(formData);
		$.ajax({
			url:"presetvalue.action",
			type:"POST",
			data : formData,
			dataType:'json',
			timeout:30000,
			error: function (){	//錯誤提示
				alert ('Error timeout');
				unBlockUI();
			},
			success: function (data){ //ajax請求成功後do something with xml
// 				console.log(data);
				if(data !=""){
					var json = $.parseJSON(data);
					if(json.voice_on_net != null){
						$("#voice_on_net").val(json.voice_on_net);	
					}else{
						$("#voice_on_net").val('0');	
					}
					if(json.voice_off_net != null){
						$("#voice_off_net").val(json.voice_off_net);	
					}else{
						$("#voice_off_net").val('0');	
					}
					if(json.pstn != null){
						$("#pstn").val(json.pstn);	
					}else{
						$("#pstn").val('0');	
					}
					if(json.data_usage != null){
						$("#data_usage").val(json.data_usage);	
					}else{
						$("#data_usage").val('0');	
					}
					if(json.sms_on_net != null){
						$("#sms_on_net").val(json.sms_on_net);	
					}else{
						$("#sms_on_net").val('0');	
					}
					if(json.sms_off_net != null){
						$("#sms_off_net").val(json.sms_off_net);	
					}else{
						$("#sms_off_net").val('0');	
					}	
				}else{
					$("#voice_on_net").val('0');
					$("#voice_off_net").val('0');
					$("#pstn").val('0');
					$("#data_usage").val('0');
					$("#sms_on_net").val('0');
					$("#sms_off_net").val('0');
				}
				$("p").empty();
				unBlockUI();
			}
		});
	};
	
	
	function wordvalue() {
		showBlockUI();
		var formData = {text_type:$("#text_type").val()}; //Array
		$.ajax({
			url:"wordvalue.action",
			type:"POST",
			data : formData,
			dataType:'json',
			timeout:30000,
			error: function (){	//錯誤提示
				alert ('Error timeout');
				unBlockUI();
			},
			success: function (data){ //ajax請求成功後do something with xml
				if(data !=""){
					var json = $.parseJSON(data);
					if(json.protect_word != null){
						$("#protect_word").val(json.protect_word);	
					}else{
						$("#protect_word").val('');	
					}
					if(json.protect_word != null){
						$("#word_id").val(json.id);	
					}else{
						$("#word_id").val('');	
					}
				}else{
					$("#word_id").val('');
					$("#protect_word").val('');				
				}
				$("p").empty();
				unBlockUI();
				changeText();
			}
		});
	};
	
	function submitForm(){
		var number_chk = /^[0-9]+(\.[0-9]{1,2})?$/;//驗證空值
		var null_chk = /^\s*$/;//驗證空值
		if(!alertController($("#calculate_rule"), '手機專案', '', false)){
			return false;
		}else if(!alertController($("#fee_type"), '請選擇資費類型', '', false)){
			return false;
		}else if(!alertController($("#fee_range"), '請選擇資費範圍', '', false)){
			return false;
		}else if(!alertController($("#fee_sel"), '請選擇資費', '', false)){
			return false;
		}else if(null_chk.test($("#voice_on_net").val())){	
			alert("網內輸入資料不能為空值");
			return false;
		}else if(!number_chk.test($("#voice_on_net").val())){	
			alert("網內輸入資料格式為數字");
			return false;
		}else if(null_chk.test($("#voice_off_net").val())){	
			alert("網外輸入資料不能為空值");
			return false;
		}else if(!number_chk.test($("#voice_off_net").val())){	
			alert("網外輸入資料格式為數字");
			return false;
		}else if(null_chk.test($("#pstn").val())){	
			alert("市話輸入資料不能為空值");
			return false;
		}else if(!number_chk.test($("#pstn").val())){	
			alert("市話輸入資料格式為數字");
			return false;
		}else if(null_chk.test($("#data_usage").val())){	
			alert("上網傳輸不能為空值");
			return false;
		}else if(!number_chk.test($("#data_usage").val())){	
			alert("上網傳輸輸入格式為數字");
			return false;
		}else if(null_chk.test($("#sms_on_net").val())){	
			alert("網內簡訊不能為空值");
			return false;
		}else if(!number_chk.test($("#sms_on_net").val())){	
			alert("網內簡訊輸入格式為數字");
			return false;
		}else if(null_chk.test($("#sms_off_net").val())){	
			alert("網外簡訊不能為空值");
			return false;
		}else if(!number_chk.test($("#sms_off_net").val())){	
			alert("網外簡訊輸入格式為數字");
			return false;
		}else{
			$("#cf_form").attr('action', 'changePresetData.action'); 
			$("#cf_form").submit();	
				
		}
	};
	
	function submitForm1(){	
		var word_text = encodeURIComponent($("#protect_word").val());
		//alert(m.replace(/%[A-F\d]{2}/g, 'U').length);
		var null_chk = /^\s*$/;//驗證空值
		if(null_chk.test($("#text_type").val())){
			alert("請選擇保護文字類型");
			return false;
		}else if(null_chk.test($("#protect_word").val())){
			alert("請輸入保護文字內容");
			return false;
		}else if(word_text.replace(/%[A-F\d]{2}/g, 'U').length>word_limit){
			alert("輸入保護文字內容過長");
			return false;
		}else{
			$("#cf_form1").attr('action', 'changeProtectWord.action'); 
			$("#cf_form1").submit();				
		}	
	};
	
	function cleanForm(){
		$("#fee_type")[0].selectedIndex = 0;
		$("#calculate_rule")[0].selectedIndex = 0;
		$("#fee_range")[0].selectedIndex = 0;
		$("#fee_sel")[0].selectedIndex = 0;
		$('#voice_on_net').val('');
		$('#voice_off_net').val('');
		$('#pstn').val('');
		$('#data_usage').val('');
		$('#sms_on_net').val('');
		$('#sms_off_net').val('');
	};
	
	function cleanForm1(){
		$("#text_type")[0].selectedIndex = 0;	
		$('#protect_word').val('');
	};
	
	var rowCount = 0;
	function addRow(id, name, status) {
		$('#projectsList tbody').append(
				"<tr><td><input type='hidden' name='projectsList[" + rowCount + "].id' value='" + id + "' />" +
				"<input type='text' name='projectsList[" + rowCount + "].name' value='" + name + "' /></td>" +
				"<td><select id='projectsList" + rowCount + "' name='projectsList[" + rowCount + "].status'>" +
				"<option value='1'>啟用</option><option value='0'>停用</option></select></td></tr>");
		$("#projectsList" + rowCount).val(status);
		rowCount++;
	};
	
	function changeText(objElement) {
		var word_text = encodeURIComponent($("#protect_word").val());
		var oTextCount = document.getElementById("txtCount");
		var tmp=word_limit-word_text.replace(/%[A-F\d]{2}/g, 'U').length;
	    oTextCount.innerHTML = "<font color=red>"+ tmp+"</font>";    
	};

	function submitUpdateExcelform(){
		showBlockUI();
		$('#fileName').val($('#file').val());
		$('#updateExcel_form').submit();
	};

	function ajaxRequestExcelFile(limitStart, limitEnd){
		var count = limitStart;
		$.ajax({
			url:"getExcelFileName.action",
			type:"POST",
			data:{'rtnJson':'Search'},
			dataType:'json',
			timeout:30000,
			error: function (err){	//錯誤提示
				alert (err);
			},
			success: function (response){ //ajax請求成功後do something with xml
				response = $.parseJSON(response);
				$('#rollBack_form').find('div').empty();
				if(response.length < 3){
					$('#rollBack_form').append('<div id="excels"></div>');
					for(var i = 0; i < response.length; i++){
						if(count > response.length){break;}
						$('#excels').append(
								'<input id="excel' +i+ '" type="radio" name="excelFileName" value="' +response[i]+ '"/>&nbsp&nbsp' + 
								'<label for="excel' +i+ '">' +response[i].split('.')[0]+ '</label><br>');
						count++;
					}
					$('#excel0').prop('checked', true);
					$('#show_excel_file').dialog('open');
				}else if(response.error == 'none'){
					$('#message_dialog').dialog('option', 'title', '錯誤');
					$('#pop_message').html(response.none);
					$('#message_dialog').dialog('open');
				}else if(limitEnd > response.length){
					$('#search_dialog').dialog('option', 'title', '錯誤');
					$('#search_message').html('已超出可查詢範圍!<br>總檔案數:' + response.length);
					$('#search_dialog').dialog('open');
				}else if((limitEnd-limitStart) < 0 || limitStart <= 0 || limitEnd <= 0 ){
					$('#search_dialog').dialog('option', 'title', '錯誤');
					$('#search_message').html('錯誤的搜尋!');
					$('#search_dialog').dialog('open');
				}else{
					$('#rollBack_form').append('<div id="excels"></div>');
					for(var i = limitStart-1; i < limitEnd; i++){
						if(count > response.length){break;}
						$('#excels').append(
								'<input id="excel' +i+ '" type="radio" name="excelFileName" value="' +response[i]+ '"/>&nbsp&nbsp' + 
								'<label for="excel' +i+ '">' +response[i].split('.')[0]+ '</label><br>');
						count++;
					}
					$('#excel' + (limitStart-1)).prop('checked', true);
					$('#show_excel_file').dialog('open');
				}
			}
		});
	};
	
	function setFailPhone(resultData, results){
		for(var x in resultData){
			results += '<a>' +resultData[x]+ '</a><br>';
		}
		return results;
	};
	
	function setFailRows(resultData, results){
		results += '<div><a>讀取錯誤之行號:</a><br>';
		results += '<table style="text-align:right"><tr>';
		for(var x in resultData){
			if((x > 0 && x%10 == 0) || x == resultData.length-1){
				results += '<td>' +resultData[x]+ '&nbsp</td></tr>';
				results += '<tr>';
			}else{
				results += '<td>' +resultData[x]+ ',</td>';
 			}
		}
		results += '</tr></table></div>';
		return results;
	};
</script>
</head>
<body>
<div id="header-wrapper">
	<div id="header" class="container">
		<div id="logo">
			<table>
				<tr>
					<td>
						<h1><a href="${pageContext.request.contextPath}/index.jsp">台灣之星APP後台管理系統</a></h1>
					</td>
					<td class="headeruserid">
						<span id="FunctionName"></span>
						<span>-</span>
						<span id="LoginId"></span>
					</td>
				</tr>
			</table>
		</div>
		<div id="mainmenu" style="position:absolute;z-index: 9999">
			<ul id="mainmenuitem" ></ul>
		</div>
	</div>
</div>
<div id="wrapper">
	<div id="page" class="container">
		<form id='cf_form' method='post'>
			<c:if test="${not empty message}">
				<div>
					<p style="color:green">${message}</p>
				</div>   	
			</c:if>
			<table id='table' class="filtered_table" cellspacing="5">
				<tr>
					<td colspan="4" align="center">
						<h2>請輸入方案預設值</h2>
					</td>
				</tr>
				<tr>
					<td>試算規則:</td>
					<td>
						<select id="calculate_rule" name="calculate_rule">
							<option value='PROJECT'>手機專案</option>
							<option value='SINGLE'>單門號</option>
						</select>	
					</td>
				</tr>
				<tr>
					<td>資費類型:</td>
					<td>
						<select id="fee_type" name="fee_type">
							<option value="">請選取資費類型</option>
						</select>	
					</td>
				</tr>
				<tr>			
					<td>資費範圍:</td>
					<td>
						 <select id="fee_range" name="fee_range">
							<option value="">資費範圍</option>
						</select>
						<br/>
						<select id="fee_sel" name="fee_sel">
							<option value="">選擇資費</option>
						</select>
					</td>
				</tr>
				<tr>			
					<td>網內:</td>
					<td>
						<input type="text" id="voice_on_net" name='voice_on_net' value="">&nbsp;分鐘
					</td>
				</tr>
				<tr>			
					<td>網外:</td>
					<td>
						<input type="text" id="voice_off_net" name='voice_off_net' value="">&nbsp;分鐘
					</td>
				</tr>
				<tr>			
					<td>市話:</td>
					<td>
						<input type="text" id="pstn" name='pstn' value="">&nbsp;分鐘
					</td>
				</tr>
				<tr>			
					<td>上網傳輸量:</td>
					<td>
						<input type="text" id="data_usage" name='data_usage' value="">&nbsp;GB
					</td>
				</tr>
				<tr>			
					<td>網內簡訊 :</td>
					<td>
						<input type="text" id="sms_on_net" name='sms_on_net' value="">&nbsp;則
					</td>
				</tr>
				<tr>			
					<td>網外簡訊 :</td>
					<td>
						<input type="text" id="sms_off_net" name='sms_off_net' value="">&nbsp;則
					</td>
				</tr>
				<tr>
					<td colspan="4" align="center">
						<input class="submit btn" type="button" onclick='submitForm()' value="資料異動" />&nbsp;
						<input class="submit btn" type="button" onclick='cleanForm()' value="清除" />
					</td>			
				</tr>
			</table>
		</form>
	</div>	
	<div id="page1" class="container">	
		<table><tr><hr></tr></table>
		<form id='cf_form1' method='post'>
			<c:if test="${not empty message1}"> 
				<div><p style="color:green">${message1}</p></div> 	
			</c:if>
			<table id='table1' class="filtered_table" cellspacing="2">
				<tr>
					<td colspan="4" align="center">
						<h2>請輸入保護文字</h2>
					</td>
				</tr>
				<tr>
					<td>保護文字類型:</td>
					<td>
						<select id="text_type" name="text_type">
							<option value="">請選取文字類型</option>
							<option value="3G_SIM_PS">3G單門號</option>
							<option value="3G_PROJECT_PS">3G手機專案</option>
							<option value="4G_SIM_PS">4G單門號</option>
							<option value="4G_PROJECT_PS">4G手機方案</option>
						</select>	
					</td>
				</tr>
				<tr>			
					<td>保護文字內容:</td>
					<td>
						<input type="hidden" id="word_id" name="word_id" value="">
						<input type="text" id="protect_word" name='protect_word' value=""  size="50" oninput="changeText(this);" >&nbsp;目前剩下可用字數：<span id="txtCount"><font color="red">0</font></span> 字<br>
					</td>
				</tr>	
				<tr>
					<td colspan="4" align="center">
						<input class="submit btn" type="button" onclick='submitForm1()' value="資料異動" />&nbsp;
						<input class="submit btn" type="button" onclick='cleanForm1()' value="清除" />
					</td>
				</tr>		
			</table>
		</form>		
	</div>	
	<div class="container"> 
		<table><tr><hr></tr></table>
		<form id='updateExcel_form' action="updateExcelData.action" method ="post" enctype ="multipart/form-data"> 
			<table class="filtered_table" cellspacing="2">
				<tr>
					<td colspan="4" align="center">
						<h2>請選擇要上傳的檔案或選擇回復</h2>
					</td>
				</tr>
				<tr>
					<td>
						更新手機資料庫(請使用Excel格式):
						<input id='file' type='file' name ="assignFile" />
						<input type="button" value="上傳" onclick='submitUpdateExcelform()'/>
						<input id='fileName' type='hidden' name='assignFileName' />
					</td>
				</tr>
			</table>
		</form >
		<table class="filtered_table" cellspacing="2">
<!-- 			ajaxRequestExcelFile(設定要顯示多少檔案至回復介面) -->
			<tr><td>回復手機資料庫:<input type="button" value="回復" onclick='ajaxRequestExcelFile(1, 3)'></td></tr>
		</table>
	</div>
</div>
<div id="message_dialog" style="display: none">
	<p id='pop_message'></p>
</div>
<div id="search_dialog" style="display: none">
	<p id='search_message'></p>
</div>
<div id="show_result_dialog" style="display: none"></div>
<div id="show_excel_file" style="display: none">
	<table style='width:350px'>
		<tr>
			<td>查詢第
				<input id='limit_start' type='number' style='width:80px' value='1'/>個~第
				<input id='limit_end' type='number' style='width:80px' value='3'/>個檔案?
			</td>
		</tr>
	</table>
	<form id='rollBack_form' action="rollbackExcelData.action" method ="post" enctype ="multipart/form-data"></form> 
</div>
<div id="footer" class="container">
	<div id="copyright" class="container">
		<p>台灣之星電信版權所有 Copyright© 2014 Taiwan Star Telecom Co., Ltd. All Rights Reserved.&nbsp;&nbsp;&nbsp;&nbsp;(最佳解析度1280X800)</p>
	</div>
</div>
</body>
</html>