/* @pjs preload="block.png, grass.png, hero.png"; 
 */

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

 /* CITATION 
 CC - SPRITE ASSET
 DESIGN BY MARTA NOWACZYK OF
 www.ifu.deviantart.com.
 opengameart.org
 */

class Block {
  PImage img;
  float x, y;
  float w, h;
  float side; // Side length
  float left, right, up, down;
  

  Block (float x, float y, int side) {
    img = loadImage("block.png");
    
    this.x = x;
    this.y = y;
    this.side = side;
    w = side;
    h = side;

    this.left = x;
    this.right = x + side;
    this.up = y;
    this.down = y + side;
  }
// ---------- DISPLAY METHOD ---------------------------------
  void display () {
    //rectMode(CORNER);
    //fill(0, 0, 255, 200);
    //stroke(255);
    //rect(x, y, side, side);
    
    imageMode(CORNER);
    image(img, x, y, side, side);
  }
}

// For broad-phase collision
// Making this method global but keeping it in "Box" tab

Hero getBroadphaseBox(Hero b)
{
  Hero broadphasebox = new Hero(1, 0, 0);
  broadphasebox.x = b.vx > 0 ? b.x : b.x + b.vx;
  broadphasebox.y = b.vy > 0 ? b.y : b.y + b.vy;
  broadphasebox.w = b.vx > 0 ? b.vx + b.w : b.w - b.vx;
  broadphasebox.h = b.vy > 0 ? b.vy + b.h : b.h - b.vy;

  return broadphasebox;
}

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

  // ---------- DISPLAY METHOD ---------------------------------
  void display() {
    rectMode(CENTER);
    fill(random(100, 255), random(200, 255), random(100, 255));

    rect(x, y, DIAMETER, DIAMETER);
  }

  // ---------- UPDATE VARIABLES AND POSITION --------------------
  void update() {
    x += xSpeed;
    y += ySpeed;
  }
}

// CITATIONS
/*
  Week 4 - Wander.pde
 Ternary Operator - http://www.processing.org/reference/conditional.html
 */
 
 /* CC - SPRITE ASSET
 DESIGN BY RYAN MOCHAL
 http://thenounproject.com/term/bat/77722/
 */

class Enemy extends Entity {
  PShape bat;
  color c;
  
  final int DIAMETER = 50;
  final float MOVESPEED = 2.0f;
  
  float wanderX = random(-1.5, 1.5);
  float wanderY = random(-1.5, 1.5);

  Enemy (int hp, float x, float y) {
    super (hp, x, y);
    bat = loadShape("bat.svg");
    bat.disableStyle();
    
    c = color(random(200), random(100), random(100, 200));
  }
  
// ---------- DISPLAY METHOD ---------------------------------
  void display () {
    fill (c);
    shapeMode(CENTER);
    shape(bat, x, y, DIAMETER, DIAMETER);
  }
  
// ---------- UPDATE VARIABLES AND POSITION --------------------
  void update () {
    wander();
  }

  void wander () {
    x += wanderX * MOVESPEED;
    y += wanderY * MOVESPEED;

    // Check bounds - Use ternary operators for conciseness
    wanderX = (x <= 0) ? 1 : wanderX;
    wanderX = (x >= width) ? -1 : wanderX;
    wanderY = (y <= 0) ? 1 : wanderY;
    wanderY = (y >= height) ? -1 : wanderY;

    if (frameCount % 60 == 0) {
      wanderX = random(-2, 2);
      wanderY = random(-2, 2);
    }
  }
}

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
/*
   Collision detection using SweptAABB tutorial from 
 gamedev.net
 http://bit.ly/1wdxc7v
 */

class Hero extends Entity {
  PImage heroImg;
  boolean playLaserWav = false;
  int count = 0;

  float w = TILE;
  float h = TILE;
  final float MOVESPEED = 3.9f;
  final float BULLET_SPEED = 8;

  ArrayList<Bullet> bullets; 

  boolean hit; // Stays when hit
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

