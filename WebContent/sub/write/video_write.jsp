<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<jsp:include page="../../page_common.jsp"></jsp:include>

<%
String file_url = request.getParameter("file_url");
%>

<script type="text/javascript">

/* init_start ----- 초기 설정 ------------------------------------------------------------ */
var full_url = '<%= file_url %>';

$(function() {
	//저작 버튼 설정
	$('.caption_button').button({ icons: { primary: 'ui-icon-grip-dotted-horizontal'} }); $('.caption_button').width(100); $('.caption_button').height(30); $('.caption_button').css('fontSize', 12); $('.caption_button').css('margin-top', 5); $('.caption_button').css('margin-left', 5); $('.caption_button').css('margin-bottom', 5);	
	$('.speech_bubble_button').button({ icons: { primary: 'ui-icon-comment'} }); $('.speech_bubble_button').width(140); $('.speech_bubble_button').height(30); $('.speech_bubble_button').css('fontSize', 12);
	$('.icon_button').button({ icons: { primary: 'ui-icon-heart'} }); $('.icon_button').width(100); $('.icon_button').height(30); $('.icon_button').css('fontSize', 12);	
	$('.geometry_button').button({ icons: { primary: 'ui-icon-geometry'} }); $('.geometry_button').width(100); $('.geometry_button').height(30); $('.geometry_button').css('fontSize', 12);
	$('.analysis_button').button({ icons: { primary: 'ui-icon-note'} }); $('.analysis_button').width(100); $('.analysis_button').height(30); $('.analysis_button').css('fontSize', 12);	
	$('.save_button').button({ icons: { primary: 'ui-icon-disk'}, text: false }); $('.save_button').width(30); $('.save_button').height(30);
	$('.exit_button').button({ icons: { primary: 'ui-icon-closethick'}, text: false }); $('.exit_button').width(30); $('.exit_button').height(30);

	//프레임 라인 설정
	$('.frame_plus').button({ icons: { primary: 'ui-icon-plusthick'}, text: false });
	$('.frame_minus').button({ icons: { primary: 'ui-icon-minusthick'}, text: false });

	//프레임 가이드 zindex 설정
	$('#video_guide').maxZIndex({inc:1});
	//지도 zindex 설정
	$('#video_map_area').maxZIndex({inc:1});
	
	//저장 버튼 설정
	$('.save_dialog').dialog({
		autoOpen: false,
		width: 'auto',
		modal: true
	});

	//비디오 플레이어 이벤트 설정
	$("#video_player").bind("timeupdate", function() {
		timeUpdate(parseInt(this.currentTime), parseInt(this.duration));
	});
});

/* init_start ----- 비디오 소스 설정 ------------------------------------- */
function videoWriteInit() {
	//비디오 설정
	changeVideo();
	//프레임 설정
	createFrameLine(1);
	createObjLine();
	//GPX or KML 데이터 설정
	loadGPS(full_url);
	//XML 데이터 설정
	loadXML(full_url);
}

function changeVideo() {
	var video = document.getElementById('video_player');
	video.src = full_url;
	video.load();
}

/* map_start ----------------------------------- 맵 설정 ------------------------------------- */
var gps_size;
function loadGPS(full_url) {
	var buf = full_url.split('.');
	var file_name = '';
	for(var i=0; i<buf.length-1; i++) {
		if(i==buf.length-2) file_name += buf[i] + '.gpx';
		else file_name += buf[i] + '.';
	}
	var lat_arr = new Array(); var lng_arr = new Array();
	$.ajax({
		type: "GET",
		url: file_name,
		dataType: "xml",
		cache: false,
		success: function(xml) {
			$(xml).find('trkpt').each(function(index) {
				var lat_str = $(this).attr('lat');
				var lng_str = $(this).attr('lon');
				lat_arr.push(parseFloat(lat_str));
				lng_arr.push(parseFloat(lng_str));
			});
			gps_size = lat_arr.length;
			$('#googlemap').get(0).contentWindow.setGPSData(lat_arr, lng_arr);
		},
		error: function(xhr, status, error) {
			//KML 파일 처리
		}
	});
	
}

/* frame_start ----------------------------------- 프레임 기능 설정 ------------------------------------- */
var auto_frameline_str;
var auto_frameline_num = 0;
function createFrameLine(type) {
	auto_frameline_str = 'video_frame_line' + auto_frameline_num;
	var top = auto_frameline_num * 25;
	var btn_top = 30 + top;
	var div_element = $(document.createElement('div'));
	div_element.attr('id', auto_frameline_str); div_element.attr('style', 'position:absolute; left:0px; top:'+top+'px; width:6000px; height:25px; background-image: url(images/timeline_frame.png);');
	div_element.appendTo('#video_obj_area');
	$('.frame_plus').attr('style', 'position:absolute; left:0px; top:'+btn_top+'px; width:25px; height:25px;');
	$('.frame_minus').attr('style', 'position:absolute; left:25px; top:'+btn_top+'px; width:25px; height:25px;');
	var obj_area_height = $('#video_obj_area').css('height'); obj_area_height = obj_area_height.replace('px','');
	$('#video_obj_area').css({height: parseInt(obj_area_height) + 25});
	var video_guide_height = $('#video_guide').css('height'); video_guide_height = video_guide_height.replace('px','');
	$('#video_guide').css({height: parseInt(video_guide_height) + 25});
	if(type==2) {
		$('#video_obj_line').css({top: top+25});
	}
	auto_frameline_num++;
}
function createObjLine() {
	var top = auto_frameline_num * 25;
	var div_element = $(document.createElement('div'));
	div_element.attr('id', 'video_obj_line'); div_element.attr('style', 'position:absolute; left:0px; top:'+top+'px; width:6000px; height:25px; background-image: url(images/timeline_frame.png);');
	div_element.appendTo('#video_obj_area');
}
function removeFrameLine() {
	if(auto_frameline_num>1) {
		auto_frameline_num--;
		var btn_top = 30 + ((auto_frameline_num-1) * 25);
		$('.frame_plus').css({top:btn_top}); $('.frame_minus').css({top:btn_top});
		$('#video_frame_line'+auto_frameline_num).remove();
		var obj_area_height = $('#video_obj_area').css('height'); obj_area_height = obj_area_height.replace('px','');
		$('#video_obj_area').css({height: parseInt(obj_area_height) - 25});
		var video_guide_height = $('#video_guide').css('height'); video_guide_height = video_guide_height.replace('px','');
		$('#video_guide').css({height: parseInt(video_guide_height) - 25});
		var top = $('#video_obj_line').css('top');
		top = top.replace('px','');
		$('#video_obj_line').css({top: parseInt(top)-25});
	}
	else {
		jAlert('프레임 라인을 더이상 제거할수 없습니다.', '정보');
	}
}
function inputFrameObj(type) {
	var obj_str, obj_text;
	if(type=='caption') { obj_str = 'framec' + (auto_caption_num-1); obj_text = 'Caption'; }
	else if(type=='bubble') { obj_str = 'frameb' + (auto_bubble_num-1); obj_text = 'Bubble'; }
	else if(type=='icon') { obj_str = 'framei' + (auto_icon_num-1); obj_text = 'Icon'; }
	else if(type=='geometry') { obj_str = 'frameg' + (auto_geometry_num-1); obj_text = 'Geometry'; }
	else {}

	var top = $('#video_obj_line').css('top');
	top = top.replace('px','');
	createFrameObj(obj_str, 0, parseInt(top), 100, obj_text);
}
var frameline_obj_top;
function createFrameObj(id, left, top, width, text) {
	var div_element = $(document.createElement('div'));
	div_element.attr('id', id); div_element.attr('style', 'position:absolute; left:'+left+'px; top:'+top+'px; width:'+width+'px; height:25px; background:#CCF; text-align:left; font-size:10px; overflow:hidden;');
	div_element.html('ID:'+id+' Type:'+text);
	div_element.draggable({ containment:'#video_obj_area', grid:[1,25]});
	div_element.resizable({ minHeight:25, maxHeight:25, minWidth:10 });
	div_element.appendTo('#video_obj_area');
}
function timeUpdate(time, totaltime) {
	var point = time * 5;
	$('#video_guide').css({left:point});
	visibleFrameObj(point);
	moveMap(time, totaltime);
}
function visibleFrameObj(point) {
	var objCount = $('#video_obj_area').children().size();
	for(var i=0; i<objCount; i++) {
		var frame_obj = $('#video_obj_area').children().eq(i);
		var id = frame_obj.attr('id');
		if(id.length > 5) {
			if(id.substring(0, 5)=='frame') {
				var buf1 = frame_obj.css('left');
				buf1 = buf1.replace('px','');
				var start_point = parseInt(buf1);
				var buf2 = frame_obj.css('width');
				buf2 = buf2.replace('px','');
				var end_point = parseInt(buf1) + parseInt(buf2);
				var obj = $('#'+id.substring(5, id.length));
				if(start_point <= point && point <= end_point) { obj.css({visibility:'visible'}); }
				else { obj.css({visibility:'hidden'}); }
			}
		}
	}
}
function moveMap(time, totaltime) {
	var ratio = time * gps_size / totaltime;
	$('#googlemap').get(0).contentWindow.moveMarker(parseInt(ratio));
}

