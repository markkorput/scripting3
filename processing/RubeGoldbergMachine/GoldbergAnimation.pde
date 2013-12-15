class GoldbergAnimation
{
  //vars
  RubeGoldbergMachine main;
  PGraphics pg; // framebuffer we draw to before rendering to the actual screen

  int startDelay; // number of frames to wait between trigger and starting animation 
  int endDelay; // number of frames BEFORE the end of the animation to release the ball
  int length; // length of the animation in frames
  int startFrame;

  PVector startPos, endPos;

  // constructor
  GoldbergAnimation(){
    // this constructor isn't really used, but for some reason it's needed
    // to make the GoldberMovie class extend this class
  }

  GoldbergAnimation(RubeGoldbergMachine main)
  {
    this.main = main;
    // defaults
    this.startDelay = 0;
    this.endDelay = 12;
    this.length = 50;
    initialize();
  }

  GoldbergAnimation(RubeGoldbergMachine main, int animation_length, int startDelay, int endDelay)
  {
    this.main = main;
    this.startDelay = startDelay;
    this.endDelay = endDelay;
    this.length = animation_length;
    initialize();
  }

  void initialize(){
    startFrame = -1;
    startPos = new PVector(main.width*0.5, 0); // center top
    endPos = new PVector(main.width*0.5, main.height-1); // center bottom
    
    pg = createGraphics(main.width, main.height);
  }

  // start animation; simply specify the next frame as the start frame
  // and calculate the end frame
  void start(){
    this.startFrame = main.frameCount + 1;
  }

  // returns if the animation is currently running
  boolean running(){
    return (this.startFrame != -1 && main.frameCount < (this.startFrame + this.length - 1));
  }
  
  // zero-based index of the current frame number, returns -1 if animation is not running
  int frame_index(){
    return main.frameCount - this.startFrame;
  } 

  float percentage_per_frame(){
    if(this.length < 1) return 1.0f; // avoid divide-by-zero
    return 1.0f / (this.length - 1);
  }

  // percentage of the current animation progress
  float percentage(){
    if(frame_index()+1 == this.length) return 1.0f; // 100% (factor 1.0) at final frame 
    return frame_index() * percentage_per_frame();
  }

  int lengthInFrames(){
    return this.length;
  }

  PVector currentBallPosition(){
    return new PVector(
      startPos.x + (endPos.x - startPos.x)*percentage(),
      startPos.y + (endPos.y - startPos.y)*percentage() ); 
  }

  void drawNextFrame(){
    pg.beginDraw();
      // clear screen
      pg.background(0);
      // get current position of the ball
      PVector ballPos = currentBallPosition();
      // draw the ball as a simple circle
      pg.ellipse(ballPos.x, ballPos.y, 20, 20);
    pg.endDraw();
    
    // draw this animation's framebuffer to the screen
    image(pg, 0, 0);
  }
}


