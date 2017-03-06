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
		var voice_onnet_free_mny1;
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
		
		//comparsion
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
		var price_choose = '${priceChoose}';
		var prepayment_amount_choose = '${prepaymentAmountChoose}';
		
		$(function() {
			jobjSearch(json);//搜尋json內容塞值
			init();
			changeAction();
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
								voice_onnet_free_mny2 = project_compare[0].Voice_onnet_free_mny;
								voice_offnet_free_mny2 = project_compare[0].Voice_offnet_free_mny;
								pstn_free_mny2 = project_compare[0].Pstn_free_mny;
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
				//Tstar
				monthly_fee1 = numFactory(monthly_fee1, true, false);
				cal_amount1 = numFactory(cal_amount1, true, true);
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
				price_choose = numFactory(price_choose, true, true);
				prepayment_amount_choose = numFactory(prepayment_amount_choose, true, true);			
				
				checkValue($("#avg_amout_compare"), cal_amount2, (cal_amount2 / period2), "-", "$", "");//目前使用平均每月帳單金額
				checkValue($("#avg_amout"), cal_amount1, (cal_amount1 / period1), "-", "$", "");//推薦專案每月帳單金額
				checkValue($("#monthly_fee"), monthly_fee1, monthly_fee1, "-", "$", "");//推薦您台灣之星最適專案
				
				// Tstar
				if('' != '${proJsonTstar.getCompany()}'){
					checkValue($("#project_name1"), project_name1, project_name1, "-", "", "");//專案名稱
					checkValue($("#monthly_fee1"), monthly_fee1.toString(), monthly_fee1, "-", "$", "");//月租費
					checkValue($("#avg_amout1"), cal_amount1.toString(), cal_amount1 / period1, "-", "$", "");//每月帳單金額
					checkValue($("#period1"), period1.toString(), period1, "-", "", "");//合約期限
					checkValue($("#total_price1"), cal_amount1.toString(), cal_amount1, "-", "$", "");//合約期限帳單總金額
					checkValue($("#phone_discount1"), price_tstar.toString(), price_tstar - prepayment_amount_tstar, "-", "$", "");//台灣之星攜碼手機折扣
					
					if('${applyType}' == "攜碼"){	
						checkValue($("#cell_plus_total1"), cal_amount1.toString(), cal_amount1 + prepayment_amount_tstar, "-", "$", "");//手機+合約期間帳單總支付金額
						
						var cpt_tstar = cal_amount1 + prepayment_amount_tstar;
						var cpt_compare = cal_amount2 + price_choose;
						checkValue($("#total_avg_price1"), cpt_tstar.toString(), cpt_compare - cpt_tstar, "-", "$", "");//共計約省金額
						
						var tap = cpt_compare - cpt_tstar;
						checkValue($("#avg_percent1"), tap.toString(), Math.round(formatFloat((tap / cpt_compare) * 100, 3)), "-", "", "%");//約省比例

						logs('price_tstar:' + price_tstar);
						logs('price_choose:' + price_choose);
						decideCheepTotalAndCheepPercentCalculate(cpt_tstar, cpt_compare, tap);
					}else if('${applyType}' == "新用戶"){		
						checkValue($("#cell_plus_total1"), cal_amount1.toString(), cal_amount1 + price_tstar, "-", "$", "");//手機+合約期間帳單總支付金額
						
						var cpt_tstar = cal_amount1 + price_tstar;
						var cpt_compare = cal_amount2 + price_choose;
						checkValue($("#total_avg_price1"), cpt_tstar.toString(), cpt_compare - cpt_tstar, "-", "$", "");//共計約省金額
						
						var tap = cpt_compare - cpt_tstar;
						checkValue($("#avg_percent1"), tap.toString(), Math.round(formatFloat((tap / cpt_compare) * 100, 3)), "-", "", "%");//約省比例

						logs('price_tstar:' + price_tstar);
						logs('price_choose:' + price_choose);
						decideCheepTotalAndCheepPercentCalculate(cpt_tstar, cpt_compare, tap);
					}else{
						console.log("applyType:" + '${applyType}');
					}
					
					checkValue($("#data_kb1"), data_kb1.toString(), data_kb1, "-", "", "");//上網費率
					
					//上網優惠
					var str = "";	
					if(null != data_free_month1 & null != period1){
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
					checkValue($("#avg_amout"), '', '', "-", "$", "");//推薦專案每月帳單金額
					checkValue($("#monthly_fee"), '', '', "-", "$", "");//推薦您台灣之星最適專案
					checkValue($("#cheap_total"), '', '', "-", "$", "");//共計約省
					checkValue($("#cheap_percent"), '', '', "-", "", "%");//共計約省百分比
		 			$('#no_fee_tstar1').attr('rowspan', (Math.round(($('tr').size()/2))-1)-$('tr:hidden').size());
		 			$('#no_fee_tstar2').attr('rowspan', (Math.round($('tr').size()/2))-1);
				}
				
				// Compare
				if('' != '${proJsonCompare.getCompany()}'){
					checkValue($("#project_name2"), project_name2, project_name2, "-", "", "");//專案名稱
					checkValue($("#monthly_fee2"), monthly_fee2.toString(), monthly_fee2, "-", "$", "");//月租費
					checkValue($("#avg_amout2"), cal_amount2.toString(), cal_amount2 / period2, "-", "$", "");//每月帳單金額
					checkValue($("#period2"), period2.toString(), period2, "-", "", "");//合約期限
					checkValue($("#total_price2"), cal_amount2.toString(), cal_amount2, "-", "$", "");//合約期限帳單總金額	
					checkValue($("#phone_discount2"), '', price_choose - prepayment_amount_choose, "-", "$", "");//對方攜碼手機折扣
					checkValue($("#cell_plus_total2"), price_choose.toString(), cal_amount2 + price_choose, "-", "$", "");//手機+合約期間帳單總支付金額
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
					checkValue($("#avg_amout"), '', '', "-", "$", "");//推薦專案每月帳單金額
					checkValue($("#monthly_fee"), '', '', "-", "$", "");//推薦您台灣之星最適專案
					checkValue($("#cheap_total"), '', '', "-", "$", "");//共計約省
					checkValue($("#cheap_percent"), '', '', "-", "", "%");//共計約省百分比
		 			$('#no_fee_compare1').attr('rowspan', (Math.round(($('tr').size()/2))-1)-$('tr:hidden').size());
		 			$('#no_fee_compare2').attr('rowspan', (Math.round($('tr').size()/2))-1);
				}	
			} catch (e) {
				alert(e);
			}
		};

		function changeAction(){
			$('#periodCallback').change(function(){
				if(!($('#periodCallback').val() == '請選擇')){
					$('#tmp_period2').attr('value', $('#periodCallback').val());
					$('#myself_form').submit();
				}
			});
		};

		function ifPhoneIsNULLThenHidden(){
			$("#hidn_choose_device_name1").attr('hidden', true);
			$("#hidn_choose_device_name2").attr('hidden', true);
 			$('#tr_cell_plus_total').attr('hidden', true);
 			$('#tr_total_avg_price').attr('hidden', true);
 			$('#tr_avg_percent').attr('hidden', true);
		};

// 		結果金額 < 0不顯示	
		function decideCheepTotalAndCheepPercentCalculate(cpt_tstar, cpt_compare, tap){
			switch (price_tstar) {//判斷[共計約省]、[共計約省百分比]的計算方式
			case ''://我方沒手機(手機='')
				switch (price_choose) {
				case ''://對方沒手機(手機='')
					checkValue($("#cheap_total"), cal_amount2.toString(), cal_amount2 - cal_amount1, "-", "$", "");//共計約省
					checkValue($("#cheap_percent"), cal_amount2.toString(), Math.round((formatFloat(((cal_amount2 - cal_amount1) / cal_amount2) * 100, 3))), "-", "", "%");//共計約省百分比
		 			$('#tr_cell_phone_price').attr('hidden', true);
					$("#tr_phone_discount").attr('hidden', true);
					ifPhoneIsNULLThenHidden();
					break;

				default://對方有手機價
					checkValue($("#cheap_total"), cal_amount2.toString(), cal_amount2 - cal_amount1, "-", "$", "");//共計約省
					checkValue($("#cheap_percent"), cal_amount2.toString(), Math.round((formatFloat(((cal_amount2 - cal_amount1) / cal_amount2) * 100, 3))), "-", "", "%");//共計約省百分比
					$("#tr_phone_discount").attr('hidden', true);
					ifPhoneIsNULLThenHidden();
					break;
				}
				if((cal_amount2 - cal_amount1) < 0){
					$("#hidn_device_total_percent").attr('hidden', true);
				}	
				break;

			default://我方有手機價
				switch (price_choose) {
				case ''://對方沒手機(手機='')
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
					if(tap < 0){
						$("#hidn_device_total_percent").attr('hidden', true);
					}	
					break;
				}
				break;
			}
		};

		//首頁佔存狀態賦值與轉送
		function submitBackForm(){
			$('#back_form').submit();
		};
	</script>
	
		<div class="new_result_style">
			<div class="nrs_title">依您的使用量試算結果：</div>
			<ul class="nrs_list">
			<li>目前使用每月平均帳單金額:
				<span id="avg_amout_compare" class="n_light_purple"></span>
			</li>
			<li>推薦您台灣之星最適專案:
				<c:if test='${not empty proJsonTstar.getCompany()}'>
					<em id="monthly_fee"></em>
				</c:if>
				<c:if test='${empty proJsonTstar.getCompany()}'>
					<em id="monthly_fee">-</em>
				</c:if>
			</li>
			<li>推薦專案每月平均帳單金額:
				<span id="avg_amout" class="n_light_purple"></span>
			</li>
			<li id="hidn_device_total_percent">
				<c:if test='${not empty chooseDeviceName}'>
					<span id="hidn_choose_device_name1">搭配</span>
				</c:if>
				<c:if test='${not empty chooseDeviceName}'>
					<em id="hidn_choose_device_name2">${chooseDeviceName}</em>
				</c:if>
				約期內較其他業者共計約省<em id="cheap_total"></em>元(約省<em id="cheap_percent"></em>)
			</li>
			</ul>
		</div>
		
		<div hidden="true" class="n_row">
			<label style="width: 40px; padding: 0;">約期 :</label>
			 <span class="custom_select"> 
				<select id="periodCallback" style="width: 201px; box-sizing: border-box;">
					<option>請選擇</option>
<!-- 					<option value='12'>12</option> -->
					<option value='24'>24</option>
					<option value='30'>30</option>
				</select>
			</span>
		</div>
		
		<div class="result_table_title">資費試算比一比：</div>
		<table class="filtered_table">
			<tr>
				<td class="gray">電信業者</td>
				<c:if test="${empty proJsonTstar.getCompany()}">
					<td class="pink"><img src="${pageContext.request.contextPath}/images/crown.png" style="width:20px; vertical-align:-3px; margin-right:3px;" />台灣之星</td>
				</c:if>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
					<td class="pink"><img src="${pageContext.request.contextPath}/images/crown.png" style="width:20px; vertical-align:-3px; margin-right:3px;" />${proJsonTstar.getCompany()}</td>
				</c:if>
				<c:if test='${empty proJsonCompare.getCompany()}'>
					<td class="pink">${company}</td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
					<td class="pink">${proJsonCompare.getCompany()}</td>
				</c:if>
			</tr>
			<tr>	
				<td class="gray">專案名稱</td>
				<c:if test='${empty proJsonTstar.getCompany()}'>
					<td id="no_fee_tstar1">目前無此資費</td>
				</c:if>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
					<td class="light_pink">${proJsonTstar.getProject_name()}</td>
				</c:if>
				<c:if test='${empty proJsonCompare.getCompany()}'>
					<td id="no_fee_compare1" class="light_gray">目前無此資費</td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
					<td class="light_gray">${proJsonCompare.getProject_name()}</td>
				</c:if>
			</tr>
			<tr>
				<td class="gray">月租費</td>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
					<td id="monthly_fee1" class="light_pink"></td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
					<td id="monthly_fee2" class="light_gray"></td>
				</c:if>
			</tr>
			<tr>	
				<td class="gray">每月帳單金額(月租+超額使用費)</td>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
					<td id="avg_amout1" class="light_pink"></td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
					<td id="avg_amout2" class="light_gray"></td>
				</c:if>
			</tr>
			<tr >	
				<td class="gray">合約期限(月)</td>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
				<td id="period1" class="light_pink"></td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
				<td id="period2" class="light_gray"></td>
				</c:if>
			</tr>
			<tr>	
				<td class="gray">合約期限總帳單金額</td>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
					<td id="total_price1" class="pink"></td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
					<td id="total_price2" class="pink"></td>
				</c:if>
			</tr>
		    <tr id="tr_cell_phone_price">
				<c:forEach items="${ProjectDeviceDtoOrder}" var="project">
						<td class="gray">${project.projectName}</td>
						<c:if test='${not empty proJsonTstar.getCompany()}'>
							<c:if test="${not empty project.priceTstar}">
								<c:if test="${applyType == '新用戶'}">
									<td class="light_pink">$<fmt:formatNumber type="currency" currencySymbol="$" pattern="#,##0;" value="${project.priceTstar}" /></td>
								</c:if>
								<c:if test="${applyType  == '攜碼'}">
									<td class="light_pink">$<fmt:formatNumber type="currency" currencySymbol="$" pattern="#,##0;" value="${project.priceTstar}" /></td>
								</c:if>
							</c:if>
							<c:if test="${empty project.priceTstar}">
								<td class="light_pink">-</td>
							</c:if>
						</c:if>
						<c:if test='${not empty proJsonCompare.getCompany()}'>
							<c:if test="${not empty project.priceChosen}">
								<td class="">$<fmt:formatNumber type="currency" currencySymbol="$" pattern="#,##0;" value="${project.priceChosen}" /></td>
							</c:if>
							<c:if test="${empty project.priceChosen}">
								<td class="">-</td>
							</c:if>
						</c:if>
				</c:forEach>
			</tr>
			<c:if test="${applyType  == '攜碼'}">
				<tr id="tr_phone_discount">
					<td class="gray">攜碼手機折扣</td>
					<c:if test='${not empty proJsonTstar.getCompany()}'>
						<td id="phone_discount1" class="light_pink"></td>
					</c:if>
					<c:if test='${not empty proJsonCompare.getCompany()}'>
						<td id="phone_discount2" class=""></td>
					</c:if>
				</tr>
			</c:if>
			<tr id="tr_cell_plus_total">
				<td class="gray">手機+ 合約期間帳單總支付金額</td>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
					<td id="cell_plus_total1" class="pink"></td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
					<td id="cell_plus_total2" class="pink"></td>
				</c:if>
			</tr>
			<tr id="tr_total_avg_price">
				<td class="gray">共計約省金額</td>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
					<td id="total_avg_price1" class="blue"></td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
					<td id="total_avg_price2" class="blue">-</td>
				</c:if>
			</tr>
			<tr id="tr_avg_percent">
				<td class="gray">約省比例</td>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
					<td id="avg_percent1" class="blue"></td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
					<td id="avg_percent2" class="blue">-</td>
				</c:if>
			</tr>
			<tr>
				<td colspan="3" class="gray">專案內容</td>
			</tr>
			<tr>
				<td class="blue">上網優惠</td>
				<c:if test='${empty proJsonTstar.getCompany()}'>
					<td id="no_fee_tstar2">目前無此資費</td>
				</c:if>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
					<td id="data_free_content1" class="blue"></td>
				</c:if>
				<c:if test='${empty proJsonCompare.getCompany()}'>
					<td id="no_fee_compare2" class="light_gray">目前無此資費</td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
					<td id="data_free_content2" class="blue"></td>
				</c:if>
			</tr>
			<tr>
				<td class="blue">語音優惠</td>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
					<td id="voice_free_content1" class="blue"></td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
					<td id="voice_free_content2" class="blue"></td>
				</c:if>
			</tr>
			<tr>				
				<td class="blue">簡訊優惠</td>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
					<td id="sms_free_content1" class="blue"></td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
					<td id="sms_free_content2" class="blue"></td>
				</c:if>
			</tr>
			<tr>
				<td class="gray">上網費率(元/KB)</td>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
					<td id="data_kb1" class="light_pink"></td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
					<td id="data_kb2"class=""></td>
				</c:if>
			</tr>
			<tr >
				<td class="gray">網內語音(元/秒)</td>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
				<td id="voice_on_net1" class="light_pink"></td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
				<td id="voice_on_net2" class=""></td>
				</c:if>
			</tr>
			<tr >
				<td class="gray">網外語音(元/秒)</td>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
				<td id="voice_off_net1" class="light_pink"></td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
				<td id="voice_off_net2" class=""></td>
				</c:if>
			</tr>
			<tr >
				<td class="gray">市話(元/秒)</td>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
				<td id="voice_local1" class="light_pink"></td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
				<td id="voice_local2" class=""></td>
				</c:if>
			</tr>
			<tr >
				<td class="gray">網內簡訊(元/則)</td>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
				<td id="sms_on_net1" class="light_pink"></td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
				<td id="sms_on_net2" class=""></td>
				</c:if>
			</tr>
			<tr >
				<td class="gray">網外簡訊(元/則)</td>
				<c:if test='${not empty proJsonTstar.getCompany()}'>
				<td id="sms_off_net1" class="light_pink"></td>
				</c:if>
				<c:if test='${not empty proJsonCompare.getCompany()}'>
				<td id="sms_off_net2" class=""></td>
				</c:if>
			</tr>
		</table>
		<div class="bl_note">
			${protectWord}
		</div>
		<div>
			<form id="back_form" hidden="true" action="comparsionP2.action" method="post">
				<input id="tmp_calRule1" name="tmp.cal_rule" value="${tmp.cal_rule}">
				<input id="tmp_applyType1" name="tmp.apply_type" value="${tmp.apply_type}">
				<input id="tmp_companySel1" name="tmp.op_id" value="${tmp.op_id}">
				<input id="tmp_feeType1" name="tmp.fee_type" value="${tmp.fee_type}">
				<input id="tmp_feeRange1" name="tmp.fee_range" value="${tmp.fee_range}">
				<input id="tmp_feeSel1" name="tmp.fee_sel" value="${tmp.fee_sel}">
				<input id="tmp_period1" name="tmp.period" value="${tmp.period}">
				<input id="tmp_projectCode1" name="tmp.project_code" value="${tmp.project_code}">
				<input id="tmp_voiceOnNet1" name="tmp.voice_on_net" value="${tmp.voice_on_net}">
				<input id="tmp_voiceOffNet1" name="tmp.voice_off_net" value="${tmp.voice_off_net}">
				<input id="tmp_pstn1" name="tmp.pstn" value="${tmp.pstn}">
				<input id="tmp_dataUsage1" name="tmp.data_usage" value="${tmp.data_usage}">
				<input id="tmp_smsOnNet1" name="tmp.sms_on_net" value="${tmp.sms_on_net}">
				<input id="tmp_smsOffNet1" name="tmp.sms_off_net" value="${tmp.sms_off_net}">
				<input id="tmp_phoneCode1" name="tmp.phone_code" value="${tmp.phone_code}">
			</form>
		</div>
		<div>
			<form id="myself_form" hidden="true" action="comparebybsc.action" method="post">
				<input id="tmp_calRule2" name="calRule" value="${tmp.cal_rule}">
				<input id="tmp_applyType2" name="applyType" value="${tmp.apply_type}">
				<input id="tmp_companySel2" name="queryCompareProject1Dto.op_id" value="${tmp.op_id}">
				<input id="tmp_feeType2" name="queryCompareProject1Dto.gtype" value="${tmp.fee_type}">
				<input id="tmp_feeRange2" name="queryCompareProject1Dto.fee_range" value="${tmp.fee_range}">
				<input id="tmp_feeSel2" name="queryCompareProject1Dto.fee_sel" value="${tmp.fee_sel}">
				<input id="tmp_period2" name="queryCompareProject1Dto.period">
				<input id="tmp_projectCode2" name="queryCompareProject1Dto.project_code" value="${tmp.project_code}">
				<input id="tmp_voiceOnNet2" name="queryCompareProject1Dto.voice_on_net" value="${tmp.voice_on_net}">
				<input id="tmp_voiceOffNet2" name="queryCompareProject1Dto.voice_off_net" value="${tmp.voice_off_net}">
				<input id="tmp_pstn2" name="queryCompareProject1Dto.pstn" value="${tmp.pstn}">
				<input id="tmp_dataUsage2" name="queryCompareProject1Dto.data_usage" value="${tmp.data_usage}">
				<input id="tmp_smsOnNet2" name="queryCompareProject1Dto.sms_on_net" value="${tmp.sms_on_net}">
				<input id="tmp_smsOffNet2" name="queryCompareProject1Dto.sms_off_net" value="${tmp.sms_off_net}">
				<input id="tmp_phoneCode2" name="queryCompareProject1Dto.phone_code" value="${tmp.phone_code}">
			</form>
		</div>
		<div class="apply_plan">
			<input class="submit" type="button" onclick='submitBackForm()' value="再算一次">
			<a class="submit" href="http://doc.tstartel.com/reservation/PreOrder.aspx?ohyes=1" onclick="ga('send', 'event', '資費試算', '我要預約');false">我要預約</a>
		</div>
</div>