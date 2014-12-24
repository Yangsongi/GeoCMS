package kr.co.turbosoft.geocms.xml;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class XMLServlet extends HttpServlet {
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {}
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		
		String[] buf = request.getParameter("file_name").split("\\/");
		String file_name = buf[1];
		String xml_data = request.getParameter("xml_data");
		
		System.out.println(xml_data);
		
		String file_dir = getServletContext().getRealPath("/")+"upload\\"; // 저장주소
		
		String result = "";
		XMLRW xmlRW = new XMLRW();
		result = xmlRW.write(file_dir, file_name, xml_data);
		System.out.println(result);
		
		//setContentType 을 먼저 설정하고 getWriter		
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.print(result);
	}
}
