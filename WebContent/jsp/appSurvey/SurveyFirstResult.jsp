<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html><!-- InstanceBegin template="/Templates/basic_layout.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0" />
<title>首登調查 - 查詢</title>
<script src="${pageContext.request.contextPath}/js/jquery-1.9.1.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-ui-1.10.3.custom.min.js"></script>
<script>
	
	function submitForm(){
		$("#cf_form").attr('action', 'querySurveyKeySave.action'); 
		$("#cf_form").submit();
	};
	
</script>
</head>
<body>
		<c:if test="${not empty banner}">
		<div style="text-align:center">
			<img src="${banner}" > 
		</div>
		</c:if>
		<div style="text-align:center">
			<font size="7">${title}</font>
		</div>
		<div style="text-align:center">
			<font size="5">${title_desc}</font>
		</div>
	
	<div>
	<c:if test="${not empty mapList}">
	 <form id='cf_form' action="doQueryAppInfo" method="post">
	 	<div style="margin:0 auto;width:900px;">
		 	<table border="1" width="100%"> 
		 		<input type="hidden" name="formkey" value="${formkey}" size="15"/>
		 		<c:forEach var="mapList" items="${mapList}" varStatus="idx">		
				<tr>
					<td width="50%">
						${mapList['name']}		
						<input type="hidden" name="columnName" value="${mapList['name']}" size="15"/>
					</td>
				 	<td>
					<c:choose>
						<c:when test="${mapList['type'] == 'moblieNumber'}">
						 ${mapList['value']}
					  	 <input type="hidden" name="columnValue" value="${mapList['value']}" size="15"/>
					    </c:when>
			    		<c:when test="${mapList['type'] == 'text'}">
					  	 <input type="text" name="columnValue" value="${mapList['value']}" size="15"/>
					    </c:when>
					    <c:when test="${mapList['type'] == 'select'}">
					    	<c:set var="selectvalue" value="${mapList['selectvalue']}"/>
							<c:set var="selectvaluearray" value="${fn:split(selectvalue,',')}"/>
							<c:set var="selecttext" value="${mapList['selecttext']}"/>
							<c:set var="selecttextarray" value="${fn:split(selecttext,',')}"/>
					    	<select id="listtype" name="columnValue">
							    <c:forEach var="select" items="${selecttextarray}" varStatus="idx">
							    	<option value="${selectvaluearray[idx.index]}" >${select}</option>
							    </c:forEach>
						    </select>	
					    </c:when>
					    <c:otherwise>
					    <input type="text" name="columnValue" value="" size="15"/>
					    </c:otherwise>
			    </c:choose>	
				  	</td>
				</tr>
				</c:forEach>					
			</table>
			<div style="text-align:center;margin-top:20px;">
					<input type="button" onclick="location.href='querySurvey.action'" value="返回" />
					<input type="button" onclick='submitForm()' value="送出" />
			</div>	   
		</div>					
	 </form>
	 </c:if>
	</div>
</body>
</html>