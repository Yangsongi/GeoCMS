package kr.co.turbosoft.geocms.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;

public class UpdateQueryProcess {
private Connection conn;
	
	public UpdateQueryProcess() {
		
		DBConnectionString dbConnStr = new DBConnectionString();
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbConnStr.URL, dbConnStr.USERNAME, dbConnStr.PASSWORD);
		} catch (ClassNotFoundException e) {e.printStackTrace();}
		catch (SQLException e) {e.printStackTrace();}
	}
	
	//���� ���ڵ� �Ϸ� ���� ���� ...(������)
	public String encodingComplete(String file) {
		String value = "";
		
		try {
			PreparedStatement pstmt;
			
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement("update upcm_video_content set encoding=? where filename=?");
			
			pstmt.setString(1, "true");
			pstmt.setString(2, file);
				
			pstmt.executeUpdate();
			
			conn.commit();
			
			pstmt.close();
			conn.close();
			
			value = "���� �Ϸ�";
			
		} catch (SQLException e) {value = e.toString();}
		
		return value;
	}
}
