import gab.opencv.*;
import java.awt.*;
import processing.video.*;

Rectangle[] faces;

Capture capture;
OpenCV opencv;

int scl = 2;

void setup() {
  size(640, 480);
  frameRate(60);
  
  // (640, 480)の解像度で処理するとMBP処理落ちするのでscl分小さく
  capture = new Capture(this, width/scl, height/scl);
  opencv = new OpenCV(this, width/scl, height/scl);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  
  capture.start();
}

void draw() {
  scale(scl);
  
  opencv.loadImage(capture);
  image(capture, 0, 0);
  
  faces = opencv.detect();
  
  noFill();
  stroke(128, 255, 0);
  strokeWeight(2);
  
  for (Rectangle face: faces) {
    text("TEST", face.x, face.y);
    rect(face.x, face.y, face.width, face.height);
  }
}

void captureEvent(Capture c) {
  c.read();
}
