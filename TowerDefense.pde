// Version 1.0
// Last changed 5-28

// CHANGES
// User Interface added to display UI and keep track of game information
// Credits and Instruction screens finished
// All code from Kyle's latest version added
// General code cleaniness

String screen, gameMode;  // Screens: Start Screen, Instruction, Game    Game Modes: Default, Placing Tower, Upgrading Tower, Deleting Tower
ArrayList<Tower> towers;
ArrayList<RailTower> railtowers;
ArrayList<QuakeTower> quaketowers;
ArrayList<ScatterTower> scattertowers;
ArrayList<RailMissile> railmissiles;
ArrayList<Mob> mobs;
ArrayList<Button> mainButtons, instructionButtons, creditButtons;
ArrayList<Missile> missiles;
ArrayList<Missile> scattermissiles;
ArrayList<QuakeAOE> quakeaoes;
ArrayList<Message> messages;
Grid grid;
int mobTimer, squareSize, xTrans, yTrans;
boolean gameRunning;
PImage a, b, c, d;

void setup() {
  mainButtons = new ArrayList();
  instructionButtons = new ArrayList();
  creditButtons = new ArrayList();
  messages = new ArrayList();

  final int windowX = 1400;
  final int windowY = 900;
  size(windowX, windowY); 
  a = loadImage("metalTexture2r90.jpg");
  b = loadImage("metalTexture2l90f.jpg");
  c = loadImage("metalTexture2r90f.jpg");
  d = loadImage("metalTexture2l90.jpg");
  a.resize(windowX, windowY);
  b.resize(windowX, windowY);
  c.resize(windowX, windowY);
  d.resize(windowX, windowY);

  mainButtons.add(new MenuButton(windowX/2, int(windowY *  0.6), 500, 75, " < INSTRUCTIONS > "));
  mainButtons.add(new MenuButton(windowX/2, int(windowY *  0.7), 500, 75, " < START GAME > "));
  mainButtons.add(new MenuButton(windowX/2, int(windowY *  0.8), 500, 75, " < CREDITS > "));
  instructionButtons.add(new MenuButton(windowX/2, int(windowY * 0.9), 300, 100, " < BACK > "));
  creditButtons.add(new MenuButton(windowX/2, int(windowY * 0.9), 300, 100, " < BACK > "));

  xTrans = 0;
  yTrans = 0;

  squareSize = 20;
  screen = "Start Screen";
  gameMode = "";
  smooth();
  mobTimer = 0;
  gameRunning = false;
  frameRate(60);
}

void keyPressed() {
  if (key == 't' || key == 'T') {
    if (screen == "Game") {
      for (int i = 0; i< grid.inter.buttons.size(); i++) {
        if (grid.inter.buttons.get(i).type == "Place Tower") {
          grid.inter.buttons.get(i).performAction();
        }
      }
    }
  }
  else if ((key == 'm' || key == 'M') && screen == "Game") {
    grid.inter.money = 99999;
  }
  else if (key == 'p' || key =='P') {
    if (gameRunning) {
      gameRunning = false;
    }
    else {
      gameRunning = true;
    }
  }
}

