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
final int TILE = 40; // Pixels per tile unit

boolean keys[]; // For handling input


// Maps
XML map1;

// ----------- SETUP ---------------------------------
void setup () {

  //Set up display
  size(800, 600); // Each map is 20 x 15 tiles
  background(50, 150, 50);
  smooth();

  //Set up input handler
  keys = new boolean[4]; //Holds four keys

  //Make hero
  hero = new Hero(10, 79, 40);

  //Make some enemies
  enemies = new ArrayList<Enemy>();
  for (int i = 1; i <= 5; i++) {
    enemy = new Enemy(5, 500, i*100 + random(0, 200));
    enemies.add(enemy);
  }

  // Initialize blocks
  blocks = new ArrayList<Block>();

  // Load map and draw blocks
  map1 = loadXML("map1.xml");


  XML[] rows = map1.getChildren("row");
  for (int row = 0; row < rows.length; row++) {
    String s = rows[row].getContent();
    for (int column = 0; column < s.length (); column++) {
      if (s.charAt(column) == '@') {

        // Make a block
        block = new Block (column*TILE, row*TILE, TILE); 
        blocks.add(block);
      }
    }
  }
}

// ----------- DRAW ---------------------------------

void draw () {
  background(50, 150, 50);
  rectMode(CORNER);

  stroke(200);
  fill(0);

  handleInput();

  checkCollision();

  update();

  display();
}


//  ----------- INPUT HANDLING ---------------------------------
void handleInput() {
  // For our array:
  // keys[0] = UP, [1] = DOWN, [2] = LEFT, and [3] = RIGHT

  if (keys[0]) {
    hero.dy = -1;
  }
  if (keys[1]) {
    hero.dy = 1;
  }
  if (!keys[0] && !keys[1]) { 
    hero.dy = 0;
  }
  if (keys[2]) {
    hero.dx = -1;
  }
  if (keys[3]) {
    hero.dx = 1;
  }
  if (!keys[2] && !keys[3]) {
    hero.dx = 0;
  }

  // Set hero velocity
  hero.vx = hero.dx * hero.MOVESPEED;
  hero.vy = hero.dy * hero.MOVESPEED;
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
  float distX = mouseX - hero.x; //Base of right triangle
  float distY = hero.y - mouseY; //Height of right triangle
  float t = 0;

  t = atan(distY/distX);
  t = (distX <= 0) ? t + PI : t;

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
// ---------- DISPLAY METHOD ---------------------------------
void display() {
  hero.display();

  //Display blocks
  for (int i = 0; i < blocks.size (); i++) {
    if (blocks.size() > 0) {
      blocks.get(i).display();
    }
  }

  //Display each enemy
  for (int i = 0; i < enemies.size (); i++) {
    enemies.get(i).display();
  }
}
// ---------- CHECK COLLISION ---------------------------------
void checkCollision() {

  // Check enemy-bullet collision
  for (int i = 0; i < hero.bullets.size (); i++) {
    bullet = hero.bullets.get(i);

    for (int j = 0; j < enemies.size (); j++) {
      enemy = enemies.get(j);

      if (dist(bullet.x, bullet.y, enemy.x, enemy.y) < bullet.DIAMETER/2 + enemy.DIAMETER/2)
      {

        //remove enemy and bullet from arraylist
        if (enemies.size() > 0) {
          enemies.remove(j);
        }
        if (hero.bullets.size() > 0) {
          hero.bullets.remove(i);
        }

        // Add a new enemy
        enemy = new Enemy(5, 500, 300 + random(0, 200));
        enemies.add(enemy);
      }
    }
  }

  // Check enemy-player collision
  for (int i = 0; i < enemies.size (); i++) {
    enemy = enemies.get(i);
    if (dist(hero.x + hero.RADIUS, hero.y + hero.RADIUS, enemy.x, enemy.y) < hero.RADIUS + enemy.DIAMETER/2) {
      println("player hit");
    }
  }

  // Check player-block collision
  for (int i = 0; i < blocks.size (); i++) {
    block = blocks.get(i);

    // Only check blocks within 100 pixels
    if (dist(block.x + block.w/2, block.y + block.h/2, hero.x + hero.w/2, hero.y + hero.h/2) < 81) {


      Hero broadphasebox = getBroadphaseBox(hero);
      if (hero.checkAABB(broadphasebox, block)) {

        float ct = hero.sweptAABB(hero, block); // Collision time
        println("framecount " + frameCount);
        hero.x += hero.vx * ct;
        hero.y += hero.vy * ct;

        if (ct < 1.0f) {
          hero.slide(ct);
        }
        i = 9999;
      }
    }
  }
}

