<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>
<!DOCTYPE html>
<html><!-- InstanceBegin template="/Templates/basic_layout.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0" />
<title>專案預約登記</title>
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/c_default.css" />
<script src="${pageContext.request.contextPath}/js/jquery-1.9.1.js"></script>
<script src="${pageContext.request.contextPath}/js/c_default.js"></script>
<script>
	if('' != '${showMessage}'){
		alert('${showMessage}');
	};
	
    function refresh(obj){  
         obj.src = "RandomImg.do?" + Math.random();  
    };
    
    
  	//執行預約
	function makeReserve(){
		$("#reserveBtn").hide();
		
		var params = {
				verifyCode : $("#po_validation").val()
		};
		var errMsg = '';
		if('' == $("#po_name").val()){
			if('' != errMsg ? errMsg += ',' : '');
			errMsg += '姓名';
// 			alert('請輸入姓名');
// 			$("#reserveBtn").show();
// 			return false;
		}
		if('' == $("#po_celpon").val()){
			if('' != errMsg ? errMsg += ',' : '');
			errMsg += '手機號碼';
// 			alert('請輸入手機號碼');
// 			$("#reserveBtn").show();
// 			return false;
		}
		if('' == $("#po_landline").val()){
			if('' != errMsg ? errMsg += ',' : '');
			errMsg += '市內電話';
// 			alert('請輸入市內電話');
// 			$("#reserveBtn").show();
// 			return false;
		}
		if('' == $("#po_address").val()){
			if('' != errMsg ? errMsg += ',' : '');
			errMsg += '選擇門市';
// 			alert('請選擇門市');
// 			$("#reserveBtn").show();
// 			return false;
		}
		if(false == $("#tos").is(":checked")){
			if('' != errMsg ? errMsg += ',' : '');
			errMsg += '詳閱聲明告知事項';
// 			alert('請詳閱聲明告知事項');
// 			$("#reserveBtn").show();
// 			return false;
		}
		if('' == $("#po_validation").val()){
			if('' != errMsg ? errMsg += ',' : '');
			errMsg += '驗證碼';
// 			alert('請輸入驗證碼');
// 			$("#reserveBtn").show();
// 			return false;
		}
		if('' != errMsg){
			alert("請確認下列欄位\n" + errMsg);
			$("#reserveBtn").show();
			return false;
		}
		
		var s = $('#reserveForm').serialize();
		//以下是執行AJAX要求server端處理資料
		$.ajax({
			url: "reserve.action",
			type: 'POST', //根據實際情況，可以是'POST'或者'GET'
// 			data: params,
			data: s,
// 			dataType: 'xml', //指定數據類型，注意server要有一行：response.setContentType("text/xml;charset=utf-8");
			timeout: 300000, //設置timeout時間，以千分之一秒為單位，1000 = 1秒
			error: function (){	//錯誤提示
				alert ('系統忙碌中，請稍候再試!!');
				$("#reserveBtn").show();
			},
			success: function (xml){ //ajax請求成功後do something with xml
					//alert(xml.result);
					if('verify code fail' == xml.result){
						$('#randomImg').click();
						alert('請輸入正確的驗證碼');
						$("#reserveBtn").show();
					}else if('fail' == xml.result){
						alert('系統異常，請稍後再試');
						$("#reserveBtn").show();
					}else if('00000' == xml.result){
						alert('您已登記成功');
						window.location.href = "${pageContext.request.contextPath}/reservation.action";
					}else{
						alert('處裡失敗:' + xml.result);
						$("#reserveBtn").show();
					}
			}
		});	//$.ajax({
	};
	
	
	var resp = jQuery.parseJSON('${result}');
	var addrJson = resp.GetRstDMSStoreAddressIdRes.Store;
	
	$(function() {
		$('.number').keypress(validateNumber);
		
		$(addrJson).each(function() {
			//檢查縣市是否存在
			if ($("#po_store option:contains('"+this.County+"')").length < 1) {
				$("#po_store").append("<option value='"+this.County+"'>"+this.County+"</option>");
			}
		});
		$("#po_store").change(function() {
			$("#po_district").empty();
			$("#po_district").append("<option value=''>選擇區域</option>");
			$("#po_store_sel").empty();
			$("#po_store_sel").append("<option value=''>選擇門市</option>");
			$("#po_address").val("");
			$(addrJson).each(function() {
				if(this.County == $("#po_store").val()){
					//檢查區域是否存在
					if ($("#po_district option:contains('"+this.City+"')").length < 1) {
						$("#po_district").append("<option value='"+this.City+"'>"+this.City+"</option>");
					}
				}
			})
		});
		$("#po_district").change(function() {
			$("#po_store_sel").empty();
			$("#po_store_sel").append("<option value=''>選擇門市</option>");
			$("#po_address").val("");
			$(addrJson).each(function() {
				if(this.County == $("#po_store").val() && this.City == $("#po_district").val()){
					//檢查門市是否存在
					if ($("#po_store_sel option:contains('"+this.StoreName+"')").length < 1) {
						$("#po_store_sel").append("<option value='"+this.StoreId+"'>"+this.StoreName+"</option>");
					}
				}
			})
		});
		$("#po_store_sel").change(function() {
			$(addrJson).each(function() {
				if(this.StoreId == $("#po_store_sel").val()){
					$("#po_address").val(this.Address);
					$("#po_storeId").val(this.StoreId);
					$("#store_sel").val(this.StoreName);
				}
			})
		});
	});
	
	//validate number field
	function validateNumber(event) {
	    var key = window.event ? event.keyCode : event.which;
	    if (event.keyCode == 8 || event.keyCode == 46
	     || event.keyCode == 37 || event.keyCode == 39) {
	        return true;
	    }
	    else if ( key < 48 || key > 57 ) {
	        return false;
	    }
	    else return true;
	};
	function showNotice(){
		alert("•    目的：作為本次活動使用。\n•    用途：作為專案申辦聯繫事宜。\n•    處置：至蒐集目的消失為止。\n•    範圍：一般個資，『包含個人姓名、地址及聯絡電話』 參加者得向活動主辦單位申請資料閱覽給予複本、補充、更正、刪除或為其他之利用");
	};
