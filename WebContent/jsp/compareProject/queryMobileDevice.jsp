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
		getLoginId('手機資料管理');	//取得目前登入使用者的ID
		<c:if test='${not empty mobileList}'>
			<c:forEach items="${mobileList}" var="mobileList">
				addRow('${mobileList.id}', '${mobileList.mobileName}', '${mobileList.status}');
			</c:forEach>
		</c:if>
		<c:if test='${empty mobileList}'>
			addRow('', '', '');
		</c:if>
		$("#company").val('${telecomRate.telecomId}');
	});
	function submitForm(){
		$("#cf_form").attr('action', 'queryMobileDevice.action'); 
		$("#cf_form").submit();
	};
	function saveForm(){
		$("#ed_form").attr('action', 'saveMobileDevice.action'); 
		$("#ed_form").submit();
	};
	var rowCount = 0;
	function addRow(id, name, status) {
		$('#projectsList tbody').append(
				"<tr><td><input type='hidden' name='mobileList[" + rowCount + "].id' value='" + id + "' />" +
				"<input type='text' name='mobileList[" + rowCount + "].mobileName' value='" + name + "' /></td>" +
				"<td><select id='projectsList" + rowCount + "' name='mobileList[" + rowCount + "].status'>" +
				"<option value='1'>啟用</option><option value='0'>停用</option></select></td></tr>");
		$("#projectsList" + rowCount).val(status);
		rowCount++;
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
	<form id='cf_form' method='post'>
		<table class="filtered_table">
			<tr>
				<th>關鍵字</th>
				<td>
					<input type='text' name='queryStr' value='${queryStr}'/>
				</td>
				<td>
					<select name='queryStatus'>
						<option value='' ${queryStatus == '' ? 'selected="selected"' : ''}>全部</option>
						<option value='1' ${queryStatus == '1' ? 'selected="selected"' : ''}>啟用</option>
						<option value='0'${queryStatus == '0' ? 'selected="selected"' : ''}>停用</option></select>
				</td>
				<td>
					<input class="submit btn" type="button" onclick='submitForm()' value="查詢" />
				</td>
			</tr>
		</table>
	</form>
	<br /><br />
	<div>
	<form id='ed_form' method='post'>
		<input class='btn' type='button' value='新增一行' onclick="addRow('', '', '')" />
		<br /><br />
		<input type='hidden' name='queryStr' value='${queryStr}'/>
		<input type='hidden' name='queryStatus' value='${queryStatus}'/>
		<table id='projectsList' class="filtered_table hasBorder tablesorter">
			<tr>
				<th>手機名稱</th>
				<th>狀態</th>
			</tr>
		</table><br />
		<input class="submit btn" type="button" onclick='saveForm()' value="異動資料" />
	</form>
	<c:if test="${not empty message}"> 
	    <p style="color:green">${message}</p>
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