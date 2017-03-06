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
				addRow('${rateProjects.projectId}', '${rateProjects.price}', '${rateProjects.prepaymentAmount}', '${rateProjects.singlePhone}', '${rateProjects.status}', '${rateProjects.id}', 'false');
			</c:forEach>
		</c:if>
		<c:if test='${empty rateProjectsList}'>
			addRow('', '', '', '', '', '', '');
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
	function addRow(projectId, price, prepaymentAmount, singlePhone, status, id, showRemove) {
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
			"<td><input type='text' maxlength='5' name='rateProjectsList[" + rowCount + "].singlePhone' value='" + singlePhone + "' /></td>" +
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
		if('' != $('#projectRateId').val()){
			$("#cf_form").submit();
		}else{
			if('' == $('#newProjectRateId').val()){
				alert('請輸入專案代碼');
			}else{
				checkProjectRateId();
			}
		}
	};
	function checkProjectRateId(){
		if('' != $('#newProjectRateId').val()){
			var s = $('#reserveForm').serialize();
			//以下是執行AJAX要求server端處理資料
			$.ajax({
				url: "checkProjectRateId.action",
				type: 'POST', //根據實際情況，可以是'POST'或者'GET'
				data: {
					projectRateId: $('#newProjectRateId').val()
				},
	 			dataType: 'json', //指定數據類型，注意server要有一行：response.setContentType("text/xml;charset=utf-8");
				timeout: 300000, //設置timeout時間，以千分之一秒為單位，1000 = 1秒
				error: function (){	//錯誤提示
					alert ('系統忙碌中，請稍候再試!!');
				},
				success: function (data){ //ajax請求成功後do something with xml
						var obj = $.parseJSON(data);
						if(false == obj.isExist){
							$("#cf_form").submit();
						}else{
							alert('專案代碼重覆');
							$("#newProjectRateId").val('');
						}
				}
			});
		}
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
	<form id='cf_form' method='post' action='saveCompareDevice.action'>
		<input type="hidden" id='projectRateId' name='projectRateId' value="${projectRateId}" />
		
		<table class="filtered_table1">
			<tr>
				<th>專案代碼</th>
				<td>
					<c:if test='${empty projectRateId}'>
						<input type='text' id='newProjectRateId' name='newProjectRateId' value='${projectRateId}' />
					</c:if>
					<c:if test='${not empty projectRateId}'>
						<input type='text' value='${projectRateId}' readonly />
					</c:if>
				</td>
			</tr>
		</table>
		<table id='projectsList' class='hasBorder tablesorter'>
		    <tr>
				<th>機型</th>
				<th>專案價</th>
				<th>攜碼價格</th>
				<th>單機價格</th>
				<th>狀態</th>
				<th><input class='btn' type='button' value='新增一行' onclick="addRow('', '', '', '', '', '', '');" /></th>
			</tr>
		</table><br />
		<input class="submit btn" type="button" onclick='submitForm()' value="異動資料" />
		<form action="qryCompareData.action">
		    <input class="submit btn" type="button" onclick='window.location.href="queryCompareDevice.action"' value="返回" />
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