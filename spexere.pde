//NICOLAS AGUIRRE MIDTERM
/* WORKS CITED
 
 FOR INPUT HANDLING: http://processing.org/discourse/beta/num_1139256015.html
 AUDIO LASER SOUND : http://soundjax.com
 SWEPT AABB        : http://www.gamedev.net/page/resources/_/technical/
                     game-programming/swept-aabb-collision-detection-and-response-r3084
 GRASS TILE        : USER SURFACECURVE FROM OPENGAMEART
                     http://opengameart.org/content/grass-textureseamless-2d
 
 */ 
import ddf.minim.*;  // For audio playback
Minim minim;
AudioPlayer ap;

boolean game; // Game state: False means game-over

PImage grass; // Background tile

// Basic actors/objects
Hero hero;
Enemy enemy;
Bullet bullet;
Block block;

// ArrayLists
ArrayList<Enemy> enemies;
ArrayList<Block> blocks;
ArrayList<Explosion> explosions = new ArrayList<Explosion>();

// For handling level-changing
final int TILE = 40; // Pixels per tile unit
final int NUM_LEVELS = 5;
int currentLevel;
XML[] maps = new XML [NUM_LEVELS];

int goalX, goalY;
final int GOALSIZE = 30;

boolean keys[]; // For handling input



// ----------- SETUP ---------------------------------
void setup () {
  //Load audio playback
  minim = new Minim(this);
  ap = minim.loadFile("laser.wav"); // Got this from soundJax
  
  //Load background image
  grass = loadImage("grass.png");

  //Set up display
  size(800, 600); // Each map is 20 x 15 tiles
  background(50, 150, 50);
  smooth();

  // Set game state
  game = true;

  // Set up input handler
  keys = new boolean[4]; //Holds four keys

  // Load maps
  maps[0] = loadXML("map0.xml");
  maps[1] = loadXML("map1.xml");
  maps[2] = loadXML("map2.xml");
  maps[3] = loadXML("map3.xml");
  maps[4] = loadXML("map4.xml");

  // Load first level
  currentLevel = 0;
  loadLevel(currentLevel);
}

// ----------- DRAW ---------------------------------

void draw () {
  if (game) {
    //background(50, 150, 50);
    rectMode(CORNER);
    stroke(200);
    fill(0);

    handleInput();
    checkCollision();
    update();
    display();
    
  } else {
    rectMode(CENTER);
    fill(80);
    stroke(#FAE119);
    rect(width/2, height/2, TILE*12, TILE*8);
    fill(#FAE119);
    textAlign(CENTER);
    textSize(32);
    text("YOU FUCKING DIED", width/2, height/2);
    textSize(24);
    text("Press the space bar to reset, stupid.", width/2, height/2 + TILE);
    textSize(10);
    text("You are bad at video games.", width/2, height/2 + TILE*2);
  }
}


//  ----------- INPUT HANDLING ---------------------------------
void handleInput() {
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

  // To reset the game
  if (!game) {
    switch (key) {
    case ' ':
      setup();
      break;
    }
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
  hero.update();

  // Update each enemy
  for (int i = 0; i < enemies.size (); i++) {
    enemies.get(i).update();
  }
}
// ---------- DISPLAY METHOD ---------------------------------
void display() {
  //Display grass
  for (int column = 0; column < width; column += TILE) {
    for (int row = 0; row < height; row += TILE) {
      image(grass, column, row);  
    }
  }

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

  //Display hero
  hero.display();

  //Display any explosions
  for (int i = 0; i < explosions.size (); i++) {
    Explosion exp = explosions.get(i);
    exp.plus();
    exp.display();
    if (exp.finished()) {
      explosions.remove(i);
    }
  }

  //Display goal
  fill(frameCount * 5 % 255, frameCount * 3 % 255, frameCount * 7 % 255);
  ellipse (goalX, goalY, GOALSIZE, GOALSIZE);
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

        // Create an explosion
        Explosion explosion = new Explosion(enemy.x, enemy.y);
        explosions.add(explosion);

        // Remove enemy and bullet from arraylist
        if (enemies.size() > 0) {
          enemies.remove(j);
        }
        if (hero.bullets.size() > 0) {
          hero.bullets.remove(i);
        }
      }
    }
  }

  // Check enemy-player collision
  for (int i = 0; i < enemies.size (); i++) {
    enemy = enemies.get(i);
    if (dist(hero.x + hero.w/2, hero.y + hero.h/2, enemy.x + DIAMETER/2, enemy.y + DIAMETER/2) < hero.w/2 + enemy.DIAMETER/2) {
      game = false;
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

        if (ct < 1.0f) {
          hero.x += hero.vx * ct;
          hero.y += hero.vy * ct;
          hero.slide(ct);
        }
        i = 9999;
      }
    }
  }

  // Check if player finished goal
  if (frameCount % 2 == 0) {
    if (dist (hero.x + hero.w/2, hero.y + hero.h/2, goalX, goalY) < GOALSIZE) {
      endLevel();
    }
  }
}

// ----- LEVEL MANAGEMENT -------------------------
void loadLevel(int levelNum) {
  XML map = maps[levelNum];
  XML[] rows = map.getChildren("row");

  // Initialize block array
  blocks = new ArrayList<Block>();
  enemies = new ArrayList<Enemy>();

  // Iterate through XML map
  for (int row = 0; row < rows.length; row++) {
    String s = rows[row].getContent();
    for (int column = 0; column < s.length (); column++) {
      if (s.charAt(column) == '@') {
        // Make a block
        block = new Block (column*TILE, row*TILE, TILE); 
        blocks.add(block);
      }

      if (s.charAt(column) == 's') {
        // Spawn hero  
        hero = new Hero(1, column*TILE, row*TILE);
      }

      if (s.charAt(column) == 'e') {
        // Spawn enemy
        Enemy enemy = new Enemy (1, column*TILE, row*TILE);
        enemies.add(enemy);
      }

      if (s.charAt(column) == 'g') {
        // Set goal-point
        goalX = column*TILE;
        goalY = row*TILE;
      }
    }
  }
}

void endLevel () {
  if (currentLevel < NUM_LEVELS-1) {
    currentLevel++;
    loadLevel(currentLevel);
  } else {
    currentLevel = 0;
    loadLevel(currentLevel);
  }
}

