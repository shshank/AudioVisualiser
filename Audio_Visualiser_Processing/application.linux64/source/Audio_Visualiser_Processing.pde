import ddf.minim.*;                //importing the minim classes
import ddf.minim.analysis.*;

Minim minim;                       //creating object for minim
AudioInput song;                   //creating object for audio input
FFT fft, fftLin, fftLog;           //creating objects for fft
int sens=2;                        //sensitibility of the visualizer
int rWidth, tMargin=490;


void setup()
{
  size(500, 500);

  minim = new Minim(this);        //constructer for the minim class
  song = minim.getLineIn();       //providing audio source

                                  //constructers for fft objects
  fft = new FFT(song.bufferSize(), song.sampleRate());
  fftLin = new FFT(song.bufferSize(), song.sampleRate()); 
  fftLin.linAverages(30);        //breaking the buffer to 30 linear bands
  fftLog = new FFT(song.bufferSize(), song.sampleRate());
  fftLog.logAverages(22, 3);     //breaking the buffer in bands as per the log scale

            
                                  //Setting up colors
  stroke(0, 255, 0);
  strokeWeight(1);
  fill(0, 255, 0);
  
  textFont(createFont("Georgia", 16));
  rectMode(CORNERS);
  textAlign(RIGHT);
}

void draw()
{
  background(0);
  /*
  Performing fft on mix buffer
  
  This is same as working with mono sound. The audio input being stereo,
  you can also access the right and left channels using 'right' & 'left' keywords.  
  */
  fft.forward(song.mix);
  fftLin.forward(song.mix);
  fftLog.forward(song.mix);
                                    //Showing the amplitude
  for (int i = 0; i < song.left.size() - 1; i++)
  {
    line(i, 50 + song.mix.get(i)*sens, i+1, 50 + song.mix.get(i+1)*sens*20);
  }

                                    //showing the frequency
  for (int i = 0; i < fft.specSize(); i++)
  {  
                                    //using the same line equation as amplitude
    line(i, 150 - fft.getBand(i)*sens, i+1, 150 - fft.getBand(i)*sens);
                                    //fixing the starting point to show lines
                                    //     instead of particles
    line(i, 250, i, 250 - fft.getBand(i)*sens);
  }
  
                                    //showing Linearly averaged frequency
  rWidth = int(width/fftLin.avgSize());
  for (int i = 0; i < fftLin.avgSize(); i++)
  {
    rect(i*rWidth, 350, i*rWidth + rWidth, 350 - fftLin.getAvg(i)*sens);
  }

                                    //showing logarithmically averaged frequency
  rWidth = int(width/fftLog.avgSize());
  for (int i = 0; i < fftLog.avgSize(); i++)
  {
    rect(i*rWidth, 450, i*rWidth + rWidth, 450 - fftLog.getAvg(i)*sens);
  }

                                     //showing text
  text("Amplitude", tMargin, 75);
  text("Frequency", tMargin, 175);
  text("Frequency", tMargin, 275);
  text("Linearly Averaged Freq.", tMargin, 375);
  text("Logarithmically Averaged Freq.", tMargin, 475);
}


                                    //closing the minim objects
void stop()
{
  song.close();
  minim.stop();

  super.stop();
}

