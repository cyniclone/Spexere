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
  hero = new Hero(10, 200, 200);

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


  // Render
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
  float t = 0; // For timestepping
  float dt = 1;

  //Update hero
  while (t <= 10) {
    hero.update();
    checkCollision();
    
    // Update each enemy
    for (int i = 0; i < enemies.size (); i++) {
      enemies.get(i).update();
    }
    
    t += dt;
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

    //Each block is only a candidate for collision if it's within 50 pixels of our hero
    //if (dist(hero.x + hero.w/2, hero.y + hero.h/2, block.x + block.w/2, block.y + block.h/2) < 100) {
     if (hero.checkAABB (hero, block)) {
      // Check collision

      println(hero.sweptAABB(hero, block));
    }
  }
}

