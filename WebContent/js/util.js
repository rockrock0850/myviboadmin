/**********這個檔案裡是一些公用的函數**********/

/**********將視窗移動到某個位置**********/
function scrollToId(id){
	if (beEmpty(id)){	//沒輸入位置，捲到畫面最上方
		$('html, body').animate({
			scrollTop: 0
		}, 2000);
	}else{
		$('html, body').animate({
			scrollTop: $("#"+id).offset().top
		}, 2000);
	}
}	//function scrollToTop(){

/**********判斷字串是否為空值**********/
function beEmpty(s){
	return (s==null || s=='undefined' || s.length<1)
}	//function scrollToTop(){

/**********判斷字串是否有值**********/
function notEmpty(s){
	return (s!=null && s!='undefined' && s.length>0)
}	//function scrollToTop(){

/**********顯示loading中的BlockUI**********/
function showBlockUI(){
/*
	$.blockUI({
		message: '<img src="images/loading.gif">資料更新中，請稍候...</img>',
		css: {
			border: 'none',
			background: 'none',
			color: '#00FF00'
		},
		overlayCSS:{
			backgroundColor: '#000000',
			opacity:         0.5,
			cursor:          'wait'
		}
	});
*/
	
	$.blockUI({ 
		message: '<img src="images/loading.gif">資料更新中，請稍候...</img>',
		css:{
			border: 'none',
			padding: '15px',
			backgroundColor: '#000',
			'-webkit-border-radius': '10px',
			'-moz-border-radius': '10px',
			opacity: .8,
			color: '#00FF00'
		}
	}); 

	//$('.blockOverlay').attr('title','以滑鼠點擊灰色區域可回到主畫面').click($.unblockUI);	//若加這一行且有使用JQuery UI Tooltip，則這一行字在BlockUI關閉後仍會殘留在IE畫面上(Chrome不會)
	$('.blockOverlay').click($.unblockUI);	//若加這一行且有使用JQuery UI Tooltip，則這一行字在BlockUI關閉後仍會殘留在IE畫面上(Chrome不會)

}

/**********解除BlockUI**********/
function unBlockUI(){
	$.unblockUI();
}

/**********將金額字串加上千位的逗點**********/
function toCurrency(s){
	if (beEmpty(s)) return "";	//字串為空
	if (isNaN(s))	return s;	//不是數字，回覆原字串
	
	var i = 0;
	var j = 0;
	var k = 0;
	var l = 0;
	var s2 = "";
	s = trim(s);
	i = s.length;			//i為字串長度
	if (i<4) return s;		//長度太短，不用加逗點，直接回覆原字串
	j = Math.floor(i/3);	//j為字串長度除以3的商數
	k = i % 3;				//k為字串長度除以3的餘數
	s2 = "";
	if (k>0) s2 = s.substring(0, k);
	for (l=0;l<j;l++){
		s2 = s2 + (s2==""?"":",") + s.substring(k+(l*3), k+(l+1)*3);
	}
	return s2;
}

/**********將字串的空白去掉**********/
function trim(stringToTrim){
	return stringToTrim.replace(/^\s+|\s+$/g,"");
}

/**********取得某個 URL 參數的值，例如 http://target.SchoolID/set?text=abc **********/
function getParameterByName( name ){
	name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
	var regexS = "[\\?&]"+name+"=([^&#]*)";
	var regex = new RegExp( regexS );
	var results = regex.exec( window.location.href );
	if( results == null )
		return "";
	else
		return decodeURIComponent(results[1].replace(/\+/g, " "));
}

/**********將 JQuery UI 的 datepicker 中文化**********/

