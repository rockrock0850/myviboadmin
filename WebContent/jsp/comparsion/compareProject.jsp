<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html>
<html><!-- InstanceBegin template="/Templates/basic_layout.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0" />
<title>資費比一比</title>
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/c_default.css?2" />
<script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/js/c_default.js"></script>
<script src="${pageContext.request.contextPath}/js/tools.js"></script>
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
	ga('create', 'UA-54439660-4', 'auto');
</script>
<script>

/* 取得由Action傳來的JsonString，並將其轉成Json物件 */
var feeRangeJson = jQuery.parseJSON('${feeRangeData}');
var feeSelJson = jQuery.parseJSON('${feeSelData}');
var companySelData = jQuery.parseJSON('${companySelData}');
var companySelJson = companySelData.companySel;
var typeSelJson = jQuery.parseJSON('${typeSelData}');
var mobileData = jQuery.parseJSON('${mobileDataJson}');

var prefeeRange = '${fee_range}';
var prefeeSel = '${fee_sel}';
var prefeeSel1 = '${fee_sel1}';
var prefeeSel2 = '${fee_sel2}';
var preCompanySel = '${company_sel}';
var preTypeSel = '${fee_type}';
var isTakeNum = true;//控制  新用戶/攜碼與自動選擇方案連動
var limit3GAry = [188, 388];
var limit4GAry = [488, 588];

//佔存狀態接收並賦值
var tmp_cal_rule = '${tmp.cal_rule}';
var tmp_apply_type = '${tmp.apply_type}';
var tmp_company_sel = '${tmp.op_id}';
var tmp_fee_type = '${tmp.fee_type}';
var tmp_fee_range = '${tmp.fee_range}';
var tmp_fee_sel = '${tmp.fee_sel}';
var tmp_period = '${tmp.period}';
var tmp_project_code = '${tmp.project_code}';
var tmp_voice_on_net = '${tmp.voice_on_net}';
var tmp_voice_off_net = '${tmp.voice_off_net}';
var tmp_pstn = '${tmp.pstn}';
var tmp_data_usage = '${tmp.data_usage}';
var tmp_sms_on_net = '${tmp.sms_on_net}';
var tmp_sms_off_net = '${tmp.sms_off_net}';
var tmp_phone_code = '${tmp.phone_code}';

