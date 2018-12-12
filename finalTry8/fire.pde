class fire extends Particle {
  fire(PVector start, float maxspeed) {
    super(start, maxspeed);
  }
  void show() {
    stroke(200, 51, 48, 10);
    strokeWeight(1);
    line(pos.x, pos.y, previousPos.x, previousPos.y);
    //point(pos.x, pos.y);
    updatePreviousPos();
  }
}
