//NICOLAS AGUIRRE MIDTERM
/* WORKS CITED
 
 FOR INPUT HANDLING: http://processing.org/discourse/beta/num_1139256015.html
 
 */


Hero hero;
Enemy enemy;
Bullet bullet;
Block block;
ArrayList<Enemy> enemies;
ArrayList<Block> blocks;

boolean keys[]; // For handling input


// ----------- SETUP ---------------------------------
void setup () {
  //Set up display
  size(800, 600);
  background(50, 150, 50);
  smooth();

  //Set up input handler
  keys = new boolean[4]; //Holds four keys

  //Make hero
  hero = new Hero(10, 200, 200);

  //Make some enemies
  enemies = new ArrayList<Enemy>();
  for (int i = 1; i <= 5; i++) {
    enemy = new Enemy(5, 500, i*100 + random(0, 200));
    enemies.add(enemy);
  }

  // Initialize blocks
  blocks = new ArrayList<Block>();

  //Make some blocks 
  for (int i = 0; i < 3; i++) {
    block = new Block((int) (i+5)*40, (int) 8*40, 40);
    blocks.add(block);
  }
}

// ----------- DRAW ---------------------------------

void draw () {
  background(50, 150, 50);
  rectMode(CORNER);

  stroke(200);
  fill(0);

  // Make some blocks
  //  if (frameCount % 60 == 0) {
  //
  //    block = new Block((int) random(0, width/40)*40, (int) random(0, height/40)*40, 40);
  //    blocks.add(block);
  //    // Every three seconds make a block
  //  }

  // Handle Input
  handleInput();

  // Update variables
  update();

  // Check Collision
  checkCollision();

  // Render
  display();
}


//  ----------- INPUT HANDLING ---------------------------------
void handleInput() {
  // For our array:
  // keys[0] = UP, [1] = DOWN, [2] = LEFT, and [3] = RIGHT

  if (keys[0]) {
    hero.yDir = -1;
  }
  if (keys[1]) {
    hero.yDir = 1;
  }
  if (!keys[0] && !keys[1]) { 
    hero.yDir = 0;
  }
  if (keys[2]) {
    hero.xDir = -1;
  }
  if (keys[3]) {
    hero.xDir = 1;
  }
  if (!keys[2] && !keys[3]) {
    hero.xDir = 0;
  }
}
void keyPressed() {
  switch (keyCode) {
  case UP:
    keys[0] = true;
    break;
  case DOWN:
    keys[1] = true;
    break;
  case LEFT:
    keys[2] = true;
    break;
  case RIGHT:
    keys[3] = true;
    break;
  }
}
void keyReleased() {
  switch (keyCode) {
  case UP:
    keys[0] = false;
    break;
  case DOWN:
    keys[1] = false;
    break;
  case LEFT:
    keys[2] = false;
    break;
  case RIGHT:
    keys[3] = false;
    break;
  }
}
void mousePressed() {
  // First we get the angle t (theta)
  // Tangent == opposite/adjacent to get angle
  float dx = mouseX - hero.x; //Base of right triangle
  float dy = hero.y - mouseY; //Height of right triangle
  float t = 0;

  if (dx >= 0) { 
    t = (atan(dy/dx));
  } else {
    t = (PI + atan(dy/dx));
  } 

  hero.shoot(t);

}

// ----------- GAME LOOP METHODS ----------------------------

void update() {
  //Update hero
  hero.update();

  // Update each enemy
  for (int i = 0; i < enemies.size (); i++) {
    enemies.get(i).update();
  }
}

void display() {
  hero.display();
  //Display each enemy
  for (int i = 0; i < enemies.size (); i++) {
    enemies.get(i).display();
  }

  //Display blocks
  for (int i = 0; i < blocks.size (); i++) {
    if (blocks.size() > 0) {
      blocks.get(i).display();
    }
  }
}

void checkCollision() {

  // Check enemy-bullet collision
  for (int i = 0; i < hero.bullets.size (); i++) {
    bullet = hero.bullets.get(i);

    for (int j = 0; j < enemies.size (); j++) {
      enemy = enemies.get(j);

      if (dist(bullet.x, bullet.y, enemy.x, enemy.y) < bullet.DIAMETER/2 + enemy.DIAMETER/2)
      {

        //remove enemy from arraylist
        if (enemies.size() > 0) {
          enemies.remove(j);
        }
        if (hero.bullets.size() > 0) {
          hero.bullets.remove(i);
        }

        // add a new enemy
        enemy = new Enemy(5, 500, 300 + random(0, 200));
        enemies.add(enemy);
      }
    }
  }

  // Check enemy-player collision
  for (int i = 0; i < enemies.size (); i++) {
    enemy = enemies.get(i);
    if (dist(hero.x, hero.y, enemy.x, enemy.y) < hero.DIAMETER/2 + enemy.DIAMETER/2) {
      println("player hit");
    }
  }

  // Check player-block collision
  for (int i = 0; i < blocks.size (); i++) {
    hero.checkCollisionWith(blocks.get(i));
  }
}

