jQuery(document).ready(function()
{	  	
	if (jQuery('.slider_item').length > 0 )jQuery('#slideh').picco();  	
});

   
(function($)
{ 
	$.fn.picco = function() 
	{
		var defaultvalue = 
		{  
			duration:600, 					 
			transition:"easeInOutCubic", 	
			o1:0.6,
			o2:0,
			timer: 5000			
		};  
		
 		return this.each(function()
		{	
			var $container = $(this), $items = $container.find('.slider_item'), $values = [], $zindex = [], $offset = 0, $animating = false, $clicked=false;
			
			var timer = setInterval(function(){}, 50000); 
			
			jQuery(window).load(function(){
				if(defaultvalue.timer && !$clicked )
					{
						timer = setInterval(function() { slide(1); }, defaultvalue.timer); 
					}
				});
		
 			if (defaultvalue.o1 != 1 && defaultvalue.o2 != 1)
			{	$items.not('.sliderh1').css('opacity', defaultvalue.o2);
				$container.find('.sliderh1').css('opacity', 1);
				$container.find('.sliderh5, .sliderh2').css('opacity', defaultvalue.o1);	
				$container.find('.sliderh5 h3, .sliderh2 h3').css('opacity', 0);
				$container.find('.sliderh5 p, .sliderh2 p').css('opacity', 0);
			}
			
 			$items.each(function(i)
			{	
				var $item = $(this);
				 
				$values[i]= {
					width: $item.width(),
					top: parseInt($item.css('top')),
					left: parseInt($item.css('left')),
					opacity: $item.css('opacity')
				};
							
				$zindex[i] =	$item.css('zIndex');
							
			});  
			
			
			$items.click(function(e)
			{	
				if (! $animating)
				{	
					$direction = e.pageX > $(window).width() / 2 ? -1 : 1;
					slide($direction);
				}
				clearInterval(timer);
				$clicked = true;
			});  
			
			
			$('.left').click(function(e)
			{	
				slide(1);
 				clearInterval(timer);
 			});  
			
			
			$('.right').click(function(e)
			{	
				slide(-1);
 				clearInterval(timer);
 			});  
			
			
			function slide($direction)
			{	
				if ($items.length <= 2) return;
				$animating = true;
				

				if($items.length == $offset || $items.length == ($offset*-1))
				{
					$offset = 1 * $direction;
				}
				else
				{
					$offset = $offset + $direction;
				}
								
				
 				$items.each(function(i)
				{	
					var $item = $(this), $next;
					
					$next = i + $offset;
					
						if($next >= $items.length)
						{
							$next = i - $items.length + $offset;
						}
						else if($next < 0)
						{
							$next = i + $items.length + $offset;
						}
					
 					$item.animate($values[$next], defaultvalue.duration, defaultvalue.transition);
					$item.find("img").animate({width:$values[$next].width}, defaultvalue.duration, defaultvalue.transition, function()
					{
						$animating = false;
					});
  					
					if ( $values[$next].width > 250) $item.find("h3").animate({opacity:1}, 400, defaultvalue.transition);
					else                             $item.find("h3").animate({opacity:0}, 200, defaultvalue.transition);
					
					if ( $values[$next].width > 250) $item.find("p").animate({opacity:1}, 400, defaultvalue.transition);
					else                             $item.find("p").animate({opacity:0}, 200, defaultvalue.transition);
					
					
					setTimeout(function()
					{
        				$item.css({zIndex: $zindex[$next]});
    				}, defaultvalue.duration / 2);
    				
				});
			} 
		});	
	};
})(jQuery); 








/*
 * jQuery Easing v1.3 - http://gsgd.co.uk/sandbox/jquery/easing/
*/

// t: current time, b: begInnIng value, c: change In value, d: duration
jQuery.easing['jswing'] = jQuery.easing['swing'];

