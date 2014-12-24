<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<script type="text/javascript">

function setImageDesign() {
	$(function() {
		//$('table tbody tr td').addClass('ui-widget-content');
		//$('.ui-widget-content').css('fontSize', 12);
		$('#image_content_list_table tbody tr td').css('fontSize', 13);
		$( "#tabs" ).tabs({
			  selected: 0
		});
	});
}
//1 페이지 선택 상태로 업데이트
clickImagePage('1');

//게시물 페이지 설정
function imagePageSetup() {
	$.ajax({
		type: 'POST',
		url: 'GetImageListServlet',
		data: 'type=init',
		success: function(data) {
			var response = data.trim(); //공백제거
			//총 페이지 계산
			//var totalPage = parseInt(response / 12) + 1;
			var min = 1;
			var max = 6;
			var totalPage = 1;
			var check = 'false';
			while(check=='false') {
				if(min <= response && response <= max) {
					check = 'true';
				}
				else {
					min += 6;
					max += 6;
					totalPage += 1;
				}
			}
			//테이블에 페이지 추가
			addImagePageCell(totalPage);
		}
	});
}

//테이블에 페이지 추가
function addImagePageCell(totalPage) {
	var target = document.getElementById("image_content_list_table");
	
	var row = target.insertRow(-1);
	
	var cell = row.insertCell(-1);
	cell.colSpan = '3';
	
	var innerHTMLStr = "<div>";
	for(var i=0; i<totalPage; i++) {
		innerHTMLStr += "<div style='float:left;'><font size='3px' color='#000'>[<a href="+'"'+"javascript:clickImagePage('"+(i+1).toString()+"');"+'"'+" style='text-decoration:none;'><font color='#000'>"+(i+1).toString()+"</font></a>]</font></div>";
	}
	innerHTMLStr += "</div>";
	cell.innerHTML = innerHTMLStr;
}

//페이지 선택
function clickImagePage(page) {
	$.ajax({
		type: 'POST',
		url: 'GetImageListServlet',
		data: 'type=noinit&pageNum='+page+'&contentNum=6',
		success: function(data) {
			var response = data.trim();
			//이미지 리스트 설정
			imageListSetup(response);
			//페이지 설정
			imagePageSetup();
			//디자인 적용
			setImageDesign();
		}
	});
}
//이미지 리스트 설정
function imageListSetup(pure_data) {
	//전달할 각 속성을 배열에 저장
	var id_arr = new Array();
	var title_arr = new Array();
	var content_arr = new Array();
	var file_url_arr = new Array();
	var udate_arr = new Array();
	
	//문자열을 <line> , <separator> 로 분리
	var data_line_arr = new Array();
	data_line_arr = pure_data.split("\<line\>");
	for(var i=0; i<data_line_arr.length; i++) {
		var data_arr = new Array();
		data_arr = data_line_arr[i].split("\<separator\>");
		id_arr.push(data_arr[0]); //id 저장
		title_arr.push(data_arr[1]); //title 저장
		content_arr.push(data_arr[2]); //content 저장
		udate_arr.push(data_arr[4]);
		var url_arr = new Array(); //파일 경로를 URL 접근 경로로 변환
		url_arr = data_arr[3].split("\\GeoCMS\\");
		var url = url_arr[1].replace("\\", "\/");
		file_url_arr.push(url); // 뽑아낸 데이터는 upload/파일명.jpg의 형태
	}
	//데이터의 최대 갯수는 12 이고 부족한 데이터는 blank 로 채운다
	//max row = 3 , max cell = 4;
	var max_row = 2;
	var max_cell = 3;
	
	if((max_row * max_cell) > id_arr.length) {
		for(var i = id_arr.length; i < (max_row*max_cell); i++) {
			id_arr.push("blank");
			title_arr.push("blank");
			content_arr.push("blank");
			file_url_arr.push("blank");
			udate_arr.push("blank");
		}
	}
	//테이블 초기화
	clearImageTable();
	
	//테이블에 데이터 추가
	addImageDataCell(max_row, max_cell, id_arr, title_arr, content_arr, file_url_arr, udate_arr);
}

