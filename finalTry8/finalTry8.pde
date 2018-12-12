import netP5.*;
import oscP5.*;
OscP5 oscP5;
float gr_diff = 0;
float fi_diff = 0;
float wa_diff = 0;
float wo_diff = 0;
float me_diff = 0;

float speedScale=1;

FlowField flowfield;
FlowField flowfield1;
FlowField flowfield2;
FlowWood flowfield3;
//FlowEarth flowfield2;
float angle = 0;
float q_wa = 750;
float q_fi = 750;
float q_gr = 750;
float q_me = 750;
float q_wo = 750;
float max_speed = 0.5;
ArrayList<water> wa;
ArrayList<fire> fi;
ArrayList<earth> gr;
ArrayList<metal> me;
ArrayList<wood> wo;
PVector target;
float r = 500;
float scale;
void setup() {
  scale = 1;
  fullScreen();
  background(0);

  oscP5 = new OscP5(this, 12000);
  flowfield = new FlowField(20, 0.05, 0.2);
  flowfield1 = new FlowField(20, 0.05, -0.25);
  //for earth
  flowfield2 = new FlowField(50, 0.1, 8);
  flowfield3 = new FlowWood(20, 1.);
  flowfield.update();
  flowfield1.update();
  flowfield2.update();
  flowfield3.update();
  wa = new ArrayList<water>();
  fi = new ArrayList<fire>();
  gr = new ArrayList<earth>();
  me = new ArrayList<metal>();
  wo = new ArrayList<wood>();
  for (int i = 0; i < q_wa; i++) {
    PVector start = new PVector(random(width/2), random(height/3, 2*height/3));
    wa.add(new water(start, max_speed));
  }
  for (int i = 0; i < q_fi; i++) {
    PVector start = new PVector(random(width/2, width), random(height/3, 2*height/3));
    fi.add(new fire(start, max_speed));
  }
  for (int i = 0; i < q_gr; i++) {
    PVector start = new PVector(random(width), random(height));
    gr.add(new earth(start, max_speed));
  }
  for (int i = 0; i < q_me; i++) {
    me.add(new metal(random(width), random(height)));
  }
  for (int i = 0; i < q_wo; i++) {
    PVector start = new PVector(random(width/2), random(height/2, height));
    wo.add(new wood(start, max_speed));
  }
  target = new PVector(width/2, height/2);
}
void draw() {
  scale = 1;
  flowfield.update();
  flowfield1.update();
  flowfield2.update();
  flowfield3.update();
  for (int i = wa.size()-1; i >= 0; i--) {
    water w = wa.get(i);
    w.follow(flowfield);
    w.run();
  }
  for (int i = fi.size()-1; i >= 0; i--) {
    fire f = fi.get(i);
    f.follow(flowfield1);
    f.run();
  }
  for (int i = gr.size()-1; i >= 0; i--) {
    earth e = gr.get(i);
    e.follow(flowfield2);
    e.run();
  }
  for (int i = me.size()-1; i >= 0; i--) {
    metal m = me.get(i);
    m.seek(target);
    m.update();
    m.display();
    if (m.dead(target)) {
      me.remove(i);
    }
  }

  if (me.size() < q_me) {
    float num = q_me-me.size();
    for (int i = 0; i<num; i++) {
      me.add(new metal(random(width), random(height)));
    }
  }

  for (int i = wo.size()-1; i >= 0; i--) {
    wood w = wo.get(i);
    w.follow(flowfield3);
    w.run();
  }

  chg();
  unbalance();
  gr_diff = 0;
  fi_diff = 0;
  wa_diff = 0;
  wo_diff = 0;
  me_diff = 0;
}

void unbalance() {
  flowfield.cons *= scale;
  flowfield1.cons *= scale;
  flowfield2.cons *= scale;
  flowfield3.cons *= scale;
  flowfield.inc *= scale;
  flowfield1.inc *= scale;
  flowfield2.inc *= scale;
  if (speedScale <2.5) {
    speedScale *= scale;
  }

  //flowfield3.inc *= scale;
  //println(flowfield1.cons);
}

void keyPressed() {
  angle = 0;
  q_wa = 750;
  q_fi = 750;
  q_gr = 750;
  q_me = 750;
  q_wo = 750;
  setup();
}

