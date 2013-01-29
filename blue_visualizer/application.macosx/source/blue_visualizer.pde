import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioInput song;
FFT fftL, fftR;

void setup()
{
  size(500, 500);

  minim = new Minim(this);

  song = minim.getLineIn(minim.STEREO, 512);


  fftL = new FFT(song.bufferSize(), song.sampleRate());
  fftR = new FFT(song.bufferSize(), song.sampleRate());
  strokeWeight(2);
}

void draw()
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


void stop()
{
  song.close();
  minim.stop();

  super.stop();
}

