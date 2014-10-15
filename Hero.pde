class Hero extends Entity {
  final int DIAMETER = 40;
  final int RADIUS = DIAMETER/2;
  final float MOVESPEED = 4;

  final float BULLET_SPEED = 8;
  ArrayList<Bullet> bullets; 

  boolean hit; // Stays true for about one second
  float frameWhenHit; //Frame when the player was hit
  int xDir, yDir;

  // Constructor
  Hero (int hp, float x, float y) {
    super (hp, x, y);
    bullets = new ArrayList<Bullet>();
    hit = false;
    xDir = 0;
    yDir = 0;
  }

  // ---------- DISPLAY METHOD ---------------------------------
  void display() {
    fill (255);
    ellipse(x, y, DIAMETER, DIAMETER);

    for (int i = 0; i < bullets.size (); i++) {
      bullets.get(i).display();
    }
  }

  // ---------- UPDATE VARIABLES AND POSITION --------------------
  void update() {
    // Update position
    updatePosition();

    // Update bullet coordinates
    for (int i = 0; i < bullets.size (); i++) {
      bullets.get(i).update();
    }

    // Remove any out of bounds bullets
    for (int i = 0; i < bullets.size (); i++) {
      if (bullets.get(i).x < 0 || bullets.get(i).x > width || 
        bullets.get(i).y < 0 || bullets.get(i).y > height) {
        bullets.remove(i);
      }
    }

    if (frameCount % 5 == 0 ) { 
      println(x + " " + y);
    }

    // Wrap-around coordinates
    x = (x < 0) ? width : x;
    x = (x > width) ? 0 : x;
    y = (y < 0) ? height : y;
    y = (y > height) ? 0 : y;
  }

  void updatePosition () {
    x += xDir * MOVESPEED;
    y += yDir * MOVESPEED;
  }

  // ---------- HANDLE BLOCK COLLISION ------------------------------
  void checkCollisionWith (Block block) {
    if (dist(x, y, block.x + block.side/2, block.y + block.side/2) < RADIUS + block.side/2) {

      //Touching top of hero
      if (y - RADIUS <= block.down && y >= block.down) {
        y = block.down + RADIUS;
      }

      //Touching bottom of hero
      if (y + RADIUS >= block.up && y <= block.up) {
        y = block.up - RADIUS;
      }

      //Touching left of hero
      if (x - RADIUS <= block.right && x >= block.right) {
        x = block.right + RADIUS;
      }

      //Touching right of hero
      if (x + RADIUS >= block.left && x <= block.left) {
        x = block.left - RADIUS;
      }
    }
  }

  // ---------- SHOOT BULLETS AND MANAGE BULLET ARRAYLIST --------------------
  void shoot(float t) {
    // Make new bullet and add to arraylist
    // Use rCos(theta) = x and rSin(theta) = y
    // To convert from polar to Cartesian

    //float d = dist(x, y, mouseX, mouseY)*.01;
    Bullet b = new Bullet(x, y, BULLET_SPEED*cos(t), BULLET_SPEED*-sin(t));
    if (bullets.size() < 5) {
      bullets.add(b);
    }
  }
}