</script>  
</head>
<body>
<div class="main_doc">
	<section class="pre_order">
		<h2 class="pre_order_title">專案預約登記</h2>
		<div class="sec_content">
			<form class="pre_order_form" id='reserveForm'>
				<div class="row po_name_row">
					<label for="po_name" class="required_item">姓名：</label>
					<input id="po_name" name="po_name" type="text" required />
				</div>
				<div class="row po_sex_row">
					<label class="required_item">性別：</label>
					<label><input type="radio" name="po_sex" value='男' checked required />男</label>
					<label><input type="radio" name="po_sex" value='女' />女</label>
				</div>
				<div class="row po_celpon_row">
					<label class="required_item" for="po_celpon">手機號碼：</label>
					<input class='number' id="po_celpon" name="po_celpon" type="tel" maxlength="10" required" />
				</div>
				<div class="row po_eml_row">
					<label for="po_eml">email：</label>
					<input id="po_eml" name="showMessage.setId" type="text" />
				</div>
				<div class="row po_landline_row">
					<label class="required_item" for="po_landline">市內電話：</label>
					<input id="po_landline" type="tel" required />
				</div>
				<div class="row po_store_row">
					<label class="required_item" for="po_store">服務門市：</label>
					<span class="custom_select">
						<select id="po_store">
							<option>選擇縣市</option>
						</select>
					</span>
					<span class="custom_select">
						<select id="po_district">
							<option value="選擇區域">選擇區域</option>
						</select>
					</span>
					<span class="custom_select">
						<select id="po_store_sel">
							<option value="選擇門市">選擇門市</option>
						</select>
					</span>
					<input id="po_address" name='po_address' type="text" />
					<input id="store_sel" name='po_store_sel' type="hidden" />
					<input id="po_storeId" name='po_storeId' type="hidden" />
				</div>
				<div class="row po_validation_row">
					<label for="po_validation" class="required_item">驗證碼：</label>
					<input id="po_validation" name='verifyCode' type="text" placeholder="請輸入下方驗證碼" maxlength="4" />
					<a href="javascript:;">
						<img id='randomImg' src="${pageContext.request.contextPath}/RandomImg.do" onclick="javascript:refresh(this);" />
					</a>
				</div>
				<div class="row po_note_row">
					若找不到您所在區域，表示該區尚無服務門市，請改選其他鄰近區域。<br>請詳實填寫資料，以便專人與您連繫(<span class="required_mark">＊</span>號為必填欄位)
				</div>
				<div class="row po_policy">
					<label><input id='tos' type="checkbox" required />我已詳閱<a href="javascript:void(0);" onclick="showNotice()">個人資料蒐集處理、利用聲明告知事項</a></label>
				</div>
				<div class="submit_po">
					<input id='reserveBtn' class="submit" type="button" value="確認送出" onclick='makeReserve()'/>
					<br /><br /><br /><br /><br /><br /><br /><br /><br />
				</div>
			</form>
		</div>
	</section>
</div>
</body>
</html>