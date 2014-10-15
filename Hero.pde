class Hero extends Entity {
  final int DIAMETER = 40;
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

  void display() {
    fill (255);
    ellipse(x, y, DIAMETER, DIAMETER);

    for (int i = 0; i < bullets.size (); i++) {
      bullets.get(i).display();
    }
  }

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

  //Handle Collision with blocks
  void checkCollisionWith (Block block) {
    //Touching top of hero
    if (y - DIAMETER/2 <= block.down && y >= block.y + block.side) {
      y = block.down + DIAMETER/2;
    }

    //Touching bottom of hero
    if (y + DIAMETER/2 >= block.up && y <= block.y) {
      y = block.up - DIAMETER/2;
    }

    //Touching left of hero
    if (x - DIAMETER/2 <= block.right && x >= block.x + block.side) {
      x = block.right + DIAMETER/2;
    }

    //Touching right of hero
    if (x + DIAMETER/2 >= block.left && x <= block.x) {
      x = block.left - DIAMETER/2;
    }
  }

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

