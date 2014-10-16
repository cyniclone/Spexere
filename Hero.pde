class Hero extends Entity {
  PImage heroImg;

  final int DIAMETER = TILE;
  final int RADIUS = DIAMETER/2;
  final float MOVESPEED = 4;

  final float BULLET_SPEED = 8;
  ArrayList<Bullet> bullets; 

  boolean hit; // Stays true for about one second
  boolean moving; // Animates sprite when true
  boolean flipImage;
  float frameWhenHit; //Frame when the player was hit
  float vx, vy; // Velocity
  int dx, dy; // Direction

  // Constructor
  Hero (int hp, float x, float y) {
    super (hp, x, y);
    bullets = new ArrayList<Bullet>();
    hit = false;
    moving = false;
    flipImage = false;
    dx = 0;
    dy = 0;
    vx = 0;
    vy = 0;

    heroImg = loadImage("hero.png");
  }

  // ---------- DISPLAY METHOD ---------------------------------
  void display() {
    // Shadow beneath sprite
    fill (60, 60, 60, 100);
    noStroke();
    ellipse(x + RADIUS, y + 30, 35, 20);

    // Animates sprite based on velocity
    if (vx != 0 || vy != 0) {
      moving = true;
    } else { 
      moving = false;
    }
    if (frameCount % 20 == 0) {
      flipImage = !flipImage;
    }
    if (flipImage && moving) {
      pushMatrix();
      scale(-1, 1);
      image(heroImg, -x - heroImg.width, y);
      popMatrix();
    } else {
      image(heroImg, x, y);
    }

    //Display bullets
    for (int i = 0; i < bullets.size (); i++) {
      bullets.get(i).display();
    }
  }

  // ---------- UPDATE VARIABLES AND POSITION --------------------
  void update() {
    updateVelocity();
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

    // Wrap-around coordinates
    x = (x < 0) ? width : x;
    x = (x > width) ? 0 : x;
    y = (y < 0) ? height : y;
    y = (y > height) ? 0 : y;
  }
  void updateVelocity() {
    vx = dx * MOVESPEED;
    vy = dy * MOVESPEED;
  }
  void updatePosition () {
    x += vx;
    y += vy;
  }

  // ---------- HANDLE BLOCK COLLISION ------------------------------
  void checkCollisionWith (Block block) {

    //Check vertical collision
    if (abs(x - (block.x + block.side/2)) < (RADIUS + block.side/2)) {
      //Touching top of hero
      if (y - DIAMETER <= block.down && y >= block.down) {
        y = block.down + DIAMETER;
      }

      //Touching bottom of hero
      if (y + DIAMETER >= block.up && y <= block.up) {
        y = block.up - DIAMETER;
      }
    }

    //Check horizontal collision
    if (abs(y - (block.y + block.side/2)) < (RADIUS + block.side/2)) {
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
    Bullet b = new Bullet(x + RADIUS, y + RADIUS, BULLET_SPEED*cos(t), BULLET_SPEED*-sin(t));
    if (bullets.size() < 5) {
      bullets.add(b);
    }
  }
}

