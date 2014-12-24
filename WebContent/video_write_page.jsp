<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>GeoCMS</title>

<%
String file_url = request.getParameter("file_url");
%>
<script type="text/javascript">

function init() {
	var file_url = '<%=file_url%>';
	var video_write_frame = document.getElementById('video_write_frame');
	video_write_frame.contentWindow.location.href = 'sub/write/video_write.jsp?file_url='+file_url;
}
</script>

</head>
<body onload='init();'>
	<div id="video_write_div" style="position:absolute; width:100%; height:100%; left:0px; top:0px; display:block;">
		<iframe id='video_write_frame' frameborder='0' style='width:100%; height:100%; margin:0px; padding:0px;'></iframe>;
	</div>
</body>
</html>