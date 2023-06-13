/*
Thomas Sanchez Lengeling.
 http://codigogenerativo.com/

 KinectPV2, Kinect for Windows v2 library for processing

 Skeleton color map example.
 Skeleton (x,y) positions are mapped to match the color Frame
 */

import KinectPV2.KJoint;
import KinectPV2.*;
import processing.sound.*;


KinectPV2 kinect;
SoundFile soundfile;
ArrayList<SoundFile> sounds;

// The default resolution is 1920 x 1280. If you want to use another resolution please add new resolution
int oldResolutionX = 1920;
int oldResolutionY = 1280;
int newResolutionX = 1024;
int newResolutionY = 768;

int coll = 0;
float handCircleRadius = 50; // defines the size of the ellipse around the users hand
float cornerCircleRadius = 50; // ui element circle
ArrayList<Ball> balls; // holds all user drawn balls 
float ballWidth = 48; // defines the size of the balls drawn by user
float ballSpeed = 1; // defines ball speed when program is first started
boolean physics = false; // activates the ball physic
int pianoStepSize = 146; // 1920 = 274 Defines the width of a piano button. Calculated with width / amount buttons

int time; // is needed for the timer between two user inputs

PFont calibri; // the standard font is blurry when enlarged, so we use a better one

void setup() {
  
 
  
  fullScreen(P3D);
  kinect = new KinectPV2(this);

  kinect.enableSkeletonColorMap(true); // is needed for tehe skeleton
  //kinect.enableColorImg(true);
  //kinect.enableDepthImg(true);
  //kinect.enableBodyTrackImg(true);
  //kinect.enableDepthMaskImg(true);
  
  kinect.init(); // starts the kinect sensor
  
  sounds = new ArrayList<SoundFile>(); // holds the piano sounds. is passed to ball.move function
  sounds.add(new SoundFile(this, "cmajor.wav"));
  sounds.add(new SoundFile(this, "dmajor.wav"));
  sounds.add(new SoundFile(this, "emajor.wav"));
  sounds.add(new SoundFile(this, "fmajor.wav"));
  sounds.add(new SoundFile(this, "gmajor.wav"));
  sounds.add(new SoundFile(this, "amajor.wav"));
  sounds.add(new SoundFile(this, "hmajor.wav"));
  
  balls = new ArrayList<Ball>(); // holds every user created ball
 
  
  time = millis(); // initialise timer to draw the circles
  
  calibri = createFont("calibri.ttf", 30); // use calibri font for text on screen
  
  
  
  
  
}

