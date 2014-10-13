abstract class Entity {
  int hp;    // Hit points
  float x, y; // X and Y position of entity
  float moveSpeed;

  //Constructor
  Entity (int hp, float x, float y, float moveSpeed) {
    this.hp = hp;
    this.x = x;
    this.y = y;
    this.moveSpeed = moveSpeed;
  }
}

