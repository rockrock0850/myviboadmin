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
		getLoginId('專案手機資料管理');	//取得目前登入使用者的ID
		if('' != '${showMsg}'){
			alert('${showMsg}');
		}
	});
	function submitForm(str){
		$("#actionMethod").val(str);
		$("#cf_form").attr('action', 'queryCompareDevice.action'); 
		$("#cf_form").submit();
	};
	function newData(){
		$("#ed_form").submit();
	};
	function editForm(str){
		$("#projectRateId").val(str); 
		$("#ed_form").submit();
	};
</script> 
</head>
<body>
<form method='post' id='ed_form' action='editCompareDevice.action'>
	<input type="hidden" id='projectRateId' name='projectRateId' />
	<input type="hidden" name='actionMethod' value='edit' />
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
			<tr><td colspan="2" align="center"><h2>專案手機資料管理</h2></td></tr>
			<tr>
				<th>專案代碼</th>
				<td>
					<input type='text' name='queryStr' />
				</td>
				<td>
					<select name='queryStatus'><option value=''>全部</option><option value='1'>啟用</option><option value='0'>停用</option></select>
				</td>
			</tr>
		</table>
		<br />
		<input type="hidden" id='actionMethod' name='actionMethod'/>
		<input class="submit btn" type="button" onclick='newData()' value="新增資料" />
		<input class="submit btn" type="button" onclick='submitForm("query")' value="查詢" />
	</form>
	<br /><br />
	<div>
		<c:if test='${not empty rateProjectsList}'>
		<table class="filtered_table hasBorder tablesorter">
			<tr>
				<th>專案代碼</th>
				<th>動作</th>
			</tr>
			<c:forEach items="${rateProjectsList}" var="rateProject">
			<tr>
				<td>${rateProject.rateId}</td>
				<td><input class="submit btn" type="button" onclick='editForm("${rateProject.rateId}")' value="修改" /></td>
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