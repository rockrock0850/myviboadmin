<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>台灣之星APP後台管理系統</title>
<link href="css/default.css" rel="stylesheet" type="text/css" media="all" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui-1.10.3.custom.min.css" />
<script src="${pageContext.request.contextPath}/js/ga.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-1.9.1.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-ui-1.10.3.custom.min.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery.blockUI.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery.blockUI.js"></script>
<script src="${pageContext.request.contextPath}/js/util.js"></script>



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
	<div id="pageCr" class="container">
		<form id="selectListForm" name="selectListForm" action="selectListMtn.action" method="post" >
		
		  <input type="hidden" id="serviceSel" name="serviceSel" value="mytstar"/>
		  <input type="hidden" id="statusSel" name="statusSel" value="1,0"/>
		  <input type="hidden" id="parentSel" name="parentSel" value="ROOT"/>
		
		  <input type="hidden" id="idNo" name="idNo" value=""/>
		  <input type="hidden" id="serviceId" name="serviceId" value=""/>
		  <input type="hidden" id="functionId" name="functionId" value=""/>
		  <input type="hidden" id="parentId" name="parentId" value=""/>
		  <input type="hidden" id="val" name="val" value=""/>
		  <input type="hidden" id="text" name="text" value=""/>
		  <input type="hidden" id="status" name="status" value=""/>
		  <input type="hidden" id="statusQuery" name="statusQuery" value=""/>
		  <input type="hidden" id="dscr" name="dscr" value=""/>
		  <input type="hidden" id="seq" name="seq" value=""/>
		  <input type="hidden" id="currentUser" name="currentUser" value=""/>
		  
		  
		  <input type="hidden" id="clickRecord" name="clickRecord" value=""/>

	<table id="crTable" class="hasBorder tablesorter" style="margin-top:20px;width:100%;">
		<tr>
			<td class="item">查詢群組 :
				<select id="groupSel" name='groupSel'>
					<option value="" >選擇群組</option>
					<!-- <option value="comparsionSelect1" >資費</option>
					<option value="comparsionSelect2" >電信公司</option> -->
					<!-- 由jquery組成下拉選單的內容 -->
				</select>
				<input id="querySelectList" name="querySelectList" class="button" value="查詢" onclick="query_selectList('ROOT', '0');" type="button">
			</td>
		<td class="item">新增群組 :
			<input id="selectList_group_dscr" name="selectList_group_dscr" type="text";>
			<input id="selectList_group_button" name="submitAdd" class="button" value="新增群組" onclick="group_insert_selectList();" type="button">
		</tr>
	</table>
	</div>
</div>

<div id="wrapper">
<div id="page" class="container">
	</div>
	<div id="page" class="container">
	</div>

</div>

<div id="footer" class="container">
	<div id="copyright" class="container">
		<p>台灣之星電信版權所有 Copyright© 2014 Taiwan Star Telecom Co., Ltd. All Rights Reserved.&nbsp;&nbsp;&nbsp;&nbsp;(最佳解析度1280X800)</p>
	</div>
</div>	

<div id="pop_message_selectList" style="display: none" title="下拉選單選項資料">
	<p>請填入所有欄位</p>
      <table cellspacing="10">
        <tr>
          <td>上一層選項名稱(PARENT_ID)</td>
          <td><input type="text" id="selectList_parentId" readonly="true" /></td>
        </tr>
        <tr>
          <td>選項名稱(TEXT)</td>
          <td><input type="text" id="selectList_text" placeholder="顯示在網頁頁面上的值" /></td>
        </tr>
        <tr>
          <td>該選項的值(VAL)</td>
          <td><input type="text" id="selectList_val" placeholder="所代表的值" /></td>
        </tr>
        <tr>
          <td>順序(SEQ)</td>
          <td><input type="text" id="selectList_seq" placeholder="只能輸入數字，例如1,2,3..." onchange="only_number_add()"/></td>
        </tr>
        <tr>
          <td>目前是否有效(STATUS)</td>
          <td>
              <select id="selectList_status">
                  <option value="1">有效</option>
                  <option value="0">失效</option>
              </select>
          </td>
        </tr>
      </table>
      <%-- <span id="info_new_groupClass">
        <button type="button" onclick="info_insert_selectList()">新增</button>
      </span>  --%>
      <%-- <span id="group_new_groupClass" style="display: none">
        <button type="button" onclick="group_add_selectList()">新增群組</button>
      </span> --%>
      <!-- <button type="button" onclick="$.unblockUI();">關閉</button> -->
  </div>

