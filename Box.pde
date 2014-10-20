// For broad-phase collision
// describes an axis-aligned rectangle with a velocity
class Box
{
  Box(float _x, float _y, float _w, float _h, float _vx, float _vy)
  {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    vx = _vx;
    vy = _vy;
  }

  Box(float _x, float _y, float _w, float _h)
  {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    vx = 0.0f;
    vy = 0.0f;
  }

  // position of top-left corner
  float x, y;

  // dimensions
  float w, h;

  // velocity
  float vx, vy;
}

// Making this method global but keeping it in "Box" tab

Box getBroadphaseBox(Hero b)
{
    Box broadphasebox;
    broadphasebox.x = b.vx > 0 ? b.x : b.x + b.vx;
    broadphasebox.y = b.vy > 0 ? b.y : b.y + b.vy;
    broadphasebox.w = b.vx > 0 ? b.vx + b.w : b.w - b.vx;
    broadphasebox.h = b.vy > 0 ? b.vy + b.h : b.h - b.vy;

    return broadphasebox;
}
