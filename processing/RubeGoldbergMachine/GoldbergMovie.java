import processing.video.*;

class GoldbergMovie
{
  //vars
  RubeGoldbergMachine main;
  Movie movie;

  int animationLength = 100; // length of animation in frames
  int startDelay; // number of frames to wait between trigger and starting animation 
  int endDelay = 12; // number of frames BEFORE the end of the animation to release the ball

  int screenPosX = 0;

  //constructor
  GoldbergMovie(RubeGoldbergMachine main)
  {
    this.main = main;

    this.movie = new Movie(main, "balls.mov");
    this.startDelay = 0;
    this.endDelay = 12;

    // this.initMovieDimensions(); 
    this.preload();

    // center video horizontally on the screen
    this.screenPosX = (int)((this.main.width*0.5) - (this.movie.width * 0.5));

    main.println("Movie size: "+this.movie.width+"x"+this.movie.height+"px");
    main.println("Screen width: "+this.main.width);
    main.println("Movie's horizontal position: "+this.screenPosX);

    // should we do this?
    // this.movie.frameRate(main.frameRate);

    
  }
  
  void startMovie(){
    this.movie.play();
  }

  int lengthInFrames(){
    // multiply movie's length in second by number of frames per second
    return (int)(this.movie.duration() * this.movie.frameRate);
  }

  void drawNextFrame(){
    // this.main.println("Checking for next frame...");
    if (this.movie.available()) {
      this.movie.read();
      main.image(this.movie, screenPosX, 0);
    }
  }
  
  void initMovieDimensions(){
    // movie.width and movie.height won't be initialized until the first frame is read;
    // so start the movie, read a frame, pause the movie and reset position to beginning 
    this.movie.play();
    this.movie.read();
    this.movie.pause();
    this.movie.jump(0.0f);
  }
  
  void preload(){
    main.println("preloading movie");

    int start = main.millis();
    
    this.movie.play();

    while(movie.available()){
      this.movie.read();
    }

    this.movie.pause();
    this.movie.jump(0.0f);
    
    main.println("preloading finished in "+ (main.millis() - start)*0.001 + " seconds");
  }
}


