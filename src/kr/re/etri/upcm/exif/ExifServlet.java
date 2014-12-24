package kr.re.etri.upcm.exif;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ExifServlet extends HttpServlet {
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {}
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		
		String[] buf = request.getParameter("file_name").split("\\/");
		String type = request.getParameter("type");
		String file_name = buf[1];
		
		String file_dir = getServletContext().getRealPath("/")+"upload\\"+file_name;
		
		System.out.println("file_dir = "+file_dir);
		
		ExifRW exifRW = new ExifRW();
		String result = "";
		
		if(type.equals("init") || type.equals("load")) {
			result = exifRW.read(file_dir, type);
			System.out.println(result);
		}
		else if(type.equals("save")){
			String data = request.getParameter("data");
			String[] split_data = exifRW.parseData(data);
			exifRW.write(file_dir, split_data);
		}
		else {}
		
		//setContentType �� ���� �����ϰ� getWriter		
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.print(result);
	}
}
