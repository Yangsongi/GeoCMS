<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<jsp:include page="../../page_common.jsp"></jsp:include>

<%
//response.setCharacterEncoding("utf-8");

String file_url = request.getParameter("file_url");
String base_url = request.getParameter("base_url");

%>

<script type="text/javascript">
var file_url = '<%= file_url %>';
var base_url = '<%= base_url %>';
var full_url = base_url + '/GeoCMS/' + file_url;

$(function() {
	$('.video_write_button').button();
	$('.video_write_button').width(80);
	$('.video_write_button').height(25);
	$('.video_write_button').css('fontSize', 12);
	
	$('.video_setting_button').button();
	$('.video_setting_button').width(80);
	$('.video_setting_button').height(25);
	$('.video_setting_button').css('fontSize', 12);
});

function videoViewerInit() {
	//비디오 설정
	changeVideo();
	//GPX or KML 데이터 설정
	loadGPS(full_url);
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

/* map_start ----------------------------------- 맵 버튼 설정 ------------------------------------- */
function reloadMap(type) {
	//var arr = readMapData();
	//$('#googlemap').get(0).contentWindow.setCenter(arr[0], arr[1], 1);
	//if(type==2) { $('#googlemap').get(0).contentWindow.setAngle(arr[2], arr[3]); }
}

readMapData = function() {
	var direction_str = $('#gps_direction_text').val();
	var lon_text = $('#lon_text').val();
	var lat_text = $('#lat_text').val();
	var focal_str = $('#focal_text').val();
	
	var buf_arr = new Array();
	buf_arr.push(lat_text);
	buf_arr.push(lon_text);
	buf_arr.push(direction_str);
	buf_arr.push(focal_str);
	return buf_arr;
};

//맵 크기 조절
var resize_map_state = 1;
var resize_scale = 150;
var init_map_left, init_map_top, init_map_width, init_map_height;
function resizeMap() {
	if(resize_map_state==1) {
		init_map_left = 520;
		init_map_top = 175;
		init_map_width = $('#video_map_area').width();
		init_map_height = $('#video_map_area').height();
		resize_map_state=2;
		$('#video_map_area').animate({left:init_map_left-resize_scale, top:init_map_top-resize_scale, width:init_map_width+resize_scale, height:init_map_height+resize_scale},"slow", function() {  $('#resize_map_btn').css('background-image','url(../../images/icon_map_min.jpg)'); reloadMap(1); });
	}
	else if(resize_map_state==2) {
		resize_map_state=1;
		$('#video_map_area').animate({left:init_map_left, top:init_map_top, width:init_map_width, height:init_map_height},"slow", function() {  $('#resize_map_btn').css('background-image','url(../../images/icon_map_max.jpg)'); reloadMap(1); });
	}
	else {}
}

//저작
function videoWrite() {
	jConfirm('뷰어를 닫고 저작을 수행하시겠습니까?', '정보', function(type){
		if(type) {
			openVideoWrite();
			//뷰어 닫기 수행
			window.parent.closeVideoViewer();
		}
	});
}
//새창 띄우기 (저작)
function openVideoWrite() {
	var conv_full_url = encodeURIComponent(full_url);
	
	window.open('', 'video_write_page', 'width=930, height=800');
	var form = document.createElement('form');
	form.setAttribute('method','post');
	form.setAttribute('action','../../video_write_page.jsp');
	form.setAttribute('target','video_write_page');
	document.body.appendChild(form);
	
	var insert = document.createElement('input');
	insert.setAttribute('type','hidden');
	insert.setAttribute('name','file_url');
	insert.setAttribute('value',conv_full_url);
	form.appendChild(insert);
	
	form.submit();
}

</script>

</head>

<body onload='videoViewerInit();' bgcolor='#FFF'>

<!---------------------------------------------------- 메인 영역 시작 ------------------------------------------------>

<!-- 비디오 영역 -->
<div id='video_main_area' style='position:absolute; left:10px; top:15px; width:500px; height:360px; display:block; border:1px solid #999999;'>
		<video id='video_player' width='480' height='340' controls='true' style='position:absolute; left:10px; top:10px;'>
			<source id='video_src' src='' type='video/ogg'></source>
			HTML5 지원 브라우저(Firefox 3.6 이상 또는 Chrome)에서 지원됩니다.
		</video>
</div>

<!-- 추가 객체 영역 -->
<div id='video_object_area' style='position:absolute; left:520px; top:15px; width:200px; height:150px; display:block; border:1px solid #999999; overflow-y:scroll;'>
	<table id='object_table'>
		<tr bgcolor='#16193c' style='font-size:12px;'>
			<td width=40 align='center' style='color:#FFF;'>ID</td>
			<td width=60 align='center' style='color:#FFF;'>Type</td>
			<td width=100 align='center' style='color:#FFF;'>Data</td>
		</tr>
	</table>
</div>

<!-- 지도 영역 -->
<div id='video_map_area' style='position:absolute; left:520px; top:175px; width:200px; height:200px; display:block; background-color:#999;'>
	<iframe id='googlemap' src='../maps/video_googlemap.jsp' style='width:100%; height:100%; margin:1px; border:none;'></iframe>
	<div id='resize_map_btn' onclick='resizeMap();' style='position:absolute; left:0px; top:0px; width:30px; height:30px; cursor:pointer; background-image:url(../../images/icon_map_max.jpg)'>
	</div>
</div>

<!----------------------------------------------------- 메인 영역 끝 ------------------------------------------------->

<!-- 저작 버튼 -->
<div style='position:absolute; left:60px; top:390px; display:block;'>
	<button class='video_write_button' onclick='videoWrite();'>Write</button>
</div>

<!-- 게시물 설정 버튼 -->
<div style='position:absolute; left:150px; top:390px; display:block;'>
	<button class='video_setting_button' onclick='videoSetting();'>Settings</button>
</div>



</body>

</html>
