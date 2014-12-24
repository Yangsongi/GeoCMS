<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<jsp:include page="page_common.jsp"></jsp:include>

<title>GeoCMS</title>


<script type="text/javascript">

</script>

</head>
<body>

<!-- 상단 메뉴 -->
	<div id="menus" style="width:100%;">
			<a href='index.jsp'><img src='images/english_images/logo.jpg' style='margin-top:20px; margin-left:40px; cursor: pointer;'/></a>
			<input type="text" id="srchBox" size="50" style='position:absolute; top:40px; left:220px; height: 23px;'/>
			<img src='images/english_images/search_btn.gif'style='top:40px; left:610px; position:absolute; cursor: pointer;' alt="검색버튼" onclick="searchAction();">
			<a href='search_page.jsp'><img src='images/english_images/menu02.gif' style='top:42px; left:800px; position:absolute; cursor: pointer;'/></a>
			<a href='#'><img src='images/english_images/menu03.jpg' style='top:42px; left:1025px; position:absolute; cursor: pointer;' onclick='imageUploadCheck();'/></a>
			<a href='openapi_page.jsp'><img src='images/english_images/menu04.gif' style='top:42px; left:1300px; position:absolute; cursor: pointer;'/></a>
			<img src='images/english_images/right_box.gif' style='top:32px; left:1600px; position:absolute;'/>
	</div>	

<div style='position:absolute; left:20px; top:130px; width:143px;'>
	<div class='accordionButton'><img src='images/menu1.jpg'/></div>
	<div class='accordionContent'>
		<img src='images/menu1_1.jpg' onclick="javascript:clickMenu(this.src);" style='cursor: pointer;'/>
	</div>
	<div class='accordionButton'><img src='images/menu2.jpg'/></div>
	<div class='accordionContent'>
		<img src='images/menu2_1.jpg' onclick="javascript:clickMenu(this.src);" style='cursor: pointer;'/>
	</div>
	<!-- <div class='accordionButton'><img src='images/menu3.jpg'/></div>
	<div class='accordionContent'>
		<img src='images/menu2_1.jpg'/>
	</div>
	<div class='accordionButton'><img src='images/menu4.jpg'/></div>
	<div class='accordionContent'>
		<img src='images/menu2_1.jpg'/>
	</div> -->
</div>

<div style='position:absolute; left:200px; top:130px; width:860px; height:615px; border:1px; solid #999999'>
	<img id='openapi_main_img' src=''/>
</div>


<div id="footer" style="position:absolute; width:100%; height:70px; top:905px; z-index:2; /* background-color:#EAEAEA; */ ">
		<jsp:include page="footer.jsp"/>
	</div>
</body>
</html>