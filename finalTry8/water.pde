class water extends Particle {
  water(PVector start, float maxspeed) {
    super(start, maxspeed);
  }
  void show() {
    stroke(136, 208, 255, 7);
    strokeWeight(1);
    line(pos.x, pos.y, previousPos.x, previousPos.y);
    //point(pos.x, pos.y);
    updatePreviousPos();
  }
}
