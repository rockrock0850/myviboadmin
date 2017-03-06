<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<title></title>
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/default.css" />
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
		getLoginId('APP手機資訊維護');	//取得目前登入使用者的ID
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
		$("#cf_form").attr('action', 'updateAppList.action'); 
		$("#cf_form").submit();
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
	//檢查檔案是否存在
	function checkfile(number){
		var null_chk = /^\s*$/;//驗證空值		
		if(null_chk.test($("#appUpimage"+number).val())){
			alert("請選擇要上傳的圖片");
		}else{
		   fileUpload(number);
		}
	}
	//上傳檔案的funtion
	function fileUpload(number) { 
		$.blockUI();
	    $.ajaxFileUpload( {     	
	        url : 'fileAction.action',//用于文件上传的服务器端请求地址  
	        secureuri : false,          //一般设置为false  
	        fileElementId : 'appUpimage'+number,     //文件上传空间的id属性  <input type="file" id="file" name="file" />  
	        dataType : 'json',          //返回值类型 一般设置为json  
	        success : function(data, status) {  
	        	     
	           $("#banner"+number).attr("value",data.appUpimagePath);
	          
	           showpic();
	        },
	        error:function(xhr, ajaxOptions, thrownError){ 
	           alert('error'); 
	        }
	       
	    }) 
	    
	 }   
	//讀畫面時執行toopic的funtion
	$(window).load(function() {
		showpic();
	});
	//toopic的顯示
	function showpic(){
		
		 $.unblockUI();

		 dw_Tooltip.defaultProps = {
			 // activateOnClick: true,
			 supportTouch: true // false by default
			    
		 }

			// Problems, errors? See http://www.dyn-web.com/tutorials/obj_lit.php#syntax
			
		 dw_Tooltip.content_vars = {				
			    L1: '<div style="text-align:center"><img src="'+$("#banner1").val()+'" /></div>',
			    L2: '<div style="text-align:center"><img src="'+$("#banner2").val()+'" /></div>',
			    L3: '<div style="text-align:center"><img src="'+$("#banner3").val()+'" /></div>',
			    L4: '<div style="text-align:center"><img src="'+$("#banner4").val()+'" /></div>',
			    L5: '<div style="text-align:center"><img src="'+$("#banner5").val()+'" /></div>',
			    L6: '<div style="text-align:center"><img src="'+$("#banner6").val()+'" /></div>',
			    L8: '<div style="text-align:center"><img src="'+$("#banner8").val()+'" /></div>',
			    L9: '<div style="text-align:center"><img src="'+$("#banner9").val()+'" /></div>',
		}
			
			
	}
	
	function checkform(){	
		var null_chk = /^\s*$/;//驗證空值	
		if(!null_chk.test($("#appUpimage1").val())){
			alert("請上傳找手機圖片");return false;
		}else if(!null_chk.test($("#appUpimage2").val())){
			alert("請上傳找資費圖片");return false;
		}else if(!null_chk.test($("#appUpimage3").val())){
			alert("請上傳懶人包圖片");return false;
		}else if(!null_chk.test($("#appUpimage4").val())){
			alert("請上傳粉絲團圖片");return false;
		}
		/*
		else if(!null_chk.test($("#appUpimage5").val())){
			alert("請上傳找優惠標題_ios圖片");return false;
		}else if(!null_chk.test($("#appUpimage6").val())){
			alert("請上傳找優惠標題_android圖片");return false;
		}
		*/
		else if(!null_chk.test($("#appUpimage8").val())){
			alert("請上傳找優惠圖片一的圖片");return false;
		}else if(!null_chk.test($("#appUpimage9").val())){
			alert("請上傳找優惠圖片二的圖片");return false;
		}else{
			
			return true;
			}
		
	}
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
	<form id='cf_form' method='post' onsubmit="javascript:return checkform(this);">
		<table class="hasBorder">
			<input type="hidden" size="30" name="osType"  value="${osType}"/>
			<thead>
				<tr align=center>
				 <c:choose>
		    		<c:when test="${osType == 'and'}">
				    	手機系統:ANDORID
				    </c:when>
				    <c:when test="${osType == 'ios'}">
				 		   手機系統:IOS
				    </c:when>
				    <c:otherwise>
				    N/A
				    </c:otherwise>
			    </c:choose>
				</tr>
				<tr>
					<th>欄位</th>
					<th>圖片URL</th>
					<th>連結URL</th>
					
				</tr>
			</thead>
			<tbody>				 
			    <tr>
					<td>找手機
					
					</td>
					<td>
						<c:choose>	
						<c:when test="${osType == 'and'}">																																	
					   	<input type="text" size="5" name="banner1"  id="banner1" value="<%=request.getScheme().toString()+"://"+request.getServerName()+":"+request.getServerPort() %>${map['app_home_and_title_banner.[1].pic']}" class="showTip L1" readonly/>		
						</c:when>
						<c:when test="${osType == 'ios'}">																																	
					   	<input type="text" size="5" name="banner1"  id="banner1" value="<%=request.getScheme().toString()+"://"+request.getServerName()+":"+request.getServerPort() %>${map['app_home_ios_title_banner.[1].pic']}" class="showTip L1" readonly/>		
						</c:when>
						</c:choose>
														   								
						<input type="file" name="appUpimage" id="appUpimage1"/>
						<input type="button" value="上傳圖片" onclick="checkfile(1);"/>
						<span id="content1">
						</span>
					</td>
					
					<td>
						<c:choose>
						<c:when test="${osType == 'and'}">	
						<input type="text" size="65" name="url1" value="${map['app_home_and_title_banner.[1].url']}"/>
						</c:when>
						<c:when test="${osType == 'ios'}">	
						<input type="text" size="65" name="url1" value="${map['app_home_ios_title_banner.[1].url']}"/>
						</c:when>
						</c:choose>		
					</td>
					
				</tr>				 
				<tr>
					<td>找資費</td>
					<td>
						<c:choose>	
						<c:when test="${osType == 'and'}">																																	
					   	<input type="text" size="5" name="banner2" id="banner2"  value="<%=request.getScheme().toString()+"://"+request.getServerName()+":"+request.getServerPort() %>${map['app_home_and_title_banner.[2].pic']}" class="showTip L2" readonly/>		
						</c:when>
						<c:when test="${osType == 'ios'}">																																	
					   	<input type="text" size="5" name="banner2" id="banner2"  value="<%=request.getScheme().toString()+"://"+request.getServerName()+":"+request.getServerPort() %>${map['app_home_ios_title_banner.[2].pic']}" class="showTip L2" readonly/>		
						</c:when>
						</c:choose>								   								
						<input type="file" name="appUpimage" id="appUpimage2"/>
						<input type="button" value="上傳圖片" onclick="checkfile(2);"/>
						<span id="content2">
						</span>
					</td>
					
					<td>
						<c:choose>
						<c:when test="${osType == 'and'}">	
						<input type="text" size="65" name="url2" value="${map['app_home_and_title_banner.[2].url']}"/>
						</c:when>
						<c:when test="${osType == 'ios'}">	
						<input type="text" size="65" name="url2" value="${map['app_home_ios_title_banner.[2].url']}"/>
						</c:when>
						</c:choose>		
					</td>
					
				</tr>
				
				<tr>
					<td>懶人包</td>
					<td>
						<c:choose>	
						<c:when test="${osType == 'and'}">																																	
					   	<input type="text" size="5" name="banner3" id="banner3" value="<%=request.getScheme().toString()+"://"+request.getServerName()+":"+request.getServerPort() %>${map['app_home_and_title_banner.[3].pic']}"  class="showTip L3" readonly/>		
						</c:when>
						<c:when test="${osType == 'ios'}">																																	
					   	<input type="text" size="5" name="banner3" id="banner3" value="<%=request.getScheme().toString()+"://"+request.getServerName()+":"+request.getServerPort() %>${map['app_home_ios_title_banner.[3].pic']}"  class="showTip L3" readonly/>		
						</c:when>
						</c:choose>								   								
						<input type="file" name="appUpimage" id="appUpimage3"/>
						<input type="button" value="上傳圖片" onclick="checkfile(3);"/>
						<span id="content3">
						</span>
					</td>
					
					<td>
						<c:choose>
						<c:when test="${osType == 'and'}">	
						<input type="text" size="65" name="url3" value="${map['app_home_and_title_banner.[3].url']}"/>
						</c:when>
						<c:when test="${osType == 'ios'}">	
						<input type="text" size="65" name="url3" value="${map['app_home_ios_title_banner.[3].url']}"/>
						</c:when>
						</c:choose>		
					</td>
					
				</tr>
				
				<tr>
					<td>粉絲團</td>
					<td>
						<c:choose>	
						<c:when test="${osType == 'and'}">																																	
					   	<input type="text" size="5" name="banner4" id="banner4" value="<%=request.getScheme().toString()+"://"+request.getServerName()+":"+request.getServerPort() %>${map['app_home_and_title_banner.[4].pic']}" class="showTip L4" readonly/>		
						</c:when>
						<c:when test="${osType == 'ios'}">																																	
					   	<input type="text" size="5" name="banner4" id="banner4" value="<%=request.getScheme().toString()+"://"+request.getServerName()+":"+request.getServerPort() %>${map['app_home_ios_title_banner.[4].pic']}" class="showTip L4" readonly/>		
						</c:when>
						</c:choose>								   								
						<input type="file" name="appUpimage" id="appUpimage4"/>
						<input type="button" value="上傳圖片" onclick="checkfile(4);"/>
						<span id="content4">
						</span>
					</td>
					
					<td>
						<c:choose>
						<c:when test="${osType == 'and'}">	
						<input type="text" size="65" name="url4" value="${map['app_home_and_title_banner.[4].url']}"/>
						</c:when>
						<c:when test="${osType == 'ios'}">	
						<input type="text" size="65" name="url4" value="${map['app_home_ios_title_banner.[4].url']}"/>
						</c:when>
						</c:choose>		
					</td>
					
				</tr>	
				<!-- 
				<tr>
					<td>找優惠標題_ios</td>
					<td>														   																							
					   	<input type="text" size="5" name="banner5" id="banner5" value="<%=request.getScheme().toString()+"://"+request.getServerName()+":"+request.getServerPort() %>${map['app_home_promote_banner.title_pic_ios']}" class="showTip L5" readonly/>														   								
						<input type="file" name="appUpimage" id="appUpimage5"/>
						<input type="button" value="上傳圖片" onclick="checkfile(5);"/>
					</td>
					
					<td>
						
					</td>
					
				</tr>
				 -->
				 <!-- 
				<tr>
					<td>找優惠標題_android</td>
					<td>														   																							
					   	<input type="text" size="5" name="banner6" id="banner6" value="<%=request.getScheme().toString()+"://"+request.getServerName()+":"+request.getServerPort() %>${map['app_home_promote_banner.title_pic_android']}" class="showTip L6" readonly/>														   								
						<input type="file" name="appUpimage" id="appUpimage6"/>
						<input type="button" value="上傳圖片" onclick="checkfile(6);"/>
					</td>
					
					<td>
						
					</td>
					
				</tr>
				 -->
				<tr>
					<td>找優惠_more</td>
					<td>														   																							
					   	
					</td>
					
					<td>
						
						<c:choose>
						<c:when test="${osType == 'and'}">	
						<input type="text" size="65" name="url7"  value="${map['app_home_and_promote_banner.more_url']}"/>
						</c:when>
						<c:when test="${osType == 'ios'}">	
						<input type="text" size="65" name="url7"  value="${map['app_home_ios_promote_banner.more_url']}"/>
						</c:when>
						</c:choose>		
					</td>
					
				</tr>
				
				<tr>
					<td>找優惠圖片一</td>
					<td>
						<c:choose>	
						<c:when test="${osType == 'and'}">																																	
					   	<input type="text" size="5" name="banner8" id="banner8" value="<%=request.getScheme().toString()+"://"+request.getServerName()+":"+request.getServerPort() %>${map['app_home_and_promote_banner.promote_data.[1].pic']}" class="showTip L8" readonly/>		
						</c:when>
						<c:when test="${osType == 'ios'}">																																	
					   	<input type="text" size="5" name="banner8" id="banner8" value="<%=request.getScheme().toString()+"://"+request.getServerName()+":"+request.getServerPort() %>${map['app_home_ios_promote_banner.promote_data.[1].pic']}" class="showTip L8" readonly/>		
						</c:when>
						</c:choose>								   								
						<input type="file" name="appUpimage" id="appUpimage8"/>
					    <input type="button" value="上傳圖片" onclick="checkfile(8);"/>
					</td>
					
					<td>
						<c:choose>
						<c:when test="${osType == 'and'}">	
						<input type="text" size="65" name="url8" value="${map['app_home_and_promote_banner.promote_data.[1].url']}"/>
						</c:when>
						<c:when test="${osType == 'ios'}">	
						<input type="text" size="65" name="url8" value="${map['app_home_ios_promote_banner.promote_data.[1].url']}"/>
						</c:when>
						</c:choose>		
					</td>
					
				</tr>	
				
				<tr>
					<td>找優惠圖片二</td>
					<td>
						<c:choose>	
						<c:when test="${osType == 'and'}">																																	
					   	<input type="text" size="5" name="banner9" id="banner9" value="<%=request.getScheme().toString()+"://"+request.getServerName()+":"+request.getServerPort() %>${map['app_home_and_promote_banner.promote_data.[2].pic']}" class="showTip L9" readonly/>		
						</c:when>
						<c:when test="${osType == 'ios'}">																																	
					   	<input type="text" size="5" name="banner9" id="banner9" value="<%=request.getScheme().toString()+"://"+request.getServerName()+":"+request.getServerPort() %>${map['app_home_ios_promote_banner.promote_data.[2].pic']}" class="showTip L9" readonly/>		
						</c:when>
						</c:choose>								   								
						<input type="file" name="appUpimage" id="appUpimage9"/>
						<input type="button" value="上傳圖片" onclick="checkfile(9);"/>
					</td>
					
					<td>
						<c:choose>
						<c:when test="${osType == 'and'}">	
						<input type="text" size="65" name="url9" value="${map['app_home_and_promote_banner.promote_data.[2].url']}"/>
						</c:when>
						<c:when test="${osType == 'ios'}">	
						<input type="text" size="65" name="url9" value="${map['app_home_ios_promote_banner.promote_data.[2].url']}"/>
						</c:when>
						</c:choose>		
					</td>
					
				</tr>
				
				<tr>
					<td>影音專區_more</td>
					<td>														   																							
					   	
					</td>
					
					<td>
						
						<c:choose>
						<c:when test="${osType == 'and'}">	
						<input type="text" size="65" name="url10"  value="${map['app_home_and_video.more_url']}"/>
						</c:when>
						<c:when test="${osType == 'ios'}">	
						<input type="text" size="65" name="url10"  value="${map['app_home_ios_video.more_url']}"/>
						</c:when>
						</c:choose>		
					</td>
					
				</tr>
				
				<tr>
					<td>影音專區</td>
					<td>														   																							
					   	
					</td>
					
					<td>
						
						<c:choose>
						<c:when test="${osType == 'and'}">	
						<input type="text" size="65" name="url11"  value="${map['app_home_and_video.youtube_url']}"/>
						</c:when>
						<c:when test="${osType == 'ios'}">	
						<input type="text" size="65" name="url11"  value="${map['app_home_ios_video.youtube_url']}"/>
						</c:when>
						</c:choose>		
					</td>
					
				</tr>
				
				<tr>
					<td>最新消息_more</td>
					<td>														   																							
					   	
					</td>
					
					<td>
						
						<c:choose>
						<c:when test="${osType == 'and'}">	
						<input type="text" size="65" name="url12"  value="${map['app_home_and_news.more_url']}"/>
						</c:when>
						<c:when test="${osType == 'ios'}">	
						<input type="text" size="65" name="url12"  value="${map['app_home_ios_news.more_url']}"/>
						</c:when>
						</c:choose>		
					</td>
					
				</tr>	
			</tbody>
			
				
			
		</table>
		<div style="text-align:center;margin:10 auto;">				
				
					<input class="submit btn" type="button" onclick="location.href='queryApp.action'" value="返回" />
					
				
					<input class="submit btn" type="button" onclick='submitForm()' value="確定異動" />
				
					<input type="checkbox" name="copy" value="both"><font size="+2">兩版共用</font>
				
			</div>
	</form>
	<br /><br />	
	</div>
</div>
<div id="footer" class="container">
	<div id="copyright" class="container">
		<p>台灣之星電信版權所有 Copyright© 2014 Taiwan Star Telecom Co., Ltd. All Rights Reserved.&nbsp;&nbsp;&nbsp;&nbsp;(最佳解析度1280X800)</p>
	</div>
</div>
</body>
</html>