$(function() {
	logs('calRule:'+tmp_cal_rule+"\n"+
			'applyType:'+tmp_apply_type+'\n'+
			'companySel:'+tmp_company_sel+'\n'+
			'feeType:'+tmp_fee_type+'\n'+
			'feeRange:'+tmp_fee_range+'\n'+
			'feeSel:'+tmp_fee_sel+'\n'+
			'period:'+tmp_period+'\n'+
			'projectCode:'+tmp_project_code+'\n'+
			'voiceOnNet:'+tmp_voice_on_net+'\n'+
			'voiceOffNet:'+tmp_voice_off_net+'\n'+
			'pstn:'+tmp_pstn+'\n'+
			'dataUsage:'+tmp_data_usage+'\n'+
			'smsOnNet:'+tmp_sms_on_net+'\n'+
			'smsOffNet:'+tmp_sms_off_net+'\n'+
			'phoneCode:'+tmp_phone_code);
	limit3GAry.sort();
	limit4GAry.sort();
	
	/* 組成"電信公司"選項 */
    $(companySelJson).each(function() {
		$("#company_sel").append("<option value='"+this.value+"'>"+this.text+"</option>");
		$("#company_sel1").append("<option value='"+this.value+"'>"+this.text+"</option>");
		$("#company_sel2").append("<option value='"+this.value+"'>"+this.text+"</option>");
	});
    //組成資費類型
	$(typeSelJson).each(function() {
		$("#fee_type").append("<option value='"+this.value+"'>"+this.text+"</option>");
		$("#fee_type1").append("<option value='"+this.value+"'>"+this.text+"</option>");
		$("#fee_type2").append("<option value='"+this.value+"'>"+this.text+"</option>");
	});
    //組成手機
    $.each(mobileData[0], function(value, text){
    	$('#cell_phone1').append("<option value='"+value+"'>"+text+"</option>");
    	$('#cell_phone2').append("<option value='"+value+"'>"+text+"</option>");
    });
	$("#fee_type").change(function() {
		buildFeeRange();
		checkIsTypeSelect();
	});
	$("#company_sel1").change(function() {
		checkIsTypeSelect1();
	});
	$("#fee_type1").change(function() {
		buildFeeRange1();
	});
	$("#fee_type2").change(function() {
		buildFeeRange2();
		checkIsTypeSelect2();
	});
	$('#fee_sel1').change(function(){
		netSwitch1();
	});
	$('#fee_sel2').change(function(){
		netSwitch2();
	});
	
    //設定預設值
	if('' != preTypeSel){
		$("#fee_type").val(preTypeSel).change();
		$("#fee_range").val(prefeeRange).change();
		$("#fee_sel").val(prefeeSel);
		$("#fee_sel1").val(prefeeSel1);
		$("#fee_sel2").val(prefeeSel2);
		$("#company_sel").val(preCompanySel);
	}
	
	checkIsTypeSelect();
	checkIsTypeSelect1();
	checkIsTypeSelect2();
	//若我方無此方案，css的格式會跑版，需修正
	<c:if test='${empty projectInfoRateTstar.telecomName}'>
		$("#resultTable").find("tr:gt(1)").each(function(){
// 			$(this).find("td").css({"background":"white"});
		});
	</c:if>
	//預設選單初始化
	if(tmp_cal_rule == 'w_p'){//試算規則:手機專案
		$('input:radio[name=calRule]').filter('[value='+tmp_cal_rule+']').prop('checked', true);
		$('.with_phone').show();
		$('.without_phone').hide();
		if(tmp_apply_type != ''){//申裝類別
			$('input:radio[name=applyType]').filter('[value='+tmp_apply_type+']').prop('checked', true);
		}else{
			if('${applyType}' != '攜碼'){
				$('input:radio[name=applyType]').filter('[value=新用戶]').prop('checked', true);
			}else{
				$('input:radio[name=applyType]').filter('[value=攜碼]').prop('checked', true);
			}
		}
		if(tmp_company_sel != ''){//電信業者
			$('#company_sel1').val(tmp_company_sel);
			checkIsTypeSelect1();
			//其他選項
			$('#fee_type1').val(tmp_fee_type);
			buildFeeRange1();
			$('#period1').val(tmp_period);
			$('#voice_on_net1').val(tmp_voice_on_net);
			$('#voice_off_net1').val(tmp_voice_off_net);
			$('#pstn1').val(tmp_pstn);
			$('#data_usage1').val(tmp_data_usage);
			$('#sms_on_net1').val(tmp_sms_on_net);
			$('#sms_off_net1').val(tmp_sms_off_net);
			$('#cell_phone1').val(tmp_phone_code);
		    initStatus();
		}  
	}else if(tmp_cal_rule == 'w_o_p'){//試算規則:單門號
		$('input:radio[name=calRule]').filter('[value='+tmp_cal_rule+']').prop('checked', true);
		$('.without_phone').show();
		$('.with_phone').hide();
		if(tmp_fee_type != ''){//資費類型
			$('#fee_type2').val(tmp_fee_type);
			checkIsTypeSelect2();
			//其他選項
			buildFeeRange2();
			$('#period2').val(tmp_period);
			$('#voice_on_net2').val(tmp_voice_on_net);
			$('#voice_off_net2').val(tmp_voice_off_net);
			$('#pstn2').val(tmp_pstn);
			$('#data_usage2').val(tmp_data_usage);
			$('#sms_on_net2').val(tmp_sms_on_net);
			$('#sms_off_net2').val(tmp_sms_off_net);
			$('#cell_phone2').val(tmp_phone_code);
		    initStatus();
		} 
	}else{
		if('${calRule}' != 'w_o_p'){
			$('input:radio[name=calRule]').filter('[value=w_p]').prop('checked', true);
		}else{
			$('input:radio[name=calRule]').filter('[value=w_o_p]').prop('checked', true);
		}
	}  
	//偵測電信業者、資費類型、範圍變動時選擇資費的內容也更著更動
	autoBetter();
	//新用戶、攜碼替換時自動最佳方案跟著更動(目前功能被取消，要重啟記得把checkIsTypeSelect1()內的$('#auto_better').attr('disabled', false);mark掉)
// 	$('input:radio[name=applyType]').change(function(){
// 		if(isTakeNum){
// 			isTakeNum = false;
// 			$('#auto_better').attr('disabled', false);
// 			$("#auto_better").empty();
// 			$("#auto_better").append('<option value="" selected>自動選擇最佳方案</option>');
// 			if($("#company_sel1") != null && $("#fee_type1") != null && $("#fee_sel1") != null && $('#period1') != null){
// 				if($("#company_sel1").val() != "" && $("#fee_type1").val() != "" && $("#fee_sel1").val() != "" && $('#period1').val() != "請選擇"){
// 					projectList();
// 				}	
// 			}
// 		}else{
// 			isTakeNum = true;
// 			$('#auto_better').attr('disabled', true);
// 			$("#auto_better").empty();
// 			$("#auto_better").append('<option value="" selected>自動選擇最佳方案</option>');
// 		}
// 	});
});
function autoBetter(){
	ifAutoBetterChanged($("#company_sel1"), $("#fee_type1"), $("#fee_sel1"), $('#period1'));
	ifAutoBetterChanged($("#fee_type1"), $("#fee_range1"), $("#fee_sel1"), $('#period1'));
	ifAutoBetterChanged($("#fee_range1"), $("#fee_sel1"), $('#period1'), null);//為了讓資費範圍change時把選擇資費設空值，用null解決，因為change前fee_sel1還是抓的到值
	ifAutoBetterChanged($("#fee_sel1"), $("#fee_type1"), $("#company_sel1"), $('#period1'));
	ifAutoBetterChanged($('#period1'), $("#fee_type1"), $("#company_sel1"), $("#fee_sel1"));
};
function ifAutoBetterChanged(changer, chk_val1, chk_val2, chk_val3){
	changer.change(function() {
// 		if(!isTakeNum){//為了與radio[applyType]連動
			$("#auto_better").empty();
			$("#auto_better").append('<option value="" selected>自動選擇最佳方案</option>');
			if(changer.val() == "" || changer.val() == "請選擇"){
				$("#auto_better").empty();
				$("#auto_better").append('<option value="" selected>自動選擇最佳方案</option>');
			}else{
				if(chk_val1 != null && chk_val2 != null && chk_val3 != null){
					if(chk_val1.val() != "" && chk_val2.val() != "" && (chk_val3.val() != "請選擇" && chk_val3.val() != "")){
						projectList();
					}	
				}
			}
// 		}
	});
};

