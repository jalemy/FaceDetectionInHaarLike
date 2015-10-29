import gab.opencv.*;
import java.awt.*;
import processing.video.*;

ArrayList<Face> faceList;
Rectangle[] faces;

Capture capture;
OpenCV opencv;

int faceCount = 0;
int enabledCount;
int scl = 1;

void setup() {
  size(1280, 720);
  frameRate(1);
  strokeWeight(2);
  textSize(26);
  
  faceList = new ArrayList<Face>();
  
  // (640, 480)の解像度で処理するとMBP処理落ちするのでscl分小さく
  // TODO: 1280 * 720用に調整 fps: 1
  capture = new Capture(this, width/scl, height/scl, 15);
  opencv = new OpenCV(this, width/scl, height/scl);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  
  capture.start();
}

void draw() {
  scale(scl);
  
  opencv.loadImage(capture);
  image(capture, 0, 0);
  
  detectFaces();
  
  for (int i = 0; i < faceList.size(); i++) {
    if (faceList.get(i).dead()) {
      faceList.remove(i);
    }
  }
  faceList.trimToSize();
  
  for (Face fl: faceList) {
    fl.display();
    if (fl.state == fl.ENABLED) {
      enabledCount++;
    }
  }
  
  fill(255, 255, 255);
  text("FPS:" + frameRate + "  faceList:" + faceList.size() + "  enabledCount:" + enabledCount, 10, 30);
  enabledCount = 0;
}

void detectFaces() {
  faces = opencv.detect();
  
  // detect()で何も見つからなかった時
  if (faces.length <= 0) {
    for (Face fl : faceList) {
      fl.countDown();
    }
    return;
  }
  
  // 最初の認識, もしくはfaceListに何も保持していなかった時
  if (faceList.isEmpty()) {
    for (Rectangle f: faces) {
      faceList.add(new Face(faceCount, f));
      faceCount++;
    }
  } 
  // faceListに既に顔情報があるとき
  else {
    boolean[] listUsed = new boolean[faceList.size()];
    boolean[] used = new boolean[faces.length];
    // faceListとfacesの顔矩形の当たり判定をとって、既に存在していた矩形にチェック
    for (int i = 0; i < faceList.size(); i++) {
      for (int j = 0; j < faces.length; j++) {
        // TODO: そもそもRectangleのx, yが中心点じゃなくて左上座標だった
        // facesの顔矩形の中心点がfaceListの顔矩形の範囲内にあったら当たりとみなす
        if (faces[j].x > faceList.get(i).r.x - faceList.get(i).r.width &&
            faces[j].x < faceList.get(i).r.x + faceList.get(i).r.width &&
            faces[j].y > faceList.get(i).r.y - faceList.get(i).r.height &&
            faces[j].y < faceList.get(i).r.y + faceList.get(i).r.height &&
            !used[j]) {
              used[j] = true;
              listUsed[i] = true;
              faceList.get(i).update(faces[j]);
              faceList.get(i).countUp();
        }
      }
    }
    
    // 当たり判定にて見つからなかったfaceListの要素をcountDown
    for (int i = 0; i < faceList.size(); i++) {
      if (!listUsed[i]) {
        faceList.get(i).countDown();
      }
    }
    
    // 当たり判定にて未使用と判断されたfacesをfaceListにadd
    for (int i = 0; i < faces.length; i++) {
      if (!used[i]) {
        faceList.add(new Face(faceCount, faces[i]));
        faceCount++;
      }
    }
  }
}
  
void captureEvent(Capture c) {
  c.read();
}