/* caption_start ----------------------------------- 자막 삽입 버튼 설정 ------------------------------------- */
function inputCaption(id, text) {
	compHide();
	
	$('#caption_font_color').attr('disabled', true);
	$('#caption_bg_color').attr('disabled', true);
	
	if(id==0 & text=="") {
		//caption dialog 내부 객체 초기화
		$('#caption_font_select').val('Normal'); $('#caption_font_color').val('#000000'); $('#caption_font_color').css('background-color', '#000000'); $('#caption_bg_color').val('#FFFFFF'); $('#caption_bg_color').css('background-color', '#FFFFFF'); $('input[name=caption_bg_checkbok]').attr('checked', true); $('#icp_caption_bg_color').removeAttr('onclick'); $('#caption_check').html('<input type="checkbox" id="caption_bold" class="caption_bold" /><label for="caption_bold" style="width:30px; height:30px;">Bold</label><input type="checkbox" id="caption_italic" class="caption_italic" /><label for="caption_italic" style="width:30px; height:30px;">Italic</label><input type="checkbox" id="caption_underline" class="caption_underline" /><label for="caption_underline" style="width:30px; height:30px;">Underline</label><input type="checkbox" id="caption_link" class="caption_link" /><label for="caption_link" style="width:30px; height:30px;">HyperLink</label>'); $('.caption_bold').button({ icons: { primary: 'ui-icon-bold'}, text: false }); $('.caption_italic').button({ icons: { primary: 'ui-icon-italic'}, text: false }); $('.caption_underline').button({ icons: { primary: 'ui-icon-underline'}, text: false }); $('.caption_link').button({ icons: { primary: 'ui-icon-link'}, text: false }); $('#caption_button').html('<button class="ui-state-default ui-corner-all" style="width:80px; height:30px; font-size:12px;" onclick="createCaption();">입력</button>'); $('#caption_text').val('');
	}
	else {
		//caption dialog 내부 객체 설정
		var font_size = $('#f'+id).css('font-size');
		if(font_size == '14px') $('#caption_font_select').val('H3');
		else if(font_size == '18px') $('#caption_font_select').val('H2');
		else if(font_size == '22px') $('#caption_font_select').val('H1');
		else $('#caption_font_select').val('Normal');
		var font_color = rgb2hex($('#f'+id).css('color')); $('#caption_font_color').val(font_color); $('#caption_font_color').css('background-color', font_color);
		var bg_color_value = $('#p'+id).css('backgroundColor'); var bg_color = '';
		if(bg_color_value!='transparent') { bg_color = rgb2hex($('#p'+id).css('backgroundColor')); $('input[name=caption_bg_checkbok]').attr('checked', false); }
		else { bg_color = '#FFFFFF'; $('input[name=caption_bg_checkbok]').attr('checked', true); }
		$('#caption_bg_color').val(bg_color); $('#caption_bg_color').css('background-color', bg_color);
		var check_html = ""; var html_text = $('#'+id).html();
		if(html_text.indexOf('<b id') != -1) check_html += '<input type="checkbox" id="caption_bold" class="caption_bold" checked="checked" /><label for="caption_bold" style="width:30px; height:30px;">Bold</label>';
		else check_html += '<input type="checkbox" id="caption_bold" class="caption_bold" /><label for="caption_bold" style="width:30px; height:30px;">Bold</label>';
		if(html_text.indexOf('<i id') != -1) check_html += '<input type="checkbox" id="caption_italic" class="caption_italic" checked="checked" /><label for="caption_italic" style="width:30px; height:30px;">Italic</label>';
		else check_html += '<input type="checkbox" id="caption_italic" class="caption_italic" /><label for="caption_italic" style="width:30px; height:30px;">Italic</label>';
		if(html_text.indexOf('<u id') != -1) check_html += '<input type="checkbox" id="caption_underline" class="caption_underline" checked="checked" /><label for="caption_underline" style="width:30px; height:30px;">Underline</label>';
		else check_html += '<input type="checkbox" id="caption_underline" class="caption_underline" /><label for="caption_underline" style="width:30px; height:30px;">Underline</label>';
		if(html_text.indexOf('<a href') != -1) check_html += '<input type="checkbox" id="caption_link" class="caption_link" checked="checked" /><label for="caption_link" style="width:30px; height:30px;">HyperLink</label>';
		else check_html += '<input type="checkbox" id="caption_link" class="caption_link" /><label for="caption_link" style="width:30px; height:30px;">HyperLink</label>';
		$('#caption_check').html(check_html); $('.caption_bold').button({ icons: { primary: 'ui-icon-bold'}, text: false }); $('.caption_italic').button({ icons: { primary: 'ui-icon-italic'}, text: false }); $('.caption_underline').button({ icons: { primary: 'ui-icon-underline'}, text: false }); $('.caption_link').button({ icons: { primary: 'ui-icon-link'}, text: false }); $('#caption_text').val($('#p'+id).html()); $('#caption_button').html('<button id="caption_replace_btn" class="ui-state-default ui-corner-all" style="width:80px; height:30px; font-size:12px;">수정</button>');
		$('#caption_replace_btn').click(function() { replaceCaption(id); });
	}
	
	document.getElementById('caption_dialog').style.display='block';
}

function checkCaption() {
	if(!$('input[name=caption_bg_checkbok]').attr('checked')) { $('#icp_caption_bg_color').bind('click', function() { iColorShow('caption_bg_color','icp_caption_bg_color'); }); }
	else { $('#icp_caption_bg_color').unbind('click'); }
}

var auto_caption_str;
var auto_caption_num = 0;
function createCaption() {
	auto_caption_str = "c" + auto_caption_num;
	
	var font_size = $('#caption_font_select').val(); var font_color = $('#caption_font_color').val(); var bg_color = $('#caption_bg_color').val(); var bg_check = $('input[name=caption_bg_checkbok]').attr('checked'); var bold_check = $('#caption_bold').attr('checked'); var italic_check = $('#caption_italic').attr('checked'); var underline_check = $('#caption_underline').attr('checked'); var link_check = $('#caption_link').attr('checked'); var text = $('#caption_text').val();
	if(bg_check==true) bg_color = '';
	var html_text;
	//폰트, 색상 설정
	if(font_size=='H3') html_text = '<font id="f'+auto_caption_str+'" style="font-size:14px; color:'+font_color+';"><pre id="p'+auto_caption_str+'" style="background:'+bg_color+';">'+text+'</pre></font>';
	else if(font_size=='H2') html_text = '<font id="f'+auto_caption_str+'" style="font-size:18px; color:'+font_color+';"><pre id="p'+auto_caption_str+'" style="background:'+bg_color+';">'+text+'</pre></font>';
	else if(font_size=='H1') html_text = '<font id="f'+auto_caption_str+'" style="font-size:22px; color:'+font_color+';"><pre id="p'+auto_caption_str+'" style="background:'+bg_color+';">'+text+'</pre></font>';
	else html_text = '<font id="f'+auto_caption_str+'" style="color:'+font_color+';"><pre id="p'+auto_caption_str+'" style="background:'+bg_color+';">'+text+'</pre></font>';
	//bold, italic, underline, hyperlink 설정
	if(bold_check==true) html_text = '<b id="b'+auto_caption_str+'">'+html_text+'</b>';
	if(italic_check==true) html_text = '<i id="i'+auto_caption_str+'">'+html_text+'</i>';
	if(underline_check==true) html_text = '<u id="u'+auto_caption_str+'">'+html_text+'</u>';
	if(link_check==true) {
		if(html_text.indexOf('http://')== -1) html_text = '<a href="http://'+text+'" id="h'+auto_caption_str+'" target="_blank">'+html_text+'</a>';
		else html_text = '<a href="'+text+'" id="h'+auto_caption_str+'" target="_blank">'+html_text+'</a>';
	}
	
	var div_element = $(document.createElement('div'));
	div_element.attr('id', auto_caption_str); div_element.attr('style', 'position:absolute; left:10px; top:10px; display:block;'); div_element.html(html_text); div_element.draggable(); div_element.dblclick(function() { inputCaption(div_element.attr('id'), text); }); div_element.appendTo('#video_main_area');
	
	$('#'+div_element.attr('id')).contextMenu('context1', {
		bindings: {
			'context_modify': function(t) { inputCaption(t.id, text); },
			'context_delete': function(t) { jConfirm('정말 삭제하시겠습니까?', '정보', function(type){ if(type) { $('#'+t.id).remove(); removeTableObject(t.id); $('#frame'+t.id).remove(); } }); }
		}
	});
	
	auto_caption_num++;
	
	compHide();
	
	var data_arr = new Array();
	data_arr.push(auto_caption_str); data_arr.push("Caption"); data_arr.push(text);
	insertTableObject(data_arr);
	inputFrameObj('caption');
}

function replaceCaption(id) {
	var font_size = $('#caption_font_select').val();
	var font_color = $('#caption_font_color').val();
	var bg_color = $('#caption_bg_color').val();
	var bg_check = $('input[name=caption_bg_checkbok]').attr('checked');
	var bold_check = $('#caption_bold').attr('checked');
	var italic_check = $('#caption_italic').attr('checked');
	var underline_check = $('#caption_underline').attr('checked');
	var link_check = $('#caption_link').attr('checked');
	var text = $('#caption_text').val();
	
	if(bg_check==true) bg_color = '';
	
	var html_text;
	//폰트, 색상 설정
	if(font_size=='H3') html_text = '<font id="f'+id+'" style="font-size:14px; color:'+font_color+';"><pre id="p'+id+'" style="background:'+bg_color+';">'+text+'</pre></font>';
	else if(font_size=='H2') html_text = '<font id="f'+id+'" style="font-size:18px; color:'+font_color+';"><pre id="p'+id+'" style="background:'+bg_color+';">'+text+'</pre></font>';
	else if(font_size=='H1') html_text = '<font id="f'+id+'" style="font-size:22px; color:'+font_color+';"><pre id="p'+id+'" style="background:'+bg_color+';">'+text+'</pre></font>';
	else html_text = '<font id="f'+id+'" style="color:'+font_color+';"><pre id="p'+id+'" style="background:'+bg_color+';">'+text+'</pre></font>';
	//bold, italic, underline, hyperlink 설정
	if(bold_check==true) html_text = '<b id="b'+id+'">'+html_text+'</b>';
	if(italic_check==true) html_text = '<i id="i'+id+'">'+html_text+'</i>';
	if(underline_check==true) html_text = '<u id="u'+id+'">'+html_text+'</u>';
	if(link_check==true) {
		if(html_text.indexOf('http://')== -1) html_text = '<a href="http://'+text+'" id="h'+id+'" target="_blank">'+html_text+'</a>';
		else html_text = '<a href="'+text+'" id="h'+id+'" target="_blank">'+html_text+'</a>';
	}
	
	$('#a'+id).remove(); $('#u'+id).remove(); $('#i'+id).remove(); $('#b'+id).remove(); $('#f'+id).remove(); $('#p'+id).remove();
	$('#'+id).html(html_text);
	
	compHide();
	
	var data_arr = new Array();
	data_arr.push(id); data_arr.push("Caption"); data_arr.push(text);
	replaceTableObject(data_arr);
}

