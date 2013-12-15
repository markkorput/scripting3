import processing.serial.*;
import processing.video.*;

ComController com;

int animationLength = 100; // length of animation in frames
int startDelay = 0; // number of frames to wait between trigger and starting animation 
int endDelay = 12; // number of frames BEFORE the end of the animation to release the ball
int unblockLength = 20; // how long (also in frames) to unblock

int startAnimationFrame = -1;
int endAnimationFrame = -1;
int unblockFrame = -1;
int blockFrame = -1;

static char BLOCK = '0';
static char UNBLOCK = '1';

char blockingSignal = BLOCK;

GoldbergMovie visual = null;

void setup()
{
  frameRate(25);
  size(1024, 768);
  com = new ComController(this);
  loadNextVisual();
}

void draw() 
{
  background(0,0,0);
  
  if(frameCount == startAnimationFrame){
    startAnimation();
  }

  //if(frameCount == endAnimationFrame){
    // DO NOTHING
  //}

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

    // we're done with the current routine, load next visual
    loadNextVisual();
  }

  com.sendMessage(blockingSignal);
  com.read();
}

void loadNextVisual(){
  String[] movies = {"balls.mov", "bars.mov", "squares.mov"};
  int[] startDelays = {0,0,0};
  int[] endDelays = {102, 99, 85};

  println("Loading next animation...");
  int index = (int)random(movies.length);
//  visual = new GoldbergMovie(this);
  visual = new GoldbergMovie(this, movies[index], startDelays[index], endDelays[index]);
  animationLength = visual.lengthInFrames();
  println("Animation length: " + animationLength +" frames"); 
  startDelay = visual.startDelay;
  endDelay = visual.endDelay;
}

void onByteReceived(char message){
  println("Byte received: "+message);

  if(message == '1'){
    scheduleAnimation();
  }
}

void keyPressed() {
  if(key == ' '){
    scheduleAnimation();
  }
}

boolean animationScheduled(){
  return endAnimationFrame > frameCount;
}

boolean animationRunning(){
  return frameCount >= startAnimationFrame && frameCount < endAnimationFrame;
}

void scheduleAnimation(){
  if(animationScheduled()){
    println("Can't schedule animation; another animation is still running.");
    return;
  }

  println("Starting animation countdown ("+startDelay+") frames");
  startAnimationFrame = frameCount + startDelay + 1;
  endAnimationFrame = startAnimationFrame + animationLength;
  unblockFrame = endAnimationFrame - endDelay;
}

void startAnimation(){
  println("Starting animation");
  visual.startMovie();
}

