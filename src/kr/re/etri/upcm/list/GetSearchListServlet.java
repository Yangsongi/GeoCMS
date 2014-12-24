package kr.re.etri.upcm.list;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.re.etri.upcm.db.SelectQueryProcess;
import kr.re.etri.upcm.xml.SearchXML;

@SuppressWarnings("serial")
public class GetSearchListServlet extends HttpServlet {
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		
		String type = "get";
		String text = request.getParameter("text");
		String target = request.getParameter("target");
		String check = request.getParameter("check");
		String search_data = "<?xml version='1.0' encoding='utf-8'?><upcm_result>";
		if(check.equals("content")) {
			SelectQueryProcess sqProcess = new SelectQueryProcess();
			search_data += sqProcess.getSearchList(text, target, type);
		}
		else if(check.equals("anno")) {
			SearchXML searchXML = new SearchXML();
			String dir = getServletContext().getRealPath("/")+"upload";
			ArrayList<String> fileNames = searchXML.getSearchList(dir, text, target, type);
			
			SelectQueryProcess sqProcess = new SelectQueryProcess();
			for(int i=0; i<fileNames.size(); i++) {
				text = fileNames.get(i).split("@")[0];
				target = fileNames.get(i).split("@")[1];
				search_data += sqProcess.getSearchList(text, target, type);
			}
		}
		else if(check.equals("all")){
			SelectQueryProcess sqProcess = new SelectQueryProcess();
			search_data += sqProcess.getSearchList(text, target, type);
			
			SearchXML searchXML = new SearchXML();
			String dir = getServletContext().getRealPath("/")+"upload";
			ArrayList<String> fileNames = searchXML.getSearchList(dir, text, target, type);
			
			for(int i=0; i<fileNames.size(); i++) {
				text = fileNames.get(i).split("@")[0];
				target = fileNames.get(i).split("@")[1];
				search_data += sqProcess.getSearchList(text, target, type);
			}
		}
		else {}
		search_data += "</upcm_result>";
		System.out.println("search_data1="+search_data);
		//setContentType 을 먼저 설정하고 getWriter		
		response.setContentType("text/xml;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.print(search_data);
	}
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		
		String type = "post";
		String text = request.getParameter("text");
		String target = request.getParameter("target");
		String check = request.getParameter("check");
		System.out.println(text+"  "+target+"  "+check);
		String search_data = "";
		if(check.equals("content")) {
			SelectQueryProcess sqProcess = new SelectQueryProcess();
			search_data = sqProcess.getSearchList(text, target, type);
		}
		else if(check.equals("anno")) {
			SearchXML searchXML = new SearchXML();
			String dir = getServletContext().getRealPath("/")+"upload";
			ArrayList<String> fileNames = searchXML.getSearchList(dir, text, target, type);
			
			SelectQueryProcess sqProcess = new SelectQueryProcess();
			for(int i=0; i<fileNames.size(); i++) {
				text = fileNames.get(i).split("@")[0];
				target = fileNames.get(i).split("@")[1];
				search_data += sqProcess.getSearchList(text, target, type);
			}
		}
		else if(check.equals("all")){
			SelectQueryProcess sqProcess = new SelectQueryProcess();
			search_data = sqProcess.getSearchList(text, target, type); // db에서 title이나 content중 검색
			
			//annotation 검색 from XML file
			SearchXML searchXML = new SearchXML();	
			String dir = getServletContext().getRealPath("/")+"upload";
			ArrayList<String> fileNames = searchXML.getSearchList(dir, text, target, type);
			
			for(int i=0; i<fileNames.size(); i++) {
				text = fileNames.get(i).split("@")[0];
				target = fileNames.get(i).split("@")[1];
				search_data += sqProcess.getSearchList(text, target, type);
			}
		}
		else {}
		System.out.println("search_data2="+search_data);
		//setContentType 을 먼저 설정하고 getWriter
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.print(search_data);
	}
}