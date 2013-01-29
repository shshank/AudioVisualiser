import processing.core.*; 
import processing.data.*; 
import processing.opengl.*; 

import ddf.minim.*; 
import ddf.minim.analysis.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class Jumping_bars extends PApplet {




Minim minim;
AudioInput song;
FFT fftL, fftR, fftLog;

public void setup()
{
  size(500, 500);
  minim = new Minim(this);

  song = minim.getLineIn(minim.STEREO, 512);

  fftL = new FFT(song.bufferSize(), song.sampleRate());
  fftR = new FFT(song.bufferSize(), song.sampleRate());
  fftLog = new FFT(song.bufferSize(), song.sampleRate());
  fftLog.logAverages(22, 20);


  strokeWeight(2);
}

public void draw()
{
  background(0);
  fftL.forward(song.left);
  fftR.forward(song.right);
  fftLog.forward(song.mix);
  for (int i = 0; i < fftL.specSize(); i++)
  {  
    stroke(random(noise(100)), random(200), 255-25*fftL.getBand(i)*4);
    strokeWeight(4);

    line(i, 350 - fftL.getBand(i)*30, i+5, 350 - fftL.getBand(i)*30);
    line(width-i, 350 - fftR.getBand(i)*30, width-i+5, 350 - fftR.getBand(i)*30);
  }

  for (int i = 0; i < song.left.size() - 1; i++)
  {
    line(i, 150 + song.right.get(i)*50, i+5, 150 + song.right.get(i+1)*50);
  }
}


public void stop()
{
  song.close();
  minim.stop();

  super.stop();
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Jumping_bars" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
