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

