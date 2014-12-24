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

/* init_start ----------------------------------- 객체 설정 ------------------------------------- */
var full_url = '<%= file_url %>';

$(function() {
	//$('.caption_button').button({ icons: { primary: 'ui-icon-grip-dotted-horizontal'} }); $('.caption_button').width(100); $('.caption_button').height(30); $('.caption_button').css('fontSize', 12); $('.caption_button').css('margin-top', 5); $('.caption_button').css('margin-left', 5); $('.caption_button').css('margin-bottom', 5);	
	//$('.speech_bubble_button').button({ icons: { primary: 'ui-icon-comment'} }); $('.speech_bubble_button').width(140); $('.speech_bubble_button').height(30); $('.speech_bubble_button').css('fontSize', 12);
	//$('.icon_button').button({ icons: { primary: 'ui-icon-heart'} }); $('.icon_button').width(100); $('.icon_button').height(30); $('.icon_button').css('fontSize', 12);	
	//$('.geometry_button').button({ icons: { primary: 'ui-icon-geometry'} }); $('.geometry_button').width(100); $('.geometry_button').height(30); $('.geometry_button').css('fontSize', 12);
	//$('.analysis_button').button({ icons: { primary: 'ui-icon-note'} }); $('.analysis_button').width(100); $('.analysis_button').height(30); $('.analysis_button').css('fontSize', 12);	
	$('.exif_button').button({ icons: { primary: 'ui-icon-exif'} }); $('.exif_button').width(100); $('.exif_button').height(30); $('.exif_button').css('fontSize', 12);	
	$('.map_button').button(); $('.map_button').width(60); $('.map_button').height(30); $('.map_button').css('fontSize', 12);
	$('.save_button').button({ icons: { primary: 'ui-icon-disk'}, text: false }); $('.save_button').width(30); $('.save_button').height(30);
	$('.exit_button').button({ icons: { primary: 'ui-icon-closethick'}, text: false }); $('.exit_button').width(30); $('.exit_button').height(30);
	
	$('#caption_font_size_label').css('fontSize', 12); $('#caption_font_select').css('fontSize', 12);
	$('#caption_font_color_label').css('fontSize', 12); $('#caption_font_color').css('fontSize', 12);
	$('#caption_bg_color_label').css('fontSize', 12); $('#caption_bg_color').css('fontSize', 12);
	$('#caption_checkbox_td').css('fontSize', 12);
	$('#bubble_font_size_label').css('fontSize', 12); $('#bubble_font_select').css('fontSize', 12);
	$('#bubble_font_color_label').css('fontSize', 12); $('#bubble_font_color').css('fontSize', 12);
	$('#bubble_bg_color_label').css('fontSize', 12); $('#bubble_bg_color').css('fontSize', 12);
	$('#bubble_checkbox_td').css('fontSize', 12);
	
	$('#icon_tab_title').addClass('ui-widget-header');
	$('.ui-widget-header').css('fontSize', 13);
	$('#icon_table1 tr td').addClass('ui-widget-content');
	$('#icon_table2 tr td').addClass('ui-widget-content');
	$('#normal_exif_table tbody tr td').addClass('ui-widget-content');
	$('#extends_exif_table tbody tr td').addClass('ui-widget-content');
	$('.ui-widget-content').css('fontSize', 12);
	
	$('#geometry_dialog').hide();
	
	$('#exif_dialog').hide();
	$('.exif_save_button').button(); $('.exif_save_button').width(60); $('.exif_save_button').height(30); $('.exif_save_button').css('fontSize', 12);
	$('.exif_cancel_button').button(); $('.exif_cancel_button').width(60); $('.exif_cancel_button').height(30); $('.exif_cancel_button').css('fontSize', 12);
	
	$('#image_map_area').hide();
	
	$('#context_modify').css('fontSize', 12);
	$('#context_delete').css('fontSize', 12);
	
	
});

/* init_start ----------------------------------- 사진 영역 설정 ------------------------------------- */
function imageWriteInit() {
	//이미지 그리기
	changeImage();
	
	//EXIF 로드
	//loadExif(base_url, file_url);
}

function changeImage() {
	var img = new Image();
	img.src = full_url;
	
	img.onload = function() {
		//이미지 Resize
		var result_arr;
		var margin = 10;
		var width = $('#image_write_image_area').width();
		var height = $('#image_write_image_area').height();
		
		result_arr = resizeImage(width, height, img.width, img.height, margin);
		//canvas 의 width height 비율과 다른 이미지의 경우 축소하여도 y 축이 음수가 나오는 경우를 처리하기 위함
		while(result_arr[1]<3) {
			margin += 10;
			result_arr = resizeImage(width, height, img.width, img.height, margin);
		}
		
		var img_element = $(document.createElement('img'));
		img_element.attr('id', 'image_write_canvas');
		img_element.attr('src', full_url);
		img_element.attr('style', 'position:absolute; left:'+result_arr[0]+'px; top:'+result_arr[1]+'px;');
		img_element.attr('width', result_arr[2]);
		img_element.attr('height', result_arr[3]);
		img_element.appendTo('#image_write_image_area');
	};
}

function resizeImage(canvas_width, canvas_height, img_width, img_height, margin) {
	var min;
	var max;
	var ratio;
	if(img_width>img_height) {
		min = img_height;
		max = img_width;
		ratio = (canvas_width-margin) / max;
	}
	else {
		min = img_width;
		max = img_height;
		ratio = (canvas_height-margin) / max;
	}
	var resize_width = img_width * ratio;
	var resize_height = img_height * ratio;
	
	var x = (canvas_width - resize_width) / 2; 
	var y = (canvas_height - resize_height) / 2;
	
	var result_arr = new Array();
	result_arr.push(x);
	result_arr.push(y);
	result_arr.push(resize_width);
	result_arr.push(resize_height);
	
	return result_arr;
}

/* init_start ----------------------------------- 닫기 버튼 설정 ------------------------------------- */
function closeImageWrite() {
	jConfirm('저작을 종료하시겠습니까?', '정보', function(type){
		if(type) {
			top.window.opener = top;
			top.window.open('','_parent','');
			top.window.close();
		}
	});
}