/* bubble_start ----------------------------------- 말풍선 삽입 버튼 설정 ------------------------------------- */
function inputBubble(id, text) {
	compHide();
	
	$('#bubble_font_color').attr('disabled', true);
	$('#bubble_bg_color').attr('disabled', true);
	
	if(id==0 & text=="") {
		//bubble dialog 내부 객체 초기화
		$('#bubble_font_select').val('Normal'); $('#bubble_font_color').val('#000000'); $('#bubble_font_color').css('background-color', '#000000'); $('#bubble_bg_color').val('#FFFFFF'); $('#bubble_bg_color').css('background-color', '#FFFFFF'); $('input[name=bubble_bg_checkbok]').attr('checked', true); $('#icp_bubble_bg_color').removeAttr('onclick'); $('#bubble_check').html('<input type="checkbox" id="bubble_bold" class="bubble_bold" /><label for="bubble_bold" style="width:30px; height:30px;">Bold</label><input type="checkbox" id="bubble_italic" class="bubble_italic" /><label for="bubble_italic" style="width:30px; height:30px;">Italic</label><input type="checkbox" id="bubble_underline" class="bubble_underline" /><label for="bubble_underline" style="width:30px; height:30px;">Underline</label><input type="checkbox" id="bubble_link" class="bubble_link" /><label for="bubble_link" style="width:30px; height:30px;">HyperLink</label>'); $('.bubble_bold').button({ icons: { primary: 'ui-icon-bold'}, text: false }); $('.bubble_italic').button({ icons: { primary: 'ui-icon-italic'}, text: false }); $('.bubble_underline').button({ icons: { primary: 'ui-icon-underline'}, text: false }); $('.bubble_link').button({ icons: { primary: 'ui-icon-link'}, text: false }); $('#bubble_button').html('<button class="ui-state-default ui-corner-all" style="width:80px; height:30px; font-size:12px;" onclick="createBubble();">입력</button>'); $('#bubble_text').val('');
	}
	else {
		//caption dialog 내부 객체 설정
		var font_size = $('#f'+id).css('font-size');
		if(font_size == '14px') $('#bubble_font_select').val('H3');
		else if(font_size == '18px') $('#bubble_font_select').val('H2');
		else if(font_size == '22px') $('#bubble_font_select').val('H1');
		else $('#bubble_font_select').val('Normal');
		var font_color = rgb2hex($('#f'+id).css('color')); $('#bubble_font_color').val(font_color); $('#bubble_font_color').css('background-color', font_color);
		var bg_color_value = $('#p'+id).css('backgroundColor'); var bg_color = '';
		if(bg_color_value!='transparent') { bg_color = rgb2hex($('#p'+id).css('backgroundColor')); $('input[name=bubble_bg_checkbok]').attr('checked', false); }
		else { bg_color = '#FFFFFF'; $('input[name=bubble_bg_checkbok]').attr('checked', true); }
		$('#bubble_bg_color').val(bg_color); $('#bubble_bg_color').css('background-color', bg_color);
		var check_html = ""; var html_text = $('#'+id).html();
		if(html_text.indexOf('<b id') != -1) check_html += '<input type="checkbox" id="bubble_bold" class="bubble_bold" checked="checked" /><label for="bubble_bold" style="width:30px; height:30px;">Bold</label>';
		else check_html += '<input type="checkbox" id="bubble_bold" class="bubble_bold" /><label for="bubble_bold" style="width:30px; height:30px;">Bold</label>';
		if(html_text.indexOf('<i id') != -1) check_html += '<input type="checkbox" id="bubble_italic" class="bubble_italic" checked="checked" /><label for="bubble_italic" style="width:30px; height:30px;">Italic</label>';
		else check_html += '<input type="checkbox" id="bubble_italic" class="bubble_italic" /><label for="bubble_italic" style="width:30px; height:30px;">Italic</label>';
		if(html_text.indexOf('<u id') != -1) check_html += '<input type="checkbox" id="bubble_underline" class="bubble_underline" checked="checked" /><label for="bubble_underline" style="width:30px; height:30px;">Underline</label>';
		else check_html += '<input type="checkbox" id="bubble_underline" class="bubble_underline" /><label for="bubble_underline" style="width:30px; height:30px;">Underline</label>';
		if(html_text.indexOf('<a href') != -1) check_html += '<input type="checkbox" id="bubble_link" class="bubble_link" checked="checked" /><label for="bubble_link" style="width:30px; height:30px;">HyperLink</label>';
		else check_html += '<input type="checkbox" id="bubble_link" class="bubble_link" /><label for="bubble_link" style="width:30px; height:30px;">HyperLink</label>';
		$('#bubble_check').html(check_html); $('.bubble_bold').button({ icons: { primary: 'ui-icon-bold'}, text: false }); $('.bubble_italic').button({ icons: { primary: 'ui-icon-italic'}, text: false }); $('.bubble_underline').button({ icons: { primary: 'ui-icon-underline'}, text: false }); $('.bubble_link').button({ icons: { primary: 'ui-icon-link'}, text: false }); $('#bubble_text').val($('#p'+id).html()); $('#bubble_button').html('<button id="bubble_replace_btn" class="ui-state-default ui-corner-all" style="width:80px; height:30px; font-size:12px;">수정</button>');
		$('#bubble_replace_btn').click(function() { replaceBubble(id); });
	}
	
	document.getElementById('bubble_dialog').style.display='block';
}

function checkBubble() {
	if(!$('input[name=bubble_bg_checkbok]').attr('checked')) { $('#icp_bubble_bg_color').bind('click', function() { iColorShow('bubble_bg_color','icp_bubble_bg_color'); }); }
	else { $('#icp_bubble_bg_color').unbind('click'); }
}

var auto_bubble_str;
var auto_bubble_num = 0;
function createBubble() {
	auto_bubble_str = "b" + auto_bubble_num;
	var font_size = $('#bubble_font_select').val(); var font_color = $('#bubble_font_color').val(); var bg_color = $('#bubble_bg_color').val(); var bg_check = $('input[name=bubble_bg_checkbok]').attr('checked'); var bold_check = $('#bubble_bold').attr('checked'); var italic_check = $('#bubble_italic').attr('checked'); var underline_check = $('#bubble_underline').attr('checked'); var link_check = $('#bubble_link').attr('checked'); var text = $('#bubble_text').val();
	if(bg_check==true) bg_color = '';
	var html_text;
	//폰트, 색상 설정
	if(font_size=='H3') html_text = '<font id="f'+auto_bubble_str+'" style="font-size:14px; color:'+font_color+';"><pre id="p'+auto_bubble_str+'" style="background:'+bg_color+';">'+text+'</pre></font>';
	else if(font_size=='H2') html_text = '<font id="f'+auto_bubble_str+'" style="font-size:18px; color:'+font_color+';"><pre id="p'+auto_bubble_str+'" style="background:'+bg_color+';">'+text+'</pre></font>';
	else if(font_size=='H1') html_text = '<font id="f'+auto_bubble_str+'" style="font-size:22px; color:'+font_color+';"><pre id="p'+auto_bubble_str+'" style="background:'+bg_color+';">'+text+'</pre></font>';
	else html_text = '<font id="f'+auto_bubble_str+'" style="color:'+font_color+';"><pre id="p'+auto_bubble_str+'" style="background:'+bg_color+';">'+text+'</pre></font>';
	//bold, italic, underline, hyperlink 설정
	if(bold_check==true) html_text = '<b id="b'+auto_bubble_str+'">'+html_text+'</b>';
	if(italic_check==true) html_text = '<i id="i'+auto_bubble_str+'">'+html_text+'</i>';
	if(underline_check==true) html_text = '<u id="u'+auto_bubble_str+'">'+html_text+'</u>';
	if(link_check==true) {
		if(html_text.indexOf('http://')== -1) html_text = '<a href="http://'+text+'" id="h'+auto_bubble_str+'" target="_blank">'+html_text+'</a>';
		else html_text = '<a href="'+text+'" id="h'+auto_bubble_str+'" target="_blank">'+html_text+'</a>';
	}
	
	var div_element = $(document.createElement('div')); div_element.attr('id', auto_bubble_str); div_element.attr('style', 'position:absolute; left:10px; top:10px; display:block;'); div_element.html(html_text); div_element.draggable(); div_element.dblclick(function() { inputBubble(div_element.attr('id'), text); }); div_element.appendTo('#video_main_area');

	$('#'+div_element.attr('id')).contextMenu('context1', {
		bindings: {
			'context_modify': function(t) { inputBubble(t.id, text); },
			'context_delete': function(t) { jConfirm('정말 삭제하시겠습니까?', '정보', function(type){ 	if(type) { $('#'+t.id).remove(); removeTableObject(t.id); $('#frame'+t.id).remove(); } }); }
		}
	});
	
	auto_bubble_num++;

	compHide();
	
	var data_arr = new Array();
	data_arr.push(auto_bubble_str); data_arr.push("Bubble"); data_arr.push(text);
	insertTableObject(data_arr);
	inputFrameObj('bubble');
}

function replaceBubble(id) {
	var font_size = $('#bubble_font_select').val();
	var font_color = $('#bubble_font_color').val();
	var bg_color = $('#bubble_bg_color').val();
	var bg_check = $('input[name=bubble_bg_checkbok]').attr('checked');
	var bold_check = $('#bubble_bold').attr('checked');
	var italic_check = $('#bubble_italic').attr('checked');
	var underline_check = $('#bubble_underline').attr('checked');
	var link_check = $('#bubble_link').attr('checked');
	var text = $('#bubble_text').val();
	
	if(bg_check==true) bg_color = '';
	
	var html_text;
	//폰트, 색상 설정
	if(font_size=='H3') html_text = '<font id="f'+id+'" style="font-size:14px; color:'+font_color+';"><pre id="p'+id+'" style="background:'+bg_color+';">'+text+'</pre></font>';
	else if(font_size=='H2') html_text = '<font id="f'+id+'" style="font-size:18px; color:'+font_color+';"><pre id="p'+id+'" style="background:'+bg_color+';">'+text+'</pre></font>';
	else if(font_size=='H1') html_text = '<font id="f'+id+'" style="font-size:22px; color:'+font_color+';"><pre id="p'+id+'" style="background:'+bg_color+';">'+text+'</pre></font>';
	else html_text = '<font id="f'+id+'" style="color:'+font_color+';"><pre id="p'+id+'" style="background:'+bg_color+';">'+text+'</pre></font>';
	//bold, italic, underline, hyperlink 설정
	if(bold_check==true) html_text = '<b id="b'+id+'">'+html_text+'</b>';
	if(italic_check==true) html_text = '<i id="i'+id+'">'+html_text+'</i>';
	if(underline_check==true) html_text = '<u id="u'+id+'">'+html_text+'</u>';
	if(link_check==true) {
		if(html_text.indexOf('http://')== -1) html_text = '<a href="http://'+text+'" id="h'+id+'" target="_blank">'+html_text+'</a>';
		else html_text = '<a href="'+text+'" id="h'+id+'" target="_blank">'+html_text+'</a>';
	}
	
	$('#a'+id).remove(); $('#u'+id).remove(); $('#i'+id).remove(); $('#b'+id).remove(); $('#f'+id).remove(); $('#p'+id).remove();
	$('#'+id).html(html_text);
	
	compHide();
	
	var data_arr = new Array();
	data_arr.push(id); data_arr.push("Bubble"); data_arr.push(text);
	replaceTableObject(data_arr);
}

/* icon_start ----------------------------------- 아이콘 & 이미지 삽입 버튼 설정 ------------------------------------- */
function inputIcon() {
	compHide();
	
	for(var i=1; i<131; i++) {
		$('#icon_img'+i).attr('src', 'images/icon/black/d'+i+'.png');
		$('#icon_img'+i).unbind('mouseover');
		$('#icon_img'+i).bind('mouseover', function() {
			var buf = this.id.split('icon_img');
			$('#'+this.id).attr('src', 'images/icon/white/d'+buf[1]+'_over.png');
		});
		$('#icon_img'+i).unbind('mouseout');
		$('#icon_img'+i).bind('mouseout', function() {
			var buf = this.id.split('icon_img');
			$('#'+this.id).attr('src', 'images/icon/black/d'+buf[1]+'.png');
		});
		$('#icon_img'+i).unbind('click');
		$('#icon_img'+i).bind('click', function() {
			var buf = this.id.split('icon_img');
			var src = 'images/icon/black/d'+buf[1]+'.png';
			createIcon(src);
		});
	}
	document.getElementById('icon_dialog').style.display='block';
}

function tabImage(num) {
	if(num==1) {
		document.getElementById('icon_div1').style.display='block';
		document.getElementById('icon_div2').style.display='none';
	}
	else if(num==2) {
		document.getElementById('icon_div1').style.display='none';
		document.getElementById('icon_div2').style.display='block';
	}
	else {}
}

var auto_icon_str;
var auto_icon_num = 0;
function createIcon(img_src) {
	auto_icon_str = "i" + auto_icon_num;
	
	var img_element = $(document.createElement('img'));
	img_element.attr('id', auto_icon_str);
	img_element.attr('src', img_src);
	img_element.attr('style', 'position:absolute; display:block; left:30px; top:30px;');
	img_element.attr('width', 100);
	img_element.attr('height', 100);
	img_element.appendTo('#video_main_area');
	$('#'+img_element.attr('id')).resizable().parent().draggable();
	$('#'+img_element.attr('id')).contextMenu('context2', {
		bindings: {
			'context_delete': function(t) {
				jConfirm('정말 삭제하시겠습니까?', '정보', function(type){ if(type) $('#'+t.id).remove(); removeTableObject(t.id); $('#frame'+t.id).remove(); });
			}
		}
	});
	
	auto_icon_num++;
	
	compHide();
	
	var data_arr = new Array();
	data_arr.push(auto_icon_str); data_arr.push("Image"); data_arr.push(img_src);
	insertTableObject(data_arr);
	inputFrameObj('icon');
}


