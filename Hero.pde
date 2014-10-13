class Hero extends Entity {
  final int DIAMETER = 40;
  final float BULLET_SPEED = 8;
  ArrayList<Bullet> bullets;
  boolean hit; // Stays true for about one second

  Hero (int hp, float x, float y, float moveSpeed) {
    super (hp, x, y, moveSpeed);
    bullets = new ArrayList<Bullet>();
  }

  void display() {
    fill (255);
    ellipse(x, y, DIAMETER, DIAMETER);

    for (int i = 0; i < bullets.size (); i++) {
      bullets.get(i).display();
    }
  }

  void update() {
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

