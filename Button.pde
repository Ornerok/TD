class Button {
  PVector pos, size;
  String type;
  boolean depressed;

  Button(int x, int y, int xsize, int ysize, String buttonType) {
    pos = new PVector(x, y);
    size = new PVector(xsize, ysize);
    type = buttonType;
    depressed = false;
  }

  Button() {
  }

  boolean mouseOverButton(int x, int y) {     
    if (abs(x-pos.x)<size.x/2 && abs(y-pos.y)<size.y/2) {
      return true;
    }
    return false;
  }

  void draw() {
    stroke(0);
    strokeWeight(1);
    rectMode(CENTER);
    textAlign(CENTER);
    textSize(20);
    fill(100, 100);
    if (type == "Place Tower") {
      if (!depressed) {
        rect(pos.x, pos.y, size.x, size.y);
        fill(255);
        text("Place Tower", pos.x, pos.y + 5);
      }
      else {
        fill(100);
        rect(pos.x, pos.y, size.x, size.y, 5);
        fill(255, 0, 0);
        text("Placing Tower", pos.x, pos.y + 5);
      }
    }
    else if (type == "Send Wave") {
      rect(pos.x, pos.y, size.x, size.y);
      fill(255);
      if (gameRunning == false && grid.inter.wave == 0) {
        text("Start Game", pos.x, pos.y + 7);
      }
      else {
        text("Send Next Wave", pos.x, pos.y + 7);
      }
    }
    else if (type == "Delete Tower") {
      rect(pos.x, pos.y, size.x, size.y);
      fill(255);
      if (gameMode == "Deleting Tower") {
        text(gameMode, pos.x, pos.y + 7);
      }
      else {
        text(type, pos.x, pos.y + 7);
      }
    }
    else if (type == "Rail Gun - 250" || type == "Quake - 200" || type == "Scatter - 100") {
      rect(pos.x, pos.y, size.x, size.y);
      fill(255);
      text(type, pos.x, pos.y + 7);
    }
    else {    
      fill(0);
      rect(pos.x, pos.y, size.x, size.y);
    }
  }

  void performAction() {
    if (type == "Place Tower") {
      if (!depressed) {
        gameMode = "Placing Tower";
        depressed = true;
      }
      else {
        gameMode = "Default";
        depressed = false;
      }
    }
    else if (type == "Send Wave") {
      if (gameRunning == false && grid.inter.wave == 0) {
        gameRunning = true;
        grid.inter.wave = 1;
      }
      else {
        grid.inter.wave++;
      }
      grid.inter.waveTimer = 1259;
      sendWave(grid.inter.wave);
    }
    else if (type == "Delete Tower") {
      gameMode = "Deleting Tower";
    }
    else if (type == "Rail Gun - 250") {
      if (grid.inter.money >= 250) {
        for (int i = 0; i < towers.size(); i++) {
          if (towers.get(i).selected) {
            int x = int(towers.get(i).pos.x);
            int y = int(towers.get(i).pos.y);
            towers.remove(i);
            railtowers.add(new RailTower(x, y));
            grid.inter.money -= 250;
          }
        }
      }
      else {
        messages.add(new Message(int(pos.x), int(pos.y), 120, color(255, 0, 0), 25, "Not Enough Money!"));
      }
    }
    else if (type == "Quake - 200"){
      if (grid.inter.money >= 200){
        for (int i = 0; i < towers.size(); i++) {
          if (towers.get(i).selected) {
            int x = int(towers.get(i).pos.x);
            int y = int(towers.get(i).pos.y);
            towers.remove(i);
            quaketowers.add(new QuakeTower(x, y));
            grid.inter.money -= 200;
          }
        }
      }
      else {
        messages.add(new Message(int(pos.x), int(pos.y), 120, color(255, 0, 0), 25, "Not Enough Money!"));
      }
    }
    else if (type == "Scatter - 100"){
      if (grid.inter.money >= 100){
        for (int i = 0; i < towers.size(); i++) {
          if (towers.get(i).selected) {
            int x = int(towers.get(i).pos.x);
            int y = int(towers.get(i).pos.y);
            towers.remove(i);
            scattertowers.add(new ScatterTower(x, y));
            grid.inter.money -= 100;
          }
        }
      }
      else {
        messages.add(new Message(int(pos.x), int(pos.y), 120, color(255, 0, 0), 25, "Not Enough Money!"));
      }
    }
  }
}

