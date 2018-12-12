class earth extends Particle {
  earth(PVector start, float maxspeed) {
    super(start, maxspeed);
  }
  void show() {
    stroke(188, 140, 88, 10);
    strokeWeight(1);
    point(pos.x, pos.y);
    //point(pos.x, pos.y);
    //updatePreviousPos();
  }
  
  // void follow(FlowEarth flow) {
  //  // What is the vector at that spot in the flow field?
  //  PVector desired = flow.lookup(pos);
  //  // Scale it up by maxspeed
  //  desired.mult(maxSpeed);
  //  // Steering is desired minus velocity
  //  PVector steer = PVector.sub(desired, vel);
  //  steer.limit(1);  // Limit to maximum steering force
  //  applyForce(steer);
  //}
}
