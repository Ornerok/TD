class Location {
  final PVector pos, l;
  boolean occupied, selected, cannotPlace;
  final int size;
  final String type;
  String parentCoordinates;
  int g;

  Location(int x, int y, int xOffset, int yOffset, int s, boolean filled, String t) {
    l = new PVector(x, y);
    pos = new PVector(xOffset + x * s, yOffset + y * s);
    occupied = filled;
    selected = false;
    size = s;
    type = t;
    g = 0;
    cannotPlace = false;
  }

  void draw() {
    rectMode(CENTER);
    stroke(100, 100);
    strokeWeight(1);
    if (selected) {
      if (occupied || cannotPlace) {
        fill(255, 0, 0, 150);
      }
      else {
        fill(0, 255, 0, 150);
      }
    }
    else {
      if (occupied) {
        fill(100, 150);
      }
      else {
        noFill();
      }
    }     
    if (type.equals("End")) {
      fill(255, 0, 0);
    }
    rect(pos.x, pos.y, size, size);
  }

  void drawClosed() {
    ellipse(pos.x, pos.y, 10, 10);
  }
}

