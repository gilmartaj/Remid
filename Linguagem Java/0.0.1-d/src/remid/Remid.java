package remid;

import uk.co.caprica.vlcj.component.AudioMediaPlayerComponent;
import uk.co.caprica.vlcj.player.MediaPlayer;

public class Remid
{

	public static void main(String[] args)
	{
		try
		{
			MediaPlayer reprodutor = new AudioMediaPlayerComponent().getMediaPlayer();
			reprodutor.playMedia(args[0]);
			while(!reprodutor.isPlaying());
			while(reprodutor.isPlaying());
			System.out.println("O áudio terminou.");
			System.exit(0);
		}
		catch(Exception e)
		{
			System.out.println("Erro ao reproduzir.");
		}
	}
}