//資費類型有選，才能選其他選項
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
function checkIsTypeSelect1(){
	if('' == $("#company_sel1").val()){
		$('#fee_type1').attr('disabled', true);
		$('#fee_range1').attr('disabled', true);
		$('#fee_sel1').attr('disabled', true);
		$('#period1').attr('disabled', true);
		$('#auto_better').attr('disabled', true);
	}else{
		$('#fee_type1').attr('disabled', false);
		$('#fee_range1').attr('disabled', false);
		$('#fee_sel1').attr('disabled', false);
		$('#period1').attr('disabled', false);
		$('#auto_better').attr('disabled', false);
	}
};
function checkIsTypeSelect2(){
	if('' == $("#fee_type2").val()){
		$('#fee_range2').attr('disabled', true);
		$('#fee_sel2').attr('disabled', true);
		$('#company_sel2').attr('disabled', true);
		$('#period2').attr('disabled', true);
	}else{
		$('#fee_range2').attr('disabled', false);
		$('#fee_sel2').attr('disabled', false);
		$('#company_sel2').attr('disabled', false);
		$('#period2').attr('disabled', false);
	}
};
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
		$("#fee_sel").empty();
		$("#fee_sel").append('<option value="" selected>選擇資費</option>');
		
		var rangeSel = $("#fee_range").val();
		$(eval('feeSelJson["'+ rangeSel + '"]')).each(function() {
			$("#fee_sel").append("<option value='"+this.value+"'>"+this.text+"</option>");
		})
	});
};

function buildFeeRange1(){
	$("#fee_range1").empty();
	$("#fee_range1").append('<option value="" selected>資費範圍</option>');
	$("#fee_sel1").empty();
	$("#fee_sel1").append('<option value="" selected>選擇資費</option>');
	
	var typeSel = $("#fee_type1").val();
	$(eval("feeRangeJson['" + typeSel + "']")).each(function() {
		$("#fee_range1").append("<option value=" + this.value + ">"+this.text+"</option>");
	});
	if(tmp_fee_range != ''){
		$('#fee_range1').val(tmp_fee_range);
	}
	/* 根據所選的"資費範圍"組成"選擇資費"選項 */
	$("#fee_range1").change(function() {
		$("#fee_sel1").empty();
		$("#fee_sel1").append('<option value="" selected>選擇資費</option>');
		
		var rangeSel = $("#fee_range1").val();
		$(eval('feeSelJson["'+ rangeSel + '"]')).each(function() {
			$("#fee_sel1").append("<option value=" + this.value + ">" + this.text + "</option>");
		})
	});
	if(tmp_fee_sel != ''){
		$('#fee_range1').change();
		$('#fee_sel1').val(tmp_fee_sel);
		projectList();
	}
};