//void mouseMoved(){
//  speedScale=map(mouseX,0,width,1,15);
//}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/gr")) {
    int val0 = theOscMessage.get(0).intValue();
    gr_diff = val0;
  }
  if (theOscMessage.checkAddrPattern("/fi")) {
    int val1 = theOscMessage.get(0).intValue();
    fi_diff = val1;
  }

  if (theOscMessage.checkAddrPattern("/wa")) {
    int val2 = theOscMessage.get(0).intValue();
    wa_diff = val2;
  }

  if (theOscMessage.checkAddrPattern("/wo")) {
    int val3 = theOscMessage.get(0).intValue();
    wo_diff = val3;
  }

  if (theOscMessage.checkAddrPattern("/me")) {
    int val4 = theOscMessage.get(0).intValue();
    me_diff = val4;
  }
}

void chg() {
  //ground
  //ground quantity increase
  if (gr_diff > 0) {
    scale = map(gr_diff, 0, 100, 1.01, 1.2);
    q_gr += gr_diff;
    if (q_gr < 1500) {
      //increase ground quantity first
      for (int i = 0; i < gr_diff; i++) {
        PVector start = new PVector(random(width), random(height));
        gr.add(new earth(start, max_speed));
      }
      //decrease the water quantity
      q_wa -= gr_diff;
      if (q_wa > 0) {
        for (int i = wa.size()-1; i > q_wa; i--) {
          wa.remove(i);
        }
      } else {
        q_wa = 0;
        for (int i = wa.size()-1; i > 0; i--) {
          wa.remove(i);
        }
      }
    } else {
      q_gr = 1500;
      //increase ground quantity
      for (int i = gr.size()-1; i < 1500; i++) {
        PVector start = new PVector(random(width), random(height));
        gr.add(new earth(start, max_speed));
      }
      //decrease the water quantity
      q_wa -= gr_diff;
      if (q_wa > 0) {
        for (int i = wa.size()-1; i > q_wa; i--) {
          wa.remove(i);
        }
      } else {
        q_wa = 0;
        for (int i = wa.size()-1; i > 0; i--) {
          wa.remove(i);
        }
      }
    }
  } else if (gr_diff < 0) {
    //scale = map(gr_diff, -50, 0, 0.7,0.95);
    //ground quantity decrease
    q_gr += gr_diff;
    if (q_gr > 0) {
      for (int i = gr.size()-1; i > q_gr; i--) {
        gr.remove(i);
      }
    } else {
      q_gr = 0;
      for (int i = gr.size()-1; i > 0; i--) {
        gr.remove(i);
      }
    }
  } else {
  }

  //fire
  //increase of fire quantity
  if (fi_diff > 0) {
    scale = map(fi_diff, 0, 100, 1.01, 1.2);
    q_fi += fi_diff;
    if (q_fi < 1500) {
      //increase ground quantity first
      for (int i = 0; i < fi_diff; i++) {
        PVector start = new PVector(random(width), random(height));
        fi.add(new fire(start, max_speed));
      }
      //decrease the metal quantity
      q_me -= fi_diff;
      if (q_me > 0) {
        for (int i = me.size()-1; i > q_me; i--) {
          me.remove(i);
        }
      } else {
        q_me = 0;
        for (int i = me.size()-1; i > 0; i--) {
          me.remove(i);
        }
      }
    } else {
      q_fi = 1500;
      //increase ground quantity
      for (int i = fi.size()-1; i < 1500; i++) {
        PVector start = new PVector(random(width), random(height));
        fi.add(new fire(start, max_speed));
      }
      //decrease the metal quantity
      q_me -= fi_diff;
      if (q_me > 0) {
        for (int i = me.size()-1; i > q_me; i--) {
          me.remove(i);
        }
      } else {
        q_me = 0;
        for (int i = me.size()-1; i > 0; i--) {
          me.remove(i);
        }
      }
    }
  } else if (fi_diff < 0) {
    //scale = map(fi_diff, -50, 0, 0.7,0.95);
    //ground quantity decrease
    q_fi += fi_diff;
    if (q_fi > 0) {
      for (int i = fi.size()-1; i > q_fi; i--) {
        fi.remove(i);
      }
    } else {
      q_fi = 0;
      for (int i = fi.size()-1; i > 0; i--) {
        fi.remove(i);
      }
    }
  } else {
  }

  //metal
  //increase of metal quantity
  if (me_diff > 0) {
    scale = map(me_diff, 0, 100, 1.01, 1.2);
    q_me += me_diff;
    if (q_me < 1500) {
      //increase metal quantity first
      for (int i = 0; i < me_diff; i++) {
        me.add(new metal(random(width), random(height)));
      }
      //decrease the wood quantity
      q_wo -= me_diff;
      if (q_wo > 0) {
        for (int i = wo.size()-1; i > q_wo; i--) {
          wo.remove(i);
        }
      } else {
        q_wo = 0;
        for (int i = wo.size()-1; i > 0; i--) {
          wo.remove(i);
        }
      }
    } else {
      q_me = 1500;
      //increase metal quantity

      for (int i = me.size()-1; i < 1500; i++) {
        me.add(new metal(random(width), random(height)));
      }
      //decrease the wood quantity
      q_wo -= me_diff;
      if (q_wo > 0) {
        for (int i = wo.size()-1; i > q_wo; i--) {
          wo.remove(i);
        }
      } else {
        q_wo = 0;
        for (int i = wo.size()-1; i > 0; i--) {
          wo.remove(i);
        }
      }
    }
  } else if (me_diff < 0) {
    //scale = map(me_diff, -50, 0, 0.7,0.95);
    //metal quantity decrease
    q_me += me_diff;
    if (q_me > 0) {
      for (int i = me.size()-1; i > q_me; i--) {
        me.remove(i);
      }
    } else {
      q_me = 0;
      for (int i = me.size()-1; i > 0; i--) {
        me.remove(i);
      }
    }
  } else {
  }


  //wood
  //increase of metal quantity
  if (wo_diff > 0) {
    scale = map(wo_diff, 0, 100, 1.01, 1.2);
    q_wo += wo_diff;
    if (q_wo < 1500) {
      //increase wood quantity first
      for (int i = 0; i < wo_diff; i++) {
        PVector start = new PVector(random(width), random(height));
        wo.add(new wood(start, max_speed));
      }
      //decrease the ground quantity
      q_gr -= wo_diff;
      if (q_gr > 0) {
        for (int i = gr.size()-1; i > q_gr; i--) {
          gr.remove(i);
        }
      } else {
        q_gr = 0;
        for (int i = gr.size()-1; i > 0; i--) {
          gr.remove(i);
        }
      }
    } else {
      q_wo = 1500;
      //increase wood quantity
      for (int i = wo.size()-1; i < 1500; i++) {
        PVector start = new PVector(random(width), random(height));
        wo.add(new wood(start, max_speed));
      }
      //decrease the ground quantity
      q_gr -= wo_diff;
      if (q_gr > 0) {
        for (int i = gr.size()-1; i > q_gr; i--) {
          gr.remove(i);
        }
      } else {
        q_gr = 0;
        for (int i = gr.size()-1; i > 0; i--) {
          gr.remove(i);
        }
      }
    }
  } else if (wo_diff < 0) {
    //scale = map(wo_diff, -50, 0, 0.7,0.95);
    //wood quantity decrease
    q_wo += wo_diff;
    if (q_wo > 0) {
      for (int i = wo.size()-1; i > q_wo; i--) {
        wo.remove(i);
      }
    } else {
      q_wo = 0;
      for (int i = wo.size()-1; i > 0; i--) {
        wo.remove(i);
      }
    }
  } else {
  }

  //water
  //increase of water quantity
  if (wa_diff > 0) {
    scale = map(wa_diff, 0, 100, 1.01, 1.2);
    q_wa += wa_diff;
    if (q_wa < 1500) {
      //increase water quantity first
      for (int i = 0; i < wa_diff; i++) {
        PVector start = new PVector(random(width), random(height));
        wa.add(new water(start, max_speed));
      }
      //decrease the fire quantity
      q_fi -= wa_diff;
      if (q_fi > 0) {
        for (int i = fi.size()-1; i > q_fi; i--) {
          fi.remove(i);
        }
      } else {
        q_fi = 0;
        for (int i = fi.size()-1; i > 0; i--) {
          fi.remove(i);
        }
      }
    } else {
      q_wa = 1500;
      //increase water quantity
      for (int i = wa.size()-1; i < 1500; i++) {
        PVector start = new PVector(random(width), random(height));
        wa.add(new water(start, max_speed));
      }
      //decrease the fire quantity
      q_fi -= wa_diff;
      if (q_fi > 0) {
        for (int i = fi.size()-1; i > q_fi; i--) {
          fi.remove(i);
        }
      } else {
        q_fi = 0;
        for (int i = fi.size()-1; i > 0; i--) {
          fi.remove(i);
        }
      }
    }
  } else if (wa_diff < 0) {
    //scale = map(wa_diff, -50, 0, 0.7,0.95);
    //wood quantity decrease
    q_wa += wa_diff;
    if (q_wa > 0) {
      for (int i = wa.size()-1; i > q_wa; i--) {
        wa.remove(i);
      }
    } else {
      q_wa = 0;
      for (int i = wa.size()-1; i > 0; i--) {
        wa.remove(i);
      }
    }
  } else {
  }
}
