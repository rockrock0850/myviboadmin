<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
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
		$("#cf_form").attr('action', 'qryCompareProjectData.action'); 
		$("#cf_form").submit();
	};
	function newData(){
		$("#cf_form").attr('action', 'editCompareProjectData.action'); 
		$("#cf_form").submit();
	};
	function editForm(str){
		$("#projectInfoid").val(str); 
		$("#ed_form").submit();
	};
</script> 
</head>
<body>
<form method='post' id='ed_form' action='editCompareProjectData.action'>
	<input type="hidden" id='projectInfoid' name='projectInfoid' />
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
						<option value="1" ${qryTelecomId == '1' ? 'selected="selected"' : ''}>台灣之星</option>
						<option value="3" ${qryTelecomId == '3' ? 'selected="selected"' : ''}>遠傳電信</option>
						<option value="2" ${qryTelecomId == '2' ? 'selected="selected"' : ''}>中華電信</option>
						<option value="4" ${qryTelecomId == '4' ? 'selected="selected"' : ''}>台灣大哥大</option>
						<option value="5" ${qryTelecomId == '5' ? 'selected="selected"' : ''}>亞太電信</option>
					</select>
				</td>
			</tr>
			<tr>
				<th>專案金額</th>
				<td><input type='text' name='queryStart' value=''/>~<input type='text' name='queryEnd' value=''/></td>
			</tr>
		</table>
		<br />
		<input type="hidden" id='actionMethod' name='actionMethod'/>
		<input class="submit btn" type="button" onclick='newData()' value="新增資料" />
		<input class="submit btn" type="button" onclick='submitForm("query")' value="查詢" />
	</form>
	<br /><br />
	<div>
		<c:if test='${not empty projectInfoList}'>
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
			<c:forEach items="${projectInfoList}" var="projectInfoList">
			<tr>
				<td>${qryTelecomName}</td>
				<td>${projectInfoList.projectName}</td>
				<td>${projectInfoList.projectRate}</td>
				<c:choose>
					<c:when test="${projectInfoList.freeDataAmount == 'NA'}">
					  	 <td>上網吃到飽</td>
					</c:when>
					<c:otherwise>
						<c:set var="flow" scope="session" value="${projectInfoList.freeDataAmount/1000}"/>
						<c:if test="${flow >= 1}">
					  		<td>每月免費傳輸量:<fmt:formatNumber value="${flow}" pattern="#.##"/>GB </br>	
						</c:if>
						<c:if test="${flow < 1}">
					  	 	<td>每月免費傳輸量:<fmt:formatNumber value="${flow}" pattern="#.##"/>MB</br>	
						</c:if>
							<c:if test="${not empty projectInfoList.freeDataMonth && projectInfoList.freeDataMonth !=0}">
					  			前${projectInfoList.freeDataMonth}個月上網吃到飽<br>
					  			</c:if>
					  			<c:if test="${not empty projectInfoList.dataOverCostMb && projectInfoList.dataOverCostMb !=0.0}">
					  			超量每MB:${projectInfoList.dataOverCostMb}元<br>
					  			</c:if>
					  		</td>
					</c:otherwise>	
				</c:choose>
				<td>${projectInfoList.contractMonths}</td>
				<td>${projectInfoList.netType}</td>
				<td><input class="submit btn" type="button" onclick='editForm("${projectInfoList.id}")' value="修改" /></td>
			</tr>
			</c:forEach>
		</table>
		</c:if>	
		<p style="color:green">${message}</p>	
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