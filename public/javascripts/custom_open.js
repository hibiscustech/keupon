/*///////////////// CUFON IMAGE REPLACEMENT /////////////////////////*/	
	Cufon.replace('h1');
	Cufon.replace('h2');
	Cufon.replace('h3');
	Cufon.replace('h4');
	Cufon.replace('h5');
/*///////////////// END CUFON IMAGE REPLACEMENT /////////////////////////*/		
/*///////////////// LOOP SLIDER /////////////////////////*/
$(function(){
		$('#loopedSlider').loopedSlider({
			autoStart: 8000,
			restart: 3000,
			containerClick: false,
			slidespeed: 300
	});
});
/*///////////////// END LOOP SLIDER /////////////////////////*/

/*///////////////// PRODUCTS OVER EFFECT /////////////////////////*/
$(function(){
	$("#portfolio-list").delegate("li a img", "mouseover mouseout", function(e) {
		if (e.type == 'mouseover') {
		$("#portfolio-list li a img").not(this).dequeue().animate({opacity: "0.3"}, 300);
		} else {
		$("#portfolio-list li a img").not(this).dequeue().animate({opacity: "1"}, 300);
		}
	});
});
/*///////////////// END PRODUCTS OVER EFFECT /////////////////////////*/

/*///////////////// FANCYBOX /////////////////////////*/
$(document).ready(function() {
	$("a[rel=example_group]").fancybox({
		'transitionIn'	:	'elastic',
		'transitionOut'	:	'elastic',
		'speedIn'		:	300, 
		'speedOut'		:	200, 
		'overlayShow'	:	true,
		'titlePosition' 	: 'over'

	});
});
/*///////////////// END FANCYBOX /////////////////////////*/

/*///////////////// BEGIN RESET SEARCH BOX /////////////////////////*/
$(function() {
	$('input.field').resetDefaultValue(); // for some elements
});
/*///////////////// END RESET SEARCH BOX /////////////////////////*/