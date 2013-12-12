import processing.serial.*;

ComController com;

int animationLength = 100;
int startDelay = 0;
int endDelay = 12;

int animationCounter = -1;
int countdownCounter = -1;

void setup()
{
  frameRate(24);
  com = new ComController(this);
}

void draw()
{
  // when the countdown is done, start the/an animation
  if(countdownCounter == 0){
    println("Countdown over");
    startAnimation();
  }

  // decrease countdown counter until it's back at -1
  if(countdownCounter == -1){  
    animationCounter -= 1;
  }

  // for the last 12 frames (0.5 seconds) of the animation, 
  // send '1' to the arduino, unblocking the ball
  if(animationCounter > 0 && animationCounter < endDelay){
    println("Unblocking ball");
    // unblock ball
    com.sendMessage('1');
  } else {
    // (continue to) block ball
    com.sendMessage('0');
  }

  // count-down each frame
  if(animationCounter > 0){
    animationCounter -= 1;
  }

  com.read();
}

void onMessageReceived(String message)
{
  println("Message received: " + message);
}

void onByteReceived(char message){
  println("Byte received: "+message);

  if(message == '1'){
    startAnimationCountdown();
  }
}

void startAnimationCountdown(){
  // can't start animation countdown when an animation is still running or we're already counting down
  if(animationCounter == 0 && countdownCounter == 0){
    // if the countdown is configured to be less than one frame;
    // start animation immediately, otherwise; initialize countdown
    if(startDelay < 1){
      startAnimation();
    } else {
      println("Starting animation countdown ("+startDelay+") frames");
      countdownCounter = startDelay;
    }
  } else {
    println("Can't start animation countdown; another animation or countdown is still running");
  }
}

void startAnimation(){
  // can't start animation when an animation is still running
  if(animationCounter == 0){
    println("Starting animation");
    animationCounter = animationLength;
  } else {
    println("Can't start animation; another animation is still running.");
  }
}
