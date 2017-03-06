/**
 ***工具檔*** 
 */
/**
 * 專案比一比各欄位計算公式:
 * 每月平均帳單金額:cal_amount(對方) / period(對方)
 * 推薦台灣之星最適專案:monthly_fee(我方)
 * ************************************************************************
 * 共計約省(有手機):等於 共計約省金額
 * 共計約省(沒手機):cal_amount(對方) - cal_amount(我方)
 * ************************************************************************
 * 共計約省約省百分(有手機)比:等於 共計約省金額 / 手機+合約期間帳單總支付金額(對方)
 * 共計約省約省百分(沒手機)比:(cal_amount(對方) - cal_amount(我方)) / cal_amount(對方)
 * ************************************************************************
 * 每月帳單金額:cal_amount / period
 * 合約期限總帳單金額:cal_amount
 * 手機專案價:price
 * 攜碼手機折扣:price - prepayment_amount
 * 手機+合約期間帳單總支付金額(攜碼):(合約期限帳單總金額 + 手機專案價) - 攜碼手機折扣
 * 手機+合約期間帳單總支付金額(新用戶):合約期限帳單總金額 + 手機專案價
 * 共計約省金額:手機+合約期間帳單總支付金額(對方) - 手機+合約期間帳單總支付金額(我方)
 * 約省比例:共計約省金額 / 手機+合約期間帳單總支付金額(對方)
 */
/**
 * 檢查第一位是否為小數點、值是否為空、是否為NaN(處理單欄位內容)
 * @param selector 檢查的selector物件($('#id'))
 * @param val 檢查的值
 * @param content 設定內容
 * @param noVal 若val為空值->輸出noVal
 * @param prefix 加在content之前的值
 * @param postfix 加在content之後的值
 * @returns {String}
 * 
 * content資料型態可能不一樣，為了統一判斷且便利，就將content中主要的值分離出來(val)做空與0判斷，
 * 否則需要寫兩個method區分。
 */
function checkValue(selector, val, content, noVal, prefix, postfix){
	try {
		if("" != val && undefined != val){
			if(val == "0" || val == '-1'){
				if('$' == prefix){
					selector.html(prefix + numeral(content).format('0,0') + postfix);//numeral():讓價格顯示格式化為千分位加上逗號
				}else{
					selector.html(noVal);
				}
			}else{
				if(typeof(content) == "string"){
					selector.html(prefix + content + postfix);
				}else if(!isNaN(content)){//若content為NaN返回true(isNaN()只接受數字，即字串跟NaN都返回true)
					if('$' == prefix){
						selector.html(prefix + numeral(content).format('0,0') + postfix);
					}else{
						selector.html(prefix + content + postfix);
					}
				}else{
					selector.html(noVal);
				}
			}
		}else{
			selector.html(noVal);
		}
	} catch (e) {
		alert(e);
	}
}
/**
 * 檢查第一位是否為小數點、值是否為空、是否為NaN(處理input欄位內容)
 * @param selector 檢查的selector物件($('#id'))
 * @param val 檢查的值
 * @param content 設定內容
 * @param noVal 若val為空值->輸出noVal
 * @param prefix 加在content之前的值
 * @param postfix 加在content之後的值
 */
function inputer(selector, val, content, noVal, prefix, postfix){
	try {
		if("" != val && undefined != val){
			if(val.substring(0,1) == "."){
				selector.val(prefix + "0" + content + postfix);
			}else if(val == "0"){
				selector.val(noVal);
			}else{
				if(typeof(content) == "string"){
					selector.val(prefix + content + postfix);
				}else if(!isNaN(content)){//若content為NaN返回true(isNaN()只接受數字，即字串跟NaN都返回true)
					selector.val(prefix + content + postfix);
				}else{
					selector.val(noVal);
				}
			}
		}else{
			selector.val(noVal);
		}
	} catch (e) {
		alert(e);
	}
}
/**
 * 檢查第一位是否為小數點，是->字頭加入'0'、字尾換行並返回字串(處理優惠類字串相加)
 * @param val 檢查的值
 * @param prefix 加在content之前的值
 * @param postfix 加在content之後的值
 * @returns {String}
 */
function checkFreeContent(val, prefix, postfix){
	try {
		if("" != val && "0" != val && "-1" != val && val != undefined){
			return prefix + val + postfix + "</br>";
		}else{
			return "";
		}
	} catch (e) {
		alert(e);
	}
}
/**
 * 上網傳輸量轉換並返回"上網贈送XXX '單位'"
 * @param num 換算的值
 * @param unitFrom (Byte、KB、MB、GM)大小寫都可
 * @param unitTo (Byte、KB、MB、GM)大小寫都可
 * @param limit 極限值(若num>=limit->進行換算)
 * @returns checkFreeContent(formatFloat(num, 2).toString(), "上網贈送", unitTo.toUpperCase())
 */