<script>
var preGroupSel = '${groupSel}';
var preDscr = '${dscr}';
var oldRadioId = '';
var record = ['ROOT']; 
var idChildIdMapJson = jQuery.parseJSON('${idChildIdMapJson}');
var idTextMapJson = jQuery.parseJSON('${idTextMapJson}');
var parentIdLevelMapJson = jQuery.parseJSON('${parentIdLevelMapJson}');
//var functionIdDscrMapJson = jQuery.parseJSON('${functionIdDscrMapJson}');//用不到, 改用groupListJson
var baseInfoMapJson = jQuery.parseJSON('${baseInfoMapJson}');
var groupListJson = jQuery.parseJSON('${groupListJson}');
var clickRecordListJson = jQuery.parseJSON('${clickRecordListJson}');

$(function() {
	$(".button").button();	//將class=button的物件做成 JQuery UI 的 button
	getLoginId('下拉選單管理');	//取得目前登入使用者的ID
	
	if(idChildIdMapJson['ROOT'].length != 0){//若沒資料會回傳idChildIdMapJson={"ROOT":[]}
		info_list('','ROOT');
	}
	
	//查詢完畢後，把serviceId, functionId, dscr 代入hidden，新增和修改時直接取值，因為同一群組，這三個值一樣
	$("#serviceId").val(baseInfoMapJson.serviceId);
	$("#functionId").val(baseInfoMapJson.functionId);
	$("#dscr").val(baseInfoMapJson.dscr);
	//第一次呼叫 selectMtn.action 會先打到action，所以 serviceId, functionId, status是null
	
	//組成查詢群組的下拉選單
	$(groupListJson).each(function() {
		$("#groupSel").append("<option value='"+this.functionId+"'>"+this.description+"</option>");
	});
	
	if('' != preGroupSel){
		$("#groupSel").val(preGroupSel);
	}
	
	//若按下新增群組，新增，查詢，至action處理完後，代入之前點到哪一層
	if(clickRecordListJson.length > 1){
		for(i=0; i<clickRecordListJson.length-1; i++){
			info_list(clickRecordListJson[i], clickRecordListJson[i+1], 'Y');
		} 
	}
	
	//新增時的pop視窗
	$( "#pop_message_selectList" ).dialog({
		autoOpen: false,
		top: 50,
        left: ($(window).width() - 750) / 2 ,
		height: 400,
		width: 600,
		modal: true,
		buttons: {
			"確認": function() {
				info_insert_selectList();
			},
			"取消": function() {
				$( this ).dialog( "close" );
			}
		}
	});	//$( "#dialog-form" ).dialog({
	
});

