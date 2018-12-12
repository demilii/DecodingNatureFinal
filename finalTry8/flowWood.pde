// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Flow Field Following

class FlowWood {

  // A flow field is a two dimensional array of PVectors
  PVector[][] field;
  int cols, rows; // Columns and Rows
  int resolution; // How large is each "cell" of the flow field
  float zoff = 0;
  float cons;
  FlowWood(int r, float constant) {
    resolution = r;
    // Determine the number of columns and rows based on sketch's width and height
    cols = width/resolution;
    rows = height/resolution;
    field = new PVector[cols][rows];
    //init();
    cons = constant;
  }

  void update() {
    float diff_l = -PI/(2*rows);
    float diff_r = PI/(2*rows);
    float xoff = 0;
    float yoff = 0;
    float angle = -PI/2;
    float angle_r = -PI/2;
    //float constant = constrain(cons,1,30);
    float constant = cons;
    for (int i = rows-1; i >= 0; i--) {
      float diff_heng = (angle_r-angle)/(cols-3);
      //float yoff = 0;
      float theta = angle;
      for (int j = 0; j < cols; j++) {


        //float theta = map(noise(xoff,yoff,zoff),0,1,0,TWO_PI);
        // Polar to cartesian coordinate transformation to get x and y components of the vector
        field[j][i] = PVector.fromAngle(theta*constant*(noise(xoff,yoff,zoff)));
        theta+= diff_heng;
        yoff += 0.1;
      }
      angle += diff_l;
      angle_r += diff_r;
    }
    zoff += 0.008;
  }

  // Draw every vector
  void display() {
    update();
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        drawVector(field[i][j], i*resolution, j*resolution, resolution-2);
      }
    }
  }

  // Renders a vector object 'v' as an arrow and a position 'x,y'
  void drawVector(PVector v, float x, float y, float scayl) {
    pushMatrix();
    float arrowsize = 4;
    // Translate to position to render vector
    translate(x, y);
    stroke(0, 100);
    // Call vector heading function to get direction (note that pointing to the right is a heading of 0) and rotate
    rotate(v.heading2D());
    // Calculate length of vector & scale it to be bigger or smaller if necessary
    float len = v.mag()*scayl;
    // Draw three lines to make an arrow (draw pointing up since we've rotate to the proper direction)
    line(0, 0, len, 0);
    //line(len,0,len-arrowsize,+arrowsize/2);
    //line(len,0,len-arrowsize,-arrowsize/2);
    popMatrix();
  }

  PVector lookup(PVector lookup) {
    int column = int(constrain(lookup.x/resolution, 0, cols-1));
    int row = int(constrain(lookup.y/resolution, 0, rows-1));
    return field[column][row].get();
  }
}
