<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<title>台灣之星APP後台管理系統</title>
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/default.css"  media="all"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui-1.10.3.custom.min.css" />
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/tooltip.css" />
<script src="${pageContext.request.contextPath}/js/ga.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-1.9.1.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-ui-1.10.3.custom.min.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery.blockUI.js"></script>
<script src="${pageContext.request.contextPath}/js/util.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/ajaxfileupload.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/dw_tooltip_c.js"></script>
<script src="js/jquery.blockUI.js"></script>
<script>
	$(function() {
		$(".btn").addClass("button ui-button ui-widget ui-state-default ui-corner-all ui-state-hover");
		getLoginId('表單資料新增');	//取得目前登入使用者的ID
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
		if(null_chk.test($("#form_key").val())){
			alert("form_key不能為空");
		}else if(null_chk.test($("#form_title").val())){
			alert("form_title不能為空");
		}else if(null_chk.test($("#form_text").val())){
			alert("form_text不能為空");
		}else{		
			$(".txt1").each(function( index ) {	  
				if(null_chk.test($(this).val())){
					alert("欄位名稱不能為空");
					$(this).val().focus();
				}
			});
			$("#cf_form").attr('action', 'insertFormdata.action');
			$("#cf_form").submit();
		}
	};
	function updateForm(){
		var null_chk = /^\s*$/;//驗證空值
		if(null_chk.test($("#form_key").val())){
			alert("form_key不能為空");
		}else if(null_chk.test($("#form_title").val())){
			alert("form_title不能為空");
		}else if(null_chk.test($("#form_text").val())){
			alert("form_text不能為空");
		}else{		
			$(".txt1").each(function( index ) {	  
				if(null_chk.test($(this).val())){
					alert("欄位名稱不能為空");
					$(this).val().focus();
				}
			});
			$("#cf_form").attr('action', 'doUpdateFormdata.action');
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
	function selectType(object) {	
		var datavalue = $(object).val();
		if(datavalue == 'text'){
			 $(object).parent().parent().find(".tr_1").hide();	
			 $(object).parent().parent().find(".tr_2").show();
		}else if(datavalue =='select'){
			 $(object).parent().parent().find(".tr_2").hide();
			 $(object).parent().parent().find(".tr_1").show();	
		}
		
	}
	function checknewfile(){
		  var null_chk = /^\s*$/;//驗證空值		
		  	if(null_chk.test($("#formimage").val())){
			 	 alert("請選擇要上傳的圖片");
			}else{
				newfileUpload();
			}
	}
 	function newfileUpload() { 
 		$.blockUI();
	    $.ajaxFileUpload( {  
	        url : 'formdatafileAction.action',//用于文件上传的服务器端请求地址  
	        secureuri : false,          //一般设置为false  
	        fileElementId : 'formimage',     //文件上传空间的id属性  <input type="file" id="file" name="file" />  
	        dataType : 'json',          //返回值类型 一般设置为json  
	        success : function(data, status) {                   
	           $("#img").attr("src",data.formimagePath);
	           $('#img').show();
	           $("#form_img").attr("value",data.formimageFileName);    
	           $.unblockUI();
	        },
	        error:function(xhr, ajaxOptions, thrownError){ 
	           alert('error'); 
	        }
	    })  
 	}
	$(document).ready(function(){
			
		$("#newimg").click(function(){		
			$('#infoRecord tr:last').after('<tr>'+
											 	'<td align="right">'+'欄位名稱:</td>'+
												'<td align="left"><input type="text" name="formName" id="formName" size="30" class="txt1"/></td>'+	
												'<td align="right">欄位型態:</td>'+
												'<td align="left">'+
												'<select id="formType" name="formType" onchange="selectType(this)">'+
													'<option value="text">文字</option>'+
													'<option value="select">下拉</option>'+		
												'</select>'+
												'</td>'+
												'<td align="right">欄位預設值:</td>'+
												'<td align="left" class="tr_1" style="display: none" >'+
													'<select id="formValueSelect" name="formValueSelect">'+
														'<c:forEach var="groupList" items="${groupList}" varStatus="idx">'+
														'<option value="${groupList.functionId}" >${groupList.description}</option>'+
														'</c:forEach>'+
													'</select>'+
												'</td>'+
												'<td align="left" class="tr_2">'+
													'<input type="text" name="formValue" id="formValue" size="30" class="txt2"/>'+
												'</td>'+
												'<td align="right">'+
													'<input type="button" class="imgs" value="刪除欄位" />'+
												'</td>'+	
										   '</tr>'					 
										 );
			
		});
		$("#infoRecord").on("click",".imgs", function(){
			$(this).closest('tr').remove();
		});	
	});
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
	<div id="page" class="container" style="overflow: scroll; width: 1500px; height: 500px;">
		<c:if test="${not empty form_img_path}"> 
			<img id="img" name="img" src="${form_img_path}" >
		</c:if>
		<c:if test="${empty form_img_path}"> 
			<img id="img" name="img" src="" style="display: none">
		</c:if>
	<form id='cf_form' method='post'>
		<table class="filtered_table" cellspacing="10">
			<tbody id="infoRecord">				
			<tr>		
				<td>上傳圖片:</td>
				<td>	 
					<input type='file' name='formimage' id='formimage' size="30" /> 	
					<input type="button" value="上傳圖片" onclick="checknewfile();"/>
					<input type='hidden' name='form_img' id='form_img' value="${form_img}" size="30" /> 
				</td>
			</tr>
			<c:if test="${empty formName}">
			<tr>
				<td>form_key:</td>
				<td>
					<input type='text' name='form_key' id='form_key' value="${form_key}" size="30" /> 	
				</td>
			</tr>
			</c:if>
			<c:if test="${not empty formName}">
					<input type='hidden' name='form_key' id='form_key' value="${changeKey}" size="30" /> 	
			</c:if>
			<tr>			
				<td>form_title:</td>
				<td>
					 <input type='text' name='form_title' id='form_title' value="${form_title}" size="30" />	
				</td>
			</tr>
			<tr>
				<td>form_text:</td>
				<td>
					<textarea id="form_text" name="form_text" rows="4" cols="28">${form_text}</textarea> 	
				</td>
			</tr>
			<tr>
			<c:if test="${empty formName}">
			<tr>			
				<td align="right">欄位名稱:</td>
				<td align="left"><input type='text' name='formName' id='formName' size="30" class="txt1"/></td>	
				<td align="right">欄位型態:</td>
				<td align="left">
								<select id="formType" name="formType" onchange="selectType(this)">					
									<option value="text">文字</option>
									<option value="select">下拉</option>		
								</select>
				</td>
				<td align="right">欄位預設值:</td>
				<td align="left" class="tr_1" style="display: none">
								<select id="formValueSelect" name="formValueSelect">					
									<c:forEach var="groupList" items="${groupList}" varStatus="idx">
							    	<option value="${groupList.functionId}" >${groupList.description}</option>
							    	</c:forEach>	
								</select>
				</td>
				<td align="left" class="tr_2"><input type='text' name='formValue' id='formValue' size="30" class="txt2"/></td>
					
			</tr>
			</c:if>
			<c:if test="${not empty formName}">
				<c:forEach var="formName" items="${formName}" varStatus="idx">
					<tr>			
						<td align="right">欄位名稱:</td>
						<td align="left"><input type='text' name='formName' id='formName' size="30" value="${formName}" class="txt1"/></td>
						<td align="right">欄位型態:</td>
						<td align="left">
								<select id="formType" name="formType" onchange="selectType(this)">					
									<option value="text" ${formType[idx.index] == 'text' ? 'selected="selected"' : ''}>文字</option>
									<option value="select" ${formType[idx.index] == 'select' ? 'selected="selected"' : ''}>下拉</option>		
								</select>
						</td>
						<td align="right">欄位預設值:</td>
							<td align="left" class="tr_1" ${formType[idx.index] == 'select' ? '' : 'style="display: none"'}>
								<select id="formValueSelect" name="formValueSelect">					
									<c:forEach var="groupList" items="${groupList}">
							    	<option value="${groupList.functionId}" ${groupList.functionId == formValue[idx.index]  ? 'selected="selected"' : ''}>${groupList.description}</option>
							    	</c:forEach>	
								</select>
							</td>
							<td align="left" class="tr_2" ${formType[idx.index] == 'text' ? '' : 'style="display: none"'}><input type='text' name='formValue' id='formValue' value="${formValue[idx.index]}" size="30" class="txt2"/></td>
							<!-- 
							<c:choose>
							<c:when test="${idx.index !=0}">
							<td align="right"><input type="button" class="imgs"  value="刪除欄位"/></td>
							</c:when>
							</c:choose>
							 -->
					</tr>
				</c:forEach>
			</c:if>
		<tbody>
		<tr>
			<c:if test="${empty formName}">
			<td colspan="4" align="center"><input class="submit btn" type="button" onclick='submitForm()' value="確認送出" />
			&nbsp;<input class="submit btn" type="button" onclick='cleanForm()' value="清除" />
			&nbsp;<input class="submit btn" type="button" onclick="location.href='queryFormdataCondition.action'" value="返回" />
			&nbsp;<input class="submit btn" type="button" name="newimg" id="newimg" value="新增欄位" /></td>
			</c:if>
			<c:if test="${not empty formName}">
			<td colspan="4" align="center"><input class="submit btn" type="button" onclick='updateForm()' value="資料更新" />
			&nbsp;<input class="submit btn" type="button" onclick='cleanForm()' value="清除" />
			&nbsp;<input class="submit btn" type="button" onclick="location.href='queryFormdataCondition.action'" value="返回" />
			</c:if>	
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