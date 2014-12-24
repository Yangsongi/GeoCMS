package kr.re.etri.upcm.ffmpeg;

public class VideoEncoding {
	//������ ���ڵ�
	public void convertToOgg(String file_name) {
		FFmpegSetting ffmpegSetting = new FFmpegSetting();
		
		String[] message = new String[] {
				ffmpegSetting.getFfmpeg_dir_and_file_name(),
				"-i",
				file_name,
				ffmpegSetting.getSrc_no_ext(file_name)+"_ogg.ogg"
		};
		
		FFmpeg ffmpeg = new FFmpeg();
		String value = ffmpeg.runFFmpeg(file_name, ffmpegSetting.getSrc_dir(file_name), message, "encoding");
		System.out.println("���� ���� : "+value);
	}
}
