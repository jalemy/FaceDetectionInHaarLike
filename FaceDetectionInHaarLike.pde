import gab.opencv.*;
import java.awt.*;
import processing.video.*;

Capture capture;
OpenCV opencv;

void setup() {
  size(640, 480);
  capture = new Capture(this, width, height);
  opencv = new OpenCV(this, width, height);
  
  capture.start();
}

void draw() {
  opencv.loadImage(capture);
  image(capture, 0, 0);
}

void captureEvent(Capture c) {
  c.read();
}
