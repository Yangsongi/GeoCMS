<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<script type="text/javascript">
function setVideoDesign() {
	$(function() {
		//$('table tbody tr td').addClass('ui-widget-content');
		//$('.ui-widget-content').css('fontSize', 12);
		$('#video_content_list_table tbody tr td').css('fontSize', 12);
	});
}

//1 페이지 선택 상태로 업데이트
clickVideoPage('1');

//게시물 페이지 설정
function videoPageSetup() {
	$.ajax({
		type: 'POST',
		url: 'GetVideoListServlet',
		data: 'type=init',
		success: function(data) {
			var response = data.trim();
			//총 페이지 계산
			//var totalPage = parseInt(response / 12) + 1;
			var min = 1;
			var max = 12;
			var totalPage = 1;
			var check = 'false';
			while(check=='false') {
				if(min <= response && response <= max) {
					check = 'true';
				}
				else {
					min += 12;
					max += 12;
					totalPage += 1;
				}
			}
			//테이블에 페이지 추가
			addVideoPageCell(totalPage);
		}
	});
}

//테이블에 페이지 추가
function addVideoPageCell(totalPage) {
	var target = document.getElementById("video_content_list_table");
	
	var row = target.insertRow(-1);
	
	var cell = row.insertCell(-1);
	cell.colSpan = '4';
	
	var innerHTMLStr = "<div>";
	for(var i=0; i<totalPage; i++) {
		innerHTMLStr += "<div style='float:left;'><font size='3px' color='#000'>[<a href="+'"'+"javascript:clickVideoPage('"+(i+1).toString()+"');"+'"'+" style='text-decoration:none;'><font color='#000'>"+(i+1).toString()+"</font></a>]</font></div>";
	}
	innerHTMLStr += "</div>";
	cell.innerHTML = innerHTMLStr;
}

//페이지 선택
function clickVideoPage(page) {
	$.ajax({
		type: 'POST',
		url: 'GetVideoListServlet',
		data: 'type=noinit&pageNum='+page+'&contentNum=12',
		success: function(data) {
			var response = data.trim();
			//이미지 리스트 설정
			videoListSetup(response);
			//페이지 설정
			videoPageSetup();
			//디자인 적용
			setVideoDesign();
		}
	});
}
//이미지 리스트 설정
function videoListSetup(pure_data) {
	//전달할 각 속성을 배열에 저장
	var id_arr = new Array();
	var title_arr = new Array();
	var content_arr = new Array();
	var file_url_arr = new Array();
	var thumbnail_url_arr = new Array();
	var origin_url_arr = new Array();
	
	//문자열을 <line> , <separator> 로 분리
	var data_line_arr = new Array();
	data_line_arr = pure_data.split("\<line\>");
	for(var i=0; i<data_line_arr.length; i++) {
		var data_arr = new Array();
		data_arr = data_line_arr[i].split("\<separator\>");
		id_arr.push(data_arr[0]); //id 저장
		title_arr.push(data_arr[1]); //title 저장
		content_arr.push(data_arr[2]); //content 저장
		
		var url_arr_buf1 = new Array(); //파일 경로를 URL 접근 경로로 변환
		url_arr_buf1 = data_arr[3].split("\\GeoCMS\\");
		var url1 = url_arr_buf1[1].replace("\\", "\/");
		file_url_arr.push(url1);
		
		var url_arr_buf2 = new Array(); //썸네일 경로를 URL 접근 경로로 변환
		url_arr_buf2 = data_arr[4].split("\\GeoCMS\\");
		var url2 = url_arr_buf2[1].replace("\\", "\/");
		thumbnail_url_arr.push(url2);
		
		var url_arr_buf3 = new Array(); //원본 경로를 URL 접근 경로로 변환
		url_arr_buf3 = data_arr[5].split("\\GeoCMS\\");
		var url3 = url_arr_buf3[1].replace("\\", "\/");
		origin_url_arr.push(url3);
	}
	//데이터의 최대 갯수는 12 이고 부족한 데이터는 blank 로 채운다
	//max row = 3 , max cell = 4;
	var max_row = 3;
	var max_cell = 4;
	
	if((max_row * max_cell) > id_arr.length) {
		for(var i = id_arr.length; i < (max_row*max_cell); i++) {
			id_arr.push("blank");
			title_arr.push("blank");
			content_arr.push("blank");
			file_url_arr.push("blank");
			thumbnail_url_arr.push("blank");
			origin_url_arr.push("blank");
		}
	}
	//테이블 초기화
	clearVideoTable();
	
	//테이블에 데이터 추가
	addVideoDataCell(max_row, max_cell, id_arr, title_arr, content_arr, file_url_arr, thumbnail_url_arr, origin_url_arr);
}