//테이블에 데이터 추가
function addImageDataCell(max_row, max_cell, id_arr, title_arr, content_arr, file_url_arr, udate_arr) {
	var target = document.getElementById("image_content_list_table");

	var thumbnail_arr = new Array();
	for(var i=0; i<file_url_arr.length; i++) {
		thumbnail_arr.push(loadXML(file_url_arr[i]));
	}

	var thumbnail_left = 30;
	var thumbnail_top = 65;
	for(var i=0; i<id_arr.length; i++) {
		//이미지 추가
		var img_row;
		if(i % max_cell == 0) {
			img_row = target.insertRow(-1);
			if(i!=0) { thumbnail_top += 125; thumbnail_left = 30; }
		}
		else {
			thumbnail_left += 130;
		}
		var img_cell = img_row.insertCell(-1);
		var innerHTMLStr = "";
		if(id_arr[i]=="blank" && title_arr[i]=="blank" && content_arr[i]=="blank" && file_url_arr[i]=="blank") {
			innerHTMLStr += "<img class='round' src='images/blank(100x70).PNG' width='100' height='70'hspace='10' vspace='10' style='border:2px solid #888888'/>";
			innerHTMLStr += "<div>&nbsp&nbsp&nbsp</div>";
			img_cell.innerHTML = innerHTMLStr;
		}
		else {
			innerHTMLStr += "<a class='imageTag' href='javascript:;' onclick="+'"'+"imageViewer('"+file_url_arr[i]+"');"+'"'+" title='|제목 : "+ title_arr[i] +"|내용 : "+ content_arr[i] +"' border='0'>";
			innerHTMLStr += "<img class='round' src='" + file_url_arr[i] + "' width='100' height='70' hspace='10' vspace='10' style='border:2px solid #888888'/>";
			innerHTMLStr += "</a>";
			innerHTMLStr += "<div>&nbsp;Writer : "+id_arr[i]+"</div>";
			innerHTMLStr += "<div>&nbsp;Date : "+udate_arr[i]+"</div>";
			if(thumbnail_arr[i]==0) innerHTMLStr += "<div style='position:absolute; left:"+thumbnail_left+"px; top:"+thumbnail_top+"px; width:30px; height:30px; background-image:url(images/thumbnail.png);'></div>";
			img_cell.innerHTML = innerHTMLStr;
		}
	}
	
	$('.imageTag').cluetip({splitTitle: '|', positionBy: 'mouse', dropShadow: true, showTitle: false, cluetipClass: 'default'});
	//$('.round').imgr({size:'1px',radius:'10px',color:'#888888'});
}

//XML 유무에 따라 썸네일 아이콘 추가
function loadXML(file_url) {
	var url_buf = file_url.split(".");
	var xml_file_name = url_buf[0] + '.xml';
	var file_check;
	$.ajax({
		type: "GET",
		url: xml_file_name,
		dataType: "xml",
		cache: false,
		async: false,
		success: function(xml) {
			file_check = 0; //저작 됨
		},
		error: function(xhr, status, error) {
			file_check = 1; //저작 안됨
		}
	});
	
	return file_check;
}


//테이블 초기화
function clearImageTable() {
	$('#image_content_list_table tr').remove();
}

//이미지 뷰어 동작 (이미지 클릭)
function imageViewer(file_url) {   // 여기서 들어오는 file_url정보 ex)  upload/20140605_120541.jpg
	//jAlert("이미지 뷰어 동작!\n\n파일 URL : "+file_url, '정보');
	/*
	var $this = $(this);
	var padding = 10;
	
	$('<iframe id="image_viewer_iframe" class="image_viewer_iframe" src="sub/viewer/image_viewer.jsp?base_url='+base_url+'&file_url='+conv_file_url+'" />').dialog({
		title: 'Image Viewer',
		autoOpen: true,
		width: 1050,
		height: 700,
		modal: true,
		resizable: true
	}).width(1050-padding).height(700-padding);
	*/
	var base_url_buf = location.href.split("\/GeoCMS\/"); //location.href 주소 "http://localhost:8082/GeoCMS/"
	var base_url = base_url_buf[0]; // "http://localhost:8082"
	var conv_file_url = encodeURIComponent(file_url); // conv_file_url = upload%2F20140605_120541.jpg
	
	var $dialog = jQuery.FrameDialog.create({ //객체정보를 로드
		url: 'sub/viewer/image_viewer.jsp?base_url='+base_url+'&file_url='+conv_file_url,
		title: 'Image Viewer',
		width:1127,  
		//width: 1150,
		height:650, 
		//height: 620,
		buttons: {},
		autoOpen:false
	});
	$dialog.dialog('open');
}

//뷰어에서 호출되는 다이얼로그 닫기 기능
function closeImageViewer() {
	//강제로 페이지 이동 시키며 뷰어 닫기
	location.href = '/GeoCMS'; 
}

</script>
<style>
.ui-tabs .ui-tabs-nav li.ui-tabs-selected a, .ui-tabs .ui-tabs-nav li.ui-state-disabled a, .ui-tabs .ui-tabs-nav li.ui-state-processing a 
{
	background-color:rgb(15, 118, 207);
	color:#fff;
}
</style>
<div id="tabs">
	  <ul>
	    <li><a href="#tabs-1">Civil Complaint</a></li>
	    <li><a href="#tabs-2">Traffic </a></li>
	    <li><a href="#tabs-3">Environment</a></li>
	    <li><a href="#tabs-4">Construction</a></li>
	  </ul>
	  <div id="tabs-1" >
	  	<table border=1 class='ui-widget' id='image_content_list_table'>
			<!-- <caption class='ui-widget-header'>이미지 리스트</caption> -->
			<tbody>
			</tbody>
		</table>
	  </div>  
	  <div id="tabs-2" style="width:330px;">
	  교통탭
	  </div>
	  <div id="tabs-3"  style="width:330px;">
	  환경탭
	  </div>
	  <div id="tabs-4"  style="width:330px;">
	  건축탭
	  </div>
 </div>