$(function () {
	var old_generateMonthYearHeader = $.datepicker._generateMonthYearHeader;
	var old_get = $.datepicker._get;
	var old_CloseFn = $.datepicker._updateDatepicker;
	/*  注意，若以下設定和 jquery-ui-timepicker-addon 共用會有問題
	$.extend($.datepicker, {
		_generateMonthYearHeader:function (a,b,c,d,e,f,g,h) {
			var htmlYearMonth = old_generateMonthYearHeader.apply(this, [a, b, c, d, e, f, g, h]);
			if ($(htmlYearMonth).find(".ui-datepicker-year").length > 0) {
				htmlYearMonth = $(htmlYearMonth).find(".ui-datepicker-year").find("option").each(function (i, e) {
					if (Number(e.value) - 1911 > 0) $(e).text('民國' + (Number(e.innerText) - 1911) + '年/西元' + e.innerText + '年');
				}).end().end().get(0).outerHTML;
			}
			return htmlYearMonth;
		},
		_get:function (a, b) {
			a.selectedYear = a.selectedYear - 1911 < 0 ? a.selectedYear + 1911 : a.selectedYear;
			a.drawYear = a.drawYear - 1911 < 0 ? a.drawYear + 1911 : a.drawYear;
			a.curreatYear = a.curreatYear - 1911 < 0 ? a.curreatYear + 1911 : a.curreatYear;
			return old_get.apply(this, [a, b]);
		},
		_updateDatepicker:function (inst) {
			old_CloseFn.call(this, inst);
			$(this).datepicker("widget").find(".ui-datepicker-buttonpane").children(":last")
				.click(function (e) {
				inst.input.val("");
			});
		},
		_setDateDatepicker: function (a, b) {
			if (a = this._getInst(a)) { this._setDate(a, b); this._updateDatepicker(a); this._updateAlternate(a) }
		},
		_widgetDatepicker: function () {
			return this.dpDiv
		}
	});
	*/
	$.datepicker.regional['zh-TW'] = {
		clearText: '清除', clearStatus: '清除已選日期',
		closeText: '關閉', closeStatus: '取消選擇',
		prevText: '<上一月', prevStatus: '顯示上個月',
		nextText: '下一月>', nextStatus: '顯示下個月',
		currentText: '今天', currentStatus: '顯示本月',
		monthNames: ['一月','二月','三月','四月','五月','六月',
		'七月','八月','九月','十月','十一月','十二月'],
		monthNamesShort: ['一','二','三','四','五','六',
		'七','八','九','十','十一','十二'],
		monthStatus: '選擇月份', yearStatus: '選擇年份',
		weekHeader: '周', weekStatus: '',
		dayNames: ['星期日','星期一','星期二','星期三','星期四','星期五','星期六'],
		dayNamesShort: ['周日','周一','周二','周三','周四','周五','周六'],
		dayNamesMin: ['日','一','二','三','四','五','六'],
		dayStatus: '設定每周第一天', dateStatus: '選擇 m月 d日, DD',
		dateFormat: 'yy-mm-dd', firstDay: 1, 
		initStatus: '請選擇日期', isRTL: false
	};
	$.datepicker.setDefaults($.datepicker.regional['zh-TW']);
});	//$(function () {

/**********將某個 input box 設為 datetime picker**********/
function setDatetimePicker(s){
	$('#' + s).datetimepicker({dateFormat: "yy/mm/dd", timeFormat: "HH:mm:ss", timeText: "時間", hourText: "時", minuteText: "分", secondText: "秒", currentText: "現在", closeText: "確定"});
}

/**********取得台灣的的縣市清單**********/
function getCountyList(){
	var ay=new Array('台北市','新北市','台中市','台南市','高雄市','基隆市','新竹市','嘉義市','桃園縣','新竹縣','苗栗縣','彰化縣','南投縣','雲林縣','嘉義縣','屏東縣','宜蘭縣','花蓮縣','台東縣','澎湖縣','金門縣','連江縣');
	var s = "";
	s += "<option value='' selected>請選擇</option>";
	for(var i in ay){
		s += "<option value='" + ay[i] + "'>" + ay[i] + "</option>";
	}
	return s;
}

