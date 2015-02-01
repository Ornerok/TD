class Message{
  PVector pos;
  int life;
  final int size;
  final String text;
  color c;
  
  Message(int x, int y, int duration, color messageColor, int messageSize, String textToDisplay){
    pos = new PVector(x, y);
    life = duration;
    size = messageSize;
    text = textToDisplay;
    c = messageColor;
  }
  
  void update(){
    life--;
    pos.y--;
    if (life <= 0){
      messages.remove(this);
    }
  }
  
  void draw(){
    fill(c, 2 * life);
    textSize(size);
    text(text, pos.x, pos.y);
  }  
}
