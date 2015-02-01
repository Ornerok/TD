class Tower {
  final PVector pos;
  String type;
  int radius, reloadCounter, reloadTime, range, opacity;  // r is rotation (radians, 0 is facing right)
  boolean selected;
  color fillA, fillB, fillC;
  float r;        // r is rotation (radians, 0 is facing right)

  Tower(float xpos, float ypos) {
    pos = new PVector(xpos, ypos);
    radius = 20;
    fillA = color(150);
    fillB = color(50);
    fillC = color(10);
    opacity = 255;
    selected = false;
    reloadTime = 75; /// We can change this later
    reloadCounter = reloadTime - 40;
    range = 250;
    r = 0;
    type = "Basic Tower";
  }

  void update() {
    if (gameRunning && reloadCounter > 0) {
      reloadCounter--;
    }
    for (int i = 0; i<mobs.size(); i++) {          /// fires missiles. The nested if statements help it run faster
      int mX = int(mobs.get(i).pos.x);
      int mY = int(mobs.get(i).pos.y);
      if (abs(mX - pos.x)<range) {
        if (abs(mY - pos.y)<range) {
          if (dist(pos.x, pos.y, mX, mY) < range) {
            if (reloadCounter == 0) {
              int bulletSpeed = 10;
              PVector mobSpeed = mobs.get(i).dir;  
              float t1 = dist(pos.x, pos.y, mX, mY)/bulletSpeed;
              PVector p1 = new PVector(mX + t1 * mobSpeed.x, mY + t1 * mobSpeed.y);
              float t2 = dist(pos.x, pos.y, p1.x, p1.y)/bulletSpeed;
              PVector p2 = new PVector(mX + t2 * mobSpeed.x, mY + t2 * mobSpeed.y);

              turnTo(int(p2.x), int(p2.y));
              missiles.add(new Missile(int(pos.x), int(pos.y), bulletSpeed, int(p2.x), int(p2.y)));
              reloadCounter = reloadTime;
            }
          }
        }
      }
    }
  }

  void draw() {
    ellipseMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    opacity = 255;

    if (gameMode == "Placing Tower") {
      opacity = 100;
    }

    fill(fillA, opacity);
    stroke(0);
    strokeWeight(1);
    ellipse (0, 0, radius*2, radius*2);
    noStroke();
    rotate(-r);
    rectMode(CORNERS);
    fill(fillB, opacity);

    int barrelLength = int(radius * 1.7);
    if (reloadCounter * 1.25 >= reloadTime) {
      barrelLength = int(radius + radius * 0.7 * (((reloadCounter * 1.25) - reloadTime)/(reloadTime * 0.25)));
    }
    else if (reloadCounter>0) {
      barrelLength = int(radius * 1.7 - radius * 0.7 * (reloadCounter/(reloadTime * 0.8)));
    }

    rect(0, 5, barrelLength, -5);

    fill(fillC, opacity);
    ellipse(0, 0, radius * 1.2, radius * 1.2);
    popMatrix();
  }

  void turnTo(int a, int b) {
    int x = a - int(pos.x);
    int y = int(pos.y) - b;

    if (x > 0 && y > 0) {
      r = atan((float)abs(y)/abs(x));
    }
    else if (x<0 && y>0) {
      r = PI - atan((float)abs(y)/abs(x));
    }
    else if (x<0 && y<0) {
      r = PI + atan((float)abs(y)/abs(x));
      ;
    }
    else if (x>0 && y<0) {
      r = TWO_PI - atan((float)abs(y)/abs(x));
    }
  }
}

