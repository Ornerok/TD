class Gridd {
  PVector size, tl, br;  
  int ss;
  ArrayList<Location>locations;

  Gridd (int topLeftX, int topLeftY, int bottomRightX, int bottomRightY, int squareSize) {
    ss = squareSize;
    locations = new ArrayList();
    size = new PVector(int((abs(topLeftX - bottomRightX)/ss)), int(abs(topLeftY-bottomRightY)/ss));
    for (int y = topLeftY; y <= bottomRightY; y+=ss) {
      for (int x = topLeftX; x <= bottomRightX; x+=ss) {
        //locations.add(new Location(x, y, ss));
      }
    }
  }

  void draw() {
    stroke(100);
    strokeWeight(5);
    rectMode(CORNERS);
    noFill();
    rect(locations.get(0).pos.x - 13, locations.get(0).pos.y -13, locations.get(locations.size()-1).pos.x + ss/2 + 3, locations.get(locations.size()-1).pos.y + ss/2 + 3);
    if (gameMode == "Placing Tower") {
      selectNearest(mouseX, mouseY);
      for (int i = 0; i<locations.size(); i++) {
        locations.get(i).draw();
      }
    }
  }


  void selectNearest(int x, int y) {
    for (int i = 0; i < locations.size(); i++) {
      locations.get(i).selected = false;
    }
    int tempPosition = -1;    /// position in the list of locations of the nearest point
    int tempDist = 99999;  /// distance between the last nearest point and the mouse
    for (int i = 0; i< locations.size(); i++) {
      if (abs(locations.get(i).pos.y - y) < 21) {
        int newDist = int(dist(x, y, locations.get(i).pos.x + ss / 2, locations.get(i).pos.y + ss/2));
        if (tempDist > newDist) {
          tempDist = newDist;
          tempPosition = i;
        }
      }
    }
    if (tempPosition != -1) {
      if (locations.get(tempPosition).pos.x < locations.get(tempPosition + 1).pos.x) {
        if (tempPosition < locations.size() - 1 - size.x) {
          locations.get(tempPosition).selected = true;
          locations.get(tempPosition + 1).selected = true;
          locations.get(tempPosition + int(size.x) + 1).selected = true;
          locations.get(tempPosition + int(size.x) + 2).selected = true;
        }
      }
    }
  }
  void fillSelected() {
    for (int i = 0; i< locations.size(); i++) {
      if (locations.get(i).selected) {
        locations.get(i).occupied = true;
      }
    }
  }
}

