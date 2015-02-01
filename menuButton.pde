class MenuButton extends Button {
  String name;
  
  MenuButton(int x, int y, int xs, int xy, String n){
    name = n;
    pos = new PVector(x, y);
    size = new PVector(xs, xy);    
  }
  
  void draw(){
    textSize(45);
    fill(102, 0, 0);
    textAlign(CENTER);
    text(name, pos.x, pos.y);    
  }
  
  void performAction(){
    if (name == " < INSTRUCTIONS > "){
      changeScreen("Instruction");
    }
    else if (name == " < START GAME > "){
      changeScreen("Game");
    }
    else if (name == " < CREDITS > "){
      changeScreen("Credits");
    }
    else if (name == " < BACK > " ){
      changeScreen("Start Screen");
    }
    else {
      println("Problem with PerformAction");
    }
    
  }
  
  
  
}
