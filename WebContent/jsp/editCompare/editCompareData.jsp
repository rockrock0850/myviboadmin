<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<title></title>
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/default.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui-1.10.3.custom.min.css" />
<script src="${pageContext.request.contextPath}/js/ga.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-1.9.1.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-ui-1.10.3.custom.min.js"></script>
<script src="${pageContext.request.contextPath}/js/util.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery.blockUI.js"></script>
<script>
	$(function() {
		btnClass();
		getLoginId('比一	比資料管理');	//取得目前登入使用者的ID
		<c:if test='${not empty rateProjectsList}'>
			<c:forEach items="${rateProjectsList}" var="rateProjects">
				addRow('${rateProjects.projectId}', '${rateProjects.price}', '${rateProjects.prepaymentAmount}', '${rateProjects.status}', '${rateProjects.id}', 'false');
			</c:forEach>
		</c:if>
		<c:if test='${empty rateProjectsList}'>
			addRow('', '', '', '', '', '');
		</c:if>
		$("#company").val('${telecomRate.telecomId}');
		
		//如果有值，就帶出來
		$("#rateType").val('${telecomRate.rateType}');
	});
	function btnClass(){
		$(".btn").addClass("button ui-button ui-widget ui-state-default ui-corner-all ui-state-hover");
	};
	
	var rowCount = 0;
	//動態增加欄位
	function addRow(projectId, price, prepaymentAmount, status, id, showRemove) {
		//判斷是否需要移除按鈕
		var appendStr = '';
		if('false' == showRemove){
			appendStr = "<td><input type='hidden' name='rateProjectsList[" + rowCount + "].id' value='" + id + "' /></td></tr>";
		}else{
			appendStr = "<td><input class='btn' type='button' value='移除' onclick='removeRow(this)'></td></tr>";
		}
		
		$('#projectsList tbody').append(
			"<tr><td><select id='rateProjectsList" + rowCount + "' name='rateProjectsList[" + rowCount + "].projectId'>" +
			<c:forEach items="${projectsList}" var="project">
				"<option value='${project.id}'>${project.name}</option>" +
			</c:forEach>
			"</select></td>" +
			"<td><input type='text' maxlength='5' name='rateProjectsList[" + rowCount + "].price' value='" + price + "' /></td>" +
			"<td><input type='text' maxlength='5' name='rateProjectsList[" + rowCount + "].prepaymentAmount' value='" + prepaymentAmount + "' /></td>" +
			"<td><select id='projectsListStatus" + rowCount + "' name='rateProjectsList[" + rowCount + "].status'>" +
			"<option value='1'>啟用</option><option value='0'>停用</option></select></td>"  + appendStr
		);		
		$("#rateProjectsList" + rowCount).val(projectId);
		$("#projectsListStatus" + rowCount).val(status);
		btnClass();
		rowCount++;
	};
	function removeRow(dom) {
		var par = $(dom).parent().parent(); //tr
		if ($("#projectsList tr").length <= 2) {
			alert('至少要有一個專案');
		} else {
			par.remove();
			calTotalAmt();
		}
	};
	function submitForm(){
		$("#cf_form").submit();
	};
</script> 
</head>
<body>
<div id="header-wrapper">
	<div id="header" class="container" style="z-index: 9999">
		<div id="logo">
			<table><tr><td><h1><a href="${pageContext.request.contextPath}/index.jsp">台灣之星APP後台管理系統</a></h1></td><td class="headeruserid"><span id="FunctionName"></span><span>-</span></td><td class="headeruserid"><span id="LoginId"></span></td></tr></table>
		</div>
		<div id="mainmenu" style="position:absolute;z-index: 9999">
			<ul id="mainmenuitem" ></ul>
		</div>
	</div>
