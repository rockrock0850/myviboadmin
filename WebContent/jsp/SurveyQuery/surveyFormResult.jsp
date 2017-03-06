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
<script src="${pageContext.request.contextPath}/js/jquery-ui-timepicker-addon.js"></script> <!-- 將 JQuery UI 的 date picker 加上時間功能，請參考 http://trentrichardson.com/examples/timepicker/ -->
<script src="${pageContext.request.contextPath}/js/jquery.tablesorter.min.js"></script> <!-- 以 table column 排序用，請參考 http://tablesorter.com/docs/ -->
<script>
	$(function() {
		$(".btn").addClass("button ui-button ui-widget ui-state-default ui-corner-all ui-state-hover");
		getLoginId('調查表單維護');	//取得目前登入使用者的ID
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
		if(null_chk.test($("#createtimestart").val()) & !null_chk.test($("#createtimeend").val())){
			alert("請輸入建立時間(起)");
		}else if(null_chk.test($("#createtimeend").val()) & !null_chk.test($("#createtimestart").val())){
			alert("請輸入建立時間(迄)");
		}else if($("#createtimestart").val()>$("#createtimeend").val()){
			alert("建立時間(起)不能大於建立時間(迄)");
		}else{
			$("#cf_form").attr('action', 'queryFormdata.action'); 
			$("#cf_form").submit();	
			$('#tblResult tbody').sortable();
		}
		
	};
	function cleanForm(){
		$('#searchKey').val('');
		$('#searchTitle').val('');
		$("#status")[0].selectedIndex = 0;
		$('#createtimestart').val('');
		$('#createtimeend').val('');
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
	$(function() {
		
		setDatetimePicker('createtimestart');	//將某個 input box 設為 datetime picker
		setDatetimePicker('createtimeend');
	});	
	
	$(document).ready(function() 
		    { 
		        $("#tblResult").tablesorter(); 
		    } 
	); 
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
			<tr><td colspan="4" align="center"><h2>請輸入搜尋條件</h2></td></tr>
			<tr>
				<td>form_key:</td>
				<td>
					<input type='text' name='searchKey' id='searchKey' size="30" value="${searchKey}"/> 	
				</td>
			</tr>
			<tr>			
				<td>form_title</td>
				<td>
					 <input type='text' name='searchTitle' id='searchTitle' size="30" value="${searchTitle}"/>	
				</td>
			</tr>
			
			<tr>
			<tr>
				<td>狀態:</td>
				<td>
					<select id="status" name="status">
						<option value="all" ${status == 'all' ? 'selected="selected"' : ''}>所有</option>
						<option value="1" ${status == '1' ? 'selected="selected"' : ''}>啟用</option>
						<option value="0" ${status == '0' ? 'selected="selected"' : ''}>停用</option>		
					</select>	
				</td>
			</tr>
			<tr>
				<td>建立時間起</td>
				<td><input type="text" id="createtimestart" name="createtimestart" value="${createtimestart}"></td>
				<td>建立時間迄</td>
				<td><input type="text" id="createtimeend" name="createtimeend" value="${createtimeend}"></td>			
			</tr>
		<tr>
			<td colspan="4" align="center"><input class="submit btn" type="button" onclick='submitForm()' value="查詢" />
			&nbsp;<input class="submit btn" type="button" onclick='cleanForm()' value="清除" />
			&nbsp;<input class="submit btn" type="button" onclick="location.href='addFormdata.action'" value="新增資料" /></td>
		</tr>			
		</table>	
	</form>
	<c:if test="${not empty message}"> 
	    <p style="color:green">${message}</p>
	</c:if>
	<c:if test="${not empty alldata}">
	<div id="page" class="container">		
		<table id="tblResult" class="hasBorder tablesorter" style="margin-top:20px;">
			<thead>
				<tr>
					<th>key</th>
					<th>標題名稱</th>
					<th>狀態</th>
					<th>資料建立日期</th>
					<th>功能</th>			
				</tr>
			</thead>
			<tbody>		
			<c:forEach var="alldata" items="${alldata}">
			<tr>
				<c:set var="key" value="${fn:split(alldata.key, '.')}" />
				<td><a href="updateFormdata.action?changeKey=${key[1]}">${key[1]}</a></td>
				<td>${alldata.value}</td>
				<td>
					<c:choose>
	    			<c:when test="${alldata.status == '1'}">
			  			啟用
			   		</c:when>
			   		<c:when test="${alldata.status == '0'}">
			         	停用
			   		</c:when>
		    		</c:choose>
				</td>
				<td>${alldata.createTime}</td>	
				<td>
					<form method='post' action="changeFormdataStatus.action">
					<input type="hidden" id="dataKey" name="dataKey" value="${alldata.key}">
					<input type="hidden" id="dataStatus" name="dataStatus" value="${alldata.status}">
					<input type='hidden' name='searchKey' id='searchKey' size="30" value="${searchKey}"/>
					<input type='hidden' name='searchTitle' id='searchTitle' size="30" value="${searchTitle}"/>
					<input type='hidden' name='status' id='status' size="30" value="${status}"/>
					<input type="hidden" id="createtimestart" name="createtimestart" value="${createtimestart}">
					<input type="hidden" id="createtimeend" name="createtimeend" value="${createtimeend}">
					<c:choose>
					<c:when test="${alldata.status == '1'}">
			  			<input type="submit" value="停用">
			   		</c:when>
					<c:when test="${alldata.status == '0'}">
			  			<input type="submit" value="啟用">
			   		</c:when>
					</c:choose>
					</form>
				</td>			
			</tr>
			</c:forEach>		
			</tbody>
		</table>
		</div>	
		</c:if>		
	</div>	
</div>
<div id="footer" class="container">
	<div id="copyright" class="container">
		<p>台灣之星電信版權所有 Copyright© 2014 Taiwan Star Telecom Co., Ltd. All Rights Reserved.&nbsp;&nbsp;&nbsp;&nbsp;(最佳解析度1280X800)</p>
	</div>
</div>
</body>
</html>