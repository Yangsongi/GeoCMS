<%-- <%@ page language='java' contentType='text/html; charset=EUC-KR' --%>
<%--     pageEncoding='EUC-KR'%> --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>    
<script type='text/javascript'>
	$(function() {
		$('.member_modify').button();
		$('.member_modify').width(80);
		$('.member_modify').height(25);
		$('.member_modify').css('fontSize', 12);
		
		$('.logout_button').button();
		$('.logout_button').width(80);
		$('.logout_button').height(25);
		$('.logout_button').css('fontSize', 12);
		
		//$('#login_table tbody tr td').addClass('ui-widget-content');
		$('#login_table tbody tr td').css('fontSize', 12);
		
		document.getElementById('id').innerHTML = $.cookie('id')+'님 어서오세요.';
		document.getElementById('info').innerHTML = "u-GIS 컨텐츠 저작 갯수: 999";
	});
	function logout() {
		$.cookie('id', null);
		$.cookie('status', null);
		location.href='index.jsp';
		jAlert('로그아웃 되었습니다!', '정보');
	}
</script>

<table id='login_table' border=1 bordercolor='#999999'>
	<caption class='ui-widget-header'>GeoCMS</caption>
	<tbody>
		<tr>
			<td id='id' colspan='2' width='200' height='25' align='center'></td>
		</tr>
		<tr>
			<td width='30' height='25' align='center'>기록</td>
			<td id='info' width='150' height='25' align='center'></td>
		</tr>
		<tr>
			<td colspan='2' width='200' align='center'>
				<button class='member_modify'>정보수정</button>
				<button class='logout_button' onclick='logout();'>로그아웃</button>
			</td>
		</tr>
	</tbody>
</table>