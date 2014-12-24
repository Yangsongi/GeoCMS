<%@ page language="java" contentType="text/html; charset=UTF-8" import="java.net.*" pageEncoding="UTF-8"%>

<script type='text/javascript'>
var abc= null;

$(function() {
	$('.image_upload_button').button();
	$('.image_upload_button').width(130);
	$('.image_upload_button').height(30);
	$('.image_upload_button').css('fontSize', 12);
});

function imageUploadCheck() {
	if($.cookie('status')!="login") {
		jAlert("로그인이 필요한 서비스 입니다.", '정보');
	}
	else {
		if($.cookie('id')=='') {
			jAlert("로그인 정보가 만료되었습니다.\n\n다시 로그인을 수행하여 주세요.", '정보');
		}
		else {
			 	abc = jQuery.FrameDialog.create({
				url: 'upload.jsp?type=1',
				title: 'Image Upload',
				width: 440,
				height: 600,
				buttons: {},
				autoOpen:false
			});
			abc.dialog('open');
		}
	}
}

function closeUpload() {
	$('.ui-dialog :button').blur();
	location.href = '/GeoCMS'; 
}

function closeDAndOpenV(fileName) {
	abc.dialog('close');
	alert("Going to the Viewer Page...");
	showViewer(fileName);
}

function showViewer(fileName) {
	
	var file_url = "upload/"+fileName;
	
	var base_url_buf = location.href.split("\/GeoCMS\/"); //location.href 주소 "http://localhost:8082/GeoCMS/"
	var base_url = base_url_buf[0]; // "http://localhost:8082"
	var conv_file_url = encodeURIComponent(file_url); // conv_file_url = upload%2F20140605_120541.jpg
	
	var $dialog1 = jQuery.FrameDialog.create({ //객체정보를 로드
		url: 'sub/viewer/image_viewer.jsp?base_url='+base_url+'&file_url='+conv_file_url,
		title: 'Image Viewer',
		width:1127,  
		height:650, 
		buttons: {},
		autoOpen:false
	});
	
	$dialog1.dialog('open');
}
</script>
<!-- <button class='image_upload_button' onclick='imageUploadCheck();'>Image Upload</button> index.jsp로 옮김--> 