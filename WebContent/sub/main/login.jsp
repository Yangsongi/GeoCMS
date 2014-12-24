<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<jsp:include page="../../page_common.jsp"></jsp:include>

<title>GeoCMS</title>

<script type='text/javascript'>
	$(function() {
		$('.join_button').button();
		$('.join_button').width(80);
		$('.join_button').height(25);
		$('.join_button').css('fontSize', 12);

		$('.login_button').button();
		$('.login_button').width(80);
		$('.login_button').height(25);
		$('.login_button').css('fontSize', 12);
		
		//$('#login_table tbody tr td').addClass('ui-widget-content');
		$('#login_table tbody tr td').css('fontSize', 12);
		//$('.ui-widget').css('color', 'black');
	});
	
	function checkLogin() {
		if($.trim($('#id_input').val())=='') {
			jAlert('아이디를 입력해 주세요.', '정보');
			$('#id_input').focus();
			return;
		}
		if($.trim($('#pass_input').val())=='') {
			jAlert('비밀번호를 입력해 주세요.', '정보');
			$('#pass_input').focus();
			return;
		}
		$.ajax({
			type: 'POST',
			url: 'MemberCheckServlet',
			data: 'id='+$('#id_input').val()+'&pass='+$('#pass_input').val(),
			success: function(data) {
				var response = data.trim();
				alert(response);
				var msg;
				switch(response) {
				case 'nomatch':
					msg = '아이디 또는 비밀번호가 일치하지 않습니다.'; break;
				case 'fail':
					msg = '로그인에 실패 했습니다.'; break;
				default :
					msg = '존재하지 않는 사용자입니다.'; break;
				}
				if(response=='success') {
					alert(response);
					$.cookie('id', $('#id_input').val(), {expires: 1});
					$.cookie('status', 'login', {expires: 1});
					alert(window.location.href);
					window.location.href='index.jsp';
				}
				else {
					$.cookie('id', null);
					$.cookie('status', null);
					jAlert(msg, '정보');
				}
			}
		});
	}
</script>
</head>

<body>
<table id='login_table' border=1 bordercolor='#999999'>
	<caption class='ui-widget-header'>GeoCMS</caption>
	<tbody>
		<tr>
			<td width='50' height='25' align='center'>아이디</td>
			<td width='150'height='25'>
				<form method='post' action='' onSubmit='checkLogin();return false;'>
					<input type='text' id='id_input' style='width:97%'>
				</form>
			</td>
		</tr>
		<tr>
			<td width='50' height='25' align='center'>비밀번호</td>
			<td width='150' height='25'>
				<form method='post' action='' onSubmit='checkLogin();return false;'>
					<input type='password' id='pass_input' style='width:97%'>
				</form>
			</td>
		</tr>
		<tr>
			<td colspan='2' width='200' align='center'>
				<button class='join_button'>회원가입</button>
				<button class='login_button' onclick='checkLogin();'>확인</button>
			</td>
		</tr>
	</tbody>
</table>
</body>