/* caption_start ----------------------------------- 자막 삽입 버튼 설정 ------------------------------------- */
function inputCaption(id, text) {
	$('#caption_dialog').dialog({
		autoOpen: false,
		title: 'Caption',
		resizable: false,
		modal: true,
		width: 510,
		height: 170,
		draggable: false,
		resize: false
	});
	$('#caption_dialog').bind('dialogopen', function() { $('.ui-dialog-title').css('fontSize', 16); });
	
	if(id==0 & text=="") {
		//caption dialog 내부 객체 초기화
		$('#caption_font_select').val('Normal');
		$('#caption_font_color').attr('disabled', true);
		$('#caption_font_color').val('#000000'); $('#caption_font_color').css('background-color', '#000000');
		$('#caption_bg_color').val('#FFFFFF'); $('#caption_bg_color').css('background-color', '#FFFFFF');
		$('#caption_bg_color').attr('disabled', true);
		$('input[name=caption_bg_checkbok]').attr('checked', true);
		$('#icp_caption_bg_color').removeAttr('onclick');
		
		$('#caption_check').html('<input type="checkbox" id="caption_bold" class="caption_bold" /><label for="caption_bold" style="width:30px; height:30px;">Bold</label><input type="checkbox" id="caption_italic" class="caption_italic" /><label for="caption_italic" style="width:30px; height:30px;">Italic</label><input type="checkbox" id="caption_underline" class="caption_underline" /><label for="caption_underline" style="width:30px; height:30px;">Underline</label><input type="checkbox" id="caption_link" class="caption_link" /><label for="caption_link" style="width:30px; height:30px;">HyperLink</label>');
		$('.caption_bold').button({ icons: { primary: 'ui-icon-bold'}, text: false }); $('.caption_italic').button({ icons: { primary: 'ui-icon-italic'}, text: false }); $('.caption_underline').button({ icons: { primary: 'ui-icon-underline'}, text: false }); $('.caption_link').button({ icons: { primary: 'ui-icon-link'}, text: false });
		$('#caption_button').html('<button class="ui-state-default ui-corner-all" style="width:80px; height:30px; font-size:12px;" onclick="createCaption();">입력</button>');
		$('#caption_text').val('');
	}
	else {
		//caption dialog 내부 객체 설정
		var font_size = $('#f'+id).css('font-size');
		if(font_size == '14px') $('#caption_font_select').val('H3');
		else if(font_size == '18px') $('#caption_font_select').val('H2');
		else if(font_size == '22px') $('#caption_font_select').val('H1');
		else $('#caption_font_select').val('Normal');
		var font_color = rgb2hex($('#f'+id).css('color'));
		$('#caption_font_color').val(font_color); $('#caption_font_color').css('background-color', font_color);
		var bg_color_value = $('#p'+id).css('backgroundColor');
		var bg_color = '';
		if(bg_color_value!='transparent') {
			bg_color = rgb2hex($('#p'+id).css('backgroundColor'));
			$('input[name=caption_bg_checkbok]').attr('checked', false);
		}
		else {
			bg_color = '#FFFFFF';
			$('input[name=caption_bg_checkbok]').attr('checked', true);
		}
		$('#caption_bg_color').val(bg_color); $('#caption_bg_color').css('background-color', bg_color);
		var check_html = "";
		var html_text = $('#'+id).html();
		if(html_text.indexOf('<b id') != -1) check_html += '<input type="checkbox" id="caption_bold" class="caption_bold" checked="checked" /><label for="caption_bold" style="width:30px; height:30px;">Bold</label>';
		else check_html += '<input type="checkbox" id="caption_bold" class="caption_bold" /><label for="caption_bold" style="width:30px; height:30px;">Bold</label>';
		if(html_text.indexOf('<i id') != -1) check_html += '<input type="checkbox" id="caption_italic" class="caption_italic" checked="checked" /><label for="caption_italic" style="width:30px; height:30px;">Italic</label>';
		else check_html += '<input type="checkbox" id="caption_italic" class="caption_italic" /><label for="caption_italic" style="width:30px; height:30px;">Italic</label>';
		if(html_text.indexOf('<u id') != -1) check_html += '<input type="checkbox" id="caption_underline" class="caption_underline" checked="checked" /><label for="caption_underline" style="width:30px; height:30px;">Underline</label>';
		else check_html += '<input type="checkbox" id="caption_underline" class="caption_underline" /><label for="caption_underline" style="width:30px; height:30px;">Underline</label>';
		if(html_text.indexOf('<a href') != -1) check_html += '<input type="checkbox" id="caption_link" class="caption_link" checked="checked" /><label for="caption_link" style="width:30px; height:30px;">HyperLink</label>';
		else check_html += '<input type="checkbox" id="caption_link" class="caption_link" /><label for="caption_link" style="width:30px; height:30px;">HyperLink</label>';
		$('#caption_check').html(check_html);
		$('.caption_bold').button({ icons: { primary: 'ui-icon-bold'}, text: false }); $('.caption_italic').button({ icons: { primary: 'ui-icon-italic'}, text: false }); $('.caption_underline').button({ icons: { primary: 'ui-icon-underline'}, text: false }); $('.caption_link').button({ icons: { primary: 'ui-icon-link'}, text: false });
		$('#caption_text').val($('#p'+id).html());
		$('#caption_button').html('<button class="ui-state-default ui-corner-all" style="width:80px; height:30px; font-size:12px;" onclick="replaceCaption('+id+');">수정</button>');
	}
	
	document.getElementById('caption_dialog').style.display='block';
	$('#caption_dialog').dialog('open');
}

function checkCaption() {
	if(!$('input[name=caption_bg_checkbok]').attr('checked')) {
		$('#icp_caption_bg_color').bind('click', function() { iColorShow('caption_bg_color','icp_caption_bg_color'); });
	}
	else {
		$('#icp_caption_bg_color').unbind('click');
	}
}