//點選顯示下一層，disabled上一層，若toRecord=Y則會記錄上一層的節點(parentId)
function info_list(exNode,node,toRecord){
	
	if(toRecord == 'Y'){
		record.push(node);
	}
	$('#tblResult'+exNode).find('input,button,select').attr('disabled', 'disabled');
	var data = idChildIdMapJson[node]; 
	var hierarchy;
	$('#page').append(
		'<table id="tblResult'+node+'" name="tblResult" class="hasBorder tablesorter" style="margin-top:20px;width:100%;">' + 
		
		'<thead>' +
			'<tr>' +
			    '<td> </td>' +
				'<td>PARENT_ID</td>' +
				
				'<td>TEXT</td>' +
				'<td>VAL</td>' +
				'<td>SEQ</td>' +
				'<td>STATUS</td>' +
				'<td></td>' +
			'</tr>' +
		'</thead>' +
		'<tbody>' 
	);
	
	for(var i=0; i<data.length; i++){
		hierarchy = data[i].hierarchy;
		var row = '<tr id="'+data[i].id+'" name="'+data[i].parentId+'">';
		row += '<td><input type="radio" id="editRadio'+data[i].id+'" name="editRadio" value="'+data[i].id+'" onclick="radio_selectList(\''+data[i].id+'\')"/></td>';
		
		row += '<td>';
		row += idTextMapJson[data[i].parentId];
		/* row += '<input type="text" id="parentId'+data[i].id+'" name="parentId" value="'+data[i].parentId+'" readonly="true" size="15"/>'; */
        row += '<input type="hidden" id="parentIdHid'+data[i].id+'" name="parentIdHid" value="'+data[i].parentId+'"/>';
        row += '</td>';

		row += '<td>';
		row += '<input type="text" id="text'+data[i].id+'" name="text" value="'+data[i].text+'" size="15"/>';
        row += '<input type="hidden" id="textHid'+data[i].id+'" name="textHid" value="'+data[i].text+'"/>';
        row += '</td>';

		row += '<td>';
		row += '<input type="text" id="val'+data[i].id+'" name="val" value="'+data[i].val+'" size="15"/>';
        row += '<input type="hidden" id="valHid'+data[i].id+'" name="valHid" value="'+data[i].val+'"/>';
        row += '</td>';

		row += '<td>';
		row += '<input type="text" id="seq'+data[i].id+'" name="seq" value="'+data[i].seq+'" size="15" onchange="only_number(\''+data[i].id+'\')"/>';
        row += '<input type="hidden" id="seqHid'+data[i].id+'" name="seqHid" value="'+data[i].seq+'"/>';
        row += '</td>';

		row += '<td>';
		/* row += '<input type="text" id="status'+data[i].id+'" name="status" value="'+data[i].status+'" readonly="true" size="15"/>'; */
		row += '<select id="status'+data[i].id+'" name="status" >';
		/* row += '	<option value="1">有效</option>';
		row += '	<option value="0" selected="selected">失效</option>'; */
		for(var j=0; j<2; j++){
			if(j == data[i].status) row += '<option value="'+data[i].status+'" selected="selected">'+idTextMapJson[data[i].status]+'</option>';
			else row += '<option value="'+j+'">'+idTextMapJson[j]+'</option>';
		}
		
		row += '</select>';
		
        row += '<input type="hidden" id="statusHid'+data[i].id+'" name="statusHid" value="'+data[i].status+'"/>';
        row += '</td>';
        
        row += '<td>';
        if(1 == data[i].status){
        	row += '<input id="displayButton'+data[i].id+'" name="nextButton'+data[i].parentId+'" class="button" value="顯示下一層" onclick="info_list(\''+node+'\',\''+data[i].id+'\',\'Y\');" type="button">';
        }
    	row += '<input id="editButton'+data[i].id+'" name="editButton" class="button" value="修改" onclick="edit_selectList('+data[i].id+');" type="button" style="display : none;"/>';
    	row += '</td>';

		row += '</tr>';
		$('#tblResult'+node).append(row);
	}
	
	if(node == 'ROOT'){
		$('#tblResult'+node).append(
				'<tr id="au'+node+hierarchy+'" name="au'+node+hierarchy+'">' + 
				'<td colspan="7">' +
				'<input type="button" id="addButton'+node+hierarchy+'"  name="addButton'+node+hierarchy+'" value="新增" class="button" onclick="info_new_selectList(\''+node+'\');" />' +
				'</td>' + 
				'</tr>' 
			);
	}else{
		$('#tblResult'+node).append(
				'<tr id="au'+node+hierarchy+'" name="au'+node+hierarchy+'">' + 
				'<td colspan="7" >' +
				'<input type="button" id="addButton'+node+hierarchy+'"  name="addButton'+node+hierarchy+'" value="新增" class="button" onclick="info_new_selectList(\''+node+'\');" />' +
				'<input type="button" id="upperButton'+node+hierarchy+'" name="upperButton'+node+hierarchy+'" value="回上一層" class="button" onclick="upper_selectList('+node+','+hierarchy+');" />' +
				'</td>' + 
				'</tr>' 
			);
	}
	
	$('#tblResult'+node).append(
		'</tbody>' +
		'</table>'
			
	);
	//$(".button").button();
}
//回上一層
function upper_selectList(){
	record.pop();//因為要回上一層，所以把自已這一層的record移除
	//採重新長出資料
	$('#page').empty();
	info_list('', 'ROOT');
	for(i=0; i<record.length-1; i++){
		info_list(record[i], record[i+1]);
	}
}
//點選radio時，關閉上一個radio的修改button
function radio_selectList(radioId){
	//alert('radioClick');
	$("#editButton"+oldRadioId).css('display', 'none');
	//把值復原
	//$("#text"+oldRadioId).val($("#textHid"+oldRadioId).val());
	//$("#val"+oldRadioId).val($("#valHid"+oldRadioId).val());
	//$("#seq"+oldRadioId).val($("#seqHid"+oldRadioId).val());
	//$("#status"+oldRadioId).val($("#statusHid"+oldRadioId).val());
	
	//讓其無法修改 readOnly = true
	//$("#text"+oldRadioId).prop('readonly', true);
	//$("#val"+oldRadioId).prop('readonly', true);
	//$("#seq"+oldRadioId).prop('readonly', true);
	//$("#status"+oldRadioId).prop('readonly', true);
	
	oldRadioId = radioId;
	$("#editButton"+radioId).css('display', '');
	//讓其可以修改readOnly = false
	//$("#text"+radioId).prop('readonly', false);
	//$("#val"+radioId).prop('readonly', false);
	//$("#seq"+radioId).prop('readonly', false);
	//$("#status"+radioId).prop('readonly', false);
	
}

