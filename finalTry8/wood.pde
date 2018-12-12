class wood extends Particle {
  wood(PVector start, float maxspeed) {
    super(start, maxspeed);
  }
  void show() {
    stroke(127, 255, 150,4);
    strokeWeight(1);
    line(pos.x, pos.y, previousPos.x, previousPos.y);
    //point(pos.x, pos.y);
    updatePreviousPos();
  }
  void follow(FlowWood flow) {
    // What is the vector at that spot in the flow field?
    PVector desired = flow.lookup(pos);
    // Scale it up by maxspeed
    desired.mult(maxSpeed);
    // Steering is desired minus velocity
    PVector steer = PVector.sub(desired, vel);
    steer.limit(1);  // Limit to maximum steering force
    applyForce(steer);
  }
}
