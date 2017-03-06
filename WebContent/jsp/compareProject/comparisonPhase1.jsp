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
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/c_defaultP1.css?3" />
<script src="${pageContext.request.contextPath}/js/jquery-1.9.1.js"></script>
<script src="${pageContext.request.contextPath}/js/c_defaultP1.js"></script>
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
	});
    //組成資費類型
	$(typeSelJson).each(function() {
		$("#fee_type").append("<option value='"+this.value+"'>"+this.text+"</option>");
	});
    
	$("#fee_type").change(function() {
		buildFeeRange();
		checkIsTypeSelect();
	});
	
    //設定預設值
	if('' != preTypeSel){
		$("#fee_type").val(preTypeSel).change();
		$("#fee_range").val(prefeeRange).change();
		$("#fee_sel").val(prefeeSel);
		$("#company_sel").val(preCompanySel);
	}
	
	checkIsTypeSelect();
	
	//若我方無此方案，css的格式會跑版，需修正
	<c:if test='${empty projectRateTstar.rateName}'>
		$("#resultTable").find("tr:gt(1)").each(function(){
			$(this).find("td").css({"background":"white"});
		});
	</c:if>
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
};

function alertEmptyResult(){
	if('' != prefeeRange){
		alert('依您設定的條件目前無相關方案可進行比一比，請重新設定。');
	}	
};
//若兩方都無此方案，則alert'查無資料，請重新選取'
<c:if test='${empty projectRateTstar.telName and empty projectRateChosen.telName}'>
	alertEmptyResult();
</c:if>

</script>
</head>
<c:choose> 
	<c:when test='${not empty projectRateTstar.telName or not empty projectRateChosen.telName}'>
		<body>
	</c:when>
	<c:otherwise>
		<body style='background:#FFF;'>
	</c:otherwise>
</c:choose>

<div class="main_doc">
	<form class="cf_form" id='cf_form' method='post' action='compare.action'>
		<div class="row fee_range_row">
			<label for="fee_range">資費類型：</label>
			<span class="custom_select">
				<select id="fee_type" name="fee_type">
					<option value="">請選取資費類型</option>
					<!-- 由jquery組成下拉選單的內容 -->
				</select>
			</span>
		</div>
		<div class="row fee_range_row">
			<label for="fee_range">資費範圍：</label>
			<span class="custom_select">
				<select id="fee_range" name="fee_range">
					<option value="">資費範圍</option>
					<!-- 由jquery組成下拉選單的內容 -->
				</select>
			</span>
			<span class="custom_select">
				<select id="fee_sel" name='fee_sel'>
					<option value="" >選擇資費</option>
					<!-- 由jquery組成下拉選單的內容 -->
				</select>
			</span>
		</div>
		<div class="row company_sel_row">
			<label for="company_sel">電信業者：</label>
			<span class="custom_select">
				<select id="company_sel" name='company_sel'>
					<option value="" >選擇其他電信業者</option>
					<!-- 由jquery組成下拉選單的內容 -->
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
<!-- 			<tr> -->
<!-- 				<th>免費 Wi-Fi</th> -->
<%-- 				<c:if test='${not empty projectRateTstar.rateName}'> --%>
<%-- 					<td>${projectRateTstar.freeEifidesc}</td> --%>
<%-- 				</c:if> --%>
<%-- 				<c:if test='${not empty projectRateChosen.rateName}'> --%>
<%-- 					<td>${projectRateChosen.freeEifidesc}</td> --%>
<%-- 				</c:if> --%>
<!-- 			</tr> -->
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
<!-- 			<tr> -->
<!-- 				<th>預繳金額</th> -->
<%-- 				<td>${projectRateTstar.prepaymentAmount}</td> --%>
<%-- 				<td>${projectRateChosen.prepaymentAmount}</td> --%>
<!-- 			</tr> -->
<!-- 			Map版，無法排序 -->
<%-- 			<c:forEach items="${projectDevicemap}" var="project"> --%>
<!-- 			    <tr class='t_height' > -->
<%-- 					<th>${project.value.projectName}</th> --%>
<%-- 					<c:if test='${not empty projectRateTstar.rateName}'> --%>
<%-- 						<td>$<fmt:formatNumber type="currency" currencySymbol="$" pattern="#,##0;" value="${project.value.priceTstar}" /></td> --%>
<%-- 					</c:if> --%>
<%-- 					<c:if test='${not empty projectRateChosen.rateName}'> --%>
<%-- 						<td>$<fmt:formatNumber type="currency" currencySymbol="$" pattern="#,##0;" value="${project.value.priceChosen}" /></td> --%>
<%-- 					</c:if> --%>
<!-- 				</tr> -->
<!-- 				<tr class='t_height' style="border-bottom-width: 2px; border-bottom-style: solid; border-bottom-color: rgb(48, 48, 48);"> -->
<!-- 					<th>攜碼價格</th> -->
<%-- 					<c:if test='${not empty projectRateTstar.rateName}'> --%>
<%-- 						<td>$<fmt:formatNumber type="currency" currencySymbol="$" pattern="#,##0;" value="${project.value.prepaymentAmountTstar}" /></td> --%>
<%-- 					</c:if> --%>
<%-- 					<c:if test='${not empty projectRateChosen.rateName}'> --%>
<%-- 						<td>$<fmt:formatNumber type="currency" currencySymbol="$" pattern="#,##0;" value="${project.value.prepaymentAmountChosen}" /></td> --%>
<%-- 					</c:if> --%>
<!-- 				</tr> -->
<%-- 			</c:forEach> --%>
<!-- 			List版，可以排序 -->
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
</body>
</html>
