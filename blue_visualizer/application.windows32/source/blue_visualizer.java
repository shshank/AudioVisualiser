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

public class blue_visualizer extends PApplet {




Minim minim;
AudioInput song;
FFT fftL, fftR;

public void setup()
{
  size(500, 500);

  minim = new Minim(this);

  song = minim.getLineIn(minim.STEREO, 512);


  fftL = new FFT(song.bufferSize(), song.sampleRate());
  fftR = new FFT(song.bufferSize(), song.sampleRate());
  strokeWeight(2);
}

public void draw()
{
  background(0);
  fftL.forward(song.left);
  fftR.forward(song.right);
  for (int i = 0; i < fftL.specSize(); i++)
  {  
    stroke(random(noise(100)), random(200), 255-25*fftL.getBand(i)*4);

    line(i, height, i, height - fftL.getBand(i)*40);
    line(width-i, height, width-i, height - fftR.getBand(i)*40);

    line(i, 350 - fftL.getBand(i)*40, i+1, 350 - fftL.getBand(i)*40);
    line(width-i, 350 - fftR.getBand(i)*40, width-i+1, 350 - fftR.getBand(i)*40);
  }

  for (int i = 0; i < song.left.size() - 1; i++)
  {
    line(i, 50 + song.left.get(i)*50, i+1, 50 + song.left.get(i+1)*50);
    line(i, 150 + song.right.get(i)*50, i+1, 150 + song.right.get(i+1)*50);
  }
}


public void stop()
{
  song.close();
  minim.stop();

  super.stop();
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "blue_visualizer" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