function buildFeeRange2(){
	$("#fee_range2").empty();
	$("#fee_range2").append('<option value="" selected>資費範圍</option>');
	$("#fee_sel2").empty();
	$("#fee_sel2").append('<option value="" selected>選擇資費</option>');
	
	var typeSel = $("#fee_type2").val();
	$(eval('feeRangeJson["'+ typeSel + '"]')).each(function() {
// 		$("#fee_range2").append("<option value='"+this.value+"'>"+this.text+"</option>");
		switch (typeSel) {
		case '3G':
			if(pickSel('低資費', this.text)){
				$("#fee_range2").append("<option value='"+this.value+"'>"+this.text+"</option>");
			}
			break;
		case '4G':
			if(pickSel('中資費', this.text)){
				$("#fee_range2").append("<option value='"+this.value+"'>"+this.text+"</option>");
			}
			break;
		}
	});
	if(tmp_fee_range != ''){
		$('#fee_range2').val(tmp_fee_range);
	}
	
	/* 根據所選的"資費範圍"組成"選擇資費"選項 */
	$("#fee_range2").change(function() {
		$("#fee_sel2").empty();
		$("#fee_sel2").append('<option value="" selected>選擇資費</option>');
		
		var rangeSel = $("#fee_range2").val();
		$(eval('feeSelJson["'+ rangeSel + '"]')).each(function() {
// 			$("#fee_sel2").append("<option value='"+this.value+"'>"+this.text+"</option>");
			var price = this.value.split('~');
			switch (typeSel) {
			case '3G':
				if(limitPrice(limit3GAry[limit3GAry.length - 1], price[0], price[1])){
					$("#fee_sel2").append("<option value='"+this.value+"'>"+this.text+"</option>");
				}
				break;
			case '4G':
				if(limitPrice(limit4GAry[limit4GAry.length - 1], price[0], price[1])){
					$("#fee_sel2").append("<option value='"+this.value+"'>"+this.text+"</option>");
				}
				break;
			}
		})
	});
	if(tmp_fee_sel != ''){
		$('#fee_range2').change();
		$('#fee_sel2').val(tmp_fee_sel);
	}
};
function netSwitch1() {
	$.ajax({
		url:"netSwitch.action",
		type:"POST",
		data:{
			'selectKey':$('#fee_type1').val() + '_' + $('#fee_range1').val() + '_' + $('#fee_sel1').val(),
		},
		dataType:'json',
		timeout:30000,
		error: function (){	//錯誤提示
			alert ('Error timeout');
		},
		success: function (data){ //ajax請求成功後do something with xml
			var json = $.parseJSON(data);
			inputer($('#voice_on_net1'), json.voice_on_net, json.voice_on_net, '0', '', '');
			inputer($('#voice_off_net1'), json.voice_off_net, json.voice_off_net, '0', '', '');
			inputer($('#pstn1'), json.pstn, json.pstn, '0', '', '');
			inputer($('#data_usage1'), json.data_usage, json.data_usage, '0', '', '');
			inputer($('#sms_on_net1'), json.sms_on_net, json.sms_on_net, '0', '', '');
			inputer($('#sms_off_net1'), json.sms_off_net, json.sms_off_net, '0', '', '');
		}
	});
};
function netSwitch2() {
	$.ajax({
		url:"netSwitch.action",
		type:"POST",
		data:{
			'selectKey':$('#fee_type2').val() + '_' + $('#fee_range2').val() + '_' + $('#fee_sel2').val(),
		},
		dataType:'json',
		timeout:30000,
		error: function (){	//錯誤提示
			alert ('Error timeout');
		},
		success: function (data){ //ajax請求成功後do something with xml
			var json = $.parseJSON(data);
			inputer($('#voice_on_net2'), json.voice_on_net, json.voice_on_net, '0', '', '');
			inputer($('#voice_off_net2'), json.voice_off_net, json.voice_off_net, '0', '', '');
			inputer($('#pstn2'), json.pstn, json.pstn, '0', '', '');
			inputer($('#data_usage2'), json.data_usage, json.data_usage, '0', '', '');
			inputer($('#sms_on_net2'), json.sms_on_net, json.sms_on_net, '0', '', '');
			inputer($('#sms_off_net2'), json.sms_off_net, json.sms_off_net, '0', '', '');
		}
	});
};
//專案比一比
function submitForm(){
	if(!alertController($("#fee_type"), '請選擇資費類型', '', false)){
		return false;
	}else if(!alertController($("#fee_range"), '請選擇資費範圍', '', false)){
		return false;
	}else if(!alertController($("#fee_sel"), '請選擇資費', '', false)){
		return false;
	}else if(!alertController($("#company_sel"), '請選擇要比較的電信業者', '', false)){
		return false;
	}else{
		//GA send
		ga('send', 'event', '專案比一比', $("#fee_type").val() + ' : ' + $("#fee_range option:selected").text(), $("#company_sel option:selected").text());
		$("#cf_form").submit();
		afterSubmit();
	}
};

//資費試算
function submitSinglePhoneForm(){
	if($('input:radio[name=calRule]:checked').val() == 'w_p'){
		//手機專案價
		if(!alertController($("#company_sel1"), '請選擇要比較的電信業者', '', false)){
			return false;
		}else if(!alertController($("#fee_type1"), '請選擇資費類型', '', false)){
			return false;
		}else if(!alertController($("#fee_range1"), '請選擇資費範圍', '', false)){
			return false;
		}else if(!alertController($("#fee_sel1"), '請選擇資費', '', false)){
			return false;
		}else if(!alertController($("#period1"), "請選擇約期", '', false)){
			return false;
		}else if(!alertController($("#voice_on_net1"), "網內分鐘數必須是數字", "請輸入網內分鐘數", true)){
			return false;
		}else if(!alertController($("#voice_off_net1"), "網外分鐘數必須是數字", "請輸入網外分鐘數", true)){
			return false;
		}else if(!alertController($("#pstn1"), "市話費率必須是數字", "請輸入市話費率", true)){
			return false;
		}else if(!alertController($("#data_usage1"), "上網傳輸量必須是數字", "請輸入上網傳輸量", true)){
			return false;
		}else if(!alertController($("#sms_on_net1"), "網內簡訊數必須是數字", "請輸入網內簡訊數", true)){
			return false;
		}else if(!alertController($("#sms_off_net1"), "網外簡訊數必須是數字", "請輸入網外簡訊數", true)){
			return false;
		}else if(!alertController($("#cell_phone1"), "請選擇手機", '', false)){
			return false;
		}else{
			//GA send
			ga('send', 'event', '資費試算', $("#fee_type1").val() + ' : ' + $("#fee_range1 option:selected").text(), $("#company_sel1 option:selected").text());
			$("#singlePhone_form").submit();
			afterSubmit();	
		}
	}else{
			//單門號
		if(!alertController($("#fee_type2"), '請選擇資費類型', '', false)){
			return false;
		}else if(!alertController($("#fee_range2"), '請選擇資費範圍', '', false)){
			return false;
		}else if(!alertController($("#fee_sel2"), '請選擇資費', '', false)){
			return false;
		}else if(!alertController($("#period2"), "請選擇約期", '', false)){
			return false;
		}else if(!alertController($("#voice_on_net2"), "網內分鐘數必須是數字", "請輸入網內分鐘數", true)){
			return false;
		}else if(!alertController($("#voice_off_net2"), "網外分鐘數必須是數字", "請輸入網外分鐘數", true)){
			return false;
		}else if(!alertController($("#pstn2"), "市話費率必須是數字", "請輸入市話費率", true)){
			return false;
		}else if(!alertController($("#data_usage2"), "上網傳輸量必須是數字", "請輸入上網傳輸量", true)){
			return false;
		}else if(!alertController($("#sms_on_net2"), "網內簡訊數必須是數字", "請輸入網內簡訊數", true)){
			return false;
		}else if(!alertController($("#sms_off_net2"), "網外簡訊數必須是數字", "請輸入網外簡訊數", true)){
			return false;
		}else if(!alertController($("#cell_phone2"), "請選擇手機", '', false)){
			return false;
		}else{
			//GA send
			ga('send', 'event', '資費試算', $("#fee_type2").val() + ' : ' + $("#fee_range2 option:selected").text(), $("#company_sel2 option:selected").text());
			$("#singlePhone_form").submit();
			afterSubmit();
		}
	}
};

