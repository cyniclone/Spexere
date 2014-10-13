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
  
  final int DIAMETER = 50;
  float wanderX = random(-2, 2);
  float wanderY = random(-2, 2);


  Enemy (int hp, float x, float y, float moveSpeed) {
    super (hp, x, y, moveSpeed);
    bat = loadShape("bat.svg");
    bat.disableStyle();
  }

  void display () {
    fill (150, 40, 40);
    shapeMode(CENTER);
    shape(bat, x, y, DIAMETER, DIAMETER);
    //ellipse (x, y, DIAMETER, DIAMETER);
    
    
  }

  void update () {
    wander();
  }

  void wander () {
    x += wanderX;
    y += wanderY;

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

  void die () {
    
  }
}

