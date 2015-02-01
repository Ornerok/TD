class QuakeTower extends Tower {
  QuakeTower(float xpos, float ypos) {
    super(xpos, ypos);
    reloadTime=150;
    range = 43;
    type = "Quake Tower";
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
            if (frameRate%20 == 0) {
              turnTo(mX, mY);
            }
            if (reloadCounter == 0) {
              turnTo(mX, mY);
              quakeaoes.add(new QuakeAOE(int(pos.x), int(pos.y), 60));
              reloadCounter = reloadTime;
            }
          }
        }
      }
    }
  }

  void draw() {
    noStroke();
    ellipseMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    opacity = 255;

    if (gameMode == "Placing Tower") {
      opacity = 100;
    }
    if (selected) {
      strokeWeight(5);
      stroke(255, 0, 0);
    }

    fill(fillA, opacity);
    ellipse (0, 0, radius*2, radius*2);
    noStroke();
    rotate(-r);
    rectMode(CORNERS);
    fill(fillB, opacity);
    ellipse(0, 0, radius * 1.2, radius * 1.2);
    popMatrix();
  }
}

