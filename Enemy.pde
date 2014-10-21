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

