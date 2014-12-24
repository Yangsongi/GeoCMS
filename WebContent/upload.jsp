<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<jsp:include page="page_common.jsp"></jsp:include>

<%
String type = request.getParameter("type");
%>
<script type="text/javascript">

var type = <%= type %>;
if(type==null || type=='') {
	window.parent.closeUpload();
} //업로드시에 type=1넘어옴

$(document).ready(
		
	function(){
		$('.create_button').button();
		$('.create_button').width(80);
		$('.create_button').height(22);
		$('.create_button').css('fontSize', 11);
		$('.create_button').css('margin-left', 5);
		$('.create_button').css('margin-right', 5);
		
		$('.cancle_button').button();
		$('.cancle_button').width(80);
		$('.cancle_button').height(22);
		$('.cancle_button').css('fontSize', 11);
		$('.cancle_button').css('margin-left', 5);
		$('.cancle_button').css('margin-right', 5);
		
		$('#upload_table tr td').css('fontSize', 12);
		
		if(type=='1') {
			$('#file_upload').uploadify({
				'uploader' : 'lib/uploadify/uploadify.swf',
				'script' : 'UploadServlet',
//				'onAllComplete' : function(event, data) {
					//계속 업로드 할 것인지 물음 기능 추가
// 					jConfirm('게시물을 계속 업로드 하시겠습니까?', '정보', function(type){
// 						if(!type) window.parent.closeUpload();
// 					});
					
//				},
				'onComplete' : function(event, data, fileObj) {
					
					window.parent.closeDAndOpenV(fileObj.name);
					//window.parent.showViewer(fileObj.name);
					

				},
		        
		        
				'cancelImg' : 'lib/uploadify/cancel.png',
				'folder' : '/uploads',
				'fileExt' : '*.jpg;*.gif;*.png;*.bmp;',
				'fileDesc' : 'Image Files',
				'auto' : false,
				'multi' : false,
				//'buttonImg' : '',
				'hideButton' : false
			});
		}
		//vedio
		else if(type=='2') {
			$('#file_upload').uploadify({
				'uploader' : 'lib/uploadify/uploadify.swf',
				'script' : 'UploadServlet',
				'onComplete' : function(event,queueID, fileObj, response, data) {
					//response 로 전달받은 저장 파일명으로 ajax 인코딩 수행 (인코딩이 동작되어도 웹페이지는 동작..)
					$.ajax({
						type: 'POST',
						url: 'EncodingProcess',
						data: 'filename='+response,
						success: function(data) {
							
						}
					});
					
					//계속 업로드 할 것인지 물음 기능 추가
					jConfirm('게시물을 계속 업로드 하시겠습니까?', '정보', function(type){
						if(!type) window.parent.closeUpload();
					});
				},
				'cancelImg' : 'lib/uploadify/cancel.png',
				'folder' : '/uploads',
				'fileExt' : '*.avi;*.mpg;*.mp4;*.mov;*.ogg;*.flv;*.webm;*.m4v;',
				'fileDesc' : 'Video Files',
				'auto' : false,
				'multi' : false,
				//'buttonImg' : '',
				'hideButton' : false
			});
		}
		else {}
	}
);

// var id = $.cookie('id');
// if(id=='' || id==null) {
// 	jAlert('로그인 정보를 잃었습니다.', '정보');
// 	window.parent.closeUpload();
// }

function contentSave() {
	var id = $.cookie('id');
	
	if(id!='' || id!=null) {
		//게시물 정보 전송 설정
		var title = encodeURIComponent($('#title_area').val());
		var content = encodeURIComponent(document.getElementById('content_area').value);
		if(type=='1') {
			$('#file_upload').uploadifySettings('script', 'UploadServlet?id='+id+'&title='+title+'&content='+content+'&type=1');			
		}
		else if(type=='2') {
			$('#file_upload').uploadifySettings('script', 'UploadServlet?id='+id+'&title='+title+'&content='+content+'&type=2');			
		}
		else {}
		
		//파일 업로드
		$('#file_upload').uploadifyUpload();
	}
	else {
		window.parent.closeUpload();
		jAlert('로그인 정보를 잃었습니다.', '정보');
	}
}

//게시물 생성
function createContent() {
	if($.trim($('#title_area').val())=='') {
		jAlert('제목을 입력해 주세요.', '정보');
		$('#title_area').focus();
		return;
	}
	contentSave();
}

//게시물 생성 취소
function cancelContent() {
	jConfirm('게시물 생성을 취소하시겠습니까?', '정보', function(type){
		if(type) window.parent.closeUpload();
	});
}


function imageViewer(file_url) {   // 여기서 들어오는 file_url정보 ex)  upload/20140605_120541.jpg
	
	
	var base_url_buf = location.href.split("\/GeoCMS\/"); //location.href 주소 "http://localhost:8082/GeoCMS/"
	var base_url = base_url_buf[0]; // "http://localhost:8082"
	var conv_file_url = encodeURIComponent(file_url); // conv_file_url = upload%2F20140605_120541.jpg
	
	var $dialog = jQuery.FrameDialog.create({ //객체정보를 로드
		url: 'sub/viewer/image_viewer.jsp?base_url='+base_url+'&file_url='+conv_file_url,
		title: 'Image Viewer',
		width:1127,  
		height:650, 
		buttons: {},
		autoOpen:false
	});
	
	$dialog.dialog('open');
}
</script>

</head>

<body bgcolor='#e5e5e5'>

<table id='upload_table' border=1>
	<tr>
		<td width='40' height='25' align='center'>TITLE</td>
		<td width='360' height='25' align='center'>
			<input id='title_area' type='text' style='width:360px;'>
		</td>
	</tr>
	<tr>
		<td width='400' height='25' align='center' colspan='2'>CONTENT</td>
	</tr>
	<tr>
		<td width='400' height='300' align='center' colspan='2'>
			<textarea id='content_area' style='width:400px; height:370px;'></textarea>
		</td>
	</tr>
	<tr>
		<td id='file_upload_td' width='400' height='25' colspan='2'>
			<input id='file_upload' name='file_upload' type='file'/>
		</td>
	</tr>
	<tr>
		<td width='400' height='25' align='center' colspan='2'>
			<button class='create_button' onclick='createContent();'>SAVE</button>
			<button class='cancle_button' onclick='cancelContent();'>CANCLE</button>
		</td>
	</tr>
</table>


</body>
