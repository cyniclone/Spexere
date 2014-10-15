class Bullet {
  final int DIAMETER = 10;
  float x, y;
  float xSpeed, ySpeed;

  Bullet (float x, float y, float xSpeed, float ySpeed) {
    this.x = x;
    this.y = y;
    this.xSpeed = xSpeed;
    this.ySpeed = ySpeed;
  }

  void update() {
    x += xSpeed;
    y += ySpeed;
  }

  void display() {
    rectMode(CENTER);
    fill(random(100, 255), random(200, 255), random(100, 255));
    
    rect(x, y, DIAMETER, DIAMETER);
  }
}

