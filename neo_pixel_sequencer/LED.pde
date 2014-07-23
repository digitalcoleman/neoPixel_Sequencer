class LED {

  color ledColor;
  float rotation, space;
  PVector pos;
  color strokeColor;
  boolean select = false;
  int strokeW = 1;

  LED(float rot, PVector posit, float spaceTemp) {
    rotation = rot;
    pos = posit;
    ledColor = color(.5, 0, 0);
    strokeColor = 0;
    space = spaceTemp;
  }

  boolean update() {
    if (select) {
      strokeColor = color(0, 0, 1);
      strokeW = 2;
    } else {
      strokeColor = color(0, 0, .4);
      strokeW = 1;
    }
    float far = dist(mouseX, mouseY, pos.x, pos.y);
    float angle = atan2(mouseY-pos.y, mouseX-pos.x);
    if (angle<-slice) angle += TAU;
    if (mousePressed && far>space-10 && far < space+10 && angle < slice+rotation && angle> rotation-slice) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    fill(ledColor);
    strokeWeight(strokeW);
    stroke(strokeColor);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(rotation);
    rect(space, 0, 20, 20);
    popMatrix();
  }
}

