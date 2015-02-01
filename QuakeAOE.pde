class QuakeAOE {
  PVector pos;
  PVector endpos;
  int wh;      // speed 
  color c;

  QuakeAOE(int xPos, int yPos, int size) {    // creates a missile that fires at the desired point at the desired speed
    pos = new PVector(xPos, yPos);
    wh = size;
    c = color(0);   
  }

  void draw() {
    strokeWeight(1);
    stroke(0);
    ellipseMode(RADIUS);
    ellipse(pos.x, pos.y, wh, wh);
  }

}

