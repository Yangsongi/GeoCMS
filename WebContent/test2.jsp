<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<jsp:include page="page_common.jsp"></jsp:include>

<script type="text/javascript">
$(document).ready(function() {
	$('.imageTag').cluetip({splitTitle: '|', positionBy: 'mouse', dropShadow: true, showTitle: false, cluetipClass: 'default'});
	$('.round').imgr({size:'3px',radius:'10px'});
});

</script>

</head>
<body>

<a class='imageTag' href='sample.jsp' title='|제목 : 안녕하세요|내용 : 샘플입니다.'>
	<img class='round' src="http://129.254.84.71:7002/GeoCMS/upload/013(3).JPG" width='200' height='200'>
</a>

</body>
</html>