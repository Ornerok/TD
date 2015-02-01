class ScatterTower extends Tower{
  ScatterTower(float xpos, float ypos) {
    super(xpos, ypos);
    reloadTime=150;
    range=250;
    type = "Scatter Tower";
  }
}

