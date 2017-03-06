<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<%@ taglib prefix="s" uri="/struts-tags"%>


<div>
	<script src="${pageContext.request.contextPath}/js/numeral.js"></script>
	<script src="${pageContext.request.contextPath}/js/tools.js"></script>
	<script>
		var json = jQuery.parseJSON(${rtnJson});
			
		//Tstar
		var monthly_fee1;
		var cal_amount1;
		var project_name1;
		var voice_on_net1;
		var voice_off_net1;
		var voice_local1;
		var period1;
		var voice_onnet_pre_free_min1;
		var voice_onnet_free_min1;
		var voice_offnet_free_min1;
		var voice_local_free_min1;
		var voice_onnet_free_mny1;;
		var voice_offnet_free_mny1;
		var pstn_free_mny1;
		var data_free_month1;
		var data_kb1;
		var data_free_mb1;
		var data_max_charge1;
		var sms_on_net1;
		var sms_off_net1;
		var sms_onnet_free_num1;
		var sms_offnet_free_num1;
		
		//singlePhone
		var monthly_fee2;
		var cal_amount2;
		var project_name2;
		var voice_on_net2;
		var voice_off_net2;
		var voice_local2;
		var period2;
		var voice_onnet_pre_free_min2;
		var voice_onnet_free_min2;
		var voice_offnet_free_min2;
		var voice_local_free_min2;
		var voice_onnet_free_mny2;
		var voice_offnet_free_mny2;
		var pstn_free_mny2;
		var data_free_month2;
		var data_kb2;
		var data_free_mb2;
		var data_max_charge2;
		var sms_on_net2;
		var sms_off_net2;
		var sms_onnet_free_num2;
		var sms_offnet_free_num2;		
		
		var price_tstar = '${priceTstar}';
		var prepayment_amount_tstar = '${prepaymentAmountTstar}';
		var single_phone_tstar = '${singlePhoneTstar}';
		var single_phone_chosen = '${singlePhoneChosen}';

		jQuery(function() {
			jobjSearch(json);
			init();
		});

		function jobjSearch(json){
			$.each(json, function(key, obj){
// 				alert(key);
				if(typeof(obj) == "object"){// 找到物件
// 					alert(obj);
					if(key == "Po_cur_company"){
// 						alert(key);
						var project_tstar = obj;
						if(obj.length == 1){// 若找到的專案大於一個以上，直接選第一個專案塞值
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
							voice_onnet_free_mny1 = project_tstar[0].Voice_onnet_free_mny;
							voice_offnet_free_mny1 = project_tstar[0].Voice_offnet_free_mny;
							pstn_free_mny1 = project_tstar[0].Pstn_free_mny;
							data_free_month1 = project_tstar[0].Data_free_month;
							data_kb1 = project_tstar[0].Data_kb;
							data_free_mb1 = project_tstar[0].Data_free_mb;
							data_max_charge1 = project_tstar[0].Date_max_charge;
							sms_onnet_free_num1 = project_tstar[0].Sms_onnet_free_num;
							sms_offnet_free_num1 = project_tstar[0].Sms_offnet_free_num;
							sms_on_net1 = project_tstar[0].Sms_on_net;	
							sms_off_net1 = project_tstar[0].Sms_off_net;
						}else if(obj.length == 2){
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
							voice_onnet_free_mny1 = project_tstar[0].Voice_onnet_free_mny;
							voice_offnet_free_mny1 = project_tstar[0].Voice_offnet_free_mny;
							pstn_free_mny1 = project_tstar[0].Pstn_free_mny;
							data_free_month1 = project_tstar[0].Data_free_month;
							data_kb1 = project_tstar[0].Data_kb;
							data_free_mb1 = project_tstar[0].Data_free_mb;
							data_max_charge1 = project_tstar[0].Date_max_charge;
							sms_onnet_free_num1 = project_tstar[0].Sms_onnet_free_num;
							sms_offnet_free_num1 = project_tstar[0].Sms_offnet_free_num;
							sms_on_net1 = project_tstar[0].Sms_on_net;	
							sms_off_net1 = project_tstar[0].Sms_off_net;

							monthly_fee2 = project_tstar[1].Monthly_fee;
							cal_amount2 = project_tstar[1].Cal_amout;
							project_name2 = project_tstar[1].Project_name;
							voice_on_net2 = project_tstar[1].Voice_no_net;
							voice_off_net2 = project_tstar[1].Voice_off_net;
							voice_local2 = project_tstar[1].Voice_local; 
							period2 = project_tstar[1].Period;
							voice_onnet_pre_free_min2 = project_tstar[1].Voice_onnet_pre_free_min;
							voice_onnet_free_min2 = project_tstar[1].Voice_onnet_free_min;
							voice_offnet_free_min2 = project_tstar[1].Voice_offnet_free_min;
							voice_local_free_min2 = project_tstar[1].Voice_local_free_min;
							voice_onnet_free_mny2 = project_tstar[1].Voice_onnet_free_mny;
							voice_offnet_free_mny2 = project_tstar[1].Voice_offnet_free_mny;
							pstn_free_mny2 = project_tstar[1].Pstn_free_mny;
							data_free_month2 = project_tstar[1].Data_free_month;
							data_kb2 = project_tstar[1].Data_kb;
							data_free_mb2 = project_tstar[1].Data_free_mb;
							data_max_charge2 = project_tstar[1].Date_max_charge;
							sms_onnet_free_num2 = project_tstar[1].Sms_onnet_free_num;
							sms_offnet_free_num2 = project_tstar[1].Sms_offnet_free_num;
							sms_on_net2 = project_tstar[1].Sms_on_net;	
							sms_off_net2 = project_tstar[1].Sms_off_net;
						}
						return;
					}
					jobjSearch(obj);
				}
			});
		};
		
		function init(){
			try {
				//Tstar
				monthly_fee1 = numFactory(monthly_fee1, true, false);
				cal_amount1 = numFactory(cal_amount1, true, true);
				project_name1 = numFactory(project_name1, false, false);
				voice_on_net1 = numFactory(voice_on_net1, false, false);
				voice_off_net1 = numFactory(voice_off_net1, false, false);
				voice_local1 = numFactory(voice_local1, false, false);
				period1 = numFactory(period1, false, false);
				voice_onnet_pre_free_min1 = numFactory(voice_onnet_pre_free_min1, false, false);
				voice_onnet_free_min1 = numFactory(voice_onnet_free_min1, false, false);
				voice_offnet_free_min1 = numFactory(voice_offnet_free_min1, false, false);
				voice_local_free_min1 = numFactory(voice_local_free_min1, false, false);
				voice_onnet_free_mny1 = numFactory(voice_onnet_free_mny1, false, false);
				voice_offnet_free_mny1 = numFactory(voice_offnet_free_mny1, false, false);
				pstn_free_mny1 = numFactory(pstn_free_mny1, false, false);
				data_free_month1 = numFactory(data_free_month1, false, false);
				data_kb1 = numFactory(data_kb1, false, false);
				data_free_mb1 = numFactory(data_free_mb1, false, false);
				data_max_charge1 = numFactory(data_max_charge1, false, false);
				sms_on_net1 = numFactory(sms_on_net1, false, false);
				sms_off_net1 = numFactory(sms_off_net1, false, false);
				sms_onnet_free_num1 = numFactory(sms_onnet_free_num1, false, false);
				sms_offnet_free_num1 = numFactory(sms_offnet_free_num1, false, false);
				
				//SinglePhone
				monthly_fee2 = numFactory(monthly_fee2, true, false);
				cal_amount2 = numFactory(cal_amount2, true, true);
				project_name2 = numFactory(project_name2, false, false);
				voice_on_net2 = numFactory(voice_on_net2, false, false);
				voice_off_net2 = numFactory(voice_off_net2, false, false);
				voice_local2 = numFactory(voice_local2, false, false);
				period2 = numFactory(period2, false, false);
				voice_onnet_pre_free_min2 = numFactory(voice_onnet_pre_free_min2, false, false);
				voice_onnet_free_min2 = numFactory(voice_onnet_free_min2, false, false);
				voice_offnet_free_min2 = numFactory(voice_offnet_free_min2, false, false);
				voice_local_free_min2 = numFactory(voice_local_free_min2, false, false);
				voice_onnet_free_mny2 = numFactory(voice_onnet_free_mny2, false, false);
				voice_offnet_free_mny2 = numFactory(voice_offnet_free_mny2, false, false);
				pstn_free_mny2 = numFactory(pstn_free_mny2, false, false);
				data_free_month2 = numFactory(data_free_month2, false, false);
				data_kb2 = numFactory(data_kb2, false, false);
				data_free_mb2 = numFactory(data_free_mb2, false, false);
				data_max_charge2 = numFactory(data_max_charge2, false, false);
				sms_on_net2 = numFactory(sms_on_net2, false, false);
				sms_off_net2 = numFactory(sms_off_net2, false, false);
				sms_onnet_free_num2 = numFactory(sms_onnet_free_num2, false, false);
				sms_offnet_free_num2 = numFactory(sms_offnet_free_num2, false, false);

				//Phone price
				price_tstar = numFactory(price_tstar, true, true);
				prepayment_amount_tstar = numFactory(prepayment_amount_tstar, true, true);
				single_phone_tstar = numFactory(single_phone_tstar, true, true);
				single_phone_chosen = numFactory(single_phone_chosen, true, true);

				checkValue($("#avg_amout_compare"), cal_amount2, (cal_amount2 / period2), "-", "$", "");//手機專案平均每月帳單金額
				checkValue($("#avg_amout"), cal_amount1, (cal_amount1 / period1), "-", "$", "");//單門號每月帳單金額
				//推薦您台灣之星最適專案	
				checkValue($("#single"), monthly_fee1, monthly_fee1, "-", "$", "");	
				checkValue($("#project"), monthly_fee2, monthly_fee1, "-", "$", "");				
				// Tstar
				if("" != '${proJsonTstar.getProject_name()}'){
					checkValue($("#project_name1"), project_name1, project_name1, "-", "", "");//專案名稱
					checkValue($("#monthly_fee1"), monthly_fee1.toString(), monthly_fee1, "-", "$", "");//月租費
					checkValue($("#avg_amout1"), cal_amount1.toString(), (cal_amount1 / period1), "-", "$", "");//每月帳單金額
					checkValue($("#period1"), period1.toString(), period1, "-", "", "");//合約期限
					checkValue($("#total_price1"), cal_amount1.toString(), cal_amount1, "-", "$", "");//合約期限帳單總金額
					checkValue($("#phone_discount1"), single_phone_tstar.toString(), single_phone_tstar - prepayment_amount_tstar, "-", "$", "");//台灣之星攜碼手機折扣
					checkValue($("#cell_plus_total1"), single_phone_tstar.toString(), cal_amount1 + single_phone_tstar, "-", "$", "");//手機+合約期間帳單總支付金額
					checkValue($("#data_kb1"), data_kb1.toString(), data_kb1, "-", "", "");//上網費率

					var cpt_tstar = cal_amount1 + single_phone_tstar;
					var cpt_compare = cal_amount2 + price_tstar;
					checkValue($("#total_avg_price1"), cpt_tstar.toString(), cpt_compare - cpt_tstar, "-", "$", "");//共計約省金額
					
					var tap = cpt_compare - cpt_tstar;
					checkValue($("#avg_percent1"), tap.toString(), Math.round((formatFloat((tap / cpt_compare) * 100, 3)), 2), "-", "", "%");//約省比例

					logs('single_phone_tstar:' + single_phone_tstar);
					logs('price_tstar:' + price_tstar);

//			 		結果金額 < 0不顯示
					switch (single_phone_tstar) {//判斷[共計約省]、[共計約省百分比]的計算方式
					case ''://空機沒手機(手機='')
						switch (price_tstar) {
						case ''://專案沒手機(手機='')
							checkValue($("#cheap_total"), cal_amount2.toString(), cal_amount2 - cal_amount1, "-", "$", "");//共計約省
							checkValue($("#cheap_percent"), cal_amount2.toString(), Math.round((formatFloat(((cal_amount2 - cal_amount1) / cal_amount2) * 100, 3))), "-", "", "%");//共計約省百分比
							$("#tr_cell_phone_price").attr('hidden', true);
							ifPhoneIsNULLThenHidden();
							break;

						default://專案有手機價
							checkValue($("#cheap_total"), cal_amount2.toString(), cal_amount2 - cal_amount1, "-", "$", "");//共計約省
							checkValue($("#cheap_percent"), cal_amount2.toString(), Math.round((formatFloat(((cal_amount2 - cal_amount1) / cal_amount2) * 100, 3))), "-", "", "%");//共計約省百分比
							ifPhoneIsNULLThenHidden();
							break;
						}
						if((cal_amount2 - cal_amount1) < 0){
							$("#hidn_device_total_percent").attr('hidden', true);
						}	
						break;

					default://空機有手機價
						switch (price_tstar) {
						case ''://專案沒手機(手機='')
							checkValue($("#cheap_total"), cal_amount2.toString(), cal_amount2 - cal_amount1, "-", "$", "");//共計約省
							checkValue($("#cheap_percent"), cal_amount2.toString(), Math.round((formatFloat(((cal_amount2 - cal_amount1) / cal_amount2) * 100, 3))), "-", "", "%");//共計約省百分比
							ifPhoneIsNULLThenHidden();
							if((cal_amount2 - cal_amount1) < 0){
								$("#hidn_device_total_percent").attr('hidden', true);
							}	
							break;

						default://兩邊都有手機價
							checkValue($("#cheap_total"), cpt_tstar.toString(), cpt_compare - cpt_tstar, "-", "$", "");//共計約省
							checkValue($("#cheap_percent"), tap.toString(), Math.round((formatFloat((tap / cpt_compare) * 100, 3))), "-", "", "%");//共計約省百分比
							//
							if(tap < 0){
								$("#hidn_device_total_percent").attr('hidden', true);
							}	
							break;
						}
						break;
					}

					//上網優惠
					var str = "";
					if(null != data_free_month2 & null != period2){
						if(data_free_month1 >= period1 || data_kb1 == -1){
							str = "吃到飽";
						}else{
							str = str + checkFreeContent(data_free_month1.toString(), "上網前", "個月免費");
							str = str + converterFreeContent(data_free_mb1.toString(), 'mb', 'gb', 1024);
							str = str + checkFreeContent(data_max_charge1.toString(), "上網收費上限", "元");
						}
					}
					checkValue($("#data_free_content1"), str, str, "-", "", "");

					checkValue($("#voice_on_net1"), voice_on_net1.toString(), voice_on_net1, "-", "", "");//網內語音
					checkValue($("#voice_off_net1"), voice_off_net1.toString(), voice_off_net1, "-", "", "");//網外語音
					checkValue($("#voice_local1"), voice_local1.toString(), voice_local1, "-", "", "");//市話

					//網內簡訊
					if(sms_on_net1 == -1){
						sms_on_net1 = '網內簡訊免費';
					}
					checkValue($("#sms_on_net1"), sms_on_net1.toString(), sms_on_net1, "-", "", "");

					//網外簡訊
					if(sms_off_net1 == -1){
						sms_off_net1 = '網外簡訊免費';
					}
					checkValue($("#sms_off_net1"), sms_off_net1.toString(), sms_off_net1, "-", "", "");

					//語音優惠
					str = "";
					if(voice_on_net1 == -1){
						str = str + '網內語音免費</br>'
					}
					str = str + checkFreeContent(voice_onnet_pre_free_min1.toString(), "網內前", "分鐘免費");
					str = str + checkFreeContent(voice_onnet_free_min1.toString(), "網內語音贈送", "分鐘");
					str = str + checkFreeContent(voice_offnet_free_min1.toString(), "網外語音贈送", "分鐘");
					str = str + checkFreeContent(voice_local_free_min1.toString(), "市話贈送", "分鐘");
					str = str + checkFreeContent(voice_onnet_free_mny1.toString(), "送網內通話費$", "元");
					str = str + checkFreeContent(voice_offnet_free_mny1.toString(), "送網外通話費$", "元");
					str = str + checkFreeContent(pstn_free_mny1.toString(), "送市話通話費$", "元");
					checkValue($("#voice_free_content1"), str, str, "-", "", "");

					//簡訊優惠
					str = "";
					str = str + checkFreeContent(sms_onnet_free_num1.toString(), "網內送", "則");
					str = str + checkFreeContent(sms_offnet_free_num1.toString(), "網外送", "則");
					checkValue($("#sms_free_content1"), str, str, "-", "", "");
				}else{
		 			ifPhoneIsNULLThenHidden();
					checkValue($("#avg_amout_compare"), '', '', "-", "$", "");//目前使用平均每月帳單金額
					checkValue($("#avg_amout"), '', '', "-", "$", "");//單門號每月帳單金額
					checkValue($("#cheap_total"), '', '', "-", "$", "");//共計約省
					checkValue($("#cheap_percent"), '', '', "-", "", "%");//共計約省百分比
		 			$('#no_fee_tstar1').attr('rowspan', (Math.round(($('tr').size()/2))-1)-$('tr:hidden').size());
		 			$('#no_fee_tstar2').attr('rowspan', (Math.round($('tr').size()/2))-1);
				}
				
				// SinglePhoneTstar
				if("" != '${proJsonTstar.getSingle_project_name()}'){
					checkValue($("#project_name2"), project_name2.toString(), project_name2, "-", "", "");//專案名稱
					checkValue($("#monthly_fee2"), monthly_fee2.toString(), monthly_fee2, "-", "$", "");//月租費
					checkValue($("#avg_amout2"), cal_amount2.toString(), cal_amount2 / period2, "-", "$", "");//每月帳單金額
					checkValue($("#period2"), period2.toString(), period2, "-", "", "");//合約期限
					checkValue($("#total_price2"), cal_amount2.toString(), cal_amount2, "-", "$", "");//合約期限帳單總金額
					checkValue($("#phone_discount2"), price_tstar.toString(), price_tstar - single_phone_chosen, "-", "$", "");//對方攜碼手機折扣
					checkValue($("#cell_plus_total2"), price_tstar.toString(), cal_amount2 + price_tstar, "-", "$", "");//手機+合約期間帳單總支付金額
					checkValue($("#data_kb2"), data_kb2.toString(), data_kb2, "-", "", "");//上網費率
					
					//上網優惠
					var str = "";
					if(null != data_free_month2 & null != period2){
						if(data_free_month2 >= period2 || data_kb2 == -1){
							str = "吃到飽";
						}else{
							str = str + checkFreeContent(data_free_month2.toString(), "上網前", "個月免費");
							str = str + converterFreeContent(data_free_mb2.toString(), 'mb', 'gb', 1024);
							str = str + checkFreeContent(data_max_charge2.toString(), "上網收費上限", "元");
						}
					}
					checkValue($("#data_free_content2"), str, str, "-", "", "");

					checkValue($("#voice_on_net2"), voice_on_net2.toString(), voice_on_net2, "-", "", "");//網內語音
					checkValue($("#voice_off_net2"), voice_off_net2.toString(), voice_off_net2, "-", "", "");//網外語音
					checkValue($("#voice_local2"), voice_local2.toString(), voice_local2, "-", "", "");//市話

					//網內簡訊
					if(sms_on_net2 == -1){
						sms_on_net2 = '網內簡訊免費';
					}
					checkValue($("#sms_on_net2"), sms_on_net2.toString(), sms_on_net2, "-", "", "");

					//網外簡訊
					if(sms_off_net2 == -1){
						sms_off_net2 = '網外簡訊免費';
					}
					checkValue($("#sms_off_net2"), sms_off_net2.toString(), sms_off_net2, "-", "", "");	

					//語音優惠
					str = "";
					if(voice_on_net2 == -1){
						str = str + '網內語音免費</br>'
					}
					str = str + checkFreeContent(voice_onnet_pre_free_min2.toString(), "網內前", "分鐘免費");
					str = str + checkFreeContent(voice_onnet_free_min2.toString(), "網內語音贈送", "分鐘");
					str = str + checkFreeContent(voice_offnet_free_min2.toString(), "網外語音贈送", "分鐘");
					str = str + checkFreeContent(voice_local_free_min2.toString(), "市話贈送", "分鐘");
					str = str + checkFreeContent(voice_onnet_free_mny2.toString(), "送網內通話費$", "元");
					str = str + checkFreeContent(voice_offnet_free_mny2.toString(), "送網外通話費$", "元");
					str = str + checkFreeContent(pstn_free_mny2.toString(), "送市話通話費$", "元");
					checkValue($("#voice_free_content2"), str, str, "-", "", "");

					//簡訊優惠
					str = "";
					str = str + checkFreeContent(sms_onnet_free_num2.toString(), "網內送", "則");
					str = str + checkFreeContent(sms_offnet_free_num2.toString(), "網外送", "則");
					checkValue($("#sms_free_content2"), str, str, "-", "", "");
				}else{
		 			ifPhoneIsNULLThenHidden();
					checkValue($("#avg_amout_compare"), '', '', "-", "$", "");//目前使用平均每月帳單金額
					checkValue($("#avg_amout"), '', '', "-", "$", "");//單門號每月帳單金額
					checkValue($("#cheap_total"), '', '', "-", "$", "");//共計約省
					checkValue($("#cheap_percent"), '', '', "-", "", "%");//共計約省百分比
		 			$('#no_fee_single1').attr('rowspan', (Math.round(($('tr').size()/2))-1)-$('tr:hidden').size());
		 			$('#no_fee_single2').attr('rowspan', (Math.round($('tr').size()/2))-1);
				}	
			} catch (e) {
				alert(e);
			}	
		};
		
		function ifPhoneIsNULLThenHidden(){
			$("#hidn_choose_device_name1").attr('hidden', true);
			$("#hidn_choose_device_name2").attr('hidden', true);
 			$('#tr_cell_plus_total').attr('hidden', true);
 			$('#tr_total_avg_price').attr('hidden', true);
 			$('#tr_avg_percent').attr('hidden', true);
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
			$('#tmp_applyType').attr('value', tmp_apply_type);
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
	
	<div class="new_result_style">
		<div class="nrs_title">依您的使用量試算結果：</div>
		<ul class="nrs_list">		
		<li>手機專案每月平均帳單金額:
			<span id="avg_amout_compare" class="n_light_purple"></span>
		</li>		
		<li>單門號每月平均帳單金額:
			<span id="avg_amout" class="n_light_purple"></span>
		</li>	
		<li hidden="true">推薦您台灣之星最適專案:<br/>
			<c:if test='${not empty proJsonTstar.getProject_name()}'>
				(1)單門號 : <em id="single" ></em>
				(2)手機案 : <em id="project" ></em>
			</c:if>
			<c:if test='${empty proJsonTstar.getProject_name()}'>
				<em >-</em>
			</c:if>
		</li>
		<li id="hidn_device_total_percent">
			<c:if test='${not empty chooseDeviceName}'>
				<span id="hidn_choose_device_name1">搭配</span>
			</c:if>
			<c:if test='${not empty chooseDeviceName}'>
				<em id="hidn_choose_device_name2">${chooseDeviceName}</em>
			</c:if>
			約期內較手機專案共計約省<em id="cheap_total"></em>元(約省<em id="cheap_percent"></em>)
		</li>
		</ul>
	</div>
	<div class="result_table_title">資費試算比一比：</div>
	<table class="filtered_table">
		<tr>
			<td class="gray">電信業者</td>
			<c:if test="${empty proJsonTstar.getProject_name()}">
				<td class="pink"><img src="${pageContext.request.contextPath}/images/crown.png" style="width:20px; vertical-align:-3px; margin-right:3px;" />台灣之星</td>
			</c:if>
			<c:if test='${not empty proJsonTstar.getProject_name()}'>
				<td class="pink"><img src="${pageContext.request.contextPath}/images/crown.png" style="width:20px; vertical-align:-3px; margin-right:3px;" />${proJsonTstar.getCompany()}</td>
			</c:if>
			<c:if test='${empty proJsonTstar.getSingle_project_name()}'>
				<td class="pink">台灣之星</td>
			</c:if>
			<c:if test='${not empty proJsonTstar.getSingle_project_name()}'>
				<td class="pink">${proJsonTstar.getCompany()}</td>
			</c:if>
		</tr>
		<tr>
			<th class="gray">類別</th>
			<td class="light_gray">單門號</td>
			<td class="light_gray">手機專案</td>
		</tr>
		<tr>
			<th class="gray">專案名稱</th>
			<c:if test='${empty proJsonTstar.getProject_name()}'>
				<td id="no_fee_tstar1" class="light_gray">目前無此資費</td>
			</c:if>
			<c:if test='${not empty proJsonTstar.getProject_name()}'>
				<td class="light_gray">${proJsonTstar.getProject_name()}</td>
			</c:if>
			<c:if test='${empty proJsonTstar.getSingle_project_name()}'>
				<td id="no_fee_single1" class="light_gray">目前無此資費</td>
			</c:if>
			<c:if test='${not empty proJsonTstar.getSingle_project_name()}'>
				<td class="light_gray">${proJsonTstar.getSingle_project_name()}</td>
			</c:if>
		</tr>
		<tr>
			<td class="gray">月租費</td>
			<c:if test='${not empty proJsonTstar.getProject_name()}'>
				<td id="monthly_fee1" class="light_gray"></td>
			</c:if>
			<c:if test='${not empty proJsonTstar.getSingle_project_name()}'>
				<td id="monthly_fee2" class="light_gray"></td>
			</c:if>
		</tr>
		<tr>
			<td class="gray">每月帳單金額(月租+超額使用費)</td>
			<c:if test='${not empty proJsonTstar.getProject_name()}'>
				<td id="avg_amout1" class="light_gray"></td>
			</c:if>
			<c:if test='${not empty proJsonTstar.getSingle_project_name()}'>
				<td id="avg_amout2" class="light_gray"></td>
			</c:if>
		</tr>
		<tr hidden="true">
			
			<td class="gray">合約期限(月)</td>
			<c:if test='${not empty proJsonTstar.getProject_name()}'>
			<td id="period1" class="light_gray"></td>
			</c:if>
			<c:if test='${not empty proJsonTstar.getSingle_project_name()}'>
			<td id="period2" class=""></td>
			</c:if>
		</tr>
		<tr>
			<td class="gray">合約期限<br/>總帳單金額</td>
			<c:if test='${not empty proJsonTstar.getProject_name()}'>
				<td id="total_price1" class="pink"></td>
			</c:if>
			<c:if test='${not empty proJsonTstar.getSingle_project_name()}'>
				<td id="total_price2" class="pink"></td>
			</c:if>
		</tr>
		<c:forEach items="${ProjectDeviceDtoOrder}" var="project">
		    <tr id="tr_cell_phone_price">
				<td class="gray">${project.projectName}</td>
				<c:if test='${not empty proJsonTstar.getProject_name()}'>
					<c:if test="${not empty project.priceTstar}">
						<td class="light_gray">$<fmt:formatNumber type="currency" currencySymbol="$" pattern="#,##0;" value="${project.singlePhoneTstar}" /></td>
					</c:if>
					<c:if test="${empty project.singlePhoneTstar}">
						<td class="light_gray">-</td>
					</c:if>
				</c:if>
				<c:if test='${not empty proJsonTstar.getSingle_project_name()}'>
					<c:if test="${not empty project.singlePhoneChosen}">
						<td class="light_gray">$<fmt:formatNumber type="currency" currencySymbol="$" pattern="#,##0;" value="${project.priceChosen}" /></td>
					</c:if>
					<c:if test="${empty project.priceChosen}">
						<td class="light_gray">-</td>
					</c:if>
				</c:if>
			</tr>
		</c:forEach>
		<tr id="tr_cell_plus_total">
			<td class="gray">手機+ 合約期間帳單總支付金額</td>
			<c:if test='${not empty proJsonTstar.getProject_name()}'>
				<td id="cell_plus_total1" class="pink"></td>
			</c:if>
			<c:if test='${not empty proJsonTstar.getSingle_project_name()}'>
				<td id="cell_plus_total2" class="pink"></td>
			</c:if>
		</tr>
		<tr id="tr_total_avg_price">
			
			<td class="gray">共計約省金額</td>
			<c:if test='${not empty proJsonTstar.getProject_name()}'>
				<td id="total_avg_price1" class="blue"></td>
			</c:if>
			<c:if test='${not empty proJsonTstar.getSingle_project_name()}'>
				<td id="total_avg_price2" class="blue">-</td>
			</c:if>
		</tr>
		<tr id="tr_avg_percent">
			
			<td class="gray">約省比例</td>
			<c:if test='${not empty proJsonTstar.getProject_name()}'>
				<td id="avg_percent1" class="blue"></td>
			</c:if>
			<c:if test='${not empty proJsonTstar.getSingle_project_name()}'>
				<td id="avg_percent2" class="blue">-</td>
			</c:if>
		</tr>
		<tr>
			<td colspan="3" class="gray">專案內容</td>
		</tr>
		<tr>
			<td class="blue">上網優惠</td>
			<c:if test='${empty proJsonTstar.getProject_name()}'>
				<td id="no_fee_tstar2">目前無此資費</td>
			</c:if>
			<c:if test='${not empty proJsonTstar.getProject_name()}'>
				<td id="data_free_content1" class="blue"></td>
			</c:if>
			<c:if test='${empty proJsonTstar.getSingle_project_name()}'>
				<td id="no_fee_single2" class="light_gray">目前無此資費</td>
			</c:if>
			<c:if test='${not empty proJsonTstar.getSingle_project_name()}'>
				<td id="data_free_content2" class="blue"></td>
			</c:if>
		</tr>
		<tr>
			
			<td class="blue">語音優惠</td>
			<c:if test='${not empty proJsonTstar.getProject_name()}'>
				<td id="voice_free_content1" class="blue"></td>
			</c:if>
			<c:if test='${not empty proJsonTstar.getSingle_project_name()}'>
				<td id="voice_free_content2" class="blue"></td>
			</c:if>
		</tr>
		<tr>
			
			<td class="blue">簡訊優惠</td>
			<c:if test='${not empty proJsonTstar.getProject_name()}'>
				<td id="sms_free_content1" class="blue"></td>
			</c:if>
			<c:if test='${not empty proJsonTstar.getSingle_project_name()}'>
				<td id="sms_free_content2" class="blue"></td>
			</c:if>
		</tr>
		<tr>
			
			<td class="gray">上網費率(元/KB)</td>
			<c:if test='${not empty proJsonTstar.getProject_name()}'>
				<td id="data_kb1" class="light_gray"></td>
			</c:if>
			<c:if test='${not empty proJsonTstar.getSingle_project_name()}'>
				<td id="data_kb2" class="light_gray"></td>
			</c:if>
		</tr>
		<tr >
			
			<td class="gray">網內語音(元/秒)</td>
			<c:if test='${not empty proJsonTstar.getProject_name()}'>
			<td id="voice_on_net1" class="light_gray"></td>
			</c:if>
			<c:if test='${not empty proJsonTstar.getSingle_project_name()}'>
			<td id="voice_on_net2" class="light_gray"></td>
			</c:if>
		</tr>
		<tr >
			<td class="gray">網外語音(元/秒)</td>
			<c:if test='${not empty proJsonTstar.getProject_name()}'>
			<td id="voice_off_net1" class="light_gray"></td>
			</c:if>
			<c:if test='${not empty proJsonTstar.getSingle_project_name()}'>
			<td id="voice_off_net2" class="light_gray"></td>
			</c:if>
		</tr>
		<tr >
			
			<td class="gray">市話(元/秒)</td>
			<c:if test='${not empty proJsonTstar.getProject_name()}'>
			<td id="voice_local1" class="light_gray"></td>
			</c:if>
			<c:if test='${not empty proJsonTstar.getSingle_project_name()}'>
			<td id="voice_local2" class="light_gray"></td>
			</c:if>
		</tr>
		<tr >
			
			<td class="gray">網內簡訊(元/則)</td>
			<c:if test='${not empty proJsonTstar.getProject_name()}'>
			<td id="sms_on_net1" class="light_gray"></td>
			</c:if>
			<c:if test='${not empty proJsonTstar.getSingle_project_name()}'>
			<td id="sms_on_net2" class="light_gray"></td>
			</c:if>
		</tr>
		<tr >
			<td class="gray">網外簡訊(元/則)</td>
			<c:if test='${not empty proJsonTstar.getProject_name()}'>
			<td id="sms_off_net1" class="light_gray"></td>
			</c:if>
			<c:if test='${not empty proJsonTstar.getSingle_project_name()}'>
			<td id="sms_off_net2" class="light_gray"></td>
			</c:if>
		</tr>
	</table>
	<div class="bl_note">
		${protectWord}
	</div>
	<div>
		<form id="back_form" hidden="true" action="comparsionP2.action" method="post">
			<input id="tmp_calRule" name="tmp.cal_rule">
			<input id="tmp_applyType" name="tmp.apply_type">
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
		<a class="submit" href="http://doc.tstartel.com/reservation/PreOrder.aspx?ohyes=1" onclick="ga('send', 'event', '資費試算', '我要預約');false">我要預約</a>
	</div>
</div>