import processing.io.*;
import gohai.glvideo.*;
GLCapture video;
color trackColor;

void setup(){
  size(320,240,P2D);
  video = new GLCapture(this);
  video.start();
  
  trackColor = color(255, 0, 0);
  
  GPIO.pinMode(4, GPIO.OUTPUT);
  GPIO.pinMode(15, GPIO.OUTPUT);
  GPIO.pinMode(17, GPIO.OUTPUT);
  GPIO.pinMode(18, GPIO.OUTPUT);
}

void draw(){
  background(0);
  if (video.available()){
    video.read();
  }
  
  video.loadPixels();
  image(video, 0, 0);
  
  float worldRecord = 500;
  int closestX = 0;
  int closestY = 0;
  
  //Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++) {
    for (int y = 0; y < video.height; y++) {
      int loc = x + y * video.width;
      // what is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);
      
      //using euclidean distance to compare colors
      float d = dist(r1, g1, b1, r2, g2, b2); // we are using the dist() function to compare the cur color with tracking color
      // if cur color is more similar to track color than closest color, save current location and current diff
      if (d < worldRecord) {
        worldRecord = d;
        closestX = x;
        closestY = y;
      }
    }
  }
  
  if (worldRecord < 10) {
    // draw a circle at the tracked pixel
    fill(trackColor);
    strokeWeight(4.0);
    stroke(0);
    ellipse(closestX, closestY, 16, 16);
    println(closestX, closestY);
    
    if (closestX < 140) {
      GPIO.digitalWrite(4, GPIO.HIGH);
      GPIO.digitalWrite(14, GPIO.HIGH);
      GPIO.digitalWrite(17, GPIO.HIGH);
      GPIO.digitalWrite(18, GPIO.LOW);
      delay(10);
      GPIO.digitalWrite(4, GPIO.HIGH);
      GPIO.digitalWrite(14, GPIO.HIGH);
      GPIO.digitalWrite(17, GPIO.HIGH);
      GPIO.digitalWrite(18, GPIO.HIGH);
      
      println("Turn Right");
    } else if (closestX > 200) {
      GPIO.digitalWrite(4, GPIO.HIGH);
      GPIO.digitalWrite(14, GPIO.LOW);
      GPIO.digitalWrite(17, GPIO.HIGH);
      GPIO.digitalWrite(18, GPIO.HIGH);
      delay(10);
      GPIO.digitalWrite(4, GPIO.HIGH);
      GPIO.digitalWrite(14, GPIO.HIGH);
      GPIO.digitalWrite(17, GPIO.HIGH);
      GPIO.digitalWrite(18, GPIO.HIGH);
      
      println("Turn Left");
    } else if (closestY < 170) {
      GPIO.digitalWrite(4, GPIO.HIGH);
      GPIO.digitalWrite(14, GPIO.LOW);
      GPIO.digitalWrite(17, GPIO.HIGH);
      GPIO.digitalWrite(18, GPIO.LOW);
      delay(10);
      GPIO.digitalWrite(4, GPIO.HIGH);
      GPIO.digitalWrite(14, GPIO.HIGH);
      GPIO.digitalWrite(17, GPIO.HIGH);
      GPIO.digitalWrite(18, GPIO.HIGH);
      
      println("Go Forward");
    } else {
      GPIO.digitalWrite(4, GPIO.HIGH);
      GPIO.digitalWrite(14, GPIO.HIGH);
      GPIO.digitalWrite(17, GPIO.HIGH);
      GPIO.digitalWrite(18, GPIO.HIGH);
    }
  } else {
      GPIO.digitalWrite(4, GPIO.HIGH);
      GPIO.digitalWrite(14, GPIO.HIGH);
      GPIO.digitalWrite(17, GPIO.HIGH);
      GPIO.digitalWrite(18, GPIO.HIGH);
  }
}

void mousePressed() {
  // save color wherre the mouse is clicked in trackColor variable
  int loc = mouseX + mouseY * video.width;
  trackColor = video.pixels[loc];
}