//caption 의 num 은 0~999 (최대 1000개 생성 가능..);
var auto_caption_num = 0;
function createCaption() {
	var font_size = $('#caption_font_select').val();
	var font_color = $('#caption_font_color').val();
	var bg_color = $('#caption_bg_color').val();
	var bg_check = $('input[name=caption_bg_checkbok]').attr('checked');
	var bold_check = $('#caption_bold').attr('checked');
	var italic_check = $('#caption_italic').attr('checked');
	var underline_check = $('#caption_underline').attr('checked');
	var link_check = $('#caption_link').attr('checked');
	var text = $('#caption_text').val();
	
	$('#caption_dialog').dialog('close');
	
	if(bg_check==true) bg_color = '';
	
	var html_text;
	//폰트, 색상 설정
	if(font_size=='H3') html_text = '<font id="f'+auto_caption_num+'" style="font-size:14px; color:'+font_color+';"><pre id="p'+auto_caption_num+'" style="background:'+bg_color+';">'+text+'</pre></font>';
	else if(font_size=='H2') html_text = '<font id="f'+auto_caption_num+'" style="font-size:18px; color:'+font_color+';"><pre id="p'+auto_caption_num+'" style="background:'+bg_color+';">'+text+'</pre></font>';
	else if(font_size=='H1') html_text = '<font id="f'+auto_caption_num+'" style="font-size:22px; color:'+font_color+';"><pre id="p'+auto_caption_num+'" style="background:'+bg_color+';">'+text+'</pre></font>';
	else html_text = '<font id="f'+auto_caption_num+'" style="color:'+font_color+';"><pre id="p'+auto_caption_num+'" style="background:'+bg_color+';">'+text+'</pre></font>';
	//bold, italic, underline, hyperlink 설정
	if(bold_check==true) html_text = '<b id="b'+auto_caption_num+'">'+html_text+'</b>';
	if(italic_check==true) html_text = '<i id="i'+auto_caption_num+'">'+html_text+'</i>';
	if(underline_check==true) html_text = '<u id="u'+auto_caption_num+'">'+html_text+'</u>';
	if(link_check==true) {
		if(html_text.indexOf('http://')== -1) html_text = '<a href="http://'+text+'" id="h'+auto_caption_num+'" target="_blank">'+html_text+'</a>';
		else html_text = '<a href="'+text+'" id="h'+auto_caption_num+'" target="_blank">'+html_text+'</a>';
	}
	
	var div_element = $(document.createElement('div'));
	div_element.attr('id', auto_caption_num);
	div_element.attr('style', 'position:absolute; left:10px; top:10px; display:block;');
	div_element.html(html_text);
	div_element.draggable();
	div_element.dblclick(function() {
		inputCaption(div_element.attr('id'), text);
	});
	
	div_element.appendTo('#image_write_image_area');

	$('#'+div_element.attr('id')).contextMenu('context1', {
		bindings: {
			'context_modify': function(t) {
				inputCaption(t.id, text);
			},
			'context_delete': function(t) {
				jConfirm('정말 삭제하시겠습니까?', '정보', function(type){
					if(type) {
						$('#'+t.id).remove();
						//image_write_image_area 의 자식 객체 중 canvas 가 1개 존재
						//그 외엔 모두 동적 생성 객체임
						//alert($('#image_write_image_area').children().size());
					}
				});
			}
		}
	});
	
	auto_caption_num++;
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
	
	$('#caption_dialog').dialog('close');
	
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
	
	$('#a'+id).remove();
	$('#u'+id).remove();
	$('#i'+id).remove();
	$('#b'+id).remove();
	$('#f'+id).remove();
	$('#p'+id).remove();
	
	$('#'+id).html(html_text);
}

/* bubble_start ----------------------------------- 말풍선 삽입 버튼 설정 ------------------------------------- */
function inputBubble(id, text) {
	$('#bubble_dialog').dialog({
		autoOpen: false,
		title: 'Speech Bubble',
		resizable: false,
		modal: true,
		width: 510,
		height: 210,
		draggable: false,
		resize: false
	});
	$('#bubble_dialog').bind('dialogopen', function() { $('.ui-dialog-title').css('fontSize', 16); });
	
	if(id==0 & text=="") {
		//bubble dialog 내부 객체 초기화
		$('#bubble_font_select').val('Normal');
		$('#bubble_font_color').val('#000000');	$('#bubble_font_color').css('background-color', '#000000');
		$('#bubble_font_color').attr('disabled', true);
		$('#bubble_bg_color').val('#FFFFFF'); $('#bubble_bg_color').css('background-color', '#FFFFFF');
		$('#bubble_bg_color').attr('disabled', true);
		$('input[name=bubble_bg_checkbok]').attr('checked', true);
		$('#icp_bubble_bg_color').removeAttr('onclick');
		
		$('#bubble_check').html('<input type="checkbox" id="bubble_bold" class="bubble_bold" /><label for="bubble_bold" style="width:30px; height:30px;">Bold</label><input type="checkbox" id="bubble_italic" class="bubble_italic" /><label for="bubble_italic" style="width:30px; height:30px;">Italic</label><input type="checkbox" id="bubble_underline" class="bubble_underline" /><label for="bubble_underline" style="width:30px; height:30px;">Underline</label><input type="checkbox" id="bubble_link" class="bubble_link" /><label for="bubble_link" style="width:30px; height:30px;">HyperLink</label>');
		$('.bubble_bold').button({ icons: { primary: 'ui-icon-bold'}, text: false }); $('.bubble_italic').button({ icons: { primary: 'ui-icon-italic'}, text: false }); $('.bubble_underline').button({ icons: { primary: 'ui-icon-underline'}, text: false }); $('.bubble_link').button({ icons: { primary: 'ui-icon-link'}, text: false });
		$('#bubble_button').html('<button class="ui-state-default ui-corner-all" style="width:80px; height:30px; font-size:12px;" onclick="createBubble();">입력</button>');
		$('#bubble_text').val('');
	}
	else {
		//bubble dialog 내부 객체 설정
		var font_size = $('#f'+id).css('font-size');
		if(font_size == '14px') $('#bubble_font_select').val('H3');
		else if(font_size == '18px') $('#bubble_font_select').val('H2');
		else if(font_size == '22px') $('#bubble_font_select').val('H1');
		else $('#bubble_font_select').val('Normal');
		var font_color = rgb2hex($('#f'+id).css('color'));
		$('#bubble_font_color').val(font_color); $('#bubble_font_color').css('background-color', font_color);
		var bg_color_value = $('#p'+id).css('backgroundColor');
		var bg_color = '';
		if(bg_color_value!='transparent') {
			bg_color = rgb2hex($('#p'+id).css('backgroundColor'));
			$('input[name=bubble_bg_checkbok]').attr('checked', false);
		}
		else {
			bg_color = '#FFFFFF';
			$('input[name=bubble_bg_checkbok]').attr('checked', true);
		}
		$('#bubble_bg_color').val(bg_color); $('#bubble_bg_color').css('background-color', bg_color);
		
		var check_html = "";
		var html_text = $('#'+id).html();
		if(html_text.indexOf('<b id') != -1) check_html += '<input type="checkbox" id="bubble_bold" class="bubble_bold" checked="checked" /><label for="bubble_bold" style="width:30px; height:30px;">Bold</label>';
		else check_html += '<input type="checkbox" id="bubble_bold" class="bubble_bold" /><label for="bubble_bold" style="width:30px; height:30px;">Bold</label>';
		if(html_text.indexOf('<i id') != -1) check_html += '<input type="checkbox" id="bubble_italic" class="bubble_italic" checked="checked" /><label for="bubble_italic" style="width:30px; height:30px;">Italic</label>';
		else check_html += '<input type="checkbox" id="bubble_italic" class="bubble_italic" /><label for="bubble_italic" style="width:30px; height:30px;">Italic</label>';
		if(html_text.indexOf('<u id') != -1) check_html += '<input type="checkbox" id="bubble_underline" class="bubble_underline" checked="checked" /><label for="bubble_underline" style="width:30px; height:30px;">Underline</label>';
		else check_html += '<input type="checkbox" id="bubble_underline" class="bubble_underline" /><label for="bubble_underline" style="width:30px; height:30px;">Underline</label>';
		if(html_text.indexOf('<a href') != -1) check_html += '<input type="checkbox" id="bubble_link" class="bubble_link" checked="checked" /><label for="bubble_link" style="width:30px; height:30px;">HyperLink</label>';
		else check_html += '<input type="checkbox" id="bubble_link" class="bubble_link" /><label for="bubble_link" style="width:30px; height:30px;">HyperLink</label>';
		$('#bubble_check').html(check_html);
		$('.bubble_bold').button({ icons: { primary: 'ui-icon-bold'}, text: false }); $('.bubble_italic').button({ icons: { primary: 'ui-icon-italic'}, text: false }); $('.bubble_underline').button({ icons: { primary: 'ui-icon-underline'}, text: false }); $('.bubble_link').button({ icons: { primary: 'ui-icon-link'}, text: false });
		$('#bubble_text').val($('#p'+id).html());
		$('#bubble_button').html('<button class="ui-state-default ui-corner-all" style="width:80px; height:30px; font-size:12px;" onclick="replaceBubble('+id+');">수정</button>');
	}
	
	document.getElementById('bubble_dialog').style.display='block';
	$('#bubble_dialog').dialog('open');
}