function afterSubmit(){
	
	var currentAttrValue = jQuery('.tabs .tab-links .active a').attr('href');
	 
    // Show/Hide Tabs
    jQuery('.tabs ' + currentAttrValue).show().siblings().hide();

    // Change/remove current tab to active
    jQuery(this).parent('li').addClass('active').siblings().removeClass('active');
    isTakeNum = true;
//     e.preventDefault();
};

function alertEmptyResult(){
	if('' != prefeeRange){
		alert('依您設定的條件目前無相關方案可進行比一比，請重新設定。');
	}	
};

function projectList(){
// 	alert($('#fee_sel1').val());
	var range = $('#fee_sel1').val().split("~");
	$.ajax({
		url: "projectList.action",
		type: 'POST', //根據實際情況，可以是'POST'或者'GET'
		data: {
			'queryCompareProject1Dto.op_id': $('#company_sel1').val(),
			'queryCompareProject1Dto.gtype': $('#fee_type1').val(),
			'queryCompareProject1Dto.range_from': range[0],
			'queryCompareProject1Dto.range_to': range[1],
		},
		dataType: 'json', //指定數據類型，注意server要有一行：response.setContentType("text/xml;charset=utf-8");
		timeout: 300000, //設置timeout時間，以千分之一秒為單位，1000 = 1秒
		error: function (){	//錯誤提示
			alert ('系統忙碌中，請稍候再試!!');
		},
		success: function (data){ //ajax請求成功後do something with xml
				var json = $.parseJSON(data);
// 				alert(json);
				$.each(json.data, function(key, obj){
// 					alert(this.Project_name);
					if(this.Period == $('#period1').val()){
						$("#auto_better").append("<option value=" + this.Project_code + ">" + this.Project_name + "</option>");
					}
					if(tmp_project_code != ''){
						$('#auto_better').val(tmp_project_code);
					    initStatus();
					}
				});
		}
	});
};
function initStatus(){
	tmp_cal_rule = '';
	tmp_apply_type = '';
	tmp_company_sel = '';
	tmp_fee_type = '';
	tmp_fee_range = '';
	tmp_fee_sel = '';
	tmp_period = '';
	tmp_project_code = '';
	tmp_voice_on_net = '';
	tmp_voice_off_net = '';
	tmp_pstn = '';
	tmp_data_usage = '';
	tmp_sms_on_net = '';
	tmp_sms_off_net = '';
	tmp_phone_code = '';
};
</script>
</head>
<c:choose> 
	<c:when test='${not empty projectInfoRateTstar.telecomName or not empty projectInfoRateChosen.telecomName}'>
		<body>
	</c:when>
	<c:otherwise>
		<body style='background:#FFF;'>
	</c:otherwise>