/* geo_start ----------------------------------- 지오매트리 삽입 버튼 설정 ------------------------------------- */

function inputGeometry() {
	compHide();
	$('#geometry_line_color').attr('disabled', true); $('#geometry_bg_color').attr('disabled', true); $('#geometry_line_color').val('#999999'); $('#geometry_line_color').css('background-color', '#999999'); $('#geometry_bg_color').val('#FF0000'); $('#geometry_bg_color').css('background-color', '#FF0000');
	document.getElementById('geometry_dialog').style.display='block';
}

function setGeometry() {
	var geo_type = $("input[name='geo_shape']:checked").val();
	if(geo_type=='circle') { inputGeometryShape(1); }
	else if(geo_type=='rect') { inputGeometryShape(2); }
	else { inputGeometryShape(3); }
}

//Geometry Common Value
var auto_geometry_str; var auto_geometry_num = 0; var geometry_point_arr_1 = new Array(); var geometry_point_arr_2 = new Array();
var geometry_total_arr_1 = new Array(); var geometry_total_arr_2 = new Array();
var geometry_total_arr_buf_1 = new Array(); var geometry_total_arr_buf_2 = new Array();
//Geometry Circle & Rect Value
var geometry_click_move_val = false; var geometry_click_move_point_x = 0; var geometry_click_move_point_y = 0;
//Geometry Point Value
var geometry_point_before_x = 0; var geometry_point_before_y = 0; var geometry_point_num = 1;

function inputGeometryShape(type) {
	compHide();
	var left = $('#video_player').css('left'); var top = $('#video_player').css('top'); var width = $('#video_player').attr('width'); var height = $('#video_player').attr('height');
	var canvas_element = $(document.createElement('canvas'));
	canvas_element.attr('id', 'geometry_draw_canvas'); canvas_element.attr('style', 'position:absolute; display:block; left:'+left+'; top:'+top+';'); canvas_element.attr('width', width); canvas_element.attr('height', height);
	
	if(type==1) {
		canvas_element.mousedown(function(e) {
			geometry_click_move_val = true;
			//좌표점 계산
			var left_str = $('#video_main_area').css('left'); var top_str = $('#video_main_area').css('top'); var left = parseInt(left_str.replace('px','')); var top = parseInt(top_str.replace('px','')); geometry_click_move_point_x = e.pageX - (this.offsetLeft + left); geometry_click_move_point_y = e.pageY - (this.offsetTop + top);
			geometry_point_arr_1 = null; geometry_point_arr_2 = null; geometry_point_arr_1 = new Array(); geometry_point_arr_2 = new Array();
			geometry_point_arr_1.push(geometry_click_move_point_x); geometry_point_arr_2.push(geometry_click_move_point_y);
		});
		canvas_element.mouseup(function(e) {
			geometry_click_move_val = false;
			//좌표점 계산
			var left_str = $('#video_main_area').css('left'); var top_str = $('#video_main_area').css('top'); var left = parseInt(left_str.replace('px','')); var top = parseInt(top_str.replace('px',''));
			geometry_point_arr_1.push(e.pageX - (this.offsetLeft + left)); geometry_point_arr_2.push(e.pageY - (this.offsetTop + top));
		});
		canvas_element.mousemove(function(e) {
			if(geometry_click_move_val) {
				//마우스 좌표 가져오기
				var left_str = $('#video_main_area').css('left'); var top_str = $('#video_main_area').css('top'); var left = parseInt(left_str.replace('px','')); var top = parseInt(top_str.replace('px','')); var mouse_x = e.pageX - (this.offsetLeft + left); var mouse_y = e.pageY - (this.offsetTop + top);
				//각 좌표 설정
				var start_x, start_y, width, height; width = Math.abs(geometry_click_move_point_x - mouse_x); height = Math.abs(geometry_click_move_point_y - mouse_y);
				if(geometry_click_move_point_x > mouse_x) start_x = mouse_x; else start_x = geometry_click_move_point_x;
				if(geometry_click_move_point_y > mouse_y) start_y = mouse_y; else start_y = geometry_click_move_point_y;
				var kappa = .5522848;
					ox = (width/2) * kappa, oy = (height/2) * kappa, xe = start_x + width, ye = start_y + height, xm = start_x + width/2, ym = start_y + height/2;
				//원 그리기
				var canvas = $('#geometry_draw_canvas');
				var context = document.getElementById('geometry_draw_canvas').getContext("2d");
				context.clearRect(0,0,canvas.attr('width'),canvas.attr('height'));
				context.strokeStyle = '#f00';
				context.beginPath(); context.moveTo(start_x, ym);
				context.bezierCurveTo(start_x, ym - oy, xm - ox, start_y, xm, start_y); context.bezierCurveTo(xm + ox, start_y, xe, ym - oy, xe, ym); context.bezierCurveTo(xe, ym + oy, xm + ox, ye, xm, ye); context.bezierCurveTo(xm - ox, ye, start_x, ym + oy, start_x, ym);
				context.closePath(); context.stroke();
			}
		});
	}
	else if(type==2) {
		canvas_element.mousedown(function(e) {
			geometry_click_move_val = true;
			//좌표점 계산
			var left_str = $('#video_main_area').css('left'); var top_str = $('#video_main_area').css('top'); var left = parseInt(left_str.replace('px','')); var top = parseInt(top_str.replace('px','')); geometry_click_move_point_x = e.pageX - (this.offsetLeft + left); geometry_click_move_point_y = e.pageY - (this.offsetTop + top);
			geometry_point_arr_1 = null; geometry_point_arr_2 = null; geometry_point_arr_1 = new Array(); geometry_point_arr_2 = new Array();
			geometry_point_arr_1.push(geometry_click_move_point_x); geometry_point_arr_2.push(geometry_click_move_point_y);
		});
		canvas_element.mouseup(function(e) {
			geometry_click_move_val = false;
			//좌표점 계산
			var left_str = $('#video_main_area').css('left'); var top_str = $('#video_main_area').css('top'); var left = parseInt(left_str.replace('px','')); var top = parseInt(top_str.replace('px',''));
			geometry_point_arr_1.push(e.pageX - (this.offsetLeft + left)); geometry_point_arr_2.push(e.pageY - (this.offsetTop + top));
		});
		canvas_element.mousemove(function(e) {
			if(geometry_click_move_val) {
				//마우스 좌표 가져오기
				var left_str = $('#video_main_area').css('left'); var top_str = $('#video_main_area').css('top'); var left = parseInt(left_str.replace('px','')); var top = parseInt(top_str.replace('px','')); var mouse_x = e.pageX - (this.offsetLeft + left); var mouse_y = e.pageY - (this.offsetTop + top);
				//각 좌표 설정
				var start_x, start_y, width, height;
				width = Math.abs(geometry_click_move_point_x - mouse_x); height = Math.abs(geometry_click_move_point_y - mouse_y);
				if(geometry_click_move_point_x > mouse_x) start_x = mouse_x;
				else start_x = geometry_click_move_point_x;
				if(geometry_click_move_point_y > mouse_y) start_y = mouse_y;
				else start_y = geometry_click_move_point_y;
				//사각형 그리기
				var canvas = $('#geometry_draw_canvas');
				var context = document.getElementById('geometry_draw_canvas').getContext("2d");
				context.clearRect(0,0,canvas.attr('width'),canvas.attr('height'));
				context.strokeStyle = '#f00';
				context.strokeRect(start_x, start_y, width, height);
			}
		});
	}
	else {
		canvas_element.click(function(e) {
			//좌표점 계산
			var left_str = $('#video_main_area').css('left'); var top_str = $('#video_main_area').css('top'); var left = parseInt(left_str.replace('px','')); var top = parseInt(top_str.replace('px','')); var x = e.pageX - (this.offsetLeft + left); var y = e.pageY - (this.offsetTop + top);
			//클릭 좌표점에 원과 숫자 그리기
			var context = document.getElementById('geometry_draw_canvas').getContext("2d"); context.strokeStyle = '#f00'; context.beginPath(); context.arc(x, y, 5, 0, 2*Math.PI, true); context.stroke();
			if(geometry_point_num>=10) context.fillText(geometry_point_num, x-7, y-6); else context.fillText(geometry_point_num, x-3, y-6);
			geometry_point_num++;
			if(geometry_point_before_x == 0 && geometry_point_before_y == 0) { geometry_point_before_x = x; geometry_point_before_y = y; }
			else { context.moveTo(geometry_point_before_x, geometry_point_before_y); context.lineTo(x, y); geometry_point_before_x = x; geometry_point_before_y = y; context.stroke(); }
			context.closePath();
			geometry_point_arr_1.push(x);
			geometry_point_arr_2.push(y);
		});
	}
	canvas_element.appendTo('#video_main_area');
	
	//그리기 완료 및 그리기 취소 버튼
	var html_text = '<button class="geometry_complete_button" onclick="createGeometry('+type+');" style="left:0px; top:0px;">그리기 완료</button>';
	html_text += '<button class="geometry_cancel_button" onclick="cancelGeometry();" style="left:10px; top:0px;">그리기 취소</button>';
	$('#video_main_area').append(html_text);
	$('.geometry_complete_button').button(); $('.geometry_cancel_button').button();
	$('.geometry_complete_button').width(100); $('.geometry_cancel_button').width(100);
	$('.geometry_complete_button').height(30); $('.geometry_cancel_button').height(30);
	$('.geometry_complete_button').css('fontSize', 12); $('.geometry_cancel_button').css('fontSize', 12);
}