</div>
<div id="wrapper">
	<div id="page" class="container">
	<form id='cf_form' method='post' action='saveCompareData.action'>
	<input type="hidden" name='telecomRate.id' value="${telecomRate.id}" />
	<table class="filtered_table1">
		<tr>
			<th>電信業者</th>
			<td>
				<select id="company" name='telecomRate.telecomId'>
					<option value="1">台灣之星</option>
					<option value="3">遠傳電信</option>
					<option value="2">中華電信</option>
					<option value="4">台灣大哥大</option>
					<option value="5">亞太電信</option>
				</select>
			</td>
		</tr>
		<tr>
			<th>專案名稱</th>
			<td><input type='text' name='telecomRate.name' value='${telecomRate.name}' /></td>
		</tr>
		<tr>
			<th>資費類型</th>
			<td>
				<select id="rateType" name="telecomRate.rateType">
					<option value="3G">3G</option>
					<option value="4G">4G</option>
				</select>
			</td>
		</tr>
		<tr>
			<th>月付金額</th>
			<td>
				<input type='text' name='telecomRate.chargesMonth' value='${telecomRate.chargesMonth}'/>
			</td>
		</tr>
		<tr>
			<th>上網傳輸量</th>
			<td><input type='text' name='telecomRate.netVolDesc' value='${telecomRate.netVolDesc}' /></td>
		</tr>
		<tr>
			<th>免費 Wi-Fi</th>
			<td><input type='text' name='telecomRate.freeWifiDesc' value='${telecomRate.freeWifiDesc}' /></td>
		</tr>
		<tr>
			<th>網內語音</th>
			<td><input type='text' name='telecomRate.voiceOnNetSec' value='${telecomRate.voiceOnNetSec}' /></td>
		</tr>
		<tr>
			<th>網外語音</th>
			<td><input type='text' name='telecomRate.voiceOffNetSec' value='${telecomRate.voiceOffNetSec}' /></td>
		</tr>
		<tr>
			<th>市話</th>
			<td><input type='text' name='telecomRate.pstn' value='${telecomRate.pstn}' /></td>
		</tr>
		<tr>
			<th>簡訊</th>
			<td><input type='text' name='telecomRate.mms' value='${telecomRate.mms}' /></td>
		</tr>
		<tr>
			<th>額外贈送</th>
			<td>
				<textarea rows="5" cols="50" name='telecomRate.freeVoiceDesc' >${telecomRate.freeVoiceDesc}</textarea>
			</td>
		</tr>
		<tr>
			<th>合約期限</th>
			<td><input type='text' name='telecomRate.contractMonths' maxlength="2" value='${telecomRate.contractMonths}' /></td>
		</tr>
<!-- 		<tr> -->
<!-- 			<th>是否啟用</th> -->
<!-- 			<td> -->
<!-- 				<select name='status' id='status'> -->
<!-- 					<option value="1">啟用</option> -->
<!-- 					<option value="0">停用</option> -->
<!-- 				</select> -->
<!-- 			</td> -->
<!-- 		</tr> -->
	</table>
	<table id='projectsList' class='hasBorder tablesorter'>
	    <tr>
			<th>機型</th>
			<th>專案價</th>
			<th>攜碼價格</th>
			<th>狀態</th>
			<th><input class='btn' type='button' value='新增一行' onclick="addRow('', '', '', '', '', '');" /></th>
		</tr>
	</table><br />
		<input class="submit btn" type="button" onclick='submitForm()' value="異動資料" />
		<form action="qryCompareData.action">
		    <input class="submit btn" type="button" onclick='window.location.href="qryCompareData.action"' value="返回" />
		</form>
	</form>
	</div>
</div>
<div id="footer" class="container">
	<div id="copyright" class="container">
		<p>台灣之星電信版權所有 Copyright© 2014 Taiwan Star Telecom Co., Ltd. All Rights Reserved.&nbsp;&nbsp;&nbsp;&nbsp;(最佳解析度1280X800)</p>
	</div>
</div>
</body>
</html>