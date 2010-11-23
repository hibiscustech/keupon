
/* Main Menu   -----------------------------------------------------------*/

jQuery(document).ready(function(){

/* k menu  */
	k_menu(); // controls the dropdown menu
	sys_toggle();


});


function k_menu()
{
	// k_menu controlls the dropdown menus and improves them with javascript
	
	jQuery(".nav a").removeAttr('title');
	jQuery(" .nav ul ").css({display: "none"}); // Opera Fix

	
	//smooth drop downs
	jQuery(".nav li").each(function()
	{	
		
		var $sublist = jQuery(this).find('ul:first');
		
		jQuery(this).hover(function()
		{	
			$sublist.stop().css({overflow:"hidden", height:"auto", display:"none", paddingTop:0}).slideDown(400, function()
			{
				jQuery(this).css({overflow:"visible", height:"auto"});
			});	
		},
		function()
		{	
			$sublist.stop().slideUp(400, function()
			{	
				jQuery(this).css({overflow:"hidden", display:"none"});
			});
		});	
	});
}

/* jQuery Toggle   -----------------------------------------------------------*/

function sys_toggle() {
	jQuery(".toggle_content").hide(); 

	jQuery("h4.toggle").toggle(function(){
		jQuery(this).addClass("active");
		}, function () {
		jQuery(this).removeClass("active");
	});

	jQuery("h4.toggle").click(function(){
		jQuery(this).next(".toggle_content").slideToggle();
	});
}



/* Plan box -----------------------------------------------------------*/
$(document).ready(function(){
//To switch directions up/down and left/right just place a "-" in front of the top/left attribute
//Vertical Sliding
$('.plan_box').hover(function(){
	$(".plan_info", this).stop().animate({top:'-400px'},{queue:false,duration:300});
	}, function() {
	$(".plan_info", this).stop().animate({top:'0px'},{queue:false,duration:300});
	});
});


/* Tabs Slideshow   -----------------------------------------------------------*/




/* Functins CallBack  -----------------------------------------------------------*/

$(window).load(function() {	
		$('ul.social li a').tipsy({gravity: 's'});

});