</c:choose>
<!-- <input type='button' value='ajax測試' onclick='netSwitch1()' /> -->
<div class="main_doc">
	<section>
		<ul class="n_tab" tab-switch="my-tab">
			<c:if test = "${empty tab}">
				<li hidden="true">專案比一比</li>
				<li hidden="true" class="active">資費試算</li>
			</c:if>
			<c:if test = "${tab == 'tab1'}">   
	      		<li hidden="true" class="active">專案比一比</li>
				<li hidden="true">資費試算</li>
			</c:if>
			<c:if test = "${tab == 'tab2'}">   
	      		<li hidden="true">專案比一比</li>
				<li hidden="true" class="active">資費試算</li>
			</c:if>
		</ul>
		<div tab-target="my-tab">
			<div>
				<div id="tab1" class="tab active">
					<div class="main_doc">
						<form id='cf_form' method='post' action='compare.action'>
							<input type="hidden" name="tab" value="tab1" />
							<div class="row fee_range_row">
								<label for="fee_range">資費類型：</label> <span class="custom_select">
									<select id="fee_type" name="fee_type">
										<option value="">請選取資費類型</option>
								</select>
								</span>
							</div>
							<div class="row fee_range_row">
								<label for="fee_range">資費範圍：</label> <span class="custom_select">
									<select id="fee_range" name="fee_range">
										<option value="">資費範圍</option>
									</select>
								</span>
								<span class="custom_select">
									<select id="fee_sel" name='fee_sel'>
										<option value="">選擇資費</option>
									</select>
								</span>
							</div>
							<div class="row company_sel_row">
								<label for="company_sel">電信業者：</label>
									<span class="custom_select"> <select id="company_sel" name='company_sel'>
									<option value="">選擇其他電信業者</option>
								</select>
								</span>
								<input class="submit" type="button" onclick='submitForm()' value="查詢" />
							</div>
						</form>
							<c:if test='${not empty projectRateTstar.telName or not empty projectRateChosen.telName}'>
								<table class="filtered_table" id="resultTable">
									<tr>
										<th>電信業者</th>
										<%-- <td>${projectRateTstar.telName}</td> --%>
										<c:if test='${empty projectRateTstar.rateName}'>
											<td>台灣之星</td>
										</c:if>
										<c:if test='${not empty projectRateTstar.rateName}'>
											<td>${projectRateTstar.telName}</td>
										</c:if>
										<c:if test='${empty projectRateChosen.rateName}'>
											<td>${companyName}</td>
										</c:if>
										<c:if test='${not empty projectRateChosen.rateName}'>
											<td>${projectRateChosen.telName}</td>
										</c:if>
									</tr>
									<tr>
										<th>專案名稱</th>
										<%-- <td>${projectRateTstar.rateName}</td> --%>
										<c:if test='${empty projectRateTstar.rateName}'>
											<td rowspan='${fn:length(projectDevicemap) * 2 + 10}'>目前無此資費</td>
										</c:if>
										<c:if test='${not empty projectRateTstar.rateName}'>
											<td>${projectRateTstar.rateName}</td>
										</c:if>
										<c:if test='${empty projectRateChosen.rateName}'>
											<td rowspan='${fn:length(projectDevicemap) * 2 + 10}'>目前無此資費</td>
										</c:if>
										<c:if test='${not empty projectRateChosen.rateName}'>
											<td>${projectRateChosen.rateName}</td>
										</c:if>
									</tr>
									<tr>
										<th>月付金額</th>
										<c:if test='${not empty projectRateTstar.rateName}'>
											<td>
												$<fmt:formatNumber type="currency" currencySymbol="$" pattern="#,##0;" value="${projectRateTstar.chargesMonth}" />
											</td>
										</c:if>
										<c:if test='${not empty projectRateChosen.rateName}'>
											<td>
												$<fmt:formatNumber type="currency" currencySymbol="$" pattern="#,##0;" value="${projectRateChosen.chargesMonth}" />
											</td>
										</c:if>
									</tr>
									<tr>
										<th>上網傳輸量</th>
										<c:if test='${not empty projectRateTstar.rateName}'>
											<td>${projectRateTstar.netVolDesc}</td>
										</c:if>
										<c:if test='${not empty projectRateChosen.rateName}'>
											<td>${projectRateChosen.netVolDesc}</td>
										</c:if>
									</tr>
									<tr>
										<th>網內語音</th>
										<c:if test='${not empty projectRateTstar.rateName}'>
											<td>${projectRateTstar.voiceOnNetSec}</td>
										</c:if>
										<c:if test='${not empty projectRateChosen.rateName}'>
											<td>${projectRateChosen.voiceOnNetSec}</td>
										</c:if>
									</tr>
									<tr>
										<th>網外語音</th>
										<c:if test='${not empty projectRateTstar.rateName}'>
											<td>${projectRateTstar.voiceOffNetSec}</td>
										</c:if>
										<c:if test='${not empty projectRateChosen.rateName}'>
											<td>${projectRateChosen.voiceOffNetSec}</td>
										</c:if>
									</tr>
									<tr>
										<th>市話</th>
										<c:if test='${not empty projectRateTstar.rateName}'>
											<td>${projectRateTstar.pstn}</td>
										</c:if>
										<c:if test='${not empty projectRateChosen.rateName}'>
											<td>${projectRateChosen.pstn}</td>
										</c:if>
									</tr>
									<tr>
										<th>簡訊</th>
										<c:if test='${not empty projectRateTstar.rateName}'>
											<td>${projectRateTstar.mms}</td>
										</c:if>
										<c:if test='${not empty projectRateChosen.rateName}'>
											<td>${projectRateChosen.mms}</td>
										</c:if>
									</tr>
									<tr>
										<th>額外贈送</th>
										<c:if test='${not empty projectRateTstar.rateName}'>
											<td>${projectRateTstar.freeVoiceDesc}</td>
										</c:if>
										<c:if test='${not empty projectRateChosen.rateName}'>
											<td>${projectRateChosen.freeVoiceDesc}</td>
										</c:if>
									</tr>
									<tr style="border-bottom-width: 2px; border-bottom-style: solid; border-bottom-color: rgb(48, 48, 48);">
										<th>合約期限(月)</th>
										<c:if test='${not empty projectRateTstar.rateName}'>
											<td>${projectRateTstar.contractMonths}</td>
										</c:if>
										<c:if test='${not empty projectRateChosen.rateName}'>
											<td>${projectRateChosen.contractMonths}</td>
										</c:if>
									</tr>
									<c:forEach items="${ProjectDeviceDtoOrder}" var="project">
									    <tr>
											<th>${project.projectName}</th>
											<c:if test='${not empty projectRateTstar.rateName}'>
												<td>$<fmt:formatNumber type="currency" currencySymbol="$" pattern="#,##0;" value="${project.priceTstar}" /></td>
											</c:if>
											<c:if test='${not empty projectRateChosen.rateName}'>
												<td>$<fmt:formatNumber type="currency" currencySymbol="$" pattern="#,##0;" value="${project.priceChosen}" /></td>
											</c:if>
										</tr>
										<tr class='t_height' style="border-bottom-width: 2px; border-bottom-style: solid; border-bottom-color: rgb(48, 48, 48);">
											<th>攜碼價格</th>
											<c:if test='${not empty projectRateTstar.rateName}'>
												<td>$<fmt:formatNumber type="currency" currencySymbol="$" pattern="#,##0;" value="${project.prepaymentAmountTstar}" /></td>
											</c:if>
											<c:if test='${not empty projectRateChosen.rateName}'>
												<td>$<fmt:formatNumber type="currency" currencySymbol="$" pattern="#,##0;" value="${project.prepaymentAmountChosen}" /></td>
											</c:if>
										</tr>
									</c:forEach>
								</table>
								<div>
									<font style='color:red; font-size:10px'>${psString}</font>
								</div>
								<div class="apply_plan">
									<a class="submit" href="reservation.action" onclick="ga('send', 'event', '專案比一比', '我要預約');false">我有興趣</a>
								</div>
							</c:if>
					</div>
				</div>
			</div>

			
			<c:if test='${calRule == "w_o_p"}'>
				<jsp:include page="comparsionNoPhone.jsp"></jsp:include>
			</c:if>
			<c:if test='${calRule == "w_p"}'>
				<jsp:include page="comparsionPhone.jsp"></jsp:include>
			</c:if>
			<c:if test='${empty calRule}'>
				<form id='singlePhone_form' method='post' action='comparebybsc.action'>
					<input type="hidden" name="tab" value="tab2" />
					<div class="n_sec_content">
						<div class="n_row">
							<label style="width: 85px; padding: 0;">試算規則 :</label>
							<label class="n_label">
								<input type="radio" id="w_p" name="calRule" value='w_p'>手機專案
							</label>
							<label class="n_label">
								<input type="radio" id="w_o_p" name="calRule" value='w_o_p'>單門號
							</label>
						</div>
						
						<!-- 手機專案價 -->
						<div class="with_phone">
							<div class="n_row">
								<label style="width: 85px; padding: 0;">申裝類別 :</label>
								<label class="n_label">
									<input type="radio" name="applyType" value="新用戶" checked="checked">新用戶
								</label>
								<label class="n_label">
									<input type="radio" name="applyType" value="攜碼">攜碼
								</label>
							</div>
							<div class="n_row">
								<label style="display: block; padding: 0 0 5px 0;">您目前使用的電信業者:</label>
								<span class="custom_select">
									<select id="company_sel1" name='queryCompareProject1Dto.op_id' style="width: 290px; box-sizing: border-box;">
										<option value="">選擇其他電信業者</option>
									</select>
								</span>
							</div>
							<div class="n_row">
								<label style="width: 85px; padding: 0;">資費類型 :</label>
								<span class="custom_select">
									<select id="fee_type1" name="queryCompareProject1Dto.gtype">
										<option value="">請選取資費類型</option>
									</select>
								</span>
							</div>
							<div class="n_row">
								<label style="width: 85px; padding: 0;">資費範圍 :</label>
								<span class="custom_select">
									<select id="fee_range1" style="width: 201px;box-sizing: border-box;" name="queryCompareProject1Dto.fee_range" disabled="disabled">
										<option value="">資費範圍</option>
									</select>
								</span>
								<div style="height: 6px;"></div>
								<label style="width: 85px; padding: 0;"></label>
								<span class="custom_select">
									<select id="fee_sel1" name="queryCompareProject1Dto.fee_sel">
										<option value="">選擇資費</option>
									</select>
								</span>
							</div>
							<div class="n_row">
								<label style="width: 85px; padding: 0;">約期 :</label>
								 <span class="custom_select"> 
									<select id="period1" style="width: 201px; box-sizing: border-box;" name="queryCompareProject1Dto.period">
										<option>請選擇</option>
