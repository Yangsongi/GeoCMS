package kr.co.turbosoft.geocms.util;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

import org.apache.sanselan.ImageReadException;
import org.apache.sanselan.Sanselan;
import org.apache.sanselan.common.IImageMetadata;
import org.apache.sanselan.formats.jpeg.JpegImageMetadata;
import org.apache.sanselan.formats.tiff.TiffImageMetadata;

public class ContentsSave {
	public String saveImageContent(ArrayList<String> setFiles) {
		//setFiles�� db�� �� ��ü �ּҰ� ���´� 
		String file_name = setFiles.toString().substring(1, setFiles.toString().length() -1); //���ʳ��� [ ] ����
		System.out.println("save�� filenDir="+file_name); 
		
		double lati = 0;
		double longi = 0;
		
		File file = new File(file_name);
		//exif����
		IImageMetadata metadata = null;
		try { metadata = Sanselan.getMetadata(file); }
		catch(ImageReadException e) { e.printStackTrace(); }
		catch(IOException e) { e.printStackTrace(); }
		
		if(metadata != null){
			JpegImageMetadata jpegMetadata = (JpegImageMetadata) metadata;
			if(jpegMetadata != null){	
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
			}	
		}
		
		String resultData = "longi:"+ String.valueOf(longi);
		resultData += ",lati:"+ String.valueOf(lati);
		return resultData;
	}
}