function createGeometry(type) {
	auto_geometry_str = "g" + auto_geometry_num;
	var min_x, max_x, min_y, max_y;
	if(type==1 || type==2) {
		if(geometry_point_arr_1[0] < geometry_point_arr_1[1]) { min_x = geometry_point_arr_1[0]; max_x = geometry_point_arr_1[1]; }
		else { min_x = geometry_point_arr_1[1]; max_x = geometry_point_arr_1[0]; }
		if(geometry_point_arr_2[0] < geometry_point_arr_2[1]) { min_y = geometry_point_arr_2[0]; max_y = geometry_point_arr_2[1]; }
		else { min_y = geometry_point_arr_2[1]; max_y = geometry_point_arr_2[0]; }
	}
	else {
		//좌표점에서 사각형 찾기
		min_x = Math.min.apply(Math, geometry_point_arr_1);
		max_x = Math.max.apply(Math, geometry_point_arr_1);
		min_y = Math.min.apply(Math, geometry_point_arr_2);
		max_y = Math.max.apply(Math, geometry_point_arr_2);
	}
	var left = min_x; var top = min_y; var width = max_x - min_x; var height = max_y - min_y;
	var left_str = $('#video_player').css('left'); var top_str = $('#video_player').css('top');
	var left_offset = parseInt(left_str.replace('px','')); var top_offset = parseInt(top_str.replace('px',''));
	left += left_offset; top += top_offset;
	//canvas 객체 삽입
	var canvas_element = $(document.createElement('canvas'));
	canvas_element.attr('id', auto_geometry_str);
	canvas_element.attr('style', 'position:absolute; display:block; left:'+left+'px; top:'+top+'px;');
	canvas_element.attr('width', width);
	canvas_element.attr('height', height);
	canvas_element.mouseover(function() {
		mouseeventGeometry(this.id, true, type);
	});
	canvas_element.mouseout(function() {
		mouseeventGeometry(this.id, false, type);
	});
	canvas_element.appendTo('#video_main_area');
	$('#'+canvas_element.attr('id')).contextMenu('context2', {
		bindings: {
			'context_delete': function(t) { jConfirm('정말 삭제하시겠습니까?', '정보', function(type){ if(type) $('#'+t.id).remove(); removeTableObject(t.id); $('#frame'+t.id).remove(); }); }
		}
	});
	//canvas 객체에 Geometry 그리기
	var canvas = $('#'+auto_geometry_str);
	var context = canvas[0].getContext("2d");
	
	var x, y;
	var x_str = auto_geometry_str+'@'+left+'@'; var y_str = auto_geometry_str+'@'+top+'@';
	var x_str_buf = auto_geometry_str+'@'+left+'@'; var y_str_buf = auto_geometry_str+'@'+top+'@';
	
	var line_color = $('#geometry_line_color').val();
	line_color = line_color.substring(1, line_color.length);
	var bg_color = $('#geometry_bg_color').val();
	bg_color = bg_color.substring(1, bg_color.length);
	context.strokeStyle = css3color(line_color, 1);
	context.lineWidth = 1;
	
	if(type==1) {
		x = 0;
		y = 0;
		width = max_x - min_x; height = max_y - min_y;
		var kappa = .5522848;
			ox = (width/2) * kappa, oy = (height/2) * kappa, xe = x + width, ye = y + height, xm = x + width/2, ym = y + height/2;
		context.beginPath();
		context.moveTo(x, ym);
		context.bezierCurveTo(x, ym - oy, xm - ox, y, xm, y); context.bezierCurveTo(xm + ox, y, xe, ym - oy, xe, ym); context.bezierCurveTo(xe, ym + oy, xm + ox, ye, xm, ye); context.bezierCurveTo(xm - ox, ye, x, ym + oy, x, ym);
		context.closePath(); context.stroke();
		x_str += x + '_' + width + '@' + line_color; y_str += y + '_' + height + '@' + bg_color + '@circle';
		x_str_buf += geometry_point_arr_1[0] + '_' + geometry_point_arr_1[1] + '@' + line_color; y_str_buf += geometry_point_arr_2[0] + '_' + geometry_point_arr_2[1] + '@' + bg_color + '@circle';
	}
	else if(type==2) {
		width = max_x - min_x; height = max_y - min_y;
		context.strokeRect(0, 0, width, height);
		x_str += 0 + '_' + width + '@' + line_color; y_str += 0 + '_' + height + '@' + bg_color + '@rect';
		x_str_buf += geometry_point_arr_1[0] + '_' + geometry_point_arr_1[1] + '@' + line_color; y_str_buf += geometry_point_arr_2[0] + '_' + geometry_point_arr_2[1] + '@' + bg_color + '@rect';
	}
	else {
		context.beginPath();
		for(var i=0; i<geometry_point_arr_1.length; i++) {
			x = Math.abs(left - geometry_point_arr_1[i] - left_offset);
			y = Math.abs(top - geometry_point_arr_2[i] - top_offset);
			if(i==0) context.moveTo(x, y);
			else context.lineTo(x, y);
			if(i==geometry_point_arr_1.length-1) { x_str += x + '@' + line_color; y_str += y + '@' + bg_color + '@point'; }
			else { x_str += x + '_'; y_str += y + '_'; }
			if(i==geometry_point_arr_1.length-1) { x_str_buf += geometry_point_arr_1[i] + '@' + line_color; y_str_buf += geometry_point_arr_2[i] + '@' + bg_color + '@point'; }
			else { x_str_buf += geometry_point_arr_1[i] + '_'; y_str_buf += geometry_point_arr_2[i] + '_'; }
		}
		context.closePath();
		context.stroke();
	}
	auto_geometry_num++;
	//데이터 저장
	geometry_total_arr_1.push(x_str);
	geometry_total_arr_2.push(y_str);
	geometry_total_arr_buf_1.push(x_str_buf);
	geometry_total_arr_buf_2.push(y_str_buf);
	
	cancelGeometry();
	
	var data_arr = new Array();
	data_arr.push(auto_geometry_str); data_arr.push("Geometry");
	if(type==1) { data_arr.push("Circle"); }
	else if(type==2) { data_arr.push("Rectangle"); }
	else { data_arr.push("Point"); }
	insertTableObject(data_arr);
	inputFrameObj('geometry');
}
function mouseeventGeometry(id, over, type) {
	//좌표 배열에서 좌표 가져옴
	var x_arr, y_arr, x_str, y_str, line_color, bg_color;
	for(var i=0; i<geometry_total_arr_1.length; i++) {
		if(id==geometry_total_arr_1[i].split("\@")[0]) {
			line_color = geometry_total_arr_1[i].split("\@")[3]; bg_color = geometry_total_arr_2[i].split("\@")[3];
			x_str = geometry_total_arr_1[i].split("\@")[2]; y_str = geometry_total_arr_2[i].split("\@")[2];
			x_arr = x_str.split("_"); y_arr = y_str.split("_");
		}
	}
	
	var x, y, width, height;
	var canvas = $('#'+id);
	var context = canvas[0].getContext("2d");
	context.clearRect(0,0,canvas.attr('width'),canvas.attr('height'));
	context.strokeStyle = css3color(line_color, 1); context.lineWidth = 1;
	
	if(type==1) {
		x = parseInt(x_arr[0]); y = parseInt(y_arr[0]); width = parseInt(x_arr[1]); height = parseInt(y_arr[1]);
		var kappa = .5522848;
			ox = (width/2) * kappa, oy = (height/2) * kappa, xe = x + width, ye = y + height, xm = x + width/2, ym = y + height/2;
		context.beginPath(); context.moveTo(x, ym);
		context.bezierCurveTo(x, ym - oy, xm - ox, y, xm, y); context.bezierCurveTo(xm + ox, y, xe, ym - oy, xe, ym); context.bezierCurveTo(xe, ym + oy, xm + ox, ye, xm, ye); context.bezierCurveTo(xm - ox, ye, x, ym + oy, x, ym);
		context.closePath();
		if(over) { context.fillStyle = css3color(bg_color, 0.2); context.fill(); }
		context.stroke();
	}
	else if(type==2) {
		x = x_arr[0]; y = y_arr[0]; width = x_arr[1]; height = y_arr[1];
		if(over) { context.fillStyle = css3color(bg_color, 0.2); context.fillRect(x, y, width, height); }
		context.strokeRect(x, y, width, height);
	}
	else {
		context.beginPath();
		for(var i=0; i<x_arr.length; i++) { x = parseInt(x_arr[i]); y = parseInt(y_arr[i]); if(i==0) context.moveTo(x, y); else context.lineTo(x, y); }
		context.closePath();
		if(over) { context.fillStyle = css3color(bg_color, 0.2); context.fill(); }
		context.stroke();
	}
}

function cancelGeometry() {
	//데이터 초기화
	$('.geometry_complete_button').remove(); $('.geometry_cancel_button').remove(); $('#geometry_draw_canvas').remove();
	geometry_point_arr_1 = null; geometry_point_arr_1 = new Array(); geometry_point_arr_2 = null; geometry_point_arr_2 = new Array();
	geometry_click_move_val = false; geometry_click_move_point_x = 0; geometry_click_move_point_y = 0; geometry_point_before_x = 0; geometry_point_before_y = 0; geometry_point_num = 1;
}

/* save_start ----------------------------------- 저장 버튼 및 불러오기 설정 ------------------------------------- */
//저장 버튼 다이얼로그 오픈
function saveSetting() {
	$('#save_dialog').dialog('open');
}
//저장 실행
function saveVideoWrite(type) {
	$('#save_dialog').dialog('close');
	
	var obj_data_arr = new Array();
	
	var html_text = '';
	
	var objCount = $('#video_main_area').children().size();
	for(var i=0; i<objCount; i++) {
		var obj = $('#video_main_area').children().eq(i);
		var id = obj.attr('id');
		if(id=='') { obj = obj.children().eq(0); id = obj.attr('id'); }
		
		if(id!='video_player') {
			var buf1 = $('#frame'+id).css('top'); var frame_line = parseInt(buf1.replace('px',''));
			var buf2 = $('#frame'+id).css('left'); var frame_start = parseInt(buf2.replace('px',''));
			var buf3 = $('#frame'+id).css('width'); var frame_end = parseInt(buf3.replace('px','')) + frame_start;
			if(id.indexOf("c")!=-1) {
				var obj_font = $('#f'+id);
				var obj_pre = $('#p'+id);
				obj_data_arr.push([id.substring(0, 1), obj.position().top, obj.position().left, obj.html(), obj_font.css('font-size'), obj_font.css('color'), obj_pre.css('backgroundColor'), obj_pre.html(), frame_line, frame_start, frame_end]);
			}
			else if(id.indexOf("b")!=-1) {
				var obj_font = $('#f'+id);
				var obj_pre = $('#p'+id);
				var obj_pre_text = obj_pre.html();
				obj_pre_text = obj_pre_text.replace(/(\n|\r)+/g, "@line@");
				obj_data_arr.push([id.substring(0, 1), obj.position().top, obj.position().left, obj.html(), obj_font.css('font-size'), obj_font.css('color'), obj_pre.css('backgroundColor'), obj_pre_text, frame_line, frame_start, frame_end]);
			}
			else if(id.indexOf("i")!=-1) {
				obj_data_arr.push([id.substring(0, 1), obj.parent().position().top, obj.parent().position().left, obj.css('width'), obj.css('height'), obj.attr('src'), frame_line, frame_start, frame_end]);
			}
			else if(id.indexOf("g")!=-1) {
				var check_id, left, top, x_str, y_str, line_color, bg_color, geo_type;
				for(var j=0; j<geometry_total_arr_buf_1.length; j++) {
					var buf1 = geometry_total_arr_buf_1[j].split("\@");
					var buf2 = geometry_total_arr_buf_2[j].split("\@");
					check_id = buf1[0]; left = buf1[1]; top = buf2[1]; x_str = buf1[2]; y_str = buf2[2]; line_color = buf1[3]; bg_color = buf2[3]; geo_type = buf2[4];
					if(check_id==id) { obj_data_arr.push([id.substring(0, 1), top, left, x_str, y_str, line_color, bg_color, geo_type, frame_line, frame_start, frame_end]); }
				}
			}
			else {}
		}
	}
	var xml_text = makeXMLStr(obj_data_arr);
	var encode_xml_text = encodeURIComponent(xml_text);

	var buf_arr = full_url.split("/GeoCMS/");
	var base_url = buf_arr[0];
	var file_name = buf_arr[1];
	var replace_url = base_url+'/GeoCMS/';
	
	var encode_file_name = encodeURIComponent(file_name);
	if(type==1 || type==2) {
		//xml 저장
		$.ajax({
			type: 'POST',
			url: replace_url+'XMLServlet',
			data: 'file_name='+encode_file_name+'&xml_data='+encode_xml_text,
			success: function(data) { var response = data.trim(); }
		});
	}
	else if(type==3) {
		xml_text = xml_text.replace(/><+/g, "\>\\n\<");
		var conv_xml_text = encodeURIComponent(xml_text);
		
		window.open('', 'xml_view_page', 'width=530, height=630');
		var form = document.createElement('form');
		form.setAttribute('method','post');
		form.setAttribute('action','xml_view.jsp');
		form.setAttribute('target','xml_view_page');
		document.body.appendChild(form);
		
		var insert = document.createElement('input');
		insert.setAttribute('type','hidden');
		insert.setAttribute('name','xml_data');
		insert.setAttribute('value',conv_xml_text);
		form.appendChild(insert);
		
		form.submit();
	}
	else {}
}

