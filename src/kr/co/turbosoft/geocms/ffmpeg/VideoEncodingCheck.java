package kr.co.turbosoft.geocms.ffmpeg;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class VideoEncodingCheck extends HttpServlet {
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {}
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String origin_url = request.getParameter("origin_url");
		
		String base_path = getServletContext().getRealPath("/");
		
		String[] origin_url_arr = origin_url.split("/");
		String upload_folder_path = origin_url_arr[0];
		String origin_file_name = origin_url_arr[1];
		
		String full_path = base_path.replace("\\", "\\\\");
		full_path += upload_folder_path;
		
		File file = new File(full_path);
		File[] file_list = file.listFiles();
		boolean file_find = false;
		for(int i=0; i<file_list.length; i++) {
			System.out.println(file_list[i].getName());
			if(file_list[i].getName().equals(origin_file_name)) file_find = true;
		}
		
		//setContentType 을 먼저 설정하고 getWriter		
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		if(file_find) out.print("true");
		else out.print("false");
	}
}
