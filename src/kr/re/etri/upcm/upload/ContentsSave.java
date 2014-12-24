package kr.re.etri.upcm.upload;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

import org.apache.sanselan.ImageReadException;
import org.apache.sanselan.Sanselan;
import org.apache.sanselan.common.IImageMetadata;
import org.apache.sanselan.formats.jpeg.JpegImageMetadata;
import org.apache.sanselan.formats.tiff.TiffImageMetadata;

import kr.re.etri.upcm.db.InsertQueryProcess;

public class ContentsSave {
	private InsertQueryProcess iqProcess = new InsertQueryProcess();
	public void saveImageContent(String setId, String setTitle, String setContent, ArrayList<String> setFiles, int participate) { 
		//setFiles에 db에 들어갈 전체 주소가 들어온다 
		
		String file_name = setFiles.toString().substring(1, setFiles.toString().length() -1); //양쪽끝에 [ ] 제거
		System.out.println("save시 filenDir="+file_name); 
		
		double lati = 0;
		double longi = 0;
		
		File file = new File(file_name);
		//exif설정
		IImageMetadata metadata = null;
		try { metadata = Sanselan.getMetadata(file); }
		catch(ImageReadException e) { e.printStackTrace(); }
		catch(IOException e) { e.printStackTrace(); }
		
		JpegImageMetadata jpegMetadata = (JpegImageMetadata) metadata;
		
		TiffImageMetadata exifMetadata = jpegMetadata.getExif();
		
		if(exifMetadata != null) {
			try {
				TiffImageMetadata.GPSInfo gpsInfo = exifMetadata.getGPS();
				if(null != gpsInfo) {
					
					longi = gpsInfo.getLongitudeAsDegreesEast();
					lati = gpsInfo.getLatitudeAsDegreesNorth();
					
				}
			} catch(ImageReadException e) { e.printStackTrace(); }
		}
		else {}
		
		String result = iqProcess.saveImageContent(setId, setTitle, setContent, setFiles, participate, longi, lati);
		
		System.out.println(result);
	}
	public void saveVideoContent(String setId, String setTitle, String setContent, String setFile, String setThumbnail, String setOriginFileName) {
		String result = iqProcess.saveVideoContent(setId, setTitle, setContent, setFile, setThumbnail, setOriginFileName);
			
		System.out.println(result);
	}
}
