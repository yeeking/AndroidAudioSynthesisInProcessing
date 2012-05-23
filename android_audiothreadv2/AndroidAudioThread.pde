import android.media.*;

int minSize;

public class AndroidAudioThread extends Thread
{
   AudioTrack track;
   short[] bufferS;
   float[] bufferF;
 
   public AndroidAudioThread(float samplingRate, int bufferLength)
   {
       minSize =AudioTrack.getMinBufferSize( (int)samplingRate, AudioFormat.CHANNEL_CONFIGURATION_MONO, AudioFormat.ENCODING_PCM_16BIT );        
       //println();
       // note that we set the buffer just to something small
       // not to the minSize
       // setting to minSize seems to cause glitches on the delivery of audio 
       // to the sound card (i.e. ireegular delivery rate)
       bufferS = new short[bufferLength];
       bufferF = new float[bufferLength];
       
      track = new AudioTrack( AudioManager.STREAM_MUSIC, (int)samplingRate, 
                                        AudioFormat.CHANNEL_CONFIGURATION_MONO, AudioFormat.ENCODING_PCM_16BIT, 
                                        minSize, AudioTrack.MODE_STREAM);
      track.play();        
   }	   
   // overidden from Thread
   public void run(){
     while(running){
       // fill the float buffer
       generateAudio(bufferF);
       // convert it to shorts
       for (int i=0;i<bufferF.length;i++){
           bufferS[i] = (short)(bufferF[i] * Short.MAX_VALUE);;
       }
       // send it to the audio device!
       track.write( bufferS, 0, bufferS.length );

     }
   }
 		
}

