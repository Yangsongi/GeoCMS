/* =========================================================
// jquery.panorama.js
// Author: OpenStudio (Arnault PACHOT)
// Mail: apachot@openstudio.fr
// Web: http://www.openstudio.fr
// Copyright (c) 2008 Arnault Pachot
// licence : GPL
========================================================= */
(function($) {
	$.fn.panorama = function(options) {
		this.each(function(){ 
			var settings = {
				views_number: 300,
				views_columns: 20
			};
			var pano_element = this;
			var orig_src = $(this).attr("src");
			var loaded = 0;
			var pano_mouse_position_x;
			var pano_mouse_position_y;
			var pano_mouse_delta_x = 0;
			var pano_mouse_delta_y = 0;
			var pano_mouse_down = false;
			var pano_current_number; 
			var pano_timer;
			var pano_loading_stop = false;
			var pano_width = parseInt($(pano_element).attr("width"));
			pano_mouse_position_x = parseInt(pano_width/2);
			var pano_height = parseInt($(pano_element).attr("height"));
			pano_mouse_position_y = parseInt(pano_height/2);
			$(pano_element).css("margin", "0 0 0 0").css("padding", "0 0 0 0").wrap('<div class="panorama" style="position: relative; margin: 0; padding: 0; background: black; height: '+pano_height+'px; width: '+pano_width+'px; overflow: hidden;"></div>');
			if(options) $.extend(settings, options);
			$(pano_element).after('<a class="pano_loading_stop" href="#" style="display: none; color: white; position: absolute; top: 5px; right: 5px; text-decoration: none;">[stop]</a><p class="pano_loading_percent" style="position: absolute; display: none; top: '+parseInt(pano_height/2-45)+'px; left: '+parseInt(pano_width/2-100)+'px; padding: 0; text-align: center; border: 2px solid white; background: #ff6600; opacity: .8; filter:alpha(opacity=80); color: white; width: 200px;"><img class="pano_loading_animation" src="circle_animation.gif" width="50" height="50" style="vertical-align: middle;"/> <span>Loading...</span></p>');
			
			var src_prefix = orig_src.substr(0, orig_src.indexOf('_',0)+1);
			var src_number = parseInt(orig_src.substr(orig_src.indexOf('_',0)+1));
			pano_current_number = src_number;
			var src_sufix = orig_src.substr(orig_src.indexOf(src_number,0)+String(src_number).length);
			$(pano_element).after('<p class="pano_loading_start" style="position: absolute; top: '+parseInt(pano_height/2-50)+'px; left: '+parseInt(pano_width/2-50)+'px; padding: 20px; border: 2px solid white; background: #ff6600; opacity: .8; filter:alpha(opacity=80); color: white;"><a href="#" style="color: white; text-decoration: none;">START</a></p>');
			$(pano_element).after('<div class="pano_loading_masque" style="position: absolute; top: 0; left: 0; width: '+pano_width+'px; height: '+pano_height+'px; background: black; opacity: .5; filter:alpha(opacity=50);"></div>');
			$(pano_element).parent().find(".pano_loading_stop").bind('click', function(){
				pano_loading_stop = true;
				return false;
			});
			$(pano_element).parent().find(".pano_loading_start a").bind('click', function(){
				$(pano_element).parent().css("cursor", "wait");
				$(pano_element).parent().find(".pano_loading_start").hide();
				$(pano_element).parent().find(".pano_loading_percent").show();
				$(pano_element).parent().find(".pano_loading_animation").show();
				$(pano_element).parent().find(".pano_vues").remove();
				pano_timer = setTimeout(function(){
				    clearTimeout(pano_timer); 
				    for (var i=0; i<settings.views_number; i++) {
					if (i!=src_number){
					 $(pano_element).after('<img class="pano_vues vue'+i+'" src="'+src_prefix+i+src_sufix+'" style="visibility: hidden;" />');
					 $(pano_element).parent().find("img.vue"+i).bind('load', function(){
						if ($(pano_element).parent().find(".pano_loading_stop").css("display")=="none") $(pano_element).parent().find(".pano_loading_stop").show();

						loaded++; 
						if (pano_loading_stop) {
							pano_loading_stop=false;
							$(pano_element).parent().find(".pano_loading_stop").hide();
							$(pano_element).parent().css("cursor", "default");
							$(pano_element).parent().find(".pano_loading_percent").hide();
							$(pano_element).parent().find(".pano_loading_start").show();
							$(pano_element).parent().find(".pano_loading_percent span").html('loading...');
							pano_timer = setTimeout(function(){
				   				 clearTimeout(pano_timer); window.stop();
							});
							
						}
						//if (loaded >= (settings.views_number-1)) {
						if (parseInt((loaded/settings.views_number)*100) > 90) {
						$(pano_element).parent().css("cursor", "pointer"); 
							$(pano_element).parent().find(".pano_loading_stop").hide();
							$(pano_element).parent().find(".pano_loading_percent").hide();
							$(pano_element).parent().find(".pano_loading_animation").hide();
							$(pano_element).parent().find(".pano_loading_masque").hide();
							$(pano_element).bind('mousedown', function(e){
								pano_mouse_down = true;
								pano_mouse_position_x = e.clientX;
								pano_mouse_position_y = e.clientY;
								$(pano_element).parent().css("cursor", "move"); 
								return false;
							});
							$(pano_element).bind('mouseup', function(){
								pano_mouse_down = false;
								$("div.panorama").css("cursor", "pointer"); 
								return false;
							}); 
							$(pano_element).bind('mousemove', function(e){
      								if (pano_mouse_down) {
									pano_mouse_delta_x = parseInt((pano_mouse_position_x - e.clientX)/20);
									pano_mouse_delta_y = parseInt((pano_mouse_position_y - e.clientY)/20);
									if (pano_mouse_delta_x!=0||pano_mouse_delta_y!=0) {
										var pageCoords = "( " + e.pageX + ", " + e.pageY + " )";
      										var clientCoords = "( " + e.clientX + ", " + e.clientY + " )";
    										//src_number1=parseInt((settings.views_columns/pano_width)*pano_mouse_delta_x);
		
										//src_number=pano_current_number+src_number1+settings.views_number-settings.views_columns*parseInt(-5+((settings.views_number/settings.views_columns)/pano_height)*pano_mouse_delta_y);
										pano_current_number=pano_current_number-pano_mouse_delta_x+settings.views_columns*pano_mouse_delta_y;
										if (pano_current_number<0)
											pano_current_number = 0;
										if (pano_current_number>(settings.views_number-1))
											pano_current_number = settings.views_number-1;
										$(pano_element).attr('src', src_prefix+pano_current_number+src_sufix);
										pano_mouse_position_x= e.clientX;
										pano_mouse_position_y= e.clientY;
									}
									
								}
								return false;											 				
							});
						}
						else {
							$(pano_element).parent().find(".pano_loading_percent span").html('loading...'+parseInt((loaded/settings.views_number)*100)+' % done.');
						}
						
					
					 });
					}
					
				}
				}, 500);
				
				return false;
				
			});

		});
	};
	

$(document).ready(function(){
	$("img.panorama").panorama();
});
})(jQuery);