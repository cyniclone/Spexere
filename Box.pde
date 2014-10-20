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

