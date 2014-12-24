package kr.re.etri.upcm.upload;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

public class UploadServlet extends HttpServlet {
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {}
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");

		//변수에 ID, 타이틀, 내용 저장
		String id = request.getParameter("id");
		String title = request.getParameter("title");
		String content = request.getParameter("content");
		String type = request.getParameter("type");

		//파일 정보 저장 변수
		ArrayList<String> files = new ArrayList<String>();

		//파일 업로드
		boolean isMultipart = ServletFileUpload.isMultipartContent(request); // 멀티파트인지 체크

		System.out.println("isMultipart : "+isMultipart);

		try {
			if(isMultipart) {
				int uploadMaxSize = 100*1024*1024; //100MB
				File tempDir = new File(getServletContext().getRealPath("/")+File.separator+"tmp");
				File uploadDir = new File(getServletContext().getRealPath("/")+File.separator+"upload");
				 
				if(!tempDir.exists()) tempDir.mkdir();
				if(!uploadDir.exists()) uploadDir.mkdir();
				 
				DiskFileItemFactory factory = new DiskFileItemFactory(uploadMaxSize, tempDir);
				ServletFileUpload upload = new ServletFileUpload(factory);
				upload.setSizeMax(uploadMaxSize);
				List items = upload.parseRequest(request);
				Iterator iter = items.iterator();
				while(iter.hasNext()) {
					FileItem item = (FileItem)iter.next();
					if(!item.isFormField()) {
						String fieldName = item.getFieldName();
						String fileName = item.getName();
						String contentType = item.getContentType();
						boolean isInMemory = item.isInMemory();
						long sizeInBytes = item.getSize();
						System.out.println("FieldName : "+fieldName);
						System.out.println("FileName : "+fileName);
						System.out.println("ContentType : "+contentType);
						System.out.println("IsInMemory : "+isInMemory);
						System.out.println("SizeInBytes : "+sizeInBytes);
						
				   
						String uploadFilePath = uploadDir+File.separator+fileName;
						String newUploadFilePath = uploadFilePath;
						int fileIndex = 1;
						File uploadFile;
						while((uploadFile = new File(newUploadFilePath)).exists()) {
							String prefix = uploadFilePath.substring(0, uploadFilePath.lastIndexOf("."));
							String suffix = uploadFilePath.substring(uploadFilePath.lastIndexOf("."));
							newUploadFilePath = prefix+"("+fileIndex+")"+suffix;
							fileIndex++;
							uploadFile = new File(newUploadFilePath);
						}
						System.out.println("uploadFile : "+newUploadFilePath);
						
						files.add(newUploadFilePath);
						
						item.write(uploadFile);
					}
				}
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}


		ContentsSave contentsSave = new ContentsSave();
		//이미지 정보 DB 저장
		if(type.equals("1")) {
			System.out.println("id : "+id+" title : "+title+" content : "+content+" participate(init 0) : 0");
			contentsSave.saveImageContent(id, title, content, files, 0);
			PrintWriter out = response.getWriter();
			out.print("다중 파일 저장..");
		}
		//비디오 정보 DB 저장 및 저장된 파일명 전송
		else if(type.equals("2")) {
			if(files.size()==1) {
				//DB 저장
				String file_name = files.get(0).substring(0, files.get(0).length()-4) + "_ogg.ogg";
				String thumbnail = files.get(0).substring(0, files.get(0).length()-4) + "_thumb.jpg";

				contentsSave.saveVideoContent(id, title, content, file_name, thumbnail, files.get(0));
				PrintWriter out = response.getWriter();
				out.print(files.get(0));
			}
			else {
				System.out.println("동영상 파일의 업로드 갯수가 1개가 아닙니다!!!");
			}
		}
		else {}
	}
}