function makeXMLStr(obj_data_arr) {
	var xml_text = '<?xml version="1.0" encoding="utf-8"?>';
	xml_text += "<upcm_obj>";
	for(var i=0; i<obj_data_arr.length; i++) {
		var buf_arr = obj_data_arr[i];
		var id = buf_arr[0];
		xml_text += "<obj>";
		xml_text += "<id>" + id + "</id>";
		var frame_line, frame_start, frame_end;
		if(id == "c" || id == "b") {
			var top = buf_arr[1];
			xml_text += "<top>" + top + "</top>";
			
			var left = buf_arr[2];
			xml_text += "<left>" + left + "</left>";
			
			var html_text = buf_arr[3];
			var href = "false";
			if(html_text.indexOf("<a href=")!=-1) href = "true";
			var underline = "false";
			if(html_text.indexOf("<u id=")!=-1) underline = "true";
			var italic = "false";
			if(html_text.indexOf("<i id=")!=-1) italic = "true";
			var bold = "false";
			if(html_text.indexOf("<b id=")!=-1) bold = "true";
			xml_text += "<href>" + href + "</href><underline>" + underline + "</underline><italic>" + italic + "</italic><bold>" + bold + "</bold>";
			
			var font_size = buf_arr[4];
			if(font_size == '14px') xml_text += "<fontsize>H3</fontsize>";
			else if(font_size == '18px') xml_text += "<fontsize>H2</fontsize>";
			else if(font_size == '22px') xml_text += "<fontsize>H1</fontsize>";
			else xml_text += "<fontsize>Normal</fontsize>";
			
			var font_color = rgb2hex(buf_arr[5]);
			xml_text += "<fontcolor>" + font_color + "</fontcolor>";
			
			var background_color = "none";
			if(buf_arr[6]!='transparent') background_color = rgb2hex(buf_arr[6]);
			xml_text += "<backgroundcolor>" + background_color + "</backgroundcolor>";
			
			var text = buf_arr[7];
			xml_text += "<text>" + text + "</text>";

			frame_line = buf_arr[8]; frame_start = buf_arr[9]; frame_end = buf_arr[10];
		}
		else if(id == "i") {
			var top = buf_arr[1];
			xml_text += "<top>" + top + "</top>";
			
			var left = buf_arr[2];
			xml_text += "<left>" + left + "</left>";
			
			var width = buf_arr[3];
			xml_text += "<width>" + width + "</width>";
			
			var height = buf_arr[4];
			xml_text += "<height>" + height + "</height>";
			
			var src = buf_arr[5];
			xml_text += "<src>" + src + "</src>";

			frame_line = buf_arr[6]; frame_start = buf_arr[7]; frame_end = buf_arr[8];
		}
		else if(id == "g") {
			var top = buf_arr[1];
			xml_text += "<top>" + top + "</top>";
			
			var left = buf_arr[2];
			xml_text += "<left>" + left + "</left>";
			
			var x_str = buf_arr[3];
			xml_text += "<xstr>" + x_str + "</xstr>";
			
			var y_str = buf_arr[4];
			xml_text += "<ystr>" + y_str + "</ystr>";
			
			var line_color = '#' + buf_arr[5];
			xml_text += "<linecolor>" + line_color + "</linecolor>";
			
			var background_color = '#' + buf_arr[6];
			xml_text += "<backgroundcolor>" + background_color + "</backgroundcolor>";
			
			var type = buf_arr[7];
			xml_text += "<type>" + type + "</type>";

			frame_line = buf_arr[8]; frame_start = buf_arr[9]; frame_end = buf_arr[10];
		}
		else {}
		xml_text += "<frameline>" + frame_line + "</frameline>";
		xml_text += "<framestart>" + frame_start + "</framestart>";
		xml_text += "<frameend>" + frame_end + "</frameend>";
		
		xml_text += "</obj>";
	}
	xml_text += "</upcm_obj>";
	
	return xml_text;
}
//소스가 길어서 따로 함수로 생성
function autoCreateText(id, font_size, font_color, bg_color, bold, italic, underline, href, text, top, left) {
	if(id == "c") {
		if(font_size == 'H3') $('#caption_font_select').val('H3');
		else if(font_size == 'H2') $('#caption_font_select').val('H2');
		else if(font_size == 'H1') $('#caption_font_select').val('H1');
		else $('#caption_font_select').val('Normal');
		
		$('#caption_font_color').val(font_color);
		if(bg_color!='none') { $('#caption_bg_color').val(bg_color); $('input[name=caption_bg_checkbok]').attr('checked', false); }
		else { bg_color = '#FFFFFF'; $('input[name=caption_bg_checkbok]').attr('checked', true); }
		
		var check_html = "";
		if(bold == 'true') check_html += '<input type="checkbox" id="caption_bold" class="caption_bold" checked="checked" /><label for="caption_bold" style="width:30px; height:30px;">Bold</label>';
		else check_html += '<input type="checkbox" id="caption_bold" class="caption_bold" /><label for="caption_bold" style="width:30px; height:30px;">Bold</label>';
		if(italic == 'true') check_html += '<input type="checkbox" id="caption_italic" class="caption_italic" checked="checked" /><label for="caption_italic" style="width:30px; height:30px;">Italic</label>';
		else check_html += '<input type="checkbox" id="caption_italic" class="caption_italic" /><label for="caption_italic" style="width:30px; height:30px;">Italic</label>';
		if(underline == 'true') check_html += '<input type="checkbox" id="caption_underline" class="caption_underline" checked="checked" /><label for="caption_underline" style="width:30px; height:30px;">Underline</label>';
		else check_html += '<input type="checkbox" id="caption_underline" class="caption_underline" /><label for="caption_underline" style="width:30px; height:30px;">Underline</label>';
		if(href == 'true') check_html += '<input type="checkbox" id="caption_link" class="caption_link" checked="checked" /><label for="caption_link" style="width:30px; height:30px;">HyperLink</label>';
		else check_html += '<input type="checkbox" id="caption_link" class="caption_link" /><label for="caption_link" style="width:30px; height:30px;">HyperLink</label>';
		$('#caption_check').html(check_html);
		$('#caption_text').val(text);
		
		createCaption();
		var obj = $('#'+auto_caption_str);
		obj.attr('style', 'position:absolute; left:'+left+'px; top:'+top+'px; display:block;');
	}
	else if(id == "b") {
		if(font_size == 'H3') $('#bubble_font_select').val('H3');
		else if(font_size == 'H2') $('#bubble_font_select').val('H2');
		else if(font_size == 'H1') $('#bubble_font_select').val('H1');
		else $('#bubble_font_select').val('Normal');
		
		$('#bubble_font_color').val(font_color);
		if(bg_color!='none') { $('#bubble_bg_color').val(bg_color); $('input[name=bubble_bg_checkbok]').attr('checked', false); }
		else { bg_color = '#FFFFFF'; $('input[name=bubble_bg_checkbok]').attr('checked', true); }
		
		var check_html = "";
		if(bold == 'true') check_html += '<input type="checkbox" id="bubble_bold" class="bubble_bold" checked="checked" /><label for="bubble_bold" style="width:30px; height:30px;">Bold</label>';
		else check_html += '<input type="checkbox" id="bubble_bold" class="bubble_bold" /><label for="bubble_bold" style="width:30px; height:30px;">Bold</label>';
		if(italic == 'true') check_html += '<input type="checkbox" id="bubble_italic" class="bubble_italic" checked="checked" /><label for="bubble_italic" style="width:30px; height:30px;">Italic</label>';
		else check_html += '<input type="checkbox" id="bubble_italic" class="bubble_italic" /><label for="bubble_italic" style="width:30px; height:30px;">Italic</label>';
		if(underline == 'true') check_html += '<input type="checkbox" id="bubble_underline" class="bubble_underline" checked="checked" /><label for="bubble_underline" style="width:30px; height:30px;">Underline</label>';
		else check_html += '<input type="checkbox" id="bubble_underline" class="bubble_underline" /><label for="bubble_underline" style="width:30px; height:30px;">Underline</label>';
		if(href == 'true') check_html += '<input type="checkbox" id="bubble_link" class="bubble_link" checked="checked" /><label for="bubble_link" style="width:30px; height:30px;">HyperLink</label>';
		else check_html += '<input type="checkbox" id="bubble_link" class="bubble_link" /><label for="bubble_link" style="width:30px; height:30px;">HyperLink</label>';
		$('#bubble_check').html(check_html);
		text = text.replace(/@line@/g, "\r\n");
		$('#bubble_text').val(text);
		
		createBubble();
		var obj = $('#'+auto_bubble_str);
		obj.attr('style', 'position:absolute; left:'+left+'px; top:'+top+'px; display:block;');
	}
}

