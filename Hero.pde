/*
   Collision detection using SweptAABB tutorial from 
 gamedev.net
 http://bit.ly/1wdxc7v
 */

class Hero extends Entity {
  PImage heroImg;

  final int DIAMETER = TILE;
  final int RADIUS = DIAMETER/2;
  float w = DIAMETER;
  float h = DIAMETER;
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

    heroImg = loadImage("hero.png");
  }

  // ---------- DISPLAY METHOD ---------------------------------
  void display() {
    // Shadow beneath sprite
    fill (60, 60, 60, 100);
    noStroke();
    ellipse(x + RADIUS, y + 30, 35, 20);

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
    Bullet b = new Bullet(x + RADIUS, y + RADIUS, BULLET_SPEED*cos(t), BULLET_SPEED*-sin(t));
    if (bullets.size() < 5) {
      bullets.add(b);
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

    //    println();
    //    println("xInvEntry and Exit: " + xInvEntry + ", " + xInvExit);
    //    println("yInvEntry and Exit: " + yInvEntry + ", " + yInvExit);

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

      println("Collision time: " + entryTime);
      return entryTime;
    }
  }

  // ----- RESOLVING COLLISION -----
  void slide (float collisionTime) {
    println("my normals are " + normalx + ", " + normaly);
    float dotprod = (vx * normaly + vy * normalx) * (1.0f - collisionTime);
    vx = dotprod * normaly;
    vy = dotprod * normalx;
    println("new vx, vy: " + vx + ", " + vy);
  }
}

