class Block {
  float x, y;
  float side; // Side length
  float left, right, up, down;
  

  Block (float x, float y, int side) {
    this.x = x;
    this.y = y;
    this.side = side;

    this.left = x;
    this.right = x + side;
    this.up = y;
    this.down = y + side;
  }

  void display () {
    rectMode(CORNER);
    fill(0, 0, 255, 200);
    rect(x, y, side, side);
  }
}

