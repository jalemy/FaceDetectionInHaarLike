class Face {
  static final int LOST = 0;
  static final int CHECK = 1;
  static final int LOOKING = 2;
  static final int ENABLED = 3;
  
  int id;
  Rectangle r;
  
  int timer;
  int state;
  
  Face(int id, Rectangle r) {
    this.id = id;
    this.r = r;
    this.timer = 20;
    this.state = LOOKING;
  }
  
  void update(Rectangle r) {
    this.r = (Rectangle)r.clone();
  }
  
  void countDown() {
    timer--;
    if (timer < 0) {
      timer = 0;
    }
    checkState();
  }
  
  void countUp() {
    timer++;
    if (timer > 100) {
      timer = 100;
    }
    checkState();
  }
  
  void checkState() {
    if (timer == 0) {
      state = LOST;
    } else if (timer >= 80) {
      state = ENABLED;
    } else if (timer >= 20) {
      state = LOOKING;
    } else if (timer > 0) {
      state = CHECK;
    }
  }
  
  boolean dead() {
    if (state == LOST) {
      return true;
    }
    return false;
  }
  
  void display() {
    stroke(0, 255, 64);
    rect(r.x, r.y, r.width, r.height);
    
    fill(128, 128, 128);
    text(id, r.x, r.y);
    
    if (state == CHECK) {
      fill(128, 0, 0, 128);
      rect(r.x, r.y, r.width, r.height);
    } else if (state == LOOKING) {
      fill(128, 128, 0, 128);
      rect(r.x, r.y, r.width, r.height);
    } else if (state == ENABLED) {
      fill(0, 64, 255, 128);
      rect(r.x, r.y, r.width, r.height);
    }
    
    noFill();
  }
}
