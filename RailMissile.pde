class RailMissile {
  PVector pos;
  PVector endpos;
  int s;      // speed 
  color c;
  float r;  // rotation (radians, 0 is facing right)

  RailMissile(int xPos, int yPos, int endX, int endY) {    // creates a missile that fires at the desired point at the desired speed
    pos = new PVector(xPos, yPos);
    endpos = new PVector(endX,endY);
    c = color(0);   
  }

  void draw() {
    strokeWeight(1);
    stroke(0);
    line(pos.x,pos.y,endpos.x,endpos.y);
  }

}

