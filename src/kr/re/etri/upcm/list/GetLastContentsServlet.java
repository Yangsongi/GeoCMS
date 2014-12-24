package kr.re.etri.upcm.list;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.re.etri.upcm.db.SelectQueryProcess;

public class GetLastContentsServlet extends HttpServlet {
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {}
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String type = request.getParameter("type");
		
		SelectQueryProcess sqProcess = new SelectQueryProcess();
		
		if(type.equals("init")) {
			String data = sqProcess.getImageListLen();
			PrintWriter out = response.getWriter();
			out.print(data);
		}
		else if(type.equals("noinit")) {
			String pageNumStr = request.getParameter("pageNum");
			String contentNumStr = request.getParameter("contentNum");
			
			String image_data = sqProcess.getImageList(pageNumStr, contentNumStr);
			
			//setContentType 을 먼저 설정하고 getWriter		
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			out.print(image_data);
		}
	}
}