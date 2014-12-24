package kr.re.etri.upcm.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;

public class InsertQueryProcess {
	private Connection conn;
	
	public InsertQueryProcess() {
		
		DBConnectionString dbConnStr = new DBConnectionString();
		try {
			//Class.forName("org.mysql.Driver");
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbConnStr.URL, dbConnStr.USERNAME, dbConnStr.PASSWORD);
		} catch (ClassNotFoundException e) {e.printStackTrace();}
		catch (SQLException e) {e.printStackTrace();}
	}
	
	//이미지 업로드 컨텐츠 정보 저장
	public String saveImageContent(String id, String title, String content, ArrayList<String> files, int participate, double longi, double lati) {
		String value = "";
		
		try {
			PreparedStatement pstmt;
			
		//	pstmt = conn.prepareStatement("insert into upcm_image_content(id, title, content, filename, participate, idx) values(?,?,?,?,?,nextval(?))");
		//	pstmt = conn.prepareStatement("insert into upcm_image_content(id, title, content, filename, idx) values(?,?,?,?,nextval(?))");
			pstmt = conn.prepareStatement("insert into upcm_image_content(id, title, content, filename, longitude, latitude, uDate) values(?,?,?,?,?,?,DATE_FORMAT(now() , '%Y-%m-%d'))");
			for(int i=0; i<files.size(); i++) {
				pstmt.setString(1, id);
				pstmt.setString(2, title);
				pstmt.setString(3, content);
				pstmt.setString(4, files.get(i));
				pstmt.setDouble(5, longi);
				pstmt.setDouble(6, lati);
				pstmt.executeUpdate();
			}
			pstmt.close();
			conn.close();
			
			value = "저장 완료";
			
		} catch (SQLException e) {value = e.toString();}
		
		return value;
	}
	
	//비디오 업로드 컨텐츠 정보 저장
	public String saveVideoContent(String id, String title, String content, String file, String thumbnail, String origin_file_name) {
		String value = "";
		
		try {
			PreparedStatement pstmt;
			
			pstmt = conn.prepareStatement("insert into upcm_video_content(id, title, content, filename, thumbnail, originname, idx) values(?,?,?,?,?,?,nextval(?))");
			
			pstmt.setString(1, id);
			pstmt.setString(2, title);
			pstmt.setString(3, content);
			pstmt.setString(4, file);
			pstmt.setString(5, thumbnail);
			pstmt.setString(6, origin_file_name);
			pstmt.setString(7, "video_count");
			
			pstmt.executeUpdate();

			pstmt.close();
			conn.close();
			
			value = "저장 완료";
			
		} catch (SQLException e) {value = e.toString();}
		
		return value;
	}
}