function checkBubble() {
	if(!$('input[name=bubble_bg_checkbok]').attr('checked')) {
		$('#icp_bubble_bg_color').bind('click', function() { iColorShow('bubble_bg_color','icp_bubble_bg_color'); });
	}
	else {
		$('#icp_bubble_bg_color').unbind('click');
	}
}

//caption 의 num 은 1000~1999 (최대 1000개 생성 가능..);
var auto_bubble_num = 1000;
function createBubble() {
	var font_size = $('#bubble_font_select').val();
	var font_color = $('#bubble_font_color').val();
	var bg_color = $('#bubble_bg_color').val();
	var bg_check = $('input[name=bubble_bg_checkbok]').attr('checked');
	var bold_check = $('#bubble_bold').attr('checked');
	var italic_check = $('#bubble_italic').attr('checked');
	var underline_check = $('#bubble_underline').attr('checked');
	var link_check = $('#bubble_link').attr('checked');
	var text = $('#bubble_text').val();
	
	$('#bubble_dialog').dialog('close');
	
	if(bg_check==true) bg_color = '';
	
	var html_text;
	//폰트, 색상 설정
	if(font_size=='H3') html_text = '<font id="f'+auto_bubble_num+'" style="font-size:14px; color:'+font_color+';"><pre id="p'+auto_bubble_num+'" style="background:'+bg_color+';">'+text+'</pre></font>';
	else if(font_size=='H2') html_text = '<font id="f'+auto_bubble_num+'" style="font-size:18px; color:'+font_color+';"><pre id="p'+auto_bubble_num+'" style="background:'+bg_color+';">'+text+'</pre></font>';
	else if(font_size=='H1') html_text = '<font id="f'+auto_bubble_num+'" style="font-size:22px; color:'+font_color+';"><pre id="p'+auto_bubble_num+'" style="background:'+bg_color+';">'+text+'</pre></font>';
	else html_text = '<font id="f'+auto_bubble_num+'" style="color:'+font_color+';"><pre id="p'+auto_bubble_num+'" style="background:'+bg_color+';">'+text+'</pre></font>';
	//bold, italic, underline, hyperlink 설정
	if(bold_check==true) html_text = '<b id="b'+auto_bubble_num+'">'+html_text+'</b>';
	if(italic_check==true) html_text = '<i id="i'+auto_bubble_num+'">'+html_text+'</i>';
	if(underline_check==true) html_text = '<u id="u'+auto_bubble_num+'">'+html_text+'</u>';
	if(link_check==true) {
		if(html_text.indexOf('http://')== -1) html_text = '<a href="http://'+text+'" id="h'+auto_bubble_num+'" target="_blank">'+html_text+'</a>';
		else html_text = '<a href="'+text+'" id="h'+auto_bubble_num+'" target="_blank">'+html_text+'</a>';
	}
	
	var div_element = $(document.createElement('div'));
	div_element.attr('id', auto_bubble_num);
	div_element.attr('style', 'position:absolute; left:10px; top:10px; display:block;');
	div_element.html(html_text);
	div_element.draggable();
	div_element.dblclick(function() {
		inputBubble(div_element.attr('id'), text);
	});
	
	div_element.appendTo('#image_write_image_area');

	$('#'+div_element.attr('id')).contextMenu('context1', {
		bindings: {
			'context_modify': function(t) {
				inputBubble(t.id, text);
			},
			'context_delete': function(t) {
				jConfirm('정말 삭제하시겠습니까?', '정보', function(type){
					if(type) {
						$('#'+t.id).remove();
						//image_write_image_area 의 자식 객체 중 canvas 가 1개 존재
						//그 외엔 모두 동적 생성 객체임
						//alert($('#image_write_image_area').children().size());
					}
				});
			}
		}
	});
	
	auto_bubble_num++;
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
	
	$('#bubble_dialog').dialog('close');
	
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
	
	$('#a'+id).remove();
	$('#u'+id).remove();
	$('#i'+id).remove();
	$('#b'+id).remove();
	$('#f'+id).remove();
	$('#p'+id).remove();
	
	$('#'+id).html(html_text);
}

/* icon_start ----------------------------------- 아이콘 & 이미지 삽입 버튼 설정 ------------------------------------- */
function inputIcon() {
	$('#icon_dialog').dialog({
		autoOpen: false,
		title: 'Icon & Image',
		resizable: false,
		modal: true,
		width: 475,
		height: 400,
		draggable: false,
		resize: false
	});
	$('#icon_dialog').bind('dialogopen', function() {
		$('#icon_tab').tabs();
		$('.ui-dialog-title').css('fontSize', 16);
	});
	$('#icon_dialog').bind('dialogclose', function() {
		$('#icon_tab').tabs('destroy');
	});
	document.getElementById('icon_dialog').style.display='block';
	$('#icon_dialog').dialog('open');
}

function selectIcon(num) {
	if(num<10) createIcon(full_url);
	else {}
}

