<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<!DOCTYPE html>
<html><!-- InstanceBegin template="/Templates/basic_layout.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0" />
<title>資費比一比</title>
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/c_default.css?2" />
<script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/js/c_default.js"></script>
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
var prefeeRange = '${fee_range}';
var prefeeSel = '${fee_sel}';
var preCompanySel = '${company_sel}';
var preTypeSel = '${fee_type}';

$(function() {
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
    
	$("#fee_type").change(function() {
		buildFeeRange();
		checkIsTypeSelect();
	});
	
	$("#company_sel1").change(function() {
		checkIsTypeSelect1();
	});
	
	$("#fee_type1").change(function() {
		buildFeeRange1();
		checkIsTypeSelect1();
	});
	$("#fee_type2").change(function() {
		buildFeeRange2();
		checkIsTypeSelect2();
	});
    //設定預設值
	if('' != preTypeSel){
		$("#fee_type").val(preTypeSel).change();
		$("#fee_range").val(prefeeRange).change();
		$("#fee_sel").val(prefeeSel);
		$("#company_sel").val(preCompanySel);
	}
	
	checkIsTypeSelect();
	checkIsTypeSelect1();
	checkIsTypeSelect2();
	//若我方無此方案，css的格式會跑版，需修正
	<c:if test='${empty projectInfoRateTstar.telecomName}'>
		$("#resultTable").find("tr:gt(1)").each(function(){
			$(this).find("td").css({"background":"white"});
		});
	</c:if>
	//試算規則預設選單
	if('${calRule}' != 'w_o_p'){
		$('input:radio[name=calRule]').filter('[value=w_p]').prop('checked', true);
	}else{
		$('input:radio[name=calRule]').filter('[value=w_o_p]').prop('checked', true);
	}
});

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
	}else{
		$('#fee_type1').attr('disabled', false);
		$('#fee_range1').attr('disabled', false);
		$('#fee_sel1').attr('disabled', false);
	}
};
function checkIsTypeSelect2(){
	if('' == $("#fee_type2").val()){
		$('#fee_range2').attr('disabled', true);
		$('#fee_sel2').attr('disabled', true);
		$('#company_sel2').attr('disabled', true);
	}else{
		$('#fee_range2').attr('disabled', false);
		$('#fee_sel2').attr('disabled', false);
		$('#company_sel2').attr('disabled', false);
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
	$(eval('feeRangeJson["'+ typeSel + '"]')).each(function() {
		$("#fee_range1").append("<option value='"+this.value+"'>"+this.text+"</option>");
	});
	
	/* 根據所選的"資費範圍"組成"選擇資費"選項 */
	$("#fee_range1").change(function() {
		$("#fee_sel1").empty();
		$("#fee_sel1").append('<option value="" selected>選擇資費</option>');
		
		var rangeSel = $("#fee_range1").val();
		$(eval('feeSelJson["'+ rangeSel + '"]')).each(function() {
			$("#fee_sel1").append("<option value='"+this.value+"'>"+this.text+"</option>");
		})
	});
};

function buildFeeRange2(){
	$("#fee_range2").empty();
	$("#fee_range2").append('<option value="" selected>資費範圍</option>');
	$("#fee_sel2").empty();
	$("#fee_sel2").append('<option value="" selected>選擇資費</option>');
	
	var typeSel = $("#fee_type2").val();
	$(eval('feeRangeJson["'+ typeSel + '"]')).each(function() {
		$("#fee_range2").append("<option value='"+this.value+"'>"+this.text+"</option>");
	});
	
	/* 根據所選的"資費範圍"組成"選擇資費"選項 */
	$("#fee_range2").change(function() {
		$("#fee_sel2").empty();
		$("#fee_sel2").append('<option value="" selected>選擇資費</option>');
		
		var rangeSel = $("#fee_range2").val();
		
		$(eval('feeSelJson["'+ rangeSel + '"]')).each(function() {
			$("#fee_sel2").append("<option value='"+this.value+"'>"+this.text+"</option>");
		})
	});
};
//專案比一比
function submitForm(){
	if('' == $("#fee_type").val()){
		alert('請選擇資費類型');
		return false;
	}
	if('' == $("#fee_range").val()){
		alert('請選擇資費範圍');
		return false;
	}
	if('' == $("#fee_sel").val()){
		alert('請選擇資費');
		return false;
	}
	if('' == $("#company_sel").val()){
		alert('請選擇要比較的電信業者');
		return false;
	}
	
	//GA send
	ga('send', 'event', '專案比一比', $("#fee_type").val() + ' : ' + $("#fee_range option:selected").text(), $("#company_sel option:selected").text());
	
	$("#cf_form").submit();
	
	afterSubmit();
};

//資費試算
function submitSinglePhoneForm(){
	$("#singlePhone_form").submit();
	afterSubmit();
}

function afterSubmit(){
	
	var currentAttrValue = jQuery('.tabs .tab-links .active a').attr('href');
	 
    // Show/Hide Tabs
    jQuery('.tabs ' + currentAttrValue).show().siblings().hide();

    // Change/remove current tab to active
    jQuery(this).parent('li').addClass('active').siblings().removeClass('active');

    e.preventDefault();
}



function alertEmptyResult(){
	if('' != prefeeRange){
		alert('依您設定的條件目前無相關方案可進行比一比，請重新設定。');
	}	
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
	
<div class="main_doc">
	<section>
		<ul class="n_tab" tab-switch="my-tab">
			<c:if test = "${empty tab}">
				<li class="active">專案比一比</li>
				<li >資費試算</li>
			</c:if>
			<c:if test = "${tab == 'tab1'}">   
	      		<li class="active">專案比一比</li>
				<li>資費試算</li>
			</c:if>
			<c:if test = "${tab == 'tab2'}">   
	      		<li>專案比一比</li>
				<li class="active">資費試算</li>
			</c:if>
		</ul>
		<div tab-target="my-tab">
			<div>
				<div id="tab1" class="tab active">
					<div class="main_doc">
						<form class="cf_form" id='cf_form' method='post' action='compareResult.action'>
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
						<c:if
							test='${not empty projectInfoRateTstar.telecomName or not empty projectInfoRateChosen.telecomName}'>
							<table class="filtered_table" id="resultTable">
								<tr>
									<th>電信業者</th>
									<%-- <td>${projectRateTstar.telName}</td> --%>
									<c:if test='${empty projectInfoRateTstar.telecomName}'>
										<td>台灣之星</td>
									</c:if>
									<c:if test='${not empty projectInfoRateTstar.telecomName}'>
										<td>${projectInfoRateTstar.telecomName}</td>
									</c:if>
									<c:if test='${empty projectInfoRateChosen.telecomName}'>
										<td>${companyName}</td>
									</c:if>
									<c:if test='${not empty projectInfoRateChosen.telecomName}'>
										<td>${projectInfoRateChosen.telecomName}</td>
									</c:if>
								</tr>
								<tr>
									<th>專案名稱</th>
									<%-- <td>${projectRateTstar.rateName}</td> --%>
									<c:if test='${empty projectInfoRateTstar.projectName}'>
										<td rowspan='${fn:length(projectDevicemap) * 2 + 10}'>目前無此資費</td>
									</c:if>
									<c:if test='${not empty projectInfoRateTstar.projectName}'>
										<td>${projectInfoRateTstar.projectName}</td>
									</c:if>
									<c:if test='${empty projectInfoRateChosen.projectName}'>
										<!-- <td rowspan='${fn:length(projectDevicemap) * 2 + 10}'>目前無此資費</td> -->
										<td rowspan='${fn:length(projectDevicemap) * 2 + 10}'>目前無此資費</td>
									</c:if>
									<c:if test='${not empty projectInfoRateChosen.projectName}'>
										<td>${projectInfoRateChosen.projectName}</td>
									</c:if>
								</tr>
								<tr>
									<th>月付金額</th>
									<c:if test='${not empty projectInfoRateTstar.projectRate}'>
										<td>
											$<fmt:formatNumber type="currency" currencySymbol="$" pattern="#,##0;" value="${projectInfoRateTstar.projectRate}" />
										</td>
									</c:if>
									<c:if test='${not empty projectInfoRateChosen.projectRate}'>
										<td>
											$<fmt:formatNumber type="currency" currencySymbol="$" pattern="#,##0;" value="${projectInfoRateChosen.projectRate}" />
										</td>
									</c:if>
								</tr>
								<tr>
									<th>上網傳輸量</th>
									<c:if test='${not empty projectInfoRateTstar.freeDataAmount}'>
										<c:choose>
											<c:when test="${projectInfoRateTstar.freeDataAmount == 'NA'}">
												<td>上網吃到飽</td>
											</c:when>
											<c:otherwise>
												<c:set var="flow" scope="session"
													value="${projectInfoRateTstar.freeDataAmount/1000}" />
												<c:if test="${flow >= 1}">
													<td>每月免費傳輸量:<fmt:formatNumber value="${flow}"
															pattern="#.##" />GB </br>
												</c:if>
												<c:if test="${flow < 1}">
													<td>每月免費傳輸量:<fmt:formatNumber value="${flow}"
															pattern="#.##" />MB</br>
												</c:if>
												<c:if
													test="${not empty projectInfoRateTstar.freeDataMonth && projectInfoRateTstar.freeDataMonth !=0}">
					  			前${projectInfoRateTstar.freeDataMonth}個月上網吃到飽<br>
												</c:if>
												<c:if
													test="${not empty projectInfoRateTstar.dataOverCostMb && projectInfoRateTstar.dataOverCostMb !=0.0}">
					  			超量每MB:${projectInfoRateTstar.dataOverCostMb}元<br>
												</c:if>
												</td>
											</c:otherwise>
										</c:choose>
									</c:if>

									<c:if test='${not empty projectInfoRateChosen.freeDataAmount}'>
										<c:choose>
											<c:when
												test="${projectInfoRateChosen.freeDataAmount == 'NA'}">
												<td>上網吃到飽</td>
											</c:when>
											<c:otherwise>
												<c:set var="flow" scope="session"
													value="${projectInfoRateChosen.freeDataAmount/1000}" />
												<c:if test="${flow >= 1}">
													<td>每月免費傳輸量:<fmt:formatNumber value="${flow}"
															pattern="#.##" />GB</br>
												</c:if>
												<c:if test="${flow < 1}">
													<td>每月免費傳輸量:<fmt:formatNumber value="${flow}"
															pattern="#.##" />MB</br>
												</c:if>
												<c:if
													test="${not empty projectInfoRateChosen.freeDataMonth && projectInfoRateChosen.freeDataMonth !=0}">
					  			前${projectInfoRateChosen.freeDataMonth}個月上網吃到飽<br>
												</c:if>
												<c:if
													test="${not empty projectInfoRateChosen.dataOverCostMb && projectInfoRateChosen.dataOverCostMb !=0.0}">
					  			超量每MB:${projectInfoRateChosen.dataOverCostMb}元<br>
												</c:if>
												</td>
											</c:otherwise>
										</c:choose>
									</c:if>

								</tr>
								<tr>
									<th>網內語音</th>
									<c:if
										test='${not empty projectInfoRateTstar.voiceOnNetFreeMonthly}'>
										<c:choose>
											<c:when
												test="${projectInfoRateTstar.voiceOnNetFreeMonthly == 'NA'}">
												<td>網內語音免費</td>
											</c:when>
											<c:otherwise>
												<td><c:if
														test='${not empty projectInfoRateTstar.voiceOnNetFreeEachTime && projectInfoRateTstar.voiceOnNetFreeEachTime !=0}'>
														<!-- 每通前${projectInfoRateTstar.voiceOnNetFreeEachTime / 60}分鐘免費 -->
								每通前<fmt:formatNumber
															value="${projectInfoRateTstar.voiceOnNetFreeEachTime / 60}"
															pattern="#.##" />分鐘免費	</br>
													</c:if> <c:if
														test='${not empty projectInfoRateTstar.voiceOnNetFreeMonthly && projectInfoRateTstar.voiceOnNetFreeMonthly !=0}'>
														<!--每月${projectInfoRateTstar.voiceOnNetFreeMonthly / 60}分鐘免費 -->
								每月<fmt:formatNumber
															value="${projectInfoRateTstar.voiceOnNetFreeMonthly / 60}"
															pattern="#.##" />分鐘免費
								</br>
													</c:if> <c:if test='${not empty projectInfoRateTstar.hotline}'>
							熱線${projectInfoRateTstar.hotline }門</br>
													</c:if> <c:if
														test='${not empty projectInfoRateTstar.voiceOnNetFreeDollar}'>
							贈送${projectInfoRateTstar.voiceOnNetFreeDollar }元通信費</br>
													</c:if> <c:if
														test='${not empty projectInfoRateTstar.voiceOnNetCost}'>
							每秒${projectInfoRateTstar.voiceOnNetCost }元</br>
													</c:if></td>
											</c:otherwise>
										</c:choose>
									</c:if>
									<c:if
										test='${not empty projectInfoRateChosen.voiceOnNetFreeMonthly}'>
										<c:choose>
											<c:when test="${projectInfoRateChosen.voiceOnNetFreeMonthly == 'NA'}">
												<td>網內語音免費</td>
											</c:when>
											<c:otherwise>
												<td>
													<c:if test='${not empty projectInfoRateChosen.voiceOnNetFreeEachTime && projectInfoRateChosen.voiceOnNetFreeEachTime !=0}'>
														<!-- 每通前${projectInfoRateTstar.voiceOnNetFreeEachTime / 60}分鐘免費 -->
														每通前<fmt:formatNumber value="${projectInfoRateTstar.voiceOnNetFreeEachTime / 60}" pattern="#.##" />分鐘免費</br>
													</c:if>
													<c:if test='${not empty projectInfoRateChosen.voiceOnNetFreeMonthly && projectInfoRateChosen.voiceOnNetFreeMonthly !=0}'>
														<!-- 每月${projectInfoRateChosen.voiceOnNetFreeMonthly / 60}分鐘免費 -->
														每月<fmt:formatNumber value="${projectInfoRateChosen.voiceOnNetFreeMonthly / 60}" pattern="#.##" />分鐘免費</br>
													</c:if>
													<c:if test='${not empty projectInfoRateChosen.hotline}'>
														熱線${projectInfoRateChosen.hotline }門</br>
													</c:if>
													<c:if test='${not empty projectInfoRateChosen.voiceOnNetFreeDollar}'>
														贈送${projectInfoRateChosen.voiceOnNetFreeDollar }元通信費</br>
													</c:if>
													<c:if test='${not empty projectInfoRateChosen.voiceOnNetCost}'>
														每秒${projectInfoRateChosen.voiceOnNetCost }元v</br>
													</c:if>
												</td>
											</c:otherwise>
										</c:choose>
									</c:if>
								</tr>
								<tr>
									<th>網外語音</th>
									<c:if
										test='${not empty projectInfoRateTstar.voiceOffNetFreeMonthly}'>
										<c:choose>
											<c:when
												test="${projectInfoRateTstar.voiceOffNetFreeMonthly == 'NA'}">
												<td>網外語音吃到飽</td>
											</c:when>
											<c:otherwise>
												<td><c:if
														test='${not empty projectInfoRateTstar.voiceOffNetFreeMonthly && projectInfoRateTstar.voiceOffNetFreeMonthly !=0.0}'>
														<!-- 每月${projectInfoRateTstar.voiceOffNetFreeMonthly /60 }分鐘免費 -->
							每月<fmt:formatNumber
															value="${projectInfoRateTstar.voiceOffNetFreeMonthly /60 }"
															pattern="#.##" />分鐘免費</br>
													</c:if> <c:if
														test='${not empty projectInfoRateTstar.voiceOffNetFreeDollar && projectInfoRateTstar.voiceOffNetFreeDollar !=0}'>
							贈送${projectInfoRateTstar.voiceOffNetFreeDollar}元通信費<br>
													</c:if> <c:if
														test='${not empty projectInfoRateTstar.voiceOffNetCost}'>
							每秒${projectInfoRateTstar.voiceOffNetCost}元</br>
													</c:if></td>
											</c:otherwise>
										</c:choose>
									</c:if>

									<c:if
										test='${not empty projectInfoRateChosen.voiceOffNetFreeMonthly}'>
										<c:choose>
											<c:when
												test="${projectInfoRateChosen.voiceOffNetFreeMonthly == 'NA'}">
												<td>網外語音吃到飽</td>
											</c:when>
											<c:otherwise>
												<td><c:if
														test='${not empty projectInfoRateChosen.voiceOffNetFreeMonthly && projectInfoRateChosen.voiceOffNetFreeMonthly !=0.0}'>
														<!-- 每月${projectInfoRateChosen.voiceOffNetFreeMonthly /60 }分鐘免費 -->
							每月<fmt:formatNumber
															value="${projectInfoRateChosen.voiceOffNetFreeMonthly /60 }"
															pattern="#.##" />分鐘免費</br>
													</c:if> <c:if
														test='${not empty projectInfoRateChosen.voiceOffNetFreeDollar && projectInfoRateChosen.voiceOffNetFreeDollar !=0}'>
							贈送${projectInfoRateChosen.voiceOffNetFreeDollar}元通信費<br>
													</c:if> <c:if
														test='${not empty projectInfoRateChosen.voiceOffNetCost}'>
							每秒${projectInfoRateChosen.voiceOffNetCost}元</br>
													</c:if></td>
											</c:otherwise>
										</c:choose>
									</c:if>
								</tr>
								<tr>
									<th>市話</th>
									<c:if
										test='${not empty projectInfoRateTstar.voiceLandlineFreeMonthly}'>
										<c:choose>
											<c:when
												test="${projectInfoRateTstar.voiceLandlineFreeMonthly == 'NA'}">
												<td>市話語音吃到飽</td>
											</c:when>
											<c:otherwise>
												<td><c:if
														test='${not empty projectInfoRateTstar.voiceLandlineFreeMonthly && projectInfoRateTstar.voiceLandlineFreeMonthly !=0.0}'>
														<!-- 每月${projectInfoRateTstar.voiceLandlineFreeMonthly /60}分鐘免費 -->
							每月<fmt:formatNumber
															value="${projectInfoRateTstar.voiceLandlineFreeMonthly /60 }"
															pattern="#.##" />分鐘免費</br>
													</c:if> <c:if
														test='${not empty projectInfoRateTstar.voiceLandlineFreeDollar && projectInfoRateTstar.voiceLandlineFreeDollar !=0}'>
							贈送${projectInfoRateTstar.voiceLandlineFreeDollar}元通信費</br>
													</c:if> <c:if
														test='${not empty projectInfoRateTstar.voiceLandlineCost}'>
							每秒${projectInfoRateTstar.voiceLandlineCost}元</br>
													</c:if></td>
											</c:otherwise>
										</c:choose>
									</c:if>

									<c:if
										test='${not empty projectInfoRateChosen.voiceLandlineFreeMonthly}'>
										<c:choose>
											<c:when
												test="${projectInfoRateChosen.voiceLandlineFreeMonthly == 'NA'}">
												<td>市話語音吃到飽</td>
											</c:when>
											<c:otherwise>
												<td><c:if
														test='${not empty projectInfoRateChosen.voiceLandlineFreeMonthly && projectInfoRateChosen.voiceLandlineFreeMonthly !=0.0}'>
														<!-- 每月${projectInfoRateChosen.voiceLandlineFreeMonthly /60}分鐘免費 -->
							每月<fmt:formatNumber
															value="${projectInfoRateChosen.voiceLandlineFreeMonthly /60}"
															pattern="#.##" />分鐘免費</br>
													</c:if> <c:if
														test='${not empty projectInfoRateChosen.voiceLandlineFreeDollar && projectInfoRateChosen.voiceLandlineFreeDollar !=0}'>
							贈送${projectInfoRateChosen.voiceLandlineFreeDollar}元通信費</br>
													</c:if> <c:if
														test='${not empty projectInfoRateChosen.voiceLandlineCost}'>
							每秒${projectInfoRateChosen.voiceLandlineCost}元</br>
													</c:if></td>
											</c:otherwise>
										</c:choose>
									</c:if>
								</tr>
								<tr>
									<th>簡訊</th>
									<td><c:if
											test='${not empty projectInfoRateTstar.smsOnNetFree || not empty projectInfoRateTstar.smsOnNetCost }'>
											<c:if
												test='${projectInfoRateTstar.smsOnNetFree !=0 || projectInfoRateTstar.smsOnNetCost !=0.0 }'>	
							網內簡訊:</br>
											</c:if>
										</c:if> <c:if
											test='${not empty projectInfoRateTstar.smsOnNetFree && projectInfoRateTstar.smsOnNetFree !=0}'>
						免費${projectInfoRateTstar.smsOnNetFree}則</br>
										</c:if> <c:if
											test='${not empty projectInfoRateTstar.smsOnNetCost && projectInfoRateTstar.smsOnNetCost !=0.0}'>
						每則${projectInfoRateTstar.smsOnNetCost}元</br>
										</c:if> <c:if
											test='${not empty projectInfoRateTstar.smsOffNetFree || not empty projectInfoRateTstar.smsOffNetCost }'>
											<c:if
												test='${projectInfoRateTstar.smsOffNetFree !=0 || projectInfoRateTstar.smsOffNetCost !=0.0 }'>	
							網外簡訊:</br>
											</c:if>
										</c:if> <c:if
											test='${not empty projectInfoRateTstar.smsOffNetFree && projectInfoRateTstar.smsOffNetFree !=0}'>
						免費${projectInfoRateTstar.smsOffNetFree}則</br>
										</c:if> <c:if
											test='${not empty projectInfoRateTstar.smsOffNetCost && projectInfoRateTstar.smsOffNetCost !=0.0}'>
						每則${projectInfoRateTstar.smsOffNetCost}元</br>
										</c:if></td>
									<c:if test='${not empty projectInfoRateChosen.projectName}'>
										<td><c:if
												test='${not empty projectInfoRateChosen.smsOnNetFree || not empty projectInfoRateChosen.smsOnNetCost }'>
												<c:if
													test='${projectInfoRateChosen.smsOnNetFree !=0 || projectInfoRateChosen.smsOnNetCost !=0.0 }'>	
							網內簡訊:</br>
												</c:if>
											</c:if> <c:if
												test='${not empty projectInfoRateChosen.smsOnNetFree && projectInfoRateChosen.smsOnNetFree !=0}'>
						免費${projectInfoRateChosen.smsOnNetFree}則</br>
											</c:if> <c:if
												test='${not empty projectInfoRateChosen.smsOnNetCost && projectInfoRateChosen.smsOnNetCost !=0.0}'>
						每則${projectInfoRateChosen.smsOnNetCost}元</br>
											</c:if> <c:if
												test='${not empty projectInfoRateChosen.smsOffNetFree || not empty projectInfoRateChosen.smsOffNetCost }'>
												<c:if
													test='${projectInfoRateChosen.smsOffNetFree !=0 || projectInfoRateChosen.smsOffNetCost !=0.0 }'>	
							網外簡訊:</br>
												</c:if>
											</c:if> <c:if
												test='${not empty projectInfoRateChosen.smsOffNetFree && projectInfoRateChosen.smsOffNetFree !=0}'>
						免費${projectInfoRateChosen.smsOffNetFree}則</br>
											</c:if> <c:if
												test='${not empty projectInfoRateChosen.smsOffNetCost && projectInfoRateChosen.smsOffNetCost !=0.0}'>
						每則${projectInfoRateChosen.smsOffNetCost}元</br>
											</c:if></td>
									</c:if>
								</tr>
								<tr>
									<th>額外贈送</th>
									<c:if test='${not empty projectInfoRateTstar.projectExtraInfo}'>
										<td>${projectInfoRateTstar.projectExtraInfo}</td>
									</c:if>
									<c:if test='${not empty projectInfoRateChosen.projectName}'>
										<td>${projectInfoRateChosen.projectExtraInfo}</td>
									</c:if>
								</tr>
								<tr
									style="border-bottom-width: 2px; border-bottom-style: solid; border-bottom-color: rgb(48, 48, 48);">
									<th>合約期限(月)</th>
									<c:if test='${not empty projectInfoRateTstar.contractMonths}'>
										<td>${projectInfoRateTstar.contractMonths}</td>
									</c:if>
									<c:if test='${not empty projectInfoRateChosen.contractMonths}'>
										<td>${projectInfoRateChosen.contractMonths}</td>
									</c:if>
								</tr>
								<c:forEach items="${ProjectDeviceDtoOrder}" var="project">
									<tr>
										<th>${project.projectName}</th>
										<c:if
											test='${not empty project.priceTstar && project.priceTstar !=0}'>
											<td>$<fmt:formatNumber type="currency"
													currencySymbol="$" pattern="#,##0;"
													value="${project.priceTstar}" /></td>
										</c:if>
										<c:if test='${empty project.priceTstar}'>
											<td></td>
										</c:if>
										<c:if
											test='${not empty project.priceChosen && project.priceChosen !=0}'>
											<td>$<fmt:formatNumber type="currency"
													currencySymbol="$" pattern="#,##0;"
													value="${project.priceChosen}" /></td>
										</c:if>
										<c:if test='${empty project.priceChosen}'>
											<td></td>
										</c:if>

									</tr>
									<tr class='t_height'
										style="border-bottom-width: 2px; border-bottom-style: solid; border-bottom-color: rgb(48, 48, 48);">
										<th>攜碼價格</th>
										<c:if
											test='${not empty project.prepaymentAmountTstar && project.prepaymentAmountTstar !=0}'>
											<td>$<fmt:formatNumber type="currency"
													currencySymbol="$" pattern="#,##0;"
													value="${project.prepaymentAmountTstar}" /></td>
										</c:if>
										<c:if test='${empty project.prepaymentAmountTstar}'>
											<td></td>
										</c:if>
										<c:if
											test='${not empty project.prepaymentAmountChosen && project.prepaymentAmountChosen !=0}'>
											<td>$<fmt:formatNumber type="currency"
													currencySymbol="$" pattern="#,##0;"
													value="${project.prepaymentAmountChosen}" /></td>
										</c:if>
										<c:if test='${empty project.prepaymentAmountChosen }'>
											<td></td>
										</c:if>
									</tr>
								</c:forEach>
							</table>
							<div>
								<font style='color: red; font-size: 10px'>${psString}</font>
							</div>
							<div class="apply_plan">
								<a class="submit" href="reservation.action"
									onclick="ga('send', 'event', '專案比一比', '我要預約');false">我有興趣</a>
							</div>

						</c:if>
					</div>
				</div>
			</div>


			<form class="cf_form" id='"singlePhone_form"' method='post' action='comparebybsc.action'>
			<input type="hidden" name="tab" value="tab2" />
			<div class="n_sec_content">
				<div class="n_row">
					<label style="width: 85px; padding: 0;">試算規則 :</label>
					<label class="n_label">
						<input type="radio" id="w_p" name="calRule" value='w_p'>手機專案價
					</label>
					<label class="n_label">
						<input type="radio" id="w_o_p" name="calRule" value='w_o_p'>單門號
					</label>
				</div>
				
				<div class="with_phone">
					<div class="n_row">
						<label style="display: block; padding: 0 0 5px 0;">您目前使用的電信業者:</label>
						<span class="custom_select">
							<select id="company_sel1" name='company_sel1' style="width: 290px; box-sizing: border-box;">
								<option value="">選擇其他電信業者</option>
							</select>
						</span>
					</div>
					<div class="n_row">
						<label style="width: 85px; padding: 0;">申裝類別 :</label>
						<label class="n_label">
							<input type="radio" name="bb" checked="checked">新用戶
						</label>
						<label class="n_label">
							<input type="radio" name="bb">攜碼
						</label>
					</div>
					<div class="n_row">
						<label style="width: 85px; padding: 0;">資費類型 :</label>
						<span class="custom_select">
							<select id="fee_type1" name="fee_type1">
								<option value="">請選取資費類型</option>
							</select>
						</span>
					</div>
					<div class="n_row">
						<label style="width: 85px; padding: 0;">資費範圍 :</label>
						<span class="custom_select">
							<select id="fee_range1" name="fee_range1">
								<option value="">資費範圍</option>
							</select>
						</span>
						<div style="height: 6px;"></div>
						<label style="width: 85px; padding: 0;"></label>
						<span class="custom_select">
							<select id="fee_sel1" name='fee_sel1'>
								<option value="">選擇資費</option>
							</select>
						</span>
					</div>
					<div class="n_row">
						<label style="width: 85px; padding: 0;">網內 :</label> <input
							type="text" style="width: 201px; box-sizing: border-box;" />
					</div>
					<div class="n_row">
						<label style="width: 85px; padding: 0;">網外 :</label> <input
							type="text" style="width: 201px; box-sizing: border-box;" />
					</div>
					<div class="n_row">
						<label style="width: 85px; padding: 0;">市話 :</label> <input
							type="text" style="width: 201px; box-sizing: border-box;" />
					</div>
					<div class="n_row">
						<label style="width: 85px; padding: 0;">上網傳輸量 :</label> <input
							type="text" style="width: 201px; box-sizing: border-box;" />
					</div>
					<div class="n_row">
						<label style="width: 85px; padding: 0;">網內簡訊 :</label> <input
							type="text" style="width: 201px; box-sizing: border-box;" />
					</div>
					<div class="n_row">
						<label style="width: 85px; padding: 0;">網外簡訊 :</label> <input
							type="text" style="width: 201px; box-sizing: border-box;" />
					</div>
					<div class="n_row">
						<label style="width: 85px; padding: 0;">手機 :</label> <span
							class="custom_select"> <select
							style="width: 201px; box-sizing: border-box;">
								<option>請選擇</option>
								<option>iPhone6</option>
						</select>
						</span>
					</div>
					<div class="n_row">
						<label style="width: 85px; padding: 0;">約期 :</label> <span
							class="custom_select"> <select
							style="width: 201px; box-sizing: border-box;">
								<option>請選擇</option>
								<option value='12'>12</option>
								<option value='24'>24</option>
								<option value='30'>30</option>
						</select>
						</span>
					</div>
					<div class="submit_po">
						<input class="submit" value="確認送出" onclick='submitForm()'>
					</div>
				</div>
				
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
							<select id="fee_range2" name="fee_range2" style="width: 201px; box-sizing: border-box;">
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
					<div class="n_row">
						<label style="width: 85px; padding: 0;">網內 :</label>
						<input type="text" style="width: 201px; box-sizing: border-box;" name='queryCompareProject2Dto.voice_on_net' />
					</div>
					<div class="n_row">
						<label style="width: 85px; padding: 0;">網外 :</label>
						<input type="text" style="width: 201px; box-sizing: border-box;" name='queryCompareProject2Dto.voice_off_net' />
					</div>
					<div class="n_row">
						<label style="width: 85px; padding: 0;">市話 :</label>
						<input type="text" style="width: 201px; box-sizing: border-box;" name='queryCompareProject2Dto.pstn' />
					</div>
					<div class="n_row">
						<label style="width: 85px; padding: 0;">上網傳輸量 :</label>
						<input type="text" style="width: 201px; box-sizing: border-box;" name='queryCompareProject2Dto.data_usage' />
					</div>
					<div class="n_row">
						<label style="width: 85px; padding: 0;">網內簡訊 :</label>
						<input type="text" style="width: 201px; box-sizing: border-box;" name='queryCompareProject2Dto.sms_on_net' />
					</div>
					<div class="n_row">
						<label style="width: 85px; padding: 0;">網外簡訊 :</label>
						<input type="text" style="width: 201px; box-sizing: border-box;" name='queryCompareProject2Dto.sms_off_net' />
					</div>
					<div class="n_row">
						<label style="width: 85px; padding: 0;">手機 :</label> <span
							class="custom_select"> <select
							style="width: 201px; box-sizing: border-box;">
								<option>請選擇</option>
								<option>iPhone6</option>
						</select>
						</span>
					</div>
					<div class="n_row">
						<label style="width: 85px; padding: 0;">約期 :</label>
						<span class="custom_select">
							<select style="width: 201px; box-sizing: border-box;" name='queryCompareProject2Dto.period'>
								<option>請選擇</option>
								<option value='12'>12</option>
								<option value='24'>24</option>
								<option value='30'>30</option>
						</select>
						</span>
					</div>
					<div class="submit_po">
						<input class="submit" type="submit" value="確認送出" onclick='submitSinglePhoneForm()'>
					</div>
				</div>
			</div>
			</form>
		</div>
	</section>
</div>	
</body>
</html>
