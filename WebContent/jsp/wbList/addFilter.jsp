<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
<script src="${pageContext.request.contextPath}/js/jquery-ui-timepicker-addon.js"></script> <!-- 將 JQuery UI 的 date picker 加上時間功能，請參考 http://trentrichardson.com/examples/timepicker/ -->
<script src="${pageContext.request.contextPath}/js/jquery.tablesorter.min.js"></script> <!-- 以 table column 排序用，請參考 http://tablesorter.com/docs/ -->
<script>
	$(function() {
		$(".btn").addClass("button ui-button ui-widget ui-state-default ui-corner-all ui-state-hover");
		getLoginId('黑白名單新增');	//取得目前登入使用者的ID
		<c:if test='${not empty projectsList}'>
			<c:forEach items="${projectsList}" var="projects">
				addRow('${projects.id}', '${projects.name}', '${projects.status}');
			</c:forEach>
		</c:if>
		<c:if test='${empty projectsList}'>
			addRow('', '', '');
		</c:if>
		$("#company").val('${telecomRate.telecomId}');
	});
	function submitForm(){
		var null_chk = /^\s*$/;//驗證空值
		if(null_chk.test($("#insertKey").val())){
			alert("key不能為空");
		}else if(null_chk.test($("#insertName").val())){
			alert("name不能為空");
		}else if(null_chk.test($("#insertValue").val())){
			alert("value不能為空");
		}else{
			$('#createuser').val($('#LoginId').text());
			$("#cf_form").attr('action', 'bwListinsert.action'); 
			$("#cf_form").submit();	
		}		
	};
	function cleanForm(){
		$('#filterKey').val('');
		$('#name').val('');
		$('#filterValue').val('');
		$("#filterType")[0].selectedIndex = 0;
		$("#status")[0].selectedIndex = 0;	
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
</script>
</head>
<body>
<div id="header-wrapper">
	<div id="header" class="container">
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
		<table class="filtered_table" cellspacing="10">
			<tr>
				<td>key:</td>
				<td>
					<input type='hidden' name='createuser' id='createuser' size="30"/> 
					<input type='text' name='insertKey' id='insertKey' size="30" /> 	
				</td>
			</tr>
			<tr>			
				<td>name:</td>
				<td>
					 <input type='text' name='insertName' id='insertName' size="30" />	
				</td>
			</tr>
			<tr>
				<td>value:</td>
				<td>
					<input type='text' name='insertValue' id='insertValue' size="30" /> 	
				</td>
			</tr>
			<tr>
			<tr>
				<td>名單型態:</td>
				<td>
					<select id="insertType" name="insertType">			
						<option value="W" >白名單</option>
						<option value="B" >黑名單</option>		
					</select>	
				</td>
			</tr>
			<tr>
				<td>狀態:</td>
				<td>
					<select id="insertStatus" name="insertStatus">					
						<option value="1" >啟用</option>
						<option value="0" >停用</option>		
					</select>	
				</td>
			</tr>

		<tr>
			<td colspan="4" align="center"><input class="submit btn" type="button" onclick='submitForm()' value="確認送出" />
			&nbsp;<input class="submit btn" type="button" onclick='cleanForm()' value="清除" />
			&nbsp;<input class="submit btn" type="button" onclick="location.href='bwListCondition.action'" value="返回" /></td>
		</tr>			
		</table>	
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