    count=0;
    heroImg = loadImage("hero.png");
  }

  // ---------- DISPLAY METHOD ---------------------------------
  void display() {
    // Shadow beneath sprite
    fill (60, 60, 60, 100);
    noStroke();
    ellipse(x + w/2, y + 30, 35, 20);

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

    //Display light
    fill (255, frameCount * 11 % 255, frameCount * 11 % 255);
    ellipse(x + w/2, y + h/2, 5, 5);
  }

  // ---------- UPDATE VARIABLES AND POSITION --------------------
  void update() {

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

    // Play laser sound
    if (playLaserWav) {
      count++;
      ap.play();
      if (count > 10) {
        playLaserWav = false;
        count = 0;
        ap.rewind();
      }
    }
  }

  void updatePosition () {
    x += vx;
    y += vy;
  }

  // ---------- SHOOT BULLETS AND MANAGE BULLET ARRAYLIST --------------------
  void shoot(float t) {
    // Make new bullet and add to arraylist
    // Use rCos(theta) = x and rSin(theta) = y
    // To convert from polar to Cartesian

    //float d = dist(x, y, mouseX, mouseY)*.01;
    Bullet b = new Bullet(x + w/2, y + h/2, BULLET_SPEED*cos(t), BULLET_SPEED*-sin(t));
    if (bullets.size() < 5) {
      bullets.add(b);
    }

    if (count == 0) {
      playLaserWav = true;
    }
  }

  // ---------- HANDLE BLOCK COLLISION ------------------------------
  // USING AXIS-ALIGNED BOUNDING BOX ALGORITHM
  // From gamedev.net
  // http://bit.ly/1wdxc7v
  float normalx = 0;
  float normaly = 0;

  // ----- DETECTION -----
  // Check if collision happened
  boolean checkAABB (Hero b1, Block b2)
  {
    return !(b1.x + b1.w < b2.x || b1.x > b2.x + b2.w || b1.y + b1.h < b2.y || b1.y > b2.y + b2.h);
  }

  // Returns time that collision occurred 
  float sweptAABB (Hero b1, Block b2) {
    float xInvEntry, yInvEntry;
    float xInvExit, yInvExit;

    // find the distance between the objects on the near and far sides for both x and y
    if (b1.vx > 0.0f)
    {
      xInvEntry = b2.x - (b1.x + b1.w);
      xInvExit = (b2.x + b2.w) - b1.x;
    } else
    {
      xInvEntry = (b2.x + b2.w) - b1.x;
      xInvExit = b2.x - (b1.x + b1.w);
    }

    if (b1.vy > 0.0f)
    {
      yInvEntry = b2.y - (b1.y + b1.h);
      yInvExit = (b2.y + b2.h) - b1.y;
    } else
    {
      yInvEntry = (b2.y + b2.h) - b1.y;
      yInvExit = b2.y - (b1.y + b1.h);
    }

    // find time of collision and time of exit for each axis 
    // (if statement is to prevent divide by zero)
    float xEntry, yEntry;
    float xExit, yExit;



    if (b1.vx == 0.0f)
    {
      xEntry = tan(HALF_PI); //Negative infinity
      xExit = -tan(HALF_PI); //Positive infinity
    } else
    {
      xEntry = xInvEntry / b1.vx;
      xExit = xInvExit / b1.vx;
    }

    if (b1.vy == 0.0f)
    {
      yEntry = tan(HALF_PI); //Negative infinity
      yExit = -tan(HALF_PI); //Positive infinity
    } else
    {
      yEntry = yInvEntry / b1.vy;
      yExit = yInvExit / b1.vy;
    }

    //    println("xEntry and Exit: " + xEntry + ", " + xExit);
    //    println("yEntry and Exit: " + yEntry + ", " + yExit);
    //
    //    if (xEntry > 1.0f) xEntry = tan(HALF_PI);
    //    if (yEntry > 1.0f) yEntry = tan(HALF_PI);

    // find the earliest/latest times of collision
    float entryTime = max(xEntry, yEntry);
    float exitTime = min(xExit, yExit);

    //    println("Entry and Exit times: " + entryTime + ", " + exitTime);


    // if there was no collision
    if (entryTime > exitTime || xEntry < 0.0f && yEntry < 0.0f || xEntry > 1.0f || yEntry > 1.0f)
    {
      normalx = 0.0f;
      normaly = 0.0f;
      return 1.0f;
    } else // if there was a collision
    {
      // calculate normal of collided surface
      if (xEntry > yEntry)
      {
        if (xInvEntry < 0.0f)
        {
          normalx = 1.0f;
          normaly = 0.0f;
        } else
        {
          normalx = -1.0f;
          normaly = 0.0f;
        }
      } else
      {
        if (yInvEntry < 0.0f)
        {
          normalx = 0.0f;
          normaly = 1.0f;
        } else
        {
          normalx = 0.0f;
          normaly = -1.0f;
        }
      }


//      println("xInvEntry and Exit: " + xInvEntry + ", " + xInvExit);
//      println("yInvEntry and Exit: " + yInvEntry + ", " + yInvExit);
//      println("Collision time: " + entryTime);
      return entryTime;
    }
  }

  // ----- RESOLVING COLLISION -----
  void slide (float collisionTime) {

//    println("my normals are " + normalx + ", " + normaly);
    float dotprod = (vx * normaly + vy * normalx) * (1.0f - collisionTime);
    vx = dotprod * normaly;
    vy = dotprod * normalx;
//    println("new vx, vy: " + vx + ", " + vy);
  }
}

abstract class Entity {
  int hp;    // Hit points
  float x, y; // X and Y position of entity

  //Constructor
  Entity (int hp, float x, float y) {
    this.hp = hp;
    this.x = x;
    this.y = y;
  }
}


