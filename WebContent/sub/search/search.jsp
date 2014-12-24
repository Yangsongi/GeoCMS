<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<script type="text/javascript">
//검색 실행
function searchPageInit(text, target, check, display) {
	var encode_text = encodeURIComponent(text);

	$.ajax({
		type: 'POST',
		url: 'GetSearchList',
		data: 'text='+encode_text+'&target='+target+'&check='+check,
		success: function(data) {
			var response = data.trim();
			//이미지 리스트 설정
			searchListSetup(response);
		}
	});

	var buf = location.href.split("search_page.jsp");
	var url = buf[0];
	url += 'GetSearchList?text='+encode_text+'&target='+target+'&check='+check;
	$('#search_api_text').val(url);
}

//이미지 리스트 설정
function searchListSetup(pure_data) {
	//전달할 각 속성을 배열에 저장
	var type_arr = new Array();
	var search_arr = new Array();
	var id_arr = new Array();
	var title_arr = new Array();
	var content_arr = new Array();
	var file_url_arr = new Array();
	var thumbnail_url_arr = new Array();
	var origin_url_arr = new Array();
	var lati_arr = new Array(); //marker를 위한 latitude
	var longi_arr = new Array(); //marker를 위한 longitude
	
	//문자열을 <line> , <separator> 로 분리
	var data_line_arr = new Array();
	data_line_arr = pure_data.split("\<line\>");
	for(var i=0; i<data_line_arr.length-1; i++) {
		var data_arr = new Array();
		data_arr = data_line_arr[i].split("\<separator\>");
		type_arr.push(data_arr[0]); //type 저장
		search_arr.push(data_arr[1]);
		id_arr.push(data_arr[2]); //id 저장
		title_arr.push(data_arr[3]); //title 저장
		content_arr.push(data_arr[4]); //content 저장
		lati_arr.push(data_arr[7]);
		longi_arr.push(data_arr[9]);
		
		var url_arr_buf1 = data_arr[5].split("\\GeoCMS\\"); //파일 경로를 URL 접근 경로로 변환
		var url1 = url_arr_buf1[1].replace("\\", "\/");
		
		file_url_arr.push(url1);
		
		if(data_arr.length==6) {
			thumbnail_url_arr.push("blank");
			origin_url_arr.push("blank");
		}
		else if(data_arr.length==8) {
			var url_arr_buf2 = data_arr[6].split("\\GeoCMS\\"); //썸네일 경로를 URL 접근 경로로 변환
			var url2 = url_arr_buf2[1].replace("\\", "\/");
			thumbnail_url_arr.push(url2);
			
			var url_arr_buf3 = data_arr[7].split("\\GeoCMS\\"); //원본 경로를 URL 접근 경로로 변환
			var url3 = url_arr_buf3[1].replace("\\", "\/");
			origin_url_arr.push(url3);
		}
		else {}
		
	}
	SearchResultMarker(file_url_arr, lati_arr, longi_arr);
	
	//테이블 초기화
	clearSearchTable();
	//테이블에 데이터 추가
	for(var i=0; i<id_arr.length; i++) {
		addSearchDataCell(type_arr[i], search_arr[i], id_arr[i], title_arr[i], content_arr[i], file_url_arr[i], thumbnail_url_arr[i], origin_url_arr[i]);
	}

	$('a.searchTag').cluetip({splitTitle: '|', positionBy: 'mouse', dropShadow: true, showTitle: false, cluetipClass: 'default'});
	
	
}

