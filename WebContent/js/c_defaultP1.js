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