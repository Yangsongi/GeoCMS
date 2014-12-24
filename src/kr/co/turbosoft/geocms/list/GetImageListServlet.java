package kr.co.turbosoft.geocms.list;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.turbosoft.geocms.db.SelectQueryProcess;

public class GetImageListServlet extends HttpServlet {
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {}
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String type = request.getParameter("type");
		
		SelectQueryProcess sqProcess = new SelectQueryProcess();
		
		if(type.equals("init")) {
			String data = sqProcess.getImageListLen();
			//setContentType 을 먼저 설정하고 getWriter		
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			System.out.println(data);
			out.print(data);
		}
		else if(type.equals("noinit")) {
			String pageNumStr = request.getParameter("pageNum");
			String contentNumStr = request.getParameter("contentNum");
			
			String image_data = sqProcess.getImageList(pageNumStr, contentNumStr);
			
			//setContentType 을 먼저 설정하고 getWriter		
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			System.out.println("GetImageListServlet : "+image_data);
			out.print(image_data);
		}
		
		else if(type.equals("otherOne")) {
			String pageNumStr = request.getParameter("pageNum");
			String contentNumStr = request.getParameter("contentNum");
			
			String image_data = sqProcess.getImageLatestList(pageNumStr, contentNumStr);
			
			//setContentType 을 먼저 설정하고 getWriter		
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			System.out.println("GetImageListServlet : "+image_data);
			out.print(image_data);
		}
		
		else if(type.equals("forMarker")) {
			
			String contentNumStr = "20"; //20개
			
			String m_data = sqProcess.getMdataList(contentNumStr);
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			System.out.println("m_data = "+m_data);
			out.print(m_data);
		}
	}
}