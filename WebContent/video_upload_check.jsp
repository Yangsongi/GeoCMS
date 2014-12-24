<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script type='text/javascript'>

$(function() {
	$('.video_upload_button').button();
	$('.video_upload_button').width(130);
	$('.video_upload_button').height(30);
	$('.video_upload_button').css('fontSize', 12);
});

function videoUploadCheck() {
	if($.cookie('status')!="login") {
		jAlert("로그인이 필요한 서비스 입니다.", '정보');
	}
	else {
		if($.cookie('id')=='') {
			jAlert("로그인 정보가 만료되었습니다.\n\n다시 로그인을 수행하여 주세요.", '정보');
		}
		else {
			var $dialog = jQuery.FrameDialog.create({
				url: 'upload.jsp?type=2',
				title: '비디오 업로드',
				width: 450,
				height: 600,
				buttons: {},
				autoOpen:false
			});
			$dialog.dialog('open');
		}
	}
}

</script>

<button class='video_upload_button' onclick='videoUploadCheck();'>비디오 업로드</button>