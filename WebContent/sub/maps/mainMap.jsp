<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <meta charset="utf-8">
    <style>
       html, body, #map-canvas {
        height: 100%;
        margin: 0px;
        padding: 0px
      }
      .controls {
        margin-top: 16px;
        border: 1px solid transparent;
        border-radius: 2px 0 0 2px;
        box-sizing: border-box;
        -moz-box-sizing: border-box;
        height: 32px;
        outline: none;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
      }

      #pac-input {
        background-color: #fff;
        padding: 0 11px 0 13px;
        width: 400px;
        font-family: Roboto;
        font-size: 15px;
        font-weight: 300;
        text-overflow: ellipsis;
      }

      #pac-input:focus {
        border-color: #4d90fe;
        margin-left: -1px;
        padding-left: 14px;  /* Regular padding-left + 1. */
        width: 401px;
      }

      .pac-container {
        font-family: Roboto;
      }

      #type-selector {
        color: #fff;
        background-color: #4d90fe;
        padding: 5px 11px 0px 11px;
      }

      #type-selector label {
        font-family: Roboto;
        font-size: 13px;
        font-weight: 300;
      }
}

    </style>
<script type = "text/javascript" src = "http://maps.googleapis.com/maps/api/js?sensor=true"></script>
<script type = "text/javascript">
$( document ).ready(function() {
	initialize();
});//document.ready 끝


function initialize()
{
	if(typeShape == "forMarker") {
		
		takeMarkerData(typeShape);
	}
	else if(typeShape == "forSearch") {
		google.maps.event.addDomListener(window, 'load', gridMap(LocationData));	
	}
	
}

function gridMap(LocationData) {
	var map = 
        new google.maps.Map(document.getElementById('map-canvas'));
    var bounds = new google.maps.LatLngBounds();
    var infowindow = new google.maps.InfoWindow();
     
    for (var i in LocationData)
    {
        var p = LocationData[i];
        var latlng = new google.maps.LatLng(p[0], p[1]);
        bounds.extend(latlng);
         
        var marker = new google.maps.Marker({
            position: latlng,
            map: map,
            title: p[2]
        });
     
        google.maps.event.addListener(marker, 'click', function() {
			var file_url = "upload/"+ this.title;
			imageViewer(file_url);
			
        });
    }
    
    map.fitBounds(bounds);
	
}


function takeMarkerData(typeShape) {
	
	$.ajax({
		type: 'POST',
		url: 'GetImageListServlet',
		data: 'type='+typeShape,
		success: function(data) 
		{
			
			var id_arr = new Array();
			var title_arr = new Array();
			var content_arr = new Array();
			var file_url_arr = new Array();
			var udate_arr = new Array();
			var idx_arr = new Array();
			var lati_arr = new Array();
			var longi_arr = new Array();
			
			//문자열을 <line> , <separator> 로 분리
			var data_line_arr = new Array();
			
			data_line_arr = data.split("\<line\>");
			
			for(var i=0; i<data_line_arr.length; i++) 
			{
				var data_arr = new Array();
				
				data_arr = data_line_arr[i].split("\<separator\>");
				
				id_arr.push(data_arr[0]); //id 저장
				
				title_arr.push(data_arr[1]); //title 저장
				
				content_arr.push(data_arr[2]); //content 저장
				
				udate_arr.push(data_arr[6]); //찍은날짜
				
				lati_arr.push(data_arr[5]); // 위도
				
				longi_arr.push(data_arr[7]); //경도
				
				var url_arr = new Array(); //파일 경로를 URL 접근 경로로 변환
				url_arr = data_arr[3].split("\\upload\\");
				var url = url_arr[1].replace("\\", "\/");
				file_url_arr.push(url); // 파일명.jpg의 형태만..
			}
			
			
			var loca = [];
			
			
			for(var i=0; i < file_url_arr.length; i++)
			{	
				var temp = new Array();
				
				temp[0] = lati_arr[i];
				temp[1] = longi_arr[i];
				temp[2] = file_url_arr[i];
				
				loca.push(temp);
				
			}
			
			LocationData = loca;
			
			
			google.maps.event.addDomListener(window, 'load', gridMap(LocationData));
		}
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
		//width: 1150,
		height:650, 
		//height: 620,
		buttons: {},
		autoOpen:false
	});
	$dialog.dialog('open');
}
</script>

<title>Main2</title>
<body>
    <div id="map-canvas"></div>
</body>
</html>