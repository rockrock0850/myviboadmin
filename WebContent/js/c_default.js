(document.all)?window.attachEvent('onload',windowOnload):window.addEventListener('load',windowOnload,false);

function windowOnload(){
		var transformProperty = ['transform','WebkitTransform','MozTransform','OTransform','msTransform'];
		var supportNumber = null;
		for(var i=0; i<transformProperty.length; i++){
			if(document.body.style[transformProperty[i]] === ''){
				supportNumber = i;
				break;
			}
		}
		
		var defaultWidth = 320;
		var bodyHeight = document.body.clientHeight;
		function resizeContent(){
			var winWidth = document.body.clientWidth;
			var docRatio = winWidth/defaultWidth;
			document.body.style.height = bodyHeight*docRatio+'px';
			document.getElementsByClassName('main_doc')[0].style[transformProperty[supportNumber]] = 'scale('+docRatio+', '+docRatio+')';
		}
		resizeContent();
		window.onresize = function(){
			resizeContent();
		}
}
$(function(){
	$('.t_height').eq(0).prev().find('td, th').css({'border-bottom':'2px solid #303030'});
	
	/*tab功能*/
	$('[tab-target] > *').hide();
	var tab_triggers = $('[tab-switch] > *');
	tab_triggers.each(function(){
		if($(this).is('.active')){
			var tab_attr = $(this).parent().attr('tab-switch');
			var index = $(this).index();
			var tab_target = $('[tab-target='+tab_attr +']');
			tab_target.find('> *').eq(index).show();
		}
	});
	tab_triggers.click(function(){
		var tab_attr = $(this).parent().attr('tab-switch');
		var index = $(this).index();
		var tab_target = $('[tab-target='+tab_attr +']');
		$(this).parent().find('> *').removeClass('active');
		$(this).addClass('active');
		tab_target.find('> *').hide();
		tab_target.find('> *').eq(index).show();
		$('body').css({'height':'auto'});
	});
	
	/*資費試算-切換手機專案價or單門號*/
	/*
	$('body').click(function(){
		if($('#w_p').is(':checked')){
			$('.with_phone').show();
			$('.without_phone').hide();
		}else if($('#w_o_p').is(':checked')){
			$('.without_phone').show();
			$('.with_phone').hide();
		}
	});*/
	
});