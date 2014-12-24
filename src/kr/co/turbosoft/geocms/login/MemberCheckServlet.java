package kr.co.turbosoft.geocms.login;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.turbosoft.geocms.db.SelectQueryProcess;

public class MemberCheckServlet extends HttpServlet {
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {}
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String id = request.getParameter("id");
		String pass = request.getParameter("pass");
		
		SelectQueryProcess sqProcess = new SelectQueryProcess();
		
		String data = sqProcess.userCheck(id, pass);
		
		PrintWriter out = response.getWriter();
		out.print(data);
	}
}
