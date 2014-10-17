/*
   Collision detection using SweptAABB tutorial from 
 gamedev.net
 http://bit.ly/1wdxc7v
 */

class Hero extends Entity {
  PImage heroImg;

  final int DIAMETER = TILE;
  final int RADIUS = DIAMETER/2;
  final int w = DIAMETER;
  final int h = DIAMETER;
  final float MOVESPEED = 0.4f;

  final float BULLET_SPEED = 0.8f;
  ArrayList<Bullet> bullets; 

  boolean hit; // Stays true for about one second
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
    updateVelocity();
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

  void updateVelocity() {
    vx = dx * MOVESPEED;
    vy = dy * MOVESPEED;
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
//    println("hero " + b1.x + ", " + b1.y + " velocity " + b1.vx + ", " + b1.vy + " w/h: " + b1.w + ", " + b1.h);
    //println("bloc " + b2.x + ", " + b2.y + " w/h: " + b2.w + ", " + b2.h);

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
<<<<<<< HEAD

//    if (abs (xInvEntry) < 1 || abs (xInvExit) < 1 || abs (yInvEntry) < 1 || abs (yInvExit) < 1) {
//      if (! (xInvEntry == 0 && xInvExit ==0)) {
//        if (! (yInvEntry == 0 && yInvExit == 0)) {
//          println("xInvEntry and Exit: " + xInvEntry + ", " + xInvExit);
//          println("yInvEntry and Exit: " + yInvEntry + ", " + yInvExit);
//        }
//      }
//    }
=======
>>>>>>> parent of 70a2bed... logging more variables for debug

    // find time of collision and time of exit for each axis 
    // (if statement is to prevent divide by zero)
    float xEntry, yEntry;
    float xExit, yExit;

    if (b1.vx == 0.0f)
    {
      xEntry = -tan(HALF_PI); // Negative infinity
      xExit = tan(HALF_PI); // Positive infinity
    } else
    {
      xEntry = xInvEntry / b1.vx;
      xExit = xInvExit / b1.vx;
    }

    if (b1.vy == 0.0f)
    {
      yEntry = -tan(HALF_PI);
      yExit = tan(HALF_PI);
    } else
    {
      yEntry = yInvEntry / b1.vy / 10;
      yExit = yInvExit / b1.vy / 10;
    }
<<<<<<< HEAD

//    if (abs (xEntry) < 1 || abs (yEntry) < 1) {
//      println("xEntry and Exit: " + xEntry + ", " + xExit);
//      println("yEntry and Exit: " + yEntry + ", " + yExit);
//    }
=======
>>>>>>> parent of 70a2bed... logging more variables for debug

    // find the earliest/latest times of collision
    float entryTime = max(xEntry, yEntry);
    float exitTime = min(xExit, yExit);
<<<<<<< HEAD

//    if (abs (entryTime) < 1 || abs (exitTime) < 1) {
//      println("Entry and Exit times: " + entryTime + ", " + exitTime);
//    }
=======
>>>>>>> parent of 70a2bed... logging more variables for debug

    // if there was no collision
    if (entryTime > exitTime || xEntry < 0.0f && yEntry < 0.0f || xEntry > 1.0f || yEntry > 1.0f)
    {
      println("entry time: " + entryTime + ", exit time: " + exitTime);
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

      // return the time of collision
      println(entryTime);
      return entryTime;
    }
  }

  // ----- RESOLVING COLLISION -----
<<<<<<< HEAD
  //  void slide (float collisionTime) {
  //    float dotprod = (vx * normaly + vy * normalx) * (1.0f - collisionTime);
  //    vx = dotprod * normaly;
  //    vy = dotprod * normalx;
  //  }
=======
  void slide (float collisionTime) {
    float dotprod = (vx * normaly + vy * normalx) * (1.0f - collisionTime);
    vx = dotprod * normaly;
    vy = dotprod * normalx;
  }
>>>>>>> parent of 70a2bed... logging more variables for debug

  // Sliding along wall
}

