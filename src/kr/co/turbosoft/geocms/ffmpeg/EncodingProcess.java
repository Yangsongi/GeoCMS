package kr.co.turbosoft.geocms.ffmpeg;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class EncodingProcess extends HttpServlet {
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {}
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String file_name = request.getParameter("filename");
		
		//�̹��� ����
		ImageExtract imageExtract = new ImageExtract();
		imageExtract.ImageExtractor(file_name);
		//�ڵ� ���ڵ� (1�� : ogg)
		VideoEncoding videoEncoding = new VideoEncoding();
		videoEncoding.convertToOgg(file_name);
	}
}