void draw() {  
  translate(xTrans, yTrans);

  int x = a.width;
  int y = a.height;
  image(b, 0, 0);
  image(a, -width, 0);
  image(c, -width, height);
  image(d, 0, height);
  image(a, width, 0);

  // draws start screen
  pushMatrix();         
  textSize(35);
  textAlign(CENTER);
  fill(102, 0, 0);
  text("BEST INTERMEDIATE COMPUTER SCIENCE", width/2, height * 0.2);
  textSize(110);
  fill(0);
  text("TOWER", width/2, height * 0.31);
  textSize(100);
  text("DEFENSE", width/2, height * 0.41);
  fill(102, 0, 0);
  textSize(45);

  for (int i = 0; i < mainButtons.size(); i++) {
    mainButtons.get(i).draw();
  }
  popMatrix();

  if (screen != "Game") {

    // draws Instructions screen
    pushMatrix();        
    translate(-width, 0);
    textSize(50);
    fill(102, 0, 0);
    text("INSTRUCTIONS", width/2, height * 0.15);
    fill(255, 0, 0);
    stroke(0);
    strokeWeight(1);

    ellipse(width/2 - 300, height * 0.3 - 12, 30, 30);  
    ellipse(width/2 - 260, height * 0.3 - 12, 30, 30);
    ellipse(width/2 - 220, height * 0.3 - 12, 30, 30);
    fill(0);
    ellipse(width/2 - 307, height * 0.3 - 18, 5, 5);
    ellipse(width/2 - 292, height * 0.3 - 18, 5, 5);
    ellipse(width/2 - 267, height * 0.3 - 18, 5, 5);
    ellipse(width/2 - 252, height * 0.3 - 18, 5, 5);
    ellipse(width/2 - 227, height * 0.3 - 18, 5, 5);
    ellipse(width/2 - 212, height * 0.3 - 18, 5, 5);

    fill(150);
    ellipse(width/2 - 280, height * 0.45 - 12, 55, 55);
    fill(50);
    rect(width/2 - 280, height * 0.45 - 17, -50, 10);
    fill(10);
    ellipse(width/2 - 280, height * 0.45 - 12, 30, 30);


    fill(0);

    textSize(30);
    text("            These fellows are the enemy.", width/2, height * 0.3);
    text("            These buildings will fire at the enemy.", width/2, height * 0.45);
    text("Click on a tower to upgrade it.", width/2, height * 0.6);
    text("Good Luck!", width/2, height * 0.74);
    textSize(22);
    text("They will enter the screen from the left. Your job is to destroy them before they reach the right of the screen.", width/2, height *0.34);
    text("In addition, these buildings (called towers) can obstruct enemies. You may place them in any unoccupied space so long", width/2, height * 0.49);
    text("as there is a path between the start and exit points. You will receive money whenever your towers kill an enemy.", width/2, height * 0.52);
    text("Towers can receive a variety of upgrades that increase their damage, range, or projectile type.", width/2, height * 0.64);

    for (int i = 0; i < instructionButtons.size(); i++) {
      instructionButtons.get(i).draw();
    }
    popMatrix();

    // draws Credits screen
    pushMatrix();
    translate(0, height);
    textSize(50);
    text("CREDITS", width/2, height * 0.1);
    textSize(27);
    text("Game Idea, Towers, and Mobs ", width * 0.3, height * 0.25);
    text("Pathfinding and Grid Design", width * 0.3, height * 0.33);
    text("Tower Upgrades and Money", width * 0.3, height * 0.41);
    text("Menus, Graphics, Buttons, and Animation", width * 0.3, height * 0.49);
    text("Help With Pathfinding", width * 0.3, height * 0.57);
    text("Invaluable Assistance", width * 0.3, height * 0.65);

    fill(0); 
    text("Kyle Ireland", width * 0.66, height * 0.25);
    text("Evan Honnold", width * 0.66, height * 0.33);
    text("K. Ireland I, Esq.", width * 0.66, height * 0.41);
    text("E. Morris Honnold", width * 0.66, height * 0.49);
    text("Sam ''A* Is Easy'' Blazes", width * 0.66, height * 0.57);
    text("Darby ''Fixed Path'' Thompson", width * 0.66, height * 0.65);

    for (int i = 0; i < creditButtons.size(); i++) {
      creditButtons.get(i).draw();
    }
    popMatrix();
  }

  if (screen == "Start Screen") {    // location: 0, 0
    goTo(0, 0, 20);
  }
  else if (screen == "Instruction") {    // location: -width , 0
    goTo(  width, 0, 20);
  }
  else if (screen == "Credits") {
    goTo(0, - height, 20);
  }
  else if (screen == "Game") {    // location: width, 0
    goTo( - width, 0, 20);

    for (int i = 0; i < missiles.size(); i++) {
      for (int j = 0; j < mobs.size(); j++) {
        if (dist(missiles.get(i).pos.x, missiles.get(i).pos.y, mobs.get(j).pos.x, mobs.get(j).pos.y)<mobs.get(j).r) {
          missiles.remove(i);
          mobs.get(j).hp --;
          if (mobs.get(j).hp <= 0) {
            mobs.get(j).clearBothSquares();
            messages.add(new Message(int(mobs.get(j).pos.x), int(mobs.get(j).pos.y), 110, color(200, 200, 0), 20, "+" + mobs.get(j).value));
            grid.inter.money += mobs.get(j).value;
            mobs.remove(j);
            break;
          }
        }
      }
    } 

    // draws Game screen
    pushMatrix();      
    translate( width, 0);
    fill(0);
    textSize(20);
    grid.draw();
    for (int i=0; i<towers.size() ; i++) {
      if (gameRunning) {
        towers.get(i).update();
      }
      towers.get(i).draw();
    }
    for (int i=0; i<towers.size() ; i++) {
      if (towers.get(i).selected) {
        strokeWeight(0);
        fill(65, 105, 225, 150);
        ellipse(towers.get(i).pos.x, towers.get(i).pos.y, towers.get(i).range*2, towers.get(i).range*2);
      }
    }
    for (int i=0; i<railtowers.size() ; i++) {
      if (gameRunning) {
        railtowers.get(i).update();
      }
      railtowers.get(i).draw();
    }
    for (int i = 0; i<railmissiles.size(); i++) {
      railmissiles.get(i).draw();
    }
    for (int i=0; i<quaketowers.size() ; i++) {
      if (gameRunning) {
        quaketowers.get(i).update();
      }
      quaketowers.get(i).draw();
    }
    for (int i=0; i<quakeaoes.size() ; i++) {
      quakeaoes.get(i).draw();
    }
    for (int i=0; i<scattertowers.size() ; i++) {
      if (gameRunning) {
        scattertowers.get(i).update();
      }
      scattertowers.get(i).draw();
    }
    for (int i = 0; i<scattermissiles.size(); i++) {
      scattermissiles.get(i).move();
      scattermissiles.get(i).draw();
    }
    for (int i = 0; i < railmissiles.size(); i++) {
      for (int j = 0; j < mobs.size(); j++) {
        float rx=railmissiles.get(i).pos.x;
        float ry=railmissiles.get(i).pos.y;
        float rex=railmissiles.get(i).endpos.x;
        float rey=railmissiles.get(i).endpos.y;
        float mx=mobs.get(j).pos.x;
        float my=mobs.get(j).pos.y;
        float mdist=dist(rx, ry, rex, rey);
        float adist=dist(rx, ry, mx, my);
        if (mdist>adist && abs((my-ry) / (mx-rx)) > (abs((rey-ry) / (rex-rx))*.95) && abs((my-ry) / (mx-rx)) < (abs((rey-ry) / (rex-rx))*1.05) && (rx-mx)*(rx-rex)>0 && (ry-my)*(ry-rey)>0) {
          mobs.get(j).hp-= 50;
        }
      }
      if (frameCount%10==0) {    
        railmissiles.remove(i);
      }
    }
    for (int i = 0; i < quakeaoes.size(); i++) {
      for (int j = 0; j < mobs.size(); j++) {
        float qx=quakeaoes.get(i).pos.x;
        float qy=quakeaoes.get(i).pos.y;
        float mx=mobs.get(j).pos.x;
        float my=mobs.get(j).pos.y;
        if (dist(qx-30, qy-30, qx+30, qy+30)>dist(qx-30, qy-30, mx, my)) {
          mobs.get(j).hp-=70;
        }
      }
      if (frameCount%15==0) {    
        quakeaoes.remove(i);
      }
    }
    for (int i = 0; i<missiles.size(); i++) {
      if (gameRunning) {
        missiles.get(i).move();
      }
      missiles.get(i).draw();
      if (missiles.get(i).fade<=0) {
        missiles.remove(i);
        break;
      }
    }
    fill(200, 200, 200);
    for (int i = 0; i<mobs.size(); i++) {
      if (gameRunning) {
        mobs.get(i).move();
      }
      mobs.get(i).draw();
      if (mobs.get(i).hp <= 0) {
        mobs.get(i).clearBothSquares();
        messages.add(new Message(int(mobs.get(i).pos.x), int(mobs.get(i).pos.y), 110, color(200, 200, 0), 20, "+" + mobs.get(i).value));
        grid.inter.money += mobs.get(i).value;
        mobs.remove(i);
      }
    }
    for (int i = 0; i < messages.size(); i++) {
      messages.get(i).draw();
      messages.get(i).update();
    }
    grid.inter.update();
    grid.inter.draw();
    popMatrix();
  }
}