void draw() {
  background(0); // is needed to delete all objects every loop
  
  
  fill(255);
  ellipse(width-200, height/16, cornerCircleRadius*2, cornerCircleRadius*2); // Button right side to start physics
  ellipse(width-300, height/16, cornerCircleRadius*2, cornerCircleRadius*2); // Button right side to stop physics
  ellipse(width-800, height/16, cornerCircleRadius*2, cornerCircleRadius*2); // Button speed 0
  ellipse(width-700, height/16, cornerCircleRadius*2, cornerCircleRadius*2); // Button speed 3
  ellipse(width-600, height/16, cornerCircleRadius*2, cornerCircleRadius*2); // Button speed 5
  //image(kinect.getDepthImage(), 0, 0, width, height);
  //image(kinect.getBodyTrackImage(), 0, 0, 1024, 768);
  //image(kinect.getDepthMaskImage(), 0, 1080, 1920, 800);
  //image(kinect.getColorImage(), 0, 0, 1024, 768); // comment in for camera image instead of black screen
  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap(); // gets users
  
  

  //individual JOINTS
  // This loop draws the skeleton of every tracked user
  // It is modified to only draw the hands
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();
      

      color col  = skeleton.getIndexColor();
      fill(col);
      stroke(col);
      drawBody(joints);
      
      //draw different color for each hand state
      drawHandState(joints[KinectPV2.JointType_HandRight], time);
      drawHandState(joints[KinectPV2.JointType_HandLeft], time);
      
    }
  }

  
  
  
  for (int i = balls.size()-1; i >= 0; i--) {
    Ball ball = balls.get(i);
    if(physics == true) {
    ball.move(sounds);
    }
    ball.display();
    if(ball.y == height-50) {
     balls.remove(i);   
    }
    /*
    if (ball.finished()) {
      // Items can be deleted with remove()
      balls.remove(i);
    }
    */
  }
  
  fill(255);
  text(frameRate, 1650, 50); // shows current framerate
  
  // piano buttons
  stroke(0);
  fill(255);
  // x value left side, y value upper left corner, width, height
  rect(0, height-50, pianoStepSize, 50);
  rect(1 + 1 * pianoStepSize, height-50, pianoStepSize, 50);
  rect(1 + 2 * pianoStepSize, height-50, pianoStepSize, 50);
  rect(1 + 3 * pianoStepSize, height-50, pianoStepSize, 50);
  rect(1 + 4 * pianoStepSize, height-50, pianoStepSize, 50);
  rect(1 + 5 * pianoStepSize, height-50, pianoStepSize, 50);
  rect(1 + 6 * pianoStepSize, height-50, pianoStepSize, 50);
  
  // text inside the buttons
  fill(0);
  textFont(calibri);
  text("C-Dur", 0+5, height-25);
  text("D-Dur", 0+ 5 + pianoStepSize, height-25);
  text("E-Dur", 0+ 6 + 2*pianoStepSize, height-25);
  text("F-Dur", 0+ 6 + 3*pianoStepSize, height-25);
  text("G-Dur", 0+ 6 + 4*pianoStepSize, height-25);
  text("A-Dur", 0+ 6 + 5*pianoStepSize, height-25);
  text("H-Dur", 0+ 6 + 6*pianoStepSize, height-25);
  
  fill(0,0,0);
  text("Play", width-325, height/16);
  text("Pause", width-230, height/16);
  text("0", width-812, height/16);
  text("3", width-712, height/16);
  text("5", width-612, height/16);
  
}
/*
This function draws a circle around every hand
Additionally it checks whether one of the circle is touching one of the buttons
The left hand can touch the speed buttons
the right hand can press play or pause
*/
void drawBody(KJoint[] joints) {
    
    // RIGHT HAND
    // draws an ellipse at the right Hand that changes color when touching one of the buttons
    if(dist((joints[KinectPV2.JointType_HandRight].getX()/oldResolutionX) * newResolutionX, (joints[KinectPV2.JointType_HandRight].getY() / oldResolutionY) * newResolutionY , width-200, height/200)< (cornerCircleRadius + handCircleRadius) || 
       dist((joints[KinectPV2.JointType_HandRight].getX()/oldResolutionX) * newResolutionX, (joints[KinectPV2.JointType_HandRight].getY() / oldResolutionY) * newResolutionY , width-200, height/300)< (cornerCircleRadius + handCircleRadius)){
      fill(255,0,0);
    } else {
    fill(0,255,0);
    }
    // enables or disables physics when touching a button
    if(dist((joints[KinectPV2.JointType_HandRight].getX() / oldResolutionX) * newResolutionX, (joints[KinectPV2.JointType_HandRight].getY() / oldResolutionY) * newResolutionY , width-200, height/16)< (cornerCircleRadius + handCircleRadius)){  
    physics = false;
    }
     if(dist((joints[KinectPV2.JointType_HandRight].getX() / oldResolutionX) * newResolutionX, (joints[KinectPV2.JointType_HandRight].getY() / oldResolutionY) * newResolutionY , width-300, height/16)< (cornerCircleRadius + handCircleRadius)){  
    physics = true;
    }
    ellipse((joints[KinectPV2.JointType_HandRight].getX() / oldResolutionX) * newResolutionX, (joints[KinectPV2.JointType_HandRight].getY() / oldResolutionY) * newResolutionY, handCircleRadius*2, handCircleRadius*2);
    
    
    // LEFT HAND
    // draws an ellipse at the left Hand that changes color when touching one of the buttons 
    fill(0,255,0);
    ellipse((joints[KinectPV2.JointType_HandLeft].getX()/oldResolutionX) * newResolutionX, (joints[KinectPV2.JointType_HandLeft].getY()/ oldResolutionY)* newResolutionY, handCircleRadius*2, handCircleRadius*2);
    // when a button is touched the speed of the next user created ball will change to that value
    if(dist((joints[KinectPV2.JointType_HandLeft].getX()/oldResolutionX) * newResolutionX, (joints[KinectPV2.JointType_HandLeft].getY()/ oldResolutionY)* newResolutionY , width-800, height/16)< (cornerCircleRadius + handCircleRadius)){  
      ballSpeed = 0;
    }
    if(dist((joints[KinectPV2.JointType_HandLeft].getX()/oldResolutionX) * newResolutionX, (joints[KinectPV2.JointType_HandLeft].getY()/ oldResolutionY)* newResolutionY , width-700, height/16)< (cornerCircleRadius + handCircleRadius)){  
      ballSpeed = 3;
    }
    if(dist((joints[KinectPV2.JointType_HandLeft].getX()/oldResolutionX) * newResolutionX, (joints[KinectPV2.JointType_HandLeft].getY()/ oldResolutionY)* newResolutionY , width-600, height/16)< (cornerCircleRadius + handCircleRadius)){  
      ballSpeed = 5;
    }
    
    // in addition to the tracked hands it is possible to show the whole skeleton with the code below
    /*
  drawBone(joints, KinectPV2.JointType_Head, KinectPV2.JointType_Neck);
  drawBone(joints, KinectPV2.JointType_Neck, KinectPV2.JointType_SpineShoulder);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_SpineMid);
  drawBone(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderRight);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderLeft);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipRight);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipLeft);

  // Right Arm
  drawBone(joints, KinectPV2.JointType_ShoulderRight, KinectPV2.JointType_ElbowRight);
  drawBone(joints, KinectPV2.JointType_ElbowRight, KinectPV2.JointType_WristRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_HandRight);
  drawBone(joints, KinectPV2.JointType_HandRight, KinectPV2.JointType_HandTipRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_ThumbRight);

  // Left Arm
  drawBone(joints, KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ElbowLeft);
  drawBone(joints, KinectPV2.JointType_ElbowLeft, KinectPV2.JointType_WristLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_HandLeft);
  drawBone(joints, KinectPV2.JointType_HandLeft, KinectPV2.JointType_HandTipLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_ThumbLeft);

  // Right Leg
  drawBone(joints, KinectPV2.JointType_HipRight, KinectPV2.JointType_KneeRight);
  drawBone(joints, KinectPV2.JointType_KneeRight, KinectPV2.JointType_AnkleRight);
  drawBone(joints, KinectPV2.JointType_AnkleRight, KinectPV2.JointType_FootRight);

  // Left Leg
  drawBone(joints, KinectPV2.JointType_HipLeft, KinectPV2.JointType_KneeLeft);
  drawBone(joints, KinectPV2.JointType_KneeLeft, KinectPV2.JointType_AnkleLeft);
  drawBone(joints, KinectPV2.JointType_AnkleLeft, KinectPV2.JointType_FootLeft);
*/
    
}
// is not used in the final version. Can be used to draw the joints of the skeleton
//draw joint
void drawJoint(KJoint[] joints, int jointType) {
  pushMatrix();
  translate(joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
  ellipse(0, 0, 25, 25);
  popMatrix();
}
//is not used in the final version. Can be used to draw lines between the skeleton joints 
//draw bone
void drawBone(KJoint[] joints, int jointType1, int jointType2) {
  pushMatrix();
  
  translate(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ());
  ellipse(0, 0, 25, 25);
  popMatrix();
  line(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ(), joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());
}

//draw hand state
void drawHandState(KJoint joint, int time) {
  noStroke();
  handState(joint.getState(), joint, time);
  pushMatrix();
  translate((joint.getX() / oldResolutionX) * newResolutionX, (joint.getY() / oldResolutionY) * newResolutionY, joint.getZ());
  ellipse(0, 0, 70, 70); // add red ellipse when hand closed
  popMatrix();
}

/*
Different hand state
 KinectPV2.HandState_Open
 KinectPV2.HandState_Closed
 KinectPV2.HandState_Lasso
 KinectPV2.HandState_NotTracked
 */
 
void handState(int handState, KJoint a, int times) {
  switch(handState) {
  case KinectPV2.HandState_Open:
    fill(0, 255, 0);
    break;
  case KinectPV2.HandState_Closed: // when the hand is closed the user draws a ball at the position the hand was closed
    fill(255, 0, 0);
    // makes sure you can only create a ball every x seconds
    if(millis() > times + 500) {
    balls.add(new Ball((a.getX() / oldResolutionX) * newResolutionX , (a.getY() / oldResolutionY)*newResolutionY, ballWidth, ballSpeed));
    time = millis();
    }
    break;
  case KinectPV2.HandState_Lasso:
    fill(0, 0, 255);
    break;
  case KinectPV2.HandState_NotTracked:
    fill(255, 255, 255);
    break;
  }
}
