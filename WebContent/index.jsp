<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<jsp:include page="page_common.jsp"></jsp:include>

<title>GeoCMS</title>

<!-- login -->
<script type="text/javascript">
var typeShape ="forMarker";
var LocationData = []; //마커용


session_check();

$(function() {
	
    $( "#dialog" ).dialog({
      autoOpen: false,
      width:845,
      height:660,
      minHeight:660,
      top:100,
      modal:true,
      hide: {
        effect: "explode",
        duration: 1000
      }
      
    });
 
    $( "#opener" ).click(function() {
      $( "#dialog" ).dialog( "open" );
    });
    
    
    
    
    
});

function session_check() {
	$.cookie('id', 'turboSoft', {expires: 1});
	$.cookie('status', 'login', {expires: 1});
	
// 	if($.cookie('status')=="login") {
// 		document.getElementById('login1').style.display='none';
// 		document.getElementById('login2').style.display='block';
// 	}
// 	else {
// 		document.getElementById('login1').style.display='block';
// 		document.getElementById('login2').style.display='none';
// 	}
	
}

function searchAction() {
	var Skeyword = $('#srchBox').val();
	$('#search_bar').val(Skeyword);
	search();
	
	$('#image_list').css('display', 'none');
	$('#latest_title').css('display', 'none');
	$('#image_latest_list').css('display', 'none');
	$('#srch_page').css('display', 'block');
	
	
	
	
}

function submit1(e) {
	var keycode;
	if(window.event) keycode = window.event.keyCode;
	else if(e) keycode = e.which;
	else return true;
	if(keycode == 13) {
		searchAction();
	}
}
</script>

</head>
<body onload="session_check();" bgcolor='#FFF'>

	<!-- 상단 메뉴 -->
	<div id="menus" style="width:100%;">
			<a href='index.jsp'><img src='images/english_images/logo.jpg' style='margin-top:20px; margin-left:40px; cursor: pointer;'/></a>
			<!-- 검색 -->
			<input type="text" id="srchBox" size="50" style='position:absolute; top:40px; left:220px; height: 23px;' onKeyPress='submit1(event);'/>
			<img src='images/english_images/search_btn.gif'style='top:40px; left:610px; position:absolute; cursor: pointer;' alt="검색버튼" onclick="searchAction();">
			<!-- HOME -->
			<a href='index.jsp'><img src='images/english_images/menu01.gif' style='top:42px; left:800px; position:absolute; cursor: pointer;'/></a>
			<!-- Make Contents -->
			<a href='#'><img src='images/english_images/menu03.jpg' style='top:42px; left:1025px; position:absolute; cursor: pointer;' onclick='imageUploadCheck();'/></a>
			<!-- Open API -->
			<img src='images/english_images/menu04.gif' style='top:42px; left:1300px; position:absolute; cursor: pointer;' id="opener"/>
			<!-- 우측 상단 글상자 -->
			<img src='images/english_images/right_box.gif' style='top:32px; left:1600px; position:absolute;'/>
	</div>	
	<!-- 상단 메뉴들 -->
	<!-- <table width='100%' border='0' cellpadding='0' cellspacing='0'>
		<tr style="background-color: gray">
			<td><img src='images/icon_blank.jpg'/></td>
			<td><a href='index.jsp'><img src='images/icon_home2.jpg' style='border-style:none;'/></a></td>
			<td><a href='search_page.jsp'><img src='images/icon_search1.jpg' style='border-style:none;'/></a></td>
			<td><a href='openapi_page.jsp'><img src='images/icon_openapi1.jpg' style='border-style:none;'/></a></td>
		</tr>
	</table> -->
	<div id="image_map" style="width: 78%; height:800px; position:absolute; left:420px; top :100px; background-color: #EAEAEA; z-index: 0" >
		<jsp:include page="sub/maps/mainMap.jsp"/>
	</div>
	<div id="image_list" style="position:absolute; top:100px; display:block; z-index: 1">
		<jsp:include page="sub/main/image_content_list.jsp"/>
	</div>
	<img src='images/english_images/title_01.gif' style="position:absolute; left:20px; top: 465px;" id="latest_title"/>
	<div id="image_latest_list" style="position:absolute; top:480px; left:12px; display:block; z-index: 0">
		<jsp:include page="sub/main/image_latest_list.jsp"/>
	</div>
	<div id="image_upload_check" style="position:absolute; left:250px; top:430px; z-index:1 ">
		<jsp:include page="image_upload_check.jsp"/>
	</div>
	<div id="footer" style="position:absolute; width:100%; height:70px; top:905px; z-index:2; /* background-color:#EAEAEA; */ ">
		<jsp:include page="footer.jsp"/>
	</div>
	
	<div id="srch_page" style="display: none;">
		<jsp:include page="search_page.jsp"/>
	</div>
	
	<div id="dialog" title="Open API">
  		<img src='images/APIcontent2.jpg'>
	</div>
	<%-- <div id="video_upload_check" style="position:absolute; left:950px; top:150px;">
		<jsp:include page="video_upload_check.jsp"/>
	</div> --%>
	<%-- <div id="video_list" style="position:absolute; left:600px; top:300px; display:block;">
		<jsp:include page="sub/main/video_content_list.jsp"/>
	</div> --%>
	
</body>

</html>