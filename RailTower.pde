class RailTower extends Tower {
  RailTower(float xpos, float ypos) {
    super(xpos,ypos);
    reloadTime = 350; /// We can change this later
    range = 500;
    type = "Railgun Tower";
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
              railmissiles.add(new RailMissile(int(pos.x), int(pos.y), int(pos.x+(mX-pos.x)*50), int(pos.y-(pos.y-mY)*50)));
              reloadCounter = reloadTime;              
            }
          }
        }
      }
    }
  }
}