/**********取得某縣市中的區域清單**********/
function getCityList(sCounty){
	//縣市資料來自WiKi：http://zh.wikipedia.org/wiki/%E4%B8%AD%E8%8F%AF%E6%B0%91%E5%9C%8B%E5%8F%B0%E7%81%A3%E5%9C%B0%E5%8D%80%E9%84%89%E9%8E%AE%E5%B8%82%E5%8D%80%E5%88%97%E8%A1%A8
	var d1 = 368;	//全國共368個鄉鎮市區
	var d2 = 2;
	var ay = new Array(d1);
	var i;
	var j;
	//初始化陣列
	for (i = 0 ; i < d1 ; i++) {
		ay[i] = new Array(d2);
	}
	var aa;
	i = 0;
	aa = new Array('松山區', '大安區', '大同區', '中山區', '內湖區', '南港區', '士林區', '北投區', '信義區', '中正區', '萬華區', '文山區');
	for (j=0; j<aa.length;j++){
		ay[i][0] = "台北市"; ay[i][1] = aa[j]; i++;
	}
	aa = new Array('板橋區', '三重區', '永和區', '中和區', '新莊區', '新店區', '土城區', '蘆洲區', '汐止區', '樹林區', '鶯歌區', '三峽區', '淡水區', '瑞芳區', '五股區', '泰山區', '林口區', '深坑區', '石碇區', '坪林區', '三芝區', '石門區', '八里區', '平溪區', '雙溪區', '貢寮區', '金山區', '萬里區', '烏來區');
	for (j=0; j<aa.length;j++){
		ay[i][0] = "新北市"; ay[i][1] = aa[j]; i++;
	}
	
	aa = new Array('中區', '東區', '南區', '西區', '北區', '北屯區', '西屯區', '南屯區', '太平區', '大里區', '霧峰區', '烏日區', '豐原區', '后里區', '東勢區', '石岡區', '新社區', '和平區', '神岡區', '潭子區', '大雅區', '大肚區', '龍井區', '沙鹿區', '梧棲區', '清水區', '大甲區', '外埔區', '大安區');
	for (j=0; j<aa.length;j++){
		ay[i][0] = "台中市"; ay[i][1] = aa[j]; i++;
	}

	aa = new Array('南區', '東區', '北區', '中西區', '安平區', '安南區', '永康區', '新營區', '鹽水區', '白河區', '麻豆區', '佳里區', '新化區', '善化區', '學甲區', '柳營區', '後壁區', '東山區', '下營區', '六甲區', '官田區', '大內區', '西港區', '七股區', '將軍區', '北門區', '安定區', '楠西區', '新市區', '山上區', '玉井區', '南化區', '左鎮區', '仁德區', '歸仁區', '關廟區', '龍崎區');
	for (j=0; j<aa.length;j++){
		ay[i][0] = "台南市"; ay[i][1] = aa[j]; i++;
	}
	
	aa = new Array('鹽埕區', '鼓山區', '左營區', '楠梓區', '三民區', '新興區', '前金區', '苓雅區', '前鎮區', '旗津區', '小港區', '鳳山區', '岡山區', '旗山區', '美濃區', '林園區', '大寮區', '大樹區', '仁武區', '大社區', '鳥松區', '橋頭區', '燕巢區', '田寮區', '阿蓮區', '路竹區', '湖內區', '茄萣區', '永安區', '彌陀區', '梓官區', '六龜區', '甲仙區', '杉林區', '內門區', '茂林區', '桃源區', '那瑪夏區');
	for (j=0; j<aa.length;j++){
		ay[i][0] = "高雄市"; ay[i][1] = aa[j]; i++;
	}
	
	aa = new Array('仁愛區', '中正區', '信義區', '中山區', '安樂區', '暖暖區', '七堵區');
	for (j=0; j<aa.length;j++){
		ay[i][0] = "基隆市"; ay[i][1] = aa[j]; i++;
	}
	
	aa = new Array('東區', '北區', '香山區');
	for (j=0; j<aa.length;j++){
		ay[i][0] = "新竹市"; ay[i][1] = aa[j]; i++;
	}
	
	aa = new Array('西區', '東區');
	for (j=0; j<aa.length;j++){
		ay[i][0] = "嘉義市"; ay[i][1] = aa[j]; i++;
	}
	
	aa = new Array('桃園市', '中壢市', '平鎮市', '八德市', '楊梅市', '大溪鎮', '蘆竹鄉', '大園鄉', '龜山鄉', '龍潭鄉', '新屋鄉', '觀音鄉', '復興鄉');
	for (j=0; j<aa.length;j++){
		ay[i][0] = "桃園縣"; ay[i][1] = aa[j]; i++;
	}
	
	aa = new Array('竹北市', '關西鎮', '新埔鎮', '竹東鎮', '湖口鄉', '橫山鄉', '新豐鄉', '芎林鄉', '寶山鄉', '北埔鄉', '峨眉鄉', '尖石鄉', '五峰鄉');
	for (j=0; j<aa.length;j++){
		ay[i][0] = "新竹縣"; ay[i][1] = aa[j]; i++;
	}
	
	aa = new Array('苗栗市', '苑裡鎮', '通霄鎮', '竹南鎮', '頭份鎮', '後龍鎮', '卓蘭鎮', '大湖鄉', '公館鄉', '銅鑼鄉', '南庄鄉', '頭屋鄉', '三義鄉', '西湖鄉', '造橋鄉', '三灣鄉', '獅潭鄉', '泰安鄉');
	for (j=0; j<aa.length;j++){
		ay[i][0] = "苗栗縣"; ay[i][1] = aa[j]; i++;
	}
	
	aa = new Array('彰化市', '鹿港鎮', '和美鎮', '北斗鎮', '員林鎮', '溪湖鎮', '田中鎮', '二林鎮', '線西鄉', '伸港鄉', '福興鄉', '秀水鄉', '花壇鄉', '芬園鄉', '大村鄉', '埔鹽鄉', '埔心鄉', '永靖鄉', '社頭鄉', '二水鄉', '田尾鄉', '埤頭鄉', '芳苑鄉', '大城鄉', '竹塘鄉', '溪州鄉');
	for (j=0; j<aa.length;j++){
		ay[i][0] = "彰化縣"; ay[i][1] = aa[j]; i++;
	}
	
	aa = new Array('南投市', '埔里鎮', '草屯鎮', '竹山鎮', '集集鎮', '名間鄉', '鹿谷鄉', '中寮鄉', '魚池鄉', '國姓鄉', '水里鄉', '信義鄉', '仁愛鄉');
	for (j=0; j<aa.length;j++){
		ay[i][0] = "南投縣"; ay[i][1] = aa[j]; i++;
	}
	
	aa = new Array('斗六市', '斗南鎮', '虎尾鎮', '西螺鎮', '土庫鎮', '北港鎮', '古坑鄉', '大埤鄉', '莿桐鄉', '林內鄉', '二崙鄉', '崙背鄉', '麥寮鄉', '東勢鄉', '褒忠鄉', '台西鄉', '元長鄉', '四湖鄉', '口湖鄉', '水林鄉');
	for (j=0; j<aa.length;j++){
		ay[i][0] = "雲林縣"; ay[i][1] = aa[j]; i++;
	}
	
	aa = new Array('太保市', '朴子市', '大林鎮', '布袋鎮', '民雄鄉', '溪口鄉', '新港鄉', '六腳鄉', '東石鄉', '義竹鄉', '鹿草鄉', '水上鄉', '中埔鄉', '竹崎鄉', '梅山鄉', '番路鄉', '大埔鄉', '阿里山鄉');
	for (j=0; j<aa.length;j++){
		ay[i][0] = "嘉義縣"; ay[i][1] = aa[j]; i++;
	}
	
	aa = new Array('屏東市', '潮州鎮', '東港鎮', '恆春鎮', '萬丹鄉', '長治鄉', '麟洛鄉', '九如鄉', '里港鄉', '鹽埔鄉', '高樹鄉', '萬巒鄉', '內埔鄉', '竹田鄉', '新埤鄉', '枋寮鄉', '新園鄉', '崁頂鄉', '林邊鄉', '南州鄉', '佳冬鄉', '琉球鄉', '車城鄉', '滿州鄉', '枋山鄉', '霧台鄉', '瑪家鄉', '泰武鄉', '來義鄉', '春日鄉', '獅子鄉', '牡丹鄉', '三地門鄉');
	for (j=0; j<aa.length;j++){
		ay[i][0] = "屏東縣"; ay[i][1] = aa[j]; i++;
	}
	
	aa = new Array('宜蘭市', '羅東鎮', '蘇澳鎮', '頭城鎮', '礁溪鄉', '壯圍鄉', '員山鄉', '冬山鄉', '五結鄉', '三星鄉', '大同鄉', '南澳鄉');
	for (j=0; j<aa.length;j++){
		ay[i][0] = "宜蘭縣"; ay[i][1] = aa[j]; i++;
	}
	
	aa = new Array('花蓮市', '鳳林鎮', '玉里鎮', '新城鄉', '吉安鄉', '壽豐鄉', '光復鄉', '豐濱鄉', '瑞穗鄉', '富里鄉', '秀林鄉', '卓溪鄉', '萬榮鄉');
	for (j=0; j<aa.length;j++){
		ay[i][0] = "花蓮縣"; ay[i][1] = aa[j]; i++;
	}
	
	aa = new Array('台東市', '成功鎮', '關山鎮', '卑南鄉', '大武鄉', '東河鄉', '長濱鄉', '鹿野鄉', '池上鄉', '綠島鄉', '延平鄉', '海端鄉', '達仁鄉', '金峰鄉', '蘭嶼鄉', '太麻里鄉');
	for (j=0; j<aa.length;j++){
		ay[i][0] = "台東縣"; ay[i][1] = aa[j]; i++;
	}
	
	aa = new Array('馬公市', '湖西鄉', '白沙鄉', '西嶼鄉', '望安鄉', '七美鄉');
	for (j=0; j<aa.length;j++){
		ay[i][0] = "澎湖縣"; ay[i][1] = aa[j]; i++;
	}
	
	aa = new Array('金城鎮', '金湖鎮', '金沙鎮', '金寧鄉', '烈嶼鄉', '烏坵鄉');
	for (j=0; j<aa.length;j++){
		ay[i][0] = "金門縣"; ay[i][1] = aa[j]; i++;
	}
	
	aa = new Array('南竿鄉', '北竿鄉', '莒光鄉', '東引鄉');
	for (j=0; j<aa.length;j++){
		ay[i][0] = "連江縣"; ay[i][1] = aa[j]; i++;
	}

	var s = "";
	s = "<option value='' selected>請選擇</option>";
	for (i = 0 ; i < d1 ; i++) {
		if (ay[i][0]==sCounty) s += "<option value='" + ay[i][1] + "'>" + ay[i][1] + "</option>";
	}
		
	return s;
}	//function getCityList(sCounty){


