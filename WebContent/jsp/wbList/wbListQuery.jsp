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
		getLoginId('黑白名單維護');	//取得目前登入使用者的ID
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
			$("#cf_form").attr('action', 'bwListConditionResult.action'); 
			$("#cf_form").submit();	
			$('#tblResult tbody').sortable();
		}
		
	};
	function cleanForm(){
		$('#filterKey').val('');
		$('#name').val('');
		$('#filterValue').val('');
		$("#filterType")[0].selectedIndex = 0;
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
	
	$(document).ready(function() { 
		$("#tblResult").tablesorter();
		$(".editRadio").click(function() {
			$(".buttoncommit").hide();
		    $(this).parent().parent().find(".buttoncommit").show();	
		});
    });
	function postdata(number){
		$('#update_id').val($('#listid'+number).val());
		$('#update_user').val($('#LoginId').text());
		$('#update_filtername').val($('#listname'+number).val());
		$('#update_filtervalue').val($('#listvalue'+number).val());
		$('#update_status').val($('#liststatus'+number).val());
		$('#update_filterType').val($('#listtype'+number).val());
		var null_chk = /^\s*$/;//驗證空值
		if(null_chk.test($("#update_filterKey").val())){
			alert("更新資料key不能為空");
		}else if(null_chk.test($("#update_filtername").val())){
			alert("更新資料name不能為空");
		}else if(null_chk.test($("#update_filtervalue").val())){
			alert("更新資料value不能為空");
		}else{
			$("#update_form").attr('action', 'bwListChange.action'); 
			$("#update_form").submit();		
		}
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
			<tr><td colspan="4" align="center"><h2>請輸入搜尋條件</h2></td></tr>
			<tr>
				<td>key:</td>
				<td>
					<input type='text' name='filterKey' id='filterKey' size="30" value="${filterKey}"/> 	
				</td>
			</tr>
			<tr>			
				<td>名稱:</td>
				<td>
					 <input type='text' name='name' id='name' size="30" value="${name}"/>	
				</td>
			</tr>
			<tr>
				<td>值:</td>
				<td>
					<input type='text' name='filterValue' id='filterValue' size="30" value="${filterValue}"/> 	
				</td>
			</tr>
			<tr>
			<tr>
				<td>名單型態:</td>
				<td>
					<select id="filterType" name="filterType">
						<option value="all" ${filterType == 'all' ? 'selected="selected"' : ''}>所有</option>
						<option value="B" ${filterType == 'B' ? 'selected="selected"' : ''}>黑名單</option>
						<option value="W" ${filterType == 'W' ? 'selected="selected"' : ''}>白名單</option>		
					</select>	
				</td>
			</tr>
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
			&nbsp;<input class="submit btn" type="button" onclick="location.href='bwListAdd.action'" value="新增資料" /></td>
		</tr>			
		</table>		
	</form>
	<form  id='update_form' method='post'>
		<input type="hidden" id="update_id" name="update_id" value="" size="15"/>
		<input type="hidden" id="update_user" name="update_user" value="" size="15"/>
		<input type="hidden" id="update_filtername" name="update_filtername" value="" size="15"/>
		<input type="hidden" id="update_filtervalue" name="update_filtervalue" value="" size="15"/>
		<input type="hidden" id="update_status" name="update_status" value="" size="15"/>
		<input type="hidden" id="update_filterType" name="update_filterType" value="" size="15"/>
		<input type='hidden' id='filterKey' name='filterKey' value="${filterKey}" size="30"/>
		<input type='hidden' id='name' name='name' value="${name}" size="30"/>
		<input type='hidden' id='filterValue' name='filterValue' value="${filterValue}" size="30"/> 
		<input type='hidden' id='filterType' name='filterType' value="${filterType}" size="30"/> 
		<input type='hidden' id='status' name='status' value="${status}" size="30"/>
		<input type="hidden" id="createtimestart" name="createtimestart" value="${createtimestart}"> 
		<input type="hidden" id="createtimeend" name="createtimeend" value="${createtimeend}">
	</form>
	<c:if test="${not empty message}"> 
	    <p style="color:green">${message}</p>
	</c:if>
	<c:if test="${not empty filterList}">
	<div id="page" class="container">		
		<table id="tblResult" class="hasBorder tablesorter" style="margin-top:20px;">
			<thead>
				<tr>
					<th></th>
					<th>key</th>
					<th>名稱</th>
					<th>value</th>
					<th>所屬名單</th>
					<th>狀態</th>
					<th>資料建立日期</th>
					<th>功能</th>		
				</tr>
			</thead>
			<tbody>		
			<c:forEach var="filterList" items="${filterList}" varStatus="idx">
				<tr>
					<td>
						<input type="hidden" id="listid${idx.index}" value="${filterList.id}" size="15"/>
						<input type="radio" class="editRadio" name="editRadio"/>
					</td>
					<td>	
						${filterList.filterKey}
					</td>
					<td>
						<input type="text" id="listname${idx.index}" value="${filterList.name}" size="15"/>
						<p style="display: none">${filterList.name}</p>
					</td>
					<td>
						<input type="text" id="listvalue${idx.index}" value="${filterList.value}" size="15"/>
						<p style="display: none">${filterList.value}</p>
					</td>
					<td>
			    		<select id="listtype${idx.index}">
							<option value="W" ${filterList.filterType == 'W' ? 'selected="selected"' : ''}>白名單</option>
							<option value="B" ${filterList.filterType == 'B' ? 'selected="selected"' : ''}>黑名單</option>		
						</select>
						<p style="display: none">${filterList.filterType}</p>
					</td>
					<td>
			    		<select id="liststatus${idx.index}">
							<option value="1" ${filterList.status == '1' ? 'selected="selected"' : ''}>啟用</option>
							<option value="0" ${filterList.status == '0' ? 'selected="selected"' : ''}>停用</option>		
						</select>
						<p style="display: none">${filterList.status}</p>
					</td>
					<td>${filterList.createTime}</td>
					<td><input type="button" class="buttoncommit" value="資料更新" style="display: none" onclick='postdata(${idx.index})'></td>				
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