<!-- 										<option value='12'>12</option> -->
										<option value='24'>24</option>
										<option value='30'>30</option>
									</select>
								</span>
							</div>
							<div class="n_row">
								<label style="width: 85px; padding: 0;">選擇資費 :</label>
								<span class="custom_select">
									<select id="auto_better" name="queryCompareProject1Dto.project_code">
										<option value="">自動選擇最佳方案</option>
									</select>
								</span>
							</div>
							<div class="n_row">
								<label style="width: 85px; padding: 0;">網內 :</label>
								<input id="voice_on_net1" type="text" style="width: 150px; box-sizing: border-box;" name="queryCompareProject1Dto.voice_on_net"/>
								<label>分鐘</label>
							</div>
							<div class="n_row">
								<label style="width: 85px; padding: 0;">網外 :</label>
								<input id="voice_off_net1" type="text" style="width: 150px; box-sizing: border-box;" name="queryCompareProject1Dto.voice_off_net"/>
								<label>分鐘</label>
							</div>
							<div class="n_row">
								<label style="width: 85px; padding: 0;">市話 :</label>
								<input id="pstn1" type="text" style="width: 150px; box-sizing: border-box;" name="queryCompareProject1Dto.pstn"/>
								<label>分鐘</label>
							</div>
							<div class="n_row">
								<label style="width: 85px; padding: 0;">上網傳輸量 :</label>
								<input id="data_usage1" type="text" style="width: 150px; box-sizing: border-box;" name="queryCompareProject1Dto.data_usage"/>
								<label>GB</label>
							</div>
							<div class="n_row">
								<label style="width: 85px; padding: 0;">網內簡訊 :</label> 
								<input id="sms_on_net1" type="text" style="width: 150px; box-sizing: border-box;" name="queryCompareProject1Dto.sms_on_net"/>
								<label>則</label>
							</div>
							<div class="n_row">
								<label style="width: 85px; padding: 0;">網外簡訊 :</label>
								<input id="sms_off_net1" type="text" style="width: 150px; box-sizing: border-box;" name="queryCompareProject1Dto.sms_off_net"/>
								<label>則</label>
							</div>
							<div class="n_row">
								<label style="width: 85px; padding: 0;">手機 :</label>
								<span class="custom_select">
									<select id="cell_phone1" name="queryCompareProject1Dto.phone_code" style="width: 201px; box-sizing: border-box;">
										<option value="">請選擇</option>
									</select>
								</span>
							</div>
							<div class="submit_po">
								<input id="phone" class="submit" type="button" value="確認送出" onclick='submitSinglePhoneForm()'>
							</div>
						</div>
						
						<!-- 單門號 -->
						<div class="without_phone" style="display: none;">
							<div class="n_row">
								<label style="width: 85px; padding: 0;">資費類型 :</label>
								<span class="custom_select">
									<select id="fee_type2" name="queryCompareProject2Dto.gtype" style="width: 201px; box-sizing: border-box;">
										<option value="">請選取資費類型</option>
									</select>
								</span>
							</div>
							<div class="n_row">
								<label style="width: 85px; padding: 0;">資費範圍 :</label>
								<span class="custom_select">
									<select id="fee_range2" name="queryCompareProject2Dto.fee_range" style="width: 201px; box-sizing: border-box;">
										<option value="">資費範圍</option>
									</select>
								</span>
								<div style="height: 6px;"></div>
								<label style="width: 85px; padding: 0;"></label> <span
									class="custom_select">
									<select id="fee_sel2" name='queryCompareProject2Dto.fee_sel' style="width: 201px; box-sizing: border-box;" disabled="disabled">
										<option value="">選擇資費</option>
									</select>
								</span>
							</div>
							<div class="n_row" hidden="true">
								<label style="width: 85px; padding: 0;">約期 :</label>
								<span class="custom_select">
									<select id="period2" style="width: 201px; box-sizing: border-box;" name='queryCompareProject2Dto.period'>
										<option>30</option>