/**********取得目前登入使用者的ID Ethan Edit 2014.10.13**********/
function getLoginId(sFunctionName){
	//以下是執行AJAX要求server端處理資料
	$.ajax({
		url: "ajaxAdmGetLoginId.jsp",
		type: 'GET', //根據實際情況，可以是'POST'或者'GET'
		data: '',
		dataType: 'xml', //指定數據類型，注意server要有一行：response.setContentType("text/xml;charset=utf-8");
		timeout: 300000, //設置timeout時間，以千分之一秒為單位，1000 = 1秒
		error: function (){	//錯誤提示
		},
		success: function (xml){ //ajax請求成功後do something with xml
			var ResultCode = $(xml).find("ResultCode").text();
			var ResultText = $(xml).find("ResultText").text();
			if (ResultCode=='00000'){	//作業成功
				$('#FunctionName').text(sFunctionName);
				$('#LoginId').text($(xml).find("LoginId").text());
				var iRole = $(xml).find("LoginRole").text();
				
				/*
				由下方的選單，控制各角色能看到的功能
				if ((iRole!=1 && iRole!=2 && iRole!=9 && iRole!=3) || (sFunctionName=='訊息維護' && iRole==2) || (sFunctionName=='訊息簽核' && iRole==1) ||
						(sFunctionName=='權限設定' && iRole!=9)){
					alert("您無權使用此服務");
					location.href="index.html";
				}*/
				
//				目前使用者的權限等級配置
//				1 = 一般使用者:訊息管理->編輯訊息
//				2 = 主管:訊息管理->編輯訊息、訊息簽核
//				3 = 訊息管理->網路涵蓋圖管理
//				4 = 訊息管理->比一比資料管理、手機資料管理、比一比預設資料維護
//				5 = 推播通知服務
//				6 = 訊息管理->下拉選單管理、APP相關、黑白名單維護、調查相關
//				7 = 報表
//				9 = 系統管理者:完整功能
				var sMenuItem = "";
				var messageControl = {master:[], items:[], endToken:[]};//訊息控制
				var pushNotification = {master:[], items:[], endToken:[]};//推播通知
				var reportForm = {master:[], items:[], endToken:[]};//報表
				var valueAdded = {master:[], items:[], endToken:[]};//加值服務
				var systemSetting = {master:[], items:[], endToken:[]};//系統設定
				var roleResult = iRole.split(",").toString();

				sMenuItem = "<li><a href='#'>功能選擇</a><ul>";
				for (var i in roleResult) {
					switch (roleResult[i]) {
					case '1':
						itemChecker(messageControl.master, "<li><a href='#'>訊息管理</a><ul>", true);
						itemChecker(messageControl.items, "<li><a href='MessageQuery.html'>訊息維護</a></li>", false);
						itemChecker(messageControl.endToken, "</ul></li>", true);
						break;
						
					case '2':
						itemChecker(messageControl.master, "<li><a href='#'>訊息管理</a><ul>", true);
						itemChecker(messageControl.items, "<li><a href='MessageQuery.html'>訊息維護</a></li>", false);
						itemChecker(messageControl.items, "<li><a href='MessageQuery.html?action=a'>訊息簽核</a></li>", false);
						itemChecker(messageControl.endToken, "</ul></li>", true);
						break;
						
					case '3':
						itemChecker(messageControl.master, "<li><a href='#'>訊息管理</a><ul>", true);
						itemChecker(messageControl.items, "<li><a href='CoverageEdit.html'>網路涵蓋圖管理</a></li>", false);
						itemChecker(messageControl.endToken, "</ul></li>", true);
						break;
						
					case '4':
						itemChecker(messageControl.master, "<li><a href='#'>訊息管理</a><ul>", true);
						itemChecker(messageControl.items, "<li><a href='qryCompareData.action'>比一比資料管理</a></li>", false);
						itemChecker(messageControl.items, "<li><a href='queryCompareDevice.action'>比一比資料管理V2</a></li>", false);
						itemChecker(messageControl.items, "<li><a href='queryDevice.action'>手機資料管理</a></li>", false);
						itemChecker(messageControl.items, "<li><a href='queryMobileDevice.action'>手機資料管理V2</a></li>", false);
						itemChecker(messageControl.items, "<li><a href='presetCompare.action'>比一比預設資料維護</a></li>", false);
						itemChecker(messageControl.endToken, "</ul></li>", true);
						break;
						
					case '5':
						itemChecker(pushNotification.master, "<li><a href='#'>推播通知服務</a><ul>", true);
						itemChecker(pushNotification.items, "<li><a href='PushMessageSend.html'>推播通知發送</a></li>", false);
						itemChecker(pushNotification.items, "<li><a href='PushMessageQuery.html'>推播通知查詢</a></li>", false);
						itemChecker(pushNotification.items, "<li><a href='PushMessageUserQuery.html'>推播用戶查詢</a></li>", false);
						itemChecker(pushNotification.endToken, "</ul></li>", true);
						break;
						
					case '6':
						itemChecker(messageControl.master, "<li><a href='#'>訊息管理</a><ul>", true);
						itemChecker(messageControl.items, "<li><a href='selectListMtn.action'>下拉選單管理</a></li>", false);
						itemChecker(messageControl.items, "<li><a href='queryApp.action'>APP資訊維護</a></li>", false);
						itemChecker(messageControl.items, "<li><a href='queryDevice.action'>手機資料管理</a></li>", false);
						itemChecker(messageControl.items, "<li><a href='comRefConditon.action'>APP資料來源查詢</a></li>", false);
						itemChecker(messageControl.items, "<li><a href='bwListCondition.action'>黑白名單維護</a></li>", false);
						itemChecker(messageControl.items, "<li><a href='surveyQueryForm.action'>調查問卷維護</a></li>", false);
						itemChecker(messageControl.items, "<li><a href='queryFormdataCondition.action'>調查表單維護</a></li>", false);
						itemChecker(messageControl.endToken, "</ul></li>", true);
						break;
						
					case '7':
						itemChecker(reportForm.master, "<li><a href='#'>報表</a><ul>", true);
						itemChecker(reportForm.items, "<li><a href='comRefReport.action'>雪豹</a></li>", false);
						itemChecker(reportForm.endToken, "</ul></li>", true);
						break;
						
					case '8':
						break;

					case '9':
						itemChecker(messageControl.master, "<li><a href='#'>訊息管理</a><ul>", true);
						itemChecker(messageControl.items, "<li><a href='MessageQuery.html'>訊息維護</a></li>", false);
						itemChecker(messageControl.items, "<li><a href='MessageQuery.html?action=a'>訊息簽核</a></li>", false);
						itemChecker(messageControl.items, "<li><a href='CoverageEdit.html'>網路涵蓋圖管理</a></li>", false);
						itemChecker(messageControl.items, "<li><a href='qryCompareData.action'>比一比資料管理</a></li>", false);
						itemChecker(messageControl.items, "<li><a href='queryCompareDevice.action'>比一比資料管理V2</a></li>", false);
						itemChecker(messageControl.items, "<li><a href='queryDevice.action'>手機資料管理</a></li>", false);
						itemChecker(messageControl.items, "<li><a href='queryMobileDevice.action'>手機資料管理V2</a></li>", false);
						itemChecker(messageControl.items, "<li><a href='presetCompare.action'>比一比預設資料維護</a></li>", false);
						itemChecker(messageControl.items, "<li><a href='selectListMtn.action'>下拉選單管理</a></li>", false);
						itemChecker(messageControl.items, "<li><a href='queryApp.action'>APP資訊維護</a></li>", false);
						itemChecker(messageControl.items, "<li><a href='comRefConditon.action'>APP資料來源查詢</a></li>", false);
						itemChecker(messageControl.items, "<li><a href='bwListCondition.action'>黑白名單維護</a></li>", false);
						itemChecker(messageControl.items, "<li><a href='surveyQueryForm.action'>調查問卷維護</a></li>", false);
						itemChecker(messageControl.items, "<li><a href='queryFormdataCondition.action'>調查表單維護</a></li>", false);
						itemChecker(messageControl.endToken, "</ul></li>", true);
						
						itemChecker(pushNotification.master, "<li><a href='#'>推播通知服務</a><ul>", true);
						itemChecker(pushNotification.items, "<li><a href='PushMessageSend.html'>推播通知發送</a></li>", false);
						itemChecker(pushNotification.items, "<li><a href='PushMessageQuery.html'>推播通知查詢</a></li>", false);
						itemChecker(pushNotification.items, "<li><a href='PushMessageUserQuery.html'>推播用戶查詢</a></li>", false);
						itemChecker(pushNotification.endToken, "</ul></li>", true);
						
						itemChecker(reportForm.master, "<li><a href='#'>報表</a><ul>", true);
						itemChecker(reportForm.items, "<li><a href='comRefReport.action'>雪豹</a></li>", false);
						itemChecker(reportForm.endToken, "</ul></li>", true);
						
						itemChecker(valueAdded.master, "<li><a href='#'>加值服務</a><ul>", true);
						itemChecker(valueAdded.items, "<li><a href='VASServiceContentCategoryQuery.html'>加值內容類別維護</a></li>", false);
						itemChecker(valueAdded.items, "<li><a href='VASServiceContentServiceQuery.html'>加值內容服務維護</a></li>", false);
						itemChecker(valueAdded.items, "<li><a href='VASServiceBasicQuery.html'>加值基本服務維護</a></li>", false);
						itemChecker(valueAdded.endToken, "</ul></li>", true);
						
						itemChecker(systemSetting.master, "<li><a href='#'>系統設定</a><ul>", true);
						itemChecker(systemSetting.items, "<li><a href='ServiceProfileQuery.html'>服務資料維護</a></li>", false);
						itemChecker(systemSetting.items, "<li><a href='AccountSetting.html'>權限設定</a></li>", false);
						itemChecker(systemSetting.endToken, "</ul></li>", true);
						break;
					}
				}
				sMenuItem = menuCreater(sMenuItem, messageControl);
				sMenuItem = menuCreater(sMenuItem, pushNotification);
				sMenuItem = menuCreater(sMenuItem, reportForm);
				sMenuItem = menuCreater(sMenuItem, valueAdded);
				sMenuItem = menuCreater(sMenuItem, systemSetting);
				sMenuItem += "<li><a href='#' onclick='doLogout();'>登出</a></li>";
				sMenuItem += "</ul></li>";
				
				$('#mainmenuitem').html(sMenuItem);
				$( "#mainmenuitem" ).menu();
			}else{
				alert("網頁閒置過久，請重新登入!!");
				location.href="index.html";
			}	//if (ResultCode=='00000'){	//作業成功
		}	//success: function (xml){ //ajax請求成功後do something with xml
	});	//$.ajax({
	//以上是執行AJAX要求server端處理資料
	return false;
};

