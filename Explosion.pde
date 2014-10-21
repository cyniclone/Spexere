// For explosion effect -- http://www.openprocessing.org/sketch/100333


class Explosion {
  float x;
  float y;
  float r;
  float r_goal = random(20, 80);
  float alp = 255;
  int life = 200;
  float g = random(50, 255);
 
  Explosion(float tmpX, float tmpY) {
    x = tmpX;
    y = tmpY;
  }
 
  void plus() {
    r += 1;
    if (r > r_goal) {
      r = r_goal;
      alp -= 5;
    }
  }
 
  void display() {
    noStroke();
    fill(255, g, 0, alp);
    ellipse(x, y, r, r);
  }
 
  boolean finished() {
    life--;
    if (life < 0) {
      return true;
    } else {
      return false;
    }
  }
}