jQuery.extend( jQuery.easing,
{
	defaultvalue: 'easeOutQuad',
	swing: function (x, t, b, c, d) {
		//alert(jQuery.easing.default);
		return jQuery.easing[jQuery.easing.defaultvalue](x, t, b, c, d);
	},
	easeInQuad: function (x, t, b, c, d) {
		return c*(t/=d)*t + b;
	},
	easeOutQuad: function (x, t, b, c, d) {
		return -c *(t/=d)*(t-2) + b;
	},
	easeInOutQuad: function (x, t, b, c, d) {
		if ((t/=d/2) < 1) return c/2*t*t + b;
		return -c/2 * ((--t)*(t-2) - 1) + b;
	},
	easeInCubic: function (x, t, b, c, d) {
		return c*(t/=d)*t*t + b;
	},
	easeOutCubic: function (x, t, b, c, d) {
		return c*((t=t/d-1)*t*t + 1) + b;
	},
	easeInOutCubic: function (x, t, b, c, d) {
		if ((t/=d/2) < 1) return c/2*t*t*t + b;
		return c/2*((t-=2)*t*t + 2) + b;
	},
	easeInQuart: function (x, t, b, c, d) {
		return c*(t/=d)*t*t*t + b;
	},
	easeOutQuart: function (x, t, b, c, d) {
		return -c * ((t=t/d-1)*t*t*t - 1) + b;
	},
	easeInOutQuart: function (x, t, b, c, d) {
		if ((t/=d/2) < 1) return c/2*t*t*t*t + b;
		return -c/2 * ((t-=2)*t*t*t - 2) + b;
	},
	easeInQuint: function (x, t, b, c, d) {
		return c*(t/=d)*t*t*t*t + b;
	},
	easeOutQuint: function (x, t, b, c, d) {
		return c*((t=t/d-1)*t*t*t*t + 1) + b;
	},
	easeInOutQuint: function (x, t, b, c, d) {
		if ((t/=d/2) < 1) return c/2*t*t*t*t*t + b;
		return c/2*((t-=2)*t*t*t*t + 2) + b;
	},
	easeInSine: function (x, t, b, c, d) {
		return -c * Math.cos(t/d * (Math.PI/2)) + c + b;
	},
	easeOutSine: function (x, t, b, c, d) {
		return c * Math.sin(t/d * (Math.PI/2)) + b;
	},
	easeInOutSine: function (x, t, b, c, d) {
		return -c/2 * (Math.cos(Math.PI*t/d) - 1) + b;
	},
	easeInExpo: function (x, t, b, c, d) {
		return (t==0) ? b : c * Math.pow(2, 10 * (t/d - 1)) + b;
	},
	easeOutExpo: function (x, t, b, c, d) {
		return (t==d) ? b+c : c * (-Math.pow(2, -10 * t/d) + 1) + b;
	},
	easeInOutExpo: function (x, t, b, c, d) {
		if (t==0) return b;
		if (t==d) return b+c;
		if ((t/=d/2) < 1) return c/2 * Math.pow(2, 10 * (t - 1)) + b;
		return c/2 * (-Math.pow(2, -10 * --t) + 2) + b;
	},
	easeInCirc: function (x, t, b, c, d) {
		return -c * (Math.sqrt(1 - (t/=d)*t) - 1) + b;
	},
	easeOutCirc: function (x, t, b, c, d) {
		return c * Math.sqrt(1 - (t=t/d-1)*t) + b;
	},
	easeInOutCirc: function (x, t, b, c, d) {
		if ((t/=d/2) < 1) return -c/2 * (Math.sqrt(1 - t*t) - 1) + b;
		return c/2 * (Math.sqrt(1 - (t-=2)*t) + 1) + b;
	},
	easeInElastic: function (x, t, b, c, d) {
		var s=1.70158;var p=0;var a=c;
		if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
		if (a < Math.abs(c)) { a=c; var s=p/4; }
		else var s = p/(2*Math.PI) * Math.asin (c/a);
		return -(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
	},
	easeOutElastic: function (x, t, b, c, d) {
		var s=1.70158;var p=0;var a=c;
		if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
		if (a < Math.abs(c)) { a=c; var s=p/4; }
		else var s = p/(2*Math.PI) * Math.asin (c/a);
		return a*Math.pow(2,-10*t) * Math.sin( (t*d-s)*(2*Math.PI)/p ) + c + b;
	},
	easeInOutElastic: function (x, t, b, c, d) {
		var s=1.70158;var p=0;var a=c;
		if (t==0) return b;  if ((t/=d/2)==2) return b+c;  if (!p) p=d*(.3*1.5);
		if (a < Math.abs(c)) { a=c; var s=p/4; }
		else var s = p/(2*Math.PI) * Math.asin (c/a);
		if (t < 1) return -.5*(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
		return a*Math.pow(2,-10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )*.5 + c + b;
	},
	easeInBack: function (x, t, b, c, d, s) {
		if (s == undefined) s = 1.70158;
		return c*(t/=d)*t*((s+1)*t - s) + b;
	},
	easeOutBack: function (x, t, b, c, d, s) {
		if (s == undefined) s = 1.70158;
		return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
	},
	easeInOutBack: function (x, t, b, c, d, s) {
		if (s == undefined) s = 1.70158; 
		if ((t/=d/2) < 1) return c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b;
		return c/2*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b;
	},
	easeInBounce: function (x, t, b, c, d) {
		return c - jQuery.easing.easeOutBounce (x, d-t, 0, c, d) + b;
	},
	easeOutBounce: function (x, t, b, c, d) {
		if ((t/=d) < (1/2.75)) {
			return c*(7.5625*t*t) + b;
		} else if (t < (2/2.75)) {
			return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
		} else if (t < (2.5/2.75)) {
			return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
		} else {
			return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
		}
	},
	easeInOutBounce: function (x, t, b, c, d) {
		if (t < d/2) return jQuery.easing.easeInBounce (x, t*2, 0, c, d) * .5 + b;
		return jQuery.easing.easeOutBounce (x, t*2-d, 0, c, d) * .5 + c*.5 + b;
	}
});