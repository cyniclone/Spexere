//NICOLAS AGUIRRE MIDTERM
/* WORKS CITED
 
 FOR INPUT HANDLING: http://processing.org/discourse/beta/num_1139256015.html
 
 */

Entity hero;
boolean keys[]; // For handling input

void setup () {
  //Set up display
  size(800, 600);
  background(50, 150, 50);
  noStroke();

  //Set up input handler
  keys = new boolean[4]; //

  //Make hero
  hero = new Entity(10, 200, 200, 3.5, 0, 220);
}

void draw () {
  background(50, 150, 50);
  // Handle Input
  handleInput();
  // Check Collission

  // Update
  bullet.update();
  //hero.update();

  // Render
  hero.display();
}


//  INPUT HANDLING -------------------------------------------
void handleInput() {
  // For our array:
  // keys[0] = UP, [1] = DOWN, [2] = LEFT, and [3] = RIGHT

  if (keys[0]) {
    hero.y -= hero.moveSpeed;
  }
  if (keys[1]) {
    hero.y += hero.moveSpeed;
  }
  if (keys[2]) {
    hero.x -= hero.moveSpeed;
  }
  if (keys[3]) {
    hero.x += hero.moveSpeed;
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

//Check if a bullet was shot
void mousePressed() {
  // First we get the angle t (theta)
  // Tangent == opposite/adjacent to get angle
  float dx = mouseX - hero.x; //Base of a right triangle
  float dy = hero.y - mouseY; //Height of a right triangle
  
  println(dx + ", " + dy);
  if (dx >= 1) { 
    hero.t = (degrees(atan(dy/dx)));
  } else {
    hero.t = (180 + degrees(atan(dy/dx)));
  } 
  println("angle is " + hero.t);
  
  // xSpeed and ySpeed determined by cos and sin respectively
  Bullet b = new Bullet(hero.x, hero.y, 
}

// ------------------------------------------------------------

class Bullet {
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
    fill(255, 40, 40);
    rect(x, y, 10, 10);
  }
}

class Entity {
  int hp;    // Hit points
  float x, y; // X and Y position of entity
  float moveSpeed;
  float t; // Angle (theta) between cursor and entity
  color c;


  //Constructor
  Entity (int hp, float x, float y, float moveSpeed, float t, color c) {
    this.hp = hp;
    this.x = x;
    this.y = y;
    this.moveSpeed = moveSpeed;
    this.t = t;
    this.c = c;
  }
  
  void display() {
      fill(c);
      ellipse (x, y, 20, 20);
  }
  
  void shoot (float t) {
    //Make a new bullet
    
  } 
}


