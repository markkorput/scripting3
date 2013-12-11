import processing.serial.*;

ComController com;

boolean bAnimationPlaying;
int animationCounter = 0;

void setup()
{
  com = new ComController(this);
  bAnimationPlaying = false;
}


void draw()
{
  
  if(animationCounter > 0 && animationCounter < 20){
    com.sendMessage('1');
  } else {
    com.sendMessage('0');
  }
  
  if(animationCounter > 0){
    animationCounter -= 1;
  }
      
  com.read();
//  if (mousePressed)
//  {
//    
//    com.sendMessage('1');
//  }
//  else
//  {
//    com.sendMessage('0');
//  }
}

void onMessageReceived(String message)
{
  println("Message received: " + message);
}

void onByteReceived(char message){
  println("Byte received: "+message);
  
  if(message == '1' && animationCounter == 0){
    animationCounter = 100;
  }
}
