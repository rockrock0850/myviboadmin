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
		getLoginId('首頁畫面連結維護');	//取得目前登入使用者的ID
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
		$("#cf_form").attr('action', 'queryAppList.action'); 
		$("#cf_form").submit();
	};
	
	function saveForm(){
		$("#ed_form").attr('action', 'saveMkturl.action'); 
		$("#ed_form").submit();
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
				<th>手機系統</th>
				<td>
					<!-- <input type='text' name='queryStr' /> -->
					<select id="ostype" name='osType'>
						<option value="and">Android</option>
						<option value="ios">Ios</option>
						
					</select>
				</td>
				
			</tr>
			<tr>
				<td>
				</td>
				
				<td>
					<input class="submit btn" type="button" onclick='submitForm()' value="查詢" />
				</td>
			</tr>
		</table>
	</form>
	
	<br /><br />
		
	<form id='ed_form' method='post'>
		<table class="filtered_table">
			<tr>
				<th>推廣畫面url</th>
				<td>
					<input type="text" name="mktUrl" value="${mktUrl}"size="100" />
					<input type="hidden" name="mktId" value="${mktId}"size="100" />
				</td>
				
			</tr>
			<tr>
				<td>
				<p style="color:red">${mktmsg}</p>
				</td>
				<td>
					<c:if test="${empty mktmsg}">
					<input class="submit btn" type="button"onclick='saveForm()' value="修改" />
					</c:if>
				</td>
				
			</tr>
		</table>
	</form>
	<c:if test="${not empty msg}">
		<p style="color: green">${msg}</p>
	</c:if>
				
		<c:if test="${not empty sessionScope.msg0}"> 
		    <p style="color:green">${sessionScope.msg0}</p>
		    <% session.removeAttribute("msg0"); %>
		</c:if>    
		<c:if test="${not empty sessionScope.msg1}"> 
		    <p style="color:green">${sessionScope.msg1}</p>
		    <% session.removeAttribute("msg1"); %>
		</c:if>       
		<c:if test="${not empty sessionScope.msg2}"> 
		    <p style="color:green">${sessionScope.msg2}</p>
		    <% session.removeAttribute("msg2"); %>
		</c:if> 
		<c:if test="${not empty sessionScope.msg3}"> 
		    <p style="color:green">${sessionScope.msg3}</p>
		    <% session.removeAttribute("msg3"); %>
		</c:if>
		<c:if test="${not empty sessionScope.msg4}"> 
		    <p style="color:green">${sessionScope.msg4}</p>
		    <% session.removeAttribute("msg4"); %>
		</c:if>
		<c:if test="${not empty sessionScope.msg5}"> 
		    <p style="color:green">${sessionScope.msg5}</p>
		    <% session.removeAttribute("msg5"); %>
		</c:if>
		<c:if test="${not empty sessionScope.msg6}"> 
		    <p style="color:green">${sessionScope.msg6}</p>
		    <% session.removeAttribute("msg6"); %>
		</c:if>
		<c:if test="${not empty sessionScope.msg7}"> 
		    <p style="color:green">${sessionScope.msg7}</p>
		    <% session.removeAttribute("msg7"); %>
		</c:if>
		<c:if test="${not empty sessionScope.msg8}"> 
		    <p style="color:green">${sessionScope.msg8}</p>
		    <% session.removeAttribute("msg8"); %>
		</c:if>
		<c:if test="${not empty sessionScope.msg9}"> 
		    <p style="color:green">${sessionScope.msg9}</p>
		    <% session.removeAttribute("msg9"); %>
		</c:if>
		<c:if test="${not empty sessionScope.msg10}"> 
		    <p style="color:green">${sessionScope.msg10}</p>
		    <% session.removeAttribute("msg10"); %>
		</c:if>
		<c:if test="${not empty sessionScope.msg11}"> 
		    <p style="color:green">${sessionScope.msg11}</p>
		    <% session.removeAttribute("msg11"); %>
		</c:if>
		<c:if test="${not empty sessionScope.msg12}"> 
		    <p style="color:green">${sessionScope.msg12}</p>
		    <% session.removeAttribute("msg12"); %>
		</c:if>
		<c:if test="${not empty sessionScope.msg13}"> 
		    <p style="color:green">${sessionScope.msg13}</p>
		    <% session.removeAttribute("msg13"); %>
		</c:if>
		<c:if test="${not empty sessionScope.msg14}"> 
		    <p style="color:green">${sessionScope.msg14}</p>
		    <% session.removeAttribute("msg14"); %>
		</c:if>
		<c:if test="${not empty sessionScope.msg15}"> 
		    <p style="color:green">${sessionScope.msg15}</p>
		    <% session.removeAttribute("msg15"); %>
		</c:if>
		<c:if test="${not empty sessionScope.msg16}"> 
		    <p style="color:green">${sessionScope.msg16}</p>
		    <% session.removeAttribute("msg16"); %>
		</c:if>
		<c:if test="${not empty sessionScope.msg17}"> 
		    <p style="color:green">${sessionScope.msg17}</p>
		    <% session.removeAttribute("msg17"); %>
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