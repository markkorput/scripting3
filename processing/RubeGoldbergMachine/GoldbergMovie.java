import processing.video.*;

class GoldbergMovie
{
  //vars
  RubeGoldbergMachine main;
  Movie movie;

  int animationLength = 100; // length of animation in frames
  int startDelay; // number of frames to wait between trigger and starting animation 
  int endDelay = 12; // number of frames BEFORE the end of the animation to release the ball

  //constructor
  GoldbergMovie(RubeGoldbergMachine main)
  {
    this.movie = new Movie(main, "red-bars.mov");
    this.startDelay = 0;
    this.endDelay = 12;

    this.main = main;
    this.movie.pause();
    this.movie.frameRate(main.frameRate);
  }
  
  void startMovie(){
    this.movie.play();
  }

  int lengthInFrames(){
    // multiply movie's length in second by number of frames per second
    return (int)(this.movie.duration() * this.main.frameRate);
  }

  void drawNextFrame(){
    // this.main.println("Checking for next frame...");
    if (this.movie.available()) {
      this.movie.read();
      main.image(this.movie, 0, 0);
    }
  }
}


