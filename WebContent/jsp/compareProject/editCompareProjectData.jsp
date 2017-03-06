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
				addRow('${rateProjects.mobileId}', '${rateProjects.price}', '${rateProjects.npPrice}', '${rateProjects.status}', '${rateProjects.id}','${rateProjects.projectId}' ,'false');
			</c:forEach>
		</c:if>
		<c:if test='${empty rateProjectsList}'>
			addRow('', '', '', '', '', '' ,'');
		</c:if>
		$("#company").val('${projectInfo.telecomId}');
		
		//如果有值，就帶出來
		$("#rateType").val('${projectInfo.netType}');
	});
	function btnClass(){
		$(".btn").addClass("button ui-button ui-widget ui-state-default ui-corner-all ui-state-hover");
	};
	
	var rowCount = 0;
	//動態增加欄位
	function addRow(mobileId, price, npPrice, status, id, projectId ,showRemove) {
		//判斷是否需要移除按鈕
		var appendStr = '';
		if('false' == showRemove){
			appendStr = "<td><input type='hidden' name='rateProjectsList[" + rowCount + "].id' value='" + id + "' /><input type='hidden' name='rateProjectsList[" + rowCount + "].projectId' value='" + projectId + "' /></td></tr>";
		}else{
			appendStr = "<td><input class='btn' type='button' value='移除' onclick='removeRow(this)'></td></tr>";
		}
		
		$('#projectsList tbody').append(
			"<tr><td><select id='rateProjectsList" + rowCount + "' name='rateProjectsList[" + rowCount + "].mobileId'>" +
			<c:forEach items="${mobileList}" var="project">
				"<option value='${project.id}'>${project.mobileName}</option>" +
			</c:forEach>
			"</select></td>" +
			"<td><input type='text' maxlength='5' name='rateProjectsList[" + rowCount + "].price' value='" + price + "' /></td>" +
			"<td><input type='text' maxlength='5' name='rateProjectsList[" + rowCount + "].npPrice' value='" + npPrice + "' /></td>" +
			"<td><select id='projectsListStatus" + rowCount + "' name='rateProjectsList[" + rowCount + "].status'>" +
			"<option value='1'>啟用</option><option value='0'>停用</option></select></td>"  + appendStr
		);		
		$("#rateProjectsList" + rowCount).val(mobileId);
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
	<form id='cf_form' method='post' action='saveCompareProjectData.action'>
	<input type="hidden" name='projectInfo.id' value="${projectInfo.id}" />
	<table class="filtered_table1">
		<tr>
			<th>電信業者</th>
			<td>
				<select id="company" name='projectInfo.telecomId'>
					<option value="1" ${projectInfo.telecomId == '1' ? 'selected="selected"' : ''}>台灣之星</option>
					<option value="3" ${projectInfo.telecomId == '3' ? 'selected="selected"' : ''}>遠傳電信</option>
					<option value="2" ${projectInfo.telecomId == '2' ? 'selected="selected"' : ''}>中華電信</option>
					<option value="4" ${projectInfo.telecomId == '4' ? 'selected="selected"' : ''}>台灣大哥大</option>
					<option value="5" ${projectInfo.telecomId == '5' ? 'selected="selected"' : ''}>亞太電信</option>
				</select>
			</td>
		</tr>
		<tr>
			<th>專案名稱</th>
			<td><input type='text' name='projectInfo.projectName' value='${projectInfo.projectName}' /></td>
		</tr>
		<tr>
			<th>資費類型</th>
			<td>
				<select id="rateType" name="projectInfo.netType">
					<option value="3G" ${projectInfo.netType == '3G' ? 'selected="selected"' : ''}>3G</option>
					<option value="4G" ${projectInfo.netType == '4G' ? 'selected="selected"' : ''}>4G</option>
				</select>
			</td>
		</tr>
		<tr>
			<th>專案費率</th>
			<td>
				<input type='text' name='projectInfo.projectRate' value='${projectInfo.projectRate}'/>
			</td>
		</tr>
		<tr>
			<th>上網傳輸量</br>(單位為MB,吃到飽NA)</th>
			<td><input type='text' name='projectInfo.freeDataAmount' value='${projectInfo.freeDataAmount}' /></td>
		</tr>
		<tr>
			<th>前幾格個月上網吃到飽</th>
			<td><input type='text' name='projectInfo.freeDataMonth' value='${projectInfo.freeDataMonth}' /></td>
		</tr>
		<tr>
			<th>超量每1MB金額</th>
			<td><input type='text' name='projectInfo.dataOverCostMb' value='${projectInfo.dataOverCostMb}' /></td>
		</tr>
		<tr>
			<th>網內語音</th>
			<td></td>
		</tr>
		<tr>
			<th>每通前分鐘免費</th>
			<td><input type='text' name='projectInfo.voiceOnNetFreeEachTime' value='${projectInfo.voiceOnNetFreeEachTime}' /></td>
		</tr>
		<tr>
			<th>每月分鐘免費(吃到飽NA)</th>
			<td><input type='text' name='projectInfo.voiceOnNetFreeMonthly' value='${projectInfo.voiceOnNetFreeMonthly}' /></td>
		</tr>
		<tr>
			<th>熱線門數</th>
			<td><input type='text' name='projectInfo.hotline' value='${projectInfo.hotline}' /></td>
		</tr>
		<tr>
			<th>贈送通信費</th>
			<td><input type='text' name='projectInfo.voiceOnNetFreeDollar' value='${projectInfo.voiceOnNetFreeDollar}' /></td>
		</tr>
		<tr>
			<th>每秒(元)</th>
			<td><input type='text' name='projectInfo.voiceOnNetCost' value='${projectInfo.voiceOnNetCost}' /></td>
		</tr>
		<tr>
			<th>網外語音</th>
			<td></td>
		</tr>
		<tr>
			<th>每月分鐘免費(NA吃到飽)</th>
			<td><input type='text' name='projectInfo.voiceOffNetFreeMonthly' value='${projectInfo.voiceOffNetFreeMonthly}' /></td>
		</tr>
		<tr>
			<th>贈送通信費</th>
			<td><input type='text' name='projectInfo.voiceOffNetFreeDollar' value='${projectInfo.voiceOffNetFreeDollar}' /></td>
		</tr>
		<tr>
			<th>每秒(元)</th>
			<td><input type='text' name='projectInfo.voiceOffNetCost' value='${projectInfo.voiceOffNetCost}' /></td>
		</tr>
		<tr>
			<th>網內簡訊</th>
			<td></td>
		</tr>
		<tr>
			<th>免費則數</th>
			<td><input type='text' name='projectInfo.smsOnNetFree' value='${projectInfo.smsOnNetFree}' /></td>
		</tr>
		<tr>
			<th>每則金額</th>
			<td><input type='text' name='projectInfo.smsOnNetCost' value='${projectInfo.smsOnNetCost}' /></td>
		</tr>
		<tr>
			<th>網外簡訊</th>
			<td></td>
		</tr>
		<tr>
			<th>免費則數</th>
			<td><input type='text' name='projectInfo.smsOffNetFree' value='${projectInfo.smsOffNetFree}' /></td>
		</tr>
		<tr>
			<th>每則金額</th>
			<td><input type='text' name='projectInfo.smsOffNetCost' value='${projectInfo.smsOffNetCost}' /></td>
		</tr>
		<tr>
			<th>專案附加說明</th>
			<td>
				<textarea rows="5" cols="50" name='projectInfo.projectExtraInfo' >${projectInfo.projectExtraInfo}</textarea>
			</td>
		</tr>
		<tr>
			<th>合約期限</th>
			<td><input type='text' name='projectInfo.contractMonths' maxlength="2" value='${projectInfo.contractMonths}' /></td>
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
		<form action="qryCompareProjectData.action">
		    <input class="submit btn" type="button" onclick='window.location.href="qryCompareProjectData.action"' value="返回" />
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