void mousePressed() {
  if (screen=="Start Screen") {
    //   changeScreen("Instruction");
    for (int i = 0; i < mainButtons.size(); i++) {
      if (mainButtons.get(i).mouseOverButton(mouseX, mouseY)) {
        mainButtons.get(i).performAction();
      }
    }
  }
  else if (screen=="Instruction") {
    //   changeScreen("Game");
    for (int i = 0; i < instructionButtons.size(); i++) {
      if (instructionButtons.get(i).mouseOverButton(mouseX, mouseY)) {
        instructionButtons.get(i).performAction();
      }
    }
  }
  else if (screen == "Credits") {
    for (int i = 0; i < creditButtons.size(); i++) {
      if (creditButtons.get(i).mouseOverButton(mouseX, mouseY)) {
        creditButtons.get(i).performAction();
      }
    }
  }
  else if (screen=="Game") {
    if (gameMode == "Default") {
      if (onTower()) {
        selectTower();
        gameMode = "Upgrading Tower";
      }
    }
    else if (gameMode == "Placing Tower") {
      grid.tryTower();
    }
    else if (gameMode == "Upgrading Tower") {
      if (onTower()) {
        deselectAllTowers();
        selectTower();
      }
      else {
        grid.inter.action(mouseX, mouseY);
        gameMode = "Default";
        deselectAllTowers();
      }
    }
    else if (gameMode == "Deleting Tower") {
      if (onTower()) {
        for (int i = 0; i < towers.size(); i++) {
          if (dist(mouseX, mouseY, towers.get(i).pos.x, towers.get(i).pos.y)<towers.get(i).radius) {
            grid.clearSquares(int(towers.get(i).pos.x), int(towers.get(i).pos.y), towers.get(i).radius);
            towers.remove(i);
          }
        }
      }
      gameMode = "Default";
    }
    grid.inter.action(mouseX, mouseY);
  }
}


