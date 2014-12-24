<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<jsp:include page="page_common.jsp"></jsp:include>

<title>GeoCMS</title>

<!-- login -->
<script type="text/javascript">

function session_check() {
	/*
	if($.cookie('status')=="login") {
		document.getElementById('login1').style.display='none';
		document.getElementById('login2').style.display='block';
	}
	else {
		document.getElementById('login1').style.display='block';
		document.getElementById('login2').style.display='none';
	}
	*/
}

$(function() {
	var $search = $('#search_bar');//Cache the element for faster DOM searching since we are using it more than once
	original_val = $search.val(); //Get the original value to test against. We use .val() to grab value="Search"
	$search.focus(function(){ //When the user tabs/clicks the search box.
		if($(this).val()===original_val){ //If the value is still the default, in this case, "Search"
			$(this).val('');//If it is, set it to blank
		}
	})
	.blur(function(){//When the user tabs/clicks out of the input
		if($(this).val()===''){//If the value is blank (such as the user clicking in it and clicking out)...
			$(this).val(original_val); //... set back to the original value
		}
	});
	
	
});

function submit(e) {
	var keycode;
	if(window.event) keycode = window.event.keyCode;
	else if(e) keycode = e.which;
	else return true;
	if(keycode == 13) {
		search();
	}
}
function search() {
	var text = $('#search_bar').val();

	if(text.length == 0) {
		jAlert("검색어를 입력해 주세요.", "정보");
	}
	else {
		var target, check, display;

		target = $("input[name='search_target']:checked").val();
		
		if($('input[name=search_check1]').attr('checked') && $('input[name=search_check2]').attr('checked')) check = "all";
		else if(!$('input[name=search_check1]').attr('checked') && !$('input[name=search_check2]').attr('checked')) { jAlert("키워드 대상을 선택해 주세요.", "정보"); }
		else {
			if($('input[name=search_check1]').attr('checked')) check = "content";
			if($('input[name=search_check2]').attr('checked')) check = "anno";
		}

		display = $('#display').val();

		//alert(text+','+target+','+check+','+display);
		if(target.length>0 && check.length>0 && display.length>0) {
			//$('#result_page').get(0).contentWindow.searchPageInit(text, target, check, display);
			searchPageInit(text, target, check, display);
		}
		else jAlert('검색 조건이 잘못 되었습니다.', '정보');
	}
}

function newWindow() {
	var search_api_str = $('#search_api_text').val();
	if(search_api_str.length>0) {
		window.open(search_api_str, 'RESTful Search API', 'width=1000, height=650');
	}
}
</script>

</head>
<body onload="session_check();" bgcolor='#FFF'>

	<!-- 상단 메뉴 -->
	<!-- <div id="menus" style="width:100%;">
			<a href='index.jsp'><img src='images/english_images/logo.jpg' style='margin-top:20px; margin-left:40px; cursor: pointer;'/></a>
			<input type="text" id="srchBox" size="50" style='position:absolute; top:40px; left:220px; height: 23px;'/>
			<img src='images/english_images/search_btn.gif'style='top:40px; left:610px; position:absolute; cursor: pointer;'>
			<a href='search_page.jsp'><img src='images/english_images/menu02.gif' style='top:42px; left:800px; position:absolute; cursor: pointer;'/></a>
			<a href='#'><img src='images/english_images/menu03.jpg' style='top:42px; left:1025px; position:absolute; cursor: pointer;' onclick='imageUploadCheck();'/></a>
			<a href='openapi_page.jsp'><img src='images/english_images/menu04.gif' style='top:42px; left:1300px; position:absolute; cursor: pointer;'/></a>
			<img src='images/english_images/right_box.gif' style='top:32px; left:1600px; position:absolute;'/>
	</div> -->	
	
	<!-- SEARCH -->
	<div id='search_div' style='position:absolute; left:10px; top:100px; width:409px; height:700px; display:block; border-top:1px solid #999; border-left:1px solid #999;'>
		
		<input id='search_bar' type='text' name='search_bar' value='Search for..' onKeyPress='submit(event);' style='display:none; position:absolute; left:130px; top:20px; width:560px; height:30px; font-family:Comic Sans MS; font-size:20px;'></input>
		
		<!-- <img src='images/button_search.jpg' onclick='javascript:search();' style='position:absolute; left:730px; top:20px; cursor: pointer;'></img> -->
		
		<table style='position:absolute; left:5px; top:20px; width:395px; border:1px solid #999;' >
			<tr bgcolor='#e5e5e5'>
				<td align='center' width=100 rowspan='4'><label style='font-size:13px;'><b>Searching<br/>Option</b></label>&nbsp;</td>
				<td align='center' width=90><label style='font-size:12px;'><b>Search</b></label></td>
				<td width=380>&nbsp;&nbsp;&nbsp;<input type='radio' name='search_target' value='photo' style="display:none;"><!-- <label style="color:#000; font-size:12px;">Photo</label> -->
					<input type='radio' name='search_target' value='video' style="display:none;"><!-- <label style="color:#000; font-size:12px;">Video</label> -->
					<input type='radio' name='search_target' value='all' checked><label style="color:#000; font-size:12px;">All</label></td>
			</tr>
			<tr bgcolor='#e5e5e5'>
				<td align='center' width=70><label style='font-size:12px;'><b>Target</b></label></td>
				<td>&nbsp;&nbsp;&nbsp;<input type="checkbox" name="search_check1" checked/><label style="color:#000; font-size:12px;">Title/Content</label>
					<input type="checkbox" name="search_check2" checked/><label style="color:#000; font-size:12px;">Annotation</label></td>
			</tr>
			<tr bgcolor='#e5e5e5'>
				<td align='center' width=70><label style='font-size:12px;'><b>Display</b></label></td>
				<td>&nbsp;&nbsp;&nbsp;<label style="color:#000; font-size:12px;">Limit result count</label>
					<input id='display' type='text' value='100' style='width:30px;'></input></td>
			</tr>
		</table>
		
		<!-- <div id='search_api' style='position:absolute; left:50px; top:180px; width:820px; height:95px; display:block; border:1px solid #999999;'>
			<label style='position:absolute; left:10px; top:15px; width:200px; height:25px; font-size:13px; color:#000;'><b>Result of RESTful OpenAPI</b></label>
			<input id='search_api_text' type='text' name='search_api_text' value='' style='position:absolute; left:10px; top:45px; width:675px; height:25px; font-family:Comic Sans MS; font-size:13px;'></input>
			<button class="ui-state-default ui-corner-all" style="position:absolute; left:700px; top:45px; width:110px; height:30px; font-size:12px;" onclick="newWindow();">New Window</button>
		</div> -->
		
		<div id='search_result' style='position:absolute; left:5px; top:100px; width:395px; height:700px; display:block; border:1px solid #999999; overflow-y:scroll;'>
			 <jsp:include page="sub/search/search.jsp"/>
		</div>
	</div>

<%-- <div id="footer" style="position:absolute; width:100%; height:70px; top:905px; z-index:2; /* background-color:#EAEAEA; */ ">
	<jsp:include page="footer.jsp"/>
</div> --%>
</body>
</html>