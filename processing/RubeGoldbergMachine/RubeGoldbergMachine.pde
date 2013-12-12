import processing.serial.*;

ComController com;

static int animationLength = 100; // length of animation in frames
static int startDelay = 0; // number of frames to wait between trigger and starting animation 
static int endDelay = 12; // number of frames BEFORE the end of the animation to release the ball
static int unblockLength = 20; // how long (also in frames) to unblock

int startAnimationFrame = -1;
int endAnimationFrame = -1;
int unblockFrame = -1;
int blockFrame = -1;

static char BLOCK = '0';
static char UNBLOCK = '1';

char blockingSignal = BLOCK;

void setup()
{
  frameRate(24);
  com = new ComController(this);
}

void draw()
{
  if(frameCount == startAnimationFrame){
    // startAnimation();
  }
  
  if(frameCount == endAnimationFrame){
    // DO NOTHING
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

void onMessageReceived(String message)
{
  println("Message received: " + message);
  // does nothing else; we don't really use this anymore
}

void onByteReceived(char message){
  println("Byte received: "+message);

  if(message == '1'){
    scheduleAnimation();
  }
}

boolean animationRunning(){
  return endAnimationFrame > frameCount;
}

void scheduleAnimation(){
  if(animationRunning()){
    println("Can't schedule animation; another animation is still running.");
    return;
  }

  println("Starting animation countdown ("+startDelay+") frames");
  startAnimationFrame = frameCount + startDelay;
  endAnimationFrame = startAnimationFrame + animationLength;
  unblockFrame = endAnimationFrame - endDelay;
}