//點選查詢時submit
function query_selectList(){
	$("#serviceId").val("mytstar");
	$("#parentId").val("ROOT");
	$("#statusQuery").val("1,0");
	$("#selectListForm").attr("action", "selectListMtn.action");
	$("#selectListForm").submit();
	
}

//點選新增群組時submit
function group_insert_selectList(){
	var check = '';
	if($.trim($('#selectList_group_dscr').val()) == ''){
		check += '請輸入群組名稱\n';
		alert(check);
		return;
	}

	if(confirm("確定執行新增群組動作?")){
		//note: serviceId, functionId, dscr, 
		//在同一群組都是一樣的，所以 在一開始就已把值帶入
		$('#dscr').val($('#selectList_group_dscr').val());
		$("#currentUser").val($.trim($("#LoginId").text()));
		$("#selectListForm").attr("action", "addGroupSelectList.action");
		$("#selectListForm").submit();
    }
}
//點選新增時，跳出pop視窗
function info_new_selectList(node) {
	$('#pop_message_selectList').dialog('open');
    $('#selectList_parentId').val(idTextMapJson[node]);//帶入parentId 的text，且不可修改
    $('#selectList_parentId').prop('readonly', true);
    $('#selectList_val').val('');
    $('#selectList_text').val('');
    $('#selectList_status').val('');
    $('#selectList_seq').val('');
    $('#parentId').val(node);//要新增的該筆資料，屬於哪一層
}
//點選pop視窗的新增時submit
function info_insert_selectList(){
	
	var check = '';
	if($.trim($('#selectList_text').val()) == ''){
		check += '顯示在網頁上的選項\n';
	}
	if($.trim($('#selectList_val').val()) == ''){
		check += '所代表的值\n';
	}
	if($.trim($('#selectList_seq').val()) == ''){
		check += '順序\n';
	}
	if(check != ''){
		alert(check + '不得為空白');
		return;
	}
	
	if(confirm("確定執行新增動作?")){
		//note: serviceId, functionId, dscr, 
		//在同一群組都是一樣的，所以 在一開始就已把值帶入
		$('#val').val($('#selectList_val').val());
		$('#text').val($('#selectList_text').val());
		$('#status').val($('#selectList_status').val());
		$('#seq').val($('#selectList_seq').val());
		$("#currentUser").val($.trim($("#LoginId").text()));
		$('#clickRecord').val(record);
		$("#selectListForm").attr("action", "addSelectList.action");
		$("#selectListForm").submit();
		
    }
}
//點選修改時submit
function edit_selectList(id){
	
	var check = '';
	if($.trim($('#text'+id).val()) == ''){
		check += '顯示在網頁上的選項(Text)\n';
	}
	if($.trim($('#val'+id).val()) == ''){
		check += '所代表的值(Val)\n';
	}
	if($.trim($('#seq'+id).val()) == ''){
		check += '順序(Seq)\n';
	}
	if(check != ''){
		alert(check + '不得為空白');
		return;
	}
	
	if(confirm("確定執行修改動作?")){
		$('#idNo').val(id);
		$('#val').val($('#val'+id).val());
		$('#text').val($('#text'+id).val());
		$('#status').val($('#status'+id).val());
		$('#seq').val($('#seq'+id).val());
		$("#currentUser").val($.trim($("#LoginId").text()));
		//$('#clickRecord').val(record);
		$('#clickRecord').val(record);
		
		//$("#status").val("1,0");
		
		$("#selectListForm").attr("action", "updateSelectList.action");
		$("#selectListForm").submit();
	}
}
//順序欄位只能輸入數字
function only_number(id){
	$("#seq"+id).val($("#seq"+id).val().replace(/\D|^0/g,''))

	  .bind("paste",function(){  //CTR+V事件处理 
		
		    $("#seq"+id).val($("#seq"+id).val().replace(/\D|^0/g,''));  
		
		}).css("ime-mode", "disabled");  //CSS设置输入法不可用
}
//pop視窗，順序欄位只能輸入數字
function only_number_add(){
	$("#selectList_seq").val($("#selectList_seq").val().replace(/\D|^0/g,''))

	  .bind("paste",function(){  //CTR+V事件处理 
		
		    $("#selectList_seq").val($("#selectList_seq").val().replace(/\D|^0/g,''));  
		
		}).css("ime-mode", "disabled");  //CSS设置输入法不可用
}

</script>

</body>
</html>