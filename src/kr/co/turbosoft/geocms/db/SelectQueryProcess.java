package kr.co.turbosoft.geocms.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class SelectQueryProcess {
	private Connection conn;
	
	public SelectQueryProcess() {
		
		DBConnectionString dbConnStr = new DBConnectionString();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbConnStr.URL, dbConnStr.USERNAME, dbConnStr.PASSWORD);
		} catch (ClassNotFoundException e) {e.printStackTrace();}
		catch (SQLException e) {e.printStackTrace();}
	}
	
	//유저 로그인 검사
	public String userCheck(String id, String pass) {
		String value = "";
		
		try {
			PreparedStatement pstmt;
			
			pstmt = conn.prepareStatement("select * from upcm_user where id= ? and pass= ?");
			pstmt.setString(1, id);
			pstmt.setString(2, pass);
			
			ResultSet rs = pstmt.executeQuery();
			
			while(rs.next()) {
				if(rs.getString(1).equals(id) && rs.getString(2).equals(pass)) {
					value = "success";
				}
			}
			
			if(!value.equals("success")) value = "fail";
			
			pstmt.close();
			conn.close();
			
		} catch (SQLException e) {e.printStackTrace();}
		
		return value;
	}
	
	//메인 이미지 리스트 길이 요청
	public String getImageListLen() {
		String value = "";
		
		try {
			PreparedStatement pstmt;
			
			pstmt = conn.prepareStatement("select count(*) from upcm_image_content");
			
			ResultSet rs = pstmt.executeQuery();
			
			while(rs.next()) {
				value += rs.getString(1);
			}
		
			pstmt.close();
			conn.close();
			
		} catch (SQLException e) {e.printStackTrace();}
		
		return value;
	}
	
	//메인 이미지 리스트 요청
	public String getImageList(String pageNumStr, String contentNumStr) {
		String value = "";
		
		try {
			PreparedStatement pstmt;
			
			int contentNum = Integer.parseInt(contentNumStr);
			
			int pageNum = Integer.parseInt(pageNumStr);

			//한 페이지 게시물은 총 12 개
			if(pageNum == 1) 
			{ 
				System.out.println("페이지넘버="+pageNum+"콘텐트넘버="+contentNum);
				pstmt = conn.prepareStatement("select * from upcm_image_content order by idx ASC limit "+contentNum); 
			}
			else 
			{
				pstmt = conn.prepareStatement("select * from upcm_image_content order by idx ASC limit "+contentNum+" offset "+(contentNum*(pageNum-1)));
			}
			ResultSet rs = pstmt.executeQuery();
			
			//id, title, content, filename 연결
			while(rs.next()) {
				value += rs.getString(1) + "<separator>" + rs.getString(2) + "<separator>" + rs.getString(3) + "<separator>" + rs.getString(4) + "<separator>" + rs.getString(7) + "<line>";
			}
			//맨 마지막의 <line> 문자열 삭제
			value = value.substring(0, value.length()-6);
			
			pstmt.close();
			conn.close();
			
		} catch (SQLException e) {e.printStackTrace();}
		
		return value;
	}
	
	//메인 이미지 - 최근업로드 리스트 요청
		public String getImageLatestList(String pageNumStr, String contentNumStr) {
			String value = "";
			
			try {
				PreparedStatement pstmt;
				
				int contentNum = Integer.parseInt(contentNumStr);
				
				int pageNum = Integer.parseInt(pageNumStr);

				//한 페이지 게시물은 총 12 개
				if(pageNum == 1) 
				{ 
					System.out.println("페이지넘버="+pageNum+"콘텐트넘버="+contentNum);
					pstmt = conn.prepareStatement("select * from upcm_image_content order by idx DESC limit "+contentNum); 
				}
				else 
				{
					pstmt = conn.prepareStatement("select * from upcm_image_content order by idx DESC limit "+contentNum+" offset "+(contentNum*(pageNum-1)));
				}
				ResultSet rs = pstmt.executeQuery();
				
				//id, title, content, filename 연결
				while(rs.next()) {
					value += rs.getString(1) + "<separator>" + rs.getString(2) + "<separator>" + rs.getString(3) + "<separator>" + rs.getString(4) + "<separator>" + rs.getString(7) +"<line>";
				}
				//맨 마지막의 <line> 문자열 삭제
				value = value.substring(0, value.length()-6);
				
				pstmt.close();
				conn.close();
				
			} catch (SQLException e) {e.printStackTrace();}
			
			return value;
		}
	
	
	
	//메인 비디오 리스트 길이 요청
	public String getVideoListLen() {
		String value = "";
		
		try {
			PreparedStatement pstmt;
			
			pstmt = conn.prepareStatement("select count(*) from upcm_video_content");
			
			ResultSet rs = pstmt.executeQuery();
			
			while(rs.next()) {
				value += rs.getString(1);
			}
		
			pstmt.close();
			conn.close();
			
		} catch (SQLException e) {e.printStackTrace();}
		
		return value;
	}
	
	//메인 비디오 리스트 요청
	public String getVideoList(String pageNumStr, String contentNumStr) {
		String value = "";
		
		try {
			PreparedStatement pstmt;
			
			int contentNum = Integer.parseInt(contentNumStr);
			
			int pageNum = Integer.parseInt(pageNumStr);
			
			//한 페이지 게시물은 총 12 개
			if(pageNum==1) { pstmt = conn.prepareStatement("select * from upcm_video_content order by idx DESC limit "+contentNum); }
			else {
				pstmt = conn.prepareStatement("select * from upcm_video_content order by idx DESC limit "+contentNum+" offset "+(contentNum*(pageNum-1)));
			}
			ResultSet rs = pstmt.executeQuery();
			
			//id, title, content, filename 연결
			while(rs.next()) {
				value += rs.getString(1) + "<separator>" + rs.getString(2) + "<separator>" + rs.getString(3) + "<separator>" + rs.getString(4) + "<separator>" + rs.getString(5) + "<line>";
			}
			//맨 마지막의 <line> 문자열 삭제
			value = value.substring(0, value.length()-6);
			
			pstmt.close();
			conn.close();
			
		} catch (SQLException e) {e.printStackTrace();}
		
		return value;
	}
	
	//검색 리스트 요청
	public String getSearchList(String text, String target, String type) {
		String value = "";
		
		try {
			PreparedStatement pstmt;
			
			ResultSet rs;
			if(target.equals("image") || target.equals("all")) {
				pstmt = conn.prepareStatement("SELECT * FROM upcm_image_content");
				
				rs = pstmt.executeQuery();
				
				while(rs.next()) {
					if(type.equals("post")) {
						if(rs.getString(2).indexOf(text)!=-1 && rs.getString(3).indexOf(text)!=-1)
							value += "image" + "<separator>" + "Title and Content"+ "<separator>" + rs.getString(1) + "<separator>" + rs.getString(2) + "<separator>" + rs.getString(3) + "<separator>" + rs.getString(4) + "<separator>" + rs.getString(5) + "<separator>" + rs.getString(6)+ "<separator>" + rs.getString(7)+ "<separator>" + rs.getString(8) +  "<line>";
						else if(rs.getString(2).indexOf(text)!=-1)
							value += "image" + "<separator>" + "Title"+ "<separator>" + rs.getString(1) + "<separator>" + rs.getString(2) + "<separator>" + rs.getString(3) + "<separator>" + rs.getString(4) + "<separator>" + rs.getString(5) + "<separator>" + rs.getString(6)+ "<separator>" + rs.getString(7)+ "<separator>" + rs.getString(8) +  "<line>";
						else if(rs.getString(3).indexOf(text)!=-1)
							value += "image" + "<separator>" + "Content"+ "<separator>" + rs.getString(1) + "<separator>" + rs.getString(2) + "<separator>" + rs.getString(3) + "<separator>" + rs.getString(4) + "<separator>" + rs.getString(5) + "<separator>" + rs.getString(6)+ "<separator>" + rs.getString(7)+ "<separator>" + rs.getString(8) +  "<line>";
						String fileName = rs.getString(4);
						if(fileName.substring(0, fileName.length()-4).equals(text) || fileName.substring(0, fileName.length()-5).equals(text))
							value += "image" + "<separator>" + "Annotation"+ "<separator>" + rs.getString(1) + "<separator>" + rs.getString(2) + "<separator>" + rs.getString(3) + "<separator>" + rs.getString(4) + "<separator>" + rs.getString(5) + "<separator>" + rs.getString(6)+ "<separator>" + rs.getString(7)+ "<separator>" + rs.getString(8) +  "<line>";
					}
					else if(type.equals("get")) {
						if(rs.getString(2).indexOf(text)!=-1 && rs.getString(3).indexOf(text)!=-1)
							value += "<result><type>image</type>" + "<search>Title and Content</search>"+ "<id>" + rs.getString(1) + "</id><title>" + rs.getString(2) + "</title><content>" + rs.getString(3) + "</content><fileurl>" + rs.getString(4) + "</fileurl></result>";
						else if(rs.getString(2).indexOf(text)!=-1)
							value += "<result><type>image</type>" + "<search>Title</search>"+ "<id>" + rs.getString(1) + "</id><title>" + rs.getString(2) + "</title><content>" + rs.getString(3) + "</content><fileurl>" + rs.getString(4) + "</fileurl></result>";
						else if(rs.getString(3).indexOf(text)!=-1)
							value += "<result><type>image</type>" + "<search>Content</search>"+ "<id>" + rs.getString(1) + "</id><title>" + rs.getString(2) + "</title><content>" + rs.getString(3) + "</content><fileurl>" + rs.getString(4) + "</fileurl></result>";
						String fileName = rs.getString(4);
						if(fileName.substring(0, fileName.length()-4).equals(text) || fileName.substring(0, fileName.length()-5).equals(text))
							value += "<result><type>image</type>" + "<search>Annotation</search>"+ "<id>" + rs.getString(1) + "</id><title>" + rs.getString(2) + "</title><content>" + rs.getString(3) + "</content><fileurl>" + rs.getString(4) + "</fileurl></result>";
					}
					else {}
				}
			}
			/*if(target.equals("video") || target.equals("all")) {
				pstmt = conn.prepareStatement("SELECT * FROM upcm_video_content");
				
				rs = pstmt.executeQuery();
				
				while(rs.next()) {
					if(type.equals("post")) {
						if(rs.getString(2).indexOf(text)!=-1 && rs.getString(3).indexOf(text)!=-1)
							value += "video" + "<separator>" + "Title and Content"+ "<separator>" + rs.getString(1) + "<separator>" + rs.getString(2) + "<separator>" + rs.getString(3) + "<separator>" + rs.getString(4) + "<separator>" + rs.getString(5) + "<separator>" + rs.getString(6) + "<line>";
						else if(rs.getString(2).indexOf(text)!=-1)
							value += "video" + "<separator>" + "Title"+ "<separator>" + rs.getString(1) + "<separator>" + rs.getString(2) + "<separator>" + rs.getString(3) + "<separator>" + rs.getString(4) + "<separator>" + rs.getString(5) + "<separator>" + rs.getString(6) + "<line>";
						else if(rs.getString(3).indexOf(text)!=-1)
							value += "video" + "<separator>" + "Content"+ "<separator>" + rs.getString(1) + "<separator>" + rs.getString(2) + "<separator>" + rs.getString(3) + "<separator>" + rs.getString(4) + "<separator>" + rs.getString(5) + "<separator>" + rs.getString(6) + "<line>";
						String fileName = rs.getString(4);
						if(fileName.substring(0, fileName.length()-4).equals(text) || fileName.substring(0, fileName.length()-5).equals(text))
							value += "video" + "<separator>" + "Annotation"+ "<separator>" + rs.getString(1) + "<separator>" + rs.getString(2) + "<separator>" + rs.getString(3) + "<separator>" + rs.getString(4) + "<separator>" + rs.getString(5) + "<separator>" + rs.getString(6) + "<line>";
					}
					else if(type.equals("get")) {
						if(rs.getString(2).indexOf(text)!=-1 && rs.getString(3).indexOf(text)!=-1)
							value += "<result><type>video</type>" + "<search>Title and Content</search>"+ "<id>" + rs.getString(1) + "</id><title>" + rs.getString(2) + "</title><content>" + rs.getString(3) + "</content><fileurl>" + rs.getString(4) + "</fileurl><thumbnailurl>" + rs.getString(5) + "</thumbnailurl><originurl>" + rs.getString(6) + "</originurl></result>";
						else if(rs.getString(2).indexOf(text)!=-1)
							value += "<result><type>video</type>" + "<search>Title</search>"+ "<id>" + rs.getString(1) + "</id><title>" + rs.getString(2) + "</title><content>" + rs.getString(3) + "</content><fileurl>" + rs.getString(4) + "</fileurl><thumbnailurl>" + rs.getString(5) + "</thumbnailurl><originurl>" + rs.getString(6) + "</originurl></result>";
						else if(rs.getString(3).indexOf(text)!=-1)
							value += "<result><type>video</type>" + "<search>Content</search>"+ "<id>" + rs.getString(1) + "</id><title>" + rs.getString(2) + "</title><content>" + rs.getString(3) + "</content><fileurl>" + rs.getString(4) + "</fileurl><thumbnailurl>" + rs.getString(5) + "</thumbnailurl><originurl>" + rs.getString(6) + "</originurl></result>";
						String fileName = rs.getString(4);
						if(fileName.substring(0, fileName.length()-4).equals(text) || fileName.substring(0, fileName.length()-5).equals(text))
							value += "<result><type>video</type>" + "<search>Annotation</search>"+ "<id>" + rs.getString(1) + "</id><title>" + rs.getString(2) + "</title><content>" + rs.getString(3) + "</content><fileurl>" + rs.getString(4) + "</fileurl><thumbnailurl>" + rs.getString(5) + "</thumbnailurl><originurl>" + rs.getString(6) + "</originurl></result>";
					}
					else {}
				}
			}*/
		} catch (SQLException e) {e.printStackTrace(); }
		
		return value;
	}
	//marker위해 data가져오기
	public String getMdataList(String contentNumStr) {
		String value = "";
		
		try {
			PreparedStatement pstmt;
			
			int contentNum = Integer.parseInt(contentNumStr); //20개
			
			pstmt = conn.prepareStatement("select * from upcm_image_content order by idx DESC limit "+contentNum);
			
			ResultSet rs = pstmt.executeQuery();
			
			//id, title, content, filename 연결
			while(rs.next()) {
				value += rs.getString(1) + "<separator>" + rs.getString(2) + "<separator>" + rs.getString(3) + "<separator>" + rs.getString(4) + "<separator>" + rs.getString(5) + "<separator>" + rs.getString(6)+ "<separator>" + rs.getString(7)+ "<separator>" + rs.getString(8) + "<line>";
			}
			//맨 마지막의 <line> 문자열 삭제
			value = value.substring(0, value.length()-6);
			pstmt.close();
			conn.close();
			
		} catch (SQLException e) {e.printStackTrace();}
		
		return value;
	}
}