var auto_icon_num = 2000;
function createIcon(img_src) {
	$('#icon_dialog').dialog('close');
	
	var img_element = $(document.createElement('img'));
	img_element.attr('id', auto_icon_num);
	img_element.attr('src', img_src);
	img_element.attr('style', 'position:absolute; display:block; left:30px; top:30px;');
	img_element.attr('width', 100);
	img_element.attr('height', 100);
	
	img_element.appendTo('#image_write_image_area');
	$('#'+img_element.attr('id')).resizable().parent().draggable();
	
	$('#'+img_element.attr('id')).contextMenu('context2', {
		bindings: {
			'context_delete': function(t) {
				jConfirm('정말 삭제하시겠습니까?', '정보', function(type){ if(type) $('#'+t.id).remove(); });
			}
		}
	});
	
	auto_icon_num++;
}

/* geo_start ----------------------------------- 지오매트리 삽입 버튼 설정 ------------------------------------- */

function viewGeometry() {
	if($('#geometry_dialog').css('display')=='none') {
		$('#geometry_dialog').slideDown("slow");
	}
	else {
		$('#geometry_dialog').slideUp("slow");
	}
}

var geometry_point_arr_x = new Array();
var geometry_point_arr_y = new Array();
var geometry_point_before_x = 0;
var geometry_point_before_y = 0;
var geometry_point_num = 1;
function inputGeometry() {
	jAlert("Geometry 로 표시하고 싶은 위치에 마우스를 클릭하여 좌표를 설정하세요.\n\n그리기 완료 버튼을 선택하지 않으면 저장되지 않습니다.\n\n첫번째 클릭 좌표와 마지막 클릭 좌표는 그리기 완료 버튼 클릭 시 자동 연결됩니다.", '정보');
	
	var left = $('#image_write_canvas').css('left');
	var top = $('#image_write_canvas').css('top');
	var width = $('#image_write_canvas').attr('width');
	var height = $('#image_write_canvas').attr('height');
	
	var canvas_element = $(document.createElement('canvas'));
	canvas_element.attr('id', 'geometry_draw_canvas');
	canvas_element.attr('style', 'position:absolute; display:block; left:'+left+'; top:'+top+';');
	canvas_element.attr('width', width);
	canvas_element.attr('height', height);
	canvas_element.click(function(e) {
		//좌표점 계산
		var left_str = $('#image_write_image_area').css('left');
		var top_str = $('#image_write_image_area').css('top');
		var left = parseInt(left_str.replace('px',''));
		var top = parseInt(top_str.replace('px',''));
		var x = e.pageX - (this.offsetLeft + left);
		var y = e.pageY - (this.offsetTop + top);
		
		//클릭 좌표점에 원과 숫자 그리기
		var context = document.getElementById('geometry_draw_canvas').getContext("2d");
		context.beginPath();
		context.arc(x, y, 5, 0, 2*Math.PI, true);
		context.stroke();
		
		if(geometry_point_num>=10) context.fillText(geometry_point_num, x-7, y-6);
		else context.fillText(geometry_point_num, x-3, y-6);
		geometry_point_num++;
		
		if(geometry_point_before_x == 0 && geometry_point_before_y == 0) {
			geometry_point_before_x = x;
			geometry_point_before_y = y;
		}
		else {
			context.moveTo(geometry_point_before_x, geometry_point_before_y);
			context.lineTo(x, y);
			geometry_point_before_x = x;
			geometry_point_before_y = y;
			context.stroke();
		}
		
		context.closePath();
		
		geometry_point_arr_x.push(x);
		geometry_point_arr_y.push(y);
	});
	
	canvas_element.appendTo('#image_write_image_area');
	
	//그리기 완료 및 그리기 취소 버튼
	var html_text = '<button class="geometry_complete_button" onclick="createGeometry();" style="left:0px; top:0px;">그리기 완료</button>';
	html_text += '<button class="geometry_cancel_button" onclick="cancelGeometry();" style="left:10px; top:0px;">그리기 취소</button>';
	$('#image_write_image_area').append(html_text);
	$('.geometry_complete_button').button(); $('.geometry_cancel_button').button();
	$('.geometry_complete_button').width(100); $('.geometry_cancel_button').width(100);
	$('.geometry_complete_button').height(30); $('.geometry_cancel_button').height(30);
	$('.geometry_complete_button').css('fontSize', 12); $('.geometry_cancel_button').css('fontSize', 12);
}

var auto_geometry_num = 3000;
var geometry_total_x_arr = new Array();
var geometry_total_y_arr = new Array();
function createGeometry() {
	//좌표점에서 사각형 찾기
	var min_x = Math.min.apply(Math, geometry_point_arr_x);
	var max_x = Math.max.apply(Math, geometry_point_arr_x);
	var min_y = Math.min.apply(Math, geometry_point_arr_y);
	var max_y = Math.max.apply(Math, geometry_point_arr_y);
	var left = min_x;
	var top = min_y;
	var width = max_x - min_x;
	var height = max_y - min_y;
	var left_str = $('#image_write_canvas').css('left');
	var top_str = $('#image_write_canvas').css('top');
	
	var left_offset = parseInt(left_str.replace('px',''));
	var top_offset = parseInt(top_str.replace('px',''));
	left += left_offset;
	top += top_offset;
	
	//canvas 객체 삽입
	var canvas_element = $(document.createElement('canvas'));
	canvas_element.attr('id', auto_geometry_num);
	canvas_element.attr('style', 'position:absolute; display:block; left:'+left+'px; top:'+top+'px;');
	canvas_element.attr('width', width);
	canvas_element.attr('height', height);
	canvas_element.mouseover(function() {
		mouseeventGeometry(this.id, true);
	});
	canvas_element.mouseout(function() {
		mouseeventGeometry(this.id, false);
	});
	canvas_element.appendTo('#image_write_image_area');
	$('#'+canvas_element.attr('id')).contextMenu('context2', {
		bindings: {
			'context_delete': function(t) {
				jConfirm('정말 삭제하시겠습니까?', '정보', function(type){ if(type) $('#'+t.id).remove(); });
			}
		}
	});

	//canvas 객체에 Geometry 그리기
	var canvas = $('#'+auto_geometry_num);
	var context = canvas[0].getContext("2d");
	
	context.beginPath();
	var x, y;
	var x_str = auto_geometry_num+'@';
	var y_str = auto_geometry_num+'@';
	for(var i=0; i<geometry_point_arr_x.length; i++) {
		x = Math.abs(left - geometry_point_arr_x[i] - left_offset);
		y = Math.abs(top - geometry_point_arr_y[i] - top_offset);
		if(i==0) context.moveTo(x, y);
		else context.lineTo(x, y);
		if(i==geometry_point_arr_x.length-1) {
			x_str += x;
			y_str += y;
		}
		else {
			x_str += x + '_';
			y_str += y + '_';
		}
	}
	context.closePath();
	
	context.strokeStyle = css3color('ff0000', 1);
	context.lineWidth = 1;
	context.stroke();
	
	auto_geometry_num++;
	
	//데이터 저장
	geometry_total_x_arr.push(x_str);
	geometry_total_y_arr.push(y_str);
	
	cancelGeometry();
}
function mouseeventGeometry(id, over) {
	//좌표 배열에서 좌표 가져옴
	var x_arr, y_arr;
	var x_str, y_str;
	for(var i=0; i<geometry_total_x_arr.length; i++) {
		if(id==geometry_total_x_arr[i].split("\@")[0]) {
			x_str = geometry_total_x_arr[i].split("\@")[1];
			y_str = geometry_total_y_arr[i].split("\@")[1];
			x_arr = x_str.split("_");
			y_arr = y_str.split("_");
		}
	}
	var canvas = $('#'+id);
	var context = canvas[0].getContext("2d");
	context.clearRect(0,0,canvas.attr('width'),canvas.attr('height'));
	context.beginPath();
	for(var i=0; i<x_arr.length; i++) {
		var x = parseInt(x_arr[i]);
		var y = parseInt(y_arr[i]);
		if(i==0) context.moveTo(x, y);
		else context.lineTo(x, y);
	}
	context.closePath();
	
	if(over) {
		context.fillStyle = css3color('000000', 0.2);
		context.fill();
	}
	context.strokeStyle = css3color('ff0000', 1);
	context.lineWidth = 1;
	context.stroke();
}