function converterFreeContent(num, unitFrom, unitTo, limit){
	try {
		if(num >= limit){
			if(unitFrom == "b" && unitTo == "kb"){
				num = num / Math.pow(1024, 1);
			}else if(unitFrom == "b" && unitTo == "mb"){
				num = num / Math.pow(1024, 2);
			}else if(unitFrom == "b" && unitTo == "gb"){
				num = num / Math.pow(1024, 3);
			}else if(unitFrom == "kb" && unitTo == "b"){
				num = num * Math.pow(1024, 1);
			}else if(unitFrom == "kb" && unitTo == "mb"){
				num = num / Math.pow(1024, 1);
			}else if(unitFrom == "kb" && unitTo == "gb"){
				num = num / Math.pow(1024, 2);
			}else if(unitFrom == "mb" && unitTo == "b"){
				num = num * Math.pow(1024, 2);
			}else if(unitFrom == "mb" && unitTo == "kb"){
				num = num * Math.pow(1024, 1);
			}else if(unitFrom == "mb" && unitTo == "gb"){
				num = num / Math.pow(1024, 1);
			}else if(unitFrom == "gb" && unitTo == "b"){
				num = num * Math.pow(1024, 3);
			}else if(unitFrom == "gb" && unitTo == "kb"){
				num = num * Math.pow(1024, 2);
			}else if(unitFrom == "gb" && unitTo == "mb"){
				num = num * Math.pow(1024, 1);
			}else if(unitFrom == "b".toUpperCase() && unitTo == "kb".toUpperCase()){
				num = num / Math.pow(1024, 1);
			}else if(unitFrom == "b".toUpperCase() && unitTo == "mb".toUpperCase()){
				num = num / Math.pow(1024, 2);
			}else if(unitFrom == "b".toUpperCase() && unitTo == "gb".toUpperCase()){
				num = num / Math.pow(1024, 3);
			}else if(unitFrom == "kb".toUpperCase() && unitTo == "b".toUpperCase()){
				num = num * Math.pow(1024, 1);
			}else if(unitFrom == "kb".toUpperCase() && unitTo == "mb".toUpperCase()){
				num = num / Math.pow(1024, 1);
			}else if(unitFrom == "kb".toUpperCase() && unitTo == "gb".toUpperCase()){
				num = num / Math.pow(1024, 2);
			}else if(unitFrom == "mb".toUpperCase() && unitTo == "b".toUpperCase()){
				num = num * Math.pow(1024, 2);
			}else if(unitFrom == "mb".toUpperCase() && unitTo == "kb".toUpperCase()){
				num = num * Math.pow(1024, 1);
			}else if(unitFrom == "mb".toUpperCase() && unitTo == "gb".toUpperCase()){
				num = num / Math.pow(1024, 1);
			}else if(unitFrom == "gb".toUpperCase() && unitTo == "b".toUpperCase()){
				num = num * Math.pow(1024, 3);
			}else if(unitFrom == "gb".toUpperCase() && unitTo == "kb".toUpperCase()){
				num = num * Math.pow(1024, 2);
			}else if(unitFrom == "gb".toUpperCase() && unitTo == "mb".toUpperCase()){
				num = num * Math.pow(1024, 1);
			}else{
				logs("Not match");
			}
		}else{
			return checkFreeContent(formatFloat(num, 2).toString(), "上網贈送", unitFrom.toUpperCase());
		}
		return checkFreeContent(formatFloat(num, 2).toString(), "上網贈送", unitTo.toUpperCase());
	} catch (e) {
		alert(e);
	}
	return -1;
}
/**
 * 小數點後幾位捨去
 * @param num 小數位數
 * @param pos 捨去小數點後幾位
 * @returns {Number}
 */
function formatFloat(num, pos) {
	var size = Math.pow(10, pos);
	return Math.round(num * size) / size;
};
/**
 * 處理輸入欄位空值、不全為數字、無選擇並彈出警告框
 * @param selector 檢查selector物件($('#id'))
 * @param content1 設定內容
 * @param content2 設定內容
 * @param isNan 是否要判斷欄位內全是數字
 * @returns {Boolean}
 */
function alertController(selector, content1, content2, isNan){
	try {
		if(isNan){
			if(isNaN(selector.val()) || '' == selector.val()){
				if(isNaN(selector.val())){
					alert(content1);
					selector.val("");
					return false;
				}else{
					alert(content2);
					selector.val("");
					return false;	
				}
			}
		}else{
			if('' == selector.val()){
				alert(content1);
				selector.val("");
				return false;
			}else if('請選擇' == selector.val()){
				alert(content1);
				selector.val("請選擇");
				return false;
			}
		}
		return true;
	} catch (e) {
		alert(e);
	}
};
/**
 * 過濾要顯示的資費範圍
 * @param pass
 * @param val
 * @returns {Boolean}
 */
function pickSel(pass, val){
	if(pass == val){
		return true;
	}else{
		return false;
	}
};
/**
 * 限制要顯示的資費範圍之價位
 * @param pass
 * @param min
 * @param max
 * @returns {Boolean}
 */
function limitPrice(pass, min, max){
	if(pass > min && pass < max){
		return true;
	}
	return false;
};
/**
 * 處理數字格式與型態轉換，讓出去的數字型態與格式正確
 * @param num
 * @param isPrice
 * @param ifRound
 * @returns {Number}
 */
function numFactory(num, isPrice, ifRound){
	if(num != '' && num != undefined){
		if(isPrice){
			if(ifRound){
				return Math.round(num);
			}else{
				return parseFloat(num);
			}
		}else{
			if(num.substring(0,1) == "."){
				return parseFloat("0" + num);
			}else{
				return parseFloat(num);
			}
		}
	}else if(num == '-1'){
		return parseFloat(num);
	}else{
		return '';
	}
};
/**
 * console.log()
 * @param any
 */
function logs(any){
	console.log(any);
}