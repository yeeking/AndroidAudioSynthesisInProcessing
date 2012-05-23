// android synthesis test patch 1
// based on code to be found here:
// http://www.badlogicgames.com/wordpress/?p=228

float phase;
float dPhase;
float samplingRate;
AndroidAudioThread audioThread;
boolean running;
PFont arial;
long then, dspTime;

void setup(){
  float frequency;
  // set up the audio thread
  samplingRate = 44100;
  running = true;
    audioThread = new AndroidAudioThread(samplingRate, 256);
    audioThread.start();  
    // set up synthesis params
    phase = 0;
    dPhase = calcDPhase(samplingRate, 400);
    arial = loadFont("ArialMT-48.vlw");
  textFont(arial);
  
}

void draw(){
  background(0);
  fill(0, 255, 0);
  ellipse(mouseX, height/4, 25, 25);
  fill(255, 0, 0);
  rect(0, height/2, width, height/2);
    dPhase = calcDPhase(samplingRate, mouseX*2);
  text("min buf: "+minSize+"\nfrate: "+frameRate+"\ndsp time ms "+dspTime, 20, 40);
 
}

void mousePressed(){

  if (mouseY > height/2){
    running = false;
  }
}

void generateAudio(float[] buffer){
  then = millis();
  for (int i=0;i<buffer.length;i++){
    buffer[i] = sin(phase);
    phase += dPhase;
  }
  dspTime = millis() - then;
}

float calcDPhase(float samplingRate, float freq){
  float dPhase;
  // how many radians does the phase of a sin wave
  // change by in a single sample 
  // for the sent samplingRate and freq?
  dPhase =  TWO_PI / samplingRate * freq; 
  return dPhase; 
}