<!-- 										<option value='12'>12</option> -->
<!-- 										<option value='24'>24</option> -->
<!-- 										<option value='30'>30</option> -->
									</select>
								</span>
							</div>
							<div class="n_row">
								<label style="width: 85px; padding: 0;">網內 :</label>
								<input id="voice_on_net2" type="text" style="width: 150px; box-sizing: border-box;" name='queryCompareProject2Dto.voice_on_net'/>
								<label>分鐘</label>
							</div>
							<div class="n_row">
								<label style="width: 85px; padding: 0;">網外 :</label>
								<input id="voice_off_net2" type="text" style="width: 150px; box-sizing: border-box;" name='queryCompareProject2Dto.voice_off_net'/>
								<label>分鐘</label>
							</div>
							<div class="n_row">
								<label style="width: 85px; padding: 0;">市話 :</label>
								<input id="pstn2" type="text" style="width: 150px; box-sizing: border-box;" name='queryCompareProject2Dto.pstn'/>
								<label>分鐘</label>
							</div>
							<div class="n_row">
								<label style="width: 85px; padding: 0;">上網傳輸量 :</label>
								<input id="data_usage2" type="text" style="width: 150px; box-sizing: border-box;" name='queryCompareProject2Dto.data_usage'/>
								<label>GB</label>
							</div>
							<div class="n_row">
								<label style="width: 85px; padding: 0;">網內簡訊 :</label>
								<input id="sms_on_net2" type="text" style="width: 150px; box-sizing: border-box;" name='queryCompareProject2Dto.sms_on_net'/>
								<label>則</label>
							</div>
							<div class="n_row">
								<label style="width: 85px; padding: 0;">網外簡訊 :</label>
								<input id="sms_off_net2" type="text" style="width: 150px; box-sizing: border-box;" name='queryCompareProject2Dto.sms_off_net'/>
								<label>則</label>
							</div>
							<div class="n_row">
								<label style="width: 85px; padding: 0;">手機 :</label>
								<span class="custom_select">
										<select id="cell_phone2" name="queryCompareProject2Dto.phone_code" style="width: 201px; box-sizing: border-box;">
											<option value="">請選擇</option>
										</select>
								</span>
							</div>
							<div class="submit_po">
								<input id="no_phone" class="submit" type="button" value="確認送出" onclick='submitSinglePhoneForm()'>
							</div>
						</div>
					</div>
				</form>
			</c:if>
		</div>
	</section>
</div>	
</body>
</html>