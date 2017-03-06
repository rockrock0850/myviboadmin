<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>
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
		$("#cf_form").attr('action', 'querySurveyKey.action'); 
		$("#cf_form").submit();
	};
	
</script>
</head>
<body>
	<div>
	 <form id='cf_form' action="doQueryAppInfo" method="post">
	 	<table>
			<tr>
				<th>Key:</th>
			 	<td>
					<input type="text" name="Key" size="50" />
			  	</td>
			</tr>
			<tr>
				<td>
					<input type="hidden" name="moblieNumber" size="50" value="${moblieNumber}"/>
					<input type="button" onclick='submitForm()' value="查詢" />
				</td>
			</tr>
		</table>
	 </form>
	</div>
	<div>
	<p style="color:red">${datamesssage}</p>
	</div>
</body>
</html>