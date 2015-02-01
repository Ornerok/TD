class Grid {
  final int ss, columns, rows;
  final Location[][] array;
  // PVector sc, ec;    // start coordinates, end coordinates
  final PVector[] linePoints, startLocations;
  final ArrayList <PVector> endLocations;
  int endX, mobsWaiting;
  UI inter;

  HashMap <String, Location> closedList;

  Grid (int topLeftX, int topLeftY, int bottomRightX, int bottomRightY, int squareSize) {
    ss = squareSize;
    rows = int(abs(topLeftY-bottomRightY)/ss);
    columns = int((abs(topLeftX - bottomRightX)/ss));
    array = new Location[columns][rows];
    endLocations = new ArrayList();
    inter = new UI();
    mobsWaiting = 0;

    // sets the walls around the game space and the end coordinates

    for (int x = 0; x < columns; x++) {
      for (int y = 0; y < rows; y++) {
        if (!(((x == 2 || x == columns - 3)&&(y>1 && y<rows -1)) || ((y == 1 || y == rows - 1)&&(x>=2 && x<=columns-3)))) {
          array[x][y] = new Location(x, y, int(topLeftX + 0.5 * ss), int(topLeftY + 0.5 * ss), ss, false, "Normal");
          if ((y == int(rows/2.0) - 2 || y == int(rows/2.0) + 2) && (x<2 || x>columns-3)) {
            array[x][y] = new Location(x, y, int(topLeftX + 0.5 * ss), int(topLeftY + 0.5 * ss), ss, true, "Wall");
          }
          if (x == columns - 1 && (y > int(rows/2.0) - 2 && y < int(rows/2.0) + 2)) {
            array[x][y] = new Location(x, y, int(topLeftX + 0.5 * ss), int(topLeftY + 0.5 * ss), ss, false, "End");
            endLocations.add(new PVector(x, y));
            endX = x;
          }
        }   
        else if (y > int(rows/2.0) - 2 && y < int(rows/2.0) + 2) {
          array[x][y] = new Location(x, y, int(topLeftX + 0.5 * ss), int(topLeftY + 0.5 * ss), ss, false, "Normal");
        }
        else {
          array[x][y] = new Location(x, y, int(topLeftX + 0.5 * ss), int(topLeftY + 0.5 * ss), ss, true, "Wall");
        }
      }
    }   

    // sets the line around the game space
    linePoints = new PVector[13];
    linePoints[0] = array[2][int(rows/2.0) - 2].pos;
    linePoints[1] = array[0][int(rows/2.0) - 2].pos;
    linePoints[2] = array[0][int(rows/2.0) + 2].pos;
    linePoints[3] = array[2][int(rows/2.0) + 2].pos;
    linePoints[4] = array[2][rows -1].pos;
    linePoints[5] = array[columns-3][rows - 1].pos;
    linePoints[6] = array[columns-3][int(rows/2.0) +2].pos;
    linePoints[7] = array[columns-1][int(rows/2.0) +2].pos;
    linePoints[8] = array[columns-1][int(rows/2.0) -2].pos;
    linePoints[9] = array[columns-3][int(rows/2.0) -2].pos;
    linePoints[10] = array[columns-3][1].pos;
    linePoints[11] = array[2][1].pos;
    linePoints[12] = array[2][int(rows/2.0) - 2].pos;

    // sets the creep spawn points
    startLocations = new PVector[3];
    for (int i = 0; i<3; i++) {
      startLocations[i] = array[0][int(rows/2.0) - 1 + i].l;
    }

    // creates the closed list
    closedList = new HashMap();
    generateClosedList();
  }

  void draw() {
    stroke(0);
    strokeWeight(5);
    for (int i = 0; i<linePoints.length - 1; i++) {
      line(linePoints[i].x, linePoints[i].y, linePoints[i+1].x, linePoints[i+1].y);
    }

    rectMode(CENTER);
    stroke(100, 100);
    strokeWeight(1);
    if (gameMode == "Placing Tower") {
      for (int x = 0; x < columns; x++) {
        for (int y = 0; y < rows; y++) {
          array[x][y].draw();
        }
      }
      selectNearest(mouseX, mouseY);
    }


    if (gameRunning == false && inter.wave == 0) {
      textAlign(CENTER);
      textSize(30);
      fill(255);
      text("Press T to begin placing towers, then click Start Game to begin", width/2, height/2 - 50);
    }

    // Spawns the mobs

    if (gameRunning && mobsWaiting > 0 && frameCount % 10 == 0) {
      spawnMob();
    }
  }

  void selectNearest(int mx, int my) {
    for (int x = 0; x < columns; x++) {
      for (int y = 0; y < rows; y++) {
        array[x][y].selected = false;
      }
    }
    mx -= array[0][0].pos.x;
    my -= array[0][0].pos.y;
    int tx = int((float)mx/ss);
    int ty = int((float)my/ss);
    if (mx > 0 && my > 0) {
      if (tx + 1 < columns && ty + 1 < rows) {
        array[tx][ty].selected = true;
        array[tx + 1][ty].selected = true;
        array[tx][ty + 1].selected = true;
        array[tx + 1][ty + 1].selected = true;
      }
    }
  }

  void fillSelected() {
    for (int x = 0; x < columns; x++) {
      for (int y = 0; y < rows; y++) {
        if (array[x][y].selected) {
          array[x][y].occupied = true;
        }
      }
    }
  }

  PVector findTowerLocation() {
    PVector temp;
    for (int x = 0; x < columns; x++) {
      for (int y = 0; y < rows; y++) {
        if (array[x][y].selected) {
          temp = new PVector(array[x][y].pos.x + 10, array[x][y].pos.y + 10);
          return temp;
        }
      }
    }
    println("Find Tower Location in Grid tab is not working!");
    PVector temp1 = new PVector(-999, -999);
    return temp1;
  }

  boolean hasEnoughSpace() {
    for (int x = 0; x < columns; x++) {
      for (int y = 0; y <rows; y++) {
        if (array[x][y].selected && (array[x][y].occupied || array[x][y].cannotPlace)) {
          println("There's not enough space!");
          return false;
        }
      }
    }
    return true;
  }

  void spawnMob() {
    int index = int(random(startLocations.length));
    mobs.add(new Mob(int(startLocations[index].x), int(startLocations[index].y)));
    mobsWaiting--;
  }

  void generateClosedList() {
    HashMap <String, Location> closed = new HashMap();
    HashMap <String, Location> open = new HashMap();

    PVector end = endLocations.get(int(endLocations.size()/2.0));
    String startCoordinates = int(end.x) + ", " + int(end.y);
    Location temp = array[int(end.x)][int(end.y)];
    temp.parentCoordinates = "Destination";
    open.put(startCoordinates, temp);

    boolean done = false;

    while (done == false) {
      int tgMin = 99999;
      String tgLocation = "null";
      for (String i : open.keySet()) {
        if (tgMin > open.get(i).g) {
          tgMin = open.get(i).g;
          tgLocation = i;
        }
      }

      if (tgLocation == "null") {
        done = true;
      }
      else {
        closed.put(tgLocation, open.get(tgLocation));
        open.remove(tgLocation);

        int tx = int(closed.get(tgLocation).l.x);
        int ty = int(closed.get(tgLocation).l.y);

        for (int x = tx - 1; x <= tx + 1; x++) {
          for (int y = ty - 1; y <= ty + 1; y++) {
            if ( (!(x == tx && y == ty)) && (x>=0 && y>=0) && (x<columns && y < rows) ) {

              String ts = x + ", " + y;

              if (array[x][y].occupied == false && !closed.containsKey(ts)) {
                String tpc = tx + ", " + ty;
                int tg = closed.get(tgLocation).g + calculateG(tx, ty, x, y);

                if (!open.containsKey(ts)) {
                  Location tc = array[x][y];
                  tc.parentCoordinates = tpc;
                  tc.g = tg;
                  open.put(ts, tc);
                }
                else {
                  if (open.get(ts).g>tg) {
                    open.get(ts).parentCoordinates = tpc;
                    open.get(ts).g = tg;
                  }
                }
              }
            }
          }
        }
      }
    }


    closedList = closed;
  }

  ArrayList <PVector> getPath(int x, int y) {
    ArrayList <PVector> temp = new ArrayList();
    String startLocation = x + ", " + y;

    if (!closedList.containsKey(startLocation)) {
      println("The GetPath function in the Grid tab has been asked to find a path from a location that is not on the closed list");
    }
    else {
      boolean done = false;
      String a = startLocation;
      while (done == false) {
        temp.add(closedList.get(a).l);
        a = closedList.get(a).parentCoordinates;   
        if (a == "Destination") {
          done = true;
        }
      }
    }   
    return temp;
  }

  int calculateG(int startX, int startY, int endX, int endY) {
    if (abs(startX - endX) == 1) {
      if (abs(startY - endY) == 1) {
        return 14;
      }
      else if (abs(startY - endY) == 0) {
        return 10;
      }
    }
    else if (abs(startX - endX) == 0) {
      if (abs(startY - endY) == 1) {
        return 10;
      }
    }
    println("CalculateG is not being used correctly");
    return 666;
  }

  void drawClosed() {
    for (String i : closedList.keySet()) {
      closedList.get(i).drawClosed();
    }
  }

  void recalculateAllPaths() {
    generateClosedList();
    for (int i = 0; i < mobs.size(); i++) {
      mobs.get(i).path = getPath(int(mobs.get(i).p2.x), int(mobs.get(i).p2.y));
    }
  }

  boolean blocksPath() {
    boolean r = true;
    ArrayList <PVector> p = new ArrayList();
    for (int x = 0; x < columns; x++) {
      for (int y = 0; y <rows; y++) {
        if (array[x][y].selected == true && array[x][y].occupied == false) {
          array[x][y].occupied = true;
          p.add(new PVector(x, y));
        }
      }
    }
    generateClosedList();
    if (closedList.containsKey(int(startLocations[1].x) + ", " + int(startLocations[1].y))) {
      r = false;
    }
    for (int i = 0; i < p.size(); i++) {
      array[int(p.get(i).x)][int(p.get(i).y)].occupied = false;
    }
    if (r) {
      println("You can't place a tower there because it would block the path.");
    }
    return r;
  }

  void tryTower() {
    PVector t = findTowerLocation(); 
    if (inter.money >= 50) {
      if (t.x>0) {
        if (!blocksPath()) {
          if (hasEnoughSpace()) { 
            towers.add(new Tower(t.x, t.y));
            fillSelected();
            recalculateAllPaths();
            inter.money -= 50;
            for (int i = 0; i< inter.buttons.size(); i++) {
              if (inter.buttons.get(i).type == "Place Tower") {
                inter.buttons.get(i).performAction();
              }
            }
          }
        }
      }
    }
    else {
      messages.add(new Message(width/2, height/2, 120, color(255, 0, 0), 40, "You Are Too Poor To Build Another Tower!"));
    }
  }

  void clearSquares(int targetX, int targetY, int distance) {
    for (int x = 0; x < columns; x++) {
      for (int y = 0; y < rows; y++) {
        if (dist(array[x][y].pos.x, array[x][y].pos.y, targetX, targetY) < distance){
          array[x][y].occupied = false;
        }
      }
    }
  }
}

