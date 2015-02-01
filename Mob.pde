class Mob {
  PVector p1, p2, pos, dir;
  ArrayList <PVector> path;
  final int r, value;
  final color c;
  int progress, speed, hp;    // speed must be a factor of squareSize; progress is the number of pixels the unit has traveled towards the destination

  Mob(int x, int y) {
    dir = new PVector(1, 0);

    pos = new PVector(grid.array[x][y].pos.x, grid.array[x][y].pos.y);
    path = grid.getPath(x, y);

    p1 = path.remove(0);
    p2 = path.remove(0);
    grid.array[int(p1.x)][int(p1.y)].cannotPlace = true;
    grid.array[int(p2.x)][int(p2.y)].cannotPlace = true;

    hp = 1;
    value = 10;
    r = 8;
    c = color(255, 0, 0);
    progress = 0;
    speed = 1;
  }

  void draw() {
    fill(c);
    strokeWeight(1);
    stroke(0);
    ellipse(int(pos.x), int(pos.y), r * 2, r * 2);
  }

  void move() {
    if (progress >= squareSize) {
      goToNext();
    }
    else {
      progress += speed;
      if (p1.x < p2.x) {
        dir.x = 1;
        pos.x += speed;
      }
      else if (p1.x > p2.x) {
        dir.x = -1;
        pos.x -= speed;
      }
      else {
        dir.x = 0;
      }
      if (p1.y < p2.y) {
        dir.y = +1;
        pos.y += speed;
      }
      else if (p1.y > p2.y) {
        dir.y = -1;
        pos.y -= speed;
      }
      else {
        dir.y = 0;
      }
    }
  }

  void goToNext() {
    progress = 0;
    if (path.size()>=1) {
      grid.array[int(p1.x)][int(p1.y)].cannotPlace = false;
      p1 = p2;
      p2 = path.remove(0);
      grid.array[int(p2.x)][int(p2.y)].cannotPlace = true;

      pos.x = grid.array[int(p1.x)][int(p1.y)].pos.x;
      pos.y = grid.array[int(p1.x)][int(p1.y)].pos.y;
    }
    else if (path.size() == 0 && p2.x == grid.endX) { // assumes that all end squares have the same X coordinate
      removeMobAtPos(p2);
    }
    else {
      println("For some reason, one of the mobs has run out of path. :(");
    }
    move();
  }
  
  void clearBothSquares(){
    grid.array[int(p1.x)][int(p1.y)].cannotPlace = false;
    grid.array[int(p2.x)][int(p2.y)].cannotPlace = false;
  }
}
  
