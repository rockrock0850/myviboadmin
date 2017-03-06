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
<script src="${pageContext.request.contextPath}/js/jquery.blockUI.js"></script>
<script src="${pageContext.request.contextPath}/js/util.js"></script>
<script>
	$(function() {
		$(".btn").addClass("button ui-button ui-widget ui-state-default ui-corner-all ui-state-hover");
		getLoginId('比一	比資料管理');	//取得目前登入使用者的ID
		if('' != '${showMsg}'){
			alert('${showMsg}');
		}
	});
	function submitForm(str){
		$("#actionMethod").val(str);
		$("#cf_form").attr('action', 'qryCompareData.action'); 
		$("#cf_form").submit();
	};
	function newData(){
		$("#cf_form").attr('action', 'editCompareData.action'); 
		$("#cf_form").submit();
	};
	function editForm(str){
		$("#telecomRateId").val(str); 
		$("#ed_form").submit();
	};
</script> 
</head>
<body>
<form method='post' id='ed_form' action='editCompareData.action'>
	<input type="hidden" id='telecomRateId' name='telecomRateId' />
</form>
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
	<form id='cf_form' method='post'>
		<table class="filtered_table">
			<tr><td colspan="2" align="center"><h2>說明文字異動</h2></td></tr>
			<tr>
				<th>說明文字</th>
				<td>
					<input type='text' name='psString' value='${psString}' style='width:100%' />
				</td>
			</tr>
			<tr>
				<td colspan='2'>
					<input class="submit btn" type="button" onclick='submitForm("editPs")' value="修改" />
					<br /><br />
				</td>
			</tr>
			<tr><td colspan="2" align="center"><h2>比一比資料管理</h2></td></tr>
			<tr>
				<th>電信業者</th>
				<td>
					<select id="company" name='qryTelecomId'>
						<option value="1">台灣之星</option>
						<option value="3">遠傳電信</option>
						<option value="2">中華電信</option>
						<option value="4">台灣大哥大</option>
						<option value="5">亞太電信</option>
					</select>
				</td>
			</tr>
			<tr>
				<th>專案金額</th>
				<td><input type='text' name='queryStart' />~<input type='text' name='queryEnd' /></td>
			</tr>
		</table>
		<br />
		<input type="hidden" id='actionMethod' name='actionMethod'/>
		<input class="submit btn" type="button" onclick='newData()' value="新增資料" />
		<input class="submit btn" type="button" onclick='submitForm("query")' value="查詢" />
	</form>
	<br /><br />
	<div>
		<c:if test='${not empty telecomRateList}'>
		<table class="filtered_table hasBorder tablesorter">
			<tr>
				<th>電信業者</th>
				<th>專案名稱</th>
				<th>月付金額</th>
				<th>上網傳輸量</th>
<!-- 				<th>免費 Wi-Fi</th> -->
				<th>合約期限(月)</th>
				<th>資費類型</th>
				<th>動作</th>
			</tr>
			<c:forEach items="${telecomRateList}" var="telecomRate">
			<tr>
				<td>${qryTelecomName}</td>
				<td>${telecomRate.name}</td>
				<td>${telecomRate.chargesMonth}</td>
				<td>${telecomRate.netVolDesc}</td>
<%-- 				<td>${telecomRate.freeWifiDesc}</td> --%>
				<td>${telecomRate.contractMonths}</td>
				<td>${telecomRate.rateType}</td>
				<td><input class="submit btn" type="button" onclick='editForm("${telecomRate.id}")' value="修改" /></td>
			</tr>
			</c:forEach>
		</table>
		</c:if>
	</div>
	</div>
</div>
<div id="footer" class="container">
	<div id="copyright" class="container">
		<p>台灣之星電信版權所有 Copyright© 2014 Taiwan Star Telecom Co., Ltd. All Rights Reserved.&nbsp;&nbsp;&nbsp;&nbsp;(最佳解析度1280X800)</p>
	</div>
</div>
</body>
</html>