void changeScreen(String screenName) {
  screen = screenName;
  if (screen == "Game") {
    grid = new Grid(-20, 0, width + 20, height - 130, squareSize);
    towers = new ArrayList();
    railtowers = new ArrayList();
    missiles = new ArrayList();
    mobs=new ArrayList();
    towers = new ArrayList();
    quaketowers = new ArrayList();
    scattermissiles = new ArrayList();
    scattertowers = new ArrayList();
    quakeaoes = new ArrayList();
    railmissiles = new ArrayList();
    gameMode = "Default";
    mobTimer = 0;
    gameRunning = false;
  }
  else {
    gameRunning = false;
    gameMode = "Game Is Not Running";
  }
}


boolean onTower() {
  for (int i=0; i<towers.size(); i++) {
    if (dist(mouseX, mouseY, towers.get(i).pos.x, towers.get(i).pos.y)<towers.get(i).radius) {
      return true;
    }
  }
  return false;
}

void selectTower() {
  for (int i=0; i<towers.size(); i++) {
    if (dist(mouseX, mouseY, towers.get(i).pos.x, towers.get(i).pos.y)<towers.get(i).radius) {
      towers.get(i).selected = true;
    }
  }
}

void deselectAllTowers() {
  for (int i=0; i<towers.size(); i++) {
    towers.get(i).selected = false;
  }
}

void removeMobAtPos(PVector p) {
  for (int i = 0; i< mobs.size(); i++) {
    if (mobs.get(i).p2 == p) {
      messages.add(new Message(int(mobs.get(i).pos.x - 30), int(mobs.get(i).pos.y + 15), 100, color(255, 0, 0), 20, "-1"));
      mobs.remove(i);
      grid.inter.lives--;
    }
  }
}

void goTo(int x, int y, int speed) {
  if (abs(x-xTrans)<=speed) {
    xTrans = x;
  }
  else {
    if (x > xTrans) {
      xTrans += speed;
    }
    else {
      xTrans -= speed;
    }
  }
  if (abs(y-yTrans)<=speed) {
    yTrans = y;
  }
  else {
    if (y > yTrans) {
      yTrans += speed;
    }
    else {
      yTrans -= speed;
    }
  }
}

void sendWave(int x) {  
  grid.mobsWaiting += 20;
}