//테이블에 데이터 추가
function addVideoDataCell(max_row, max_cell, id_arr, title_arr, content_arr, file_url_arr, thumbnail_url_arr, origin_url_arr) {
	var target = document.getElementById("video_content_list_table");
	
	for(var i=0; i<id_arr.length; i++) {
		//이미지 추가
		var img_row;
		if(i % max_cell == 0) {
			img_row = target.insertRow(-1);
		}
		var img_cell = img_row.insertCell(-1);
		var innerHTMLStr = "";
		if(id_arr[i]=="blank" && title_arr[i]=="blank" && content_arr[i]=="blank" && file_url_arr[i]=="blank" && thumbnail_url_arr[i]=="blank" && origin_url_arr[i]=="blank") {
			innerHTMLStr += "<img class='video_round' src='images/blank(100x70).PNG' width='100' height='70' hspace='10' vspace='10' style='border:2px solid #888888'/>";
			innerHTMLStr += "<div>&nbsp&nbsp&nbsp</div>";
			img_cell.innerHTML = innerHTMLStr;
		}
		else {
			innerHTMLStr += "<a class='videoTag' href='javascript:;' onclick="+'"'+"videoViewer('"+file_url_arr[i]+"','"+origin_url_arr[i]+"');"+'"'+" title='|제목 : "+ title_arr[i] +"|내용 : "+ content_arr[i] +"' border='0'>";
			innerHTMLStr += "<img class='video_round' src='" + thumbnail_url_arr[i] + "' width='100' height='70' hspace='10' vspace='10' style='border:2px solid #888888'/>";
			innerHTMLStr += "</a>";
			innerHTMLStr += "<div>&nbsp&nbsp&nbsp작성자 : "+id_arr[i]+"</div>";
			img_cell.innerHTML = innerHTMLStr;
		}
	}
	$('a.videoTag').cluetip({splitTitle: '|', positionBy: 'mouse', dropShadow: true, showTitle: false, cluetipClass: 'default'});
	//$('.video_round').imgr({size:'3px',radius:'1px',color:'#888888'});
}

//테이블 초기화
function clearVideoTable() {
	$('#video_content_list_table tr').remove();
}

//비디오 뷰어 동작
function videoViewer(file_url, origin_url) {
	//jAlert("비디오 뷰어 동작!\n\n파일 URL : "+file_url+"\n\n원본 URL : "+origin_url, '정보');
	var conv_origin_url = encodeURIComponent(origin_url);
	$.ajax({
		type: 'POST',
		url: 'VideoEncodingCheck',
		data: 'origin_url='+conv_origin_url,
		success: function(data) {
			var response = data.trim();
			if(response=='true') {
				jAlert('인코딩 중 입니다...', '정보');
			}
			else {
				var base_url_buf = location.href.split("\/GeoCMS\/");
				var base_url = base_url_buf[0];
				var conv_file_url = encodeURIComponent(file_url);
				var $dialog = jQuery.FrameDialog.create({
					url: 'sub/viewer/video_viewer.jsp?base_url='+base_url+'&file_url='+conv_file_url,
					title: 'Video Viewer',
					width: 900,
					height: 480,
					buttons: {},
					autoOpen:false,
					open: function(event, ui){$('body').css('overflow','hidden');$('.ui-widget-overlay').css('width','100%');}
				});
				$dialog.dialog('open');
			}
		}
	});
}

//뷰어에서 호출되는 다이얼로그 닫기 기능
function closeVideoViewer() {
	//강제로 페이지 이동 시키며 뷰어 닫기
	location.href = '/GeoCMS'; 
}

</script>

<table border=1 class='ui-widget' id='video_content_list_table'>
	<caption class='ui-widget-header'>Video Contents List</caption>
	<tbody>
	</tbody>
</table>