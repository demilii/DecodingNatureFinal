// Daniel Shiffman
// http://youtube.com/thecodingtrain
// http://codingtra.in
//
// Coding Challenge #24: Perlin Noise Flow  Field
// https://youtu.be/BjoM9oKOAKY
public class FlowField {
  PVector[] vectors;
  int cols, rows;
  float inc;
  float zoff = 0;
  int scl;
  float cons;
  FlowField(int res,float _inc, float constant) {
    scl = res;
    cols = floor(width / res) + 1;
    rows = floor(height / res) + 1;
    vectors = new PVector[cols * rows];
    inc = _inc;
    cons = constant;
  }
  
  
  void init() {
    float xoff = 0;
    for (int y = 0; y < rows; y++) { 
      float yoff = 0;
      for (int x = 0; x < cols; x++) {
        float angle = noise(xoff, yoff, zoff)* TWO_PI*cons;
        PVector v = PVector.fromAngle(angle);
        v.setMag(1);
        int index = x + y * cols;
        vectors[index] = v;
       
        xoff += inc;
      }
      yoff += inc;
    }
    zoff +=inc/5;
  }
  void update() {
    //float constant = constrain(cons,1.,30.);
    float constant = cons;
    float xoff = 0;
    for (int y = 0; y < rows; y++) { 
      float yoff = 0;
      for (int x = 0; x < cols; x++) {
        float angle = noise(xoff, yoff, zoff)* TWO_PI*constant;
        
        PVector v = PVector.fromAngle(angle);
        v.setMag(1);
        int index = x + y * cols;
        vectors[index] = v;
       
        xoff += inc;
      }
      yoff += inc;
    }
    zoff +=inc/5;
  }
  void display() {
    for (int y = 0; y < rows; y++) { 
      for (int x = 0; x < cols; x++) {
        int index = x + y * cols;
        PVector v = vectors[index];
        
        stroke(0, 0, 0, 100);
        strokeWeight(0.1);
        pushMatrix();
        translate(x * scl, y * scl);
        rotate(v.heading());
        line(0, 0, scl, 0);
        popMatrix();
      }
    }
  }
}
