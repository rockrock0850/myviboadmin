<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<div>
	<script src="${pageContext.request.contextPath}/js/numeral.js"></script>
	<script src="${pageContext.request.contextPath}/js/tools.js"></script>
	<script>
		logs("Json:" + ${rtnJson});
		var json = jQuery.parseJSON(${rtnJson});
		
		//Tstar
		var monthly_fee1 = "";
		var cal_amount1 = "";
		var project_name1 = "";
		var voice_on_net1 = "";
		var voice_off_net1 = "";
		var voice_local1 = "";
		var period1 = "";
		var voice_onnet_pre_free_min1 = "";
		var voice_onnet_free_min1 = "";
		var voice_offnet_free_min1 = "";
		var voice_local_free_min1 = "";
		var data_free_month1 = "";
		var data_kb1 = "";
		var data_free_mb1 = "";
		var data_max_charge1 = "";
		var sms_on_net1 = "";
		var sms_off_net1 = "";
		var sms_onnet_free_num1 = "";
		var sms_offnet_free_num1 = "";
		
		//comparsion
		var monthly_fee2 = "";
		var cal_amount2 = "";
		var project_name2 = "";
		var voice_on_net2 = "";
		var voice_off_net2 = "";
		var voice_local2 = "";
		var period2 = "";
		var voice_onnet_pre_free_min2 = "";
		var voice_onnet_free_min2 = "";
		var voice_offnet_free_min2 = "";
		var voice_local_free_min2 = "";
		var data_free_month2 = "";
		var data_kb2 = "";
		var data_free_mb2 = "";
		var data_max_charge2 = "";
		var sms_on_net2 = "";
		var sms_off_net2 = "";
		var sms_onnet_free_num2 = "";
		var sms_offnet_free_num2 = "";
		
		var price_tstar = '${priceTstar}';
		var prepayment_amount_tstar = '${prepaymentAmountTstar}';
		var price_choose = '${priceChoose}';
		var prepayment_amount_choose = '${prepaymentAmountChoose}';
		
		$(function() {
			jobjSearch(json);//搜尋json內容塞值
			init();
		});
		function jobjSearch(json){
			try {
				$.each(json, function(key, obj){
//	 				alert(key);
					if(typeof(obj) == "object"){// 找到物件
//	 					alert(obj);
						if(key == "Po_cur_company"){
							if(obj.length >= 1){// 若找到的專案大於一個以上，直接選第一個專案塞值
								var project_tstar = obj;
//	 							alert(project_tstar[0].Project_name);
								monthly_fee1 = project_tstar[0].Monthly_fee;
								cal_amount1 = project_tstar[0].Cal_amout;
								project_name1 = project_tstar[0].Project_name;
								voice_on_net1 = project_tstar[0].Voice_no_net;
								voice_off_net1 = project_tstar[0].Voice_off_net;
								voice_local1 = project_tstar[0].Voice_local; 
								period1 = project_tstar[0].Period;
								voice_onnet_pre_free_min1 = project_tstar[0].Voice_onnet_pre_free_min;
								voice_onnet_free_min1 = project_tstar[0].Voice_onnet_free_min;
								voice_offnet_free_min1 = project_tstar[0].Voice_offnet_free_min;
								voice_local_free_min1 = project_tstar[0].Voice_local_free_min;
								data_free_month1 = project_tstar[0].Data_free_month;
								data_kb1 = project_tstar[0].Data_kb;
								data_free_mb1 = project_tstar[0].Data_free_mb;
								data_max_charge1 = project_tstar[0].Date_max_charge;
								sms_onnet_free_num1 = project_tstar[0].Sms_onnet_free_num;
								sms_offnet_free_num1 = project_tstar[0].Sms_offnet_free_num;
								sms_on_net1 = project_tstar[0].Sms_on_net;	
								sms_off_net1 = project_tstar[0].Sms_off_net;
								return;// 找到底層內容後就return出來不繼續搜尋
							}
						}
						if(key == "Po_cur_competitor"){
							if(obj.length >= 1){// 若找到的專案大於一個以上，直接選第一個專案顯示
								var project_compare = obj;
//	 							alert(project_compare[0].Project_name);
								monthly_fee2 = project_compare[0].Monthly_fee;
								cal_amount2 = project_compare[0].Cal_amout;
								project_name2 = project_compare[0].Project_name;
								voice_on_net2 = project_compare[0].Voice_no_net;
								voice_off_net2 = project_compare[0].Voice_off_net;
								voice_local2 = project_compare[0].Voice_local;
								period2 = project_compare[0].Period;
								voice_onnet_pre_free_min2 = project_compare[0].Voice_onnet_pre_free_min;
								voice_onnet_free_min2 = project_compare[0].Voice_onnet_free_min;
								voice_offnet_free_min2 = project_compare[0].Voice_offnet_free_min;
								voice_local_free_min2 = project_compare[0].Voice_local_free_min;
								data_free_month2 = project_compare[0].Data_free_month;
								data_kb2 = project_compare[0].Data_kb;
								data_free_mb2 = project_compare[0].Data_free_mb;
								data_max_charge2 = project_compare[0].Date_max_charge;
								sms_onnet_free_num2 = project_compare[0].Sms_onnet_free_num;
								sms_offnet_free_num2 = project_compare[0].Sms_offnet_free_num;
								sms_on_net2 = project_compare[0].Sms_on_net;	
								sms_off_net2 = project_compare[0].Sms_off_net;
								return;// 找到底層內容後就return出來不繼續搜尋
							}
						}
						jobjSearch(obj);
					}
				});
			} catch (e) {
				alert(e);
			}
		};
		
		function init() {
			try {
				checkValue($("#avg_amout"), cal_amount2, Math.round(cal_amount2 / period2), "-", "$", "");//平均每月帳單金額
				checkValue($("#monthly_fee"), monthly_fee1, monthly_fee1, "-", "$", "");//推薦您台灣之星最適專案
				
				// Tstar
				if("" != project_name1){
					checkValue($("#project_name1"), project_name1, project_name1, "-", "", "");//專案名稱
					checkValue($("#monthly_fee1"), monthly_fee1, monthly_fee1, "-", "$", "");//月租費
					checkValue($("#avg_amout1"), cal_amount1, Math.round(cal_amount1 / period1), "-", "$", "");//每月帳單金額
					checkValue($("#period1"), period1, period1, "-", "", "");//合約期限
					checkValue($("#total_price1"), cal_amount1, Math.round(cal_amount1), "-", "$", "");//合約期限帳單總金額
					checkValue($("#phone_discount1"), price_tstar, parseInt(price_tstar) - parseInt(prepayment_amount_tstar), "-", "$", "");//台灣之星攜碼手機折扣
					
					if('${applyType}' == "攜碼"){					
						checkValue($("#cell_plus_total1"), price_tstar, parseInt(cal_amount1) + parseInt(price_tstar) + (parseInt(price_tstar) - parseInt(prepayment_amount_tstar)), "-", "$", "");//手機+合約期間帳單總支付金額
						
						var cpt_tstar = parseInt(cal_amount1) + parseInt(price_tstar) + (parseInt(price_tstar) - parseInt(prepayment_amount_tstar));
						var cpt_compare = parseInt(cal_amount2) + parseInt(price_choose) + (parseInt(price_choose) - parseInt(prepayment_amount_choose));
						checkValue($("#total_avg_price1"), cpt_tstar.toString(), cpt_compare - cpt_tstar, "-", "$", "");//共計約省金額
						
						var tap = cpt_compare - cpt_tstar;
						checkValue($("#avg_percent1"), tap.toString(), formatFloat((formatFloat((tap / cpt_compare) * 100, 3)), 2), "-", "", "%");//約省比例

						switch (price_tstar) {//判斷[共計約省]、[共計約省百分比]的計算方式
						case ''://我方沒手機價
							if(price_choose == ''){//兩方都沒有手機價才隱藏專案價欄位
								checkValue($("#cheap_total"), cal_amount2, Math.round(cal_amount2 - cal_amount1), "-", "$", "");//共計約省
								checkValue($("#cheap_percent"), cal_amount2, formatFloat((formatFloat(((cal_amount2 - cal_amount1) / cal_amount2) * 100, 3)), 2), "-", "", "%");//共計約省百分比
								$('#tr_phone_discount').attr('hidden', true);
					 			$('#tr_cell_phone_price').attr('hidden', true);
					 			$('#tr_cell_plus_total').attr('hidden', true);
					 			$('#tr_total_avg_price').attr('hidden', true);
					 			$('#tr_avg_percent').attr('hidden', true);
							}else{
								checkValue($("#cheap_total"), cal_amount2, Math.round(cal_amount2 - cal_amount1), "-", "$", "");//共計約省
								checkValue($("#cheap_percent"), cal_amount2, formatFloat((formatFloat(((cal_amount2 - cal_amount1) / cal_amount2) * 100, 3)), 2), "-", "", "%");//共計約省百分比
							}
							break;

						default://我方有手機價
							if(price_choose == ''){//對方沒手機價
								checkValue($("#cheap_total"), cal_amount2, Math.round(cal_amount2 - cal_amount1), "-", "$", "");//共計約省
								checkValue($("#cheap_percent"), cal_amount2, formatFloat((formatFloat(((cal_amount2 - cal_amount1) / cal_amount2) * 100, 3)), 2), "-", "", "%");//共計約省百分比
							}else{
								checkValue($("#cheap_total"), cpt_tstar.toString(), cpt_compare - cpt_tstar, "-", "$", "");//共計約省
								checkValue($("#cheap_percent"), tap.toString(), formatFloat((formatFloat((tap / cpt_compare) * 100, 3)), 2), "-", "", "%");//共計約省百分比	
							}
							break;
						}
					}else if('${applyType}' == "新用戶"){		
						checkValue($("#cell_plus_total1"), price_tstar, parseInt(cal_amount1) + parseInt(price_tstar), "-", "$", "");//手機+合約期間帳單總支付金額
						
						var cpt_tstar = parseInt(cal_amount1) + parseInt(price_tstar);
						var cpt_compare = parseInt(cal_amount2) + parseInt(price_choose);
						checkValue($("#total_avg_price1"), cpt_tstar.toString(), cpt_compare - cpt_tstar, "-", "$", "");//共計約省金額
						
						var tap = cpt_compare - cpt_tstar;
						checkValue($("#avg_percent1"), tap.toString(), formatFloat((formatFloat((tap / cpt_compare) * 100, 3)), 2), "-", "", "%");//約省比例

						switch (price_tstar) {//判斷[共計約省]、[共計約省百分比]的計算方式
						case ''://我方沒手機價
							if(price_choose == ''){//兩方都沒有手機價才隱藏專案價欄位
								checkValue($("#cheap_total"), cal_amount2, Math.round(cal_amount2 - cal_amount1), "-", "$", "");//共計約省
								checkValue($("#cheap_percent"), cal_amount2, formatFloat((formatFloat((((cal_amount2 - cal_amount1) / cal_amount2)) * 100, 3)), 2), "-", "", "%");//共計約省百分比
					 			$('#tr_cell_phone_price').attr('hidden', true);
					 			$('#tr_cell_plus_total').attr('hidden', true);
					 			$('#tr_total_avg_price').attr('hidden', true);
					 			$('#tr_avg_percent').attr('hidden', true);
							}else{
								checkValue($("#cheap_total"), cal_amount2, Math.round(cal_amount2 - cal_amount1), "-", "$", "");//共計約省
								checkValue($("#cheap_percent"), cal_amount2, formatFloat((formatFloat((((cal_amount2 - cal_amount1) / cal_amount2)) * 100, 3)), 2), "-", "", "%");//共計約省百分比
							}
							break;

						default://我方有手機價
							if(price_choose == ''){//對方沒手機價
								checkValue($("#cheap_total"), cal_amount2, Math.round(cal_amount2 - cal_amount1), "-", "$", "");//共計約省
								checkValue($("#cheap_percent"), cal_amount2, formatFloat((formatFloat((((cal_amount2 - cal_amount1) / cal_amount2)) * 100, 3)), 2), "-", "", "%");//共計約省百分比
							}else{
								checkValue($("#cheap_total"), cpt_tstar.toString(), cpt_compare - cpt_tstar, "-", "$", "");//共計約省
								checkValue($("#cheap_percent"), tap.toString(), formatFloat((formatFloat((tap / cpt_compare) * 100, 3)), 2), "-", "", "%");//共計約省百分比	
							}
							break;
						}
					}else{
						alert("applyType:" + '${applyType}');
					}
					
					checkValue($("#data_kb1"), data_kb1, data_kb1, "-", "", "");//上網費率
					
					var str = "";					
					//上網優惠
					if(null != data_free_month1 & null != period1){
						if(parseInt(data_free_month1) >= parseInt(period1)){
							str = "吃到飽";
						}else{
							str = str + checkFreeContent(data_free_month1, "上網前", "個月免費");
							str = str + converterFreeContent(parseInt(data_free_mb1), 'mb', 'gb', 1024);
							str = str + checkFreeContent(data_max_charge1, "上網收費上限", "元");
						}
					}
					checkValue($("#data_free_content1"), str, str, "-", "", "");
					str = "";
					//語音優惠
					str = str + checkFreeContent(voice_onnet_pre_free_min1, "網內前", "分鐘免費");
					str = str + checkFreeContent(voice_onnet_free_min1, "網內語音贈送", "分鐘");
					str = str + checkFreeContent(voice_offnet_free_min1, "網外語音贈送", "分鐘");
					str = str + checkFreeContent(voice_local_free_min1, "市話贈送", "分鐘");
					checkValue($("#voice_free_content1"), str, str, "-", "", "");
					str = "";
					//簡訊優惠
					str = str + checkFreeContent(sms_onnet_free_num1, "網內送", "則");
					str = str + checkFreeContent(sms_offnet_free_num1, "網外送", "則");
					checkValue($("#sms_free_content1"), str, str, "-", "", "");
					
					checkValue($("#voice_on_net1"), voice_on_net1, voice_on_net1, "-", "", "");//網內語音
					checkValue($("#voice_off_net1"), voice_off_net1, voice_off_net1, "-", "", "");//網外語音
					checkValue($("#voice_local1"), voice_local1, voice_local1, "-", "", "");//市話
					checkValue($("#sms_on_net1"), sms_on_net1, sms_on_net1, "-", "", "");//網內簡訊
					checkValue($("#sms_off_net1"), sms_off_net1, sms_off_net1, "-", "", "");//網外簡訊				
				}else{
		 			$('#no_fee_tstar').attr('rowspan', $('tr').size() - 1);
				}
				
				// Compare
				if("" != project_name2){
					checkValue($("#project_name2"), project_name2, project_name2, "-", "", "");//專案名稱
					checkValue($("#monthly_fee2"), monthly_fee2, monthly_fee2, "-", "$", "");//月租費
					checkValue($("#avg_amout2"), cal_amount2, Math.round(cal_amount2 / period2), "-", "$", "");//每月帳單金額
					checkValue($("#period2"), period2, period2, "-", "", "");//合約期限
					checkValue($("#total_price2"), cal_amount2, Math.round(cal_amount2), "-", "$", "");//合約期限帳單總金額
					checkValue($("#phone_discount2"), '', parseInt(price_choose) - parseInt(prepayment_amount_choose), "-", "$", "");//對方攜碼手機折扣
					
					if('${applyType}' == "攜碼"){
						checkValue($("#cell_plus_total2"), price_choose, parseInt(cal_amount2) + parseInt(price_choose) + (parseInt(price_choose) - parseInt(prepayment_amount_choose)), "-", "$", "");//手機+合約期間帳單總支付金額
					}else if('${applyType}' == "新用戶"){
						checkValue($("#cell_plus_total2"), price_choose, parseInt(cal_amount2) + parseInt(price_choose), "-", "$", "");//手機+合約期間帳單總支付金額
					}else{
						alert("applyType:" + '${applyType}');
					}
					
					checkValue($("#data_kb2"), data_kb2, data_kb2, "-", "", "");//上網費率
					
					var str = "";					
					//上網優惠
					if(null != data_free_month2 & null != period2){
						if(parseInt(data_free_month2) >= parseInt(period2)){
							str = "吃到飽";
						}else{
							str = str + checkFreeContent(data_free_month2, "上網前", "個月免費");
							str = str + converterFreeContent(parseInt(data_free_mb2), 'mb', 'gb', 1024);
							str = str + checkFreeContent(data_max_charge2, "上網收費上限", "元");
						}
					}
					checkValue($("#data_free_content2"), str, str, "-", "", "");
					str = "";
					//語音優惠
					str = str + checkFreeContent(voice_onnet_pre_free_min2, "網內前", "分鐘免費");
					str = str + checkFreeContent(voice_onnet_free_min2, "網內語音贈送", "分鐘");
					str = str + checkFreeContent(voice_offnet_free_min2, "網外語音贈送", "分鐘");
					str = str + checkFreeContent(voice_local_free_min2, "市話贈送", "分鐘");
					checkValue($("#voice_free_content2"), str, str, "-", "", "");
					str = "";
					//簡訊優惠
					str = str + checkFreeContent(sms_onnet_free_num2, "網內送", "則");
					str = str + checkFreeContent(sms_offnet_free_num2, "網外送", "則");
					checkValue($("#sms_free_content2"), str, str, "-", "", "");
					
					checkValue($("#voice_on_net2"), voice_on_net2, voice_on_net2, "-", "", "");//網內語音
					checkValue($("#voice_off_net2"), voice_off_net2, voice_off_net2, "-", "", "");//網外語音
					checkValue($("#voice_local2"), voice_local2, voice_local2, "-", "", "");//市話
					checkValue($("#sms_on_net2"), sms_on_net2, sms_on_net2, "-", "", "");//網內簡訊
					checkValue($("#sms_off_net2"), sms_off_net2, sms_off_net2, "-", "", "");//網外簡訊	
				}else{
		 			$('#no_fee_compare').attr('rowspan', $('tr').size() - 1);
				}	
			} catch (e) {
				alert(e);
			}
		};

		//首頁佔存狀態賦值與轉送
		function submitBackForm(){
			var tmp_cal_rule = '${tmp.cal_rule}';
			var tmp_apply_type = '${tmp.apply_type}';
			var tmp_company_sel = '${tmp.op_id}';
			var tmp_fee_type = '${tmp.fee_type}';
			var tmp_fee_range = '${tmp.fee_range}';
			var tmp_fee_sel = '${tmp.fee_sel}';
			var tmp_period = '${tmp.period}';
			var tmp_project_code = '${tmp.project_code}';
			var tmp_voice_on_net = '${tmp.voice_on_net}';
			var tmp_voice_off_net = '${tmp.voice_off_net}';
			var tmp_pstn = '${tmp.pstn}';
			var tmp_data_usage = '${tmp.data_usage}';
			var tmp_sms_on_net = '${tmp.sms_on_net}';
			var tmp_sms_off_net = '${tmp.sms_off_net}';
			var tmp_phone_code = '${tmp.phone_code}';
			
			$('#tmp_calRule').attr('value', tmp_cal_rule);
			$('#tmp_applyTye').attr('value', tmp_apply_type);
			$('#tmp_companySel').attr('value', tmp_company_sel);
			$('#tmp_feeType').attr('value', tmp_fee_type);
			$('#tmp_feeRange').attr('value', tmp_fee_range);
			$('#tmp_feeSel').attr('value', tmp_fee_sel);
			$('#tmp_period').attr('value', tmp_period);
			$('#tmp_projectCode').attr('value', tmp_project_code);
			$('#tmp_voiceOnNet').attr('value', tmp_voice_on_net);
			$('#tmp_voiceOffNet').attr('value', tmp_voice_off_net);
			$('#tmp_pstn').attr('value', tmp_pstn);
			$('#tmp_dataUsage').attr('value', tmp_data_usage);
			$('#tmp_smsOnNet').attr('value', tmp_sms_on_net);
			$('#tmp_smsOffNet').attr('value', tmp_sms_off_net);
			$('#tmp_phoneCode').attr('value', tmp_phone_code);
			$('#back_form').submit();
		};
	</script>
	<div class="n_sec_content">
		<div class="n_result">
			<div class="n_result_item">每月平均每月帳單金額:
				<span id="avg_amout" class="n_light_purple"></span>
			</div>
			<div class="n_result_item">推薦您台灣之星最適專案:
				<c:if test='${not empty proJsonTstar.getCompany()}'>
					<span id="monthly_fee" class="n_light_purple"></span>
				</c:if>
				<c:if test='${empty proJsonTstar.getCompany()}'>
					<span class="n_light_purple">-</span>
				</c:if>
			</div>
			<div class="n_result_item">
				<c:if test='${not empty chooseDeviceName}'>
					<span>搭配</span>
				</c:if>
				<c:if test='${not empty chooseDeviceName}'>
					<span class="n_light_purple">${chooseDeviceName}</span>
				</c:if>
				約期內較其他業者共計約省
				<c:if test='${cal_amount1 != "" || cal_amount2 != ""}'>
					<span id="cheap_total" class="n_light_purple"></span>
				</c:if>
				元(約省
				<c:if test='${cal_amount1 != "" || cal_amount2 != ""}'>
					<span id="cheap_percent" class="n_light_purple"></span>
				</c:if>
				)
			</div>
		</div>
		<table class="filtered_table">
			<tr>
				<th align="center">電信業者</th>
				<c:if test="${empty proJsonTstar.getCompany()}">
					<td align="center">台灣之星</td>
				</c:if>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
					<td align="center">${proJsonTstar.getCompany()}</td>
				</c:if>
				<c:if test='${empty proJsonCompare.getCompany()}'>
					<td align="center">${company}</td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
					<td align="center">${proJsonCompare.getCompany()}</td>
				</c:if>
			</tr>
			<tr>
				<th align="center">專案名稱</th>
				<c:if test='${empty proJsonTstar.getCompany()}'>
					<td id="no_fee_tstar">目前無此資費</td>
				</c:if>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
					<td align="center">${proJsonTstar.getProject_name()}</td>
				</c:if>
				<c:if test='${empty proJsonCompare.getCompany()}'>
					<td id="no_fee_compare">目前無此資費</td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
					<td align="center">${proJsonCompare.getProject_name()}</td>
				</c:if>
			</tr>
			<tr>
				<th align="center">月租費</th>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
					<td id="monthly_fee1" align="center"></td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
					<td id="monthly_fee2" align="center"></td>
				</c:if>
			</tr>
			<tr>
				<th>每月帳單金額(月租+超額使用費)</th>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
					<td id="avg_amout1" align="center"></td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
					<td id="avg_amout2" align="center"></td>
				</c:if>
			</tr>
			<tr >
				<th align="center">合約期限(月)</th>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
				<td id="period1" align="center"></td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
				<td id="period2" align="center"></td>
				</c:if>
			</tr>
			<tr>
				<th align="center">合約期限<br/>總帳單金額</th>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
					<td id="total_price1" align="center"></td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
					<td id="total_price2" align="center"></td>
				</c:if>
			</tr>
			<c:forEach items="${ProjectDeviceDtoOrder}" var="project">
			    <tr id="tr_cell_phone_price">
					<th align="center">${project.projectName}<br/>專案價</th>
					<c:if test='${not empty proJsonTstar.getProject_name()}'>
						<c:if test="${not empty project.priceTstar}">
							<c:if test="${applyType == '新用戶'}">
								<td align="center">$<fmt:formatNumber type="currency" currencySymbol="$" pattern="#,##0;" value="${project.priceTstar}" /></td>
							</c:if>
							<c:if test="${applyType  == '攜碼'}">
								<td align="center">$<fmt:formatNumber type="currency" currencySymbol="$" pattern="#,##0;" value="${project.prepaymentAmountTstar}" /></td>
							</c:if>
						</c:if>
						<c:if test="${empty project.priceTstar}">
							<td align="center">-</td>
						</c:if>
					</c:if>
					<c:if test='${not empty proJsonCompare.getProject_name()}'>
						<c:if test="${not empty project.priceChosen}">
							<td align="center">$<fmt:formatNumber type="currency" currencySymbol="$" pattern="#,##0;" value="${project.priceChosen}" /></td>
						</c:if>
						<c:if test="${empty project.priceChosen}">
							<td align="center">-</td>
						</c:if>
					</c:if>
				</tr>
			</c:forEach>
			<c:if test="${applyType  == '攜碼'}">
				<tr id="tr_phone_discount">
					<th align="center">攜碼手機折扣</th>
					<c:if test='${not empty proJsonTstar.getCompany()}'>
						<td id="phone_discount1" align="center"></td>
					</c:if>
					<c:if test='${not empty proJsonCompare.getCompany()}'>
						<td id="phone_discount2" align="center"></td>
					</c:if>
				</tr>
			</c:if>
			<tr id="tr_cell_plus_total">
				<th align="center">手機 + 合約期間帳單總支付金額</th>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
					<td id="cell_plus_total1" align="center"></td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
					<td id="cell_plus_total2" align="center"></td>
				</c:if>
			</tr>
			<tr id="tr_total_avg_price">
				<th align="center">共計約省金額</th>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
					<td id="total_avg_price1" align="center"></td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
					<td id="total_avg_price2" align="center">-</td>
				</c:if>
			</tr>
			<tr id="tr_avg_percent">
				<th align="center">約省比例</th>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
					<td id="avg_percent1" align="center"></td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
					<td id="avg_percent2" align="center">-</td>
				</c:if>
			</tr>
			<tr>
				<th align="center">上網優惠</th>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
					<td id="data_free_content1" align="center"></td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
					<td id="data_free_content2" align="center"></td>
				</c:if>
			</tr>
			<tr>
				<th align="center">語音優惠</th>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
					<td id="voice_free_content1" align="center"></td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
					<td id="voice_free_content2" align="center"></td>
				</c:if>
			</tr>
			<tr>
				<th align="center">簡訊優惠</th>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
					<td id="sms_free_content1" align="center"></td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
					<td id="sms_free_content2" align="center"></td>
				</c:if>
			</tr>
			<tr>
				<th align="center">上網費率(元/KB)</th>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
					<td id="data_kb1" align="center"></td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
					<td id="data_kb2" align="center"></td>
				</c:if>
			</tr>
			<tr >
				<th align="center">網內語音(元/秒)</th>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
				<td id="voice_on_net1" align="center"></td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
				<td id="voice_on_net2" align="center"></td>
				</c:if>
			</tr>
			<tr >
				<th align="center">網外語音(元/秒)</th>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
				<td id="voice_off_net1" align="center"></td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
				<td id="voice_off_net2" align="center"></td>
				</c:if>
			</tr>
			<tr >
				<th align="center">市話(元/秒)</th>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
				<td id="voice_local1" align="center"></td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
				<td id="voice_local2" align="center"></td>
				</c:if>
			</tr>
			<tr >
				<th align="center">網內簡訊(元/則)</th>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
				<td id="sms_on_net1" align="center"></td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
				<td id="sms_on_net2" align="center"></td>
				</c:if>
			</tr>
			<tr >
				<th align="center">網外簡訊(元/則)</th>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
				<td id="sms_off_net1" align="center"></td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
				<td id="sms_off_net2" align="center"></td>
				</c:if>
			</tr>
		</table>
		<div>
			<font style='color:red; font-size:10px'>${protectWord}</font>
		</div>
		<div>
			<form id="back_form" hidden="true" action="comparsion.action" method="post">
				<input id="tmp_calRule" name="tmp.cal_rule">
				<input id="tmp_applyTye" name="tmp.apply_type">
				<input id="tmp_companySel" name="tmp.op_id">
				<input id="tmp_feeType" name="tmp.fee_type">
				<input id="tmp_feeRange" name="tmp.fee_range">
				<input id="tmp_feeSel" name="tmp.fee_sel">
				<input id="tmp_period" name="tmp.period">
				<input id="tmp_projectCode" name="tmp.project_code">
				<input id="tmp_voiceOnNet" name="tmp.voice_on_net">
				<input id="tmp_voiceOffNet" name="tmp.voice_off_net">
				<input id="tmp_pstn" name="tmp.pstn">
				<input id="tmp_dataUsage" name="tmp.data_usage">
				<input id="tmp_smsOnNet" name="tmp.sms_on_net">
				<input id="tmp_smsOffNet" name="tmp.sms_off_net">
				<input id="tmp_phoneCode" name="tmp.phone_code">
			</form>
		</div>
		<div class="apply_plan">
			<input class="submit" type="button" onclick='submitBackForm()' value="再算一次">
			<a class="submit" href="reservation.action" onclick="ga('send', 'event', '資費試算', '我要預約');false">我要預約</a>
		</div>
	</div>
</div>