//테이블에 데이터 추가
function addSearchDataCell(type, search, id, title, content, file_url, thumbnail_url, origin_url) {
	
	var target = document.getElementById("search_content_list_table");
	
	var row;
	row = target.insertRow(-1);
	row.setAttribute('bgcolor', '#e5e5e5');
	var img_cell = row.insertCell(-1);
	var innerHTMLStr = "";
	innerHTMLStr += "<a class='searchTag' href='javascript:;' onclick="+'"'+"searchViewer('"+file_url+"','"+origin_url+"','"+type+"');"+'"'+" title='|제목 : "+ title+"|내용 : "+ content+"' border='0'>";
	if(type=='image') {	innerHTMLStr += "<img src='" + file_url + "' width='140' height='110' hspace='10' vspace='10' border='3' style='border-color:#888888'/>"; }
	else if(type=='video') { innerHTMLStr += "<img src='" + thumbnail_url+ "' width='120' height='90' hspace='10' vspace='10' border='3' style='border-color:#888888'/>"; }
	else {}
	innerHTMLStr += "</a>";
	img_cell.innerHTML = innerHTMLStr;
	var txt_cell1 = row.insertCell(-1);
	innerHTMLStr = "<div style='width:220px;'>&nbsp<label style='color:#000; font-size:12px;'><b>Target : </b>"+search+"<br/><br/>&nbsp&nbsp<b>Author : </b>"+id+"<br/><br/>&nbsp&nbsp<b>Title   : </b>"+title+"<br/><br/>&nbsp&nbsp<b>Content : </b>"+content+"</label></div>";
	txt_cell1.innerHTML = innerHTMLStr;
// 	var txt_cell2 = row.insertCell(-1);
// 	innerHTMLStr = "<div style='width:510px;'>&nbsp<label style='color:#000; font-size:12px;'><b>Title   : </b>"+title+"<br/>&nbsp<b>Content : </b>"+content+"</label></div>";
// 	txt_cell2.innerHTML = innerHTMLStr;
	var hr_row = target.insertRow(-1);
	var hr_cell = hr_row.insertCell(-1);
	hr_cell.setAttribute('colspan', '2');
	//hr_cell.innerHTML = "<hr/>";
}

function SearchResultMarker(file_url_arr, lati_arr, longi_arr) {
	
	
	var file_url = [];  //   upload/dalkjfkdjfa.jpg
	
	for(var i=0; i < file_url_arr.length; i++)
	{
		var temp =	file_url_arr[i].split("/");
		
		file_url.push(temp[1]);
	}
	
	alert(file_url);
	
	var loca = [];
	
	
	for(var i=0; i < file_url.length; i++)
	{	
		var temp = new Array();
		
		temp[0] = lati_arr[i];
		temp[1] = longi_arr[i];
		temp[2] = file_url[i];
		
		loca.push(temp);
		
	}
	
	LocationData = loca;
	
	
	typeShape = "forSearch";
	initialize();
}

//테이블 초기화
function clearSearchTable() {
	$('#search_content_list_table tr').remove();
}

//뷰어 동작
function searchViewer(file_url, origin_url, type) {
	var base_url_buf = location.href.split("\/GeoCMS\/");
	var base_url = base_url_buf[0];
	var conv_file_url = encodeURIComponent(file_url);
	var conv_origin_url = encodeURIComponent(origin_url);
	if(type=='image') {
		var $dialog = jQuery.FrameDialog.create({
			url: 'sub/viewer/image_viewer.jsp?base_url='+base_url+'&file_url='+conv_file_url,
			title: 'Image Viewer',
			width: 1127,
			height: 650,
			buttons: {},
			autoOpen:false
		});
		$dialog.dialog('open');
	}
	else if(type=='video') {
		$.ajax({
			type: 'POST',
			url: 'VideoEncodingCheck',
			data: 'origin_url='+conv_origin_url,
			success: function(data) {
				var response = data.trim();
				if(response=='true') { jAlert('인코딩 중 입니다...', '정보'); }
				else {
					var $dialog = jQuery.FrameDialog.create({
						url: 'sub/viewer/video_viewer.jsp?base_url='+base_url+'&file_url='+conv_file_url,
						title: 'Video Viewer',
						width: 750,
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
	else {}
}

</script>

<table border=0 class='ui-widget' id='search_content_list_table'>
</table>