function cancelGeometry() {
	//데이터 초기화
	$('.geometry_complete_button').remove();
	$('.geometry_cancel_button').remove();
	$('#geometry_draw_canvas').remove();
	geometry_point_arr_x = null;
	geometry_point_arr_x = new Array();
	geometry_point_arr_y = null;
	geometry_point_arr_y = new Array();
	geometry_point_before_x = 0;
	geometry_point_before_y = 0;
	geometry_point_num = 1;
}

/* exif_start ----------------------------------- EXIF 버튼 설정 ------------------------------------- */
function viewEXIF() {
	if($('#exif_dialog').css('display')=='none') {
		$('#exif_dialog').slideDown("slow");
		loadExif(full_url);
	}
	else {
		$('#exif_dialog').slideUp("slow");
	}
}

function cancelExif() {
	loadExif(full_url);
}

function saveExif() {
	var buf_arr = full_url.split("/GeoCMS/");
	var base_url = buf_arr[0];
	var file_name = buf_arr[1];
	var replace_url = base_url+'/GeoCMS/';
	
	var encode_file_name = encodeURIComponent(file_name);
	
	var data_text = "";
	if($('#comment_text').val()!='Not Found.') data_text += $('#comment_text').val() + "\<GPSDirection\>";
	else data_text += "\<NONE\>\<GPSDirection\>";
	if($('#gps_direction_text').val()!='Not Found.') data_text += $('#gps_direction_text').val() + "\<LineSeparator\>";
	else data_text += "\<NONE\>\<LineSeparator\>";
	if($('#lon_text').val()!='Not Found.') data_text += $('#lon_text').val() + "\<LineSeparator\>";
	else data_text += "\<NONE\>\<LineSeparator\>";
	if($('#lat_text').val()!='Not Found.') data_text += $('#lat_text').val() + "\<LineSeparator\>";
	else data_text += "\<NONE\>";
	
	$.ajax({
		type: 'POST',
		url: replace_url+'ExifServlet',
		data: 'file_name='+encode_file_name+'&type=save&data='+data_text,
		success: function(data) {
			var response = data.trim();
			
			//exifSetting(response);
		}
	});
}

function loadExif(full_url) {
	//ajax 송신 시 URL 을 수정해줘야 함..
	//viewer 의 depth 에 따른 URL 문제로 ExifServlet 을 호출할 경우
	//http://xxx.xxx.xxx.xxx:8002/GeoCMS/sub/viewer/ExifServlet 으로 호출됨..
	var buf_arr = full_url.split("/GeoCMS/");
	var base_url = buf_arr[0];
	var file_name = buf_arr[1];
	var replace_url = base_url+'/GeoCMS/';
	
	var encode_file_name = encodeURIComponent(file_name);
	
	$.ajax({
		type: 'POST',
		url: replace_url+'ExifServlet',
		data: 'file_name='+encode_file_name+'&type=load',
		success: function(data) {
			var response = data.trim();
			
			exifSetting(response);
		}
	});
}