function loadXML(full_url) {
	var buf_arr = full_url.split("/GeoCMS/");
	var base_url = buf_arr[0];
	var file_name = buf_arr[1];
	var replace_url = base_url+'/GeoCMS/';
	buf_arr = file_name.split(".");
	var xml_file_name = buf_arr[0] + '.xml';
	
	$.ajax({
		type: "GET",
		url: replace_url + xml_file_name,
		dataType: "xml",
		cache: false,
		success: function(xml) {
			jAlert('객체 정보를 로드 합니다.', '정보');
			var max_top = 0;
			$(xml).find('obj').each(function(index) {
				var frameline = $(this).find('frameline').text();
				if(max_top < parseInt(frameline)) max_top = parseInt(frameline);
			});
			var max_line = max_top / 25
			for(var i=0; i<max_line; i++) { createFrameLine(2); }
			$(xml).find('obj').each(function(index) {
				var id = $(this).find('id').text();
				var frame_obj;
				if(id == "c" || id == "b") {
					var font_size = $(this).find('fontsize').text(); var font_color = $(this).find('fontcolor').text(); var bg_color = $(this).find('backgroundcolor').text();
					var bold = $(this).find('bold').text(); var italic = $(this).find('italic').text(); var underline = $(this).find('underline').text(); var href = $(this).find('href').text();
					var text = $(this).find('text').text(); var top = $(this).find('top').text(); var left = $(this).find('left').text();
					autoCreateText(id, font_size, font_color, bg_color, bold, italic, underline, href, text, top, left);
					if(id == 'c') frame_obj = $('#frame'+auto_caption_str); else frame_obj = $('#frame'+auto_bubble_str);
				}
				else if(id == "i") {
					var top = $(this).find('top').text();
					var left = $(this).find('left').text();
					var width = $(this).find('width').text();
					var height = $(this).find('height').text();
					var src = $(this).find('src').text();
					
					createIcon(src);
					var obj = $('#'+auto_icon_str);
					obj.parent().position().top = top;
					obj.parent().position().left = left;
					
					obj.parent().attr('style', 'overflow: hidden; position: absolute; width:'+width+'; height:'+height+'; top:'+top+'px; left:'+left+'px; margin:0px;');
					obj.attr('style', 'position:static; display: block; top:'+top+'px; left:'+left+'px; width:'+width+'; height:'+height+';');
					frame_obj = $('#frame'+auto_icon_str);
				}
				else if(id == "g") {
					var buf = $(this).find('type').text();
					var type;
					if(buf=='circle') type = 1;
					else if(buf=='rect') type = 2;
					else if(buf=='point') type = 3;
					else {}
					
					var top = $(this).find('top').text();
					var left = $(this).find('left').text();
					var x_str = $(this).find('xstr').text();
					var y_str = $(this).find('ystr').text();
					var line_color = $(this).find('linecolor').text();
					var bg_color = $(this).find('backgroundcolor').text();
					$('#geometry_line_color').val(line_color);
					$('#geometry_bg_color').val(bg_color);
					var buf1 = x_str.split('_');
					for(var i=0; i<buf1.length; i++) { geometry_point_arr_1.push(parseInt(buf1[i])); }
					var buf2 = y_str.split('_');
					for(var i=0; i<buf2.length; i++) { geometry_point_arr_2.push(parseInt(buf2[i])); }
					createGeometry(type);
					frame_obj = $('#frame'+auto_geometry_str);
				}
				else {}
				var frame_obj_top = parseInt($(this).find('frameline').text());
				var frame_obj_left = parseInt($(this).find('framestart').text());
				var frame_obj_width = parseInt($(this).find('frameend').text()) - frame_obj_left;
				frame_obj.css({top:frame_obj_top, left:frame_obj_left, width:frame_obj_width});
			});
		},
		error: function(xhr, status, error) {
			//alert('XML 호출 오류! 관리자에게 문의하여 주세요.');
		}
	});
}

/* exit_start ----------------------------------- 종료 버튼 설정 ------------------------------------- */
function closeVideoWrite() {
	jConfirm('저작을 종료하시겠습니까?', '정보', function(type){
		if(type) { top.window.opener = top; top.window.open('','_parent',''); top.window.close(); }
	});
}

/* ------------------- 공통 기능 ----------------- */
//컴포넌트 숨기기
function compHide() {
	document.getElementById('caption_dialog').style.display='none';
	document.getElementById('bubble_dialog').style.display='none';
	document.getElementById('icon_dialog').style.display='none';
	document.getElementById('geometry_dialog').style.display='none';
	cancelGeometry();
}
//맵 크기 조절
var resize_map_state = 1;
var resize_scale = 400;
var init_map_left, init_map_top, init_map_width, init_map_height;
function resizeMap() {
	if(resize_map_state==1) {
		init_map_left = 610;
		init_map_top = 575;
		init_map_width = $('#video_map_area').width();
		init_map_height = $('#video_map_area').height();
		resize_map_state=2;
		$('#video_map_area').animate({left:init_map_left-resize_scale, top:init_map_top-resize_scale, width:init_map_width+resize_scale, height:init_map_height+resize_scale},"slow", function() { $('#resize_map_btn').css('background-image','url(../../images/icon_map_min.jpg)'); reloadMap(); });
	}
	else if(resize_map_state==2) {
		resize_map_state=1;
		$('#video_map_area').animate({left:init_map_left, top:init_map_top, width:init_map_width, height:init_map_height},"slow", function() { $('#resize_map_btn').css('background-image','url(../../images/icon_map_max.jpg)'); reloadMap(); });
	}
	else {}
}
function reloadMap() {
	$('#googlemap').get(0).contentWindow.resetCenter();
}
//객체 테이블
function insertTableObject(data_arr) {
	var html_text = "";
	html_text += "<tr id='obj_tr"+data_arr[0]+"' bgcolor='#cccffc' style='font-size:12px;'>";
	html_text += "<td align='center'><label>"+data_arr[0]+"</label></td>";
	html_text += "<td align='center'><label>"+data_arr[1]+"</label></td>";
	html_text += "<td id='obj_td"+data_arr[0]+"'><label>"+data_arr[2]+"</label></td>";
	html_text += "</tr>";
	
	$('#object_table tr:last').after(html_text);
	$('.ui-widget-content').css('fontSize', 12);
}
function replaceTableObject(data_arr) {
	$('#obj_td'+data_arr[0]).html(data_arr[2]);
}
function removeTableObject(id) {
	$('#obj_tr'+id).remove();
}

/* util_start ----------------------------------- Util ------------------------------------- */
rgb2hex = function(rgb) {
	rgb = rgb.match(/^rgba?\((\d+),\s*(\d+),\s*(\d+)(?:,\s*(\d+))?\)$/);
    function hex(x) {
        return ("0" + parseInt(x).toString(16)).slice(-2);
    }
    return "#" + hex(rgb[1]) + hex(rgb[2]) + hex(rgb[3]);
};
hex_to_decimal = function(hex) {
	return Math.max(0, Math.min(parseInt(hex, 16), 255));
};
css3color = function(color, opacity) {
	if(color.length==3) { var c1, c2, c3; c1 = color.substring(0, 1); c2 = color.substring(1, 2); c3 = color.substring(2, 3); color = c1 + c1 + c2 + c2 + c3 + c3; }
	return 'rgba('+hex_to_decimal(color.substr(0,2))+','+hex_to_decimal(color.substr(2,2))+','+hex_to_decimal(color.substr(4,2))+','+opacity+')';
};

</script>
</head>
<body onload='videoWriteInit();' bgcolor='#FFF'>

<!------------------------------------------------------ 화면 영역 ----------------------------------------------------------->
<!-- 저작 버튼 영역 -->
<div class='video_write_function' style='position:absolute; left:10px; top:10px; width:910px; display:block; background-color:#16193c;'>
	<table>
		<tr><td><button class='caption_button' onclick='inputCaption(0,"");'>Caption</button></td>
		<td><button class='speech_bubble_button' onclick='inputBubble(0,"");'>Speech Bubble</button></td>
		<td><button class='icon_button' onclick='inputIcon();'>Image</button></td>
		<td><button class='geometry_button' onclick='inputGeometry();'>Geometry</button></td>
		<td><button class='analysis_button' onclick=''>Analysis</button></td>
		<!-- <td width=700><button class='map_button' onclick='reloadMap(2);'>Map</button></td> -->
		<td width=700></td>
		<td><button class='save_button' onclick='saveSetting();'>Save</button></td>
		<td><button class='exit_button' onclick='closevideoWrite();'>EXIT</button></td></tr>
	</table>
</div>



<!-- 저작 영역 -->
<div id='video_main_area' style='position:absolute; left:10px; top:65px; width:590px; height:360px; display:block; border:1px solid #999999;'>
	<video id='video_player' width='570' height='340' controls='true' style='position:absolute; left:10px; top:10px;'>
		<source id='video_src' src='' type='video/ogg'></source>
		HTML5 지원 브라우저(Firefox 3.6 이상 또는 Chrome)에서 지원됩니다.
	</video>
</div>

<!-- 프레임 영역 -->
<div id='video_frame_area' style='position:absolute; left:10px; top:435px; width:590px; height:130px; display:block; border:1px solid #999999; overflow:scroll;'>
	<div style='position:absolute; left:50px; width:6000px; height:30px; background-image: url(images/timeline_time.png);'></div>
	<button class='frame_plus' style='position:absolute; left:0px; top:30px; width:25px; height:25px;' onclick='createFrameLine(2);'>Plus</button>
	<button class='frame_minus' style='position:absolute; left:25px; top:30px; width:25px; height:25px;' onclick='removeFrameLine();'>Minus</button>
	<div id='video_obj_area' style='position:absolute; left:50px; top:30px; width:6000px; height:25px; background:#CCF;'>
		<div id='video_guide' style='position:absolute; left:0px; top:-30px; width:2px; height:30px; background:#F00;'></div>
	</div>
</div>

<!-- 후보군 영역 -->
<div id='video_candidate_area' style='position:absolute; left:610px; top:65px; width:310px; height:245px; display:block; border:1px solid #999999; overflow-y:scroll;'>
	<table id='candidate_table'>
		<tr bgcolor='#16193c' style='font-size:12px;'>
			<td width=10 align='center'></td>
			<td width=40 align='center' style='color:#FFF;'>ID</td>
			<td width=120 align='center' style='color:#FFF;'>Name</td>
			<td width=50 align='center' style='color:#FFF;'>X1</td>
			<td width=50 align='center' style='color:#FFF;'>X2</td>
		</tr>
	</table>
</div>

<!-- 추가 객체 영역 -->
<div id='video_object_area' style='position:absolute; left:610px; top:320px; width:310px; height:245px; display:block; border:1px solid #999999; overflow-y:scroll;'>
	<table id='object_table'>
		<tr bgcolor='#16193c' style='font-size:12px;'>
			<td width=50 align='center' style='color:#FFF;'>ID</td>
			<td width=80 align='center' style='color:#FFF;'>Type</td>
			<td width=180 align='center' style='color:#FFF;'>Data</td>
		</tr>
	</table>
</div>

<!-- 저작 설정 영역 -->
<div id='video_sub_area' style='position:absolute; left:10px; top:575px; width:590px; height:210px; display:block; border:1px solid #999999;'>
</div>

<!-- 지도 영역 -->
<div id='video_map_area' style='position:absolute; left:610px; top:575px; width:310px; height:210px; display:block; background-color:#999;'>
	<iframe id='googlemap' src='../maps/video_googlemap.jsp' style='width:100%; height:100%; margin:1px; border:none;'></iframe>
	<div id='resize_map_btn' onclick='resizeMap();' style='position:absolute; left:0px; top:0px; width:30px; height:30px; cursor:pointer; background-image:url(../../images/icon_map_max.jpg)'>
	</div>
</div>



<!----------------------------------------------------- 서브 영역 ------------------------------------------------------------->

<!-- 자막 삽입 다이얼로그 객체 -->
<div id='caption_dialog' style='position:absolute; left:50px; top:600px; width:500px; height:150px; border:1px solid #999999; display:none;'>
	<div style='display:table; width:100%; height:100%;'>
		<div align="center" style='display:table-cell; vertical-align:middle;'>
			<table border='0'>
				<tr><td width=65><label style="font-size:12px;">Font Size : </label></td>
				<td><select id="caption_font_select" style="font-size:12px;"><option>Normal<option>H3<option>H2<option>H1</select></td>
				<td><label style="font-size:12px;">Font Color : </label></td>
				<td><input id="caption_font_color" type="text" class="iColorPicker" value="#FFFFFF" style="width:50px;"/></td>
				<td><label style="font-size:12px;">BG Color : </label></td>
				<td><input id="caption_bg_color" type="text" class="iColorPicker" value="#000000" style="width:50px;"/></td>
				<td id='caption_checkbox_td'><input type="checkbox" name="caption_bg_checkbok" onclick="checkCaption();"/><label style="font-size:12px;">투명</label></td></tr>
				<tr><td colspan='7' id='caption_check'></td></tr>
				<tr><td colspan='7'><hr/></td></tr>
				<tr><td colspan='5'><input id="caption_text" type="text" style="width:90%; font-size:12px; border:solid 2px #777;"/></td>
				<td colspan='2' align='center' id='caption_button'></td></tr>
			</table>
		</div>
	</div>
