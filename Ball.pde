

class Ball {
  
  float x; // x position
  float y; // y position
  float speed;
  float gravity;
  float w; // the width of a ball
  
  
  // constructor
  Ball(float tempX, float tempY, float tempW, float tempS) {
    x = tempX;
    y = tempY;
    w = tempW;
    speed = tempS;
    gravity = 0.01;
  }
  
    void move(ArrayList<SoundFile> sounds) {
    // Add gravity to speed
    speed = speed + gravity;
    // Add speed to y location
    y = y + speed;
    
    // If ellipse reaches the bottom
    if (y > height-50) {
      y = height-50; // makes sure the sound is only played once
      
      // defines the sound the ball makes when it hits a different section of  the x axis
      if(x>0 && x<=pianoStepSize) {sounds.get(0).play();}
      if(x>pianoStepSize && x<=2*pianoStepSize) {sounds.get(1).play();}
      if(x>2*pianoStepSize && x<=3*pianoStepSize) {sounds.get(2).play();}
      if(x>3*pianoStepSize && x<=4*pianoStepSize) {sounds.get(3).play();}
      if(x>4*pianoStepSize && x<=5*pianoStepSize) {sounds.get(4).play();}
      if(x>5*pianoStepSize && x<=6*pianoStepSize) {sounds.get(5).play();}
      if(x>6*pianoStepSize && x<7*pianoStepSize) {sounds.get(6).play();}
    }
  }
  
  // Display the circle
  void display() {
    fill(255);
    ellipse(x,y,w,w);
  }
}  
