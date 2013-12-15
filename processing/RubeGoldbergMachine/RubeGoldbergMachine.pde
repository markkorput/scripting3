import processing.serial.*;
import processing.video.*;

// our serial communication object
ComController com;

// we use frame numbers to schedule these four types of events
// -1 means unscheduled, because `frameCount` will never be -1
int startAnimationFrame = -1;
int endAnimationFrame = -1;
int unblockFrame = -1;
int blockFrame = -1;

// byte-message sent through the serial connection
static char BLOCK = '0'; 
static char UNBLOCK = '1';

// Block by default
char blockingSignal = BLOCK; 

// how long (in frames) to unblock when dropping the ball
int unblockLength = 20; 


GoldbergMovie visual = null;

void setup()
{
  frameRate(25);
  // beamer resolution
  size(1024, 768);
  // initialize serial communication object
  com = new ComController(this);

  // preload first visual
  loadNextVisual();
  // clear the screen
  background(0,0,0);
}

void draw() 
{
  if(frameCount == startAnimationFrame){
    println("Starting animation");
    visual.startMovie();
  }

  if(frameCount == endAnimationFrame){
    // as soon as one animation if done, load the next one
    loadNextVisual();
    background(0,0,0);
  }

  if(animationRunning()){
    visual.drawNextFrame();
  }

  if(frameCount == unblockFrame){
    println("Unblocking ball at frame "+frameCount);
    blockingSignal = UNBLOCK;
    // schedule switching back to blocking
    blockFrame = frameCount + unblockLength;
  }

  if(frameCount == blockFrame){
    println("Reblocking ball at frame "+frameCount);
    blockingSignal = BLOCK;
  }

  com.sendMessage(blockingSignal);
  com.read();
}

void loadNextVisual(){
  // predefined movies
  String[] movies = {"balls.mov", "bars.mov", "squares.mov"};
  int[] startDelays = {0,0,0};
  int[] endDelays = {102, 99, 85};

  println("Loading next animation...");

  // pick a random movie
  int index = (int)random(movies.length);
  // initialize movie object
  //  visual = new GoldbergMovie(this);
  visual = new GoldbergMovie(this, movies[index], startDelays[index], endDelays[index]);
}

void onByteReceived(char message){
  println("Byte received: "+message);

  // getting a '1' byte through the serial connection
  // means we should start a new animation
  if(message == '1'){
    scheduleAnimation();
  }
}

// for debugging purposes we can also trigger the next animation
// by pressing the space bar
void keyPressed() {
  if(key == ' '){
    scheduleAnimation();
  }
}

// if the endAnimationFrame is still coming, this means there's an active animation
// scheduled or still running
boolean animationScheduled(){
  return endAnimationFrame > frameCount;
}

// if the current frame if somewhere between startAnimationFrame and endAnimationFrame
// this means an animation is currently running
boolean animationRunning(){
  return frameCount >= startAnimationFrame && frameCount < endAnimationFrame;
}

void scheduleAnimation(){
  // Abort if there's already an animation scheduled;
  // can't schedule multiple animation simultanously
  if(animationScheduled()){
    println("Can't schedule animation; another animation is still running.");
    return;
  }

  println("Starting animation in ("+visual.startDelay+") frames");
  // schedule startAnimation, endAnimation and unblock events
  // for the next animation
  // (the reblock event will be scheduled by the unblocking) 
  startAnimationFrame = frameCount + visual.startDelay + 1;
  endAnimationFrame = startAnimationFrame + visual.lengthInFrames();
  unblockFrame = endAnimationFrame - visual.endDelay;
}

