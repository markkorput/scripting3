import processing.video.*;

// having this GolbergMovie class EXTEND the GoldberAnimation class is a really
// ugly way to allow the main script (RubeGoldbergMachine) to use these two classes
// interchangeably. We should probably use java's Interface mechanism here
// (implements instead of extends), but I couldn't quickly find a way to get this working...
class GoldbergMovie extends GoldbergAnimation
{
  //vars
  RubeGoldbergMachine main;
  Movie movie;

  int startDelay; // number of frames to wait between trigger and starting animation 
  int endDelay = 12; // number of frames BEFORE the end of the animation to release the ball

  int screenPosX = 0;
  int screenPosY = 0;

  //constructor
  GoldbergMovie(RubeGoldbergMachine main)
  {
    super(main);

    this.main = main;

    // default movie
    this.movie = new Movie(main, "balls.mov");
    this.startDelay = 0;
    this.endDelay = 92;

    // should we do this?
    // this.movie.frameRate(main.frameRate);
    initialize();
  }

  GoldbergMovie(RubeGoldbergMachine main, String movie_path, int startDelay, int endDelay)
  {
    this.main = main;

    this.movie = new Movie(main, movie_path);
    this.startDelay = startDelay;
    this.endDelay = endDelay;

    // should we do this?
    // this.movie.frameRate(main.frameRate);
    initialize();
  }
  
  void initialize(){
    // this.initMovieDimensions(); 
    this.preload();

    // center video horizontally on the screen
    this.screenPosX = (int)((this.main.width*0.5) - (this.movie.width * 0.5));
    this.screenPosY = (int)((this.main.height*0.5) - (this.movie.height * 0.5));

    main.println("Movie size: "+this.movie.width+"x"+this.movie.height+"px");
    main.println("Screen size: "+this.main.width+"x"+this.main.height+"px");
    main.println("Movie position: "+this.screenPosX+","+this.screenPosY);
  }
  
  void start(){
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
      main.image(this.movie, screenPosX, screenPosY);
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