//判斷字元
function isContains(roleArray, role) {
	for(i = 0; i < roleArray.length; i++){
		if(9 == roleArray[i]){
			return 9;
		}else if(role == roleArray[i]){
			return role;
		}
	}
	return null; 
};

/**********登出作業**********/
function doLogout(){
	showBlockUI();
	//以下是執行AJAX要求server端處理資料
	$.ajax({
		url: "ajaxAdmDoLogout.jsp",
		type: 'GET', //根據實際情況，可以是'POST'或者'GET'
		data: '',
		dataType: 'xml', //指定數據類型，注意server要有一行：response.setContentType("text/xml;charset=utf-8");
		timeout: 300000, //設置timeout時間，以千分之一秒為單位，1000 = 1秒
		error: function (){	//錯誤提示
			unBlockUI();
			alert ('系統忙碌中，請稍候再試!!');
		},
		success: function (xml){ //ajax請求成功後do something with xml
			unBlockUI();
			var ResultCode = $(xml).find("ResultCode").text();
			var ResultText = $(xml).find("ResultText").text();
			if (ResultCode=='00000'){	//作業成功
				_gaq.push(['_trackEvent', '使用者登出', 'Success', $('#LoginId').text()]);	//紀錄至Google Analytics
				//setTimeout('location.href="index.html"', 1000);
				location.href="index.html";
			}else{
				alert(ResultText);
			}	//if (ResultCode=='<%=gcResultCodeSuccess%>'){	//作業成功
		}	//success: function (xml){ //ajax請求成功後do something with xml
	});	//$.ajax({
	//以上是執行AJAX要求server端處理資料
	return false;
}

//判斷項目容器中是否有重複的項目
function itemChecker(items, addItem, isMasterOrEndToken){
	if(isMasterOrEndToken){
		if(items.length == 0){
			items.push(addItem);
		}else{
			return;
		}
	}else{
		if(items.length == 0){
			items.push(addItem);
		}else{
			for(var x = 0; x < items.length; x++){
				if(items[x] == addItem){
					return;
				}else if(x == items.length-1){
					items.push(addItem);
				}
			}
		}
	}
};

//產生主項目與子項目
function menuCreater(menu, master){
	if(master.master.length == 0){
		return menu;
	}else{
		menu += master.master[0];
		for(var x in master.items){
			menu += master.items[x];
		}
		menu += master.endToken[0];
		return menu;
	}
}