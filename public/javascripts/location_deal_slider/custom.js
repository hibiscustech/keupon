function dropdown_menu()
{
	jQuery("#nav a, .subnav a");
	jQuery(" #nav ul ").css({display: "none", opacity:"0.90"}); // fix for opera browser
	
	jQuery("#nav li").each(function()
	{	
		
		var $sublist = jQuery(this).find('ul:first');
		
		jQuery(this).hover(function()
		{	
			$sublist.stop().css({overflow:"hidden", height:"auto", display:"none"}).slideDown(200, function()
			{
				jQuery(this).css({overflow:"visible", height:"auto"});
			});	
		},
		function()
		{	
			$sublist.stop().slideUp(250, function()
			{	
				jQuery(this).css({overflow:"hidden", display:"none"});
			});
		});	
	});
}











