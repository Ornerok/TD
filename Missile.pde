class Missile {
  PVector pos;
  int s;      // speed 
  color c;
  float r;  // rotation (radians, 0 is facing right)
  int fade;    // determines when missiles fade out
  float xMoveDist, yMoveDist;

  Missile(int xPos, int yPos, int speed, int rotation) {      // creates a missile that fires in the desired direction at the desired speed
    pos = new PVector(xPos, yPos);                            // This constructor is not used and is not fully functional
    s = speed;
    c = color(0);
    r = rotation;
    fade = 100;
  }

  Missile(int xPos, int yPos, int speed, int targetX, int targetY) {    // creates a missile that fires at the desired point at the desired speed
    pos = new PVector(xPos, yPos);
    s = speed;
    c = color(0);
    
    int x = targetX - xPos;
    int y = yPos - targetY;
    
    if (x > 0 && y > 0){
      r = atan((float)abs(y)/abs(x));
    }
    else if (x<0 && y>0){
      r = PI - atan((float)abs(y)/abs(x));
    }
    else if (x<0 && y<0){
      r = PI + atan((float)abs(y)/abs(x));;
    }
    else if (x>0 && y<0){
      r = TWO_PI - atan((float)abs(y)/abs(x));
    }
    
    fade = 100;
    xMoveDist = 1.0 * s * cos(r);
    yMoveDist = -1.0 * s * sin(r);
  }

  void draw() {
    
    strokeWeight(1);
    stroke(0);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-r);
    fill(c);
    if (fade < 25){
      fill(c, fade * 10);
      stroke(0, fade * 10);
    }
    ellipse(0, 0, 8, 4);
    popMatrix();
    
    /*
    strokeWeight(1);
    stroke(0);
    fill(c);
    if (fade < 25){
      fill(c, fade * 10);
      stroke(0, fade * 10);
    }
    ellipse(pos.x, pos.y, 4, 4);
    */
  }
  
  void move(){
    pos.x += xMoveDist;
    pos.y += yMoveDist;
    fade = fade - 1;
  }
}

/*
class Missile {
 PVector pos;       
 float spd;
 color c;
 
 Missile(float xpos, float ypos, float missilespeed){//, float r, float g, float b) {
 pos = new PVector(xpos,ypos);
 spd = missilespeed;
 //  c= color(r,g,b);
 
 }
 void draw(){
 //We can differentiate missiles by rgb. We can use size as well, but I didn't include that
 stroke(255);
 // fill(x,y,z);
 fill(0);
 rect(pos.x,pos.y,5,10);
 }
 void move(float distx, float disty){
 
 
 pos.x=pos.x+distx*5;
 pos.y=pos.y+disty*5;
 }
 }    
 */