function exifSetting(data) {
	var line_buf_arr = data.split("\<LineSeparator\>");
	
	var line_data_buf_arr;
	
	//Make
	line_data_buf_arr = line_buf_arr[0].split("\<Separator\>");
	document.getElementById("make_text").value = line_data_buf_arr[1];
	//Model
	line_data_buf_arr = line_buf_arr[1].split("\<Separator\>");
	document.getElementById("model_text").value = line_data_buf_arr[1];
	//Date Time
	line_data_buf_arr = line_buf_arr[2].split("\<Separator\>");
	document.getElementById("date_text").value = line_data_buf_arr[1];
	//Flash
	line_data_buf_arr = line_buf_arr[3].split("\<Separator\>");
	document.getElementById("flash_text").value = line_data_buf_arr[1];
	//Shutter Speed
	line_data_buf_arr = line_buf_arr[4].split("\<Separator\>");
	document.getElementById("shutter_text").value = line_data_buf_arr[1];
	//Aperture
	line_data_buf_arr = line_buf_arr[5].split("\<Separator\>");
	document.getElementById("aperture_text").value = line_data_buf_arr[1];
	//Max Aperture
	line_data_buf_arr = line_buf_arr[6].split("\<Separator\>");
	document.getElementById("m_aperture_text").value = line_data_buf_arr[1];
	//Focal Length
	line_data_buf_arr = line_buf_arr[7].split("\<Separator\>");
	document.getElementById("focal_text").value = line_data_buf_arr[1];
	//Digital Zoom
	line_data_buf_arr = line_buf_arr[8].split("\<Separator\>");
	document.getElementById("zoom_text").value = line_data_buf_arr[1];
	//White Balance
	line_data_buf_arr = line_buf_arr[9].split("\<Separator\>");
	document.getElementById("white_text").value = line_data_buf_arr[1];
	//Brightness
	line_data_buf_arr = line_buf_arr[10].split("\<Separator\>");
	document.getElementById("bright_text").value = line_data_buf_arr[1];
	//GPS IMG Direction
	line_data_buf_arr = line_buf_arr[11].split("\<Separator\>");
	document.getElementById("img_direction_text").value = line_data_buf_arr[1];
	//User Comment
	line_data_buf_arr = line_buf_arr[12].split("\<Separator\>");
	if(line_data_buf_arr[1].charAt(0)=="'" && line_data_buf_arr[1].charAt(line_data_buf_arr[1].length-1)=="'") line_data_buf_arr[1] = line_data_buf_arr[1].substring(1, line_data_buf_arr[1].length-1);
	if(line_data_buf_arr[1].indexOf("\<GPSDirection\>")!=-1) {
		var buf_arr = line_data_buf_arr[1].split("\<GPSDirection\>");
		if(buf_arr[0]=='') document.getElementById("comment_text").value = 'Not Found.';
		else document.getElementById("comment_text").value = buf_arr[0];
		if(buf_arr[1]=='') document.getElementById("gps_direction_text").value = 'Not Found.';
		else document.getElementById("gps_direction_text").value = buf_arr[1];
	}
	if(line_data_buf_arr[1]=="Not Found.") {
		document.getElementById("comment_text").value = "Not Found.";
		document.getElementById("gps_direction_text").value = "Not Found.";
	}
	//GPS Speed
	line_data_buf_arr = line_buf_arr[13].split("\<Separator\>");
	document.getElementById("speed_text").value = line_data_buf_arr[1];
	//GPS Altitude
	line_data_buf_arr = line_buf_arr[14].split("\<Separator\>");
	document.getElementById("alt_text").value = line_data_buf_arr[1];
	//GPS Longitude
	line_data_buf_arr = line_buf_arr[15].split("\<Separator\>");
	document.getElementById("lon_text").value = line_data_buf_arr[1];
	//GPS Latitude
	line_data_buf_arr = line_buf_arr[16].split("\<Separator\>");
	document.getElementById("lat_text").value = line_data_buf_arr[1];
}

/* map_start ----------------------------------- 맵 버튼 설정 ------------------------------------- */
var scale_value = 0.3;
var scale_state = 1;
var origin_left, origin_width, origin_height;
function viewMap() {
	if(scale_state==1) {
		origin_left = 510;
		origin_width = $('#image_map_area').width();
		origin_height = $('#image_map_area').height();
		scale_state = 2;
	}
	
	if(scale_state==2) {
		$('#image_map_area').slideDown("slow");
		scale_state = 3;
	}
	else if(scale_state==3) {
		var scale_width = origin_width * scale_value;
		var scale_height = origin_height * scale_value;
		var point = (origin_width - scale_width) + origin_left;
		$('#image_map_area').animate({width:scale_width, height:scale_height, left:point});
		scale_state = 4;
	}
	else if(scale_state==4) {
		$('#image_map_area').slideUp("slow");
		$('#image_map_area').animate({width:origin_width, height:origin_height, left:origin_left});
		scale_state = 2;
	}
}

/* save_start ----------------------------------- 저장 버튼 설정 ------------------------------------- */
function saveImageWrite() {
	var html_text = '';
	for(var i=0; i<4000; i++) {
		var obj = $('#'+i);
		if(obj.attr('id')==i) {
			if(0<=i && i<1000) {
				//자막
				html_text += i + '\n' + obj.html() + '\n';
			}
			else if(1000<=i && i<2000) {
				//말풍선
				html_text += i + '\n' + obj.html() + '\n';
			}
			else if(2000<=i && i<3000) {
				//아이콘
				html_text += i + '\n' + obj.html() + '\n';
			}
			else if(3000<=i && i<4000) {
				//지오매트리
				var x_str, y_str;
				for(var j=0; j<geometry_total_x_arr.length; j++) {
					if(i==geometry_total_x_arr[j].split("\@")[0]) {
						x_str = geometry_total_x_arr[j].split("\@")[1];
						y_str = geometry_total_y_arr[j].split("\@")[1];
						html_text += i + '\n' + x_str + "@" + y_str + '\n';
					}
				}
			}
			else {}
		}
	}
	alert("XML 로 표현 예정입니다.\n\n\n\n"+html_text);
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
	return 'rgba('+hex_to_decimal(color.substr(0,2))+','+hex_to_decimal(color.substr(2,2))+','+hex_to_decimal(color.substr(4,2))+','+opacity+')';
};
</script>

</head>
<body onload='imageWriteInit();' bgcolor='#2a2a2a'>
<!-- 저작 기능 영역 -->
<div class='image_write_function' style='position:absolute; left:10px; top:10px; width:1000px; display:block; background-image:url(images/bg1000x40.jpg);'>
	<table>
		<tr>
			<td>
				<button class='caption_button' onclick='inputCaption(0,"");'>Caption</button>
			</td>
			<td>
				<button class='speech_bubble_button' onclick='inputBubble(0,"");'>Speech Bubble</button>
			</td>
			<td>
				<button class='icon_button' onclick='inputIcon();'>Image</button>
			</td>
			<td>
				<button class='geometry_button' onclick='viewGeometry();'>Geometry</button>
			</td>
			<!-- <td>
				<button class='analysis_button' onclick=''>Analysis</button>
			</td> -->
			<td>
				<button class='exif_button' onclick='viewEXIF();'>EXIF</button>
			</td>
			<td>
				<button class='map_button' onclick='viewMap();'>Map</button>
			</td>
			<td>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</td>
			<td>
				<button class='save_button' onclick='saveImageWrite();'>Save</button>
			</td>
			<td>
				<button class='exit_button' onclick='closeImageWrite();'>EXIT</button>
			</td>
		</tr>
	</table>
</div>

<!-- 이미지 영역 -->
<div id='image_write_image_area' style='position:absolute; left:10px; top:65px; width:1000px; height:600px; display:block; border:1px solid #999999;'>
</div>

<!-- 지도 영역 -->
<div id='image_map_area' style='position:absolute; left:510px; top:65px; width:500px; height:400px; display:block; background-color:#999;'>
	<iframe src='../maps/googlemap.jsp' style='width:100%; height:100%; margin:1px; border:none;'></iframe>
</div>

