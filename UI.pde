class UI {
  int h, lives, money, wave, waveTimer;
  ArrayList <Button> buttons, upgrades;
  boolean towerSelected;
  String selectedType;

  UI() {
    h = 100;  
    lives = 10;
    money = 200;
    wave = 0;
    waveTimer = 59;
    towerSelected = false;
    selectedType = "Null";
    buttons = new ArrayList();
    upgrades = new ArrayList();
    buttons.add(new Button(330, height - h + 68, 180, 38, "Send Wave"));
    buttons.add(new Button(width - 130, height - h + 68, 180, 38, "Delete Tower"));
    buttons.add(new Button(width - 130, height - h + 26, 180, 38, "Place Tower"));
    upgrades.add(new Button(675, height - h + 60, 180, 38, "Rail Gun - 250"));
    upgrades.add(new Button(860, height - h + 60, 160, 38, "Quake - 200"));
    upgrades.add(new Button(1035, height - h + 60, 160, 38, "Scatter - 100"));
  }
  void draw() {
    noStroke();
    fill(0, 0, 50, 100);
    rectMode(CORNER);
    rect(0, height - h, width, h);
    fill(0, 150);
    rect(0, height - h - 15, width, 15);

    textAlign(LEFT);
    fill(255);
    textSize(25);
    text("Lives:", 20, height - h + 25);
    text("Money:", 20, height - h + 55);
    text("Wave:", 20, height - h  + 85);
    if (gameRunning == false) {
      text("Game Paused", 250, height - h + 31);
    }
    else {
      text("Next Wave In: ", 220, height -h + 31);
    }
    textSize(28);
    fill(0, 150, 0);
    text(lives, 140, height - h + 26);
    fill(150, 150, 0);
    text(money, 140, height - h + 56);
    fill(0);
    text(wave, 140, height - h + 86);
    fill(200, 0, 0);
    if (wave > 0 && gameRunning) { 
      text(int(waveTimer/60), 405, height - h + 32);
    }
    for (int i = 0; i < buttons.size(); i++) {
      buttons.get(i).draw();
    }
    if (towerSelected) {
      fill(0);
      textSize(25);
      text("Currently Selected: ", 575, height - h + 31);
      fill(255);
      text(selectedType, 810, height - h + 31);
      if (selectedType == "Basic Tower") {
        fill(0);
        text("Upgrades: ", 523, height - h + 70);
        for (int i = 0; i < upgrades.size(); i++) {
          upgrades.get(i).draw();
        }
      }
    }
  }

  void update() {
    if (gameRunning) {
      waveTimer--;
    }
    if (waveTimer < 2) {
      waveTimer = 1200;
      wave++;
      sendWave(wave);
    }
    if (lives < 1) {
      gameRunning = false;
      textSize(69);
      fill(255, 0, 0);
      text("YOU LOSE!", width/2, height/2 - 50);
    }
    towerSelected = false;
    selectedType = "Null";
    for (int i = 0; i < towers.size(); i++) {
      if (towers.get(i).selected) {
        towerSelected = true;
        selectedType = towers.get(i).type;
      }
    }
  }

  void action(int x, int y) {
    for (int i = 0; i < buttons.size(); i++) {
      if (buttons.get(i).mouseOverButton(x, y)) {
        buttons.get(i).performAction();
      }
    }
    if (selectedType == "Basic Tower"){
      for (int j = 0; j < upgrades.size(); j++){
        if (upgrades.get(j).mouseOverButton(x, y)) {
          upgrades.get(j).performAction();
        }
      }
    }
  }
}