</div>

<!-- 말풍선 삽입 다이얼로그 객체 -->
<div id='bubble_dialog' style='position:absolute; left:50px; top:590px; width:500px; height:180px; border:1px solid #999999; display:none;'>
	<div style='display:table; width:100%; height:100%;'>
		<div align="center" style='display:table-cell; vertical-align:middle;'>
			<table border='0'>
				<tr><td width=65><label style="font-size:12px;">Font Size : </label></td>
				<td><select id="bubble_font_select" style="font-size:12px;"><option>Normal<option>H3<option>H2<option>H1</select></td>
				<td><label style="font-size:12px;">Font Color : </label></td>
				<td><input id="bubble_font_color" type="text" class="iColorPicker" value="#FFFFFF" style="width:50px;"/></td>
				<td><label style="font-size:12px;">BG Color : </label></td>
				<td><input id="bubble_bg_color" type="text" class="iColorPicker" value="#000000" style="width:50px;"/></td>
				<td id='bubble_checkbox_td'><input type="checkbox" name="bubble_bg_checkbok" onclick="checkBubble();"/><label style=" font-size:12px;">투명</label></td></tr>
				<tr><td colspan='7' id='bubble_check'></td></tr>
				<tr><td colspan='7'><hr/></td></tr>
				<tr><td colspan='5'><textarea id="bubble_text" rows="3" style="width:90%; font-size:12px; border:solid 2px #777;"></textarea></td>
				<td colspan='2' align='center' id='bubble_button'></td></tr>
			</table>
		</div>
	</div>
</div>

<!-- 아미지 삽입 다이얼로그 객체 -->
<div id='icon_dialog' style='position:absolute; left:50px; top:600px; width:500px; height:175px; border:1px solid #999999; display:none;'>
	<div style='position:absolute; left:5px; top:-15px;'>
		<button class="ui-state-default" style="width:80px; height:30px; font-size:12px;" onclick="tabImage(1);">Icon</button>
		<button class="ui-state-default" style="width:80px; height:30px; font-size:12px;" onclick="tabImage(2);">Image</button>
	</div>
	<div id='icon_div1' style='position:absolute; left:15px; top:20px; width:465px; height:150px; background-color:#999; border:1px solid #999999; overflow-y:scroll; display:block;'>
		<table id='icon_table1' border="0">
			<tr><td><img id='icon_img1' src=''></td><td><img id='icon_img2' src=''></td><td><img id='icon_img3' src=''></td><td><img id='icon_img4' src=''></td><td><img id='icon_img5' src=''></td><td><img id='icon_img6' src=''></td><td><img id='icon_img7' src=''></td><td><img id='icon_img8' src=''></td><td><img id='icon_img9' src=''></td><td><img id='icon_img10' src=''></td></tr>
			<tr><td><img id='icon_img11' src=''></td><td><img id='icon_img12' src=''></td><td><img id='icon_img13' src=''></td><td><img id='icon_img14' src=''></td><td><img id='icon_img15' src=''></td><td><img id='icon_img16' src=''></td><td><img id='icon_img17' src=''></td><td><img id='icon_img18' src=''></td><td><img id='icon_img19' src=''></td><td><img id='icon_img20' src=''></td></tr>
			<tr><td><img id='icon_img21' src=''></td><td><img id='icon_img22' src=''></td><td><img id='icon_img23' src=''></td><td><img id='icon_img24' src=''></td><td><img id='icon_img25' src=''></td><td><img id='icon_img26' src=''></td><td><img id='icon_img27' src=''></td><td><img id='icon_img28' src=''></td><td><img id='icon_img29' src=''></td><td><img id='icon_img30' src=''></td></tr>
			<tr><td><img id='icon_img31' src=''></td><td><img id='icon_img32' src=''></td><td><img id='icon_img33' src=''></td><td><img id='icon_img34' src=''></td><td><img id='icon_img35' src=''></td><td><img id='icon_img36' src=''></td><td><img id='icon_img37' src=''></td><td><img id='icon_img38' src=''></td><td><img id='icon_img39' src=''></td><td><img id='icon_img40' src=''></td></tr>
			<tr><td><img id='icon_img41' src=''></td><td><img id='icon_img42' src=''></td><td><img id='icon_img43' src=''></td><td><img id='icon_img44' src=''></td><td><img id='icon_img45' src=''></td><td><img id='icon_img46' src=''></td><td><img id='icon_img47' src=''></td><td><img id='icon_img48' src=''></td><td><img id='icon_img49' src=''></td><td><img id='icon_img50' src=''></td></tr>
			<tr><td><img id='icon_img51' src=''></td><td><img id='icon_img52' src=''></td><td><img id='icon_img53' src=''></td><td><img id='icon_img54' src=''></td><td><img id='icon_img55' src=''></td><td><img id='icon_img56' src=''></td><td><img id='icon_img57' src=''></td><td><img id='icon_img58' src=''></td><td><img id='icon_img59' src=''></td><td><img id='icon_img60' src=''></td></tr>
			<tr><td><img id='icon_img61' src=''></td><td><img id='icon_img62' src=''></td><td><img id='icon_img63' src=''></td><td><img id='icon_img64' src=''></td><td><img id='icon_img65' src=''></td><td><img id='icon_img66' src=''></td><td><img id='icon_img67' src=''></td><td><img id='icon_img68' src=''></td><td><img id='icon_img69' src=''></td><td><img id='icon_img70' src=''></td></tr>
			<tr><td><img id='icon_img71' src=''></td><td><img id='icon_img72' src=''></td><td><img id='icon_img73' src=''></td><td><img id='icon_img74' src=''></td><td><img id='icon_img75' src=''></td><td><img id='icon_img76' src=''></td><td><img id='icon_img77' src=''></td><td><img id='icon_img78' src=''></td><td><img id='icon_img79' src=''></td><td><img id='icon_img80' src=''></td></tr>
			<tr><td><img id='icon_img81' src=''></td><td><img id='icon_img82' src=''></td><td><img id='icon_img83' src=''></td><td><img id='icon_img84' src=''></td><td><img id='icon_img85' src=''></td><td><img id='icon_img86' src=''></td><td><img id='icon_img87' src=''></td><td><img id='icon_img88' src=''></td><td><img id='icon_img89' src=''></td><td><img id='icon_img90' src=''></td></tr>
			<tr><td><img id='icon_img91' src=''></td><td><img id='icon_img92' src=''></td><td><img id='icon_img93' src=''></td><td><img id='icon_img94' src=''></td><td><img id='icon_img95' src=''></td><td><img id='icon_img96' src=''></td><td><img id='icon_img97' src=''></td><td><img id='icon_img98' src=''></td><td><img id='icon_img99' src=''></td><td><img id='icon_img100' src=''></td></tr>
			<tr><td><img id='icon_img101' src=''></td><td><img id='icon_img102' src=''></td><td><img id='icon_img103' src=''></td><td><img id='icon_img104' src=''></td><td><img id='icon_img105' src=''></td><td><img id='icon_img106' src=''></td><td><img id='icon_img107' src=''></td><td><img id='icon_img108' src=''></td><td><img id='icon_img109' src=''></td><td><img id='icon_img110' src=''></td></tr>
			<tr><td><img id='icon_img111' src=''></td><td><img id='icon_img112' src=''></td><td><img id='icon_img113' src=''></td><td><img id='icon_img114' src=''></td><td><img id='icon_img115' src=''></td><td><img id='icon_img116' src=''></td><td><img id='icon_img117' src=''></td><td><img id='icon_img118' src=''></td><td><img id='icon_img119' src=''></td><td><img id='icon_img120' src=''></td></tr>
			<tr><td><img id='icon_img121' src=''></td><td><img id='icon_img122' src=''></td><td><img id='icon_img123' src=''></td><td><img id='icon_img124' src=''></td><td><img id='icon_img125' src=''></td><td><img id='icon_img126' src=''></td><td><img id='icon_img127' src=''></td><td><img id='icon_img128' src=''></td><td><img id='icon_img129' src=''></td><td><img id='icon_img130' src=''></td></tr>
		</table>
	</div>

	<div id='icon_div2' style='position:absolute; left:15px; top:20px; width:465px; height:150px; background-color:#999; border:1px solid #999999; overflow-y:scroll; display:none;'>
		<table id='icon_table2' border="1">
			<tr>
				<td>이미지 검색 바 위치</td>
			</tr>
			<tr>
				<td>이미지 검색 결과 위치</td>
			</tr>
		</table>
	</div>
</div>

<!-- Geometry 삽입 다이얼로그 객체 -->
<div id='geometry_dialog' style='position:absolute; left:50px; top:610px; width:500px; height:140px; border:1px solid #999999; display:none;'>
	<div style='display:table; width:100%; height:100%;'>
		<div align="center" style='display:table-cell; vertical-align:middle;'>
			<table id='geometry_table' border="0">
				<tr>
					<td><label style="font-size:12px;">Shape Style : </label>
					<input type='radio' name='geo_shape' value='circle'><label style="font-size:12px;">Circle</label>
					<input type='radio' name='geo_shape' value='rect'><label style="font-size:12px;">Rect</label>
					<input type='radio' name='geo_shape' value='point' checked><label style="font-size:12px;">Point</label></td>
					<td width='20'></td>
					<td rowspan='3'><button class="ui-state-default ui-corner-all" style="width:80px; height:30px; font-size:12px;" onclick="setGeometry();">확인</button></td>
				</tr>
				<tr><td><hr/></td><td width='20'></td></tr>
				<tr>
					<td><label style="font-size:12px;">Line Color : </label>
					<input id="geometry_line_color" type="text" class="iColorPicker" value="#959595" style="width:50px;"/>
					&nbsp;&nbsp;&nbsp;
					<label style="font-size:12px;">MouseOver Color : </label>
					<input id="geometry_bg_color" type="text" class="iColorPicker" value="#FF0000" style="width:50px;"/></td>
					<td width='20'></td>
				</tr>
			</table>
		</div>
	</div>
</div>

<!-- 오른클릭 Context Menu -->
<div id="context1" class="contextMenu">
	<ul>
		<!-- <li id="modify"><img src="abcd.png" />Modify</li> -->
		<li id="context_modify">Modify</li>
		<li id="context_delete">Delete</li>
	</ul>
</div>
<div id="context2" class="contextMenu">
	<ul>
		<li id="context_delete">Delete</li>
	</ul>
</div>

<!-- 저장 버튼 다이얼로그 객체 -->
<div id='save_dialog' class='save_dialog' title='저장 방식 선택'>
	<button class='ui-state-default ui-corner-all' style='width:300px; height:40px; font-size:11px;' onclick='saveVideoWrite(1);'>영상 정보에 저장</button><br/><br/>
	<button class='ui-state-default ui-corner-all' style='width:300px; height:40px; font-size:11px;' onclick='saveVideoWrite(2);'>XML 로 저장</button><br/><br/>
	<button class='ui-state-default ui-corner-all' style='width:300px; height:40px; font-size:11px;' onclick='saveVideoWrite(3);'>XML 문자열 보기</button>
</div>

</body>
</html>