<!-- 자막 삽입 다이얼로그 객체 -->
<div id='caption_dialog' style='display:none;'>
	<table border="0">
		<tr>
			<td width=60><label id="caption_font_size_label">Font Size : </label></td>
			<td><select id="caption_font_select"><option>Normal<option>H3<option>H2<option>H1</select></td>
			<td><label id="caption_font_color_label">Font Color : </label></td>
			<td><input id="caption_font_color" type="text" class="iColorPicker" value="#FFFFFF" style="width:50px;"/></td>
			<td><label id="caption_bg_color_label">BG Color : </label></td>
			<td><input id="caption_bg_color" type="text" class="iColorPicker" value="#000000" style="width:50px;"/></td>
			<td id='caption_checkbox_td'><input type="checkbox" name="caption_bg_checkbok" onclick="checkCaption();"/>투명</td>
		</tr>
		<tr>
			<td colspan='7' id='caption_check'>
			</td>
		</tr>
		<tr>
			<td colspan='5'>
				<input id="caption_text" type="text" style="width:90%; background-color:#333; color:#fff; font-size:12px; border:solid 2px #777;"/>
			</td>
			<td colspan='2' align='center' id='caption_button'>
			</td>
		</tr>
	</table>
</div>

<!-- 말풍선 삽입 다이얼로그 객체 -->
<div id='bubble_dialog' style='display:none;'>
	<table border="0">
		<tr>
			<td width=60><label id="bubble_font_size_label">Font Size : </label></td>
			<td><select id="bubble_font_select"><option>Normal<option>H3<option>H2<option>H1</select></td>
			<td><label id="bubble_font_color_label">Font Color : </label></td>
			<td><input id="bubble_font_color" type="text" class="iColorPicker" value="#FFFFFF" style="width:50px;"/></td>
			<td><label id="bubble_bg_color_label">BG Color : </label></td>
			<td><input id="bubble_bg_color" type="text" class="iColorPicker" value="#000000" style="width:50px;"/></td>
			<td id='bubble_checkbox_td'><input type="checkbox" name="bubble_bg_checkbok" onclick="checkBubble();"/>투명</td>
		</tr>
		<tr>
			<td colspan='7' id='bubble_check'>
			</td>
		</tr>
		<tr>
			<td colspan='5'>
				<textarea id="bubble_text" rows="3" style="width:90%; background-color:#333; color:#fff; font-size:12px; border:solid 2px #777;"></textarea>
			</td>
			<td colspan='2' align='center' id='bubble_button'>
			</td>
		</tr>
	</table>
</div>

<!-- 아미지 삽입 다이얼로그 객체 -->
<div id='icon_dialog' style='display:none;'>
	<div id='icon_tab'>
		<ul id='icon_tab_title'>
			<li><a href="#icon_tab1">Icon</a></li>
			<li><a href="#icon_tab2">Image</a></li>
		</ul>
		<div id='icon_tab1'>
			<table id='icon_table1' border="1">
				<tr>
					<td onclick="selectIcon(1);">아이콘1</td>
					<td onclick="selectIcon(1);">아이콘2</td>
					<td onclick="selectIcon(1);">아이콘3</td>
				</tr>
				<tr>
					<td onclick="selectIcon(1);">아이콘4</td>
					<td onclick="selectIcon(1);">아이콘5</td>
					<td onclick="selectIcon(1);">아이콘6</td>
				</tr>
				<tr>
					<td onclick="selectIcon(1);">아이콘7</td>
					<td onclick="selectIcon(1);">아이콘8</td>
					<td onclick="selectIcon(1);">아이콘9</td>
				</tr>
			</table>
		</div>
		<div id='icon_tab2'>
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
</div>

<!-- Geometry 삽입 다이얼로그 객체 -->
<div id='geometry_dialog' style='position:absolute; left:450px; top:60px; width:300px; height:200px; background-color:#F8CA28;'>
	<table id='geometry_table' border="1">
		<caption class='ui-widget-header'>Shape Style</caption>
		<tbody>
			<tr>
				<td onclick="selectIcon(1);">원</td>
				<td onclick="selectIcon(1);">사각형</td>
				<td onclick="selectIcon(1);">포인트</td>
			</tr>
		</tbody>
	</table>
</div>

<!-- EXIF 영역 -->
<div id='exif_dialog' style='position:absolute; left:550px; top:60px; width:300px; height:600px; background-color:#F8CA28;'>
	<table id='normal_exif_table'>
		<caption class='ui-widget-header'>Normal Info</caption>
		<tbody>
			<tr>
				<td width='100'>Make</td><td width='150'><input id='make_text' name='text' type='text' disabled/></td>
			</tr>
			<tr>
				<td>Model</td><td><input id='model_text' name='text' type='text' disabled/></td>
			</tr>
			<tr>
				<td>Date Time</td><td><input id='date_text' name='text' type='text' disabled/></td>
			</tr>
			<tr>
				<td>Flash</td><td><input id='flash_text' name='text' type='text' disabled/></td>
			</tr>
			<tr>
				<td>Shutter Speed</td><td><input id='shutter_text' name='text' type='text' disabled/></td>
			</tr>
			<tr>
				<td>Aperture</td><td><input id='aperture_text' name='text' type='text' disabled/></td>
			</tr>
			<tr>
				<td>Max Aperture</td><td><input id='m_aperture_text' name='text' type='text' disabled/></td>
			</tr>
			<tr>
				<td>Focal Length</td><td><input id='focal_text' name='text' type='text' disabled/></td>
			</tr>
			<tr>
				<td>Digital Zoom</td><td><input id='zoom_text' name='text' type='text' disabled/></td>
			</tr>
			<tr>
				<td>White Balance</td><td><input id='white_text' name='text' type='text' disabled/></td>
			</tr>
			<tr>
				<td>Brightness</td><td><input id='bright_text' name='text' type='text' disabled/></td>
			</tr>
			<tr>
				<td>IMG Direction</td><td><input id='img_direction_text' name='text' type='text' disabled/></td>
			</tr>
			<tr>
				<td>User Comment</td><td><input id='comment_text' name='text' type='text'/></td>
			</tr>
		</tbody>
	</table>
	<table id='extends_exif_table'>
		<caption class='ui-widget-header'>GPS Info</caption>
		<tbody>
			<tr>
				<td width='100'>Speed</td><td width='150'><input id='speed_text' name='text' type='text'/></td>
			</tr>
			<tr>
				<td>Altitude</td><td><input id='alt_text' name='text' type='text'/></td>
			</tr>
			<tr>
				<td>GPS Direction</td><td><input id='gps_direction_text' name='text' type='text'/></td>
			</tr>
			<tr>
				<td>Longitude</td><td><input id='lon_text' name='text' type='text'/></td>
			</tr>
			<tr>
				<td>Latitude</td><td><input id='lat_text' name='text' type='text'/></td>
			</tr>
		</tbody>
	</table>
	<button class="exif_save_button" onclick="saveExif();">수정</button>
	<button class="exif_cancel_button" onclick="cancelExif();">취소</button>
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


</body>
</html>